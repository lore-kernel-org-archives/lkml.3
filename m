Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab3JUCzc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 22:55:32 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:50734 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab3JUCzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 22:55:31 -0400
MIME-Version: 1.0
Date: Mon, 21 Oct 2013 10:55:29 +0800
Message-ID: <CAPgLHd8TpMFSUqCePW6=Ef_6_w39goayhQZO-fnu4_QJ10wfnA@mail.gmail.com>
Subject: [PATCH -next] pinctrl: tb10x: fix the error handling in tb10x_pinctrl_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linus.walleij@linaro.org, grant.likely@linaro.org, rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

This patch fix the error handling in tb10x_pinctrl_probe():
 - devm_ioremap_resource() return ERR_PTR() and never return NULL
 - remove the dev_err call to avoid redundant error message
 - pinctrl_register() returns NULL not ERR_PTR()

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/pinctrl/pinctrl-tb10x.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-tb10x.c b/drivers/pinctrl/pinctrl-tb10x.c
index 2e1ea56..9f7fa9b 100644
--- a/drivers/pinctrl/pinctrl-tb10x.c
+++ b/drivers/pinctrl/pinctrl-tb10x.c
@@ -806,9 +806,8 @@ static int tb10x_pinctrl_probe(struct platform_device *pdev)
 	mutex_init(&state->mutex);
 
 	state->base = devm_ioremap_resource(dev, mem);
-	if (!state->base) {
-		dev_err(dev, "Request register region failed.\n");
-		ret = -EBUSY;
+	if (IS_ERR(state->base)) {
+		ret = PTR_ERR(state->base);
 		goto fail;
 	}
 
@@ -830,9 +829,9 @@ static int tb10x_pinctrl_probe(struct platform_device *pdev)
 	}
 
 	state->pctl = pinctrl_register(&tb10x_pindesc, dev, state);
-	if (IS_ERR(state->pctl)) {
+	if (!state->pctl) {
 		dev_err(dev, "could not register TB10x pin driver\n");
-		ret = PTR_ERR(state->pctl);
+		ret = -EINVAL;
 		goto fail;
 	}
 

