Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab3HVMvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 08:51:50 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:55613 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753517Ab3HVMvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 08:51:36 -0400
From: Jisheng Zhang <jszhang@marvell.com>
To: <jszhang@marvell.com>, <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>,
        <ezequiel.garcia@free-electrons.com>, <mturquette@linaro.org>,
        <sebastian.hesselbarth@gmail.com>, <linus.walleij@linaro.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] clk: mvebu: add missing iounmap
Date: Thu, 22 Aug 2013 20:46:50 +0800
Message-ID: <1377175611-4241-4-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377175611-4241-1-git-send-email-jszhang@marvell.com>
References: <1377175611-4241-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing iounmap to setup error path.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 drivers/clk/mvebu/clk-cpu.c |  4 +++-
 drivers/clk/mvebu/common.c  | 18 ++++++++++++------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/mvebu/clk-cpu.c b/drivers/clk/mvebu/clk-cpu.c
index b0fbc07..1466865 100644
--- a/drivers/clk/mvebu/clk-cpu.c
+++ b/drivers/clk/mvebu/clk-cpu.c
@@ -119,7 +119,7 @@ void __init of_cpu_clk_setup(struct device_node *node)
 
 	cpuclk = kzalloc(ncpus * sizeof(*cpuclk), GFP_KERNEL);
 	if (WARN_ON(!cpuclk))
-		return;
+		goto cpuclk_out;
 
 	clks = kzalloc(ncpus * sizeof(*clks), GFP_KERNEL);
 	if (WARN_ON(!clks))
@@ -170,6 +170,8 @@ bail_out:
 		kfree(cpuclk[ncpus].clk_name);
 clks_out:
 	kfree(cpuclk);
+cpuclk_out:
+	iounmap(clock_complex_base);
 }
 
 CLK_OF_DECLARE(armada_xp_cpu_clock, "marvell,armada-xp-cpu-clock",
diff --git a/drivers/clk/mvebu/common.c b/drivers/clk/mvebu/common.c
index adaa4a1..6b415f9 100644
--- a/drivers/clk/mvebu/common.c
+++ b/drivers/clk/mvebu/common.c
@@ -45,8 +45,10 @@ void __init mvebu_coreclk_setup(struct device_node *np,
 	clk_data.clk_num = 2 + desc->num_ratios;
 	clk_data.clks = kzalloc(clk_data.clk_num * sizeof(struct clk *),
 				GFP_KERNEL);
-	if (WARN_ON(!clk_data.clks))
+	if (WARN_ON(!clk_data.clks)) {
+		iounmap(base);
 		return;
+	}
 
 	/* Register TCLK */
 	of_property_read_string_index(np, "clock-output-names", 0,
@@ -134,7 +136,7 @@ void __init mvebu_clk_gating_setup(struct device_node *np,
 
 	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
 	if (WARN_ON(!ctrl))
-		return;
+		goto ctrl_out;
 
 	spin_lock_init(&ctrl->lock);
 
@@ -145,10 +147,8 @@ void __init mvebu_clk_gating_setup(struct device_node *np,
 	ctrl->num_gates = n;
 	ctrl->gates = kzalloc(ctrl->num_gates * sizeof(struct clk *),
 			      GFP_KERNEL);
-	if (WARN_ON(!ctrl->gates)) {
-		kfree(ctrl);
-		return;
-	}
+	if (WARN_ON(!ctrl->gates))
+		goto bail_out;
 
 	for (n = 0; n < ctrl->num_gates; n++) {
 		const char *parent =
@@ -160,4 +160,10 @@ void __init mvebu_clk_gating_setup(struct device_node *np,
 	}
 
 	of_clk_add_provider(np, clk_gating_get_src, ctrl);
+
+	return;
+bail_out:
+	kfree(ctrl);
+ctrl_out:
+	iounmap(base);
 }
-- 
1.8.4.rc3

