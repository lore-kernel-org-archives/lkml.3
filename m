Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbaDVQET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:04:19 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:59823 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038AbaDVQEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:04:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140422144659.GF15882@pd.tnic>
References: <CAObL_7EJi5+m-oDXRy4hu+-OTZ=9wZ9WEivTMsdDtccU00wfWA@mail.gmail.com>
 <5355A9E9.9070102@zytor.com> <CAObL_7EP+zPpx9TVgsSu2iFN+r0U8yy6UEZtdk=CPwowXUu=Qw@mail.gmail.com>
 <1dbe8155-58da-45c2-9dc0-d9f4b5a6e643@email.android.com> <CAObL_7FUDpV9md+UnDbXxWw=trrXLFLNNJMNegdezrQt7rm6TA@mail.gmail.com>
 <a035392c-f332-4b3f-b851-13b0c7a0fc68@email.android.com> <CAObL_7FMX9yaGVi19pVwsU5VwHqKLLWMEB7kwDF-fatsGnHvdQ@mail.gmail.com>
 <ee12ff5e-91fe-487b-bed9-4472f15f94fe@email.android.com> <CAObL_7HTDvN2zu2_CDnVR_ztZ-b7PfLYz0csuVX-ShQ7EHGEjg@mail.gmail.com>
 <20140422112312.GB15882@pd.tnic> <20140422144659.GF15882@pd.tnic>
From: Andrew Lutomirski <amluto@gmail.com>
Date: Tue, 22 Apr 2014 09:03:55 -0700
Message-ID: <CAObL_7FGs4n6zusbdwTLi5W5q2V81Sf7pOnOmHPFyv5d7jMfvA@mail.gmail.com>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 7:46 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Apr 22, 2014 at 01:23:12PM +0200, Borislav Petkov wrote:
>> I wonder if it would be workable to use a bit in the espfix PGD to
>> denote that it has been initialized already... I hear, near NX there's
>> some room :-)
>
> Ok, I realized this won't work when I hit send... Oh well.
>
> Anyway, another dumb idea: have we considered making this lazy? I.e.,
> preallocate pages to fit the stack of NR_CPUS after smp init is done but
> not setup the percpu espfix stack. Only do that in espfix_fix_stack the
> first time we land there and haven't been setup yet on this cpu.
>
> This should cover the 1% out there who still use 16-bit segments and the
> rest simply doesn't use it and get to save themselves the PT-walk in
> start_secondary().
>
> Hmmm...

I'm going to try to do the math to see what's actually going on.

Each 4G slice contains 64kB of ministacks, which corresponds to 1024
ministacks.  Virtual addresses are divided up as:

12 bits (0..11): address within page.
9 bits (12..20): identifies the PTE within the level 1 directory
9 bits (21..29): identifies the level 1 directory (pmd?) within the
level 2 directory
9 bits (30..38): identifies the level 2 directory (pud) within the
level 3 directory

Critically, each 1024 CPUs can share the same level 1 directory --
there are just a bunch of copies of the same thing in there.
Similarly, they can share the same level 2 directory, and each slot in
that directory will point to the same level 1 directory.

For the level 3 directory, there is only one globally.  It needs 8
entries per 1024 CPUs.

I imagine there's a scalability problem here, too: it's okay if each
of a very large number of CPUs waits while shared structures are
allocated, but owners of big systems won't like it if they all
serialize on the way out.

So maybe it would make sense to refactor this into two separate
functions.  First, before we start the first non-boot CPU:

static pte_t *slice_pte_tables[NR_CPUS / 1024];
Allocate and initialize them all;

It might even make sense to do this at build time instead of run time.
 I can't imagine that parallelizing this would provide any benefit
unless it were done *very* carefully and there were hundreds of
thousands of CPUs.  At worst, we're wasting 4 bytes per CPU not
present.

Then, for the per-CPU part, have one init-once structure (please tell
me the kernel has one of these) per 64 possible CPUs.  Each CPU will
make sure that its group of 64 cpus is initialized, using the init
once mechanism, and then it will set its percpu variable accordingly.

There are only 64 CPUs per slice, so mutexes may no be so bad here.

--Andy
