Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbaFMJYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 05:24:12 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58411 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaFMJYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:24:10 -0400
Date: Fri, 13 Jun 2014 18:23:15 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] staging: dgap: unwind on error in dgap_init_one()
Message-ID: <20140613092315.GA3804@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dgap_init_one() needs to handle error properly
if one of functions in dgap_init_one() is failed.

Introduce some functions for handling error in dgap_init_one()
 - dgap_tty_unregister() : unregister tty driver
 - dgap_free_flipbuf() : free flip buffer
 - dgap_release_remap() : release memory region and unmapped memory.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   53 +++++++++++++++++++++++++++++++++++-------
 1 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 2ccbd54..5c8e622 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -77,6 +77,7 @@ static int dgap_init_pci(void);
 static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static void dgap_remove_one(struct pci_dev *dev);
 static int dgap_do_remap(struct board_t *brd);
+static void dgap_release_remap(struct board_t *brd);
 static irqreturn_t dgap_intr(int irq, void *voidbrd);
 
 static int dgap_tty_open(struct tty_struct *tty, struct file *file);
@@ -122,6 +123,7 @@ static int dgap_tty_put_char(struct tty_struct *tty, unsigned char c);
 static void dgap_tty_send_xchar(struct tty_struct *tty, char ch);
 
 static int dgap_tty_register(struct board_t *brd);
+static void dgap_tty_unregister(struct board_t *brd);
 static int dgap_tty_init(struct board_t *);
 static void dgap_tty_free(struct board_t *);
 static void dgap_cleanup_tty(struct board_t *);
@@ -189,6 +191,7 @@ static void dgap_do_fep_load(struct board_t *brd, const u8 *ufep, int len);
 static void dgap_do_conc_load(struct board_t *brd, u8 *uaddr, int len);
 #endif
 static int dgap_alloc_flipbuf(struct board_t *brd);
+static void dgap_free_flipbuf(struct board_t *brd);
 static int dgap_request_irq(struct board_t *brd);
 static void dgap_free_irq(struct board_t *brd);
 
@@ -586,37 +589,49 @@ static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	brd = dgap_board[dgap_numboards++];
 	rc = dgap_firmware_load(pdev, ent->driver_data, brd);
 	if (rc)
-		return rc;
+		goto cleanup_brd;
 
 	rc = dgap_alloc_flipbuf(brd);
 	if (rc)
-		return rc;
+		goto cleanup_brd;
 
 	rc = dgap_tty_register(brd);
 	if (rc)
-		return rc;
+		goto free_flipbuf;
 
 	rc = dgap_request_irq(brd);
 	if (rc)
-		return rc;
+		goto unregister_tty;
 
 	/*
 	 * Do tty device initialization.
 	 */
 	rc = dgap_tty_init(brd);
 	if (rc < 0)
-		return rc;
+		goto free_irq;
 
 	rc = dgap_tty_register_ports(brd);
-	if (rc) {
-		dgap_tty_free(brd);
-		return rc;
-	}
+	if (rc)
+		goto tty_free;
 
 	brd->state = BOARD_READY;
 	brd->dpastatus = BD_RUNNING;
 
 	return 0;
+
+tty_free:
+	dgap_tty_free(brd);
+free_irq:
+	dgap_free_irq(brd);
+unregister_tty:
+	dgap_tty_unregister(brd);
+free_flipbuf:
+	dgap_free_flipbuf(brd);
+cleanup_brd:
+	dgap_release_remap(brd);
+	kfree(brd);
+	dgap_board[--dgap_numboards] = NULL;
+	return rc;
 }
 
 static void dgap_remove_one(struct pci_dev *dev)
@@ -1021,6 +1036,12 @@ static int dgap_do_remap(struct board_t *brd)
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
@@ -1328,6 +1349,14 @@ free_serial_drv:
 	return rc;
 }
 
+static void dgap_tty_unregister(struct board_t *brd)
+{
+	tty_unregister_driver(brd->print_driver);
+	tty_unregister_driver(brd->serial_driver);
+	put_tty_driver(brd->print_driver);
+	put_tty_driver(brd->serial_driver);
+}
+
 /*
  * dgap_tty_init()
  *
@@ -4164,6 +4193,12 @@ static int dgap_alloc_flipbuf(struct board_t *brd)
 	return 0;
 }
 
+static void dgap_free_flipbuf(struct board_t *brd)
+{
+	kfree(brd->flipbuf);
+	kfree(brd->flipflagbuf);
+}
+
 /*
  * Create pr and tty device entries
  */
-- 
1.7.1

