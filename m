Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3JGKMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:12:49 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:53768 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab3JGKMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:12:43 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Paul Zimmerman <paulz@synopsys.com>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH 2/5] usb: gadget: s3c-hsotg: support configurable UTMI PHY width
Date: Mon,  7 Oct 2013 06:12:29 -0400
Message-Id: <1381140752-312-3-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381140752-312-1-git-send-email-matt.porter@linaro.org>
References: <1381140752-312-1-git-send-email-matt.porter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend dwc2 binding with an optional utmi phy width property.
Enable the s3c-hsotg.c driver to use standard dwc2 binding
and enable configuration of the UTMI phy width based on the
property.

Signed-off-by: Matt Porter <matt.porter@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
---
 Documentation/devicetree/bindings/staging/dwc2.txt |  4 ++++
 drivers/usb/gadget/s3c-hsotg.c                     | 18 +++++++++++++++++-
 drivers/usb/gadget/s3c-hsotg.h                     |  1 +
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/staging/dwc2.txt b/Documentation/devicetree/bindings/staging/dwc2.txt
index 1a1b7cf..fb6b8ee 100644
--- a/Documentation/devicetree/bindings/staging/dwc2.txt
+++ b/Documentation/devicetree/bindings/staging/dwc2.txt
@@ -6,10 +6,14 @@ Required properties:
 - reg : Should contain 1 register range (address and length)
 - interrupts : Should contain 1 interrupt
 
+Optional properties:
+- snps,phy-utmi-width: Must contain the UTMI data width (either 8 or 16)
+
 Example:
 
         usb@101c0000 {
                 compatible = "ralink,rt3050-usb, snps,dwc2";
                 reg = <0x101c0000 40000>;
                 interrupts = <18>;
+		snps,phy-utmi-width = <8>;
         };
diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 34d80f3..396afb3 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -137,6 +137,7 @@ struct s3c_hsotg_ep {
  * @regs: The memory area mapped for accessing registers.
  * @irq: The IRQ number we are using
  * @supplies: Definition of USB power supplies
+ * @phyif: PHY interface width
  * @dedicated_fifos: Set if the hardware has dedicated IN-EP fifos.
  * @num_of_eps: Number of available EPs (excluding EP0)
  * @debug_root: root directrory for debugfs.
@@ -164,6 +165,7 @@ struct s3c_hsotg {
 
 	struct regulator_bulk_data supplies[ARRAY_SIZE(s3c_hsotg_supply_names)];
 
+	u32			phyif;
 	unsigned int		dedicated_fifos:1;
 	unsigned char           num_of_eps;
 
@@ -2212,7 +2214,7 @@ static void s3c_hsotg_core_init(struct s3c_hsotg *hsotg)
 	 */
 
 	/* set the PLL on, remove the HNP/SRP and set the PHY */
-	writel(GUSBCFG_PHYIf16 | GUSBCFG_TOutCal(7) |
+	writel(hsotg->phyif | GUSBCFG_TOutCal(7) |
 	       (0x5 << 10), hsotg->regs + GUSBCFG);
 
 	s3c_hsotg_init_fifo(hsotg);
@@ -3447,9 +3449,11 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 	struct s3c_hsotg_plat *plat = dev_get_platdata(&pdev->dev);
 	struct usb_phy *phy;
 	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
 	struct s3c_hsotg_ep *eps;
 	struct s3c_hsotg *hsotg;
 	struct resource *res;
+	u32 phy_utmi_width = 16;
 	int epnum;
 	int ret;
 	int i;
@@ -3539,6 +3543,17 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 		goto err_supplies;
 	}
 
+	/* Set default UTMI width */
+	hsotg->phyif = GUSBCFG_PHYIf16;
+	if (np) {
+		of_property_read_u32(np, "snps,phy-utmi-width",
+				     &phy_utmi_width);
+		if (phy_utmi_width == 8)
+			hsotg->phyif = GUSBCFG_PHYIf8;
+		if ((phy_utmi_width != 8) && (phy_utmi_width != 16))
+			dev_warn(dev, "invalid snps,phy-utmi-width value\n");
+	}
+
 	/* usb phy enable */
 	s3c_hsotg_phy_enable(hsotg);
 
@@ -3645,6 +3660,7 @@ static int s3c_hsotg_remove(struct platform_device *pdev)
 #ifdef CONFIG_OF
 static const struct of_device_id s3c_hsotg_of_ids[] = {
 	{ .compatible = "samsung,s3c6400-hsotg", },
+	{ .compatible = "snps,dwc2", },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, s3c_hsotg_of_ids);
diff --git a/drivers/usb/gadget/s3c-hsotg.h b/drivers/usb/gadget/s3c-hsotg.h
index d650b12..85f549f 100644
--- a/drivers/usb/gadget/s3c-hsotg.h
+++ b/drivers/usb/gadget/s3c-hsotg.h
@@ -55,6 +55,7 @@
 #define GUSBCFG_HNPCap				(1 << 9)
 #define GUSBCFG_SRPCap				(1 << 8)
 #define GUSBCFG_PHYIf16			(1 << 3)
+#define GUSBCFG_PHYIf8				(0 << 3)
 #define GUSBCFG_TOutCal_MASK			(0x7 << 0)
 #define GUSBCFG_TOutCal_SHIFT			(0)
 #define GUSBCFG_TOutCal_LIMIT			(0x7)
-- 
1.8.4

