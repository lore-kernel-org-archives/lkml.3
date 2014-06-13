Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaFMHod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:44:33 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:57799 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaFMHoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:44:32 -0400
Date: Fri, 13 Jun 2014 16:43:37 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] staging: dgap: cleanup dgap_firmware_load() function
Message-ID: <20140613074337.GA31632@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dgap_firmware_load() has a lot of stuff beside
loding firmware. So some registering and initializing
for device are moved into dgap_init_one().

And also adds unwinding on error in dgap_init_one().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   81 ++++++++++++++++++++++++++----------------
 1 files changed, 50 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index c0016bd..e1347fb 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -199,7 +199,8 @@ static void dgap_do_reset_board(struct board_t *brd);
 static int dgap_test_bios(struct board_t *brd);
 static int dgap_test_fep(struct board_t *brd);
 static int dgap_tty_register_ports(struct board_t *brd);
-static int dgap_firmware_load(struct pci_dev *pdev, int card_type);
+static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
+			      struct board_t* brd);
 
 static void dgap_cleanup_module(void);
 
@@ -571,6 +572,7 @@ static int dgap_init_pci(void)
 static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int rc;
+	struct board_t* brd;
 
 	if (dgap_numboards >= MAXBOARDS)
 		return -EPERM;
@@ -583,8 +585,51 @@ static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	dgap_numboards++;
-	return dgap_firmware_load(pdev, ent->driver_data);
+	brd = dgap_board[dgap_numboards++];
+	rc = dgap_firmware_load(pdev, ent->driver_data, brd);
+	if (rc)
+		goto free_brd;
+
+	rc = dgap_alloc_flipbuf(brd);
+	if (rc)
+		goto free_brd;
+
+	rc = dgap_tty_register(brd);
+	if (rc)
+		goto free_flipbuf;
+
+	rc = dgap_request_irq(brd);
+	if (rc)
+		goto unregister_tty;
+
+	/*
+	 * Do tty device initialization.
+	 */
+	rc = dgap_tty_init(brd);
+	if (rc < 0)
+		goto free_irq;
+
+	rc = dgap_tty_register_ports(brd);
+	if (rc)
+		goto tty_free;
+
+	brd->state = BOARD_READY;
+	brd->dpastatus = BD_RUNNING;
+
+	return 0;
+
+tty_free:
+	dgap_tty_free(brd);
+free_irq:
+	dgap_free_irq(brd);
+unregister_tty:
+	dgap_tty_unregister(brd);
+free_flipbuf:
+	dgap_free_flipbuf(brd);
+free_brd:
+	kfree(brd);
+	dgap_board[--dgap_numboards] = NULL;
+	return rc;
 }
 
 static void dgap_remove_one(struct pci_dev *dev)
@@ -824,9 +869,9 @@ static void dgap_free_irq(struct board_t *brd)
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
@@ -867,9 +912,6 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
 		kfree(dgap_config_buf);
 	}
 
-	ret = dgap_alloc_flipbuf(brd);
-	if (ret)
-		return ret;
 	/*
 	 * Match this board to a config the user created for us.
 	 */
@@ -891,14 +933,6 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
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
@@ -961,21 +995,6 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
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

