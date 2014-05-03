Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaECJbV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 05:31:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:45407 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaECJbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 05:31:19 -0400
Date: Sat, 3 May 2014 11:31:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] timer updates for 3.15
Message-ID: <alpine.DEB.2.02.1405031123420.6261@ionos.tec.linutronix.de>
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

This update brings along:

* Two fixes for long standing bugs in the hrtimer code, one which
  prevents remote enqueuing and the other preventing arbitrary delays
  after a interrupt hang was detected

* A fix in the timer wheel which prevents math overflow

* A fix for a long standing issue with the architected ARM timer
  related to the C3STOP mechanism.

* A trivial compile fix for nspire SoC clocksource

Thanks,

	tglx

------------------>
Alexander Shiyan (1):
      clocksource: nspire: Fix compiler warning

Jiri Bohac (1):
      timer: Prevent overflow in apply_slack

Leon Ma (1):
      hrtimer: Prevent remote enqueue of leftmost timers

Lorenzo Pieralisi (1):
      clocksource: arch_arm_timer: Fix age-old arch timer C3STOP detection issue

Stuart Hayes (1):
      hrtimer: Prevent all reprogramming if hang detected


 .../devicetree/bindings/arm/arch_timer.txt         |    3 +++
 drivers/clocksource/arm_arch_timer.c               |    6 +++++-
 drivers/clocksource/zevio-timer.c                  |    7 ++++++-
 kernel/hrtimer.c                                   |   22 ++++++++++++++++++++
 kernel/timer.c                                     |    2 +-
 5 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
index 06fc760..37b2caf 100644
--- a/Documentation/devicetree/bindings/arm/arch_timer.txt
+++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
@@ -19,6 +19,9 @@ to deliver its interrupts via SPIs.
 
 - clock-frequency : The frequency of the main counter, in Hz. Optional.
 
+- always-on : a boolean property. If present, the timer is powered through an
+  always-on power domain, therefore it never loses context.
+
 Example:
 
 	timer {
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 57e823c..5163ec1 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -66,6 +66,7 @@ static int arch_timer_ppi[MAX_TIMER_PPI];
 static struct clock_event_device __percpu *arch_timer_evt;
 
 static bool arch_timer_use_virtual = true;
+static bool arch_timer_c3stop;
 static bool arch_timer_mem_use_virtual;
 
 /*
@@ -263,7 +264,8 @@ static void __arch_timer_setup(unsigned type,
 	clk->features = CLOCK_EVT_FEAT_ONESHOT;
 
 	if (type == ARCH_CP15_TIMER) {
-		clk->features |= CLOCK_EVT_FEAT_C3STOP;
+		if (arch_timer_c3stop)
+			clk->features |= CLOCK_EVT_FEAT_C3STOP;
 		clk->name = "arch_sys_timer";
 		clk->rating = 450;
 		clk->cpumask = cpumask_of(smp_processor_id());
@@ -665,6 +667,8 @@ static void __init arch_timer_init(struct device_node *np)
 		}
 	}
 
+	arch_timer_c3stop = !of_property_read_bool(np, "always-on");
+
 	arch_timer_register();
 	arch_timer_common_init();
 }
diff --git a/drivers/clocksource/zevio-timer.c b/drivers/clocksource/zevio-timer.c
index ca81809..7ce4421 100644
--- a/drivers/clocksource/zevio-timer.c
+++ b/drivers/clocksource/zevio-timer.c
@@ -212,4 +212,9 @@ error_free:
 	return ret;
 }
 
-CLOCKSOURCE_OF_DECLARE(zevio_timer, "lsi,zevio-timer", zevio_timer_add);
+static void __init zevio_timer_init(struct device_node *node)
+{
+	BUG_ON(zevio_timer_add(node));
+}
+
+CLOCKSOURCE_OF_DECLARE(zevio_timer, "lsi,zevio-timer", zevio_timer_init);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index d55092c..6b715c0 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -234,6 +234,11 @@ again:
 			goto again;
 		}
 		timer->base = new_base;
+	} else {
+		if (cpu != this_cpu && hrtimer_check_target(timer, new_base)) {
+			cpu = this_cpu;
+			goto again;
+		}
 	}
 	return new_base;
 }
@@ -569,6 +574,23 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 
 	cpu_base->expires_next.tv64 = expires_next.tv64;
 
+	/*
+	 * If a hang was detected in the last timer interrupt then we
+	 * leave the hang delay active in the hardware. We want the
+	 * system to make progress. That also prevents the following
+	 * scenario:
+	 * T1 expires 50ms from now
+	 * T2 expires 5s from now
+	 *
+	 * T1 is removed, so this code is called and would reprogram
+	 * the hardware to 5s from now. Any hrtimer_start after that
+	 * will not reprogram the hardware due to hang_detected being
+	 * set. So we'd effectivly block all timers until the T2 event
+	 * fires.
+	 */
+	if (cpu_base->hang_detected)
+		return;
+
 	if (cpu_base->expires_next.tv64 != KTIME_MAX)
 		tick_program_event(cpu_base->expires_next, 1);
 }
diff --git a/kernel/timer.c b/kernel/timer.c
index 87bd529..3bb01a3 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -838,7 +838,7 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
 
 	bit = find_last_bit(&mask, BITS_PER_LONG);
 
-	mask = (1 << bit) - 1;
+	mask = (1UL << bit) - 1;
 
 	expires_limit = expires_limit & ~(mask);
 
