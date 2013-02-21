Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab3BUWvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:51:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:53406 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab3BUWvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:51:37 -0500
Message-Id: <20130221220147.719832397@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Feb 2013 22:51:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC patch 0/8] timekeeping: Implement shadow timekeeper to shorten
 in kernel reader side blocking
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vsyscall based timekeeping interfaces for userspace provide the
shortest possible reader side blocking (update of the vsyscall gtod
data structure), but the kernel side interfaces to timekeeping are
blocked over the full code sequence of calculating update_wall_time()
magic which can be rather "long" due to ntp, corner cases, etc...

Eric did some work a few years ago to distangle the seqcount write
hold from the spinlock which is serializing the potential updaters of
the kernel internal timekeeper data. I couldn't be bothered to reread
the old mail thread and figure out why this got turned down, but I
remember that there were objections due to the potential inconsistency
between calculation, update and observation.

In hindsight that's nonsense, because even back at that time we did
the vsyscall update at the very least moment and unsychronized to the
in kernel data update.

While we never got any complaints about that there is a real issue
versus virtualization:

  VCPU0                                         VCPU1

  update_wall_time()
    write_seqlock_irqsave(&tk->lock, flags);
    ....

Host schedules out VCPU0

Arbitrary delay

Host schedules in VCPU0
                                                __vdso_clock_gettime()#1
    update_vsyscall();
                                                __vdso_clock_gettime()#2

Depending on the length of the delay which kept VCPU0 away from
executing and depending on the direction of the ntp update of the
timekeeping variables __vdso_clock_gettime()#2 can observe time going
backwards.

You can reproduce that by pinning VCPU0 to physical core 0 and VCPU1
to physical core 1. Now remove all load from physical core 1 except
VCPU1 and put massive load on physical core 0 and make sure that the
NTP adjustment lowers the mult factor. It's extremly hard to
reproduce, but it's possible.

So this patch series is going to expose the same issue to the kernel
side timekeeping. I'm not too worried about that, because 

 - it's extremly hard to trigger
 
 - we are aware of the issue vs. vsyscalls already

 - making the kernel behave the same way as vsyscall does not make
   things worse

 - John Stultz has already an idea how to fix it.
   See  https://lkml.org/lkml/2013/2/19/569

Though that's not the scope of this patch series, but I want to make
sure that it's documented.

Now the obvious question whether this is worth the trouble can be
answered easily. Preempt-RT users and HPC folks have complained about
the long write hold time of the timekeeping seqcount since years and a
quick test on a preempt-RT enabled kernel shows, that this series
lowers the maximum latency on the non-timekeeping cores from 8 to 4
microseconds. That's a whopping factor of 2. Defintely worth the
trouble!

Thanks,

	tglx
---
 include/linux/jiffies.h             |    1 
 include/linux/timekeeper_internal.h |    4 
 kernel/time/tick-internal.h         |    2 
 kernel/time/timekeeping.c           |  176 +++++++++++++++++++++---------------
 4 files changed, 107 insertions(+), 76 deletions(-)



