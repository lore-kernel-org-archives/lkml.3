Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaBLMjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 07:39:43 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.142]:22793 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751291AbaBLMjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 07:39:41 -0500
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-5.tower-179.messagelabs.com!1392208778!25856381!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201402121239.s1CCdZpd014527@swsrvapps-01.diasemi.com>
From: Steve Twiss <stwiss.opensource@diasemi.com>
Date: Wed, 12 Feb 2014 09:57:52 +0000
Subject: [PATCH V2] regulator: da9063: Bug fix when setting max voltage on
 LDOs 5-11
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Twiss <stwiss.opensource@diasemi.com>

Bug fix to allow the setting of maximum voltage for certain LDOs.

What the bug is:

There is a problem caused by an invalid calculation of n_voltages
in the driver. This n_voltages value has the potential to be
different for each regulator.

The value for linear_min_sel is set as DA9063_V##regl_name#
which can be different depending upon the regulator. This is
chosen according to the following definitions in the DA9063
registers.h file:

DA9063_VLDO1_BIAS	0
DA9063_VLDO2_BIAS	0
DA9063_VLDO3_BIAS	0
DA9063_VLDO4_BIAS	0
DA9063_VLDO5_BIAS	2
DA9063_VLDO6_BIAS	2
DA9063_VLDO7_BIAS	2
DA9063_VLDO8_BIAS	2
DA9063_VLDO9_BIAS	3
DA9063_VLDO10_BIAS	2
DA9063_VLDO11_BIAS	2

The calculation for n_voltages is valid for LDOs whose BIAS value
is zero but this is not correct for those LDOs which have a
non-zero value.

What the fix is:

In order to take into account the non-zero linear_min_sel value which 
is set for the regulators LDO5, LDO6, LDO7, LDO8, LDO9, LDO10 and
LDO11, the calculation for n_voltages should take into account the
missing term defined by DA9063_V##regl_name#.

This will in turn allow the core constraints calculation to set the
maximum voltage limits correctly and therefore allow users to apply
the maximum expected voltage to all of the LDOs.

Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
---
Checks performed with next-20140212/scripts/checkpatch.pl
 da9063-regulator.c        total: 0 errors, 5 warnings, 923 lines checked

This patch applies against kernel version linux-next next-20140212
There are several checkpatch warnings associated with this file
however they are not linked with this patch.

Regards,
Steve Twiss, Dialog Semiconductor Ltd.

Previous conversations
- https://lkml.org/lkml/2014/2/11/503



 drivers/regulator/da9063-regulator.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index 56727eb..91e99a2 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -1,3 +1,4 @@
+
 /*
  * Regulator driver for DA9063 PMIC series
  *
@@ -60,7 +61,8 @@ struct da9063_regulator_info {
 	.desc.ops = &da9063_ldo_ops, \
 	.desc.min_uV = (min_mV) * 1000, \
 	.desc.uV_step = (step_mV) * 1000, \
-	.desc.n_voltages = (((max_mV) - (min_mV))/(step_mV) + 1), \
+	.desc.n_voltages = (((max_mV) - (min_mV))/(step_mV) + 1 \
+		+ (DA9063_V##regl_name##_BIAS)), \
 	.desc.enable_reg = DA9063_REG_##regl_name##_CONT, \
 	.desc.enable_mask = DA9063_LDO_EN, \
 	.desc.vsel_reg = DA9063_REG_V##regl_name##_A, \
-- 
end-of-patch for PATCH V2

