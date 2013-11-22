Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab3KVB67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:58:59 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49844 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755519Ab3KVB5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:57:46 -0500
From: Joel Fernandes <joelf@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <benoit.cousson@linaro.org>, <santosh.shilimkar@ti.com>,
        <jgchunter@gmail.com>, <rnayak@ti.com>, <balbi@ti.com>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 5/8] ARM: OMAP2+: timer: Introduce OF-friendly clocksource/clockevent system timers
Date: Thu, 21 Nov 2013 19:56:51 -0600
Message-ID: <1385085414-9034-6-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385085414-9034-1-git-send-email-joelf@ti.com>
References: <1385085414-9034-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This work is a migration effort of OMAP system timers to the
clocksource/clockevent framework. Consider this as a first-pass in this effort.
There are few cleanups that need to be done first. The HWMOD code is
intertwined with the timer code. HWMOD code cleanups in the future will
hopefully make most of this code go away, so till then we separate out the
power/clocks portion of the code from the actual timer bits.  This will
facilitate near-future work of adapting the system timer as a clocksource.

New functions for OF-only boot are introduced, and we can soon delete the old
versions once we migrate all platforms. Currently only AM335x is migrated and
testedA new omap_generic_timer_init function is introduced for DT platforms.
Code required earlier for non-DT platforms such as setup of timer IDs and timer
parent clock is not required.  parent clocks are automatically setup by the mux
clock driver through DT so they no longer need to be hardcoded.

The init code will try to pick the best timer for clocksource and clockevent
however bindings are added to force a particular timer as clocksource or
clockevent through DT.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 .../devicetree/bindings/arm/omap/timer.txt         |  12 ++
 arch/arm/mach-omap2/common.h                       |   1 +
 arch/arm/mach-omap2/timer.c                        | 235 +++++++++++++++++++++
 3 files changed, 248 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/omap/timer.txt b/Documentation/devicetree/bindings/arm/omap/timer.txt
index d02e27c..6cf7a75 100644
--- a/Documentation/devicetree/bindings/arm/omap/timer.txt
+++ b/Documentation/devicetree/bindings/arm/omap/timer.txt
@@ -32,6 +32,18 @@ Optional properties:
 - ti,timer-secure: 	Indicates the timer is reserved on a secure OMAP device
 			and therefore cannot be used by the kernel.
 
+- ti,timer-clockevent,
+  ti,timer-clocksource	These properties force the system timer code to choose
+			the particular timer as a clockevent or clocksource.
+			If these properties are not specified, the timer code
+			picks up a "ti,timer-alwon" as the clocksource and a
+			timer containing one of the following properties as
+			the clockevent in the following order:
+				ti,timer-alwon
+				ti,timer-dsp
+				ti,timer-pwm
+				ti,timer-secure
+
 Example:
 
 timer12: timer@48304000 {
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index 4a5684b..2a6b588 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -86,6 +86,7 @@ extern void omap3_secure_sync32k_timer_init(void);
 extern void omap3_gptimer_timer_init(void);
 extern void omap4_local_timer_init(void);
 extern void omap5_realtime_timer_init(void);
+void omap_generic_timer_init(void);
 
 void omap2420_init_early(void);
 void omap2430_init_early(void);
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index dd41f57..8ee2de0 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -318,6 +318,89 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 	return r;
 }
 
