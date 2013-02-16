Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab3BPCKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 21:10:07 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:48568 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3BPCKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 21:10:05 -0500
Message-ID: <1360980594.6332.1.camel@phoenix>
Subject: [PATCH] regulator: twl: Convert twl4030ldo_ops to get_voltage_sel
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tero Kristo <t-kristo@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2013 10:09:54 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes an inconsistent behavior between list_voltage() and get_voltage()
because current implementation of get_voltage() does not check the case
IS_UNSUP() is true.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/twl-regulator.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 683d314..d62604c0 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -465,24 +465,23 @@ twl4030ldo_set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
 			    selector);
 }
 
-static int twl4030ldo_get_voltage(struct regulator_dev *rdev)
+static int twl4030ldo_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
-	int		vsel = twlreg_read(info, TWL_MODULE_PM_RECEIVER,
-								VREG_VOLTAGE);
+	int vsel = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_VOLTAGE);
 
 	if (vsel < 0)
 		return vsel;
 
 	vsel &= info->table_len - 1;
-	return LDO_MV(info->table[vsel]) * 1000;
+	return vsel;
 }
 
 static struct regulator_ops twl4030ldo_ops = {
 	.list_voltage	= twl4030ldo_list_voltage,
 
 	.set_voltage_sel = twl4030ldo_set_voltage_sel,
-	.get_voltage	= twl4030ldo_get_voltage,
+	.get_voltage_sel = twl4030ldo_get_voltage_sel,
 
 	.enable		= twl4030reg_enable,
 	.disable	= twl4030reg_disable,
-- 
1.7.9.5



