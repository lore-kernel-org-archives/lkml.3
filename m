Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935195AbaFTR0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:26:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41394 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935146AbaFTR0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:26:30 -0400
From: Nishanth Menon <nm@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <acourbot@nvidia.com>, <gnurou@gmail.com>, <j-keerthy@ti.com>,
        <linux-tegra@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH] regulator: palmas: Fix SMPS enable/disable/is_enabled
Date: Fri, 20 Jun 2014 12:26:23 -0500
Message-ID: <1403285183-15926-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use regmap regulator ops to enable/disable and check if regulator
is enabled for various SMPS. However, these depend on valid
enable_reg, enable_mask and enable_value in regulator descriptor.

Currently we do not populate these for SMPS other than SMPS10, this
results in spurious results as regmap assumes that the values are
valid and ends up reading register 0x0 RTC:SECONDS_REG on Palmas
variants that do have RTC! To fix this, we update proper parameters
for the descriptor fields.

Further, we want to ensure the behavior consistent with logic
prior to commit dbabd624d4eec50b6, where, once you do a set_mode,
enable/disable ensure the logic remains consistent and configures
Palmas to the configuration that we set with set_mode (since the
configuration register is common). To do this, we can rely on the
regulator core's regulator_register behavior where the regulator
descriptor pointer provided by the regulator driver is stored. (no
reallocation and copy is done). This lets us update the enable_value
post registration, to remain consistent with the mode we configure as
part of set_mode.

Fixes: dbabd624d4eec50b6 ("regulator: palmas: Reemove open coded functions with helper functions")
Reported-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---

NOTE: there is a minor checkpatch check warning- but trying to fix
it makes the code inconsistent with remaining code flow, so, I have
chosen to ignore it.

CHECK: Alignment should match open parenthesis
#56: FILE: drivers/regulator/palmas-regulator.c:974:
+					PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
+						palmas_regs_info[id].ctrl_addr);

total: 0 errors, 0 warnings, 1 checks, 24 lines checked

Original Report: http://marc.info/?t=140316427500004&r=1&w=2 
Debug: http://marc.info/?t=140327063500007&r=1&w=2

 drivers/regulator/palmas-regulator.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index b982f0f..3c861d5 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -325,6 +325,10 @@ static int palmas_set_mode_smps(struct regulator_dev *dev, unsigned int mode)
 	if (rail_enable)
 		palmas_smps_write(pmic->palmas,
 			palmas_regs_info[id].ctrl_addr, reg);
+
+	/* Switch the enable value to ensure this is used for enable */
+	pmic->desc[id].enable_val = pmic->current_reg_mode[id];
+
 	return 0;
 }
 
@@ -964,6 +968,14 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 				return ret;
 			pmic->current_reg_mode[id] = reg &
 					PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
+
+			pmic->desc[id].enable_reg =
+					PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
+						palmas_regs_info[id].ctrl_addr);
+			pmic->desc[id].enable_mask =
+					PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
+			/* set_mode overrides this value */
+			pmic->desc[id].enable_val = SMPS_CTRL_MODE_ON;
 		}
 
 		pmic->desc[id].type = REGULATOR_VOLTAGE;
-- 
1.7.9.5

