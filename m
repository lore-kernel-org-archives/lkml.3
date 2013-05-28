Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab3E1Vns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:43:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59506 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab3E1VVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:21:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 08/78] drivers/rtc/rtc-at91rm9200.c: fix missing iounmap
Date: Tue, 28 May 2013 14:19:17 -0700
Message-Id: <1369776027-17859-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 3427de92ac70a064098ff843c72ac76c420bb1cb upstream.

Add missing iounmap to probe error path and remove.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/rtc/rtc-at91rm9200.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index b6469e2..086fb35 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -298,7 +298,7 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 	if (ret) {
 		printk(KERN_ERR "at91_rtc: IRQ %d already in use.\n",
 				irq);
-		return ret;
+		goto err_unmap;
 	}
 
 	/* cpu init code should really have flagged this device as
@@ -310,13 +310,20 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
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
@@ -333,6 +340,7 @@ static int __exit at91_rtc_remove(struct platform_device *pdev)
 	free_irq(irq, pdev);
 
 	rtc_device_unregister(rtc);
+	iounmap(at91_rtc_regs);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.8.1.2

