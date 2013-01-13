Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab3AMRtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:49:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35077 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755533Ab3AMRpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:41 -0500
Message-Id: <20130113174302.044390376@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:25 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tony Prisk <linux@prisktech.co.nz>, Edgar Toernig <froese@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 30/49] drivers/rtc/rtc-vt8500.c: fix handling of data passed in struct
 rtc_time
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Prisk <linux@prisktech.co.nz>

commit 2f90b68309683f2c5765a1b04ca23d71e51f1494 upstream.

tm_mon is 0..11, whereas vt8500 expects 1..12 for the month field,
causing invalid date errors for January, and causing the day field to
roll over incorrectly.

The century flag is only handled in vt8500_rtc_read_time, but not set in
vt8500_rtc_set_time.  This patch corrects the behaviour of the century
flag.

Signed-off-by: Edgar Toernig <froese@gmx.de>
Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/rtc/rtc-vt8500.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-vt8500.c b/drivers/rtc/rtc-vt8500.c
index 737addf..00c930f 100644
--- a/drivers/rtc/rtc-vt8500.c
+++ b/drivers/rtc/rtc-vt8500.c
@@ -119,7 +119,7 @@ static int vt8500_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	tm->tm_min = bcd2bin((time & TIME_MIN_MASK) >> TIME_MIN_S);
 	tm->tm_hour = bcd2bin((time & TIME_HOUR_MASK) >> TIME_HOUR_S);
 	tm->tm_mday = bcd2bin(date & DATE_DAY_MASK);
-	tm->tm_mon = bcd2bin((date & DATE_MONTH_MASK) >> DATE_MONTH_S);
+	tm->tm_mon = bcd2bin((date & DATE_MONTH_MASK) >> DATE_MONTH_S) - 1;
 	tm->tm_year = bcd2bin((date & DATE_YEAR_MASK) >> DATE_YEAR_S)
 			+ ((date >> DATE_CENTURY_S) & 1 ? 200 : 100);
 	tm->tm_wday = (time & TIME_DOW_MASK) >> TIME_DOW_S;
@@ -138,8 +138,9 @@ static int vt8500_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	}
 
 	writel((bin2bcd(tm->tm_year - 100) << DATE_YEAR_S)
-		| (bin2bcd(tm->tm_mon) << DATE_MONTH_S)
-		| (bin2bcd(tm->tm_mday)),
+		| (bin2bcd(tm->tm_mon + 1) << DATE_MONTH_S)
+		| (bin2bcd(tm->tm_mday))
+		| ((tm->tm_year >= 200) << DATE_CENTURY_S),
 		vt8500_rtc->regbase + VT8500_RTC_DS);
 	writel((bin2bcd(tm->tm_wday) << TIME_DOW_S)
 		| (bin2bcd(tm->tm_hour) << TIME_HOUR_S)


