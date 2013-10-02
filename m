Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3JBMsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:48:04 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43387 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab3JBMsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:48:02 -0400
Message-ID: <1380718076.7307.1.camel@phoenix>
Subject: [PATCH v2 1/2] regulator: as3722: Fix equation to calculate max_uV
 in regulator_lin_range macro
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Florian Lobmaier <florian.lobmaier@ams.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 02 Oct 2013 20:47:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix off-by-one in the equation to calculate max_uV and also adjust the _min_uV
setting accordingly.

For LDOs:
The voltage select bits set the LDO output voltage 0.825V...3.3V, 25mV steps
  ....00h : LDO off
  01h-24h : V_LDO4 = 0.8V + ldo4_vsel * 25mV
                   = 0.825V + (ldo4_vsel - 1h) * 25mV
  25h-3Fh : do not use
  40h-7Fh : V_LDO4 = 1.725V + (ldo4_vsel - 40h) * 25mV

For SD2345:
The voltage select bits set the DC/DC output voltage level and power the DC/DC
converter down.
  ....00h : DC/DC powered down
  01h-40h : V_SD2 = 0.6V + sd2_vsel * 12.5mV
                  = 0.6125V + (sd2_vsel - 1h) * 12.5mV
  41h-70h : V_SD2 = 1.4V + (sd2_vsel - 40h) * 25mV
                  = 1.425V + (sd2_vsel - 41h) * 25mV
  71h-7Fh : V_SD2 = 2.6V + (sd2_vsel - 70h) * 50mV
                  = 2.65V + (sd2_vsel - 71h) * 50mV

Note, the third entry in as3722_sd2345_ranges is wrong in current code.
Fix it based on the datasheet.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/as3722-regulator.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/as3722-regulator.c b/drivers/regulator/as3722-regulator.c
index 16a5d26..01a8b17 100644
--- a/drivers/regulator/as3722-regulator.c
+++ b/drivers/regulator/as3722-regulator.c
@@ -441,11 +441,11 @@ static struct regulator_ops as3722_ldo3_extcntrl_ops = {
 		.max_sel = _max_sel,					\
 		.uV_step = _step_uV,					\
 		.min_uV = _min_uV,					\
-		.max_uV = _min_uV + (_max_sel - _min_sel + 1) * _step_uV, \
+		.max_uV = _min_uV + (_max_sel - _min_sel) * _step_uV,	\
 	}
 
 static const struct regulator_linear_range as3722_ldo_ranges[] = {
-	regulator_lin_range(0x01, 0x24,  800000, 25000),
+	regulator_lin_range(0x01, 0x24,  825000, 25000),
 	regulator_lin_range(0x40, 0x7F, 1725000, 25000),
 };
 
@@ -605,9 +605,9 @@ static int as3722_sd016_set_current_limit(struct regulator_dev *rdev,
 }
 
 static const struct regulator_linear_range as3722_sd2345_ranges[] = {
-	regulator_lin_range(0x01, 0x40,  600000, 12500),
-	regulator_lin_range(0x41, 0x70, 1400000, 25000),
-	regulator_lin_range(0x71, 0x7F, 1725000, 50000),
+	regulator_lin_range(0x01, 0x40,  612500, 12500),
+	regulator_lin_range(0x41, 0x70, 1425000, 25000),
+	regulator_lin_range(0x71, 0x7F, 2650000, 50000),
 };
 
 static struct regulator_ops as3722_sd016_ops = {
-- 
1.8.1.2



