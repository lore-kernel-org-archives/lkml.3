Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbaBOTVe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 14:21:34 -0500
Received: from www.linutronix.de ([62.245.132.108]:47750 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbaBOTVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 14:21:32 -0500
Date: Sat, 15 Feb 2014 20:21:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT Pull] timer fixes for 3.14
Message-ID: <alpine.DEB.2.02.1402152005210.21991@ionos.tec.linutronix.de>
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

The following trilogy of patches brings you:

 * Fix for a long standing math overflow issue with HZ < 60

 * An onliner fix for a corner case in the dreaded tick broadcast
   mechanism affecting a certain range of AMD machines which are
   infested with the infamous automagic C1E power control misfeature

 * A fix for one of the ARM platforms which allows the kernel to
   proceed and boot instead of stupidly panicing for no good
   reason. The patch is slightly larger than necessary, but it's less
   ugly than the alternative 5 liner.


Thanks,

	tglx

------------------>
Mikulas Patocka (1):
      time: Fix overflow when HZ is smaller than 60

Thomas Gleixner (1):
      tick: Clear broadcast pending bit when switching to oneshot

Tim Kryger (1):
      clocksource: Kona: Print warning rather than panic


 drivers/clocksource/bcm_kona_timer.c |   54 ++++++++++++++++++----------------
 kernel/time/jiffies.c                |    6 ++++
 kernel/time/tick-broadcast.c         |    1 +
 3 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/drivers/clocksource/bcm_kona_timer.c b/drivers/clocksource/bcm_kona_timer.c
index 974b2db..0595dc6 100644
--- a/drivers/clocksource/bcm_kona_timer.c
+++ b/drivers/clocksource/bcm_kona_timer.c
@@ -99,31 +99,6 @@ kona_timer_get_counter(void *timer_base, uint32_t *msw, uint32_t *lsw)
 	return;
 }
 
-static void __init kona_timers_init(struct device_node *node)
-{
-	u32 freq;
-	struct clk *external_clk;
-
-	external_clk = of_clk_get_by_name(node, NULL);
-
-	if (!IS_ERR(external_clk)) {
-		arch_timer_rate = clk_get_rate(external_clk);
-		clk_prepare_enable(external_clk);
-	} else if (!of_property_read_u32(node, "clock-frequency", &freq)) {
-		arch_timer_rate = freq;
-	} else {
-		panic("unable to determine clock-frequency");
-	}
-
-	/* Setup IRQ numbers */
-	timers.tmr_irq = irq_of_parse_and_map(node, 0);
-
-	/* Setup IO addresses */
-	timers.tmr_regs = of_iomap(node, 0);
-
-	kona_timer_disable_and_clear(timers.tmr_regs);
-}
-
 static int kona_timer_set_next_event(unsigned long clc,
 				  struct clock_event_device *unused)
 {
@@ -198,7 +173,34 @@ static struct irqaction kona_timer_irq = {
 
 static void __init kona_timer_init(struct device_node *node)
 {
-	kona_timers_init(node);
+	u32 freq;
+	struct clk *external_clk;
+
+	if (!of_device_is_available(node)) {
+		pr_info("Kona Timer v1 marked as disabled in device tree\n");
+		return;
+	}
+
+	external_clk = of_clk_get_by_name(node, NULL);
+
+	if (!IS_ERR(external_clk)) {
+		arch_timer_rate = clk_get_rate(external_clk);
+		clk_prepare_enable(external_clk);
+	} else if (!of_property_read_u32(node, "clock-frequency", &freq)) {
+		arch_timer_rate = freq;
+	} else {
+		pr_err("Kona Timer v1 unable to determine clock-frequency");
+		return;
+	}
+
+	/* Setup IRQ numbers */
+	timers.tmr_irq = irq_of_parse_and_map(node, 0);
+
+	/* Setup IO addresses */
+	timers.tmr_regs = of_iomap(node, 0);
+
+	kona_timer_disable_and_clear(timers.tmr_regs);
+
 	kona_timer_clockevents_init();
 	setup_irq(timers.tmr_irq, &kona_timer_irq);
 	kona_timer_set_next_event((arch_timer_rate / HZ), NULL);
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 7a925ba..a6a5bf5 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -51,7 +51,13 @@
  * HZ shrinks, so values greater than 8 overflow 32bits when
  * HZ=100.
  */
+#if HZ < 34
+#define JIFFIES_SHIFT	6
+#elif HZ < 67
+#define JIFFIES_SHIFT	7
+#else
 #define JIFFIES_SHIFT	8
+#endif
 
 static cycle_t jiffies_read(struct clocksource *cs)
 {
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 43780ab..98977a5 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -756,6 +756,7 @@ out:
 static void tick_broadcast_clear_oneshot(int cpu)
 {
 	cpumask_clear_cpu(cpu, tick_broadcast_oneshot_mask);
+	cpumask_clear_cpu(cpu, tick_broadcast_pending_mask);
 }
 
 static void tick_broadcast_init_next_event(struct cpumask *mask,
