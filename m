Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbaKFK3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:29:49 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:62030 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaKFK3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:29:46 -0500
Date: Thu, 6 Nov 2014 19:27:33 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] staging: dgap: remove useless variables for saving tty's
 major
Message-ID: <20141106102733.GA21465@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The board_t has a tty_struct(serial_driver and print_driver)
that has a major number. When major number is compared in
dgap_tty_open(), just use brd->serial_driver{print_driver}->major.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    9 ++-------
 drivers/staging/dgap/dgap.h |    3 ---
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 688aaa4..3f23e5b 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -4477,10 +4477,10 @@ static int dgap_tty_open(struct tty_struct *tty, struct file *file)
 	spin_lock_irqsave(&ch->ch_lock, lock_flags2);
 
 	/* Figure out our type */
-	if (major == brd->dgap_serial_major) {
+	if (major == brd->serial_driver->major) {
 		un = &brd->channels[minor]->ch_tun;
 		un->un_type = DGAP_SERIAL;
-	} else if (major == brd->dgap_transparent_print_major) {
+	} else if (major == brd->print_driver->major) {
 		un = &brd->channels[minor]->ch_pun;
 		un->un_type = DGAP_PRINT;
 	} else {
@@ -5302,10 +5302,7 @@ static int dgap_tty_register(struct board_t *brd)
 		goto unregister_serial_drv;
 
 	dgap_boards_by_major[brd->serial_driver->major] = brd;
-	brd->dgap_serial_major = brd->serial_driver->major;
-
 	dgap_boards_by_major[brd->print_driver->major] = brd;
-	brd->dgap_transparent_print_major = brd->print_driver->major;
 
 	return 0;
 
@@ -6563,7 +6560,6 @@ static void dgap_cleanup_tty(struct board_t *brd)
 	unsigned int i;
 
 	dgap_boards_by_major[brd->serial_driver->major] = NULL;
-	brd->dgap_serial_major = 0;
 	for (i = 0; i < brd->nasync; i++) {
 		tty_port_destroy(&brd->serial_ports[i]);
 		dev = brd->channels[i]->ch_tun.un_sysfs;
@@ -6575,7 +6571,6 @@ static void dgap_cleanup_tty(struct board_t *brd)
 	kfree(brd->serial_ports);
 
 	dgap_boards_by_major[brd->print_driver->major] = NULL;
-	brd->dgap_transparent_print_major = 0;
 	for (i = 0; i < brd->nasync; i++) {
 		tty_port_destroy(&brd->printer_ports[i]);
 		dev = brd->channels[i]->ch_pun.un_sysfs;
diff --git a/drivers/staging/dgap/dgap.h b/drivers/staging/dgap/dgap.h
index 14e2ed0..6840331 100644
--- a/drivers/staging/dgap/dgap.h
+++ b/drivers/staging/dgap/dgap.h
@@ -584,9 +584,6 @@ struct board_t {
 	struct tty_port *printer_ports;
 	char		print_name[200];
 
-	u32		dgap_serial_major;
-	u32		dgap_transparent_print_major;
-
 	struct bs_t __iomem *bd_bs;	/* Base structure pointer         */
 
 	char	*flipbuf;		/* Our flip buffer, alloced if    */
-- 
1.7.1

