Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab3DBLzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:55:09 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42924 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760653Ab3DBLzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:55:04 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v8 1/2] ARM: davinci: dm365: add support for v4l2 video display
Date: Tue,  2 Apr 2013 17:24:40 +0530
Message-Id: <1364903681-13914-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1364903681-13914-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1364903681-13914-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Create platform devices for various video modules like venc,osd,
vpbe and v4l2 driver for dm365.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/mach-davinci/board-dm365-evm.c |    4 +-
 arch/arm/mach-davinci/davinci.h         |    7 +-
 arch/arm/mach-davinci/dm365.c           |  185 +++++++++++++++++++++++++++++--
 3 files changed, 184 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index c2d4958..cf77c46 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -564,8 +564,6 @@ static struct davinci_uart_config uart_config __initdata = {
 
 static void __init dm365_evm_map_io(void)
 {
-	/* setup input configuration for VPFE input devices */
-	dm365_set_vpfe_config(&vpfe_cfg);
 	dm365_init();
 }
 
@@ -597,6 +595,8 @@ static __init void dm365_evm_init(void)
 
 	davinci_setup_mmc(0, &dm365evm_mmc_config);
 
+	dm365_init_video(&vpfe_cfg, NULL);
+
 	/* maybe setup mmc1/etc ... _after_ mmc0 */
 	evm_init_cpld();
 
diff --git a/arch/arm/mach-davinci/davinci.h b/arch/arm/mach-davinci/davinci.h
index 12d544b..a9de512 100644
--- a/arch/arm/mach-davinci/davinci.h
+++ b/arch/arm/mach-davinci/davinci.h
@@ -36,8 +36,13 @@
 #include <media/davinci/vpbe_osd.h>
 
 #define DAVINCI_SYSTEM_MODULE_BASE	0x01c40000
+#define SYSMOD_VDAC_CONFIG		0x2c
 #define SYSMOD_VIDCLKCTL		0x38
 #define SYSMOD_VPSS_CLKCTL		0x44
+#define VPSS_VENCCLKEN_ENABLE		BIT(3)
+#define VPSS_DACCLKEN_ENABLE		BIT(4)
+#define VPSS_PLLC2SYSCLK5_ENABLE	BIT(5)
+
 #define SYSMOD_VDD3P3VPWDN		0x48
 #define SYSMOD_VSCLKDIS			0x6c
 #define SYSMOD_PUPDCTL1			0x7c
@@ -84,7 +89,7 @@ void __init dm365_init_ks(struct davinci_ks_platform_data *pdata);
 void __init dm365_init_rtc(void);
 void dm365_init_spi0(unsigned chipselect_mask,
 			const struct spi_board_info *info, unsigned len);
-void dm365_set_vpfe_config(struct vpfe_config *cfg);
+int dm365_init_video(struct vpfe_config *, struct vpbe_config *);
 
 /* DM644x function declarations */
 void __init dm644x_init(void);
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index c61dd94..786c860 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -40,10 +40,14 @@
 
 #define DM365_REF_FREQ		24000000	/* 24 MHz on the DM365 EVM */
 
+#define DM365_RTC_BASE			0x01c69000
+
 /* Base of key scan register bank */
 #define DM365_KEYSCAN_BASE		0x01c69400
 
-#define DM365_RTC_BASE			0x01c69000
+#define DM365_OSD_BASE			0x01c71c00
+
+#define DM365_VENC_BASE			0x01c71e00
 
 #define DAVINCI_DM365_VC_BASE		0x01d0c000
 #define DAVINCI_DMA_VC_TX		2
@@ -1233,6 +1237,177 @@ static struct platform_device dm365_isif_dev = {
 	},
 };
 
