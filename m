Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbaGUWN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:13:56 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:55158 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaGUWNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:13:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140721220825.GE11555@pd.tnic>
References: <20140719130602.GA5101@pd.tnic> <53CD6B50.5010404@mit.edu>
 <20140721213534.GB11555@pd.tnic> <CALCETrW91Q=ivYRVFb0WKXgHQO7O+x_HHDy67e90TU6Bte_ecg@mail.gmail.com>
 <20140721215225.GD11555@pd.tnic> <CALCETrX1LbZAiPH4x2Uby_cUUj2wgN92wc+5wvf-B3_9XdObWQ@mail.gmail.com>
 <20140721220825.GE11555@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 21 Jul 2014 15:13:33 -0700
Message-ID: <CALCETrXOpcegDp+eUTWqDkO0jWqgJNYhKJW=HbzvT1ga4Ekxog@mail.gmail.com>
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

On Mon, Jul 21, 2014 at 3:08 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Jul 21, 2014 at 02:56:49PM -0700, Andy Lutomirski wrote:
>> I expect that users of __vdso_clock_gettime (e.g. glibc) will get the
>> correct time :)  They use vread_tsc, and they can't use
>> preempt_disable, because they're in userspace.  They also can't
>> directly access per-cpu variables.
>>
>> Turning off vdso tsc support on these machines would be an option.
>
> Right, this is what I was going to propose to tglx on IRC. Or we can try
> to come up with something working for the vdso too, say RDTSCP :-)
>
> But that still won't work as it needs the per-cpu variables. So I guess
> vdso loses...
>
>> I actually own one of these systems.  It's a Sandy Bridge Core-i7
>> Extreme or something like that.
>
> Ha, cool, so I've got my tester! :-)

Ha.  Ha ha.  Muahaha.  Because IIRC this box is synced until the first
time it suspends.

>
>> I wonder if that's a bug in get_cycles.
>>
>> The basic issue is that rdtsc is not ordered with respect to nearby
>> loads, so it's fairly easy to see it behaving non-monotonically across
>> CPUs.  rdtscp is ordered, but it's a little slower.
>
> Yah, that I know. But I don't see get_cycles() having the barriers. So
> it might be a bug. We can certainly try to "fix" it and see what happens
> :-)
>
> diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
> index 94605c0e9cee..ad7d5e449c0b 100644
> --- a/arch/x86/include/asm/tsc.h
> +++ b/arch/x86/include/asm/tsc.h
> @@ -27,7 +27,9 @@ static inline cycles_t get_cycles(void)
>         if (!cpu_has_tsc)
>                 return 0;
>  #endif
> +       rdtsc_barrier();
>         rdtscll(ret);
> +       rdtsc_barrier();
>

Only the first of these is necessary.  There was a long thread on this
a couple of years ago, and the conclusion was that the code in
vread_tsc in vclock_gettime.c is correct.

--Andy

>         return ret;
>  }
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --



-- 
Andy Lutomirski
AMA Capital Management, LLC
