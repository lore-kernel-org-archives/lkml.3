Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaJITPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:15:03 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:44594 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaJITMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:12:33 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>,
        AnilKumar Ch <anilkumar@ti.com>, nsekhar@ti.com, t-kristo@ti.com,
        j-keerthy@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 10/12] rtc: omap: enable wake-up from power off
Date: Thu,  9 Oct 2014 21:06:32 +0200
Message-Id: <1412881594-25678-11-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1412881594-25678-1-git-send-email-johan@kernel.org>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ALARM interrupt must not be disabled during shutdown in order to be
able to power up the system using an RTC alarm.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/rtc/rtc-omap.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index b0319864dd42..8836c58901b5 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -670,7 +670,15 @@ static SIMPLE_DEV_PM_OPS(omap_rtc_pm_ops, omap_rtc_suspend, omap_rtc_resume);
 
 static void omap_rtc_shutdown(struct platform_device *pdev)
 {
-	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
+	u8 mask;
+
+	/*
+	 * Keep the ALARM interrupt enabled to allow the system to power up on
+	 * alarm events.
+	 */
+	mask = rtc_read(OMAP_RTC_INTERRUPTS_REG);
+	mask &= OMAP_RTC_INTERRUPTS_IT_ALARM;
+	rtc_write(mask, OMAP_RTC_INTERRUPTS_REG);
 }
 
 MODULE_ALIAS("platform:omap_rtc");
-- 
2.0.4

