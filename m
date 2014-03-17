Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbaCQJse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:48:34 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:2975 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371AbaCQJsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:48:33 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Mark Brown <broonie@kernel.org>, nicolas.ferre@atmel.com
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, Bo Shen <voice.shen@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] ASoC: atmel: support CCF based clks
Date: Mon, 17 Mar 2014 17:45:39 +0800
Message-Id: <1395049541-28128-7-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1395049541-28128-1-git-send-email-voice.shen@atmel.com>
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <b.brezillon@overkiz.com>

Provide dev to clk_get function if we're using CCF based clks.
CCF based prog clks support automatic parent selection when asking for a
specific rate: remove the clk32k clk retrieval if we're using these clks.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
[voice.shen@atmel.com: switch to devm manage function]
Signed-off-by: Bo Shen <voice.shen@atmel.com>

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

 sound/soc/atmel/atmel_wm8904.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/sound/soc/atmel/atmel_wm8904.c b/sound/soc/atmel/atmel_wm8904.c
index b4e3690..a797d33 100644
--- a/sound/soc/atmel/atmel_wm8904.c
+++ b/sound/soc/atmel/atmel_wm8904.c
@@ -170,25 +170,26 @@ static int atmel_asoc_wm8904_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	mclk = clk_get(NULL, "pck0");
+	mclk = devm_clk_get(&pdev->dev, "pck0");
 	if (IS_ERR(mclk)) {
 		dev_err(&pdev->dev, "failed to get pck0\n");
 		ret = PTR_ERR(mclk);
 		goto err_set_audio;
 	}
 
-	clk_src = clk_get(NULL, "clk32k");
-	if (IS_ERR(clk_src)) {
-		dev_err(&pdev->dev, "failed to get clk32k\n");
-		ret = PTR_ERR(clk_src);
-		goto err_set_audio;
-	}
+	if (!IS_ENABLED(CONFIG_COMMON_CLK)) {
+		clk_src = devm_clk_get(&pdev->dev, "clk32k");
+		if (IS_ERR(clk_src)) {
+			dev_err(&pdev->dev, "failed to get clk32k\n");
+			ret = PTR_ERR(clk_src);
+			goto err_set_audio;
+		}
 
-	ret = clk_set_parent(mclk, clk_src);
-	clk_put(clk_src);
-	if (ret != 0) {
-		dev_err(&pdev->dev, "failed to set MCLK parent\n");
-		goto err_set_audio;
+		ret = clk_set_parent(mclk, clk_src);
+		if (ret != 0) {
+			dev_err(&pdev->dev, "failed to set MCLK parent\n");
+			goto err_set_audio;
+		}
 	}
 
 	dev_info(&pdev->dev, "setting pck0 to %dHz\n", MCLK_RATE);
-- 
1.8.5.2

