Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbaCDQci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:32:38 -0500
Received: from top.free-electrons.com ([176.31.233.9]:42135 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751630AbaCDQch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:32:37 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v3 1/5] i2c: mv64xxx: Add reset deassert call
Date: Tue,  4 Mar 2014 17:28:37 +0100
Message-Id: <1393950521-4173-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393950521-4173-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1393950521-4173-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A31 SoC using that IP has a reset controller maintaining
it reset unless told otherwise.

Add some optional reset support to the driver.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 .../devicetree/bindings/i2c/i2c-mv64xxx.txt         |  1 +
 drivers/i2c/busses/Kconfig                          |  1 +
 drivers/i2c/busses/i2c-mv64xxx.c                    | 21 +++++++++++++++++++--
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt b/Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt
index 582b465..21062bc 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt
@@ -16,6 +16,7 @@ Optional properties :
 
  - clock-frequency : Desired I2C bus clock frequency in Hz. If not set the
 default frequency is 100kHz
+ - resets          : phandle to the parent reset controller
 
 Examples:
 
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index f5ed031..70bcad9 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -528,6 +528,7 @@ config I2C_MPC
 config I2C_MV64XXX
 	tristate "Marvell mv64xxx I2C Controller"
 	depends on (MV64X60 || PLAT_ORION || ARCH_SUNXI)
+	select RESET_CONTROLLER
 	help
 	  If you say yes to this option, support will be included for the
 	  built-in I2C interface on the Marvell 64xxx line of host bridges.
diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index d52d849..1bb69b6 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -17,6 +17,7 @@
 #include <linux/interrupt.h>
 #include <linux/mv643xx_i2c.h>
 #include <linux/platform_device.h>
+#include <linux/reset.h>
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -148,6 +149,7 @@ struct mv64xxx_i2c_data {
 	bool			offload_enabled;
 /* 5us delay in order to avoid repeated start timing violation */
 	bool			errata_delay;
+	struct reset_control	*rstc;
 };
 
 static struct mv64xxx_i2c_regs mv64xxx_i2c_regs_mv64xxx = {
@@ -759,6 +761,16 @@ mv64xxx_of_config(struct mv64xxx_i2c_data *drv_data,
 	}
 	drv_data->irq = irq_of_parse_and_map(np, 0);
 
+	drv_data->rstc = devm_reset_control_get(dev, NULL);
+	if (IS_ERR(drv_data->rstc)) {
+		if (PTR_ERR(drv_data->rstc) == -EPROBE_DEFER) {
+			rc = -EPROBE_DEFER;
+			goto out;
+		}
+	} else {
+		reset_control_deassert(drv_data->rstc);
+	}
+
 	/* Its not yet defined how timeouts will be specified in device tree.
 	 * So hard code the value to 1 second.
 	 */
@@ -845,7 +857,7 @@ mv64xxx_i2c_probe(struct platform_device *pd)
 	}
 	if (drv_data->irq < 0) {
 		rc = -ENXIO;
-		goto exit_clk;
+		goto exit_reset;
 	}
 
 	drv_data->adapter.dev.parent = &pd->dev;
@@ -865,7 +877,7 @@ mv64xxx_i2c_probe(struct platform_device *pd)
 		dev_err(&drv_data->adapter.dev,
 			"mv64xxx: Can't register intr handler irq%d: %d\n",
 			drv_data->irq, rc);
-		goto exit_clk;
+		goto exit_reset;
 	} else if ((rc = i2c_add_numbered_adapter(&drv_data->adapter)) != 0) {
 		dev_err(&drv_data->adapter.dev,
 			"mv64xxx: Can't add i2c adapter, rc: %d\n", -rc);
@@ -876,6 +888,9 @@ mv64xxx_i2c_probe(struct platform_device *pd)
 
 exit_free_irq:
 	free_irq(drv_data->irq, drv_data);
+exit_reset:
+	if (pd->dev.of_node && !IS_ERR(drv_data->rstc))
+		reset_control_assert(drv_data->rstc);
 exit_clk:
 #if defined(CONFIG_HAVE_CLK)
 	/* Not all platforms have a clk */
@@ -894,6 +909,8 @@ mv64xxx_i2c_remove(struct platform_device *dev)
 
 	i2c_del_adapter(&drv_data->adapter);
 	free_irq(drv_data->irq, drv_data);
+	if (dev->dev.of_node && !IS_ERR(drv_data->rstc))
+		reset_control_assert(drv_data->rstc);
 #if defined(CONFIG_HAVE_CLK)
 	/* Not all platforms have a clk */
 	if (!IS_ERR(drv_data->clk)) {
-- 
1.9.0

