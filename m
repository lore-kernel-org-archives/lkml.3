Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaCGNpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:45:06 -0500
Received: from top.free-electrons.com ([176.31.233.9]:38731 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751683AbaCGNpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:45:04 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux@arm.linux.org.uk,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] i2c: mv64xxx: Fix circular dependencies warning and compilation breakage
Date: Fri,  7 Mar 2014 14:43:15 +0100
Message-Id: <1394199795-5516-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140307111858.GB12274@katana>
References: <20140307111858.GB12274@katana>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the circular dependency introduced by commit 370136bc67c3
("i2c: mv64xxx: Add reset deassert call"):

drivers/video/Kconfig:42:error: recursive dependency detected!

Since the reset framework doesn't define dummy stubs whenever
CONFIG_RESET_CONTROLLER is not defined, it's the only sane way to have a driver
that compiles in any cases.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/i2c/busses/Kconfig       |  1 -
 drivers/i2c/busses/i2c-mv64xxx.c | 22 +++++++++++++---------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 70bcad9..f5ed031 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -528,7 +528,6 @@ config I2C_MPC
 config I2C_MV64XXX
 	tristate "Marvell mv64xxx I2C Controller"
 	depends on (MV64X60 || PLAT_ORION || ARCH_SUNXI)
-	select RESET_CONTROLLER
 	help
 	  If you say yes to this option, support will be included for the
 	  built-in I2C interface on the Marvell 64xxx line of host bridges.
diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 203a548..a1dc99b 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -768,14 +768,16 @@ mv64xxx_of_config(struct mv64xxx_i2c_data *drv_data,
 	}
 	drv_data->irq = irq_of_parse_and_map(np, 0);
 
-	drv_data->rstc = devm_reset_control_get(dev, NULL);
-	if (IS_ERR(drv_data->rstc)) {
-		if (PTR_ERR(drv_data->rstc) == -EPROBE_DEFER) {
-			rc = -EPROBE_DEFER;
-			goto out;
+	if (IS_ENABLED(CONFIG_RESET_CONTROLLER)) {
+		drv_data->rstc = devm_reset_control_get(dev, NULL);
+		if (IS_ERR(drv_data->rstc)) {
+			if (PTR_ERR(drv_data->rstc) == -EPROBE_DEFER) {
+				rc = -EPROBE_DEFER;
+				goto out;
+			}
+		} else {
+			reset_control_deassert(drv_data->rstc);
 		}
-	} else {
-		reset_control_deassert(drv_data->rstc);
 	}
 
 	/* Its not yet defined how timeouts will be specified in device tree.
@@ -900,7 +902,8 @@ mv64xxx_i2c_probe(struct platform_device *pd)
 exit_free_irq:
 	free_irq(drv_data->irq, drv_data);
 exit_reset:
-	if (pd->dev.of_node && !IS_ERR(drv_data->rstc))
+	if (pd->dev.of_node && IS_ENABLED(CONFIG_RESET_CONTROLLER) &&
+	    !IS_ERR(drv_data->rstc))
 		reset_control_assert(drv_data->rstc);
 exit_clk:
 #if defined(CONFIG_HAVE_CLK)
@@ -920,7 +923,8 @@ mv64xxx_i2c_remove(struct platform_device *dev)
 
 	i2c_del_adapter(&drv_data->adapter);
 	free_irq(drv_data->irq, drv_data);
-	if (dev->dev.of_node && !IS_ERR(drv_data->rstc))
+	if (dev->dev.of_node && IS_ENABLED(CONFIG_RESET_CONTROLLER) &&
+	    !IS_ERR(drv_data->rstc))
 		reset_control_assert(drv_data->rstc);
 #if defined(CONFIG_HAVE_CLK)
 	/* Not all platforms have a clk */
-- 
1.9.0

