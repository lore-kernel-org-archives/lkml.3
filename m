Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaABMMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:12:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60707 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaABMIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH, RFC 14/30] tty/amiserial: avoid interruptible_sleep_on
Date: Thu,  2 Jan 2014 13:07:38 +0100
Message-Id: <1388664474-1710039-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Bd6yTasx5uqwq+Be5jlGibDa+V2U7VXdoMKu35pMGYH
 Bt9MX0tn/N+gjV/4MtWx2nhX6frt0s82skzFJt/YXGEHALbHkC
 EeWpddyF0gKlw19ZQp4IMPeq8Z6TImiU1qkIrw0PCexXZKAdES
 aMozZcBj5lhEfT8W+UkO2ovww70eIud7GM5cJ+T8AomnvIUpIH
 fjhBOrVzarHm4kE3TJLvhA5vVL76dBKlVb3YKpNIMIdQ/AtPJK
 J/nM/4MmZ7eygk0AVeRTdH/11M6kxR4cAPMsuZ2TsBkWLHinKP
 rnT8wvB1d+TccEgcAIhnK6JbhPDJlLc2NHNFtgzc1F6vFQYwz5
 ghO6EgMnQlPDPmSSBfCj/bUUIJv4KDhGCtfUXZcuZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interruptible_sleep_on is generally problematic and we want to get
rid of it. In case of TIOCMIWAIT, that race is actually in user
space and does not get fixed since we can only detect changes after
entering the ioctl handler, but it removes one more caller.

This instance can not be trivially replaced with wait_event, so
I chose to open-code the wait loop using prepare_to_wait/finish_wait.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/amiserial.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 71630a2..979e7c3 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1248,6 +1248,8 @@ static int rs_ioctl(struct tty_struct *tty,
 	struct async_icount cprev, cnow;	/* kernel counter temps */
 	void __user *argp = (void __user *)arg;
 	unsigned long flags;
+	DEFINE_WAIT(wait);
+	int ret;
 
 	if (serial_paranoia_check(info, tty->name, "rs_ioctl"))
 		return -ENODEV;
@@ -1288,25 +1290,33 @@ static int rs_ioctl(struct tty_struct *tty,
 			cprev = info->icount;
 			local_irq_restore(flags);
 			while (1) {
-				interruptible_sleep_on(&info->tport.delta_msr_wait);
-				/* see if a signal did it */
-				if (signal_pending(current))
-					return -ERESTARTSYS;
+				prepare_to_wait(&info->tport.delta_msr_wait,
+						&wait, TASK_INTERRUPTIBLE);
 				local_irq_save(flags);
 				cnow = info->icount; /* atomic copy */
 				local_irq_restore(flags);
 				if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr && 
-				    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
-					return -EIO; /* no change => error */
+				    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts) {
+					ret = -EIO; /* no change => error */
+					break;
+				}
 				if ( ((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
 				     ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
 				     ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
 				     ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts)) ) {
-					return 0;
+					ret = 0;
+					break;
+				}
+				schedule();
+				/* see if a signal did it */
+				if (signal_pending(current)) {
+					ret = -ERESTARTSYS;
+					break;
 				}
 				cprev = cnow;
 			}
-			/* NOTREACHED */
+			finish_wait(&info->tport.delta_msr_wait, &wait);
+			return ret;
 
 		case TIOCSERGWILD:
 		case TIOCSERSWILD:
-- 
1.8.3.2

