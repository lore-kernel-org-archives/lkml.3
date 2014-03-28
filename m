Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaC1LOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:14:46 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35428 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752102AbaC1LOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:14:34 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 11/11] ARM: mvebu: register the cpuidle driver for the Armada XP SoCs
Date: Fri, 28 Mar 2014 12:13:31 +0100
Message-Id: <1396005211-15573-12-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1396005211-15573-1-git-send-email-gregory.clement@free-electrons.com>
References: <1396005211-15573-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpuidle is a platform driver so we register the device just after
the initialization of the board in an arch_initcall.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/mach-mvebu/pmsu.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
index 9ea2bb44d573..e105e33cf3f0 100644
--- a/arch/arm/mach-mvebu/pmsu.c
+++ b/arch/arm/mach-mvebu/pmsu.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/of_address.h>
 #include <linux/io.h>
+#include <linux/platform_device.h>
 #include <linux/smp.h>
 #include <linux/resource.h>
 #include <asm/cacheflush.h>
@@ -65,6 +66,10 @@ static void __iomem *pmsu_mp_base;
 extern void ll_disable_coherency(void);
 extern void ll_enable_coherency(void);
 
+static struct platform_device armada_xp_cpuidle_device = {
+	.name = "cpuidle-armada-370-xp",
+};
+
 static struct of_device_id of_pmsu_table[] = {
 	{ .compatible = "marvell,armada-370-pmsu", },
 	{ .compatible = "marvell,armada-370-xp-pmsu", },
@@ -281,4 +286,36 @@ static struct notifier_block armada_370_xp_cpu_pm_notifier = {
 	.notifier_call = armada_370_xp_cpu_pm_notify,
 };
 
+int __init armada_370_xp_cpu_pm_init(void)
+{
+	struct device_node *np;
+
+	/*
+	 * Check that all the requirements are available to enable
+	 * cpuidle. So far, it is only supported on Armada XP, cpuidle
+	 * needs the coherency fabric and the PMSU enabled
+	 */
+
+	if (!of_machine_is_compatible("marvell,armadaxp"))
+		return 0;
+
+	np = of_find_compatible_node(NULL, NULL, "marvell,coherency-fabric");
+	if (!np)
+		return 0;
+	of_node_put(np);
+
+	np = of_find_matching_node(NULL, of_pmsu_table);
+	if (!np)
+		return 0;
+	of_node_put(np);
+
+	armada_370_xp_pmsu_enable_l2_powerdown_onidle();
+	armada_xp_cpuidle_device.dev.platform_data = armada_370_xp_cpu_suspend;
+	platform_device_register(&armada_xp_cpuidle_device);
+	cpu_pm_register_notifier(&armada_370_xp_cpu_pm_notifier);
+
+	return 0;
+}
+
+arch_initcall(armada_370_xp_cpu_pm_init);
 early_initcall(armada_370_xp_pmsu_init);
-- 
1.8.1.2

