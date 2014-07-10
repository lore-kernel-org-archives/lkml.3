Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbaGJD1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 23:27:23 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:63859 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaGJD1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 23:27:22 -0400
Date: Thu, 10 Jul 2014 12:26:04 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2] staging: dgap: removes redundant null check and change
 paramter for dgap_maxcps_room()
Message-ID: <20140710032603.GA5576@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Null checks for tty, un and ch are already done by caller,
so replace parameter "tty" with "ch" and "un".

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
V2: revert return type from int to void.
leave it originally.

 drivers/staging/dgap/dgap.c |   21 ++++-----------------
 1 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index cc21dd2..9affc5b 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -2507,22 +2507,9 @@ static int dgap_wait_for_drain(struct tty_struct *tty)
  * returns the new bytes_available.  This only affects printer
  * output.
  */
-static int dgap_maxcps_room(struct tty_struct *tty, int bytes_available)
+static int dgap_maxcps_room(struct channel_t *ch, struct un_t *un,
+			    int bytes_available)
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
@@ -2624,7 +2611,7 @@ static int dgap_tty_write_room(struct tty_struct *tty)
 		ret += ch->ch_tsize;
 
 	/* Limit printer to maxcps */
-	ret = dgap_maxcps_room(tty, ret);
+	ret = dgap_maxcps_room(ch, un, ret);
 
 	/*
 	 * If we are printer device, leave space for
@@ -2729,7 +2716,7 @@ static int dgap_tty_write(struct tty_struct *tty, const unsigned char *buf,
 	 * Limit printer output to maxcps overall, with bursts allowed
 	 * up to bufsize characters.
 	 */
-	bufcount = dgap_maxcps_room(tty, bufcount);
+	bufcount = dgap_maxcps_room(ch, un, bufcount);
 
 	/*
 	 * Take minimum of what the user wants to send, and the
-- 
1.7.1

