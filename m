Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbaIKNVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:21:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45937 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756967AbaIKNVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:21:37 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Johan Hovold <jhovold@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 3/9] rtc: at91sam9: replace devm_ioremap by devm_ioremap_resource
Date: Thu, 11 Sep 2014 15:18:39 +0200
Message-Id: <1410441525-25258-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410441525-25258-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1410441525-25258-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace devm_ioremap calls by devm_ioremap_resource which already check
resource consistency (resource != NULL) and print an error in case of
failure.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/rtc/rtc-at91sam9.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index 74a9ca0..38a2693 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -306,18 +306,11 @@ static const struct rtc_class_ops at91_rtc_ops = {
  */
 static int at91_rtc_probe(struct platform_device *pdev)
 {
-	struct resource	*r, *r_gpbr;
+	struct resource	*r;
 	struct sam9_rtc	*rtc;
 	int		ret, irq;
 	u32		mr;
 
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	r_gpbr = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (!r || !r_gpbr) {
-		dev_err(&pdev->dev, "need 2 ressources\n");
-		return -ENODEV;
-	}
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		dev_err(&pdev->dev, "failed to get interrupt resource\n");
@@ -335,18 +328,16 @@ static int at91_rtc_probe(struct platform_device *pdev)
 		device_init_wakeup(&pdev->dev, 1);
 
 	platform_set_drvdata(pdev, rtc);
-	rtc->rtt = devm_ioremap(&pdev->dev, r->start, resource_size(r));
-	if (!rtc->rtt) {
-		dev_err(&pdev->dev, "failed to map registers, aborting.\n");
-		return -ENOMEM;
-	}
 
-	rtc->gpbr = devm_ioremap(&pdev->dev, r_gpbr->start,
-				resource_size(r_gpbr));
-	if (!rtc->gpbr) {
-		dev_err(&pdev->dev, "failed to map gpbr registers, aborting.\n");
-		return -ENOMEM;
-	}
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	rtc->rtt = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(rtc->rtt))
+		return PTR_ERR(rtc->rtt);
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	rtc->gpbr = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(rtc->gpbr))
+		return PTR_ERR(rtc->rtt);
 
 	mr = rtt_readl(rtc, MR);
 
-- 
1.9.1

