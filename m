Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbaFCG1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 02:27:43 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50182 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaFCG1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 02:27:42 -0400
Date: Tue, 3 Jun 2014 15:26:53 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] staging: dgap: pass "dgap_numboards" as a paramter to
 dgap_found_board()
Message-ID: <20140603062653.GA7153@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Pass "dgap_numboards" to dgap_found_board() instead of
using a global variable.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index c78c8e2..9501a5e 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -70,7 +70,7 @@ MODULE_SUPPORTED_DEVICE("dgap");
 
 static int dgap_start(void);
 static void dgap_init_globals(void);
-static int dgap_found_board(struct pci_dev *pdev, int id);
+static int dgap_found_board(struct pci_dev *pdev, int id, int boardnum);
 static void dgap_cleanup_board(struct board_t *brd);
 static void dgap_poll_handler(ulong dummy);
 static int dgap_init_pci(void);
@@ -575,7 +575,7 @@ static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return -EIO;
 
-	rc = dgap_found_board(pdev, ent->driver_data);
+	rc = dgap_found_board(pdev, ent->driver_data, dgap_numboards);
 	if (rc)
 		return rc;
 
@@ -667,7 +667,7 @@ static void dgap_cleanup_board(struct board_t *brd)
  *
  * A board has been found, init it.
  */
-static int dgap_found_board(struct pci_dev *pdev, int id)
+static int dgap_found_board(struct pci_dev *pdev, int id, int boardnum)
 {
 	struct board_t *brd;
 	unsigned int pci_irq;
@@ -679,11 +679,11 @@ static int dgap_found_board(struct pci_dev *pdev, int id)
 	if (!brd)
 		return -ENOMEM;
 
-	dgap_board[dgap_numboards] = brd;
+	dgap_board[boardnum] = brd;
 
 	/* store the info for the board we've found */
 	brd->magic = DGAP_BOARD_MAGIC;
-	brd->boardnum = dgap_numboards;
+	brd->boardnum = boardnum;
 	brd->firstminor = 0;
 	brd->vendor = dgap_pci_tbl[id].vendor;
 	brd->device = dgap_pci_tbl[id].device;
@@ -777,13 +777,13 @@ static int dgap_found_board(struct pci_dev *pdev, int id)
 		goto free_brd;
 
 	pr_info("dgap: board %d: %s (rev %d), irq %ld\n",
-		dgap_numboards, brd->name, brd->rev, brd->irq);
+		boardnum, brd->name, brd->rev, brd->irq);
 
 	return 0;
 
 free_brd:
 	kfree(brd);
-	dgap_board[dgap_numboards] = NULL;
+	dgap_board[boardnum] = NULL;
 
 	return ret;
 }
-- 
1.7.1

