Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaKFKaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:30:14 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:44668 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaKFKaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:30:11 -0500
Date: Thu, 6 Nov 2014 19:27:59 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging: dgap: introducing find_board_by_major()
Message-ID: <20141106102759.GA21472@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use find_board_by_major function instead of getting a brd from static
arrary. Becasue tty's major number doesn't start zero and we can
find a brd from dgap_board[].

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 3f23e5b..f38354f 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -80,7 +80,6 @@ static int dgap_poll_tick = 20;	/* Poll interval - 20 ms */
 
 static struct class *dgap_class;
 
-static struct board_t *dgap_boards_by_major[256];
 static uint dgap_count = 500;
 
 /*
@@ -4409,6 +4408,22 @@ static void dgap_tty_unthrottle(struct tty_struct *tty)
 	spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
 }
 
+static struct board_t *find_board_by_major(unsigned int major)
+{
+	unsigned int i;
+
+	for (i = 0; i < MAXBOARDS; i++) {
+		struct board_t *brd = dgap_board[i];
+		if (!brd)
+			return NULL;
+		if (major == brd->serial_driver->major ||
+		    major == brd->print_driver->major)
+			return brd;
+	}
+
+	return NULL;
+}
+
 /************************************************************************
  *
  * TTY Entry points and helper functions
@@ -4435,11 +4450,7 @@ static int dgap_tty_open(struct tty_struct *tty, struct file *file)
 	major = MAJOR(tty_devnum(tty));
 	minor = MINOR(tty_devnum(tty));
 
-	if (major > 255)
-		return -EIO;
-
-	/* Get board pointer from our array of majors we have allocated */
-	brd = dgap_boards_by_major[major];
+	brd = find_board_by_major(major);
 	if (!brd)
 		return -EIO;
 
@@ -5301,9 +5312,6 @@ static int dgap_tty_register(struct board_t *brd)
 	if (rc < 0)
 		goto unregister_serial_drv;
 
-	dgap_boards_by_major[brd->serial_driver->major] = brd;
-	dgap_boards_by_major[brd->print_driver->major] = brd;
-
 	return 0;
 
 unregister_serial_drv:
@@ -6559,7 +6567,6 @@ static void dgap_cleanup_tty(struct board_t *brd)
 	struct device *dev;
 	unsigned int i;
 
-	dgap_boards_by_major[brd->serial_driver->major] = NULL;
 	for (i = 0; i < brd->nasync; i++) {
 		tty_port_destroy(&brd->serial_ports[i]);
 		dev = brd->channels[i]->ch_tun.un_sysfs;
@@ -6570,7 +6577,6 @@ static void dgap_cleanup_tty(struct board_t *brd)
 	put_tty_driver(brd->serial_driver);
 	kfree(brd->serial_ports);
 
-	dgap_boards_by_major[brd->print_driver->major] = NULL;
 	for (i = 0; i < brd->nasync; i++) {
 		tty_port_destroy(&brd->printer_ports[i]);
 		dev = brd->channels[i]->ch_pun.un_sysfs;
-- 
1.7.1

