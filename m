Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaDQUsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:48:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:51538 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaDQUsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:48:46 -0400
Date: Thu, 17 Apr 2014 22:48:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] timer fixes for 3.15
Message-ID: <alpine.DEB.2.02.1404172234580.22697@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

Viresh unearthed the following three hickups in the timer/timekeeping
code:

- Negated check for the result of a clock event selection

- A missing early exit in the jiffies update path which causes
  update_wall_time to be called for nothing causing lock contention
  and wasted cycles in the timer interrupt

- Checking a variable in the NOHZ code enable code for true which can
  only be set by that very code after the check succeeds. That results
  in a rock solid runtime disablement of that feature.

Thanks,

	tglx

------------------>
Viresh Kumar (3):
      tick-common: Fix wrong check in tick_check_replacement()
      tick-sched: Don't call update_wall_time() when delta is lesser than tick_period
      tick-sched: Check tick_nohz_enabled in tick_nohz_switch_to_nohz()


 kernel/time/tick-common.c |    2 +-
 kernel/time/tick-sched.c  |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 0156612..0a0608e 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -276,7 +276,7 @@ static bool tick_check_preferred(struct clock_event_device *curdev,
 bool tick_check_replacement(struct clock_event_device *curdev,
 			    struct clock_event_device *newdev)
 {
-	if (tick_check_percpu(curdev, newdev, smp_processor_id()))
+	if (!tick_check_percpu(curdev, newdev, smp_processor_id()))
 		return false;
 
 	return tick_check_preferred(curdev, newdev);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 9f8af69..6558b7a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -84,6 +84,9 @@ static void tick_do_update_jiffies64(ktime_t now)
 
 		/* Keep the tick_next_period variable up to date */
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
+	} else {
+		write_sequnlock(&jiffies_lock);
+		return;
 	}
 	write_sequnlock(&jiffies_lock);
 	update_wall_time();
@@ -967,7 +970,7 @@ static void tick_nohz_switch_to_nohz(void)
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t next;
 
-	if (!tick_nohz_active)
+	if (!tick_nohz_enabled)
 		return;
 
 	local_irq_disable();
