Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751016AbaHVTGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:06:39 -0400
Received: from 132.79-246-81.adsl-static.isp.belgacom.be ([81.246.79.132]:44324
	"EHLO viper.mind.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaHVTGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:06:38 -0400
From: "Arnout Vandecappelle (Essensium/Mind)" <arnout@mind.be>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        David Brown <davidb@codeaurora.org>,
        "Arnout Vandecappelle (Essensium/Mind)" <arnout@mind.be>
Subject: [PATCH v2] tps65910: Work around silicon erratum SWCZ010
Date: Fri, 22 Aug 2014 17:30:56 +0200
Message-Id: <1408721456-8101-1-git-send-email-arnout@mind.be>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408709666-5927-1-git-send-email-arnout@mind.be>
References: <1408709666-5927-1-git-send-email-arnout@mind.be>
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

A simpler workaround is to make a dummy transfer just before the first
access to the tps65910 chip. This can be done unconditionally.

Signed-off-by: Arnout Vandecappelle (Essensium/Mind) <arnout@mind.be>
---
This patch is based on v3.17-rc1.
Build-tested with omap2plus_defconfig.
Runtime tested based on v3.4.97 with a custom config.

v2: use dummy transfer instead of retrying (Laxman Dewangan)
---
 drivers/mfd/tps65910.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index f243e75..7612d89 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -486,6 +486,11 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	tps65910->i2c_client = i2c;
 	tps65910->id = chip_id;
 
+	/* Work around silicon erratum SWCZ010: the tps65910 may miss the
+	 * first I2C transfer. So issue a dummy transfer before the first
+	 * real transfer.
+	 */
+	i2c_master_send(i2c, "", 1);
 	tps65910->regmap = devm_regmap_init_i2c(i2c, &tps65910_regmap_config);
 	if (IS_ERR(tps65910->regmap)) {
 		ret = PTR_ERR(tps65910->regmap);
-- 
2.1.0

