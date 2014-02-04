Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934881AbaBDV1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:27:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934677AbaBDVMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 075/140] rtc: max8907: weekday encoding fixes
Date: Tue,  4 Feb 2014 13:11:02 -0800
Message-Id: <20140204211039.102948635@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 75ea799df4cb07e505c91b4abaa87bc28aad3e66 upstream.

The current MAX8907 driver has two issues related to weekday value
handling:

1)

The HW WEEKDAY register has range 0..6 rather than 1..7 as documented.
Note that I validated the actual HW range by observing the HW register
roll from 6->0 rather than 6->7->1 as would otherwise be expected.

This matches Linux's tm_wday range of 0..6.

When the CMOS RAM content is lost, the date returned from the device is
2007-01-01 00:00:00, which is a Monday.  The WEEKDAY register reads 1 in
this case.  This matches the numbering in Linux's tm_wday field.

Hence we should write Linux's tm_wday value to the register without
modifying it.  Hence, remove the +1/-1 calculations for WEEKDAY/tm_wday.

2)

There's no need to make alarms match on the WEEKDAY register, since the
other fields together uniquely define the alarm date/time.  Ignoring the
WEEKDAY value in the match isolates the driver from any incorrect value in
the current time copy of the WEEKDAY register.

Each change individually, or both together, solves an issue that I
observed; "hwclock -r" would time out waiting for its alarm to fire if the
CMOS RAM content had been lost, and hence the WEEKDAY register value
mismatched what the driver expected it to be.  "hwclock -w" would solve
this by over-writing the HW default WEEKDAY register value with what the
driver expected.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-max8907.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/rtc/rtc-max8907.c
+++ b/drivers/rtc/rtc-max8907.c
@@ -51,7 +51,7 @@ static irqreturn_t max8907_irq_handler(i
 {
 	struct max8907_rtc *rtc = data;
 
-	regmap_update_bits(rtc->regmap, MAX8907_REG_ALARM0_CNTL, 0x7f, 0);
+	regmap_write(rtc->regmap, MAX8907_REG_ALARM0_CNTL, 0);
 
 	rtc_update_irq(rtc->rtc_dev, 1, RTC_IRQF | RTC_AF);
 
@@ -64,7 +64,7 @@ static void regs_to_tm(u8 *regs, struct
 		bcd2bin(regs[RTC_YEAR1]) - 1900;
 	tm->tm_mon = bcd2bin(regs[RTC_MONTH] & 0x1f) - 1;
 	tm->tm_mday = bcd2bin(regs[RTC_DATE] & 0x3f);
-	tm->tm_wday = (regs[RTC_WEEKDAY] & 0x07) - 1;
+	tm->tm_wday = (regs[RTC_WEEKDAY] & 0x07);
 	if (regs[RTC_HOUR] & HOUR_12) {
 		tm->tm_hour = bcd2bin(regs[RTC_HOUR] & 0x01f);
 		if (tm->tm_hour == 12)
@@ -88,7 +88,7 @@ static void tm_to_regs(struct rtc_time *
 	regs[RTC_YEAR1] = bin2bcd(low);
 	regs[RTC_MONTH] = bin2bcd(tm->tm_mon + 1);
 	regs[RTC_DATE] = bin2bcd(tm->tm_mday);
-	regs[RTC_WEEKDAY] = tm->tm_wday + 1;
+	regs[RTC_WEEKDAY] = tm->tm_wday;
 	regs[RTC_HOUR] = bin2bcd(tm->tm_hour);
 	regs[RTC_MIN] = bin2bcd(tm->tm_min);
 	regs[RTC_SEC] = bin2bcd(tm->tm_sec);
@@ -153,7 +153,7 @@ static int max8907_rtc_set_alarm(struct
 	tm_to_regs(&alrm->time, regs);
 
 	/* Disable alarm while we update the target time */
-	ret = regmap_update_bits(rtc->regmap, MAX8907_REG_ALARM0_CNTL, 0x7f, 0);
+	ret = regmap_write(rtc->regmap, MAX8907_REG_ALARM0_CNTL, 0);
 	if (ret < 0)
 		return ret;
 
@@ -163,8 +163,7 @@ static int max8907_rtc_set_alarm(struct
 		return ret;
 
 	if (alrm->enabled)
-		ret = regmap_update_bits(rtc->regmap, MAX8907_REG_ALARM0_CNTL,
-					 0x7f, 0x7f);
+		ret = regmap_write(rtc->regmap, MAX8907_REG_ALARM0_CNTL, 0x77);
 
 	return ret;
 }


