Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934534AbaFTFU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 01:20:59 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54857 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaFTFU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 01:20:58 -0400
Date: Fri, 20 Jun 2014 14:19:58 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgap: make dgap_found_board() return a brd pointer
Message-ID: <20140620051958.GA17076@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make dgap_found_board() return a brd pointer and that brd pointer
assign to dgap_board[] in the end of the dgap_init_one().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 5c8e622..55c9761 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -70,7 +70,8 @@ MODULE_SUPPORTED_DEVICE("dgap");
 
 static int dgap_start(void);
 static void dgap_init_globals(void);
-static int dgap_found_board(struct pci_dev *pdev, int id, int boardnum);
+static struct board_t *dgap_found_board(struct pci_dev *pdev, int id,
+					int boardnum);
 static void dgap_cleanup_board(struct board_t *brd);
 static void dgap_poll_handler(ulong dummy);
 static int dgap_init_pci(void);
@@ -582,11 +583,10 @@ static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return -EIO;
 
-	rc = dgap_found_board(pdev, ent->driver_data, dgap_numboards);
-	if (rc)
+	brd = dgap_found_board(pdev, ent->driver_data, dgap_numboards);
+	if (IS_ERR(brd))
 		return rc;
 
-	brd = dgap_board[dgap_numboards++];
 	rc = dgap_firmware_load(pdev, ent->driver_data, brd);
 	if (rc)
 		goto cleanup_brd;
@@ -617,6 +617,8 @@ static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	brd->state = BOARD_READY;
 	brd->dpastatus = BD_RUNNING;
 
+	dgap_board[dgap_numboards++] = brd;
+
 	return 0;
 
 tty_free:
@@ -717,7 +719,8 @@ static void dgap_cleanup_board(struct board_t *brd)
  *
  * A board has been found, init it.
  */
-static int dgap_found_board(struct pci_dev *pdev, int id, int boardnum)
+static struct board_t *dgap_found_board(struct pci_dev *pdev, int id,
+					int boardnum)
 {
 	struct board_t *brd;
 	unsigned int pci_irq;
@@ -727,9 +730,7 @@ static int dgap_found_board(struct pci_dev *pdev, int id, int boardnum)
 	/* get the board structure and prep it */
 	brd = kzalloc(sizeof(struct board_t), GFP_KERNEL);
 	if (!brd)
-		return -ENOMEM;
-
-	dgap_board[boardnum] = brd;
+		return ERR_PTR(-ENOMEM);
 
 	/* store the info for the board we've found */
 	brd->magic = DGAP_BOARD_MAGIC;
@@ -828,13 +829,12 @@ static int dgap_found_board(struct pci_dev *pdev, int id, int boardnum)
 	pr_info("dgap: board %d: %s (rev %d), irq %ld\n",
 		boardnum, brd->name, brd->rev, brd->irq);
 
-	return 0;
+	return brd;
 
 free_brd:
 	kfree(brd);
-	dgap_board[boardnum] = NULL;
 
-	return ret;
+	return ERR_PTR(ret);
 }
 
 
-- 
1.7.1

