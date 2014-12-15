Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbaLOQQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:16:32 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57059 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751370AbaLOQP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:15:59 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Mike Turquette <mturquette@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 4/5] rtc: at91: request IRQs with IRQF_SUSPEND_NOACTION
Date: Mon, 15 Dec 2014 17:15:51 +0100
Message-Id: <1418660152-17185-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418660152-17185-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1418660152-17185-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IRQ line connected to RTC blocks are often shared with a timer device
which request the IRQ with IRQF_NO_SUSPEND.
Since the RTC drivers are correctly disabling IRQs when entering suspend
we can safely request the IRQ with IRQF_SUSPEND_NOACTION so that irq core
can suspend this specific handler.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/rtc/rtc-at91rm9200.c | 2 +-
 drivers/rtc/rtc-at91sam9.c   | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 70a5d94..0ed504f 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -401,7 +401,7 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 					AT91_RTC_CALEV);
 
 	ret = devm_request_irq(&pdev->dev, irq, at91_rtc_interrupt,
-				IRQF_SHARED,
+				IRQF_SHARED | IRQF_SUSPEND_NOACTION,
 				"at91_rtc", pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "IRQ %d already in use.\n", irq);
diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index 6b9aaf1..e7f8eed 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -421,7 +421,8 @@ static int at91_rtc_probe(struct platform_device *pdev)
 
 	/* register irq handler after we know what name we'll use */
 	ret = devm_request_irq(&pdev->dev, rtc->irq, at91_rtc_interrupt,
-				IRQF_SHARED, dev_name(&rtc->rtcdev->dev), rtc);
+				IRQF_SHARED | IRQF_SUSPEND_NOACTION,
+				dev_name(&rtc->rtcdev->dev), rtc);
 	if (ret) {
 		dev_dbg(&pdev->dev, "can't share IRQ %d?\n", rtc->irq);
 		return ret;
-- 
1.9.1

