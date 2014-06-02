Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaFBFPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 01:15:39 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51572 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbaFBFPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 01:15:35 -0400
Date: Mon, 2 Jun 2014 14:14:47 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6 RESEND V2] staging: dgap: unwind on error in
 dgap_found_board()
Message-ID: <20140602051447.GA30379@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a label for "kfree(brd)". And also remove
a state value as BOARD_FAILED in brd when dgap_do_remap() is failed.
Because "brd" will free after failure.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
---
RESEND: this patch is included into newly series of patches.
V2: add "Reviewed-by" line in change log.

 drivers/staging/dgap/dgap.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index af78f6f..5556a6e 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -673,6 +673,7 @@ static int dgap_found_board(struct pci_dev *pdev, int id)
 	struct board_t *brd;
 	unsigned int pci_irq;
 	int i;
+	int ret;
 
 	/* get the board structure and prep it */
 	brd = kzalloc(sizeof(struct board_t), GFP_KERNEL);
@@ -728,8 +729,10 @@ static int dgap_found_board(struct pci_dev *pdev, int id)
 		brd->membase_end = pci_resource_end(pdev, 0);
 	}
 
-	if (!brd->membase)
-		return -ENODEV;
+	if (!brd->membase) {
+		ret = -ENODEV;
+		goto free_brd;
+	}
 
 	if (brd->membase & 1)
 		brd->membase &= ~3;
@@ -770,14 +773,20 @@ static int dgap_found_board(struct pci_dev *pdev, int id)
 	tasklet_init(&brd->helper_tasklet, dgap_poll_tasklet,
 			(unsigned long) brd);
 
-	i = dgap_do_remap(brd);
-	if (i)
-		brd->state = BOARD_FAILED;
+	ret = dgap_do_remap(brd);
+	if (ret)
+		goto free_brd;
 
 	pr_info("dgap: board %d: %s (rev %d), irq %ld\n",
 		dgap_numboards, brd->name, brd->rev, brd->irq);
 
 	return 0;
+
+free_brd:
+	kfree(brd);
+	dgap_board[dgap_numboards] = NULL;
+
+	return ret;
 }
 
 
-- 
1.7.1

