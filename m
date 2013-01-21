Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3AURjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:39:01 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:49772 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3AURjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:39:00 -0500
From: Matt Sealey <matt@genesi-usa.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org,
        Matt Sealey <matt@genesi-usa.com>, Shawn Guo <shawn.guo@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] mc13892-regulator: correct/refine handling of the SWxHI bit
Date: Mon, 21 Jan 2013 11:38:40 -0600
Message-Id: <1358789920-1341-1-git-send-email-matt@genesi-usa.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MC13892 PMIC supports a "HI" bit for 3 of it's 4 buck switcher outputs,
which enables a higher set of voltage ranges.

Despite a comment in the code ('sw regulators need special care due to the
"hi" bit'), it actually does not take special care since it does not modify
it's use of the selector table index when this bit is set, giving us very
odd behavior when setting a high voltage on supported switchers or listing
current voltages. Net effect is in best case the kernel and sysfs report
lower voltages than are actually set in hardware (1300mV instead of 1800mV
for example) and in the worst case setting a voltage (e.g. 1800mV) will cause
an undervoltage condition (e.g. 1300mV).

Correct the behavior, taking into account SW1 doesn't support the HI bit,
and as such we need to ignore it.

While we are modifying these functions, fix and optimize the following;

* set_voltage_sel callback was using .reg instead of .vsel_reg - since
  they were set to the same value it actually didn't break anything but
  it would be semantically incorrect to use .reg in this case. We now use
  .vsel_reg and be consistent.
* vsel_shift is always 0 for every SWx regulator, and constantly shifting
  and masking off the bottom few bits is time consuming and makes the
  code very hard to read - optimize this out.
* get_voltage_sel uses the variable "val" and set_voltage_sel uses the
  variable "selector" (and reg_value). Introduce the variable "selector"
  to get_voltage_sel such that it makes more sense and allow some leaner
  code in light of the modifications in this patch. Add better exposure
  to the debug print so the register value AND the selector are printed as
  this will adequately show the HI bit in the register.
* correct a comment in probe which is doing a version check. Magic
  values are awful but for once instance, a comment does just as
  good a job as something symbolic.

Signed-off-by: Matt Sealey <matt@genesi-usa.com>
Tested-by: Steev Klimaszewski <steev@genesi-usa.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/mc13892-regulator.c |   72 +++++++++++++++++++++++++--------
 1 file changed, 56 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 0d84b1f..169457b 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -164,6 +164,14 @@ static const unsigned int mc13892_sw1[] = {
 	1350000, 1375000
 };
 
+/*
+ * Note: this table is used to derive SWxVSEL by index into
+ * the array. Offset the values by the index of 1100000uV
+ * to get the actual register value for that voltage selector
+ * if the HI bit is to be set as well.
+ */
+#define MC13892_SWxHI_SEL_OFFSET		20
+
 static const unsigned int mc13892_sw[] = {
 	600000,   625000,  650000,  675000,  700000,  725000,
 	750000,   775000,  800000,  825000,  850000,  875000,
@@ -239,7 +247,6 @@ static const unsigned int mc13892_pwgtdrv[] = {
 };
 
 static struct regulator_ops mc13892_gpo_regulator_ops;
-/* sw regulators need special care due to the "hi bit" */
 static struct regulator_ops mc13892_sw_regulator_ops;
 
 
@@ -396,7 +403,7 @@ static int mc13892_sw_regulator_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
 	int ret, id = rdev_get_id(rdev);
-	unsigned int val;
+	unsigned int val, selector;
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
 
@@ -407,12 +414,28 @@ static int mc13892_sw_regulator_get_voltage_sel(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	val = (val & mc13892_regulators[id].vsel_mask)
-		>> mc13892_regulators[id].vsel_shift;
+	/*
+	 * Figure out if the HI bit is set inside the switcher mode register
+	 * since this means the selector value we return is at a different
+	 * offset into the selector table.
+	 *
+	 * According to the MC13892 documentation note 59 (Table 47) the SW1
+	 * buck switcher does not support output range programming therefore
+	 * the HI bit must always remain 0. So do not do anything strange if
+	 * our register is MC13892_SWITCHERS0.
+	 */
+
+	selector = val & mc13892_regulators[id].vsel_mask;
+
+	if ((mc13892_regulators[id].vsel_reg != MC13892_SWITCHERS0) &&
+	    (val & MC13892_SWITCHERS0_SWxHI)) {
+		selector += MC13892_SWxHI_SEL_OFFSET;
+	}
 
-	dev_dbg(rdev_get_dev(rdev), "%s id: %d val: %d\n", __func__, id, val);
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d val: 0x%08x selector: %d\n",
+			__func__, id, val, selector);
 
-	return val;
+	return selector;
 }
 
 static int mc13892_sw_regulator_set_voltage_sel(struct regulator_dev *rdev,
@@ -425,18 +448,35 @@ static int mc13892_sw_regulator_set_voltage_sel(struct regulator_dev *rdev,
 
 	volt = rdev->desc->volt_table[selector];
 	mask = mc13892_regulators[id].vsel_mask;
-	reg_value = selector << mc13892_regulators[id].vsel_shift;
-
-	if (volt > 1375000) {
-		mask |= MC13892_SWITCHERS0_SWxHI;
-		reg_value |= MC13892_SWITCHERS0_SWxHI;
-	} else if (volt < 1100000) {
-		mask |= MC13892_SWITCHERS0_SWxHI;
-		reg_value &= ~MC13892_SWITCHERS0_SWxHI;
+	reg_value = selector;
+
+	/*
+	 * Don't mess with the HI bit or support HI voltage offsets for SW1.
+	 *
+	 * Since the get_voltage_sel callback has given a fudged value for
+	 * the selector offset, we need to back out that offset if HI is
+	 * to be set so we write the correct value to the register.
+	 *
+	 * The HI bit addition and selector offset handling COULD be more
+	 * complicated by shifting and masking off the voltage selector part
+	 * of the register then logical OR it back in, but since the selector
+	 * is at bits 4:0 there is very little point. This makes the whole
+	 * thing more readable and we do far less work.
+	 */
+
+	if (mc13892_regulators[id].vsel_reg != MC13892_SWITCHERS0) {
+		if (volt > 1375000) {
+			reg_value -= MC13892_SWxHI_SEL_OFFSET;
+			reg_value |= MC13892_SWITCHERS0_SWxHI;
+			mask |= MC13892_SWITCHERS0_SWxHI;
+		} else if (volt < 1100000) {
+			reg_value &= ~MC13892_SWITCHERS0_SWxHI;
+			mask |= MC13892_SWITCHERS0_SWxHI;
+		}
 	}
 
 	mc13xxx_lock(priv->mc13xxx);
-	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13892_regulators[id].reg, mask,
+	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13892_regulators[id].vsel_reg, mask,
 			      reg_value);
 	mc13xxx_unlock(priv->mc13xxx);
 
@@ -520,7 +560,7 @@ static int mc13892_regulator_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_unlock;
 
-	/* enable switch auto mode */
+	/* enable switch auto mode (on 2.0A silicon only) */
 	if ((val & 0x0000FFFF) == 0x45d0) {
 		ret = mc13xxx_reg_rmw(mc13892, MC13892_SWITCHERS4,
 			MC13892_SWITCHERS4_SW1MODE_M |
-- 
1.7.10.4

