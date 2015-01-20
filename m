Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbbATRZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:25:28 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:39405 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbbATRZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:25:27 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liviu Dudau <liviu.dudau@arm.com>, Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] mfd: vexpress: Remove non-DT code
Date: Tue, 20 Jan 2015 17:25:15 +0000
Message-Id: <1421774715-29926-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, as all VE platforms have to be booted with DT,
the code handling non-DT case can be removed.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/mfd/vexpress-sysreg.c | 71 +++++++++----------------------------------
 1 file changed, 15 insertions(+), 56 deletions(-)

diff --git a/drivers/mfd/vexpress-sysreg.c b/drivers/mfd/vexpress-sysreg.c
index 8f43ab8..3e628df 100644
--- a/drivers/mfd/vexpress-sysreg.c
+++ b/drivers/mfd/vexpress-sysreg.c
@@ -47,71 +47,26 @@
 #define SYS_HBI_MASK		0xfff
 #define SYS_PROCIDx_HBI_SHIFT	0
 
-#define SYS_MCI_CARDIN		(1 << 0)
-#define SYS_MCI_WPROT		(1 << 1)
-
 #define SYS_MISC_MASTERSITE	(1 << 14)
 
-
-static void __iomem *__vexpress_sysreg_base;
-
-static void __iomem *vexpress_sysreg_base(void)
+void vexpress_flags_set(u32 data)
 {
-	if (!__vexpress_sysreg_base) {
+	static void __iomem *base;
+
+	if (!base) {
 		struct device_node *node = of_find_compatible_node(NULL, NULL,
 				"arm,vexpress-sysreg");
 
-		__vexpress_sysreg_base = of_iomap(node, 0);
+		base = of_iomap(node, 0);
 	}
 
-	WARN_ON(!__vexpress_sysreg_base);
-
-	return __vexpress_sysreg_base;
-}
-
-
-static int vexpress_sysreg_get_master(void)
-{
-	if (readl(vexpress_sysreg_base() + SYS_MISC) & SYS_MISC_MASTERSITE)
-		return VEXPRESS_SITE_DB2;
-
-	return VEXPRESS_SITE_DB1;
-}
-
-void vexpress_flags_set(u32 data)
-{
-	writel(~0, vexpress_sysreg_base() + SYS_FLAGSCLR);
-	writel(data, vexpress_sysreg_base() + SYS_FLAGSSET);
-}
-
-unsigned int vexpress_get_mci_cardin(struct device *dev)
-{
-	return readl(vexpress_sysreg_base() + SYS_MCI) & SYS_MCI_CARDIN;
-}
-
-u32 vexpress_get_procid(int site)
-{
-	if (site == VEXPRESS_SITE_MASTER)
-		site = vexpress_sysreg_get_master();
+	if (WARN_ON(!base))
+		return;
 
-	return readl(vexpress_sysreg_base() + (site == VEXPRESS_SITE_DB1 ?
-			SYS_PROCID0 : SYS_PROCID1));
+	writel(~0, base + SYS_FLAGSCLR);
+	writel(data, base + SYS_FLAGSSET);
 }
 
-void __iomem *vexpress_get_24mhz_clock_base(void)
-{
-	return vexpress_sysreg_base() + SYS_24MHZ;
-}
-
-
-void __init vexpress_sysreg_early_init(void __iomem *base)
-{
-	__vexpress_sysreg_base = base;
-
-	vexpress_config_set_master(vexpress_sysreg_get_master());
-}
-
-
 /* The sysreg block is just a random collection of various functions... */
 
 static struct syscon_platform_data vexpress_sysreg_sys_id_pdata = {
@@ -210,6 +165,7 @@ static int vexpress_sysreg_probe(struct platform_device *pdev)
 	struct resource *mem;
 	void __iomem *base;
 	struct bgpio_chip *mmc_gpio_chip;
+	int master;
 	u32 dt_hbi;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -220,11 +176,14 @@ static int vexpress_sysreg_probe(struct platform_device *pdev)
 	if (!base)
 		return -ENOMEM;
 
-	vexpress_config_set_master(vexpress_sysreg_get_master());
+	master = readl(base + SYS_MISC) & SYS_MISC_MASTERSITE ?
+			VEXPRESS_SITE_DB2 : VEXPRESS_SITE_DB1;
+	vexpress_config_set_master(master);
 
 	/* Confirm board type against DT property, if available */
 	if (of_property_read_u32(of_root, "arm,hbi", &dt_hbi) == 0) {
-		u32 id = vexpress_get_procid(VEXPRESS_SITE_MASTER);
+		u32 id = readl(base + (master == VEXPRESS_SITE_DB1 ?
+				 SYS_PROCID0 : SYS_PROCID1));
 		u32 hbi = (id >> SYS_PROCIDx_HBI_SHIFT) & SYS_HBI_MASK;
 
 		if (WARN_ON(dt_hbi != hbi))
-- 
2.1.0

