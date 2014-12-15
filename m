Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaLOQQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:16:37 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57046 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751240AbaLOQP7 (ORCPT
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
Subject: [PATCH 3/5] watchdog: at91sam9: request the irq with IRQF_NO_SUSPEND
Date: Mon, 15 Dec 2014 17:15:50 +0100
Message-Id: <1418660152-17185-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418660152-17185-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1418660152-17185-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The watchdog interrupt (only used when activating software watchdog)
shouldn't be suspended when entering suspend mode, because it is shared
with a timer device (which request the line with IRQF_NO_SUSPEND) and once
the watchdog "Mode Register" has been written, it cannot be changed (which
means we cannot disable the watchdog interrupt when entering suspend).

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/watchdog/at91sam9_wdt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 6df9405..1443b3c 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -208,7 +208,8 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
 
 	if ((tmp & AT91_WDT_WDFIEN) && wdt->irq) {
 		err = request_irq(wdt->irq, wdt_interrupt,
-				  IRQF_SHARED | IRQF_IRQPOLL,
+				  IRQF_SHARED | IRQF_IRQPOLL |
+				  IRQF_NO_SUSPEND,
 				  pdev->name, wdt);
 		if (err)
 			return err;
-- 
1.9.1

