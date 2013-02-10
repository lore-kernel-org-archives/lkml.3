Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314Ab3BLOzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:55:53 -0500
Received: from science.horizon.com ([71.41.210.146]:57515 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761257Ab3BLOxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:53:37 -0500
MBOX-Line: From 1b30b13f9e3e15909a88b242c0146218c5548a41 Mon Sep 17 00:00:00 2001
Message-Id: <1b30b13f9e3e15909a88b242c0146218c5548a41.1360677367.git.linux@horizon.com>
In-Reply-To: <cover.1360677367.git.linux@horizon.com>
References: <cover.1360677367.git.linux@horizon.com>
From: George Spelvin <linux@horizon.com>
Date: Sun, 10 Feb 2013 04:41:56 -0500
Subject: [PATCH v2 2/9] pps: Use pps_lookup_dev to reduce ldisc coupling
To: linux-serial@vger.kernel.org, peter@hurleysoftware.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, giometti@linux.it, linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that N_TTY uses tty->disc_data for its private data,
'subclass' ldiscs cannot use ->disc_data for their own private data.
(This is a regression is v3.8-rc1)

Use pps_lookup_dev to associate the tty with the pps source instead.

This fixes a crashing regression in 3.8-rc1.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 drivers/pps/clients/pps-ldisc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-ldisc.c
index 79451f2..60cee9e 100644
--- a/drivers/pps/clients/pps-ldisc.c
+++ b/drivers/pps/clients/pps-ldisc.c
@@ -31,7 +31,7 @@
 static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
 				struct pps_event_time *ts)
 {
-	struct pps_device *pps = (struct pps_device *)tty->disc_data;
+	struct pps_device *pps = pps_lookup_dev(tty);
 
 	BUG_ON(pps == NULL);
 
@@ -67,9 +67,9 @@ static int pps_tty_open(struct tty_struct *tty)
 		pr_err("cannot register PPS source \"%s\"\n", info.path);
 		return -ENOMEM;
 	}
-	tty->disc_data = pps;
+	pps->lookup_cookie = tty;
 
-	/* Should open N_TTY ldisc too */
+	/* Now open the base class N_TTY ldisc */
 	ret = alias_n_tty_open(tty);
 	if (ret < 0) {
 		pr_err("cannot open tty ldisc \"%s\"\n", info.path);
@@ -81,7 +81,6 @@ static int pps_tty_open(struct tty_struct *tty)
 	return 0;
 
 err_unregister:
-	tty->disc_data = NULL;
 	pps_unregister_source(pps);
 	return ret;
 }
@@ -90,11 +89,10 @@ static void (*alias_n_tty_close)(struct tty_struct *tty);
 
 static void pps_tty_close(struct tty_struct *tty)
 {
-	struct pps_device *pps = (struct pps_device *)tty->disc_data;
+	struct pps_device *pps = pps_lookup_dev(tty);
 
 	alias_n_tty_close(tty);
 
-	tty->disc_data = NULL;
 	dev_info(pps->dev, "removed\n");
 	pps_unregister_source(pps);
 }
-- 
1.8.1.3

