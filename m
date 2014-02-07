Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaBGRdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:33:09 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38822 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbaBGRdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:33:06 -0500
Subject: [PATCH] time/cpuidle:Fixup fallout from hrtimer broadcast mode
 inclusion
To: tglx@linutronix.de, fengguang.wu@intel.com
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 07 Feb 2014 22:59:24 +0530
Message-ID: <20140207172924.8248.55002.stgit@preeti>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020717-0320-0000-0000-00000268A410
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The broadcast timer registration has to be done only when
GENERIC_CLOCKEVENTS_BROADCAST and TICK_ONESHOT config options are enabled.
Also fix max_delta_ticks value for the pseudo clock device.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
---

 kernel/time/tick-broadcast-hrtimer.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/time/tick-broadcast-hrtimer.c b/kernel/time/tick-broadcast-hrtimer.c
index 5591aaa..bc383ac 100644
--- a/kernel/time/tick-broadcast-hrtimer.c
+++ b/kernel/time/tick-broadcast-hrtimer.c
@@ -81,7 +81,7 @@ static struct clock_event_device ce_broadcast_hrtimer = {
 	.min_delta_ns		= 1,
 	.max_delta_ns		= KTIME_MAX,
 	.min_delta_ticks	= 1,
-	.max_delta_ticks	= KTIME_MAX,
+	.max_delta_ticks	= ULONG_MAX,
 	.mult			= 1,
 	.shift			= 0,
 	.cpumask		= cpu_all_mask,
@@ -102,9 +102,11 @@ static enum hrtimer_restart bc_handler(struct hrtimer *t)
 	return HRTIMER_RESTART;
 }
 
+#if defined(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST) && defined(CONFIG_TICK_ONESHOT)
 void tick_setup_hrtimer_broadcast(void)
 {
 	hrtimer_init(&bctimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 	bctimer.function = bc_handler;
 	clockevents_register_device(&ce_broadcast_hrtimer);
 }
+#endif

