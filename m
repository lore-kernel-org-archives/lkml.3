Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab3EXKk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 06:40:59 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:64847 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab3EXKjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 06:39:35 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 3/6] ASoC: ux500: Drop dangling struct i2s_controller
Date: Fri, 24 May 2013 12:39:17 +0200
Message-Id: <1369391960-27320-4-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1369391960-27320-1-git-send-email-fabio.baltieri@linaro.org>
References: <1369391960-27320-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop struct i2s_controller from the ux500 ASoC driver as right now it is
instantiated but not used anywhere.  Also drop a mismatched
device_unregister in the process.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 sound/soc/ux500/ux500_msp_i2s.c | 19 -------------------
 sound/soc/ux500/ux500_msp_i2s.h | 12 ------------
 2 files changed, 31 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index b029b2d..cba0e86 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -649,7 +649,6 @@ int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 			struct msp_i2s_platform_data *platform_data)
 {
 	struct resource *res = NULL;
-	struct i2s_controller *i2s_cont;
 	struct device_node *np = pdev->dev.of_node;
 	struct ux500_msp *msp;
 
@@ -694,22 +693,6 @@ int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 	msp->msp_state = MSP_STATE_IDLE;
 	msp->loopback_enable = 0;
 
-	/* I2S-controller is allocated and added in I2S controller class. */
-	i2s_cont = devm_kzalloc(&pdev->dev, sizeof(*i2s_cont), GFP_KERNEL);
-	if (!i2s_cont) {
-		dev_err(&pdev->dev,
-			"%s: ERROR: Failed to allocate I2S-controller!\n",
-			__func__);
-		return -ENOMEM;
-	}
-	i2s_cont->dev.parent = &pdev->dev;
-	i2s_cont->data = (void *)msp;
-	i2s_cont->id = (s16)msp->id;
-	snprintf(i2s_cont->name, sizeof(i2s_cont->name), "ux500-msp-i2s.%04x",
-		msp->id);
-	dev_dbg(&pdev->dev, "I2S device-name: '%s'\n", i2s_cont->name);
-	msp->i2s_cont = i2s_cont;
-
 	return 0;
 }
 
@@ -717,8 +700,6 @@ void ux500_msp_i2s_cleanup_msp(struct platform_device *pdev,
 			struct ux500_msp *msp)
 {
 	dev_dbg(msp->dev, "%s: Enter (id = %d).\n", __func__, msp->id);
-
-	device_unregister(&msp->i2s_cont->dev);
 }
 
 MODULE_LICENSE("GPL v2");
diff --git a/sound/soc/ux500/ux500_msp_i2s.h b/sound/soc/ux500/ux500_msp_i2s.h
index 8ce014e..ccfcc32 100644
--- a/sound/soc/ux500/ux500_msp_i2s.h
+++ b/sound/soc/ux500/ux500_msp_i2s.h
@@ -469,17 +469,6 @@ struct i2s_message {
 	size_t period_len;
 };
 
-struct i2s_controller {
-	struct module *owner;
-	unsigned int id;
-	unsigned int class;
-	const struct i2s_algorithm *algo; /* the algorithm to access the bus */
-	void *data;
-	struct mutex bus_lock;
-	struct device dev; /* the controller device */
-	char name[48];
-};
-
 struct ux500_msp_config {
 	unsigned int f_inputclk;
 	unsigned int rx_clk_sel;
@@ -515,7 +504,6 @@ struct ux500_msp {
 	enum enum_i2s_controller id;
 	void __iomem *registers;
 	struct device *dev;
-	struct i2s_controller *i2s_cont;
 	struct stedma40_chan_cfg *dma_cfg_rx;
 	struct stedma40_chan_cfg *dma_cfg_tx;
 	struct dma_chan *tx_pipeid;
-- 
1.8.2

