Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbaFKI7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:59:05 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33120 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775AbaFKI7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:59:00 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 29/36] ARM: OMAP2+: gpmc-smc91x: Use gpmc_generic_init()
Date: Wed, 11 Jun 2014 11:56:34 +0300
Message-ID: <1402477001-31132-30-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't access any GPMC registers here. Use gpmc_generic_init()
to pass GPMC Chip Select settings, platform device and platform data
to the GPMC driver.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc-smc91x.c | 50 +++++++++++++++------------------------
 1 file changed, 19 insertions(+), 31 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc-smc91x.c b/arch/arm/mach-omap2/gpmc-smc91x.c
index 7f5d84a..4ac0d4d 100644
--- a/arch/arm/mach-omap2/gpmc-smc91x.c
+++ b/arch/arm/mach-omap2/gpmc-smc91x.c
@@ -25,8 +25,11 @@
 static struct omap_smc91x_platform_data *gpmc_cfg;
 
 static struct resource gpmc_smc91x_resources[] = {
+/* GPMC driver will fixup the 1st memory resource, see gpmc_probe_legacy () */
 	[0] = {
 		.flags		= IORESOURCE_MEM,
+		.start		= 0,
+		.end		= 0xf,
 	},
 	[1] = {
 		.flags		= IORESOURCE_IRQ,
@@ -92,21 +95,11 @@ static void smc91c96_get_device_timing(struct gpmc_device_timings *dev_t)
  */
 void __init gpmc_smc91x_init(struct omap_smc91x_platform_data *board_data)
 {
-	unsigned long cs_mem_base;
 	int ret;
 	struct gpmc_device_timings dev_t;
 
 	gpmc_cfg = board_data;
 
-	if (gpmc_cs_request(gpmc_cfg->cs, SZ_16M, &cs_mem_base) < 0) {
-		printk(KERN_ERR "Failed to request GPMC mem for smc91x\n");
-		return;
-	}
-
-	gpmc_smc91x_resources[0].start = cs_mem_base + 0x300;
-	gpmc_smc91x_resources[0].end = cs_mem_base + 0x30f;
-	gpmc_smc91x_resources[1].flags |= (gpmc_cfg->flags & IRQF_TRIGGER_MASK);
-
 	if (gpmc_cfg->flags & GPMC_MUX_ADD_DATA)
 		smc91x_settings.mux_add_data = GPMC_MUX_AD;
 	if (gpmc_cfg->flags & GPMC_READ_MON)
@@ -115,34 +108,24 @@ void __init gpmc_smc91x_init(struct omap_smc91x_platform_data *board_data)
 		smc91x_settings.wait_on_write = true;
 	if (gpmc_cfg->wait_pin)
 		smc91x_settings.wait_pin = gpmc_cfg->wait_pin;
-	ret = gpmc_cs_program_settings(gpmc_cfg->cs, &smc91x_settings);
-	if (ret < 0)
-		goto free1;
-
-	if (gpmc_cfg->flags & GPMC_TIMINGS_SMC91C96) {
-		struct gpmc_timings gpmc_t;
 
+	if (gpmc_cfg->flags & GPMC_TIMINGS_SMC91C96)
 		smc91c96_get_device_timing(&dev_t);
-		gpmc_calc_timings(&gpmc_t, &smc91x_settings, &dev_t);
-		if (gpmc_cs_set_timings(gpmc_cfg->cs, &gpmc_t)) {
-			pr_err("%s: failed to set GPMC timings\n", __func__);
-			goto free1;
-		}
-	}
 
 	if (gpio_request_one(gpmc_cfg->gpio_irq, GPIOF_IN, "SMC91X irq") < 0)
 		goto free1;
 
 	gpmc_smc91x_resources[1].start = gpio_to_irq(gpmc_cfg->gpio_irq);
+	gpmc_smc91x_resources[1].flags |= (gpmc_cfg->flags & IRQF_TRIGGER_MASK);
 
-	if (gpmc_cfg->gpio_pwrdwn) {
+	if (gpio_is_valid(gpmc_cfg->gpio_pwrdwn)) {
 		ret = gpio_request_one(gpmc_cfg->gpio_pwrdwn,
 				       GPIOF_OUT_INIT_LOW, "SMC91X powerdown");
 		if (ret)
 			goto free2;
 	}
 
-	if (gpmc_cfg->gpio_reset) {
+	if (gpio_is_valid(gpmc_cfg->gpio_reset)) {
 		ret = gpio_request_one(gpmc_cfg->gpio_reset,
 				       GPIOF_OUT_INIT_LOW, "SMC91X reset");
 		if (ret)
@@ -153,21 +136,26 @@ void __init gpmc_smc91x_init(struct omap_smc91x_platform_data *board_data)
 		gpio_set_value(gpmc_cfg->gpio_reset, 0);
 	}
 
-	if (platform_device_register(&gpmc_smc91x_device) < 0) {
-		printk(KERN_ERR "Unable to register smc91x device\n");
-		gpio_free(gpmc_cfg->gpio_reset);
-		goto free3;
+	ret = gpmc_generic_init(gpmc_cfg->cs, false,
+				&smc91x_settings,
+				gpmc_cfg->flags & GPMC_TIMINGS_SMC91C96 ?
+				&dev_t : NULL, NULL,
+				&gpmc_smc91x_device, sizeof(gpmc_smc91x_info));
+	if (ret) {
+		pr_err("%s: gpmc_generic_init() failed %d\n", __func__, ret);
+		goto free4;
 	}
 
 	return;
 
+free4:
+	if (gpio_is_valid(gpmc_cfg->gpio_reset))
+		gpio_free(gpmc_cfg->gpio_reset);
 free3:
-	if (gpmc_cfg->gpio_pwrdwn)
+	if (gpio_is_valid(gpmc_cfg->gpio_pwrdwn))
 		gpio_free(gpmc_cfg->gpio_pwrdwn);
 free2:
 	gpio_free(gpmc_cfg->gpio_irq);
 free1:
-	gpmc_cs_free(gpmc_cfg->cs);
-
 	printk(KERN_ERR "Could not initialize smc91x\n");
 }
-- 
1.8.3.2

