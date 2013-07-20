Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab3GTGVx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 02:21:53 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:46244 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab3GTGV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 02:21:29 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 1/2] media: i2c: adv7343: make the platform data members as array
Date: Sat, 20 Jul 2013 11:51:05 +0530
Message-Id: <1374301266-26726-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374301266-26726-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1374301266-26726-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch makes the platform data members as array wherever
possible, so as this makes easier while collecting the data
in DT case and read the entire array at once.

This patch also makes appropriate changes to board-da850-evm.c

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/mach-davinci/board-da850-evm.c |    6 ++----
 drivers/media/i2c/adv7343.c             |   28 ++++++++++++++--------------
 include/media/adv7343.h                 |   20 ++++----------------
 3 files changed, 20 insertions(+), 34 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index e6f5b5d..ab6bdbe 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -733,12 +733,10 @@ static struct tvp514x_platform_data tvp5146_pdata = {
 
 static struct adv7343_platform_data adv7343_pdata = {
 	.mode_config = {
-		.dac_3 = 1,
-		.dac_2 = 1,
-		.dac_1 = 1,
+		.dac = { 1, 1, 1 },
 	},
 	.sd_config = {
-		.sd_dac_out1 = 1,
+		.sd_dac_out = { 1 },
 	},
 };
 
diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
index 8080c2c..f0238fb 100644
--- a/drivers/media/i2c/adv7343.c
+++ b/drivers/media/i2c/adv7343.c
@@ -227,12 +227,12 @@ static int adv7343_setoutput(struct v4l2_subdev *sd, u32 output_type)
 	else
 		val = state->pdata->mode_config.sleep_mode << 0 |
 		      state->pdata->mode_config.pll_control << 1 |
-		      state->pdata->mode_config.dac_3 << 2 |
-		      state->pdata->mode_config.dac_2 << 3 |
-		      state->pdata->mode_config.dac_1 << 4 |
-		      state->pdata->mode_config.dac_6 << 5 |
-		      state->pdata->mode_config.dac_5 << 6 |
-		      state->pdata->mode_config.dac_4 << 7;
+		      state->pdata->mode_config.dac[2] << 2 |
+		      state->pdata->mode_config.dac[1] << 3 |
+		      state->pdata->mode_config.dac[0] << 4 |
+		      state->pdata->mode_config.dac[5] << 5 |
+		      state->pdata->mode_config.dac[4] << 6 |
+		      state->pdata->mode_config.dac[3] << 7;
 
 	err = adv7343_write(sd, ADV7343_POWER_MODE_REG, val);
 	if (err < 0)
@@ -251,15 +251,15 @@ static int adv7343_setoutput(struct v4l2_subdev *sd, u32 output_type)
 	/* configure SD DAC Output 2 and SD DAC Output 1 bit to zero */
 	val = state->reg82 & (SD_DAC_1_DI & SD_DAC_2_DI);
 
-	if (state->pdata && state->pdata->sd_config.sd_dac_out1)
-		val = val | (state->pdata->sd_config.sd_dac_out1 << 1);
-	else if (state->pdata && !state->pdata->sd_config.sd_dac_out1)
-		val = val & ~(state->pdata->sd_config.sd_dac_out1 << 1);
+	if (state->pdata && state->pdata->sd_config.sd_dac_out[0])
+		val = val | (state->pdata->sd_config.sd_dac_out[0] << 1);
+	else if (state->pdata && !state->pdata->sd_config.sd_dac_out[0])
+		val = val & ~(state->pdata->sd_config.sd_dac_out[0] << 1);
 
-	if (state->pdata && state->pdata->sd_config.sd_dac_out2)
-		val = val | (state->pdata->sd_config.sd_dac_out2 << 2);
-	else if (state->pdata && !state->pdata->sd_config.sd_dac_out2)
-		val = val & ~(state->pdata->sd_config.sd_dac_out2 << 2);
+	if (state->pdata && state->pdata->sd_config.sd_dac_out[1])
+		val = val | (state->pdata->sd_config.sd_dac_out[1] << 2);
+	else if (state->pdata && !state->pdata->sd_config.sd_dac_out[1])
+		val = val & ~(state->pdata->sd_config.sd_dac_out[1] << 2);
 
 	err = adv7343_write(sd, ADV7343_SD_MODE_REG2, val);
 	if (err < 0)
diff --git a/include/media/adv7343.h b/include/media/adv7343.h
index 944757b..e4142b1 100644
--- a/include/media/adv7343.h
+++ b/include/media/adv7343.h
@@ -28,12 +28,7 @@
  * @pll_control: PLL and oversampling control. This control allows internal
  *		 PLL 1 circuit to be powered down and the oversampling to be
  *		 switched off.
- * @dac_1: power on/off DAC 1.
- * @dac_2: power on/off DAC 2.
- * @dac_3: power on/off DAC 3.
- * @dac_4: power on/off DAC 4.
- * @dac_5: power on/off DAC 5.
- * @dac_6: power on/off DAC 6.
+ * @dac: array to configure power on/off DAC's 1..6
  *
  * Power mode register (Register 0x0), for more info refer REGISTER MAP ACCESS
  * section of datasheet[1], table 17 page no 30.
@@ -43,23 +38,16 @@
 struct adv7343_power_mode {
 	bool sleep_mode;
 	bool pll_control;
-	bool dac_1;
-	bool dac_2;
-	bool dac_3;
-	bool dac_4;
-	bool dac_5;
-	bool dac_6;
+	u32 dac[6];
 };
 
 /**
  * struct adv7343_sd_config - SD Only Output Configuration.
- * @sd_dac_out1: Configure SD DAC Output 1.
- * @sd_dac_out2: Configure SD DAC Output 2.
+ * @sd_dac_out: array configuring SD DAC Outputs 1 and 2
  */
 struct adv7343_sd_config {
 	/* SD only Output Configuration */
-	bool sd_dac_out1;
-	bool sd_dac_out2;
+	u32 sd_dac_out[2];
 };
 
 /**
-- 
1.7.9.5

