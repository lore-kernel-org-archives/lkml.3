Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaFDLiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:38:20 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:58924 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbaFDLgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:36:09 -0400
From: nyushchenko@dev.rtsoft.ru
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru,
        Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH 17/21] rtc-mpc5121: use devm_irq_of_parse_and_map()
Date: Wed,  4 Jun 2014 15:13:17 +0400
Message-Id: <1401880402-30091-18-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>

This avoids leak of IRQ mapping on error paths, and makes it possible
to use devm_request_irq() without facing unmap-while-handler-installed
issues.

Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
---
 drivers/rtc/rtc-mpc5121.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
index dc4f142..c62e5eb 100644
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -328,22 +328,34 @@ static int mpc5121_rtc_probe(struct platform_device *op)
 
 	platform_set_drvdata(op, rtc);
 
-	rtc->irq = irq_of_parse_and_map(op->dev.of_node, 1);
-	err = request_irq(rtc->irq, mpc5121_rtc_handler, 0,
+	rtc->irq = devm_irq_of_parse_and_map(&op->dev, op->dev.of_node, 1);
+	if (rtc->irq <= 0) {
+		dev_err(&op->dev, "%s: could not locate irq\n", __func__);
+		err = rtc->irq ? rtc->irq : -EINVAL;
+		goto out;
+	}
+	err = devm_request_irq(&op->dev, rtc->irq, mpc5121_rtc_handler, 0,
 						"mpc5121-rtc", &op->dev);
 	if (err) {
 		dev_err(&op->dev, "%s: could not request irq: %i\n",
 							__func__, rtc->irq);
-		goto out_dispose;
+		goto out;
 	}
 
-	rtc->irq_periodic = irq_of_parse_and_map(op->dev.of_node, 0);
-	err = request_irq(rtc->irq_periodic, mpc5121_rtc_handler_upd,
+	rtc->irq_periodic = devm_irq_of_parse_and_map(&op->dev,
+				op->dev.of_node, 0);
+	if (rtc->irq_periodic <= 0) {
+		dev_err(&op->dev, "%s: could not locate irq\n", __func__);
+		err = rtc->irq_periodic ? rtc->irq_periodic : -EINVAL;
+		goto out;
+	}
+	err = devm_request_irq(&op->dev, rtc->irq_periodic,
+				mpc5121_rtc_handler_upd,
 				0, "mpc5121-rtc_upd", &op->dev);
 	if (err) {
 		dev_err(&op->dev, "%s: could not request irq: %i\n",
 						__func__, rtc->irq_periodic);
-		goto out_dispose2;
+		goto out;
 	}
 
 	if (of_device_is_compatible(op->dev.of_node, "fsl,mpc5121-rtc")) {
@@ -364,19 +376,13 @@ static int mpc5121_rtc_probe(struct platform_device *op)
 
 	if (IS_ERR(rtc->rtc)) {
 		err = PTR_ERR(rtc->rtc);
-		goto out_free_irq;
+		goto out;
 	}
 	rtc->rtc->uie_unsupported = 1;
 
 	return 0;
 
-out_free_irq:
-	free_irq(rtc->irq_periodic, &op->dev);
-out_dispose2:
-	irq_dispose_mapping(rtc->irq_periodic);
-	free_irq(rtc->irq, &op->dev);
-out_dispose:
-	irq_dispose_mapping(rtc->irq);
+out:
 	iounmap(rtc->regs);
 
 	return err;
@@ -392,10 +398,6 @@ static int mpc5121_rtc_remove(struct platform_device *op)
 	out_8(&regs->int_enable, in_8(&regs->int_enable) & ~0x1);
 
 	iounmap(rtc->regs);
-	free_irq(rtc->irq, &op->dev);
-	free_irq(rtc->irq_periodic, &op->dev);
-	irq_dispose_mapping(rtc->irq);
-	irq_dispose_mapping(rtc->irq_periodic);
 
 	return 0;
 }
-- 
1.7.10.4

