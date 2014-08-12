Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaHLGkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:40:07 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:48976 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbaHLGkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:40:05 -0400
Date: Tue, 12 Aug 2014 15:38:33 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: [PATCH 1/7 V2] staging: dgap: remove useless variable
Message-ID: <20140812063833.GA14768@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dgap_major_serial_registered and dgap_major_transparent_print_registered
could be checked whether a board is initialized.
But it doesn't need to check that variables becasue dgap_board
as global is managed for boards which are initialized completely.
So when it called dgap_cleanup_tty() function, various allocated
variables in a board will free properly.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
V2: update change log.

 drivers/staging/dgap/dgap.c |   48 +++++++++++++++++-------------------------
 drivers/staging/dgap/dgap.h |    3 --
 2 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index ac12e99..55c06c9 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -1320,11 +1320,9 @@ static int dgap_tty_register(struct board_t *brd)
 	if (rc < 0)
 		goto unregister_serial_drv;
 
-	brd->dgap_major_serial_registered = TRUE;
 	dgap_boards_by_major[brd->serial_driver->major] = brd;
 	brd->dgap_serial_major = brd->serial_driver->major;
 
-	brd->dgap_major_transparent_print_registered = TRUE;
 	dgap_boards_by_major[brd->print_driver->major] = brd;
 	brd->dgap_transparent_print_major = brd->print_driver->major;
 
@@ -1544,35 +1542,29 @@ static void dgap_cleanup_tty(struct board_t *brd)
 	struct device *dev;
 	int i;
 
-	if (brd->dgap_major_serial_registered) {
-		dgap_boards_by_major[brd->serial_driver->major] = NULL;
-		brd->dgap_serial_major = 0;
-		for (i = 0; i < brd->nasync; i++) {
-			tty_port_destroy(&brd->serial_ports[i]);
-			dev = brd->channels[i]->ch_tun.un_sysfs;
-			dgap_remove_tty_sysfs(dev);
-			tty_unregister_device(brd->serial_driver, i);
-		}
-		tty_unregister_driver(brd->serial_driver);
-		put_tty_driver(brd->serial_driver);
-		kfree(brd->serial_ports);
-		brd->dgap_major_serial_registered = FALSE;
-	}
-
-	if (brd->dgap_major_transparent_print_registered) {
-		dgap_boards_by_major[brd->print_driver->major] = NULL;
-		brd->dgap_transparent_print_major = 0;
-		for (i = 0; i < brd->nasync; i++) {
-			tty_port_destroy(&brd->printer_ports[i]);
-			dev = brd->channels[i]->ch_pun.un_sysfs;
-			dgap_remove_tty_sysfs(dev);
-			tty_unregister_device(brd->print_driver, i);
-		}
-		tty_unregister_driver(brd->print_driver);
-		put_tty_driver(brd->print_driver);
-		kfree(brd->printer_ports);
-		brd->dgap_major_transparent_print_registered = FALSE;
+	dgap_boards_by_major[brd->serial_driver->major] = NULL;
+	brd->dgap_serial_major = 0;
+	for (i = 0; i < brd->nasync; i++) {
+		tty_port_destroy(&brd->serial_ports[i]);
+		dev = brd->channels[i]->ch_tun.un_sysfs;
+		dgap_remove_tty_sysfs(dev);
+		tty_unregister_device(brd->serial_driver, i);
+	}
+	tty_unregister_driver(brd->serial_driver);
+	put_tty_driver(brd->serial_driver);
+	kfree(brd->serial_ports);
+
+	dgap_boards_by_major[brd->print_driver->major] = NULL;
+	brd->dgap_transparent_print_major = 0;
+	for (i = 0; i < brd->nasync; i++) {
+		tty_port_destroy(&brd->printer_ports[i]);
+		dev = brd->channels[i]->ch_pun.un_sysfs;
+		dgap_remove_tty_sysfs(dev);
+		tty_unregister_device(brd->print_driver, i);
 	}
+	tty_unregister_driver(brd->print_driver);
+	put_tty_driver(brd->print_driver);
+	kfree(brd->printer_ports);
 }
 
 /*=======================================================================
diff --git a/drivers/staging/dgap/dgap.h b/drivers/staging/dgap/dgap.h
index 9728d59..0482a4c 100644
--- a/drivers/staging/dgap/dgap.h
+++ b/drivers/staging/dgap/dgap.h
@@ -586,9 +586,6 @@ struct board_t {
 	struct tty_port *printer_ports;
 	char		print_name[200];
 
-	u32		dgap_major_serial_registered;
-	u32		dgap_major_transparent_print_registered;
-
 	u32		dgap_serial_major;
 	u32		dgap_transparent_print_major;
 
-- 
1.7.1

