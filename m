Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaCKDTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 23:19:13 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:42319 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaCKDTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 23:19:11 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org, lidza.louina@gmail.com
Cc: driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgnc: replace unnecessary while() with if()
Date: Tue, 11 Mar 2014 12:19:06 +0900
Message-ID: <2660456.pjdndOVhKF@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It doesn't need to use while loop for getting newrate,
because it always breaks out the end of while loop with
"break". So just replace while with if.

And the type of newrate is "unsigned int", this type
is never less than zero. If it can be set to negative value by
user application with ioctl(), it is not zero but it
can be a unexpected value for setting custom baudrate.

Also smatch says:
drivers/staging/dgnc/dgnc_tty.c:967 dgnc_set_custom_speed() warn:
 unsigned 'newrate' is never less than zero.
drivers/staging/dgnc/dgnc_tty.c:981 dgnc_set_custom_speed() info:
 ignoring unreachable code.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgnc/dgnc_tty.c |   41 ++++++++++++++++++--------------------
 1 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index a6c6aba..199b9d7 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -964,8 +964,10 @@ static void dgnc_set_custom_speed(struct channel_t *ch, uint newrate)
 	int deltahigh;
 	int deltalow;
 
-	if (newrate < 0)
-		newrate = 0;
+	if (newrate <= 0) {
+		ch->ch_custom_speed = 0;
+		return;
+	}
 
 	/*
 	 *  Since the divisor is stored in a 16-bit integer, we make sure
@@ -978,7 +980,7 @@ static void dgnc_set_custom_speed(struct channel_t *ch, uint newrate)
 	if (newrate && newrate > ch->ch_bd->bd_dividend)
 		newrate = ch->ch_bd->bd_dividend;
 
-	while (newrate > 0) {
+	if (newrate > 0) {
 		testdiv = ch->ch_bd->bd_dividend / newrate;
 
 		/*
@@ -995,28 +997,23 @@ static void dgnc_set_custom_speed(struct channel_t *ch, uint newrate)
 		 *  If the rate for the requested divisor is correct, just
 		 *  use it and be done.
 		 */
-		if (testrate_high == newrate )
-			break;
-
-		/*
-		 *  Otherwise, pick the rate that is closer (i.e. whichever rate
-		 *  has a smaller delta).
-		 */
-		deltahigh = testrate_high - newrate;
-		deltalow = newrate - testrate_low;
+		if (testrate_high != newrate) {
+			/*
+			 *  Otherwise, pick the rate that is closer (i.e. whichever rate
+			 *  has a smaller delta).
+			 */
+			deltahigh = testrate_high - newrate;
+			deltalow = newrate - testrate_low;
 
-		if (deltahigh < deltalow) {
-			newrate = testrate_high;
-		} else {
-			newrate = testrate_low;
+			if (deltahigh < deltalow) {
+				newrate = testrate_high;
+			} else {
+				newrate = testrate_low;
+			}
 		}
-
-		break;
 	}
 
 	ch->ch_custom_speed = newrate;
-
-	return;
 }
 
 
@@ -3316,10 +3313,10 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 
 	case DIGI_SETCUSTOMBAUD:
 	{
-		uint new_rate;
+		int new_rate;
 		/* Let go of locks when accessing user space, could sleep */
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
-		rc = get_user(new_rate, (unsigned int __user *) arg);
+		rc = get_user(new_rate, (int __user *) arg);
 		if (rc)
 			return rc;
 		DGNC_LOCK(ch->ch_lock, lock_flags);
-- 
1.7.4.4


