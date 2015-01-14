Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbbANKWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 05:22:10 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:34662 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbbANKWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 05:22:06 -0500
From: Max Filippov <jcmvbkbc@gmail.com>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] i2c-ocores: add common clock support
Date: Wed, 14 Jan 2015 13:21:39 +0300
Message-Id: <1421230899-7843-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow bus clock specification as a common clock handle. This makes this
controller easier to use in a setup based on common clock framework.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 .../devicetree/bindings/i2c/i2c-ocores.txt         |  4 ++-
 drivers/i2c/busses/i2c-ocores.c                    | 38 ++++++++++++++++++++--
 2 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-ocores.txt b/Documentation/devicetree/bindings/i2c/i2c-ocores.txt
index 1637c29..4b4c5a3 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-ocores.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-ocores.txt
@@ -4,7 +4,9 @@ Required properties:
 - compatible      : "opencores,i2c-ocores" or "aeroflexgaisler,i2cmst"
 - reg             : bus address start and address range size of device
 - interrupts      : interrupt number
-- clock-frequency : frequency of bus clock in Hz
+- clk             : handle to bus clock (mutually exclusive with
+                    clock-frequency)
+- clock-frequency : frequency of bus clock in Hz (mutually exclusive with clk)
 - #address-cells  : should be <1>
 - #size-cells     : should be <0>
 
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index 7249b5b..f97c5c8 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -12,6 +12,7 @@
  * kind, whether express or implied.
  */
 
+#include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -36,6 +37,7 @@ struct ocores_i2c {
 	int nmsgs;
 	int state; /* see STATE_ */
 	int clock_khz;
+	struct clk *clk;
 	void (*setreg)(struct ocores_i2c *i2c, int reg, u8 value);
 	u8 (*getreg)(struct ocores_i2c *i2c, int reg);
 };
@@ -320,9 +322,23 @@ static int ocores_i2c_of_probe(struct platform_device *pdev,
 	}
 
 	if (of_property_read_u32(np, "clock-frequency", &val)) {
-		dev_err(&pdev->dev,
-			"Missing required parameter 'clock-frequency'\n");
-		return -ENODEV;
+		struct clk *clk = devm_clk_get(&pdev->dev, NULL);
+
+		if (!IS_ERR(clk)) {
+			int ret = clk_prepare_enable(clk);
+
+			if (ret) {
+				dev_err(&pdev->dev,
+					"clk_prepare_enable failed: %d\n", ret);
+				return ret;
+			}
+			i2c->clk = clk;
+			val = clk_get_rate(clk);
+		} else {
+			dev_err(&pdev->dev,
+				"Missing required parameter 'clock-frequency'\n");
+			return -ENODEV;
+		}
 	}
 	i2c->clock_khz = val / 1000;
 
@@ -446,6 +462,9 @@ static int ocores_i2c_remove(struct platform_device *pdev)
 	/* remove adapter & data */
 	i2c_del_adapter(&i2c->adap);
 
+	if (i2c->clk)
+		clk_disable_unprepare(i2c->clk);
+
 	return 0;
 }
 
@@ -458,6 +477,9 @@ static int ocores_i2c_suspend(struct device *dev)
 	/* make sure the device is disabled */
 	oc_setreg(i2c, OCI2C_CONTROL, ctrl & ~(OCI2C_CTRL_EN|OCI2C_CTRL_IEN));
 
+	if (i2c->clk)
+		clk_disable_unprepare(i2c->clk);
+
 	return 0;
 }
 
@@ -465,6 +487,16 @@ static int ocores_i2c_resume(struct device *dev)
 {
 	struct ocores_i2c *i2c = dev_get_drvdata(dev);
 
+	if (i2c->clk) {
+		int ret = clk_prepare_enable(i2c->clk);
+
+		if (ret) {
+			dev_err(&pdev->dev,
+				"clk_prepare_enable failed: %d\n", ret);
+			return ret;
+		}
+	}
+
 	ocores_init(i2c);
 
 	return 0;
-- 
1.8.1.4

