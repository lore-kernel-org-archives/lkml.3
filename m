Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab3DXDvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 23:51:20 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48849 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab3DXDvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 23:51:19 -0400
Message-ID: <1366775472.22788.1.camel@phoenix>
Subject: [PATCH] regulator: mc13892: Fix MC13892_SWITCHERS0_SWxHI bit in
 set_voltage_sel
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Matt Sealey <matt@genesi-usa.com>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Yong Shen <yong.shen@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 24 Apr 2013 11:51:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is necessary to clear MC13892_SWITCHERS0_SWxHI bit when set voltage to the
voltage range from 1100000 to 1375000. Leaving MC13892_SWITCHERS0_SWxHI bit
untouched may result in wrong voltage setting.

For example, currently switch voltage from 1400000 to 1300000 will set the
voltage to 1800000 because the HI bit is still set.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/mc13892-regulator.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 9891aec..cc76c52 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -465,13 +465,13 @@ static int mc13892_sw_regulator_set_voltage_sel(struct regulator_dev *rdev,
 	 */
 
 	if (mc13892_regulators[id].vsel_reg != MC13892_SWITCHERS0) {
+		mask |= MC13892_SWITCHERS0_SWxHI;
+
 		if (volt > 1375000) {
 			reg_value -= MC13892_SWxHI_SEL_OFFSET;
 			reg_value |= MC13892_SWITCHERS0_SWxHI;
-			mask |= MC13892_SWITCHERS0_SWxHI;
-		} else if (volt < 1100000) {
+		} else {
 			reg_value &= ~MC13892_SWITCHERS0_SWxHI;
-			mask |= MC13892_SWITCHERS0_SWxHI;
 		}
 	}
 
-- 
1.7.10.4



