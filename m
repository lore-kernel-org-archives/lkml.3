Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410Ab3EGNpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:45:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42612 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933366Ab3EGNm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 110/118] drivers/rtc/rtc-at91rm9200.c: fix missing iounmap
Date: Tue,  7 May 2013 14:39:16 +0100
Message-Id: <1367933964-1564-111-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 3427de92ac70a064098ff843c72ac76c420bb1cb upstream.

Add missing iounmap to probe error path and remove.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/rtc/rtc-at91rm9200.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index dc474bc..9f2762c 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -297,7 +297,7 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 	if (ret) {
 		printk(KERN_ERR "at91_rtc: IRQ %d already in use.\n",
 				irq);
-		return ret;
+		goto err_unmap;
 	}
 
 	/* cpu init code should really have flagged this device as
@@ -309,13 +309,20 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 	rtc = rtc_device_register(pdev->name, &pdev->dev,
 				&at91_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
-		free_irq(irq, pdev);
-		return PTR_ERR(rtc);
+		ret = PTR_ERR(rtc);
+		goto err_free_irq;
 	}
 	platform_set_drvdata(pdev, rtc);
 
 	printk(KERN_INFO "AT91 Real Time Clock driver.\n");
 	return 0;
+
+err_free_irq:
+	free_irq(irq, pdev);
+err_unmap:
+	iounmap(at91_rtc_regs);
+
+	return ret;
 }
 
 /*
@@ -332,6 +339,7 @@ static int __exit at91_rtc_remove(struct platform_device *pdev)
 	free_irq(irq, pdev);
 
 	rtc_device_unregister(rtc);
+	iounmap(at91_rtc_regs);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.8.1.2

