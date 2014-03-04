Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaCDQcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:32:46 -0500
Received: from top.free-electrons.com ([176.31.233.9]:42141 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751630AbaCDQco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:32:44 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v3 2/5] i2c: mv64xxx: Add support for the Allwinner A31 I2C driver
Date: Tue,  4 Mar 2014 17:28:38 +0100
Message-Id: <1393950521-4173-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393950521-4173-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1393950521-4173-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A31 I2C controller is almost identical to the one used in the
other Allwinner SoCs, except for the fact that it needs to clear the interrupt
by setting the INT_FLAGS bit in the control register, instead of clearing it.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 .../devicetree/bindings/i2c/i2c-mv64xxx.txt         | 21 ++++++++++++++-------
 drivers/i2c/busses/i2c-mv64xxx.c                    | 11 +++++++++++
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt b/Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt
index 21062bc..befd4fb 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt
@@ -4,19 +4,26 @@
 Required properties :
 
  - reg             : Offset and length of the register set for the device
- - compatible      : Should be "marvell,mv64xxx-i2c" or "allwinner,sun4i-i2c"
-                     or "marvell,mv78230-i2c" or "marvell,mv78230-a0-i2c"
-                     Note: Only use "marvell,mv78230-a0-i2c" for a very rare,
-                     initial version of the SoC which had broken offload
-                     support.  Linux auto-detects this and sets it
-                     appropriately.
+ - compatible      : Should be either:
+                     - "allwinner,sun4i-i2c"
+                     - "allwinner,sun6i-a31-i2c"
+                     - "marvell,mv64xxx-i2c"
+                     - "marvell,mv78230-i2c"
+                     - "marvell,mv78230-a0-i2c"
+                       * Note: Only use "marvell,mv78230-a0-i2c" for a
+                         very rare, initial version of the SoC which
+                         had broken offload support.  Linux
+                         auto-detects this and sets it appropriately.
  - interrupts      : The interrupt number
 
 Optional properties :
 
  - clock-frequency : Desired I2C bus clock frequency in Hz. If not set the
 default frequency is 100kHz
- - resets          : phandle to the parent reset controller
+
+ - resets          : phandle to the parent reset controller. Mandatory
+                     whenever you're using the "allwinner,sun6i-a31-i2c"
+                     compatible.
 
 Examples:
 
diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 1bb69b6..203a548 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -150,6 +150,7 @@ struct mv64xxx_i2c_data {
 /* 5us delay in order to avoid repeated start timing violation */
 	bool			errata_delay;
 	struct reset_control	*rstc;
+	bool			irq_clear_inverted;
 };
 
 static struct mv64xxx_i2c_regs mv64xxx_i2c_regs_mv64xxx = {
@@ -568,6 +569,11 @@ mv64xxx_i2c_intr(int irq, void *dev_id)
 		status = readl(drv_data->reg_base + drv_data->reg_offsets.status);
 		mv64xxx_i2c_fsm(drv_data, status);
 		mv64xxx_i2c_do_action(drv_data);
+
+		if (drv_data->irq_clear_inverted)
+			writel(drv_data->cntl_bits | MV64XXX_I2C_REG_CONTROL_IFLG,
+			       drv_data->reg_base + drv_data->reg_offsets.control);
+
 		rc = IRQ_HANDLED;
 	}
 	spin_unlock_irqrestore(&drv_data->lock, flags);
@@ -687,6 +693,7 @@ static const struct i2c_algorithm mv64xxx_i2c_algo = {
  */
 static const struct of_device_id mv64xxx_i2c_of_match_table[] = {
 	{ .compatible = "allwinner,sun4i-i2c", .data = &mv64xxx_i2c_regs_sun4i},
+	{ .compatible = "allwinner,sun6i-a31-i2c", .data = &mv64xxx_i2c_regs_sun4i},
 	{ .compatible = "marvell,mv64xxx-i2c", .data = &mv64xxx_i2c_regs_mv64xxx},
 	{ .compatible = "marvell,mv78230-i2c", .data = &mv64xxx_i2c_regs_mv64xxx},
 	{ .compatible = "marvell,mv78230-a0-i2c", .data = &mv64xxx_i2c_regs_mv64xxx},
@@ -795,6 +802,10 @@ mv64xxx_of_config(struct mv64xxx_i2c_data *drv_data,
 		drv_data->offload_enabled = false;
 		drv_data->errata_delay = true;
 	}
+
+	if (of_device_is_compatible(np, "allwinner,sun6i-a31-i2c"))
+		drv_data->irq_clear_inverted = true;
+
 out:
 	return rc;
 #endif
-- 
1.9.0

