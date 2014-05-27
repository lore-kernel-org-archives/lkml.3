Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaE0HKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 03:10:22 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41776 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaE0HKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 03:10:21 -0400
Date: Tue, 27 May 2014 16:09:37 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH V2] staging: dgap: implement proper error handling in
 dgap_firmware_load()
Message-ID: <20140527070937.GA21621@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dgap_tty_init() and dgap_tty_register_ports() are failed,
these are needed to free some memory properly.

It can be handled by calling dgap_tty_uninit() and dgap_cleanup_board().
But tty's ports are not registered yet when these function are failed,
so it need to switch with boolean value whether tty's ports are
registered.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
V2: remove "brd->nasync = 0" for avoiding to call some destroyer
for unregistering tty's ports.

I'm not sure about add a parameter in dgap_tty_uninit() for checking
whether tty's ports are registered.
please review this. And if I am wrong, let me know.

 drivers/staging/dgap/dgap.c |   34 +++++++++++++++++++++++-----------
 1 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 65d651e..03a3a4b 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -124,7 +124,7 @@ static void dgap_tty_send_xchar(struct tty_struct *tty, char ch);
 
 static int dgap_tty_register(struct board_t *brd);
 static int dgap_tty_init(struct board_t *);
-static void dgap_tty_uninit(struct board_t *);
+static void dgap_tty_uninit(struct board_t *, bool);
 static void dgap_carrier(struct channel_t *ch);
 static void dgap_input(struct channel_t *ch);
 
@@ -620,7 +620,7 @@ static void dgap_cleanup_module(void)
 
 	for (i = 0; i < dgap_numboards; ++i) {
 		dgap_remove_ports_sysfiles(dgap_board[i]);
-		dgap_tty_uninit(dgap_board[i]);
+		dgap_tty_uninit(dgap_board[i], true);
 		dgap_cleanup_board(dgap_board[i]);
 	}
 
@@ -954,19 +954,23 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
 	 * Do tty device initialization.
 	 */
 	ret = dgap_tty_init(brd);
-	if (ret < 0) {
-		dgap_tty_uninit(brd);
-		return ret;
-	}
+	if (ret < 0)
+		goto err_cleanup;
 
 	ret = dgap_tty_register_ports(brd);
 	if (ret)
-		return ret;
+		goto err_cleanup;
 
 	brd->state = BOARD_READY;
 	brd->dpastatus = BD_RUNNING;
 
 	return 0;
+
+err_cleanup:
+	dgap_tty_uninit(brd, false);
+	dgap_cleanup_board(brd);
+	return ret;
+
 }
 
 /*
@@ -1488,19 +1492,20 @@ static int dgap_tty_init(struct board_t *brd)
  * Uninitialize the TTY portion of this driver.  Free all memory and
  * resources.
  */
-static void dgap_tty_uninit(struct board_t *brd)
+static void dgap_tty_uninit(struct board_t *brd, bool ports_registered)
 {
 	struct device *dev;
-	int i;
+	int i = 0;
 
 	if (brd->dgap_major_serial_registered) {
 		dgap_boards_by_major[brd->serial_driver->major] = NULL;
 		brd->dgap_serial_major = 0;
-		for (i = 0; i < brd->nasync; i++) {
+		while (ports_registered && i < brd->nasync) {
 			tty_port_destroy(&brd->serial_ports[i]);
 			dev = brd->channels[i]->ch_tun.un_sysfs;
 			dgap_remove_tty_sysfs(dev);
 			tty_unregister_device(brd->serial_driver, i);
+			i++;
 		}
 		tty_unregister_driver(brd->serial_driver);
 		put_tty_driver(brd->serial_driver);
@@ -1508,14 +1513,21 @@ static void dgap_tty_uninit(struct board_t *brd)
 		brd->dgap_major_serial_registered = FALSE;
 	}
 
+	/*
+	 * Clear index of tty's port for unregistering
+	 * ports of printer driver
+	 */
+	i = 0;
+
 	if (brd->dgap_major_transparent_print_registered) {
 		dgap_boards_by_major[brd->print_driver->major] = NULL;
 		brd->dgap_transparent_print_major = 0;
-		for (i = 0; i < brd->nasync; i++) {
+		while (ports_registered && i < brd->nasync) {
 			tty_port_destroy(&brd->printer_ports[i]);
 			dev = brd->channels[i]->ch_pun.un_sysfs;
 			dgap_remove_tty_sysfs(dev);
 			tty_unregister_device(brd->print_driver, i);
+			i++;
 		}
 		tty_unregister_driver(brd->print_driver);
 		put_tty_driver(brd->print_driver);
-- 
1.7.1

