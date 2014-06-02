Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaFBFJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 01:09:14 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58570 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaFBFJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 01:09:12 -0400
Date: Mon, 2 Jun 2014 14:08:24 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] staging: dgap: unwind on error in
 dgap_tty_register_ports()
Message-ID: <20140602050824.GA29914@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- The dgap_tty_register_ports() needs to handle if the
tty_port_register_device() fails.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   44 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 8580f4b..3e716fe 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -4143,6 +4143,7 @@ static int dgap_tty_register_ports(struct board_t *brd)
 {
 	struct channel_t *ch;
 	int i;
+	int ret;
 
 	brd->serial_ports = kcalloc(brd->nasync, sizeof(*brd->serial_ports),
 					GFP_KERNEL);
@@ -4152,8 +4153,8 @@ static int dgap_tty_register_ports(struct board_t *brd)
 	brd->printer_ports = kcalloc(brd->nasync, sizeof(*brd->printer_ports),
 					GFP_KERNEL);
 	if (!brd->printer_ports) {
-		kfree(brd->serial_ports);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto free_serial_ports;
 	}
 
 	for (i = 0; i < brd->nasync; i++) {
@@ -4170,6 +4171,11 @@ static int dgap_tty_register_ports(struct board_t *brd)
 					brd->serial_driver,
 					brd->firstminor + i, NULL);
 
+		if (IS_ERR(classp)) {
+			ret = PTR_ERR(classp);
+			goto unregister_ttys;
+		}
+
 		dgap_create_tty_sysfs(&ch->ch_tun, classp);
 		ch->ch_tun.un_sysfs = classp;
 
@@ -4177,12 +4183,46 @@ static int dgap_tty_register_ports(struct board_t *brd)
 					brd->print_driver,
 					brd->firstminor + i, NULL);
 
+		if (IS_ERR(classp)) {
+			ret = PTR_ERR(classp);
+			goto unregister_ttys;
+		}
+
 		dgap_create_tty_sysfs(&ch->ch_pun, classp);
 		ch->ch_pun.un_sysfs = classp;
 	}
 	dgap_create_ports_sysfiles(brd);
 
 	return 0;
+
+unregister_ttys:
+	while (i >= 0) {
+		ch = brd->channels[i];
+		if (ch->ch_tun.un_sysfs) {
+			dgap_remove_tty_sysfs(ch->ch_tun.un_sysfs);
+			tty_unregister_device(brd->serial_driver, i);
+		}
+
+		if (ch->ch_pun.un_sysfs) {
+			dgap_remove_tty_sysfs(ch->ch_pun.un_sysfs);
+			tty_unregister_device(brd->print_driver, i);
+		}
+		i--;
+	}
+
+	for (i = 0; i < brd->nasync; i++) {
+		tty_port_destroy(&brd->serial_ports[i]);
+		tty_port_destroy(&brd->printer_ports[i]);
+	}
+
+	kfree(brd->printer_ports);
+	brd->printer_ports = NULL;
+
+free_serial_ports:
+	kfree(brd->serial_ports);
+	brd->serial_ports = NULL;
+
+	return ret;
 }
 
 /*
-- 
1.7.1

