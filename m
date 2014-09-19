Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbaISK1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 06:27:18 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41542 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660AbaISK0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 06:26:46 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Doug Anderson <dianders@chromium.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        rtc-linux@googlegroups.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v10 5/6] rtc: max77686: Use ffs() to calculate tm_wday
Date: Fri, 19 Sep 2014 12:26:16 +0200
Message-Id: <1411122377-10426-6-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411122377-10426-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1411122377-10426-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function max77686_rtc_calculate_wday() is used to
calculate the day of the week to be filled in struct
rtc_time but that function only calculates the number
of bits shifted. So the ffs() function can be used to
find the first bit set instead of a special function.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/rtc/rtc-max77686.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index b177ba1..2659bd3 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -70,16 +70,6 @@ enum MAX77686_RTC_OP {
 	MAX77686_RTC_READ,
 };
 
-static inline int max77686_rtc_calculate_wday(u8 shifted)
-{
-	int counter = -1;
-	while (shifted) {
-		shifted >>= 1;
-		counter++;
-	}
-	return counter;
-}
-
 static void max77686_rtc_data_to_tm(u8 *data, struct rtc_time *tm,
 				   int rtc_24hr_mode)
 {
@@ -93,7 +83,7 @@ static void max77686_rtc_data_to_tm(u8 *data, struct rtc_time *tm,
 			tm->tm_hour += 12;
 	}
 
-	tm->tm_wday = max77686_rtc_calculate_wday(data[RTC_WEEKDAY] & 0x7f);
+	tm->tm_wday = ffs(data[RTC_WEEKDAY] & 0x7f) - 1;
 	tm->tm_mday = data[RTC_DATE] & 0x1f;
 	tm->tm_mon = (data[RTC_MONTH] & 0x0f) - 1;
 	tm->tm_year = (data[RTC_YEAR] & 0x7f) + 100;
-- 
2.1.0

