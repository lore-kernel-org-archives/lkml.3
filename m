Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaFMHpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:45:09 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36087 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaFMHpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:45:07 -0400
Date: Fri, 13 Jun 2014 16:44:11 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] staging: dgap: introduce dgap_release_remap()
Message-ID: <20140613074411.GA31639@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dgap_found_board() did request some memory region and
call ioremap, these should be released and unmaped
when one of functions which are called after dgap_found_board()
in dgap_init_one() is failed.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index e1347fb..5c8e622 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -77,6 +77,7 @@ static int dgap_init_pci(void);
 static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static void dgap_remove_one(struct pci_dev *dev);
 static int dgap_do_remap(struct board_t *brd);
+static void dgap_release_remap(struct board_t *brd);
 static irqreturn_t dgap_intr(int irq, void *voidbrd);
 
 static int dgap_tty_open(struct tty_struct *tty, struct file *file);
@@ -588,11 +589,11 @@ static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	brd = dgap_board[dgap_numboards++];
 	rc = dgap_firmware_load(pdev, ent->driver_data, brd);
 	if (rc)
-		goto free_brd;
+		goto cleanup_brd;
 
 	rc = dgap_alloc_flipbuf(brd);
 	if (rc)
-		goto free_brd;
+		goto cleanup_brd;
 
 	rc = dgap_tty_register(brd);
 	if (rc)
@@ -626,7 +627,8 @@ unregister_tty:
 	dgap_tty_unregister(brd);
 free_flipbuf:
 	dgap_free_flipbuf(brd);
-free_brd:
+cleanup_brd:
+	dgap_release_remap(brd);
 	kfree(brd);
 	dgap_board[--dgap_numboards] = NULL;
 	return rc;
@@ -1034,6 +1036,12 @@ static int dgap_do_remap(struct board_t *brd)
 	return 0;
 }
 
+static void dgap_release_remap(struct board_t *brd)
+{
+	release_mem_region(brd->membase, 0x200000);
+	release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
+	iounmap(brd->re_map_membase);
+}
 /*****************************************************************************
 *
 * Function:
-- 
1.7.1

