Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab3LTOsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:48:36 -0500
Received: from mail-gg0-f178.google.com ([209.85.161.178]:58393 "EHLO
	mail-gg0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3LTOsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:48:35 -0500
X-Greylist: delayed 3963 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Dec 2013 09:48:35 EST
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: shawn.guo@linaro.org, b20788@freescale.com, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [RFC] regulator: anatop-regulator: Also provide a delay when voltage decreases
Date: Fri, 20 Dec 2013 12:48:22 -0200
Message-Id: <1387550902-6086-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Currently we only wait for a delay for the LDO voltages to settle when it goes
from a lower voltage to a higher one.

Also provide the delay when the opposite transition happens.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Hi Anson/Shawn,

I could not find in the reference manual anywhere that says that the delay
should de done only when the voltage increases.


 drivers/regulator/anatop-regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 7d7c05e..843c5d1 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -70,7 +70,7 @@ static int anatop_regmap_set_voltage_time_sel(struct regulator_dev *reg,
 	int ret = 0;
 
 	/* check whether need to care about LDO ramp up speed */
-	if (anatop_reg->delay_bit_width && new_sel > old_sel) {
+	if (anatop_reg->delay_bit_width) {
 		/*
 		 * the delay for LDO ramp up time is
 		 * based on the register setting, we need
@@ -80,7 +80,7 @@ static int anatop_regmap_set_voltage_time_sel(struct regulator_dev *reg,
 		regmap_read(anatop_reg->anatop, anatop_reg->delay_reg, &val);
 		val = (val >> anatop_reg->delay_bit_shift) &
 			((1 << anatop_reg->delay_bit_width) - 1);
-		ret = (new_sel - old_sel) * (LDO_RAMP_UP_UNIT_IN_CYCLES <<
+		ret = abs(new_sel - old_sel) * (LDO_RAMP_UP_UNIT_IN_CYCLES <<
 			val) / LDO_RAMP_UP_FREQ_IN_MHZ + 1;
 	}
 
-- 
1.8.1.2

