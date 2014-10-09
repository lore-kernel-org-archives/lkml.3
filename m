Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaJITPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:15:23 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:64985 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaJITMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:12:32 -0400
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
Subject: [PATCH 08/12] rtc: omap: restore irq state after reading TC registers
Date: Thu,  9 Oct 2014 21:06:30 +0200
Message-Id: <1412881594-25678-9-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1412881594-25678-1-git-send-email-johan@kernel.org>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure to restore local irq state when reading the timer/calendar
(TC) registers, so that omap_rtc_read_time() can be called with
interrupts disabled.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/rtc/rtc-omap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 0ef016553a97..62e2e9a9887a 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -239,8 +239,10 @@ static void bcd2tm(struct rtc_time *tm)
 
 static int omap_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
+	unsigned long flags;
+
 	/* we don't report wday/yday/isdst ... */
-	local_irq_disable();
+	local_irq_save(flags);
 	rtc_wait_not_busy();
 
 	tm->tm_sec = rtc_read(OMAP_RTC_SECONDS_REG);
@@ -250,7 +252,7 @@ static int omap_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	tm->tm_mon = rtc_read(OMAP_RTC_MONTHS_REG);
 	tm->tm_year = rtc_read(OMAP_RTC_YEARS_REG);
 
-	local_irq_enable();
+	local_irq_restore(flags);
 
 	bcd2tm(tm);
 	return 0;
-- 
2.0.4

