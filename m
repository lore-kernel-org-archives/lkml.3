Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582AbaJURvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:51:08 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:51238 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933383AbaJURo4 (ORCPT
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
Subject: [PATCH v2 16/20] rtc: omap: enable wake-up from power off
Date: Tue, 21 Oct 2014 19:38:02 +0200
Message-Id: <1413913086-12730-17-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1413913086-12730-1-git-send-email-johan@kernel.org>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1413913086-12730-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ALARM interrupt must not be disabled during shutdown in order to be
able to power up the system using an RTC alarm.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/rtc/rtc-omap.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index f6c93f877857..cb5ef3c845d1 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -687,8 +687,15 @@ static SIMPLE_DEV_PM_OPS(omap_rtc_pm_ops, omap_rtc_suspend, omap_rtc_resume);
 static void omap_rtc_shutdown(struct platform_device *pdev)
 {
 	struct omap_rtc *rtc = platform_get_drvdata(pdev);
+	u8 mask;
 
-	rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, 0);
+	/*
+	 * Keep the ALARM interrupt enabled to allow the system to power up on
+	 * alarm events.
+	 */
+	mask = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
+	mask &= OMAP_RTC_INTERRUPTS_IT_ALARM;
+	rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, mask);
 }
 
 static struct platform_driver omap_rtc_driver = {
-- 
2.0.4

