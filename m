Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaESJ5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:57:15 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34975 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaESJ5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:57:14 -0400
Date: Mon, 19 May 2014 18:56:34 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH V4] staging: dgap: implement error handling in
 dgap_tty_register()
Message-ID: <20140519095634.GA8370@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- alloc_tty_driver() is deprecated so it is changed to
tty_alloc_driver()
- Pointers which are allocated by alloc_tty_driver() and kzalloc()
can be NULL so it need to check NULL for them.
- If one of those is failed, it need to add proper handler for
avoiding memory leak.
- If both of drivers are registered normally, and
then set TRUE to dgap_major_serial{print}_registered. If one
of drivers is failed to register, leave a default value as
FALSE.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
V2: rebased on staging-next branch
V3: removes unneeded information in e-mail
V4: removes labels for kfree() calls with ttys because
destruct_tty_driver() calls kfree for ttys.

 drivers/staging/dgap/dgap.c |   45 +++++++++++++++++++++++++++++++-----------
 1 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index d7cfc45..8cf0816 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -1210,9 +1210,11 @@ static int dgap_ms_sleep(ulong ms)
  */
 static int dgap_tty_register(struct board_t *brd)
 {
-	int rc = 0;
+	int rc;
 
-	brd->serial_driver = alloc_tty_driver(MAXPORTS);
+	brd->serial_driver = tty_alloc_driver(MAXPORTS, 0);
+	if (IS_ERR(brd->serial_driver))
+		return PTR_ERR(brd->serial_driver);
 
 	snprintf(brd->serial_name, MAXTTYNAMELEN, "tty_dgap_%d_",
 		 brd->boardnum);
@@ -1231,8 +1233,10 @@ static int dgap_tty_register(struct board_t *brd)
 	/* The kernel wants space to store pointers to tty_structs */
 	brd->serial_driver->ttys =
 		kzalloc(MAXPORTS * sizeof(struct tty_struct *), GFP_KERNEL);
-	if (!brd->serial_driver->ttys)
-		return -ENOMEM;
+	if (!brd->serial_driver->ttys) {
+		rc = -ENOMEM;
+		goto free_serial_drv;
+	}
 
 	/*
 	 * Entry points for driver.  Called by the kernel from
@@ -1245,7 +1249,11 @@ static int dgap_tty_register(struct board_t *brd)
 	 * again, separately so we don't get the LD confused about what major
 	 * we are when we get into the dgap_tty_open() routine.
 	 */
-	brd->print_driver = alloc_tty_driver(MAXPORTS);
+	brd->print_driver = tty_alloc_driver(MAXPORTS, 0);
+	if (IS_ERR(brd->print_driver)) {
+		rc = PTR_ERR(brd->print_driver);
+		goto free_serial_drv;
+	}
 
 	snprintf(brd->print_name, MAXTTYNAMELEN, "pr_dgap_%d_",
 		 brd->boardnum);
@@ -1264,8 +1272,10 @@ static int dgap_tty_register(struct board_t *brd)
 	/* The kernel wants space to store pointers to tty_structs */
 	brd->print_driver->ttys =
 		kzalloc(MAXPORTS * sizeof(struct tty_struct *), GFP_KERNEL);
-	if (!brd->print_driver->ttys)
-		return -ENOMEM;
+	if (!brd->print_driver->ttys) {
+		rc = -ENOMEM;
+		goto free_print_drv;
+	}
 
 	/*
 	 * Entry points for driver.  Called by the kernel from
@@ -1276,19 +1286,30 @@ static int dgap_tty_register(struct board_t *brd)
 	/* Register tty devices */
 	rc = tty_register_driver(brd->serial_driver);
 	if (rc < 0)
-		return rc;
-	brd->dgap_major_serial_registered = TRUE;
-	dgap_boards_by_major[brd->serial_driver->major] = brd;
-	brd->dgap_serial_major = brd->serial_driver->major;
+		goto free_print_drv;
 
 	/* Register Transparent Print devices */
 	rc = tty_register_driver(brd->print_driver);
 	if (rc < 0)
-		return rc;
+		goto unregister_serial_drv;
+
+	brd->dgap_major_serial_registered = TRUE;
+	dgap_boards_by_major[brd->serial_driver->major] = brd;
+	brd->dgap_serial_major = brd->serial_driver->major;
+
 	brd->dgap_major_transparent_print_registered = TRUE;
 	dgap_boards_by_major[brd->print_driver->major] = brd;
 	brd->dgap_transparent_print_major = brd->print_driver->major;
 
+	return 0;
+
+unregister_serial_drv:
+	tty_unregister_driver(brd->serial_driver);
+free_print_drv:
+	put_tty_driver(brd->print_driver);
+free_serial_drv:
+	put_tty_driver(brd->serial_driver);
+
 	return rc;
 }
 
-- 
1.7.1

