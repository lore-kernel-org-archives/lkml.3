Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbaCDUzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:55:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750AbaCDUEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve Twiss <stwiss.opensource@diasemi.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13 129/172] regulator: da9063: Bug fix when setting max voltage on LDOs 5-11
Date: Tue,  4 Mar 2014 12:03:33 -0800
Message-Id: <20140304200303.841740658@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Twiss <stwiss.opensource@diasemi.com>

commit ebf6dad0de89677aa58a4d8b009014ff88a23452 upstream.

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
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/da9063-regulator.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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


