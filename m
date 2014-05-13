Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaEMPpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:45:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40106 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753751AbaEMPpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:45:10 -0400
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
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH RESEND v4 6/8] usb: ohci-platform: Enable optional use of reset controller
Date: Tue, 13 May 2014 17:44:20 +0200
Message-Id: <1399995862-17788-7-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1399995862-17788-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1399995862-17788-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OHCI controllers used in the Allwinner A31 are asserted in reset using a
global reset controller.

Add optional support for such a controller in the OHCI platform driver.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 Documentation/devicetree/bindings/usb/usb-ohci.txt |  1 +
 drivers/usb/host/ohci-platform.c                   | 27 +++++++++++++++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/usb-ohci.txt b/Documentation/devicetree/bindings/usb/usb-ohci.txt
index 45f67d91e888..b968a1aea995 100644
--- a/Documentation/devicetree/bindings/usb/usb-ohci.txt
+++ b/Documentation/devicetree/bindings/usb/usb-ohci.txt
@@ -12,6 +12,7 @@ Optional properties:
 - clocks : a list of phandle + clock specifier pairs
 - phys : phandle + phy specifier pair
 - phy-names : "usb"
+- resets : phandle + reset specifier pair
 
 Example:
 
diff --git a/drivers/usb/host/ohci-platform.c b/drivers/usb/host/ohci-platform.c
index b6002c951c5c..4369299064c7 100644
--- a/drivers/usb/host/ohci-platform.c
+++ b/drivers/usb/host/ohci-platform.c
@@ -24,6 +24,7 @@
 #include <linux/err.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/reset.h>
 #include <linux/usb/ohci_pdriver.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
@@ -36,6 +37,7 @@
 
 struct ohci_platform_priv {
 	struct clk *clks[OHCI_MAX_CLKS];
+	struct reset_control *rst;
 	struct phy *phy;
 };
 
@@ -191,6 +193,19 @@ static int ohci_platform_probe(struct platform_device *dev)
 				break;
 			}
 		}
+
+	}
+
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
 	}
 
 	if (pdata->big_endian_desc)
@@ -203,7 +218,7 @@ static int ohci_platform_probe(struct platform_device *dev)
 		dev_err(&dev->dev,
 			"Error: CONFIG_USB_OHCI_BIG_ENDIAN_MMIO not set\n");
 		err = -EINVAL;
-		goto err_put_clks;
+		goto err_reset;
 	}
 #endif
 #ifndef CONFIG_USB_OHCI_BIG_ENDIAN_DESC
@@ -211,14 +226,14 @@ static int ohci_platform_probe(struct platform_device *dev)
 		dev_err(&dev->dev,
 			"Error: CONFIG_USB_OHCI_BIG_ENDIAN_DESC not set\n");
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
@@ -242,6 +257,9 @@ static int ohci_platform_probe(struct platform_device *dev)
 err_power:
 	if (pdata->power_off)
 		pdata->power_off(dev);
+err_reset:
+	if (priv->rst)
+		reset_control_assert(priv->rst);
 err_put_clks:
 	while (--clk >= 0)
 		clk_put(priv->clks[clk]);
@@ -266,6 +284,9 @@ static int ohci_platform_remove(struct platform_device *dev)
 	if (pdata->power_off)
 		pdata->power_off(dev);
 
+	if (priv->rst)
+		reset_control_assert(priv->rst);
+
 	for (clk = 0; clk < OHCI_MAX_CLKS && priv->clks[clk]; clk++)
 		clk_put(priv->clks[clk]);
 
-- 
1.9.3