+static int __init omap_dmtimer_power_init(struct omap_dm_timer *timer,
+					struct device_node *np,
+					bool is_counter) {
+	struct omap_hwmod *oh;
+	const char *oh_name = NULL;
+	struct clk *src;
+	const char *parent;
+	int r;
+
+	of_property_read_string_index(np, "ti,hwmods", 0, &oh_name);
+	if (!oh_name)
+		return -ENODEV;
+
+	oh = omap_hwmod_lookup(oh_name);
+	if (!oh)
+		return -ENODEV;
+
+	omap_hwmod_setup_one(oh_name);
+
+	if (!is_counter) {
+		if (oh->_clk)
+			timer->fclk = oh->_clk;
+		else
+			timer->fclk = clk_get(NULL,
+					      omap_hwmod_get_main_clk(oh));
+		if (IS_ERR(timer->fclk))
+			return PTR_ERR(timer->fclk);
+
+		parent = of_get_property(np, "ti,timer-parent", NULL);
+		if (!parent) {
+			pr_err("ti,timer-parent required for system timer\n");
+			return -1;
+		}
+
+		src = clk_get(NULL, parent);
+		if (IS_ERR(src)) {
+			pr_err("Couldn't clk_get timer parent\n");
+			return PTR_ERR(src);
+		}
+
+		if (clk_get_parent(timer->fclk) != src) {
+			r = clk_set_parent(timer->fclk, src);
+			if (r < 0) {
+				pr_err("%s: %s cannot set source\n", __func__,
+				       oh->name);
+				clk_put(src);
+				return r;
+			}
+		}
+		clk_put(src);
+	}
+
+	omap_hwmod_enable(oh);
+	return 0;
+}
+
+static int __init omap_dmtimer_init_one(struct omap_dm_timer *timer,
+					struct device_node *np,
+					int posted)
+{
+	timer->irq = irq_of_parse_and_map(np, 0);
+	if (!timer->irq)
+		return -ENXIO;
+
+	timer->io_base = of_iomap(np, 0);
+	if (!timer->io_base)
+		return -ENXIO;
+
+	__omap_dm_timer_init_regs(timer);
+
+	if (posted)
+		__omap_dm_timer_enable_posted(timer);
+
+	/* Check that the intended posted configuration matches the actual */
+	if (posted != timer->posted)
+		return -EINVAL;
+
+	timer->rate = clk_get_rate(timer->fclk);
+	timer->reserved = 1;
+
+	return 0;
+}
+
 static void __init omap2_gp_clockevent_init(int gptimer_id,
 						const char *fck_source,
 						const char *property)
@@ -353,6 +436,41 @@ static void __init omap2_gp_clockevent_init(int gptimer_id,
 		clkev.rate);
 }
 
+static int __init omap_clockevent_init(struct device_node *np)
+{
+	int res;
+
+	clkev.errata = omap_dm_timer_get_errata();
+
+	/*
+	 * For clock-event timers we never read the timer counter and
+	 * so we are not impacted by errata i103 and i767. Therefore,
+	 * we can safely ignore this errata for clock-event timers.
+	 */
+	__omap_dm_timer_override_errata(&clkev, OMAP_TIMER_ERRATA_I103_I767);
+
+	clockevent_gpt.name = "timer_clkev";
+
+	res = omap_dmtimer_init_one(&clkev, np, OMAP_TIMER_POSTED);
+	if (res)
+		return res;
+
+	omap2_gp_timer_irq.dev_id = &clkev;
+	setup_irq(clkev.irq, &omap2_gp_timer_irq);
+
+	__omap_dm_timer_int_enable(&clkev, OMAP_TIMER_INT_OVERFLOW);
+
+	clockevent_gpt.cpumask = cpu_possible_mask;
+	clockevent_gpt.irq = omap_dm_timer_get_irq(&clkev);
+	clockevents_config_and_register(&clockevent_gpt, clkev.rate,
+					3, /* Timer internal resynch latency */
+					0xffffffff);
+
+	pr_info("OMAP clockevent source: %s at %lu Hz\n", clockevent_gpt.name,
+		clkev.rate);
+	return 0;
+}
+
 /* Clocksource code */
 static struct omap_dm_timer clksrc;
 static bool use_gptimer_clksrc;
@@ -448,6 +566,31 @@ static int __init __maybe_unused omap2_sync32k_clocksource_init(void)
 	return ret;
 }
 
+/* Setup free-running counter for clocksource */
+static int __init omap_sync32k_clocksource_init(struct device_node *np)
+{
+	int ret = 0;
+	void __iomem *vbase;
+
+	vbase = of_iomap(np, 0);
+	if (!vbase) {
+		pr_err("%s: failed to get counter_32k resource\n", __func__);
+		return -ENXIO;
+	}
+
+	ret = omap_init_clocksource_32k(vbase);
+	if (ret) {
+		pr_err("%s: failed to initialize counter_32k clocksource(%d)\n",
+		       __func__, ret);
+		return ret;
+	}
+
+	pr_err("Sync32k clocksource initialized\n");
+
+	return ret;
+}
+
+
 static void __init omap2_gptimer_clocksource_init(int gptimer_id,
 						  const char *fck_source,
 						  const char *property)
