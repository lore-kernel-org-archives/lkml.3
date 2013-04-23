Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3DWEgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 00:36:00 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:38515 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab3DWEf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 00:35:59 -0400
Message-ID: <1366691753.25625.6.camel@phoenix>
Subject: [PATCH] regulator: tps62360: Fix off-by-one shift for ramp_ctrl
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Date: Tue, 23 Apr 2013 12:35:53 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheet[1]

Register 0x06h Description: RmpCtrl (REGISTER ADDRESS: 0x06h Read/Write)
BIT[5..7]:
        RMP[2:0] Output voltage ramp timing
        D7-D5   Slope
        000     32mV/us
        001     16mV/us
        010     8mV/us
        ...
        110     0.5mV/us
        111     0.25mV/us

Thus to get correct ramp_ctrl value, we need to right-shift 5 bits.

[1] http://www.ti.com/lit/ds/symlink/tps62360.pdf

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps62360-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index acbd63f..612919c 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -278,7 +278,7 @@ static int tps62360_init_dcdc(struct tps62360_chip *tps,
 			__func__, REG_RAMPCTRL, ret);
 		return ret;
 	}
-	ramp_ctrl = (ramp_ctrl >> 4) & 0x7;
+	ramp_ctrl = (ramp_ctrl >> 5) & 0x7;
 
 	/* ramp mV/us = 32/(2^ramp_ctrl) */
 	tps->desc.ramp_delay = DIV_ROUND_UP(32000, BIT(ramp_ctrl));
-- 
1.7.10.4



