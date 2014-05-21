Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaEULWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:22:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36796 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbaEULWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:22:04 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <pekon@ti.com>, <ezequiel.garcia@free-electrons.com>,
        <robertcnelson@gmail.com>, <jg1.han@samsung.com>,
        <dwmw2@infradead.org>, <javier@dowhile0.org>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 07/16] ARM: OMAP2+: nand: Update gpmc_nand_init() to use generic_gpmc_init()
Date: Wed, 21 May 2014 14:20:55 +0300
Message-ID: <1400671264-10702-8-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400671264-10702-1-git-send-email-rogerq@ti.com>
References: <1400671264-10702-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function should only be called by board init code for
legacy boot.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc-nand.c | 79 ++++++++---------------------------------
 1 file changed, 14 insertions(+), 65 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc-nand.c b/arch/arm/mach-omap2/gpmc-nand.c
index 4349e82..d536575 100644
--- a/arch/arm/mach-omap2/gpmc-nand.c
+++ b/arch/arm/mach-omap2/gpmc-nand.c
@@ -25,8 +25,11 @@
 #define	NAND_IO_SIZE	4
 
 static struct resource gpmc_nand_resource[] = {
+/* GPMC driver will fixup all the resources, see gpmc_probe_legacy () */
 	{
 		.flags		= IORESOURCE_MEM,
+		.start          = 0,
+		.end            = NAND_IO_SIZE - 1,
 	},
 	{
 		.flags		= IORESOURCE_IRQ,
@@ -72,89 +75,35 @@ static bool gpmc_hwecc_bch_capable(enum omap_ecc ecc_opt)
 		return 0;
 }
 
-/* This function will go away once the device-tree convertion is complete */
-static void gpmc_set_legacy(struct omap_nand_platform_data *gpmc_nand_data,
-			    struct gpmc_settings *s)
-{
-	/* Enable RD PIN Monitoring Reg */
-	if (gpmc_nand_data->dev_ready) {
-		s->wait_on_read = true;
-		s->wait_on_write = true;
-	}
-
-	if (gpmc_nand_data->devsize == NAND_BUSWIDTH_16)
-		s->device_width = GPMC_DEVWIDTH_16BIT;
-	else
-		s->device_width = GPMC_DEVWIDTH_8BIT;
-}
-
 int gpmc_nand_init(struct omap_nand_platform_data *gpmc_nand_data,
 		   struct gpmc_timings *gpmc_t)
 {
 	int err	= 0;
 	struct gpmc_settings s;
-	struct device *dev = &gpmc_nand_device.dev;
 
 	memset(&s, 0, sizeof(struct gpmc_settings));
-
 	gpmc_nand_device.dev.platform_data = gpmc_nand_data;
 
-	err = gpmc_cs_request(gpmc_nand_data->cs, NAND_IO_SIZE,
-				(unsigned long *)&gpmc_nand_resource[0].start);
-	if (err < 0) {
-		dev_err(dev, "Cannot request GPMC CS %d, error %d\n",
-			gpmc_nand_data->cs, err);
-		return err;
-	}
-
-	gpmc_nand_resource[0].end = gpmc_nand_resource[0].start +
-							NAND_IO_SIZE - 1;
-
-	gpmc_nand_resource[1].start =
-				gpmc_get_client_irq(GPMC_IRQ_FIFOEVENTENABLE);
-	gpmc_nand_resource[2].start =
-				gpmc_get_client_irq(GPMC_IRQ_COUNT_EVENT);
-
-	if (gpmc_t) {
-		err = gpmc_cs_set_timings(gpmc_nand_data->cs, gpmc_t);
-		if (err < 0) {
-			dev_err(dev, "Unable to set gpmc timings: %d\n", err);
-			return err;
-		}
-	}
-
-	if (gpmc_nand_data->of_node)
-		gpmc_read_settings_dt(gpmc_nand_data->of_node, &s);
+	/* GPMC settings */
+	if (gpmc_nand_data->devsize == NAND_BUSWIDTH_16)
+		s.device_width = GPMC_DEVWIDTH_16BIT;
 	else
-		gpmc_set_legacy(gpmc_nand_data, &s);
+		s.device_width = GPMC_DEVWIDTH_8BIT;
 
 	s.device_nand = true;
 
-	err = gpmc_cs_program_settings(gpmc_nand_data->cs, &s);
-	if (err < 0)
-		goto out_free_cs;
-
-	err = gpmc_configure(GPMC_CONFIG_WP, 0);
-	if (err < 0)
-		goto out_free_cs;
-
-	gpmc_update_nand_reg(&gpmc_nand_data->reg, gpmc_nand_data->cs);
-
 	if (!gpmc_hwecc_bch_capable(gpmc_nand_data->ecc_opt)) {
-		dev_err(dev, "Unsupported NAND ECC scheme selected\n");
+		pr_err("%s: Unsupported NAND ECC scheme selected\n", __func__);
 		return -EINVAL;
 	}
 
-	err = platform_device_register(&gpmc_nand_device);
-	if (err < 0) {
-		dev_err(dev, "Unable to register NAND device\n");
-		goto out_free_cs;
+	err = gpmc_generic_init(gpmc_nand_data->cs, GPMC_OMAP_TYPE_NAND, &s,
+				NULL, gpmc_t, &gpmc_nand_device,
+				sizeof(*gpmc_nand_data));
+	if (err) {
+		pr_err("%s: gpmc_generic_init() failed %d\n", __func__, err);
+		return err;
 	}
 
 	return 0;
-
-out_free_cs:
-	gpmc_cs_free(gpmc_nand_data->cs);
-
-	return err;
 }
-- 
1.8.3.2

