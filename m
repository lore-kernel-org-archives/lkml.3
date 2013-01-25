Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab3AYTqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 14:46:46 -0500
Received: from smtp181.dfw.emailsrvr.com ([67.192.241.181]:50815 "EHLO
	smtp181.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab3AYTql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 14:46:41 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 1/4 v11] arm: use device tree to get smp_twd clock
Date: Fri, 25 Jan 2013 13:46:42 -0600
Message-Id: <1359143205-20279-2-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359143205-20279-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1359143205-20279-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Move clk setup to twd_local_timer_common_register and rely on
twd_timer_rate being 0 to force calibration if there is no clock.
Remove common_setup_called as it is no longer needed.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
---
Changes from v10
	Reworked to simplify the logic as suggested by Russell King.
Changes from v9
        Updated to work with 3.8 kernel.
Changes from v4, v5, v6, v7, v8
        None.
Changes from v3
        No longer setting *clk to NULL in twd_get_clock().
Changes from v2
        Turned the check for the node pointer into an if-then-else statement.
        Removed the second, redundant clk_get_rate.
Changes from v1
        None.

 arch/arm/kernel/smp_twd.c | 53 +++++++++++++++++------------------------------
 1 file changed, 19 insertions(+), 34 deletions(-)

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 49f335d..ae0c7bb 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -31,7 +31,6 @@ static void __iomem *twd_base;
 
 static struct clk *twd_clk;
 static unsigned long twd_timer_rate;
-static bool common_setup_called;
 static DEFINE_PER_CPU(bool, percpu_setup_called);
 
 static struct clock_event_device __percpu **twd_evt;
@@ -239,25 +238,28 @@ static irqreturn_t twd_handler(int irq, void *dev_id)
 	return IRQ_NONE;
 }
 
-static struct clk *twd_get_clock(void)
+static void twd_get_clock(struct device_node *np)
 {
-	struct clk *clk;
 	int err;
 
-	clk = clk_get_sys("smp_twd", NULL);
-	if (IS_ERR(clk)) {
-		pr_err("smp_twd: clock not found: %d\n", (int)PTR_ERR(clk));
-		return clk;
+	if (np)
+		twd_clk = of_clk_get(np, 0);
+	else
+		twd_clk = clk_get_sys("smp_twd", NULL);
+
+	if (IS_ERR(twd_clk)) {
+		pr_err("smp_twd: clock not found %d\n", (int) PTR_ERR(twd_clk));
+		return;
 	}
 
-	err = clk_prepare_enable(clk);
+	err = clk_prepare_enable(twd_clk);
 	if (err) {
 		pr_err("smp_twd: clock failed to prepare+enable: %d\n", err);
-		clk_put(clk);
-		return ERR_PTR(err);
+		clk_put(twd_clk);
+		return;
 	}
 
-	return clk;
+	twd_timer_rate = clk_get_rate(twd_clk);
 }
 
 /*
@@ -280,26 +282,7 @@ static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
 	}
 	per_cpu(percpu_setup_called, cpu) = true;
 
-	/*
-	 * This stuff only need to be done once for the entire TWD cluster
-	 * during the runtime of the system.
-	 */
-	if (!common_setup_called) {
-		twd_clk = twd_get_clock();
-
-		/*
-		 * We use IS_ERR_OR_NULL() here, because if the clock stubs
-		 * are active we will get a valid clk reference which is
-		 * however NULL and will return the rate 0. In that case we
-		 * need to calibrate the rate instead.
-		 */
-		if (!IS_ERR_OR_NULL(twd_clk))
-			twd_timer_rate = clk_get_rate(twd_clk);
-		else
-			twd_calibrate_rate();
-
-		common_setup_called = true;
-	}
+	twd_calibrate_rate();
 
 	/*
 	 * The following is done once per CPU the first time .setup() is
@@ -330,7 +313,7 @@ static struct local_timer_ops twd_lt_ops __cpuinitdata = {
 	.stop	= twd_timer_stop,
 };
 
-static int __init twd_local_timer_common_register(void)
+static int __init twd_local_timer_common_register(struct device_node *np)
 {
 	int err;
 
@@ -350,6 +333,8 @@ static int __init twd_local_timer_common_register(void)
 	if (err)
 		goto out_irq;
 
+	twd_get_clock(np);
+
 	return 0;
 
 out_irq:
@@ -373,7 +358,7 @@ int __init twd_local_timer_register(struct twd_local_timer *tlt)
 	if (!twd_base)
 		return -ENOMEM;
 
-	return twd_local_timer_common_register();
+	return twd_local_timer_common_register(NULL);
 }
 
 #ifdef CONFIG_OF
@@ -405,7 +390,7 @@ void __init twd_local_timer_of_register(void)
 		goto out;
 	}
 
-	err = twd_local_timer_common_register();
+	err = twd_local_timer_common_register(np);
 
 out:
 	WARN(err, "twd_local_timer_of_register failed (%d)\n", err);
-- 
1.7.11.7

