Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbaFKI7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:59:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56391 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaFKI7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:59:11 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 32/36] ARM: OMAP2+: onenand: Use gpmc_generic_init()
Date: Wed, 11 Jun 2014 11:56:37 +0300
Message-ID: <1402477001-31132-33-git-send-email-rogerq@ti.com>
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
 arch/arm/mach-omap2/gpmc-onenand.c | 53 ++++++++------------------------------
 1 file changed, 11 insertions(+), 42 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc-onenand.c b/arch/arm/mach-omap2/gpmc-onenand.c
index 37ed4f1..139b3dd 100644
--- a/arch/arm/mach-omap2/gpmc-onenand.c
+++ b/arch/arm/mach-omap2/gpmc-onenand.c
@@ -27,7 +27,10 @@
 #define	ONENAND_IO_SIZE	SZ_128K
 
 static struct resource gpmc_onenand_resource = {
+/* GPMC driver will fixup the memory resource, see gpmc_probe_legacy() */
 	.flags		= IORESOURCE_MEM,
+	.start		= 0,
+	.end		= ONENAND_IO_SIZE - 1,
 };
 
 static struct platform_device gpmc_onenand_device = {
@@ -68,29 +71,11 @@ static void omap2_onenand_get_async_timings(struct gpmc_device_timings *dev_t)
 	dev_t->t_wph = t_wph * 1000;
 }
 
-static int omap2_onenand_setup_async(struct omap_onenand_platform_data
-				     *gpmc_onenand_data)
-{
-	struct gpmc_timings gpmc_t;
-	struct gpmc_device_timings dev_t;
-	int ret;
-
-	ret = gpmc_cs_program_settings(gpmc_onenand_data->cs, &onenand_async);
-	if (ret < 0)
-		return ret;
-
-	omap2_onenand_get_async_timings(&dev_t);
-	gpmc_calc_timings(&gpmc_t, &onenand_async, &dev_t);
-	if (gpmc_cs_set_timings(gpmc_onenand_data->cs, &gpmc_t))
-		return -EINVAL;
-
-	return 0;
-}
-
 void gpmc_onenand_init(struct omap_onenand_platform_data *gpmc_onenand_data)
 {
 	int err;
 	struct device *dev = &gpmc_onenand_device.dev;
+	struct gpmc_device_timings dev_t;
 
 	gpmc_onenand_device.dev.platform_data = gpmc_onenand_data;
 
@@ -106,29 +91,13 @@ void gpmc_onenand_init(struct omap_onenand_platform_data *gpmc_onenand_data)
 	else
 		gpmc_onenand_data->flags &= ~ONENAND_IN_OMAP34XX;
 
-	err = gpmc_cs_request(gpmc_onenand_data->cs, ONENAND_IO_SIZE,
-				(unsigned long *)&gpmc_onenand_resource.start);
-	if (err < 0) {
-		dev_err(dev, "Cannot request GPMC CS %d, error %d\n",
-			gpmc_onenand_data->cs, err);
-		return;
-	}
-
-	gpmc_onenand_resource.end = gpmc_onenand_resource.start +
-							ONENAND_IO_SIZE - 1;
-
-	if (omap2_onenand_setup_async(gpmc_onenand_data)) {
-		pr_err("%s: Failed to setup ASYNC timings\n", __func__);
-		goto fail;
-	}
-
-	if (platform_device_register(&gpmc_onenand_device) < 0) {
-		dev_err(dev, "Unable to register OneNAND device\n");
-		goto fail;
-	}
 
-	return;
+	omap2_onenand_get_async_timings(&dev_t);
 
-fail:
-	gpmc_cs_free(gpmc_onenand_data->cs);
+	err = gpmc_generic_init(gpmc_onenand_data->cs, false,
+				&onenand_async, &dev_t, NULL,
+				&gpmc_onenand_device,
+				sizeof(*gpmc_onenand_data));
+	if (err)
+		pr_err("%s: gpmc_generic_init() failed %d\n", __func__, err);
 }
-- 
1.8.3.2

