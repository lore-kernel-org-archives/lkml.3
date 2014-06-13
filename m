Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaFMJXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 05:23:36 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:42462 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaFMJXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:23:35 -0400
Date: Fri, 13 Jun 2014 18:22:40 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] staging: dgap: move unrelated functions in
 dgap_firmware_load()
Message-ID: <20140613092240.GA3797@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dgap_firmware_load() has a lot of stuff which are
unrelated with loading firmware.
So just moved to dgap_init_one().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   70 ++++++++++++++++++++++++-------------------
 1 files changed, 39 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 721404f..2ccbd54 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -197,7 +197,8 @@ static void dgap_do_reset_board(struct board_t *brd);
 static int dgap_test_bios(struct board_t *brd);
 static int dgap_test_fep(struct board_t *brd);
 static int dgap_tty_register_ports(struct board_t *brd);
-static int dgap_firmware_load(struct pci_dev *pdev, int card_type);
+static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
+			      struct board_t* brd);
 
 static void dgap_cleanup_module(void);
 
@@ -569,6 +570,7 @@ static int dgap_init_pci(void)
 static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int rc;
+	struct board_t* brd;
 
 	if (dgap_numboards >= MAXBOARDS)
 		return -EPERM;
@@ -581,8 +583,40 @@ static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	dgap_numboards++;
-	return dgap_firmware_load(pdev, ent->driver_data);
+	brd = dgap_board[dgap_numboards++];
+	rc = dgap_firmware_load(pdev, ent->driver_data, brd);
+	if (rc)
+		return rc;
+
+	rc = dgap_alloc_flipbuf(brd);
+	if (rc)
+		return rc;
+
+	rc = dgap_tty_register(brd);
+	if (rc)
+		return rc;
+
+	rc = dgap_request_irq(brd);
+	if (rc)
+		return rc;
+
+	/*
+	 * Do tty device initialization.
+	 */
+	rc = dgap_tty_init(brd);
+	if (rc < 0)
+		return rc;
+
+	rc = dgap_tty_register_ports(brd);
+	if (rc) {
+		dgap_tty_free(brd);
+		return rc;
+	}
+
+	brd->state = BOARD_READY;
+	brd->dpastatus = BD_RUNNING;
+
+	return 0;
 }
 
 static void dgap_remove_one(struct pci_dev *dev)
@@ -822,9 +856,9 @@ static void dgap_free_irq(struct board_t *brd)
 		free_irq(brd->irq, brd);
 }
 
-static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
+static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
+			      struct board_t* brd)
 {
-	struct board_t *brd = dgap_board[dgap_numboards - 1];
 	const struct firmware *fw;
 	char *tmp_ptr;
 	int ret;
@@ -865,9 +899,6 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
 		kfree(dgap_config_buf);
 	}
 
-	ret = dgap_alloc_flipbuf(brd);
-	if (ret)
-		return ret;
 	/*
 	 * Match this board to a config the user created for us.
 	 */
@@ -889,14 +920,6 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
 		return -EINVAL;
 	}
 
-	ret = dgap_tty_register(brd);
-	if (ret)
-		return ret;
-
-	ret = dgap_request_irq(brd);
-	if (ret)
-		return ret;
-
 	if (fw_info[card_type].bios_name) {
 		ret = request_firmware(&fw, fw_info[card_type].bios_name,
 					&pdev->dev);
@@ -959,21 +982,6 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
 		release_firmware(fw);
 	}
 #endif
-	/*
-	 * Do tty device initialization.
-	 */
-	ret = dgap_tty_init(brd);
-	if (ret < 0)
-		return ret;
-
-	ret = dgap_tty_register_ports(brd);
-	if (ret) {
-		dgap_tty_free(brd);
-		return ret;
-	}
-
-	brd->state = BOARD_READY;
-	brd->dpastatus = BD_RUNNING;
 
 	return 0;
 }
-- 
1.7.1

