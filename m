Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaLHGz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:55:57 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:43189 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaLHGz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:55:56 -0500
Subject: [PATCH V2] tick-broadcast: Register for hrtimer based broadcast as
 the fallback broadcast mode
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: tglx@linutronix.de
Cc: mark.rutland@arm.com, lorenzo.pieralisi@arm.com, peterz@infradead.org,
        benh@kernel.crashing.org, rafael.j.wysocki@intel.com,
        will.deacon@arm.com, linux-kernel@vger.kernel.org,
        shawn.guo@linaro.org, fweisbec@gmail.com, jingchang.lu@freescale.com,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Date: Mon, 08 Dec 2014 12:25:43 +0530
Message-ID: <20141208065513.3075.48721.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120806-0033-0000-0000-000002EF6321
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5d1638acb9f6 ('tick: Introduce hrtimer based broadcast') added a
hrtimer based broadcast mode for those platforms in which local timers stop
when CPUs enter deep idle states. The commit expected the platforms to
register for this mode explicitly when they lacked a better external device
to wake up CPUs in deep idle. Given that more platforms are beginning to use
this mode, we can avoid the call to set it up on every platform that requires
it, by registering for the hrtimer based broadcast mode in the core code if
no better broadcast device is available.

This commit also helps detect cases where the platform fails to register for
a broadcast device but invokes the help of one when entering deep idle states.
Currently we do not handle this situation at all and call the broadcast clock
device without checking for its existence. This patch will handle such buggy
cases properly.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
Changes from V1: https://lkml.org/lkml/2014/12/5/261
1.Moved registering the hrtimer based broadcast from timekeeping code
to an early_initcall.

 arch/arm64/kernel/time.c             |    2 --
 arch/powerpc/kernel/time.c           |    1 -
 include/linux/clockchips.h           |    6 +++---
 kernel/time/tick-broadcast-hrtimer.c |    4 +++-
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
index 1a7125c..47baaa8 100644
--- a/arch/arm64/kernel/time.c
+++ b/arch/arm64/kernel/time.c
@@ -70,8 +70,6 @@ void __init time_init(void)
 	of_clk_init(NULL);
 	clocksource_of_init();
 
-	tick_setup_hrtimer_broadcast();
-
 	arch_timer_rate = arch_timer_get_rate();
 	if (!arch_timer_rate)
 		panic("Unable to initialise architected timer.\n");
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 7505599..51433a8 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -942,7 +942,6 @@ void __init time_init(void)
 	clocksource_init();
 
 	init_decrementer_clockevent();
-	tick_setup_hrtimer_broadcast();
 }
 
 
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 2e4cb67..91754b0 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -187,11 +187,11 @@ extern int tick_receive_broadcast(void);
 #endif
 
 #if defined(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST) && defined(CONFIG_TICK_ONESHOT)
-extern void tick_setup_hrtimer_broadcast(void);
+extern int __init tick_setup_hrtimer_broadcast(void);
 extern int tick_check_broadcast_expired(void);
 #else
 static inline int tick_check_broadcast_expired(void) { return 0; }
-static inline void tick_setup_hrtimer_broadcast(void) {};
+static inline int __init tick_setup_hrtimer_broadcast(void) { return 0; }
 #endif
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
@@ -207,7 +207,7 @@ static inline void clockevents_resume(void) {}
 
 static inline int clockevents_notify(unsigned long reason, void *arg) { return 0; }
 static inline int tick_check_broadcast_expired(void) { return 0; }
-static inline void tick_setup_hrtimer_broadcast(void) {};
+static inline int __init tick_setup_hrtimer_broadcast(void) { return 0; }
 
 #endif
 
diff --git a/kernel/time/tick-broadcast-hrtimer.c b/kernel/time/tick-broadcast-hrtimer.c
index eb682d5..5c35995 100644
--- a/kernel/time/tick-broadcast-hrtimer.c
+++ b/kernel/time/tick-broadcast-hrtimer.c
@@ -98,9 +98,11 @@ static enum hrtimer_restart bc_handler(struct hrtimer *t)
 	return HRTIMER_RESTART;
 }
 
-void tick_setup_hrtimer_broadcast(void)
+int __init tick_setup_hrtimer_broadcast(void)
 {
 	hrtimer_init(&bctimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 	bctimer.function = bc_handler;
 	clockevents_register_device(&ce_broadcast_hrtimer);
+	return 0;
 }
+early_initcall(tick_setup_hrtimer_broadcast);

