Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615AbaJURvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:51:12 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:34657 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375AbaJURo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:44:56 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Felipe Balbi <balbi@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH v2 03/20] rtc: omap: fix interrupt disable at probe
Date: Tue, 21 Oct 2014 19:37:49 +0200
Message-Id: <1413913086-12730-4-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1413913086-12730-1-git-send-email-johan@kernel.org>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1413913086-12730-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use writel instead of writeb when disabling interrupts at probe as
ALARM2 is not cleared otherwise on some IP-block revisions (e.g.
AM3352).

Note that the driver currently never enables the ALARM2 interrupt.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/rtc/rtc-omap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 828cb9983cc2..813d475fe7c6 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -427,10 +427,12 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	}
 	platform_set_drvdata(pdev, rtc);
 
-	/* clear pending irqs, and set 1/second periodic,
-	 * which we'll use instead of update irqs
+	/*
+	 * disable interrupts
+	 *
+	 * NOTE: ALARM2 is not cleared on AM3352 if rtc_write (writeb) is used
 	 */
-	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
+	rtc_writel(0, OMAP_RTC_INTERRUPTS_REG);
 
 	/* enable RTC functional clock */
 	if (id_entry->driver_data & OMAP_RTC_HAS_32KCLK_EN) {
-- 
2.0.4

