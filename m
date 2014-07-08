Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbaGHTir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:38:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54778 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932567AbaGHTeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:34:10 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nicolas Ferre" <nicolas.ferre@atmel.com>,
        "Boris BREZILLON" <boris.brezillon@free-electrons.com>,
        "Andrew Victor" <linux@maxim.org.za>,
        "Bryan Evenson" <bevenson@melinkcorp.com>,
        "Alessandro Zummo" <a.zummo@towertech.it>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.619006759@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 064/125] rtc: rtc-at91rm9200: fix infinite wait for
 ACKUPD irq
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - at91_rtc_write() is called at91_sys_write()
 - Use at91_sys_write() directly instead of the missing
   at91_rtc_write_ier() and at91_rtc_write_idr()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/rtc/rtc-at91rm9200.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -36,6 +36,7 @@
 #define AT91_RTC_EPOCH		1900UL	/* just like arch/arm/common/rtctime.c */
 
 static DECLARE_COMPLETION(at91_rtc_updated);
+static DECLARE_COMPLETION(at91_rtc_upd_rdy);
 static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 
 /*
@@ -97,6 +98,8 @@ static int at91_rtc_settime(struct devic
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
+	wait_for_completion(&at91_rtc_upd_rdy);
+
 	/* Stop Time/Calendar from counting */
 	cr = at91_sys_read(AT91_RTC_CR);
 	at91_sys_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL | AT91_RTC_UPDTIM);
@@ -119,7 +122,9 @@ static int at91_rtc_settime(struct devic
 
 	/* Restart Time/Calendar */
 	cr = at91_sys_read(AT91_RTC_CR);
+	at91_sys_write(AT91_RTC_SCCR, AT91_RTC_SECEV);
 	at91_sys_write(AT91_RTC_CR, cr & ~(AT91_RTC_UPDCAL | AT91_RTC_UPDTIM));
+	at91_sys_write(AT91_RTC_IER, AT91_RTC_SECEV);
 
 	return 0;
 }
@@ -226,8 +231,10 @@ static irqreturn_t at91_rtc_interrupt(in
 	if (rtsr) {		/* this interrupt is shared!  Is it ours? */
 		if (rtsr & AT91_RTC_ALARM)
 			events |= (RTC_AF | RTC_IRQF);
-		if (rtsr & AT91_RTC_SECEV)
-			events |= (RTC_UF | RTC_IRQF);
+		if (rtsr & AT91_RTC_SECEV) {
+			complete(&at91_rtc_upd_rdy);
+			at91_sys_write(AT91_RTC_IDR, AT91_RTC_SECEV);
+		}
 		if (rtsr & AT91_RTC_ACKUPD)
 			complete(&at91_rtc_updated);
 
@@ -291,6 +298,11 @@ static int __init at91_rtc_probe(struct
 	}
 	platform_set_drvdata(pdev, rtc);
 
+	/* enable SECEV interrupt in order to initialize at91_rtc_upd_rdy
+	 * completion.
+	 */
+	at91_sys_write(AT91_RTC_IER, AT91_RTC_SECEV);
+
 	printk(KERN_INFO "AT91 Real Time Clock driver.\n");
 	return 0;
 }

