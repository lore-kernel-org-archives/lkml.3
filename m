Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaKUS2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:28:53 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:51485 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaKUS2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:28:51 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxn_T=UgBUwqkRJvALygrNORaB6ox3nowvHpV6yFBfDoA@mail.gmail.com>
References: <alpine.DEB.2.11.1411202204030.3950@nanos> <20141120221122.GA25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411202315230.3950@nanos> <20141120230514.GB25393@htj.dyndns.org>
 <CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
 <20141120233920.GC25393@htj.dyndns.org> <CALCETrUh_6tWdTyDwZ4U1BDSnN1khbGDGBvCTO3MVcdU-X23QA@mail.gmail.com>
 <20141121162742.GB15461@htj.dyndns.org> <CALCETrUcuDh8c27cEHmoM7jo_kozJbYxV3p1H2LhmzBa16XOyQ@mail.gmail.com>
 <CA+55aFxU2q_-PVx+6fXGkXdAt3oaxvqxzy29Nrn989uTiVXvCg@mail.gmail.com>
 <20141121170805.GD30603@home.goodmis.org> <CA+55aFw+axXZhez-5x8zWFw1=6OazMbj=va8nt9GZHsrxsKewQ@mail.gmail.com>
 <CALCETrUp5kCnzFokCKVf3kn7K_d_5YP-phyNfL4rFR0tMZJi2A@mail.gmail.com> <CA+55aFxn_T=UgBUwqkRJvALygrNORaB6ox3nowvHpV6yFBfDoA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 21 Nov 2014 10:28:28 -0800
Message-ID: <CALCETrUFHFvKU3hnD8w0oVYjKx2XPxTUrXynqpsm3J7yahbqYg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
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
> On Fri, Nov 21, 2014 at 9:22 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> Both mystify me.  Why does the 32-bit version walk down the hierarchy
>> at all instead of just touching the top level?
>
> Quite frankly, I think it's just due to historical reasons, and should
> be removed.
>
> But the historical reasons are that with the aliasing of the PUD and
> PMD entries in the PGD, it's all fairly confusing. So I think we only
> used to do the top level, but then when we expanded from two levels to
> three, that "top level" became the pmd, and then when we expanded from
> three to four, the pmd was actually two levels down. So it's all
> basically mindless work.
>
> So I do think we could simplify and unify things.
>
> In 32-bit mode, we actually have two different cases:
>
>  - in PAE, there's the magic top-level 4-entry PGD that always *has*
> to be present (the P bit isn't actually checked by hardware)
>
>     As a result, in PAE mode, the top PGD entries always exist, and
> are always prepopulated, and for the kernel area (including obviously
> the vmalloc space) always points to the init_pgd[] entry.
>
>     Ergo, in PAE mode, I don't think we should ever hit this case in
> the first place.
>
>  - in non-PAE mode, we should just copy the top-level entry, and return.
>
> And in 64-bit more, we only have the "copy the top-level entry" case.
>
> So I think we should
>
>  (a) remove the 32-bit vs 64-bit difference, because that's not actually valid
>
>  (b) make it a PAE vs non-PAE difference
>
>  (c) the PAE case is a no-op
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
>
>         index = pgd_index(address);
>         pgd_entry = init_mm.pgd[index];
>         if (!pgd_present(pgd_entry))
>                 return -1;
>
>         pgd_dst = __va(PAGE_MASK & read_cr3());
>         if (pgd_present(pgd_dst[index]))
>                 return -1;
>
>         ACCESS_ONCE(pgd_dst[index]) = pgd_entry;
>         return 0;
>     }
>     NOKPROBE_SYMBOL(vmalloc_fault);
>
> and it's done.
>
> Would anybody be willing to actually *test* something like the above?
> The above may compile, but that's all the "testing" it got.
>

I'd be happy to test it (i.e. boot it and try to use my computer), but
I have nowhere near enough RAM to do it right.

Is there any easy way to get the vmalloc code to randomize enough bits
to exercise this?

--Andy
