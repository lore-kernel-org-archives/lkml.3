Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaKFK3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:29:25 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:56905 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaKFK3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:29:23 -0500
Date: Thu, 6 Nov 2014 19:27:11 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging: dgap: fix memory leak caused by double
 allocation of tty_structs
Message-ID: <20141106102711.GA21460@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty_struct of serial_driver and print_driver were getting
allocated twice. One is allocated in tty_alloc_driver(), the other
is in dgap_tty_register(). So remove these in dgap_tty_register().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 6418cc5..688aaa4 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -5254,14 +5254,6 @@ static int dgap_tty_register(struct board_t *brd)
 	brd->serial_driver->init_termios = dgap_default_termios;
 	brd->serial_driver->driver_name = DRVSTR;
 
-	/* The kernel wants space to store pointers to tty_structs */
-	brd->serial_driver->ttys =
-		kzalloc(MAXPORTS * sizeof(struct tty_struct *), GFP_KERNEL);
-	if (!brd->serial_driver->ttys) {
-		rc = -ENOMEM;
-		goto free_serial_drv;
-	}
-
 	/*
 	 * Entry points for driver.  Called by the kernel from
 	 * tty_io.c and n_tty.c.
@@ -5293,14 +5285,6 @@ static int dgap_tty_register(struct board_t *brd)
 	brd->print_driver->init_termios = dgap_default_termios;
 	brd->print_driver->driver_name = DRVSTR;
 
-	/* The kernel wants space to store pointers to tty_structs */
-	brd->print_driver->ttys =
-		kzalloc(MAXPORTS * sizeof(struct tty_struct *), GFP_KERNEL);
-	if (!brd->print_driver->ttys) {
-		rc = -ENOMEM;
-		goto free_print_drv;
-	}
-
 	/*
 	 * Entry points for driver.  Called by the kernel from
 	 * tty_io.c and n_tty.c.
-- 
1.7.1

