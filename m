Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab3LEHon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 02:44:43 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15446 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab3LEHod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 02:44:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 04 Dec 2013 23:41:31 -0800
From: Bill Huang <bilhuang@nvidia.com>
To: <rjw@rjwysocki.net>, <viresh.kumar@linaro.org>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Bill Huang <bilhuang@nvidia.com>
Subject: [PATCH v3 1/2] cpufreq: tegra: Call tegra_cpufreq_init() specifically in machine code
Date: Thu, 5 Dec 2013 15:44:21 +0800
Message-ID: <1386229462-3474-2-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com>
References: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com>
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
 arch/arm/mach-tegra/tegra.c     |    2 ++
 drivers/cpufreq/tegra-cpufreq.c |   13 ++-----------
 include/linux/tegra-soc.h       |   11 ++++++++++-
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c
index 7336817..14490ad 100644
--- a/arch/arm/mach-tegra/tegra.c
+++ b/arch/arm/mach-tegra/tegra.c
@@ -34,6 +34,7 @@
 #include <linux/usb/tegra_usb_phy.h>
 #include <linux/clk/tegra.h>
 #include <linux/irqchip.h>
+#include <linux/tegra-soc.h>
 
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/mach-types.h>
@@ -160,6 +161,7 @@ static void __init tegra_dt_init_late(void)
 {
 	int i;
 
+	tegra_cpufreq_init();
 	tegra_init_suspend();
 	tegra_cpuidle_init();
 	tegra_powergate_debugfs_init();
diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index 63f0059..ae1c0f1 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -155,7 +155,7 @@ static struct cpufreq_driver tegra_cpufreq_driver = {
 #endif
 };
 
-static int __init tegra_cpufreq_init(void)
+int __init tegra_cpufreq_init(void)
 {
 	cpu_clk = clk_get_sys(NULL, "cclk");
 	if (IS_ERR(cpu_clk))
@@ -177,17 +177,8 @@ static int __init tegra_cpufreq_init(void)
 
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
index 95f611d..a179aa5 100644
--- a/include/linux/tegra-soc.h
+++ b/include/linux/tegra-soc.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+ * Copyright (c) 2012,2013, NVIDIA CORPORATION.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -17,6 +17,15 @@
 #ifndef __LINUX_TEGRA_SOC_H_
 #define __LINUX_TEGRA_SOC_H_
 
+#ifdef CONFIG_ARM_TEGRA_CPUFREQ
+int tegra_cpufreq_init(void);
+#else
+static inline int tegra_cpufreq_init(void)
+{
+	return -EINVAL;
+}
+#endif
+
 u32 tegra_read_chipid(void);
 
 #endif /* __LINUX_TEGRA_SOC_H_ */
-- 
1.7.9.5

