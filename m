Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594AbaGVW1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:27:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44893 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbaGVW1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:27:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 065/116] rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq
Date: Tue, 22 Jul 2014 15:21:16 -0700
Message-Id: <1406067727-19683-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

commit 2fe121e1f5aa3bf31b418a9790db6c400e922291 upstream.

The rtc user must wait at least 1 sec between each time/calandar update
(see atmel's datasheet chapter "Updating Time/Calendar").

Use the 1Hz interrupt to update the at91_rtc_upd_rdy flag and wait for
the at91_rtc_wait_upd_rdy event if the rtc is not ready.

This patch fixes a deadlock in an uninterruptible wait when the RTC is
updated more than once every second.  AFAICT the bug is here from the
beginning, but I think we should at least backport this fix to 3.10 and
the following longterm and stable releases.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Reported-by: Bryan Evenson <bevenson@melinkcorp.com>
Tested-by: Bryan Evenson <bevenson@melinkcorp.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/rtc/rtc-at91rm9200.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 357da6b..243d8c7 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -41,6 +41,7 @@
 #define AT91_RTC_EPOCH		1900UL	/* just like arch/arm/common/rtctime.c */
 
 static DECLARE_COMPLETION(at91_rtc_updated);
+static DECLARE_COMPLETION(at91_rtc_upd_rdy);
 static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
 static int irq;
@@ -104,6 +105,8 @@ static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
+	wait_for_completion(&at91_rtc_upd_rdy);
+
 	/* Stop Time/Calendar from counting */
 	cr = at91_rtc_read(AT91_RTC_CR);
 	at91_rtc_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL | AT91_RTC_UPDTIM);
@@ -126,7 +129,9 @@ static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
 
 	/* Restart Time/Calendar */
 	cr = at91_rtc_read(AT91_RTC_CR);
+	at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_SECEV);
 	at91_rtc_write(AT91_RTC_CR, cr & ~(AT91_RTC_UPDCAL | AT91_RTC_UPDTIM));
+	at91_rtc_write_ier(AT91_RTC_SECEV);
 
 	return 0;
 }
@@ -233,8 +238,10 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
 	if (rtsr) {		/* this interrupt is shared!  Is it ours? */
 		if (rtsr & AT91_RTC_ALARM)
 			events |= (RTC_AF | RTC_IRQF);
-		if (rtsr & AT91_RTC_SECEV)
-			events |= (RTC_UF | RTC_IRQF);
+		if (rtsr & AT91_RTC_SECEV) {
+			complete(&at91_rtc_upd_rdy);
+			at91_rtc_write_idr(AT91_RTC_SECEV);
+		}
 		if (rtsr & AT91_RTC_ACKUPD)
 			complete(&at91_rtc_updated);
 
@@ -317,6 +324,11 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 	}
 	platform_set_drvdata(pdev, rtc);
 
+	/* enable SECEV interrupt in order to initialize at91_rtc_upd_rdy
+	 * completion.
+	 */
+	at91_rtc_write_ier(AT91_RTC_SECEV);
+
 	printk(KERN_INFO "AT91 Real Time Clock driver.\n");
 	return 0;
 
-- 
1.9.1