@@ -475,6 +618,39 @@ static void __init omap2_gptimer_clocksource_init(int gptimer_id,
 			clocksource_gpt.name, clksrc.rate);
 }
 
+static int __init omap_clocksource_init(struct device_node *np)
+{
+	int res = 0;
+
+	clksrc.errata = omap_dm_timer_get_errata();
+
+	if (strlen(np->name) > 7) {
+		pr_err("%s: OF node name too big\n", __func__);
+		return -ENODEV;
+	}
+	clocksource_gpt.name = "timer_clksrc";
+
+	res = omap_dmtimer_init_one(&clksrc, np, OMAP_TIMER_NONPOSTED);
+	if (res)
+		return res;
+
+	__omap_dm_timer_load_start(&clksrc,
+				   OMAP_TIMER_CTRL_ST | OMAP_TIMER_CTRL_AR, 0,
+				   OMAP_TIMER_NONPOSTED);
+	setup_sched_clock(dmtimer_read_sched_clock, 32, clksrc.rate);
+
+	res = clocksource_register_hz(&clocksource_gpt, clksrc.rate);
+	if (res) {
+		pr_err("Could not register clocksource %s\n",
+		       clocksource_gpt.name);
+		return res;
+	} else {
+		pr_info("OMAP clocksource: %s at %lu Hz\n",
+			clocksource_gpt.name, clksrc.rate);
+	}
+	return 0;
+}
+
 #ifdef CONFIG_SOC_HAS_REALTIME_COUNTER
 /*
  * The realtime counter also called master counter, is a free-running
@@ -604,6 +780,65 @@ static OMAP_SYS_32K_TIMER_INIT(4, 1, "timer_32k_ck", "ti,timer-alwon",
 			       2, "sys_clkin_ck", NULL);
 #endif
 
+void omap_generic_timer_init(void)
+{
+	struct device_node *np_clksrc = NULL, *np_clkev = NULL;
+	int res, using_counter = false;
+
+	if (!of_have_populated_dt())
+		BUG_ON("Generic timer init should only be used for DT boot\n");
+
+	if (omap_clk_init)
+		omap_clk_init();
+
+	omap_dmtimer_init();
+
+	/*
+	 * Search for a clocksource:
+	 * Check if dmtimer with property timer-clocksource is in DT,
+	 * If not, by default see if a counter is available unless the
+	 * clocksource=use_gptimer is present on boot command line.
+	 * If no counter on platform, or use_gptimer=1, search for
+	 * a dmtimer with ti,timer-alwon property (timers that don't
+	 * turn off during suspend state). If not found, then fail.
+	 */
+	np_clksrc = omap_get_timer_dt(omap_timer_match, "ti,timer-clocksource");
+	if (!np_clksrc && !use_gptimer_clksrc) {
+		np_clksrc = omap_get_timer_dt(omap_counter_match, NULL);
+		if (np_clksrc)
+			using_counter = true;
+	}
+
+	if (!np_clksrc)
+		np_clksrc = omap_get_timer_dt(omap_timer_match,
+					      "ti,timer-alwon");
+
+	BUG_ON(!np_clksrc);
+
+	np_clkev = omap_get_timer_dt(omap_timer_match, "ti,timer-clockevent");
+	if (!np_clkev) {
+		np_clkev = omap_get_timer_dt(omap_timer_match, NULL);
+		BUG_ON(!np_clkev);
+	}
+
+	res = omap_dmtimer_power_init(&clkev, np_clkev, false);
+	BUG_ON(res);
+
+	res = omap_clockevent_init(np_clkev);
+	BUG_ON(res);
+
+	res = omap_dmtimer_power_init(&clksrc, np_clksrc, using_counter);
+	BUG_ON(res);
+
+	if (using_counter)
+		res = omap_sync32k_clocksource_init(np_clksrc);
+	else
+		res = omap_clocksource_init(np_clksrc);
+	BUG_ON(res);
+
+	of_node_put(np_clksrc);
+}
+
 #ifdef CONFIG_ARCH_OMAP4
 void __init omap4_local_timer_init(void)
 {
-- 
1.8.1.2

