Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbaFZSbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:31:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47118 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbaFZSbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:31:43 -0400
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
CC: Keerthy <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <t-kristo@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH] regulator: tps65917: Fix SMPS enable/disable/is_enable
Date: Thu, 26 Jun 2014 13:31:34 -0500
Message-ID: <1403807494-23907-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use regmap regulator ops to enable/disable and check if regulator
is enabled for various SMPS. However, these depend on valid
enable_reg, enable_mask and enable_value in regulator descriptor.

So, similar to fix we did in commit 318dbb02b50c
("regulator: palmas: Fix SMPS enable/disable/is_enabled"), populate the
same for TPS65917 SMPS registration. LDO definitions are already in place.

Fixes: d6f83370ed97 ("regulator: palmas: Add tps65917 PMIC support")
Signed-off-by: Nishanth Menon <nm@ti.com>
---

Applies on:
	git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git
branch: topic/palmas (4c0c9ca Merge remote-tracking branch 'regulator/fix/palmas' into regulator-palmas)

Note: Ignored the minor style check from checkpatch --strict as fixing
it would create an 80 char warning

 drivers/regulator/palmas-regulator.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 7c8b441..c7aa1b1 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -1333,6 +1333,14 @@ static int tps65917_smps_registration(struct palmas_pmic *pmic,
 		pmic->current_reg_mode[id] = reg &
 				PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
 
+		pmic->desc[id].enable_reg =
+				PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
+					palmas_regs_info[id].ctrl_addr);
+		pmic->desc[id].enable_mask =
+				PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
+		/* set_mode overrides this value */
+		pmic->desc[id].enable_val = SMPS_CTRL_MODE_ON;
+
 		pmic->desc[id].type = REGULATOR_VOLTAGE;
 		pmic->desc[id].owner = THIS_MODULE;
 
-- 
1.7.9.5

