Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934490Ab3EGCli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:41:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:65028 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758705Ab3EGClh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:41:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,625,1363158000"; 
   d="scan'208";a="329975917"
Date: Tue, 7 May 2013 10:38:53 +0800
From: Feng Tang <feng.tang@intel.com>
To: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fwd: [GIT PULL] timer changes for v3.10
Message-ID: <20130507023853.GA2945@feng-snb>
References: <20130430074322.GA20110@gmail.com>
 <20130506230137.GA16801@amd.pavel.ucw.cz>
 <CA++bM2scosWgBpC3_LzcKYOjG4EQQzN5Vf4rZFds-5qRVRwvDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA++bM2scosWgBpC3_LzcKYOjG4EQQzN5Vf4rZFds-5qRVRwvDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Tue, May 07, 2013 at 09:10:42AM +0800, Feng Tang wrote:
> ---------- Forwarded message ----------
> From: Pavel Machek <pavel@ucw.cz>
> Date: 2013/5/7
> Subject: Re: [GIT PULL] timer changes for v3.10
> To: Ingo Molnar <mingo@kernel.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>,
> linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Peter
> Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>
> 
> 
> Hi!
> 
> >  - suspend/resume enhancements by Feng Tang: on certain new Intel Atom
> >    processors (Penwell and Cloverview), there is a feature that the TSC
> >    won't stop in S3 state, so the TSC value won't be reset to 0 after
> >    resume. This can be taken advantage of by the generic via the
> >    CLOCK_SOURCE_SUSPEND_NONSTOP flag: instead of using the RTC to
> >    recover/approximate sleep time, the main (and precise) clocksource can
> >    be used.
> 
> Ok, so for system time, we use three different timers:
> 
> 1) RTC, while system is off
> 
> 2) PIT, while system is running (plus TSC for parts of second)

Not exactly. AFAIK, in most morden x86 processors, the TSC is the primary
clocksource for system time counting.

If you grep clocksource in arch/x86/, there are some clockcources:
HPET, TSC, i8253(PIT you mentioned), APBT and some other xen/kvm clocksources.

Each of them has a "rating", and the clocksource with highest rating will
be selected for system time counting. Here are the ratings:

HPET:	250
TSC:	300
APBT:	250
PIT:	110

So for a system with TSC, unless the TSC is detected or claimed to be
"unstable", it will be used as the runtime clocksource.

> 
> 3) TSC, while system is sleeping

This happens Only if we explicitly claim one processor's TSC has
S3_NONSTOP_TSC feature. Detail could be found in patches. 

For other cases, system will still use persistent_clock or RTC to
calculate the sleep/suspended time

In short, most of existing X86 platforms will not be affected

> 
> Now. we have ntpd that is trying to compute "speed of clock", and
> adjust accordingly (adjtimex). But will it still do the right thing
> when we switch to different source during sleep?
> 
> And is the TSC even good enough? According to man page, PIT is not
> precise enough, so we sync from RTC every 11 minutes. I'd imagine TSC
My understanding, the reason for this 11 minutes sync is due to the
PIT's register value has wrapped around .

> is even worse than that. Machine can stay is s2ram for weeks (for a
> lot more if it is desktop and you do s2ram for powersaving). Also
> temperature of CPU varies a lot between active and s2ram states. Is
> TSC good enough?

Yes, I think it is relatively precise. Per our test, system time backed
by the S3 non stop TSC only has 1 second drift after 4 days running
(with mixed running and S3 states). And before using this feature, we've
seen many time drift problems due to the RTC HW or system FW with our
platforms.

Thanks,
Feng


