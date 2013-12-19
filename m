Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab3LSPzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:55:36 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50066 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab3LSPzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:55:33 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, broonie@kernel.org, alsa-devel@alsa-project.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/11] ASoC: ux500: Provide better checking for Device Tree and/or Platform Data
Date: Thu, 19 Dec 2013 15:55:00 +0000
Message-Id: <1387468508-12286-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
References: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These drivers will not work without platform specific data, which is
passed in via Device Tree or Platform Data. To avoid the chance of
NULL pointer dereferencing and alike, let's ensure we have at least
one of the methods in play before continuing.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_msp_dai.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index c6fb5cc..bc042cc 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -771,10 +771,14 @@ static const struct snd_soc_component_driver ux500_msp_component = {
 static int ux500_msp_drv_probe(struct platform_device *pdev)
 {
 	struct ux500_msp_i2s_drvdata *drvdata;
+	struct msp_i2s_platform_data *pdata = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
 	int ret = 0;
 
-	dev_dbg(&pdev->dev, "%s: Enter (pdev->name = %s).\n", __func__,
-		pdev->name);
+	if (!pdata && !np) {
+		dev_err(&pdev->dev, "No platform data or Device Tree found\n");
+		return -ENODEV;
+	}
 
 	drvdata = devm_kzalloc(&pdev->dev,
 				sizeof(struct ux500_msp_i2s_drvdata),
-- 
1.8.3.2

