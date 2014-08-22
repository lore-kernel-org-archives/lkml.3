Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbaHVMOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:14:55 -0400
Received: from 132.79-246-81.adsl-static.isp.belgacom.be ([81.246.79.132]:42683
	"EHLO viper.mind.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbaHVMOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:14:54 -0400
From: "Arnout Vandecappelle (Essensium/Mind)" <arnout@mind.be>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        David Brown <davidb@codeaurora.org>,
        "Arnout Vandecappelle (Essensium/Mind)" <arnout@mind.be>
Subject: [PATCH] tps65910: Work around silicon erratum SWCZ010
Date: Fri, 22 Aug 2014 14:14:26 +0200
Message-Id: <1408709666-5927-1-git-send-email-arnout@mind.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From http://www.ti.com/lit/pdf/SWCZ010 :

Glitch on SDA-SCL not managed correctly by the I2C IP

Impact:
The standard specifies that the I2C transfer should restart on a start
event in all cases. The current design does not support two consecutive
Start conditions. This can cause the first real access after such a
glitch to be corrupted.

Description:
An unexpected glitch on SDA and SCL can generate a wrong start event.
In the current design, the SCL line must toggle two times to detect a
new start event and completely restart the I2C access; hence the real
start event is not detected in the case of a single SCL toggle.

Workaround:
Repeat I2C access.

The first access to the tps65910 that we do is when loading the regmap
in the probe function. If there has been a glitch during boot and the
erratum is triggered, then the regmap loading will fail with -REMOTEIO
since the I2C transfer is not ACKed by the tps65910.

A simple retry will work around it, because a subsequent I2C start
condition is detected properly by the tps65910.

Signed-off-by: Arnout Vandecappelle (Essensium/Mind) <arnout@mind.be>
---
This patch is based on v3.17-rc1.
Build-tested with omap2plus_defconfig.
Runtime tested based on v3.4.97 with a custom config.
---
 drivers/mfd/tps65910.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index f243e75..cc1ca33 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -487,8 +487,18 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	tps65910->id = chip_id;
 
 	tps65910->regmap = devm_regmap_init_i2c(i2c, &tps65910_regmap_config);
-	if (IS_ERR(tps65910->regmap)) {
+	if (IS_ERR(tps65910->regmap))
 		ret = PTR_ERR(tps65910->regmap);
+	if (ret == -EREMOTEIO) {
+		dev_warn(&i2c->dev, "regmap initialization failed, possibly due to erratum SWCZ010; trying again\n");
+		tps65910->regmap = regmap_init_i2c(i2c,
+			&tps65910_regmap_config);
+		if (IS_ERR(tps65910->regmap))
+			ret = PTR_ERR(tps65910->regmap);
+		else
+			ret = 0;
+	}
+	if (ret) {
 		dev_err(&i2c->dev, "regmap initialization failed: %d\n", ret);
 		return ret;
 	}
-- 
2.1.0

