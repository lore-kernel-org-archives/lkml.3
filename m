Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab3LBHFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 02:05:32 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:53278 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab3LBHF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 02:05:29 -0500
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Ruehl <chris.ruehl@gtsys.com.hk>
Subject: [PATCH 1/3] usb: phy-generic: Add GPIO based ChipSelect
Date: Mon,  2 Dec 2013 15:05:17 +0800
Message-Id: <1385967919-13258-2-git-send-email-chris.ruehl@gtsys.com.hk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1385967919-13258-1-git-send-email-chris.ruehl@gtsys.com.hk>
References: <1385967919-13258-1-git-send-email-chris.ruehl@gtsys.com.hk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb: phy-generic: Add GPIO based ChipSelect

The ULPI ISP1504 uses the CHIP_SELECT_N (low active) pin to active the
chip. This patch add support for GPIO based ChipSelect almost the same
way implemented for the Reset feature.

Sample DT configuration:
pinctrl_usbphy2: usbphy-2 {
fsl,pins = <
	/* chip select and reset gpio output */
	MX27_PAD_PC_CD1_B__GPIO6_20 0x0
	MX27_PAD_PC_CD2_B__GPIO6_19 0x0
	>;
};

&usbphy2 {
        cs-gpios = <&gpio6 20 1>;
	reset-gpios = <&gpio6 19 1>;
	pinctrl-names = "default";
	pinctrl-0 = <&pinctrl_usbphy2>;
};

Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
---
 drivers/usb/phy/phy-generic.c |   31 +++++++++++++++++++++++++++++++
 drivers/usb/phy/phy-generic.h |    2 ++
 2 files changed, 33 insertions(+)

diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
index fce3a9e..ff4d68c 100644
--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -181,6 +181,24 @@ int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_gen_xceiv *nop,
 			return -EPROBE_DEFER;
 	}
 
+	if(gpio_is_valid(nop->gpio_chipselect)) {
+		unsigned long gpio_flags;
+		dev_dbg(dev, "Requesting Chipselect GPIO %d\n",
+				nop->gpio_chipselect);
+		if (nop->cs_active_low)
+			gpio_flags = GPIOF_OUT_INIT_LOW;
+		else
+			gpio_flags = GPIOF_OUT_INIT_HIGH;
+
+		err = devm_gpio_request_one(dev, nop->gpio_chipselect,
+				gpio_flags, dev_name(dev));
+		if (err) {
+			dev_err(dev, "Error requesting Chipselect GPIO %d err=%d\n",
+					nop->gpio_chipselect, err);
+			return err;
+		}
+	}
+
 	if (gpio_is_valid(nop->gpio_reset)) {
 		unsigned long gpio_flags;
 
@@ -231,27 +249,40 @@ static int usb_phy_gen_xceiv_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	nop->reset_active_low = true;	/* default behaviour */
+	nop->cs_active_low = true;
 
 	if (dev->of_node) {
 		struct device_node *node = dev->of_node;
 		enum of_gpio_flags flags;
+		enum of_gpio_flags csflags;
 
 		if (of_property_read_u32(node, "clock-frequency", &clk_rate))
 			clk_rate = 0;
 
 		needs_vcc = of_property_read_bool(node, "vcc-supply");
+
 		nop->gpio_reset = of_get_named_gpio_flags(node, "reset-gpios",
 								0, &flags);
+
 		if (nop->gpio_reset == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
 
 		nop->reset_active_low = flags & OF_GPIO_ACTIVE_LOW;
 
+		nop->gpio_chipselect = of_get_named_gpio_flags(node, "cs-gpios",
+								0, &csflags);
+		if (gpio_is_valid(nop->gpio_chipselect))
+			nop->cs_active_low = csflags & OF_GPIO_ACTIVE_LOW;
+
 	} else if (pdata) {
 		type = pdata->type;
 		clk_rate = pdata->clk_rate;
 		needs_vcc = pdata->needs_vcc;
 		nop->gpio_reset = pdata->gpio_reset;
+		nop->gpio_chipselect = pdata->gpio_chipselect;
+	} else {
+		nop->gpio_reset = -1;
+		nop->gpio_chipselect = -1;
 	}
 
 	err = usb_phy_gen_create_phy(dev, nop, type, clk_rate, needs_vcc);
diff --git a/drivers/usb/phy/phy-generic.h b/drivers/usb/phy/phy-generic.h
index d2a220d..97eafc2 100644
--- a/drivers/usb/phy/phy-generic.h
+++ b/drivers/usb/phy/phy-generic.h
@@ -7,7 +7,9 @@ struct usb_phy_gen_xceiv {
 	struct clk *clk;
 	struct regulator *vcc;
 	int gpio_reset;
+	int gpio_chipselect;
 	bool reset_active_low;
+	bool cs_active_low;
 };
 
 int usb_gen_phy_init(struct usb_phy *phy);
-- 
1.7.10.4

