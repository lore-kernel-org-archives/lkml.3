Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbaGUWn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:43:59 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:59501 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbaGUWn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:43:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140721223009.GF11555@pd.tnic>
References: <20140719130602.GA5101@pd.tnic> <53CD6B50.5010404@mit.edu>
 <20140721213534.GB11555@pd.tnic> <CALCETrW91Q=ivYRVFb0WKXgHQO7O+x_HHDy67e90TU6Bte_ecg@mail.gmail.com>
 <20140721215225.GD11555@pd.tnic> <CALCETrX1LbZAiPH4x2Uby_cUUj2wgN92wc+5wvf-B3_9XdObWQ@mail.gmail.com>
 <20140721220825.GE11555@pd.tnic> <CALCETrXOpcegDp+eUTWqDkO0jWqgJNYhKJW=HbzvT1ga4Ekxog@mail.gmail.com>
 <20140721223009.GF11555@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 21 Jul 2014 15:43:36 -0700
Message-ID: <CALCETrU1BWJ5h=GDRFKg_CXh4pQvB6MyCoRP=H3z8XGirhQDsQ@mail.gmail.com>
Subject: Re: [PATCH] x86, TSC: Add a software TSC offset
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 3:30 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Jul 21, 2014 at 03:13:33PM -0700, Andy Lutomirski wrote:
>> Ha.  Ha ha.  Muahaha.  Because IIRC this box is synced until the first
>> time it suspends.
>
> Sweet, TSCs get fumbled in some S-state or maybe SMI... Who TF knows.
>
> Well, I'm thinking upon resume, we run through smpboot which should do
> the tsc sync check again. Will have to test to see.

I have some reason to believe that this is almost an intentional bug
on the part of the BIOS vendor.

>
>> > diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
>> > index 94605c0e9cee..ad7d5e449c0b 100644
>> > --- a/arch/x86/include/asm/tsc.h
>> > +++ b/arch/x86/include/asm/tsc.h
>> > @@ -27,7 +27,9 @@ static inline cycles_t get_cycles(void)
>> >         if (!cpu_has_tsc)
>> >                 return 0;
>> >  #endif
>> > +       rdtsc_barrier();
>> >         rdtscll(ret);
>> > +       rdtsc_barrier();
>> >
>>
>> Only the first of these is necessary.  There was a long thread on this
>> a couple of years ago, and the conclusion was that the code in
>> vread_tsc in vclock_gettime.c is correct.
>
>          * The various CPU manuals are unclear
>          * as to whether rdtsc can be reordered with later loads,
>          * but no one has ever seen it happen.
>
> until some future uarch proves you wrong. :-)
>
> I guess we can try with one pre-fence only first although if we're doing
> one already, I can't imagine the post-one to be all that expensive since
> we've retired the whole inflight crap already anyway.
>

IIRC it was actually quite expensive, at least on Sandy Bridge.  Maybe
AMD is different.

Anyway, if some future uarch breaks this, I could resurrect my old
hack: do a TSC-dependent load prior to returning.  Loads are ordered,
and the hackish load can't be reordered wrt RDTSC due to
data-dependency, so we're in business :)

--Andy
