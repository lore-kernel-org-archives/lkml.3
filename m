Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3ILLZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:25:27 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10138 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab3ILLZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:25:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 12 Sep 2013 04:22:16 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: <rjw@sisk.pl>, <viresh.kumar@linaro.org>, <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Bill Huang <bilhuang@nvidia.com>
Subject: [PATCH v2 1/4] cpufreq: tegra: Call tegra_cpufreq_init() specifically in machine code
Date: Thu, 12 Sep 2013 04:24:48 -0700
Message-ID: <1378985091-9447-2-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378985091-9447-1-git-send-email-bilhuang@nvidia.com>
References: <1378985091-9447-1-git-send-email-bilhuang@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the call from module_init to Tegra machine codes so it won't be
called in a multi-platform kernel running on non-Tegra SoCs.

Signed-off-by: Bill Huang <bilhuang@nvidia.com>
---
 arch/arm/mach-tegra/common.c    |    2 ++
 drivers/cpufreq/tegra-cpufreq.c |   13 ++-----------
 include/linux/tegra-soc.h       |   11 ++++++++++-
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 94a119a..db4414e 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -25,6 +25,7 @@
 #include <linux/reboot.h>
 #include <linux/irqchip.h>
 #include <linux/clk-provider.h>
+#include <linux/tegra-soc.h>
 
 #include <asm/hardware/cache-l2x0.h>
 
@@ -109,6 +110,7 @@ void __init tegra_init_early(void)
 
 void __init tegra_init_late(void)
 {
+	tegra_cpufreq_init();
 	tegra_init_suspend();
 	tegra_cpuidle_init();
 	tegra_powergate_debugfs_init();
diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index a7b876f..09c5af0 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -253,7 +253,7 @@ static struct cpufreq_driver tegra_cpufreq_driver = {
 	.attr		= tegra_cpufreq_attr,
 };
 
-static int __init tegra_cpufreq_init(void)
+int __init tegra_cpufreq_init(void)
 {
 	cpu_clk = clk_get_sys(NULL, "cclk");
 	if (IS_ERR(cpu_clk))
@@ -275,17 +275,8 @@ static int __init tegra_cpufreq_init(void)
 
 	return cpufreq_register_driver(&tegra_cpufreq_driver);
 }
-
-static void __exit tegra_cpufreq_exit(void)
-{
-        cpufreq_unregister_driver(&tegra_cpufreq_driver);
-	clk_put(emc_clk);
-	clk_put(cpu_clk);
-}
-
+EXPORT_SYMBOL(tegra_cpufreq_init);
 
 MODULE_AUTHOR("Colin Cross <ccross@android.com>");
 MODULE_DESCRIPTION("cpufreq driver for Nvidia Tegra2");
 MODULE_LICENSE("GPL");
-module_init(tegra_cpufreq_init);
-module_exit(tegra_cpufreq_exit);
diff --git a/include/linux/tegra-soc.h b/include/linux/tegra-soc.h
index 95f611d..d86d081 100644
--- a/include/linux/tegra-soc.h
+++ b/include/linux/tegra-soc.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+ * Copyright (c) 2012,2013, NVIDIA CORPORATION.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -19,4 +19,13 @@
 
 u32 tegra_read_chipid(void);
 
+#ifdef CONFIG_ARM_TEGRA_CPUFREQ
+int tegra_cpufreq_init(void);
+#else
+static inline int tegra_cpufreq_init(void)
+{
+	return -EINVAL;
+}
+#endif
+
 #endif /* __LINUX_TEGRA_SOC_H_ */
-- 
1.7.9.5

