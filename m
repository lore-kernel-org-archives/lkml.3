Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbaD1T4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:56:46 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:28072 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933062AbaD1Tx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:53:29 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH 09/10] ARM: vexpress: move HBI check to sysreg driver
Date: Mon, 28 Apr 2014 18:57:56 +0100
Message-Id: <1398707877-22596-10-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
References: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last reason for static memory mapping is the HBI (board
identification number) check early in the machine code.

Moving the check to the sysreg driver makes it possible to
completely remove the early mapping and init functions.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 arch/arm/mach-vexpress/v2m.c  | 49 -------------------------------------------
 drivers/mfd/vexpress-sysreg.c | 30 ++++++++++----------------
 include/linux/vexpress.h      |  1 -
 3 files changed, 11 insertions(+), 69 deletions(-)

diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index d8b419b..38f4f6f 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -370,53 +370,6 @@ MACHINE_START(VEXPRESS, "ARM-Versatile Express")
 	.init_machine	= v2m_init,
 MACHINE_END
 
-static struct map_desc v2m_rs1_io_desc __initdata = {
-	.virtual	= V2M_PERIPH,
-	.pfn		= __phys_to_pfn(0x1c000000),
-	.length		= SZ_2M,
-	.type		= MT_DEVICE,
-};
-
-static int __init v2m_dt_scan_memory_map(unsigned long node, const char *uname,
-		int depth, void *data)
-{
-	const char **map = data;
-
-	if (strcmp(uname, "motherboard") != 0)
-		return 0;
-
-	*map = of_get_flat_dt_prop(node, "arm,v2m-memory-map", NULL);
-
-	return 1;
-}
-
-void __init v2m_dt_map_io(void)
-{
-	const char *map = NULL;
-
-	of_scan_flat_dt(v2m_dt_scan_memory_map, &map);
-
-	if (map && strcmp(map, "rs1") == 0)
-		iotable_init(&v2m_rs1_io_desc, 1);
-	else
-		iotable_init(v2m_io_desc, ARRAY_SIZE(v2m_io_desc));
-}
-
-void __init v2m_dt_init_early(void)
-{
-	u32 dt_hbi;
-
-	/* Confirm board type against DT property, if available */
-	if (of_property_read_u32(of_allnodes, "arm,hbi", &dt_hbi) == 0) {
-		u32 hbi = vexpress_get_hbi(VEXPRESS_SITE_MASTER);
-
-		if (WARN_ON(dt_hbi != hbi))
-			pr_warning("vexpress: DT HBI (%x) is not matching "
-					"hardware (%x)!\n", dt_hbi, hbi);
-	}
-}
-
-
 static void __init v2m_dt_init(void)
 {
 	l2x0_of_init(0x00400000, 0xfe0fffff);
@@ -432,7 +385,5 @@ DT_MACHINE_START(VEXPRESS_DT, "ARM-Versatile Express")
 	.dt_compat	= v2m_dt_match,
 	.smp		= smp_ops(vexpress_smp_dt_ops),
 	.smp_init	= smp_init_ops(vexpress_smp_init_ops),
-	.map_io		= v2m_dt_map_io,
-	.init_early	= v2m_dt_init_early,
 	.init_machine	= v2m_dt_init,
 MACHINE_END
diff --git a/drivers/mfd/vexpress-sysreg.c b/drivers/mfd/vexpress-sysreg.c
index 952df84..9e21e4f 100644
--- a/drivers/mfd/vexpress-sysreg.c
+++ b/drivers/mfd/vexpress-sysreg.c
@@ -45,7 +45,6 @@
 #define SYS_CFGSTAT		0x0a8
 
 #define SYS_HBI_MASK		0xfff
-#define SYS_ID_HBI_SHIFT	16
 #define SYS_PROCIDx_HBI_SHIFT	0
 
 #define SYS_MCI_CARDIN		(1 << 0)
@@ -99,24 +98,6 @@ u32 vexpress_get_procid(int site)
 			SYS_PROCID0 : SYS_PROCID1));
 }
 
-u32 vexpress_get_hbi(int site)
-{
-	u32 id;
-
-	switch (site) {
-	case VEXPRESS_SITE_MB:
-		id = readl(vexpress_sysreg_base() + SYS_ID);
-		return (id >> SYS_ID_HBI_SHIFT) & SYS_HBI_MASK;
-	case VEXPRESS_SITE_MASTER:
-	case VEXPRESS_SITE_DB1:
-	case VEXPRESS_SITE_DB2:
-		id = vexpress_get_procid(site);
-		return (id >> SYS_PROCIDx_HBI_SHIFT) & SYS_HBI_MASK;
-	}
-
-	return ~0;
-}
-
 void __iomem *vexpress_get_24mhz_clock_base(void)
 {
 	return vexpress_sysreg_base() + SYS_24MHZ;
@@ -229,6 +210,7 @@ static int vexpress_sysreg_probe(struct platform_device *pdev)
 	struct resource *mem;
 	void __iomem *base;
 	struct bgpio_chip *mmc_gpio_chip;
+	u32 dt_hbi;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mem)
@@ -240,6 +222,16 @@ static int vexpress_sysreg_probe(struct platform_device *pdev)
 
 	vexpress_config_set_master(vexpress_sysreg_get_master());
 
+	/* Confirm board type against DT property, if available */
+	if (of_property_read_u32(of_allnodes, "arm,hbi", &dt_hbi) == 0) {
+		u32 id = vexpress_get_procid(VEXPRESS_SITE_MASTER);
+		u32 hbi = (id >> SYS_PROCIDx_HBI_SHIFT) & SYS_HBI_MASK;
+
+		if (WARN_ON(dt_hbi != hbi))
+			dev_warn(&pdev->dev, "DT HBI (%x) is not matching hardware (%x)!\n",
+					dt_hbi, hbi);
+	}
+
 	/*
 	 * Duplicated SYS_MCI pseudo-GPIO controller for compatibility with
 	 * older trees using sysreg node for MMC control lines.
diff --git a/include/linux/vexpress.h b/include/linux/vexpress.h
index 46636e3..a4c9547 100644
--- a/include/linux/vexpress.h
+++ b/include/linux/vexpress.h
@@ -60,7 +60,6 @@ struct regmap *devm_regmap_init_vexpress_config(struct device *dev);
 
 unsigned int vexpress_get_mci_cardin(struct device *dev);
 u32 vexpress_get_procid(int site);
-u32 vexpress_get_hbi(int site);
 void *vexpress_get_24mhz_clock_base(void);
 void vexpress_flags_set(u32 data);
 
-- 
1.9.1

