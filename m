Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaELTfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 15:35:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:32958 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754524AbaELTfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 15:35:08 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        kishon@ti.com, hdegoede@redhat.com
Cc: Boris Brezillon <boris@free-electrons.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v3 5/8] usb: ehci-platform: add optional reset controller retrieval
Date: Mon, 12 May 2014 21:34:31 +0200
Message-Id: <1399923274-6017-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1399923274-6017-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1399923274-6017-1-git-send-email-maxime.ripard@free-electrons.com>
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
---
 Documentation/devicetree/bindings/usb/usb-ehci.txt |  1 +
 drivers/usb/host/ehci-platform.c                   | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

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
index c7dd93aad20c..8bb15eda9713 100644
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
@@ -280,6 +294,9 @@ static int ehci_platform_remove(struct platform_device *dev)
 	if (pdata->power_off)
 		pdata->power_off(dev);
 
+	if (priv->rst)
+		reset_control_assert(priv->rst);
+
 	for (clk = 0; clk < EHCI_MAX_CLKS && priv->clks[clk]; clk++)
 		clk_put(priv->clks[clk]);
 
-- 
1.9.3

