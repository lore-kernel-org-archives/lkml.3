Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbbAUM4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:56:20 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:50680 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbbAUM4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:56:08 -0500
Message-ID: <5575911c82b96b23fdcaeb71bde87e9e.squirrel@www.codeaurora.org>
Date: Wed, 21 Jan 2015 12:56:06 -0000
Subject: RE: [PATCH v3] hrtimers: calculate expires_next after all timers are
 executed
From: vigneshr@codeaurora.org
To: tglx@linutronix.de, stfomichev@yandex-team.ru
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        viresh.kumar@linaro.org, fweisbec@gmail.com, mingo@kernel.org,
        cl@linux.com, psodagud@codeaurora.org, sboyd@codeaurora.org
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

In this patch, we are only setting the flag
cpu_base->in_hrtirq = 1; in hrtimer_interrupt() and not resetting it.


> @@ -1251,9 +1251,9 @@ void hrtimer_interrupt(struct clock_even
> dev->next_event.tv64 = KTIME_MAX;
>
> raw_spin_lock(&cpu_base->lock);
> + cpu_base->in_hrtirq = 1;

Since this is the case, after the hrtimer_interrupt routine completes and
new timer is started and say it happens to be leftmost,
we don't allow hrtimer_reprogram() since we bail out given that
cpu_base->in_hrtirq=1 :

timer irq comes
--->hrtimer_interrupt()
---->cpu_base->in_hrtirq flag is set
------>Interrupt is serviced

After sometime

-->__hrtimer_start_range_ns()
--->happens to be leftmost hence call hrtimer_enqueue_reprogram()
----->hrtimer_reprogram()
------->bail out since cpu_base->in_hrtirq flag is stil set

At the end of hrtimer interrupt routine, i think we should also clear this
flag.

Something like the following can be added ?

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 8c94a55..b663653 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1251,9 +1251,9 @@ void hrtimer_interrupt(struct clock_event_device *dev)
        dev->next_event.tv64 = KTIME_MAX;

        raw_spin_lock(&cpu_base->lock);
-       cpu_base->in_hrtirq = 1;
        entry_time = now = hrtimer_update_base(cpu_base);
 retry:
+       cpu_base->in_hrtirq = 1;
        /*
         * We set expires_next to KTIME_MAX here with cpu_base->lock
         * held to prevent that a timer is enqueued in our queue via
@@ -1304,6 +1304,7 @@ retry:
         * against it.
         */
        cpu_base->expires_next = expires_next;
+       cpu_base->in_hrtirq = 0;
        raw_spin_unlock(&cpu_base->lock);

        /* Reprogramming necessary ? */

Thanks and regards,
vignesh Radhakrishnan

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

