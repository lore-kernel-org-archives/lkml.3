Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559AbaJURvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:51:05 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:54710 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933382AbaJURo4 (ORCPT
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
Subject: [PATCH v2 13/20] rtc: omap: add helper to read raw bcd time
Date: Tue, 21 Oct 2014 19:37:59 +0200
Message-Id: <1413913086-12730-14-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1413913086-12730-1-git-send-email-johan@kernel.org>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1413913086-12730-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helper to read raw BCD time that can be used in interrupt context.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/rtc/rtc-omap.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index ee20f2d36065..bcdf3c596214 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -234,22 +234,24 @@ static void bcd2tm(struct rtc_time *tm)
 	tm->tm_year = bcd2bin(tm->tm_year) + 100;
 }
 
-
-static int omap_rtc_read_time(struct device *dev, struct rtc_time *tm)
+static void omap_rtc_read_time_raw(struct omap_rtc *rtc, struct rtc_time *tm)
 {
-	struct omap_rtc *rtc = dev_get_drvdata(dev);
-
-	/* we don't report wday/yday/isdst ... */
-	local_irq_disable();
-	rtc_wait_not_busy(rtc);
-
 	tm->tm_sec = rtc_read(rtc, OMAP_RTC_SECONDS_REG);
 	tm->tm_min = rtc_read(rtc, OMAP_RTC_MINUTES_REG);
 	tm->tm_hour = rtc_read(rtc, OMAP_RTC_HOURS_REG);
 	tm->tm_mday = rtc_read(rtc, OMAP_RTC_DAYS_REG);
 	tm->tm_mon = rtc_read(rtc, OMAP_RTC_MONTHS_REG);
 	tm->tm_year = rtc_read(rtc, OMAP_RTC_YEARS_REG);
+}
+
+static int omap_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct omap_rtc *rtc = dev_get_drvdata(dev);
 
+	/* we don't report wday/yday/isdst ... */
+	local_irq_disable();
+	rtc_wait_not_busy(rtc);
+	omap_rtc_read_time_raw(rtc, tm);
 	local_irq_enable();
 
 	bcd2tm(tm);
-- 
2.0.4

