Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935364Ab3E3QFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:05:17 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:43606 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934049Ab3E3QEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:04:53 -0400
Message-ID: <1369929888.16480.5.camel@host5.omatika.ru>
Subject: [PATCH] rtc-ds1302: handle write protection
From: Sergey Yanovich <ynvich@gmail.com>
To: Marc Zyngier <maz@misterjones.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
Date: Thu, 30 May 2013 20:04:48 +0400
In-Reply-To: <53f44a9ec4c8391288d6c132fd5689da@localhost>
References: <1369092090-5384-1-git-send-email-ynvich@gmail.com>
	 <20130529155311.9e35e847968f3923bc83f4cd@linux-foundation.org>
	 <1369908882.17429.13.camel@host5.omatika.ru>
	 <53f44a9ec4c8391288d6c132fd5689da@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f1cd048a066b249082752a96abce7d33a0cd4ea3 Mon Sep 17 00:00:00 2001
From: Sergey Yanovich <ynvich@gmail.com>
Date: Tue, 21 May 2013 03:06:31 +0400
Subject: [PATCH] rtc-ds1302: handle write protection

This chip has a control register and can prevent altering saved clock.
Without this patch we could have:
----8<----
(arm)root@pac14:~# date
Tue May 21 03:08:27 MSK 2013
(arm)root@pac14:~# /etc/init.d/hwclock.sh show
Tue May 21 11:13:58 2013  -0.067322 seconds
(arm)root@pac14:~# /etc/init.d/hwclock.sh stop
[info] Saving the system clock.
[info] Hardware Clock updated to Tue May 21 03:09:01 MSK 2013.
(arm)root@pac14:~# /etc/init.d/hwclock.sh show
Tue May 21 11:14:15 2013  -0.624272 seconds
----8<----

The patch enables write access to rtc before the driver tries to write time
and re-disables when time data is written.

Signed-off-by: Sergey Yanovich <ynvich@gmail.com>

 # Changes to be committed:
---
changes for v2:
 - do enable/disable around set_time() instead of in probe()/remove()

 drivers/rtc/rtc-ds1302.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/rtc/rtc-ds1302.c b/drivers/rtc/rtc-ds1302.c
index 7533b72..07e8d79 100644
--- a/drivers/rtc/rtc-ds1302.c
+++ b/drivers/rtc/rtc-ds1302.c
@@ -23,8 +23,12 @@
 #define	RTC_CMD_READ	0x81		/* Read command */
 #define	RTC_CMD_WRITE	0x80		/* Write command */
 
+#define	RTC_CMD_WRITE_ENABLE	0x00		/* Write enable */
+#define	RTC_CMD_WRITE_DISABLE	0x80		/* Write disable */
+
 #define RTC_ADDR_RAM0	0x20		/* Address of RAM0 */
 #define RTC_ADDR_TCR	0x08		/* Address of trickle charge register */
+#define	RTC_ADDR_CTRL	0x07		/* Address of control register */
 #define	RTC_ADDR_YEAR	0x06		/* Address of year register */
 #define	RTC_ADDR_DAY	0x05		/* Address of day of week register */
 #define	RTC_ADDR_MON	0x04		/* Address of month register */
@@ -161,6 +165,7 @@ static int ds1302_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 static int ds1302_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
+	ds1302_writebyte(RTC_ADDR_CTRL, RTC_CMD_WRITE_ENABLE);
 	/* Stop RTC */
 	ds1302_writebyte(RTC_ADDR_SEC, ds1302_readbyte(RTC_ADDR_SEC) | 0x80);
 
@@ -175,6 +180,8 @@ static int ds1302_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	/* Start RTC */
 	ds1302_writebyte(RTC_ADDR_SEC, ds1302_readbyte(RTC_ADDR_SEC) & ~0x80);
 
+	ds1302_writebyte(RTC_ADDR_CTRL, RTC_CMD_WRITE_DISABLE);
+
 	return 0;
 }
 
-- 
1.7.10.4

