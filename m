Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967901Ab3DSDO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 23:14:57 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38253 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967861Ab3DSDOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 23:14:55 -0400
Message-ID: <1366341289.18636.2.camel@phoenix>
Subject: [PATCH RFT] regulator: palmas: Remove wrong voltage setting for
 enabling LDO8 tracking mode
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 19 Apr 2013 11:14:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When SMPS45 is set to off and LDO8 tracking is enabled, LDO8 output can be set
from 0.45 to 1.65V and the steps of voltage change is 25mV.

This is done by setting:
        pmic->desc[id].min_uV = 450000;
        pmic->desc[id].uV_step = 25000;

I don't see the point of reading vsel register, multiple the register value by
2 and then write back to the register.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Laxman,

Current code looks strange (and wrong) to me.
I don't see the point of reading vsel register, multiple the register value by
2 and then write back to the register.
Can you double check this patch, in case I might misunderstand the code.

Thanks,
Axel

 drivers/regulator/palmas-regulator.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 67ed5e5d..f26344e 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -643,24 +643,6 @@ static void palmas_enable_ldo8_track(struct palmas *palmas)
 		dev_err(palmas->dev, "Error in enabling tracking mode\n");
 		return;
 	}
-	/*
-	 * When SMPS45 is set to off and LDO8 tracking is enabled, the LDO8
-	 * output is defined by the LDO8_VOLTAGE.VSEL register divided by two,
-	 * and can be set from 0.45 to 1.65 V.
-	 */
-	addr = palmas_regs_info[PALMAS_REG_LDO8].vsel_addr;
-	ret = palmas_ldo_read(palmas, addr, &reg);
-	if (ret) {
-		dev_err(palmas->dev, "Error in reading ldo8 voltage reg\n");
-		return;
-	}
-
-	reg = (reg << 1) & PALMAS_LDO8_VOLTAGE_VSEL_MASK;
-	ret = palmas_ldo_write(palmas, addr, reg);
-	if (ret < 0)
-		dev_err(palmas->dev, "Error in setting ldo8 voltage reg\n");
-
-	return;
 }
 
 static struct of_regulator_match palmas_matches[] = {
-- 
1.7.10.4



