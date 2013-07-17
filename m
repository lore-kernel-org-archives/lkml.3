Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3GQMQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:16:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54727 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab3GQMQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:16:19 -0400
From: Mark Brown <broonie@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Wed, 17 Jul 2013 13:16:09 +0100
Message-Id: <1374063369-20444-2-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374063369-20444-1-git-send-email-broonie@kernel.org>
References: <1374063369-20444-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 2/2] mfd: wm8994: Remove check for active audio in runtime suspend
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Since enabling VMID takes a runtime PM reference there is no need to
suppress suspend when doing a runtime suspend. Similarly the digital
inputs and outputs are DAPM widgets and therefore the ASoC core will
be holding a reference for them.

This used to be required when integration with system suspend was being
bodged.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mfd/wm8994-core.c | 30 +-----------------------------
 1 file changed, 1 insertion(+), 29 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index e8ecb8e..e1c283e 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -201,35 +201,7 @@ static int wm8994_suspend(struct device *dev)
 	int ret;
 
 	/* Don't actually go through with the suspend if the CODEC is
-	 * still active (eg, for audio passthrough from CP. */
-	ret = wm8994_reg_read(wm8994, WM8994_POWER_MANAGEMENT_1);
-	if (ret < 0) {
-		dev_err(dev, "Failed to read power status: %d\n", ret);
-	} else if (ret & WM8994_VMID_SEL_MASK) {
-		dev_dbg(dev, "CODEC still active, ignoring suspend\n");
-		return 0;
-	}
-
-	ret = wm8994_reg_read(wm8994, WM8994_POWER_MANAGEMENT_4);
-	if (ret < 0) {
-		dev_err(dev, "Failed to read power status: %d\n", ret);
-	} else if (ret & (WM8994_AIF2ADCL_ENA | WM8994_AIF2ADCR_ENA |
-			  WM8994_AIF1ADC2L_ENA | WM8994_AIF1ADC2R_ENA |
-			  WM8994_AIF1ADC1L_ENA | WM8994_AIF1ADC1R_ENA)) {
-		dev_dbg(dev, "CODEC still active, ignoring suspend\n");
-		return 0;
-	}
-
-	ret = wm8994_reg_read(wm8994, WM8994_POWER_MANAGEMENT_5);
-	if (ret < 0) {
-		dev_err(dev, "Failed to read power status: %d\n", ret);
-	} else if (ret & (WM8994_AIF2DACL_ENA | WM8994_AIF2DACR_ENA |
-			  WM8994_AIF1DAC2L_ENA | WM8994_AIF1DAC2R_ENA |
-			  WM8994_AIF1DAC1L_ENA | WM8994_AIF1DAC1R_ENA)) {
-		dev_dbg(dev, "CODEC still active, ignoring suspend\n");
-		return 0;
-	}
-
+	 * still active for accessory detect. */
 	switch (wm8994->type) {
 	case WM8958:
 	case WM1811:
-- 
1.8.3.2

