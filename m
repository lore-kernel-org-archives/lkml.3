Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaGGB3J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 21:29:09 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:57240 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaGGB3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 21:29:06 -0400
Date: Mon, 7 Jul 2014 10:27:54 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgap: removes redundant null check and change
 paramter for dgap_maxcps_room()
Message-ID: <20140707012754.GA26042@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Null checks for tty, un and ch are already done by caller,
so replace parameter "tty" with "ch" and "un".

And also use a pointer for returning new bytes_available instead of
return variable.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   29 +++++++----------------------
 1 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index e8d3c99..da11dfb 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -2507,31 +2507,18 @@ static int dgap_wait_for_drain(struct tty_struct *tty)
  *
  * Reduces bytes_available to the max number of characters
  * that can be sent currently given the maxcps value, and
- * returns the new bytes_available.  This only affects printer
+ * rewrites the new bytes_available.  This only affects printer
  * output.
  */
-static int dgap_maxcps_room(struct tty_struct *tty, int bytes_available)
+static void dgap_maxcps_room(struct channel_t *ch, struct un_t *un,
+			     int *bytes_available)
 {
-	struct channel_t *ch;
-	struct un_t *un;
-
-	if (!tty)
-		return bytes_available;
-
-	un = tty->driver_data;
-	if (!un || un->magic != DGAP_UNIT_MAGIC)
-		return bytes_available;
-
-	ch = un->un_ch;
-	if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
-		return bytes_available;
-
 	/*
 	 * If its not the Transparent print device, return
 	 * the full data amount.
 	 */
 	if (un->un_type != DGAP_PRINT)
-		return bytes_available;
+		return;
 
 	if (ch->ch_digi.digi_maxcps > 0 && ch->ch_digi.digi_bufsize > 0) {
 		int cps_limit = 0;
@@ -2553,10 +2540,8 @@ static int dgap_maxcps_room(struct tty_struct *tty, int bytes_available)
 			cps_limit = 0;
 		}
 
-		bytes_available = min(cps_limit, bytes_available);
+		*bytes_available = min(cps_limit, *bytes_available);
 	}
-
-	return bytes_available;
 }
 
 static inline void dgap_set_firmware_event(struct un_t *un, unsigned int event)
@@ -2627,7 +2612,7 @@ static int dgap_tty_write_room(struct tty_struct *tty)
 		ret += ch->ch_tsize;
 
 	/* Limit printer to maxcps */
-	ret = dgap_maxcps_room(tty, ret);
+	dgap_maxcps_room(ch, un, &ret);
 
 	/*
 	 * If we are printer device, leave space for
@@ -2732,7 +2717,7 @@ static int dgap_tty_write(struct tty_struct *tty, const unsigned char *buf,
 	 * Limit printer output to maxcps overall, with bursts allowed
 	 * up to bufsize characters.
 	 */
-	bufcount = dgap_maxcps_room(tty, bufcount);
+	dgap_maxcps_room(ch, un, &bufcount);
 
 	/*
 	 * Take minimum of what the user wants to send, and the
-- 
1.7.1

