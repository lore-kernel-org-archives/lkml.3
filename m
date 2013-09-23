Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3IWKEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:04:24 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:45287 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab3IWKEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:04:23 -0400
MIME-Version: 1.0
Date: Mon, 23 Sep 2013 18:04:19 +0800
Message-ID: <CAPgLHd-m5dyhN=ECp463ts12CO-f8HJuQqhp-U5fY4cNrbo1hQ@mail.gmail.com>
Subject: [PATCH] tps65090-charger: drop devm_free_irq of devm_ allocated irq
From: Wei Yongjun <weiyj.lk@gmail.com>
To: anton@enomsg.org, dwmw2@infradead.org, grant.likely@linaro.org,
        rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The devm_request_irq function allocates irq that is released
when a driver detaches. Thus, there is no reason to explicitly
call devm_free_irq in probe or remove functions.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/power/tps65090-charger.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/power/tps65090-charger.c b/drivers/power/tps65090-charger.c
index bdd7b9b..14b6e79 100644
--- a/drivers/power/tps65090-charger.c
+++ b/drivers/power/tps65090-charger.c
@@ -277,13 +277,13 @@ static int tps65090_charger_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(cdata->dev, "Unable to register irq %d err %d\n", irq,
 			ret);
-		goto fail_free_irq;
+		goto fail_unregister_supply;
 	}
 
 	ret = tps65090_config_charger(cdata);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "charger config failed, err %d\n", ret);
-		goto fail_free_irq;
+		goto fail_unregister_supply;
 	}
 
 	/* Check for charger presence */
@@ -292,14 +292,14 @@ static int tps65090_charger_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(cdata->dev, "%s(): Error in reading reg 0x%x", __func__,
 			TPS65090_REG_CG_STATUS1);
-		goto fail_free_irq;
+		goto fail_unregister_supply;
 	}
 
 	if (status1 != 0) {
 		ret = tps65090_enable_charging(cdata);
 		if (ret < 0) {
 			dev_err(cdata->dev, "error enabling charger\n");
-			goto fail_free_irq;
+			goto fail_unregister_supply;
 		}
 		cdata->ac_online = 1;
 		power_supply_changed(&cdata->ac);
@@ -307,8 +307,6 @@ static int tps65090_charger_probe(struct platform_device *pdev)
 
 	return 0;
 
-fail_free_irq:
-	devm_free_irq(cdata->dev, irq, cdata);
 fail_unregister_supply:
 	power_supply_unregister(&cdata->ac);
 
@@ -319,7 +317,6 @@ static int tps65090_charger_remove(struct platform_device *pdev)
 {
 	struct tps65090_charger *cdata = platform_get_drvdata(pdev);
 
-	devm_free_irq(cdata->dev, cdata->irq, cdata);
 	power_supply_unregister(&cdata->ac);
 
 	return 0;

