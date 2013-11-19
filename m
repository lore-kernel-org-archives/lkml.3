Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab3KSTJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:09:11 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:64840 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3KSTJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:09:08 -0500
Date: Tue, 19 Nov 2013 20:09:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Boyer <jwboyer@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [GIT PULL] core kernel update
Message-ID: <20131119190904.GA22076@gmail.com>
References: <20131119154253.GA12219@gmail.com>
 <CA+55aFzyBxFi8_4C4hAz6+SAgtHCmQtpxSyJhRyWzggoRGTD5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzyBxFi8_4C4hAz6+SAgtHCmQtpxSyJhRyWzggoRGTD5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Nov 19, 2013 at 7:42 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Josh Boyer (1):
> >       smp/cpumask: Make CONFIG_CPUMASK_OFFSTACK=y usable without debug dependency
> 
> This seems to be just pure stupid.
> 
> Why the hell should we ever ask the user whethr they want to force 
> CPUMASK offstack?
> 
> Seriously, it only leaves room for mistakes and stupidities. There 
> is no reason for any normal use-case to ask the user about this. 
> Even the help message is pure and utter garbage ("This is a bit more 
> expensive, but avoids stack overflow").
> 
> The fact is, an on-stack CPUMASK is *smaller* than a pointer to an 
> offstack one when NR_CPU is small. The question makes no sense then. 
> And when NR_CPU is huge, the question makes no sense _either_, since 
> we can't have the cpumasks on stack.

You are completely right. I missed that, will fix it up.

So we have these CPU count ranges right now:

  config NR_CPUS
        int "Maximum number of CPUs" if SMP && !MAXSMP
        range 2 8 if SMP && X86_32 && !X86_BIGSMP
        range 2 512 if SMP && !MAXSMP && !CPUMASK_OFFSTACK
        range 2 8192 if SMP && !MAXSMP && CPUMASK_OFFSTACK && X86_64

As you pointed out offstack is definitely nonsensical for
NR_CPUS <= 64. (on 64-bit CPUs) On-stack is known to crash with 
NR_CPUS >= 1024.

The 128..512 CPUs range is somewhat of an unknown.

So the fixed code would always use on-stack cpumasks up to a limit 
(which limit falls into the 128...512 range) and it would always use 
off-stack cpumasks above that limit. No user configurability in the 
regular case. [*]

The actual value of the limit - here's the on-stack cpumask sizes of 
the candidate range:

	128 CPUs: 16 byte cpumasks
	256 CPUs: 32 byte cpumasks
	512 CPUs: 64 byte cpumasks

512 definitely 'feels' dangerous, so I'd say the limit should be 
either 128 or 256. Both are ridiculously high counts for regular 
systems, so it doesn't really matter which one we pick.

I'd guess we should pick the higher limit for the time being (256 CPUs 
- maybe even 512 CPUs), and lower it on contrary evidence (evidence of 
stack overflows)?

Thoughts?

Thanks,

	Ingo

[*] Plus perhaps allow offstack to be configurable arbitrarily if 
    debugging is enabled [DEBUG_PER_CPU_MAP=y], to allow easy
    experiments/measurements?
