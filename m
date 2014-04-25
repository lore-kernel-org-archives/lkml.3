Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaDYHFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:05:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51604 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaDYHF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:05:28 -0400
Date: Fri, 25 Apr 2014 16:04:59 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: daeseok.youn@gmail.com, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgap: implement error handling in
 dgap_tty_register()
Message-ID: <20140425070459.GA9155@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- alloc_tty_driver() is deprecated so it is changed to
tty_alloc_driver()
- Pointers which are allocated by alloc_tty_driver() and kzalloc()
can be NULL so it need to check NULL for them.
- If one of those is failed, it need to add proper handler for
avoiding memory leak.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   49 +++++++++++++++++++++++++++++++++++--------
 1 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 3c9278a..5c8823a 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -875,7 +875,11 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
 		return -EINVAL;
 	}
 
-	dgap_tty_register(brd);
+	ret = dgap_tty_register(brd);
+	if (ret) {
+		pr_err("dgap: failed to register tty driver\n");
+		return ret;
+	}
 	dgap_finalize_board_init(brd);
 
 	if (fw_info[card_type].bios_name) {
@@ -1200,7 +1204,9 @@ static int dgap_tty_register(struct board_t *brd)
 {
 	int rc = 0;
 
-	brd->SerialDriver = alloc_tty_driver(MAXPORTS);
+	brd->SerialDriver = tty_alloc_driver(MAXPORTS, 0);
+	if (IS_ERR(brd->SerialDriver))
+		return PTR_ERR(brd->SerialDriver);
 
 	snprintf(brd->SerialName, MAXTTYNAMELEN, "tty_dgap_%d_", brd->boardnum);
 	brd->SerialDriver->name = brd->SerialName;
@@ -1218,8 +1224,10 @@ static int dgap_tty_register(struct board_t *brd)
 	/* The kernel wants space to store pointers to tty_structs */
 	brd->SerialDriver->ttys =
 		kzalloc(MAXPORTS * sizeof(struct tty_struct *), GFP_KERNEL);
-	if (!brd->SerialDriver->ttys)
-		return -ENOMEM;
+	if (!brd->SerialDriver->ttys) {
+		rc = -ENOMEM;
+		goto free_serial_drv;
+	}
 
 	/*
 	 * Entry points for driver.  Called by the kernel from
@@ -1232,7 +1240,11 @@ static int dgap_tty_register(struct board_t *brd)
 	 * again, separately so we don't get the LD confused about what major
 	 * we are when we get into the dgap_tty_open() routine.
 	 */
-	brd->PrintDriver = alloc_tty_driver(MAXPORTS);
+	brd->PrintDriver = tty_alloc_driver(MAXPORTS, 0);
+	if (IS_ERR(brd->PrintDriver)) {
+		rc = PTR_ERR(brd->PrintDriver);
+		goto free_serial_ttys;
+	}
 
 	snprintf(brd->PrintName, MAXTTYNAMELEN, "pr_dgap_%d_", brd->boardnum);
 	brd->PrintDriver->name = brd->PrintName;
@@ -1250,8 +1262,10 @@ static int dgap_tty_register(struct board_t *brd)
 	/* The kernel wants space to store pointers to tty_structs */
 	brd->PrintDriver->ttys =
 		kzalloc(MAXPORTS * sizeof(struct tty_struct *), GFP_KERNEL);
-	if (!brd->PrintDriver->ttys)
-		return -ENOMEM;
+	if (!brd->PrintDriver->ttys) {
+		rc = -ENOMEM;
+		goto free_print_drv;
+	}
 
 	/*
 	 * Entry points for driver.  Called by the kernel from
@@ -1263,7 +1277,8 @@ static int dgap_tty_register(struct board_t *brd)
 		/* Register tty devices */
 		rc = tty_register_driver(brd->SerialDriver);
 		if (rc < 0)
-			return rc;
+			goto free_print_ttys;
+
 		brd->dgap_Major_Serial_Registered = TRUE;
 		dgap_BoardsByMajor[brd->SerialDriver->major] = brd;
 		brd->dgap_Serial_Major = brd->SerialDriver->major;
@@ -1273,13 +1288,29 @@ static int dgap_tty_register(struct board_t *brd)
 		/* Register Transparent Print devices */
 		rc = tty_register_driver(brd->PrintDriver);
 		if (rc < 0)
-			return rc;
+			goto unregister_serial_drv;
+
 		brd->dgap_Major_TransparentPrint_Registered = TRUE;
 		dgap_BoardsByMajor[brd->PrintDriver->major] = brd;
 		brd->dgap_TransparentPrint_Major = brd->PrintDriver->major;
 	}
 
 	return rc;
+
+unregister_serial_drv:
+	tty_unregister_driver(brd->SerialDriver);
+free_print_ttys:
+	kfree(brd->PrintDriver->ttys);
+	brd->PrintDriver->ttys = NULL;
+free_print_drv:
+	put_tty_driver(brd->PrintDriver);
+free_serial_ttys:
+	kfree(brd->SerialDriver->ttys);
+	brd->SerialDriver->ttys = NULL;
+free_serial_drv:
+	put_tty_driver(brd->SerialDriver);
+
+	return rc;
 }
 
 /*
-- 
1.7.4.4

