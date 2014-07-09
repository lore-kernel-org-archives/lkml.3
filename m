Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbaGIMVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:21:39 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50547 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbaGIMVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:21:37 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <lisovy@merica.cz>
To: Tony Lindgren <tony@atomide.com>, Pekon Gupta <pekon@ti.com>,
        linux-omap@vger.kernel.org
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michal Vokac <vokac.m@gmail.com>, Michal Sojka <sojkam1@fel.cvut.cz>,
        lisovy@gmail.com, Rostislav Lisovy <lisovy@merica.cz>
Subject: [PATCH RESEND] ARM: omap2+: gpmc-nand: Use dynamic platform_device_alloc()
Date: Wed,  9 Jul 2014 14:21:19 +0200
Message-Id: <1404908479-11196-1-git-send-email-lisovy@merica.cz>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPMC controller supports up to 8 memory devices connected to it.
Since there is one statically allocated "struct platform_device
gpmc_nand_device" it is not possible to configure the system to
use more than one NAND device connected to the GPMC. This
modification makes it possible to use up to 8 NAND devices
connected to the GPMC controller.

Signed-off-by: Rostislav Lisovy <lisovy@merica.cz>
---

Tested on custom AM335x board with two different NAND chips
(128 + 256 MiB) using GPMC configuration in FDT -- behaves
correctly.


 arch/arm/mach-omap2/gpmc-nand.c | 79 +++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 42 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc-nand.c b/arch/arm/mach-omap2/gpmc-nand.c
index 4349e82..c5481a8 100644
--- a/arch/arm/mach-omap2/gpmc-nand.c
+++ b/arch/arm/mach-omap2/gpmc-nand.c
@@ -24,25 +24,6 @@
 /* minimum size for IO mapping */
 #define	NAND_IO_SIZE	4
 
-static struct resource gpmc_nand_resource[] = {
-	{
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.flags		= IORESOURCE_IRQ,
-	},
-	{
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device gpmc_nand_device = {
-	.name		= "omap2-nand",
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(gpmc_nand_resource),
-	.resource	= gpmc_nand_resource,
-};
-
 static bool gpmc_hwecc_bch_capable(enum omap_ecc ecc_opt)
 {
 	/* platforms which support all ECC schemes */
@@ -93,43 +74,41 @@ int gpmc_nand_init(struct omap_nand_platform_data *gpmc_nand_data,
 {
 	int err	= 0;
 	struct gpmc_settings s;
-	struct device *dev = &gpmc_nand_device.dev;
-
-	memset(&s, 0, sizeof(struct gpmc_settings));
+	struct platform_device *pdev;
+	struct resource gpmc_nand_res[] = {
+		{ .flags = IORESOURCE_MEM, },
+		{ .flags = IORESOURCE_IRQ, },
+		{ .flags = IORESOURCE_IRQ, },
+	};
 
-	gpmc_nand_device.dev.platform_data = gpmc_nand_data;
+	BUG_ON(gpmc_nand_data->cs >= GPMC_CS_NUM);
 
 	err = gpmc_cs_request(gpmc_nand_data->cs, NAND_IO_SIZE,
-				(unsigned long *)&gpmc_nand_resource[0].start);
+			      (unsigned long *)&gpmc_nand_res[0].start);
 	if (err < 0) {
-		dev_err(dev, "Cannot request GPMC CS %d, error %d\n",
-			gpmc_nand_data->cs, err);
+		pr_err("omap2-gpmc: Cannot request GPMC CS %d, error %d\n",
+		       gpmc_nand_data->cs, err);
 		return err;
 	}
-
-	gpmc_nand_resource[0].end = gpmc_nand_resource[0].start +
-							NAND_IO_SIZE - 1;
-
-	gpmc_nand_resource[1].start =
-				gpmc_get_client_irq(GPMC_IRQ_FIFOEVENTENABLE);
-	gpmc_nand_resource[2].start =
-				gpmc_get_client_irq(GPMC_IRQ_COUNT_EVENT);
+	gpmc_nand_res[0].end = gpmc_nand_res[0].start + NAND_IO_SIZE - 1;
+	gpmc_nand_res[1].start = gpmc_get_client_irq(GPMC_IRQ_FIFOEVENTENABLE);
+	gpmc_nand_res[2].start = gpmc_get_client_irq(GPMC_IRQ_COUNT_EVENT);
 
 	if (gpmc_t) {
 		err = gpmc_cs_set_timings(gpmc_nand_data->cs, gpmc_t);
 		if (err < 0) {
-			dev_err(dev, "Unable to set gpmc timings: %d\n", err);
+			pr_err("omap2-gpmc: Unable to set gpmc timings: %d\n", err);
 			return err;
 		}
 	}
 
+	memset(&s, 0, sizeof(struct gpmc_settings));
 	if (gpmc_nand_data->of_node)
 		gpmc_read_settings_dt(gpmc_nand_data->of_node, &s);
 	else
 		gpmc_set_legacy(gpmc_nand_data, &s);
 
 	s.device_nand = true;
-
 	err = gpmc_cs_program_settings(gpmc_nand_data->cs, &s);
 	if (err < 0)
 		goto out_free_cs;
@@ -141,18 +120,34 @@ int gpmc_nand_init(struct omap_nand_platform_data *gpmc_nand_data,
 	gpmc_update_nand_reg(&gpmc_nand_data->reg, gpmc_nand_data->cs);
 
 	if (!gpmc_hwecc_bch_capable(gpmc_nand_data->ecc_opt)) {
-		dev_err(dev, "Unsupported NAND ECC scheme selected\n");
-		return -EINVAL;
+		pr_err("omap2-nand: Unsupported NAND ECC scheme selected\n");
+		err = -EINVAL;
+		goto out_free_cs;
 	}
 
-	err = platform_device_register(&gpmc_nand_device);
-	if (err < 0) {
-		dev_err(dev, "Unable to register NAND device\n");
-		goto out_free_cs;
+
+	pdev = platform_device_alloc("omap2-nand", gpmc_nand_data->cs);
+	if (pdev) {
+		err = platform_device_add_resources(pdev, gpmc_nand_res,
+						    ARRAY_SIZE(gpmc_nand_res));
+		if (!err)
+			pdev->dev.platform_data = gpmc_nand_data;
+	} else {
+		err = -ENOMEM;
+	}
+	if (err)
+		goto out_free_pdev;
+
+	err = platform_device_add(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "Unable to register NAND device\n");
+		goto out_free_pdev;
 	}
 
 	return 0;
 
+out_free_pdev:
+	platform_device_put(pdev);
 out_free_cs:
 	gpmc_cs_free(gpmc_nand_data->cs);
 
-- 
1.9.1

