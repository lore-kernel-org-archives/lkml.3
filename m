Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291Ab3BHQgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 11:36:06 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:35871 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760212Ab3BHQgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 11:36:02 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <FlorianSchandinat@gmx.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <jhovold@gmail.com>,
        <jacmet@sunsite.dk>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 5/5] ARM: at91/avr32/atmel_lcdfb: add platform device-id table
Date: Fri, 8 Feb 2013 17:35:18 +0100
Message-ID: <53bca6150efd934c9f0ec64b5365fe1cf625d85d.1360340791.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1360340791.git.nicolas.ferre@atmel.com>
References: <cover.1360340791.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

Add platform device-id table in order to identify the controller and
determine its configuration.

The currently used configuration parameters are:

have_alt_pixclock
 - SOC uses an alternate pixel-clock calculation formula (at91sam9g45
   non-ES)

have_hozval
 - SOC has a HOZVAL field in LCDFRMCFG which is used to determine the
   linesize for STN displays (at91sam9261, at921sam9g10 and at32ap)

have_intensity_bit
 - SOC uses IBGR:555 rather than BGR:565 16-bit pixel layout
   (at91sam9261, at91sam9263 and at91sam9rl)

This allows us to remove all the remaining uses of cpu_is macros from
the driver.

Tested on at91sam9263 and at91sam9g45, compile-tested for other
AT91-SOCs, and untested for AVR32.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91sam9261.c         |  3 +-
 arch/arm/mach-at91/at91sam9261_devices.c |  6 ++-
 arch/arm/mach-at91/at91sam9263.c         |  2 +-
 arch/arm/mach-at91/at91sam9263_devices.c |  2 +-
 arch/arm/mach-at91/at91sam9g45.c         |  3 +-
 arch/arm/mach-at91/at91sam9g45_devices.c |  6 ++-
 arch/arm/mach-at91/at91sam9rl.c          |  2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c  |  2 +-
 arch/avr32/mach-at32ap/at32ap700x.c      |  2 +
 drivers/video/atmel_lcdfb.c              | 89 ++++++++++++++++++++++++++++----
 include/video/atmel_lcdc.h               |  4 +-
 11 files changed, 102 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 5838f12..0204f4c 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -169,7 +169,8 @@ static struct clk *periph_clocks[] __initdata = {
 };
 
 static struct clk_lookup periph_clocks_lookups[] = {
-	CLKDEV_CON_DEV_ID("hclk", "atmel_lcdfb.0", &hck1),
+	CLKDEV_CON_DEV_ID("hclk", "at91sam9261-lcdfb.0", &hck1),
+	CLKDEV_CON_DEV_ID("hclk", "at91sam9g10-lcdfb.0", &hck1),
 	CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.0", &spi0_clk),
 	CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.1", &spi1_clk),
 	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.0", &tc0_clk),
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index 92e0f86..629ea5f 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -488,7 +488,6 @@ static struct resource lcdc_resources[] = {
 };
 
 static struct platform_device at91_lcdc_device = {
-	.name		= "atmel_lcdfb",
 	.id		= 0,
 	.dev		= {
 				.dma_mask		= &lcdc_dmamask,
@@ -505,6 +504,11 @@ void __init at91_add_device_lcdc(struct atmel_lcdfb_info *data)
 		return;
 	}
 
+	if (cpu_is_at91sam9g10())
+		at91_lcdc_device.name = "at91sam9g10-lcdfb";
+	else
+		at91_lcdc_device.name = "at91sam9261-lcdfb";
+
 #if defined(CONFIG_FB_ATMEL_STN)
 	at91_set_A_periph(AT91_PIN_PB0, 0);     /* LCDVSYNC */
 	at91_set_A_periph(AT91_PIN_PB1, 0);     /* LCDHSYNC */
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index 520a63d..2282fd7 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -190,7 +190,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("pclk", "at91rm9200_ssc.1", &ssc1_clk),
 	CLKDEV_CON_DEV_ID("pclk", "fff98000.ssc", &ssc0_clk),
 	CLKDEV_CON_DEV_ID("pclk", "fff9c000.ssc", &ssc1_clk),
-	CLKDEV_CON_DEV_ID("hclk", "atmel_lcdfb.0", &lcdc_clk),
+	CLKDEV_CON_DEV_ID("hclk", "at91sam9263-lcdfb.0", &lcdc_clk),
 	CLKDEV_CON_DEV_ID("mci_clk", "atmel_mci.0", &mmc0_clk),
 	CLKDEV_CON_DEV_ID("mci_clk", "atmel_mci.1", &mmc1_clk),
 	CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.0", &spi0_clk),
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index ed666f5..858c8aa 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -848,7 +848,7 @@ static struct resource lcdc_resources[] = {
 };
 
 static struct platform_device at91_lcdc_device = {
-	.name		= "atmel_lcdfb",
+	.name		= "at91sam9263-lcdfb",
 	.id		= 0,
 	.dev		= {
 				.dma_mask		= &lcdc_dmamask,
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index ea6b62b..c68960d 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -228,7 +228,8 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_ID("hclk", &macb_clk),
 	/* One additional fake clock for ohci */
 	CLKDEV_CON_ID("ohci_clk", &uhphs_clk),
-	CLKDEV_CON_DEV_ID("hclk", "atmel_lcdfb.0", &lcdc_clk),
+	CLKDEV_CON_DEV_ID("hclk", "at91sam9g45-lcdfb.0", &lcdc_clk),
+	CLKDEV_CON_DEV_ID("hclk", "at91sam9g45es-lcdfb.0", &lcdc_clk),
 	CLKDEV_CON_DEV_ID("ehci_clk", "atmel-ehci", &uhphs_clk),
 	CLKDEV_CON_DEV_ID("hclk", "atmel_usba_udc", &utmi_clk),
 	CLKDEV_CON_DEV_ID("pclk", "atmel_usba_udc", &udphs_clk),
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 827c9f2..fe626d4 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -981,7 +981,6 @@ static struct resource lcdc_resources[] = {
 };
 
 static struct platform_device at91_lcdc_device = {
-	.name		= "atmel_lcdfb",
 	.id		= 0,
 	.dev		= {
 				.dma_mask		= &lcdc_dmamask,
@@ -997,6 +996,11 @@ void __init at91_add_device_lcdc(struct atmel_lcdfb_info *data)
 	if (!data)
 		return;
 
+	if (cpu_is_at91sam9g45es())
+		at91_lcdc_device.name = "at91sam9g45es-lcdfb";
+	else
+		at91_lcdc_device.name = "at91sam9g45-lcdfb";
+
 	at91_set_A_periph(AT91_PIN_PE0, 0);	/* LCDDPWR */
 
 	at91_set_A_periph(AT91_PIN_PE2, 0);	/* LCDCC */
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index 4cd4fa9..3de3e04 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -179,7 +179,7 @@ static struct clk *periph_clocks[] __initdata = {
 };
 
 static struct clk_lookup periph_clocks_lookups[] = {
-	CLKDEV_CON_DEV_ID("hclk", "atmel_lcdfb.0", &lcdc_clk),
+	CLKDEV_CON_DEV_ID("hclk", "at91sam9rl-lcdfb.0", &lcdc_clk),
 	CLKDEV_CON_DEV_ID("hclk", "atmel_usba_udc", &utmi_clk),
 	CLKDEV_CON_DEV_ID("pclk", "atmel_usba_udc", &udphs_clk),
 	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.0", &tc0_clk),
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index ddf223f..352468f 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -514,7 +514,7 @@ static struct resource lcdc_resources[] = {
 };
 
 static struct platform_device at91_lcdc_device = {
-	.name		= "atmel_lcdfb",
+	.name		= "at91sam9rl-lcdfb",
 	.id		= 0,
 	.dev		= {
 				.dma_mask		= &lcdc_dmamask,
diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index cd25b01..7c2f668 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1530,6 +1530,8 @@ at32_add_device_lcdc(unsigned int id, struct atmel_lcdfb_info *data,
 	memcpy(info, data, sizeof(struct atmel_lcdfb_info));
 	info->default_monspecs = monspecs;
 
+	pdev->name = "at32ap-lcdfb";
+
 	platform_device_register(pdev);
 	return pdev;
 
diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 2effd35..c1a2914 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -34,6 +34,77 @@
 #define ATMEL_LCDC_DMA_BURST_LEN	8	/* words */
 #define ATMEL_LCDC_FIFO_SIZE		512	/* words */
 
+struct atmel_lcdfb_config {
+	bool have_alt_pixclock;
+	bool have_hozval;
+	bool have_intensity_bit;
+};
+
+static struct atmel_lcdfb_config at91sam9261_config = {
+	.have_hozval		= true,
+	.have_intensity_bit	= true,
+};
+
+static struct atmel_lcdfb_config at91sam9263_config = {
+	.have_intensity_bit	= true,
+};
+
+static struct atmel_lcdfb_config at91sam9g10_config = {
+	.have_hozval		= true,
+};
+
+static struct atmel_lcdfb_config at91sam9g45_config = {
+	.have_alt_pixclock	= true,
+};
+
+static struct atmel_lcdfb_config at91sam9g45es_config = {
+};
+
+static struct atmel_lcdfb_config at91sam9rl_config = {
+	.have_intensity_bit	= true,
+};
+
+static struct atmel_lcdfb_config at32ap_config = {
+	.have_hozval		= true,
+};
+
+static const struct platform_device_id atmel_lcdfb_devtypes[] = {
+	{
+		.name = "at91sam9261-lcdfb",
+		.driver_data = (unsigned long)&at91sam9261_config,
+	}, {
+		.name = "at91sam9263-lcdfb",
+		.driver_data = (unsigned long)&at91sam9263_config,
+	}, {
+		.name = "at91sam9g10-lcdfb",
+		.driver_data = (unsigned long)&at91sam9g10_config,
+	}, {
+		.name = "at91sam9g45-lcdfb",
+		.driver_data = (unsigned long)&at91sam9g45_config,
+	}, {
+		.name = "at91sam9g45es-lcdfb",
+		.driver_data = (unsigned long)&at91sam9g45es_config,
+	}, {
+		.name = "at91sam9rl-lcdfb",
+		.driver_data = (unsigned long)&at91sam9rl_config,
+	}, {
+		.name = "at32ap-lcdfb",
+		.driver_data = (unsigned long)&at32ap_config,
+	}, {
+		/* terminator */
+	}
+};
+
+static struct atmel_lcdfb_config *
+atmel_lcdfb_get_config(struct platform_device *pdev)
+{
+	unsigned long data;
+
+	data = platform_get_device_id(pdev)->driver_data;
+
+	return (struct atmel_lcdfb_config *)data;
+}
+
 #if defined(CONFIG_ARCH_AT91)
 #define	ATMEL_LCDFB_FBINFO_DEFAULT	(FBINFO_DEFAULT \
 					 | FBINFO_PARTIAL_PAN_OK \
@@ -199,8 +270,7 @@ static unsigned long compute_hozval(struct atmel_lcdfb_info *sinfo,
 	unsigned long lcdcon2;
 	unsigned long value;
 
-	if (!(cpu_is_at91sam9261() || cpu_is_at91sam9g10()
-		|| cpu_is_at32ap7000()))
+	if (!sinfo->config->have_hozval)
 		return xres;
 
 	lcdcon2 = lcdc_readl(sinfo, ATMEL_LCDC_LCDCON2);
@@ -426,7 +496,7 @@ static int atmel_lcdfb_check_var(struct fb_var_screeninfo *var,
 		break;
 	case 16:
 		/* Older SOCs use IBGR:555 rather than BGR:565. */
-		if (sinfo->have_intensity_bit)
+		if (sinfo->config->have_intensity_bit)
 			var->green.length = 5;
 		else
 			var->green.length = 6;
@@ -534,7 +604,7 @@ static int atmel_lcdfb_set_par(struct fb_info *info)
 	/* Now, the LCDC core... */
 
 	/* Set pixel clock */
-	if (cpu_is_at91sam9g45() && !cpu_is_at91sam9g45es())
+	if (sinfo->config->have_alt_pixclock)
 		pix_factor = 1;
 
 	clk_value_khz = clk_get_rate(sinfo->lcdc_clk) / 1000;
@@ -686,7 +756,7 @@ static int atmel_lcdfb_setcolreg(unsigned int regno, unsigned int red,
 
 	case FB_VISUAL_PSEUDOCOLOR:
 		if (regno < 256) {
-			if (sinfo->have_intensity_bit) {
+			if (sinfo->config->have_intensity_bit) {
 				/* old style I+BGR:555 */
 				val  = ((red   >> 11) & 0x001f);
 				val |= ((green >>  6) & 0x03e0);
@@ -874,10 +944,9 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
 	}
 	sinfo->info = info;
 	sinfo->pdev = pdev;
-	if (cpu_is_at91sam9261() || cpu_is_at91sam9263() ||
-							cpu_is_at91sam9rl()) {
-		sinfo->have_intensity_bit = true;
-	}
+	sinfo->config = atmel_lcdfb_get_config(pdev);
+	if (!sinfo->config)
+		goto free_info;
 
 	strcpy(info->fix.id, sinfo->pdev->name);
 	info->flags = ATMEL_LCDFB_FBINFO_DEFAULT;
@@ -1146,7 +1215,7 @@ static struct platform_driver atmel_lcdfb_driver = {
 	.remove		= __exit_p(atmel_lcdfb_remove),
 	.suspend	= atmel_lcdfb_suspend,
 	.resume		= atmel_lcdfb_resume,
-
+	.id_table	= atmel_lcdfb_devtypes,
 	.driver		= {
 		.name	= "atmel_lcdfb",
 		.owner	= THIS_MODULE,
diff --git a/include/video/atmel_lcdc.h b/include/video/atmel_lcdc.h
index 8deb226..0f5a2fc 100644
--- a/include/video/atmel_lcdc.h
+++ b/include/video/atmel_lcdc.h
@@ -31,6 +31,7 @@
 #define ATMEL_LCDC_WIRING_BGR	0
 #define ATMEL_LCDC_WIRING_RGB	1
 
+struct atmel_lcdfb_config;
 
  /* LCD Controller info data structure, stored in device platform_data */
 struct atmel_lcdfb_info {
@@ -61,7 +62,8 @@ struct atmel_lcdfb_info {
 	void (*atmel_lcdfb_power_control)(int on);
 	struct fb_monspecs	*default_monspecs;
 	u32			pseudo_palette[16];
-	bool			have_intensity_bit;
+
+	struct atmel_lcdfb_config *config;
 };
 
 #define ATMEL_LCDC_DMABADDR1	0x00
-- 
1.8.0