+static struct resource dm365_osd_resources[] = {
+	{
+		.start = DM365_OSD_BASE,
+		.end   = DM365_OSD_BASE + 0xff,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static u64 dm365_video_dma_mask = DMA_BIT_MASK(32);
+
+static struct platform_device dm365_osd_dev = {
+	.name		= DM365_VPBE_OSD_SUBDEV_NAME,
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(dm365_osd_resources),
+	.resource	= dm365_osd_resources,
+	.dev		= {
+		.dma_mask		= &dm365_video_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+static struct resource dm365_venc_resources[] = {
+	{
+		.start = IRQ_VENCINT,
+		.end   = IRQ_VENCINT,
+		.flags = IORESOURCE_IRQ,
+	},
+	/* venc registers io space */
+	{
+		.start = DM365_VENC_BASE,
+		.end   = DM365_VENC_BASE + 0x177,
+		.flags = IORESOURCE_MEM,
+	},
+	/* vdaccfg registers io space */
+	{
+		.start = DAVINCI_SYSTEM_MODULE_BASE + SYSMOD_VDAC_CONFIG,
+		.end   = DAVINCI_SYSTEM_MODULE_BASE + SYSMOD_VDAC_CONFIG + 3,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static struct resource dm365_v4l2_disp_resources[] = {
+	{
+		.start = IRQ_VENCINT,
+		.end   = IRQ_VENCINT,
+		.flags = IORESOURCE_IRQ,
+	},
+	/* venc registers io space */
+	{
+		.start = DM365_VENC_BASE,
+		.end   = DM365_VENC_BASE + 0x177,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static int dm365_vpbe_setup_pinmux(enum v4l2_mbus_pixelcode if_type,
+			    int field)
+{
+	switch (if_type) {
+	case V4L2_MBUS_FMT_SGRBG8_1X8:
+		davinci_cfg_reg(DM365_VOUT_FIELD_G81);
+		davinci_cfg_reg(DM365_VOUT_COUTL_EN);
+		davinci_cfg_reg(DM365_VOUT_COUTH_EN);
+		break;
+
+	case V4L2_MBUS_FMT_YUYV10_1X20:
+		if (field)
+			davinci_cfg_reg(DM365_VOUT_FIELD);
+		else
+			davinci_cfg_reg(DM365_VOUT_FIELD_G81);
+		davinci_cfg_reg(DM365_VOUT_COUTL_EN);
+		davinci_cfg_reg(DM365_VOUT_COUTH_EN);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int dm365_venc_setup_clock(enum vpbe_enc_timings_type type,
+				  unsigned int pclock)
+{
+	void __iomem *vpss_clkctl_reg;
+	u32 val;
+
+	vpss_clkctl_reg = DAVINCI_SYSMOD_VIRT(SYSMOD_VPSS_CLKCTL);
+
+	switch (type) {
+	case VPBE_ENC_STD:
+		val = VPSS_VENCCLKEN_ENABLE | VPSS_DACCLKEN_ENABLE;
+		break;
+
+	case VPBE_ENC_DV_TIMINGS:
+		if (pclock <= 27000000) {
+			val = VPSS_VENCCLKEN_ENABLE | VPSS_DACCLKEN_ENABLE;
+		} else {
+			/* set sysclk4 to output 74.25 MHz from pll1 */
+			val = VPSS_PLLC2SYSCLK5_ENABLE | VPSS_DACCLKEN_ENABLE |
+			      VPSS_VENCCLKEN_ENABLE;
+		}
+		break;
+
+	default:
+		return -EINVAL;
+	}
+	writel(val, vpss_clkctl_reg);
+
+	return 0;
+}
+
+static struct platform_device dm365_vpbe_display = {
+	.name		= "vpbe-v4l2",
+	.id		= -1,
+	.num_resources  = ARRAY_SIZE(dm365_v4l2_disp_resources),
+	.resource	= dm365_v4l2_disp_resources,
+	.dev		= {
+		.dma_mask		= &dm365_video_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+struct venc_platform_data dm365_venc_pdata = {
+	.setup_pinmux	= dm365_vpbe_setup_pinmux,
+	.setup_clock	= dm365_venc_setup_clock,
+};
+
+static struct platform_device dm365_venc_dev = {
+	.name		= DM365_VPBE_VENC_SUBDEV_NAME,
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(dm365_venc_resources),
+	.resource	= dm365_venc_resources,
+	.dev		= {
+		.dma_mask		= &dm365_video_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+		.platform_data		= (void *)&dm365_venc_pdata,
+	},
+};
+
+static struct platform_device dm365_vpbe_dev = {
+	.name		= "vpbe_controller",
+	.id		= -1,
+	.dev		= {
+		.dma_mask		= &dm365_video_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+int __init dm365_init_video(struct vpfe_config *vpfe_cfg,
+				struct vpbe_config *vpbe_cfg)
+{
+	if (vpfe_cfg || vpbe_cfg)
+		platform_device_register(&dm365_vpss_device);
+
+	if (vpfe_cfg) {
+		vpfe_capture_dev.dev.platform_data = vpfe_cfg;
+		platform_device_register(&dm365_isif_dev);
+		platform_device_register(&vpfe_capture_dev);
+	}
+	if (vpbe_cfg) {
+		dm365_vpbe_dev.dev.platform_data = vpbe_cfg;
+		platform_device_register(&dm365_osd_dev);
+		platform_device_register(&dm365_venc_dev);
+		platform_device_register(&dm365_vpbe_dev);
+		platform_device_register(&dm365_vpbe_display);
+	}
+
+	return 0;
+}
+
 static int __init dm365_init_devices(void)
 {
 	if (!cpu_is_davinci_dm365())
@@ -1246,14 +1421,6 @@ static int __init dm365_init_devices(void)
 	clk_add_alias(NULL, dev_name(&dm365_mdio_device.dev),
 		      NULL, &dm365_emac_device.dev);
 
-	platform_device_register(&dm365_vpss_device);
-	platform_device_register(&dm365_isif_dev);
-	platform_device_register(&vpfe_capture_dev);
 	return 0;
 }
 postcore_initcall(dm365_init_devices);
-
-void dm365_set_vpfe_config(struct vpfe_config *cfg)
-{
-       vpfe_capture_dev.dev.platform_data = cfg;
-}
-- 
1.7.4.1

