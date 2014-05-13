Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbaEMPrC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:47:02 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40102 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753694AbaEMPpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:45:09 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        kishon@ti.com, hdegoede@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Boris Brezillon <boris@free-electrons.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH RESEND v4 5/8] usb: ehci-platform: add optional reset controller retrieval
Date: Tue, 13 May 2014 17:44:19 +0200
Message-Id: <1399995862-17788-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1399995862-17788-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1399995862-17788-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

On the Allwinner's A31 SoC the reset line connected to the EHCI IP has to
be deasserted for the EHCI block to be usable.

Add support for an optional reset controller that will be deasserted on
power off and asserted on power on.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 Documentation/devicetree/bindings/usb/usb-ehci.txt |  1 +
 drivers/usb/host/ehci-platform.c                   | 26 +++++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/usb-ehci.txt b/Documentation/devicetree/bindings/usb/usb-ehci.txt
index ff151ec084c4..43c1a4e06767 100644
--- a/Documentation/devicetree/bindings/usb/usb-ehci.txt
+++ b/Documentation/devicetree/bindings/usb/usb-ehci.txt
@@ -15,6 +15,7 @@ Optional properties:
  - clocks : a list of phandle + clock specifier pairs
  - phys : phandle + phy specifier pair
  - phy-names : "usb"
+ - resets : phandle + reset specifier pair
 
 Example (Sequoia 440EPx):
     ehci@e0000300 {
diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index c7dd93aad20c..2f5b9ce3e042 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -29,6 +29,7 @@
 #include <linux/of.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/reset.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
 #include <linux/usb/ehci_pdriver.h>
@@ -41,6 +42,7 @@
 
 struct ehci_platform_priv {
 	struct clk *clks[EHCI_MAX_CLKS];
+	struct reset_control *rst;
 	struct phy *phy;
 };
 
@@ -208,6 +210,18 @@ static int ehci_platform_probe(struct platform_device *dev)
 		}
 	}
 
+	priv->rst = devm_reset_control_get_optional(&dev->dev, NULL);
+	if (IS_ERR(priv->rst)) {
+		err = PTR_ERR(priv->rst);
+		if (err == -EPROBE_DEFER)
+			goto err_put_clks;
+		priv->rst = NULL;
+	} else {
+		err = reset_control_deassert(priv->rst);
+		if (err)
+			goto err_put_clks;
+	}
+
 	if (pdata->big_endian_desc)
 		ehci->big_endian_desc = 1;
 	if (pdata->big_endian_mmio)
@@ -218,7 +232,7 @@ static int ehci_platform_probe(struct platform_device *dev)
 		dev_err(&dev->dev,
 			"Error: CONFIG_USB_EHCI_BIG_ENDIAN_MMIO not set\n");
 		err = -EINVAL;
-		goto err_put_clks;
+		goto err_reset;
 	}
 #endif
 #ifndef CONFIG_USB_EHCI_BIG_ENDIAN_DESC
@@ -226,14 +240,14 @@ static int ehci_platform_probe(struct platform_device *dev)
 		dev_err(&dev->dev,
 			"Error: CONFIG_USB_EHCI_BIG_ENDIAN_DESC not set\n");
 		err = -EINVAL;
-		goto err_put_clks;
+		goto err_reset;
 	}
 #endif
 
 	if (pdata->power_on) {
 		err = pdata->power_on(dev);
 		if (err < 0)
-			goto err_put_clks;
+			goto err_reset;
 	}
 
 	hcd->rsrc_start = res_mem->start;
@@ -256,6 +270,9 @@ static int ehci_platform_probe(struct platform_device *dev)
 err_power:
 	if (pdata->power_off)
 		pdata->power_off(dev);
+err_reset:
+	if (priv->rst)
+		reset_control_assert(priv->rst);
 err_put_clks:
 	while (--clk >= 0)
 		clk_put(priv->clks[clk]);
@@ -280,6 +297,9 @@ static int ehci_platform_remove(struct platform_device *dev)
 	if (pdata->power_off)
 		pdata->power_off(dev);
 
+	if (priv->rst)
+		reset_control_assert(priv->rst);
+
 	for (clk = 0; clk < EHCI_MAX_CLKS && priv->clks[clk]; clk++)
 		clk_put(priv->clks[clk]);
 
-- 
1.9.3

