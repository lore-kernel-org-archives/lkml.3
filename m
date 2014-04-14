Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaDNPPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:15:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60754 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754264AbaDNPKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:10:33 -0400
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
Subject: [PATCH v7 10/11] cpuidle: mvebu: Add initial CPU idle support for Armada 370/XP SoC
Date: Mon, 14 Apr 2014 17:10:13 +0200
Message-Id: <1397488214-20685-11-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1397488214-20685-1-git-send-email-gregory.clement@free-electrons.com>
References: <1397488214-20685-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the wfi, cpu idle and cpu deep idle power states support for the
Armada XP SoCs.

All the latencies and the power consumption values used at the
"armada_370_xp_idle_driver" structure are preliminary and will be
modified in the future after running some measurements and analysis.

Based on the work of Nadav Haklai.

Signed-off-by: Nadav Haklai <nadavh@marvell.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/Kconfig.arm             |  5 ++
 drivers/cpuidle/Makefile                |  1 +
 drivers/cpuidle/cpuidle-armada-370-xp.c | 93 +++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+)
 create mode 100644 drivers/cpuidle/cpuidle-armada-370-xp.c

diff --git a/drivers/cpuidle/Kconfig.arm b/drivers/cpuidle/Kconfig.arm
index 97ccc31dbdd8..5bb94780d377 100644
--- a/drivers/cpuidle/Kconfig.arm
+++ b/drivers/cpuidle/Kconfig.arm
@@ -1,6 +1,11 @@
 #
 # ARM CPU Idle drivers
 #
+config ARM_ARMADA_370_XP_CPUIDLE
+	bool "CPU Idle Driver for Armada 370/XP family processors"
+	depends on ARCH_MVEBU
+	help
+	  Select this to enable cpuidle on Armada 370/XP processors.
 
 config ARM_BIG_LITTLE_CPUIDLE
 	bool "Support for ARM big.LITTLE processors"
diff --git a/drivers/cpuidle/Makefile b/drivers/cpuidle/Makefile
index f71ae1b373c5..9902d052bd87 100644
--- a/drivers/cpuidle/Makefile
+++ b/drivers/cpuidle/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
 
 ##################################################################################
 # ARM SoC drivers
+obj-$(CONFIG_ARM_ARMADA_370_XP_CPUIDLE) += cpuidle-armada-370-xp.o
 obj-$(CONFIG_ARM_BIG_LITTLE_CPUIDLE)	+= cpuidle-big_little.o
 obj-$(CONFIG_ARM_HIGHBANK_CPUIDLE)	+= cpuidle-calxeda.o
 obj-$(CONFIG_ARM_KIRKWOOD_CPUIDLE)	+= cpuidle-kirkwood.o
diff --git a/drivers/cpuidle/cpuidle-armada-370-xp.c b/drivers/cpuidle/cpuidle-armada-370-xp.c
new file mode 100644
index 000000000000..28587d0f3947
--- /dev/null
+++ b/drivers/cpuidle/cpuidle-armada-370-xp.c
@@ -0,0 +1,93 @@
+/*
+ * Marvell Armada 370 and Armada XP SoC cpuidle driver
+ *
+ * Copyright (C) 2014 Marvell
+ *
+ * Nadav Haklai <nadavh@marvell.com>
+ * Gregory CLEMENT <gregory.clement@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ *
+ * Maintainer: Gregory CLEMENT <gregory.clement@free-electrons.com>
+ */
+
+#include <linux/cpu_pm.h>
+#include <linux/cpuidle.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/suspend.h>
+#include <linux/platform_device.h>
+#include <asm/cpuidle.h>
+
+#define ARMADA_370_XP_MAX_STATES	3
+#define ARMADA_370_XP_FLAG_DEEP_IDLE	0x10000
+
+static int (*armada_370_xp_cpu_suspend)(int);
+
+static int armada_370_xp_enter_idle(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv,
+				int index)
+{
+	int ret;
+	bool deepidle = false;
+	cpu_pm_enter();
+
+	if (drv->states[index].flags & ARMADA_370_XP_FLAG_DEEP_IDLE)
+		deepidle = true;
+
+	ret = armada_370_xp_cpu_suspend(deepidle);
+	if (ret)
+		return ret;
+
+	cpu_pm_exit();
+
+	return index;
+}
+
+static struct cpuidle_driver armada_370_xp_idle_driver = {
+	.name			= "armada_370_xp_idle",
+	.states[0]		= ARM_CPUIDLE_WFI_STATE,
+	.states[1]		= {
+		.enter			= armada_370_xp_enter_idle,
+		.exit_latency		= 10,
+		.power_usage		= 50,
+		.target_residency	= 100,
+		.flags			= CPUIDLE_FLAG_TIME_VALID,
+		.name			= "MV CPU IDLE",
+		.desc			= "CPU power down",
+	},
+	.states[2]		= {
+		.enter			= armada_370_xp_enter_idle,
+		.exit_latency		= 100,
+		.power_usage		= 5,
+		.target_residency	= 1000,
+		.flags			= CPUIDLE_FLAG_TIME_VALID |
+						ARMADA_370_XP_FLAG_DEEP_IDLE,
+		.name			= "MV CPU DEEP IDLE",
+		.desc			= "CPU and L2 Fabric power down",
+	},
+	.state_count = ARMADA_370_XP_MAX_STATES,
+};
+
+static int armada_370_xp_cpuidle_probe(struct platform_device *pdev)
+{
+
+	armada_370_xp_cpu_suspend = (void *)(pdev->dev.platform_data);
+	return cpuidle_register(&armada_370_xp_idle_driver, NULL);
+}
+
+static struct platform_driver armada_370_xp_cpuidle_plat_driver = {
+	.driver = {
+		.name = "cpuidle-armada-370-xp",
+		.owner = THIS_MODULE,
+	},
+	.probe = armada_370_xp_cpuidle_probe,
+};
+
+module_platform_driver(armada_370_xp_cpuidle_plat_driver);
+
+MODULE_AUTHOR("Gregory CLEMENT <gregory.clement@free-electrons.com>");
+MODULE_DESCRIPTION("Armada 370/XP cpu idle driver");
+MODULE_LICENSE("GPL");
-- 
1.8.1.2

