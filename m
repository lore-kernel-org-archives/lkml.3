Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaIJOkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:40:49 -0400
Received: from exprod7og128.obsmtp.com ([64.18.2.121]:51697 "EHLO
	exprod7og128.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaIJOks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:40:48 -0400
From: Anders Berg <anders.berg@avagotech.com>
To: Mark Brown <broonie@kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Anders Berg <anders.berg@avagotech.com>
Subject: [PATCH] spi: pl022: Add support for chip select extension
Date: Wed, 10 Sep 2014 16:40:30 +0200
Message-Id: <1410360030-26634-1-git-send-email-anders.berg@avagotech.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for a extended PL022 which has an extra register for controlling up
to five chip select signals. This controller is found on the AXM5516 SoC.
Unfortunately the PrimeCell identification registers are identical to a
standard ARM PL022. To work around this, the peripheral ID must be overridden
in the device tree using the "arm,primecell-periphid" property with the value
0x000b6022.

Signed-off-by: Anders Berg <anders.berg@avagotech.com>
---
 drivers/spi/spi-pl022.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 1189cfd..b395489 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -82,6 +82,7 @@
 #define SSP_MIS(r)	(r + 0x01C)
 #define SSP_ICR(r)	(r + 0x020)
 #define SSP_DMACR(r)	(r + 0x024)
+#define SSP_CSR(r)	(r + 0x030) /* vendor extension */
 #define SSP_ITCR(r)	(r + 0x080)
 #define SSP_ITIP(r)	(r + 0x084)
 #define SSP_ITOP(r)	(r + 0x088)
@@ -198,6 +199,12 @@
 #define SSP_DMACR_MASK_TXDMAE		(0x1UL << 1)
 
 /*
+ * SSP Chip Select Control Register - SSP_CSR
+ * (vendor extension)
+ */
+#define SSP_CSR_CSVALUE_MASK		(0x1FUL << 0)
+
+/*
  * SSP Integration Test control Register - SSP_ITCR
  */
 #define SSP_ITCR_MASK_ITEN		(0x1UL << 0)
@@ -313,6 +320,7 @@ enum ssp_writing {
  * @extended_cr: 32 bit wide control register 0 with extra
  * features and extra features in CR1 as found in the ST variants
  * @pl023: supports a subset of the ST extensions called "PL023"
+ * @internal_cs_ctrl: supports chip select control register
  */
 struct vendor_data {
 	int fifodepth;
@@ -321,6 +329,7 @@ struct vendor_data {
 	bool extended_cr;
 	bool pl023;
 	bool loopback;
+	bool internal_cs_ctrl;
 };
 
 /**
@@ -440,9 +449,32 @@ static void null_cs_control(u32 command)
 	pr_debug("pl022: dummy chip select control, CS=0x%x\n", command);
 }
 
+/**
+ * internal_cs_control - Control chip select signals via SSP_CSR.
+ * @pl022: SSP driver private data structure
+ * @command: select/delect the chip
+ *
+ * Used on controller with internal chip select control via SSP_CSR register
+ * (vendor extension). Each of the 5 LSB in the register controls one chip
+ * select signal.
+ */
+static void internal_cs_control(struct pl022 *pl022, u32 command)
+{
+	u32 tmp;
+
+	tmp = readw(SSP_CSR(pl022->virtbase));
+	if (command == SSP_CHIP_SELECT)
+		tmp &= ~BIT(pl022->cur_cs);
+	else
+		tmp |= BIT(pl022->cur_cs);
+	writew(tmp, SSP_CSR(pl022->virtbase));
+}
+
 static void pl022_cs_control(struct pl022 *pl022, u32 command)
 {
-	if (gpio_is_valid(pl022->cur_cs))
+	if (pl022->vendor->internal_cs_ctrl)
+		internal_cs_control(pl022, command);
+	else if (gpio_is_valid(pl022->cur_cs))
 		gpio_set_value(pl022->cur_cs, command);
 	else
 		pl022->cur_chip->cs_control(command);
@@ -2118,6 +2150,9 @@ static int pl022_probe(struct amba_device *adev, const struct amba_id *id)
 	if (platform_info->num_chipselect && platform_info->chipselects) {
 		for (i = 0; i < num_cs; i++)
 			pl022->chipselects[i] = platform_info->chipselects[i];
+	} else if (pl022->vendor->internal_cs_ctrl) {
+		for (i = 0; i < num_cs; i++)
+			pl022->chipselects[i] = i;
 	} else if (IS_ENABLED(CONFIG_OF)) {
 		for (i = 0; i < num_cs; i++) {
 			int cs_gpio = of_get_named_gpio(np, "cs-gpios", i);
@@ -2347,6 +2382,7 @@ static struct vendor_data vendor_arm = {
 	.extended_cr = false,
 	.pl023 = false,
 	.loopback = true,
+	.internal_cs_ctrl = false,
 };
 
 static struct vendor_data vendor_st = {
@@ -2356,6 +2392,7 @@ static struct vendor_data vendor_st = {
 	.extended_cr = true,
 	.pl023 = false,
 	.loopback = true,
+	.internal_cs_ctrl = false,
 };
 
 static struct vendor_data vendor_st_pl023 = {
@@ -2365,6 +2402,17 @@ static struct vendor_data vendor_st_pl023 = {
 	.extended_cr = true,
 	.pl023 = true,
 	.loopback = false,
+	.internal_cs_ctrl = false,
+};
+
+static struct vendor_data vendor_lsi = {
+	.fifodepth = 8,
+	.max_bpw = 16,
+	.unidir = false,
+	.extended_cr = false,
+	.pl023 = false,
+	.loopback = true,
+	.internal_cs_ctrl = true,
 };
 
 static struct amba_id pl022_ids[] = {
@@ -2398,6 +2446,15 @@ static struct amba_id pl022_ids[] = {
 		.mask	= 0xffffffff,
 		.data	= &vendor_st_pl023,
 	},
+	{
+		/*
+		 * PL022 variant that has a chip select control register whih
+		 * allows control of 5 output signals nCS[0:4].
+		 */
+		.id	= 0x000b6022,
+		.mask	= 0x000fffff,
+		.data	= &vendor_lsi,
+	},
 	{ 0, 0 },
 };
 
-- 
1.9.1

