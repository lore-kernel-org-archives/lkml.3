Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278Ab3DBLo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:44:28 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:37122 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760957Ab3DBLoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:44:25 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 1/3] media: davinci: vpss: enable vpss clocks
Date: Tue,  2 Apr 2013 17:14:02 +0530
Message-Id: <1364903044-13752-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1364903044-13752-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1364903044-13752-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

By default the VPSS clocks were enabled in capture driver
for davinci family which creates duplicates for dm355/dm365/dm644x.
This patch adds support to enable the VPSS clocks in VPSS driver,
which avoids duplication of code and also adding clock aliases.

This patch uses PM runtime API to enable/disable instead common clock
framework. con_ids for master and slave clocks of vpss is added in pm_domain
for pm runtime to clock handling.

This patch cleanups the VPSS clock enabling in the capture driver,
and also removes the clock alias in machine file. Along side adds
a vpss slave clock for DM365 as mentioned by Sekhar
(https://patchwork.kernel.org/patch/1221261/).

The Suspend/Resume in dm644x_ccdc.c which enabled/disabled the VPSS clock
is now implemented as part of the VPSS driver.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/mach-davinci/dm355.c                |    7 +---
 arch/arm/mach-davinci/dm365.c                |   11 +++++--
 arch/arm/mach-davinci/dm644x.c               |    9 +----
 arch/arm/mach-davinci/pm_domain.c            |    2 +-
 drivers/media/platform/davinci/dm355_ccdc.c  |   39 +----------------------
 drivers/media/platform/davinci/dm644x_ccdc.c |   44 --------------------------
 drivers/media/platform/davinci/isif.c        |   28 ++--------------
 drivers/media/platform/davinci/vpss.c        |   25 ++++++++++++++
 8 files changed, 43 insertions(+), 122 deletions(-)

diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index b49c3b7..8e98bb0 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -345,8 +345,8 @@ static struct clk_lookup dm355_clks[] = {
 	CLK(NULL, "pll1_aux", &pll1_aux_clk),
 	CLK(NULL, "pll1_sysclkbp", &pll1_sysclkbp),
 	CLK(NULL, "vpss_dac", &vpss_dac_clk),
-	CLK(NULL, "vpss_master", &vpss_master_clk),
-	CLK(NULL, "vpss_slave", &vpss_slave_clk),
+	CLK("vpss", "master", &vpss_master_clk),
+	CLK("vpss", "slave", &vpss_slave_clk),
 	CLK(NULL, "clkout1", &clkout1_clk),
 	CLK(NULL, "clkout2", &clkout2_clk),
 	CLK(NULL, "pll2", &pll2_clk),
@@ -873,9 +873,6 @@ static int __init dm355_init_devices(void)
 	if (!cpu_is_davinci_dm355())
 		return 0;
 
-	/* Add ccdc clock aliases */
-	clk_add_alias("master", dm355_ccdc_dev.name, "vpss_master", NULL);
-	clk_add_alias("slave", dm355_ccdc_dev.name, "vpss_master", NULL);
 	davinci_cfg_reg(DM355_INT_EDMA_CC);
 	platform_device_register(&dm355_edma_device);
 	platform_device_register(&dm355_vpss_device);
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 6c39805..c61dd94 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -257,6 +257,12 @@ static struct clk vpss_master_clk = {
 	.flags		= CLK_PSC,
 };
 
+static struct clk vpss_slave_clk = {
+	.name		= "vpss_slave",
+	.parent		= &pll1_sysclk5,
+	.lpsc		= DAVINCI_LPSC_VPSSSLV,
+};
+
 static struct clk arm_clk = {
 	.name		= "arm_clk",
 	.parent		= &pll2_sysclk2,
@@ -449,7 +455,8 @@ static struct clk_lookup dm365_clks[] = {
 	CLK(NULL, "pll2_sysclk8", &pll2_sysclk8),
 	CLK(NULL, "pll2_sysclk9", &pll2_sysclk9),
 	CLK(NULL, "vpss_dac", &vpss_dac_clk),
-	CLK(NULL, "vpss_master", &vpss_master_clk),
+	CLK("vpss", "master", &vpss_master_clk),
+	CLK("vpss", "slave", &vpss_slave_clk),
 	CLK(NULL, "arm", &arm_clk),
 	CLK(NULL, "uart0", &uart0_clk),
 	CLK(NULL, "uart1", &uart1_clk),
@@ -1239,8 +1246,6 @@ static int __init dm365_init_devices(void)
 	clk_add_alias(NULL, dev_name(&dm365_mdio_device.dev),
 		      NULL, &dm365_emac_device.dev);
 
-	/* Add isif clock alias */
-	clk_add_alias("master", dm365_isif_dev.name, "vpss_master", NULL);
 	platform_device_register(&dm365_vpss_device);
 	platform_device_register(&dm365_isif_dev);
 	platform_device_register(&vpfe_capture_dev);
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index ee0e994..c2a9273 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -300,8 +300,8 @@ static struct clk_lookup dm644x_clks[] = {
 	CLK(NULL, "dsp", &dsp_clk),
 	CLK(NULL, "arm", &arm_clk),
 	CLK(NULL, "vicp", &vicp_clk),
-	CLK(NULL, "vpss_master", &vpss_master_clk),
-	CLK(NULL, "vpss_slave", &vpss_slave_clk),
+	CLK("vpss", "master", &vpss_master_clk),
+	CLK("vpss", "slave", &vpss_slave_clk),
 	CLK(NULL, "arm", &arm_clk),
 	CLK(NULL, "uart0", &uart0_clk),
 	CLK(NULL, "uart1", &uart1_clk),
@@ -901,11 +901,6 @@ int __init dm644x_init_video(struct vpfe_config *vpfe_cfg,
 		dm644x_vpfe_dev.dev.platform_data = vpfe_cfg;
 		platform_device_register(&dm644x_ccdc_dev);
 		platform_device_register(&dm644x_vpfe_dev);
-		/* Add ccdc clock aliases */
-		clk_add_alias("master", dm644x_ccdc_dev.name,
-			      "vpss_master", NULL);
-		clk_add_alias("slave", dm644x_ccdc_dev.name,
-			      "vpss_slave", NULL);
 	}
 
 	if (vpbe_cfg) {
diff --git a/arch/arm/mach-davinci/pm_domain.c b/arch/arm/mach-davinci/pm_domain.c
index c90250e..445b10b 100644
--- a/arch/arm/mach-davinci/pm_domain.c
+++ b/arch/arm/mach-davinci/pm_domain.c
@@ -53,7 +53,7 @@ static struct dev_pm_domain davinci_pm_domain = {
 
 static struct pm_clk_notifier_block platform_bus_notifier = {
 	.pm_domain = &davinci_pm_domain,
-	.con_ids = { "fck", NULL, },
+	.con_ids = { "fck", "master", "slave", NULL, },
 };
 
 static int __init davinci_pm_runtime_init(void)
diff --git a/drivers/media/platform/davinci/dm355_ccdc.c b/drivers/media/platform/davinci/dm355_ccdc.c
index 2364dba..05f8fb7 100644
--- a/drivers/media/platform/davinci/dm355_ccdc.c
+++ b/drivers/media/platform/davinci/dm355_ccdc.c
@@ -37,7 +37,6 @@
 #include <linux/platform_device.h>
 #include <linux/uaccess.h>
 #include <linux/videodev2.h>
-#include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/module.h>
 
@@ -59,10 +58,6 @@ static struct ccdc_oper_config {
 	struct ccdc_params_raw bayer;
 	/* YCbCr configuration */
 	struct ccdc_params_ycbcr ycbcr;
-	/* Master clock */
-	struct clk *mclk;
-	/* slave clock */
-	struct clk *sclk;
 	/* ccdc base address */
 	void __iomem *base_addr;
 } ccdc_cfg = {
@@ -997,32 +992,10 @@ static int dm355_ccdc_probe(struct platform_device *pdev)
 		goto fail_nomem;
 	}
 
-	/* Get and enable Master clock */
-	ccdc_cfg.mclk = clk_get(&pdev->dev, "master");
-	if (IS_ERR(ccdc_cfg.mclk)) {
-		status = PTR_ERR(ccdc_cfg.mclk);
-		goto fail_nomap;
-	}
-	if (clk_prepare_enable(ccdc_cfg.mclk)) {
-		status = -ENODEV;
-		goto fail_mclk;
-	}
-
-	/* Get and enable Slave clock */
-	ccdc_cfg.sclk = clk_get(&pdev->dev, "slave");
-	if (IS_ERR(ccdc_cfg.sclk)) {
-		status = PTR_ERR(ccdc_cfg.sclk);
-		goto fail_mclk;
-	}
-	if (clk_prepare_enable(ccdc_cfg.sclk)) {
-		status = -ENODEV;
-		goto fail_sclk;
-	}
-
 	/* Platform data holds setup_pinmux function ptr */
 	if (NULL == pdev->dev.platform_data) {
 		status = -ENODEV;
-		goto fail_sclk;
+		goto fail_nomap;
 	}
 	setup_pinmux = pdev->dev.platform_data;
 	/*
@@ -1033,12 +1006,6 @@ static int dm355_ccdc_probe(struct platform_device *pdev)
 	ccdc_cfg.dev = &pdev->dev;
 	printk(KERN_NOTICE "%s is registered with vpfe.\n", ccdc_hw_dev.name);
 	return 0;
-fail_sclk:
-	clk_disable_unprepare(ccdc_cfg.sclk);
-	clk_put(ccdc_cfg.sclk);
-fail_mclk:
-	clk_disable_unprepare(ccdc_cfg.mclk);
-	clk_put(ccdc_cfg.mclk);
 fail_nomap:
 	iounmap(ccdc_cfg.base_addr);
 fail_nomem:
@@ -1052,10 +1019,6 @@ static int dm355_ccdc_remove(struct platform_device *pdev)
 {
 	struct resource	*res;
 
-	clk_disable_unprepare(ccdc_cfg.sclk);
-	clk_disable_unprepare(ccdc_cfg.mclk);
-	clk_put(ccdc_cfg.mclk);
-	clk_put(ccdc_cfg.sclk);
 	iounmap(ccdc_cfg.base_addr);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res)
diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
index 971d639..30fa084 100644
--- a/drivers/media/platform/davinci/dm644x_ccdc.c
+++ b/drivers/media/platform/davinci/dm644x_ccdc.c
@@ -38,7 +38,6 @@
 #include <linux/uaccess.h>
 #include <linux/videodev2.h>
 #include <linux/gfp.h>
-#include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/module.h>
 
@@ -60,10 +59,6 @@ static struct ccdc_oper_config {
 	struct ccdc_params_raw bayer;
 	/* YCbCr configuration */
 	struct ccdc_params_ycbcr ycbcr;
-	/* Master clock */
-	struct clk *mclk;
-	/* slave clock */
-	struct clk *sclk;
 	/* ccdc base address */
 	void __iomem *base_addr;
 } ccdc_cfg = {
@@ -991,38 +986,9 @@ static int dm644x_ccdc_probe(struct platform_device *pdev)
 		goto fail_nomem;
 	}
 
-	/* Get and enable Master clock */
-	ccdc_cfg.mclk = clk_get(&pdev->dev, "master");
-	if (IS_ERR(ccdc_cfg.mclk)) {
-		status = PTR_ERR(ccdc_cfg.mclk);
-		goto fail_nomap;
-	}
-	if (clk_prepare_enable(ccdc_cfg.mclk)) {
-		status = -ENODEV;
-		goto fail_mclk;
-	}
-
-	/* Get and enable Slave clock */
-	ccdc_cfg.sclk = clk_get(&pdev->dev, "slave");
-	if (IS_ERR(ccdc_cfg.sclk)) {
-		status = PTR_ERR(ccdc_cfg.sclk);
-		goto fail_mclk;
-	}
-	if (clk_prepare_enable(ccdc_cfg.sclk)) {
-		status = -ENODEV;
-		goto fail_sclk;
-	}
 	ccdc_cfg.dev = &pdev->dev;
 	printk(KERN_NOTICE "%s is registered with vpfe.\n", ccdc_hw_dev.name);
 	return 0;
-fail_sclk:
-	clk_disable_unprepare(ccdc_cfg.sclk);
-	clk_put(ccdc_cfg.sclk);
-fail_mclk:
-	clk_disable_unprepare(ccdc_cfg.mclk);
-	clk_put(ccdc_cfg.mclk);
-fail_nomap:
-	iounmap(ccdc_cfg.base_addr);
 fail_nomem:
 	release_mem_region(res->start, resource_size(res));
 fail_nores:
@@ -1034,10 +1000,6 @@ static int dm644x_ccdc_remove(struct platform_device *pdev)
 {
 	struct resource	*res;
 
-	clk_disable_unprepare(ccdc_cfg.mclk);
-	clk_disable_unprepare(ccdc_cfg.sclk);
-	clk_put(ccdc_cfg.mclk);
-	clk_put(ccdc_cfg.sclk);
 	iounmap(ccdc_cfg.base_addr);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res)
@@ -1052,18 +1014,12 @@ static int dm644x_ccdc_suspend(struct device *dev)
 	ccdc_save_context();
 	/* Disable CCDC */
 	ccdc_enable(0);
-	/* Disable both master and slave clock */
-	clk_disable_unprepare(ccdc_cfg.mclk);
-	clk_disable_unprepare(ccdc_cfg.sclk);
 
 	return 0;
 }
 
 static int dm644x_ccdc_resume(struct device *dev)
 {
-	/* Enable both master and slave clock */
-	clk_prepare_enable(ccdc_cfg.mclk);
-	clk_prepare_enable(ccdc_cfg.sclk);
 	/* Restore CCDC context */
 	ccdc_restore_context();
 
diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c
index abc3ae3..3332cca 100644
--- a/drivers/media/platform/davinci/isif.c
+++ b/drivers/media/platform/davinci/isif.c
@@ -32,7 +32,6 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/videodev2.h>
-#include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/module.h>
 
@@ -88,8 +87,6 @@ static struct isif_oper_config {
 	struct isif_ycbcr_config ycbcr;
 	struct isif_params_raw bayer;
 	enum isif_data_pack data_pack;
-	/* Master clock */
-	struct clk *mclk;
 	/* ISIF base address */
 	void __iomem *base_addr;
 	/* ISIF Linear Table 0 */
@@ -1039,6 +1036,10 @@ static int isif_probe(struct platform_device *pdev)
 	void *__iomem addr;
 	int status = 0, i;
 
+	/* Platform data holds setup_pinmux function ptr */
+	if (!pdev->dev.platform_data)
+		return -ENODEV;
+
 	/*
 	 * first try to register with vpfe. If not correct platform, then we
 	 * don't have to iomap
@@ -1047,22 +1048,6 @@ static int isif_probe(struct platform_device *pdev)
 	if (status < 0)
 		return status;
 
-	/* Get and enable Master clock */
-	isif_cfg.mclk = clk_get(&pdev->dev, "master");
-	if (IS_ERR(isif_cfg.mclk)) {
-		status = PTR_ERR(isif_cfg.mclk);
-		goto fail_mclk;
-	}
-	if (clk_prepare_enable(isif_cfg.mclk)) {
-		status = -ENODEV;
-		goto fail_mclk;
-	}
-
-	/* Platform data holds setup_pinmux function ptr */
-	if (NULL == pdev->dev.platform_data) {
-		status = -ENODEV;
-		goto fail_mclk;
-	}
 	setup_pinmux = pdev->dev.platform_data;
 	/*
 	 * setup Mux configuration for ccdc which may be different for
@@ -1124,9 +1109,6 @@ fail_nobase_res:
 		release_mem_region(res->start, resource_size(res));
 		i--;
 	}
-fail_mclk:
-	clk_disable_unprepare(isif_cfg.mclk);
-	clk_put(isif_cfg.mclk);
 	vpfe_unregister_ccdc_device(&isif_hw_dev);
 	return status;
 }
@@ -1146,8 +1128,6 @@ static int isif_remove(struct platform_device *pdev)
 		i++;
 	}
 	vpfe_unregister_ccdc_device(&isif_hw_dev);
-	clk_disable_unprepare(isif_cfg.mclk);
-	clk_put(isif_cfg.mclk);
 	return 0;
 }
 
diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index a19c552..d36429d 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -25,6 +25,8 @@
 #include <linux/spinlock.h>
 #include <linux/compiler.h>
 #include <linux/io.h>
+#include <linux/pm_runtime.h>
+
 #include <media/davinci/vpss.h>
 
 MODULE_LICENSE("GPL");
@@ -490,6 +492,10 @@ static int vpss_probe(struct platform_device *pdev)
 	} else
 		oper_cfg.hw_ops.clear_wbl_overflow = dm644x_clear_wbl_overflow;
 
+	pm_runtime_enable(&pdev->dev);
+
+	pm_runtime_get(&pdev->dev);
+
 	spin_lock_init(&oper_cfg.vpss_lock);
 	dev_info(&pdev->dev, "%s vpss probe success\n", platform_name);
 	return 0;
@@ -507,6 +513,7 @@ static int vpss_remove(struct platform_device *pdev)
 {
 	struct resource		*res;
 
+	pm_runtime_disable(&pdev->dev);
 	iounmap(oper_cfg.vpss_regs_base0);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(res->start, resource_size(res));
@@ -518,10 +525,28 @@ static int vpss_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int vpss_suspend(struct device *dev)
+{
+	pm_runtime_put(dev);
+	return 0;
+}
+
+static int vpss_resume(struct device *dev)
+{
+	pm_runtime_get(dev);
+	return 0;
+}
+
+static const struct dev_pm_ops vpss_pm_ops = {
+	.suspend = vpss_suspend,
+	.resume = vpss_resume,
+};
+
 static struct platform_driver vpss_driver = {
 	.driver = {
 		.name	= "vpss",
 		.owner = THIS_MODULE,
+		.pm = &vpss_pm_ops,
 	},
 	.remove = vpss_remove,
 	.probe = vpss_probe,
-- 
1.7.4.1

