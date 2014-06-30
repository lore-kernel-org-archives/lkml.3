Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbaF3P5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:57:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58251 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbaF3P5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:57:47 -0400
From: Nishanth Menon <nm@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Keerthy J <j-keerthy@ti.com>
CC: Tero Kristo <t-kristo@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 6/6] regulator: palmas: Fix SMPS enable/disable/is_enable for tps65917
Date: Mon, 30 Jun 2014 10:57:39 -0500
Message-ID: <1404143859-8160-7-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404143859-8160-1-git-send-email-nm@ti.com>
References: <1404143859-8160-1-git-send-email-nm@ti.com>
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
same for TPS65917 SMPS registration. LDO definitions are already in
place.

Fixes: d6f83370ed97 ("regulator: palmas: Add tps65917 PMIC support")
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/regulator/palmas-regulator.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index ae0f639..a7ce34d 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -1312,6 +1312,11 @@ static int tps65917_smps_registration(struct palmas_pmic *pmic,
 			return ret;
 		pmic->current_reg_mode[id] = reg &
 				PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
+		desc->enable_reg = PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
+						      rinfo->ctrl_addr);
+		desc->enable_mask = PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
+		/* set_mode overrides this value */
+		desc->enable_val = SMPS_CTRL_MODE_ON;
 
 		desc->type = REGULATOR_VOLTAGE;
 		desc->owner = THIS_MODULE;
-- 
1.7.9.5

