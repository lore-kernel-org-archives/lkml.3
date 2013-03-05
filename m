Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab3CEGQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 01:16:14 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:34061 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3CEGQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 01:16:13 -0500
Message-ID: <1362464160.1111.1.camel@phoenix>
Subject: [PATCH RESEND 1/3] regulator: core: Add enable_is_inverted flag to
 indicate set enable_mask bits to disable
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        "Jett.Zhou" <jtzhou@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 14:16:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add enable_is_inverted flag to indicate set enable_mask bits to disable
when using regulator_enable_regmap and friends APIs.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Reviewed-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
This patch was sent on https://lkml.org/lkml/2013/2/16/14.
This resend is against linux-next tree (20130305).

 drivers/regulator/core.c         |   24 ++++++++++++++++++++----
 include/linux/regulator/driver.h |    3 +++
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cea0217..d420c8f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1905,7 +1905,10 @@ int regulator_is_enabled_regmap(struct regulator_dev *rdev)
 	if (ret != 0)
 		return ret;
 
-	return (val & rdev->desc->enable_mask) != 0;
+	if (rdev->desc->enable_is_inverted)
+		return (val & rdev->desc->enable_mask) == 0;
+	else
+		return (val & rdev->desc->enable_mask) != 0;
 }
 EXPORT_SYMBOL_GPL(regulator_is_enabled_regmap);
 
@@ -1920,9 +1923,15 @@ EXPORT_SYMBOL_GPL(regulator_is_enabled_regmap);
  */
 int regulator_enable_regmap(struct regulator_dev *rdev)
 {
+	unsigned int val;
+
+	if (rdev->desc->enable_is_inverted)
+		val = 0;
+	else
+		val = rdev->desc->enable_mask;
+
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
-				  rdev->desc->enable_mask,
-				  rdev->desc->enable_mask);
+				  rdev->desc->enable_mask, val);
 }
 EXPORT_SYMBOL_GPL(regulator_enable_regmap);
 
@@ -1937,8 +1946,15 @@ EXPORT_SYMBOL_GPL(regulator_enable_regmap);
  */
 int regulator_disable_regmap(struct regulator_dev *rdev)
 {
+	unsigned int val;
+
+	if (rdev->desc->enable_is_inverted)
+		val = rdev->desc->enable_mask;
+	else
+		val = 0;
+
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
-				  rdev->desc->enable_mask, 0);
+				  rdev->desc->enable_mask, val);
 }
 EXPORT_SYMBOL_GPL(regulator_disable_regmap);
 
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index a741bb6..5e2d13d 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -200,6 +200,8 @@ enum regulator_type {
  *                output when using regulator_set_voltage_sel_regmap
  * @enable_reg: Register for control when using regmap enable/disable ops
  * @enable_mask: Mask for control when using regmap enable/disable ops
+ * @enable_is_inverted: A flag to indicate set enable_mask bits to disable
+ *                      when using regulator_enable_regmap and friends APIs.
  * @bypass_reg: Register for control when using regmap set_bypass
  * @bypass_mask: Mask for control when using regmap set_bypass
  *
@@ -229,6 +231,7 @@ struct regulator_desc {
 	unsigned int apply_bit;
 	unsigned int enable_reg;
 	unsigned int enable_mask;
+	bool enable_is_inverted;
 	unsigned int bypass_reg;
 	unsigned int bypass_mask;
 
-- 
1.7.9.5



