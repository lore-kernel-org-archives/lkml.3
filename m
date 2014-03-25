Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbaCYWt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:49:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49904 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751476AbaCYWtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:49:23 -0400
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
Subject: [PATCH v5 14/14] ARM: mvebu: register the cpuidle driver for the Armada XP SoCs
Date: Tue, 25 Mar 2014 23:48:25 +0100
Message-Id: <1395787705-31061-15-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com>
References: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpuidle is a platform driver so we register the device just after
the initialization of the board in an arch_initcall.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/mach-mvebu/pmsu.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
index 5812ff4a9b63..fa611594b65a 100644
--- a/arch/arm/mach-mvebu/pmsu.c
+++ b/arch/arm/mach-mvebu/pmsu.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/of_address.h>
 #include <linux/io.h>
+#include <linux/platform_device.h>
 #include <linux/smp.h>
 #include <asm/cacheflush.h>
 #include <asm/cp15.h>
@@ -65,6 +66,10 @@ static void __iomem *pmsu_reset_base;
 extern void ll_disable_coherency(void);
 extern void ll_enable_coherency(void);
 
+static struct platform_device armada_xp_cpuidle_device = {
+	.name = "cpuidle-armada-370-xp",
+};
+
 static struct of_device_id of_pmsu_table[] = {
 	{
 		.compatible = "marvell,armada-370-pmsu",
@@ -285,4 +290,21 @@ static struct notifier_block armada_370_xp_cpu_pm_notifier = {
 	.notifier_call = armada_370_xp_cpu_pm_notify,
 };
 
+int __init armada_370_xp_cpu_pm_init(void)
+{
+	if (!((of_find_compatible_node(NULL, NULL, "marvell,armada-370-xp-pmsu") ||
+				of_find_compatible_node(NULL, NULL, "marvell,armada-370-pmsu"))
+			&& of_find_compatible_node(NULL, NULL, "marvell,coherency-fabric")
+			&& of_machine_is_compatible("marvell,armadaxp")))
+		return 0;
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

