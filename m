Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596Ab3GaO31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:29:27 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:56026 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3GaO3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:29:25 -0400
X-Greylist: delayed 887 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jul 2013 10:29:25 EDT
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, Wolfram Sang <wsa@the-dreams.de>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH] rtc: rtc-stmp3xxx: provide timeout for potentially endless loop polling a HW bit
Date: Wed, 31 Jul 2013 16:29:01 +0200
Message-Id: <1375280941-22657-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's always a bad idea to poll on HW bits without a timeout.

The i.MX28 RTC can be easily brought into a state in which the RTC is
not running (until after a power-on-reset) and thus the status bits
which are polled in the driver won't ever change.

This patch prevents the kernel from getting stuck in this case.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/rtc/rtc-stmp3xxx.c |   35 +++++++++++++++++++++++++----------
 1 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-stmp3xxx.c b/drivers/rtc/rtc-stmp3xxx.c
index 767fee2..2601953 100644
--- a/drivers/rtc/rtc-stmp3xxx.c
+++ b/drivers/rtc/rtc-stmp3xxx.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
+#include <linux/delay.h>
 #include <linux/rtc.h>
 #include <linux/slab.h>
 #include <linux/of_device.h>
@@ -119,24 +120,39 @@ static void stmp3xxx_wdt_register(struct platform_device *rtc_pdev)
 }
 #endif /* CONFIG_STMP3XXX_RTC_WATCHDOG */
 
-static void stmp3xxx_wait_time(struct stmp3xxx_rtc_data *rtc_data)
+static int stmp3xxx_wait_time(struct stmp3xxx_rtc_data *rtc_data)
 {
+	int timeout = 5000; /* 3ms according to i.MX28 Ref Manual */
 	/*
-	 * The datasheet doesn't say which way round the
-	 * NEW_REGS/STALE_REGS bitfields go. In fact it's 0x1=P0,
-	 * 0x2=P1, .., 0x20=P5, 0x40=ALARM, 0x80=SECONDS
+	 * The i.MX28 Applications Processor Reference Manual, Rev. 1, 2010
+	 * states:
+	 * | The order in which registers are updated is
+	 * | Persistent 0, 1, 2, 3, 4, 5, Alarm, Seconds.
+	 * | (This list is in bitfield order, from LSB to MSB, as they would
+	 * | appear in the STALE_REGS and NEW_REGS bitfields of the HW_RTC_STAT
+	 * | register. For example, the Seconds register corresponds to
+	 * | STALE_REGS or NEW_REGS containing 0x80.)
 	 */
-	while (readl(rtc_data->io + STMP3XXX_RTC_STAT) &
-			(0x80 << STMP3XXX_RTC_STAT_STALE_SHIFT))
-		cpu_relax();
+	do {
+		if (!(readl(rtc_data->io + STMP3XXX_RTC_STAT) &
+				(0x80 << STMP3XXX_RTC_STAT_STALE_SHIFT)))
+			return 0;
+		udelay(1);
+	} while (--timeout > 0);
+	return (readl(rtc_data->io + STMP3XXX_RTC_STAT) &
+		(0x80 << STMP3XXX_RTC_STAT_STALE_SHIFT)) ? -ETIME : 0;
 }
 
 /* Time read/write */
 static int stmp3xxx_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 {
+	int ret;
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
-	stmp3xxx_wait_time(rtc_data);
+	ret = stmp3xxx_wait_time(rtc_data);
+	if (ret)
+		return ret;
+
 	rtc_time_to_tm(readl(rtc_data->io + STMP3XXX_RTC_SECONDS), rtc_tm);
 	return 0;
 }
@@ -146,8 +162,7 @@ static int stmp3xxx_rtc_set_mmss(struct device *dev, unsigned long t)
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
 	writel(t, rtc_data->io + STMP3XXX_RTC_SECONDS);
-	stmp3xxx_wait_time(rtc_data);
-	return 0;
+	return stmp3xxx_wait_time(rtc_data);
 }
 
 /* interrupt(s) handler */
-- 
1.7.2.5

