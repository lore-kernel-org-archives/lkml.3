Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaKUTGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:06:43 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:61089 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaKUTGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:06:41 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxn_T=UgBUwqkRJvALygrNORaB6ox3nowvHpV6yFBfDoA@mail.gmail.com>
References: <alpine.DEB.2.11.1411202204030.3950@nanos>
	<20141120221122.GA25393@htj.dyndns.org>
	<alpine.DEB.2.11.1411202315230.3950@nanos>
	<20141120230514.GB25393@htj.dyndns.org>
	<CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
	<20141120233920.GC25393@htj.dyndns.org>
	<CALCETrUh_6tWdTyDwZ4U1BDSnN1khbGDGBvCTO3MVcdU-X23QA@mail.gmail.com>
	<20141121162742.GB15461@htj.dyndns.org>
	<CALCETrUcuDh8c27cEHmoM7jo_kozJbYxV3p1H2LhmzBa16XOyQ@mail.gmail.com>
	<CA+55aFxU2q_-PVx+6fXGkXdAt3oaxvqxzy29Nrn989uTiVXvCg@mail.gmail.com>
	<20141121170805.GD30603@home.goodmis.org>
	<CA+55aFw+axXZhez-5x8zWFw1=6OazMbj=va8nt9GZHsrxsKewQ@mail.gmail.com>
	<CALCETrUp5kCnzFokCKVf3kn7K_d_5YP-phyNfL4rFR0tMZJi2A@mail.gmail.com>
	<CA+55aFxn_T=UgBUwqkRJvALygrNORaB6ox3nowvHpV6yFBfDoA@mail.gmail.com>
Date: Fri, 21 Nov 2014 11:06:41 -0800
X-Google-Sender-Auth: 0Mfp-U_Sq6ne11NKE6MVkIL56_4
Message-ID: <CA+55aFyEnuByhPM3FEdi=Q0WGuJWiBgtkWNAbRLHDpmPRaqnQA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 10:22 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>  (d) the non-PAE case would look something like this:
>
>     static noinline int vmalloc_fault(unsigned long address)
>     {
>         unsigned index;
>         pgd_t *pgd_dst, pgd_entry;
>
>         /* Make sure we are in vmalloc area: */
>         if (!(address >= VMALLOC_START && address < VMALLOC_END))
>                 return -1;

Side note: I think this is just unnecessary confusion, and generates
big constants for no good reason.

The thing is, the kernel PGD's should always be in sync. In fact, at
PGD allocation time, we just do

     clone_pgd_range(.. KERNEL_PGD_BOUNDARY, KERNEL_PGD_PTRS);

and it might actually be better to structure this to be that exact same thing.

So instead of checking the address, we could just do

        index = pgd_index(address);
        if (index < KERNEL_PGD_BOUNDARY)
                return -1;

which actually matches our initialization sequence much better anyway.
And avoids those random big constants.

Also, it turns out that this:

        if (pgd_present(pgd_dst[index]))

generates a crazy big constant because of bad compiler issues (the
"pgd_present()" thing only checks the low bit, but it does so on
pgd_flags(), which does "native_pgd_val(pgd) & PTE_FLAGS_MASK", so you
have an insane extra "and" with the constant 0xffffc00000000fff, just
to then "and" it again with "1". It doesn't do that with the first
pgd_present() check, oddly enough.

WTF, gcc?

Anyway, even more importantly, because of the whole issue with nesting
page tables, it's probably best to actually avoid all the
"pgd_present()" etc helpers, because those might be hardcoded to 1
etc. So avoid the whole issue by just accessign the raw data.

Simplify, simplify, simplify. The actual code generation for this all
should be maybe 20 instructions.

Here's the simplified end result. Again, this is TOTALLY UNTESTED. I
compiled it and verified that the code generation looks like what I'd
have expected, but that's literally it.

  static noinline int vmalloc_fault(unsigned long address)
  {
        pgd_t *pgd_dst;
        pgdval_t pgd_entry;
        unsigned index = pgd_index(address);

        if (index < KERNEL_PGD_BOUNDARY)
                return -1;

        pgd_entry = init_mm.pgd[index].pgd;
        if (!pgd_entry)
                return -1;

        pgd_dst = __va(PAGE_MASK & read_cr3());
        pgd_dst += index;

        if (pgd_dst->pgd)
                return -1;

        ACCESS_ONCE(pgd_dst->pgd) = pgd_entry;
        return 0;
  }
  NOKPROBE_SYMBOL(vmalloc_fault);

Hmm? Does anybody see anything fundamentally wrong with this?

                     Linus
