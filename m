Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaIASsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 14:48:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54164 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbaIASsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 14:48:35 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Mike Turquette <mturquette@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/3] cpufreq: kirkwood: use the powersave multiplexer
Date: Mon,  1 Sep 2014 11:47:05 -0700
Message-Id: <1409597225-24368-4-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1409597225-24368-1-git-send-email-mturquette@linaro.org>
References: <1409597225-24368-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The powersave clock acts like a multiplexer for the cpu, selecting
either the clock signal derived from the cpu pll or from the ddr clock.
This patch changes powersave from a gate clock to a mux clock to better
reflect this behavior.

This is a cleaner approach whereby the frequency of the cpu always
matches the rate of powersave_clk. The cpufreq driver for the kirkwood
platform no longer must parse this behavior out of various calls to
clk_enable and clk_disable, but can instead simply select the parent cpu
it wants when changing rate. Likewise when requesting the cpu rate we
need only query powersave_clk's rate through the usual call to
clk_get_rate.

The new clock data and corresponding changes to the cpufreq driver are
combined into this single commit to avoid a git bisect issue where this
cpufreq driver fails to work properly between the commit that updates
the kirkwood clock driver and the commit that changes how the cpufreq
driver uses that clock.

Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/mvebu/kirkwood.c       | 15 +++++++++++++--
 drivers/cpufreq/kirkwood-cpufreq.c | 14 +++++---------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/mvebu/kirkwood.c b/drivers/clk/mvebu/kirkwood.c
index f73a2fa..99550f2 100644
--- a/drivers/clk/mvebu/kirkwood.c
+++ b/drivers/clk/mvebu/kirkwood.c
@@ -216,7 +216,6 @@ static const struct clk_gating_soc_desc kirkwood_gating_desc[] __initconst = {
 	{ "runit", NULL, 7, 0 },
 	{ "xor0", NULL, 8, 0 },
 	{ "audio", NULL, 9, 0 },
-	{ "powersave", "cpuclk", 11, 0 },
 	{ "sata0", NULL, 14, 0 },
 	{ "sata1", NULL, 15, 0 },
 	{ "xor1", NULL, 16, 0 },
@@ -247,6 +246,16 @@ struct clk_muxing_ctrl {
 	int num_muxes;
 };
 
+static const char *powersave_parents[] = {
+	"cpuclk",
+	"ddrclk",
+};
+
+static const struct clk_muxing_soc_desc kirkwood_mux_desc[] __initconst = {
+	{ "powersave", powersave_parents, ARRAY_SIZE(powersave_parents),
+		11, 1, 0 },
+};
+
 #define to_clk_mux(_hw) container_of(_hw, struct clk_mux, hw)
 
 static struct clk *clk_muxing_get_src(
@@ -323,8 +332,10 @@ static void __init kirkwood_clk_init(struct device_node *np)
 	else
 		mvebu_coreclk_setup(np, &kirkwood_coreclks);
 
-	if (cgnp)
+	if (cgnp) {
 		mvebu_clk_gating_setup(cgnp, kirkwood_gating_desc);
+		kirkwood_clk_muxing_setup(cgnp, kirkwood_mux_desc);
+	}
 }
 CLK_OF_DECLARE(kirkwood_clk, "marvell,kirkwood-core-clock",
 	       kirkwood_clk_init);
diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
index 37a4806..7906d4a 100644
--- a/drivers/cpufreq/kirkwood-cpufreq.c
+++ b/drivers/cpufreq/kirkwood-cpufreq.c
@@ -12,7 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/clk.h>
-#include <linux/clk-provider.h>
 #include <linux/cpufreq.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
@@ -39,8 +38,7 @@ static struct priv
  * - cpu clk
  * - ddr clk
  *
- * The frequencies are set at runtime before registering this *
- * table.
+ * The frequencies are set at runtime before registering this table.
  */
 static struct cpufreq_frequency_table kirkwood_freq_table[] = {
 	{0, STATE_CPU_FREQ,	0}, /* CPU uses cpuclk */
@@ -50,9 +48,7 @@ static struct cpufreq_frequency_table kirkwood_freq_table[] = {
 
 static unsigned int kirkwood_cpufreq_get_cpu_frequency(unsigned int cpu)
 {
-	if (__clk_is_enabled(priv.powersave_clk))
-		return kirkwood_freq_table[1].frequency;
-	return kirkwood_freq_table[0].frequency;
+	return clk_get_rate(priv.powersave_clk) / 1000;
 }
 
 static int kirkwood_cpufreq_target(struct cpufreq_policy *policy,
@@ -70,10 +66,10 @@ static int kirkwood_cpufreq_target(struct cpufreq_policy *policy,
 
 	switch (state) {
 	case STATE_CPU_FREQ:
-		clk_disable(priv.powersave_clk);
+		clk_set_parent(priv.powersave_clk, priv.cpu_clk);
 		break;
 	case STATE_DDR_FREQ:
-		clk_enable(priv.powersave_clk);
+		clk_set_parent(priv.powersave_clk, priv.ddr_clk);
 		break;
 	}
 
@@ -150,7 +146,7 @@ static int kirkwood_cpufreq_probe(struct platform_device *pdev)
 		err = PTR_ERR(priv.powersave_clk);
 		goto out_ddr;
 	}
-	clk_prepare(priv.powersave_clk);
+	clk_prepare_enable(priv.powersave_clk);
 
 	of_node_put(np);
 	np = NULL;
-- 
1.8.3.2

