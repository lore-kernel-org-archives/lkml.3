Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab3BPWYy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 17:24:54 -0500
Received: from mail.ispras.ru ([83.149.199.43]:42129 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617Ab3BPWYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 17:24:53 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] tty: mxser: improve error handling in mxser_probe() and mxser_module_init()
Date: Sun, 17 Feb 2013 02:24:37 +0400
Message-Id: <1361053477-17102-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Currently mxser_probe() and mxser_module_init() ignore errors
that can happen in tty_port_register_device().
2. mxser_module_init() does not deallocate resources allocated in mxser_get_ISA_conf()
if mxser_initbrd() failed.

The patch adds proper error handling in all the cases.
Also it moves free_irq() from mxser_release_ISA_res() to mxser_board_remove(),
since it makes mxser_release_ISA_res() a counterpart for mxser_get_ISA_conf(),
while free_irq() is relevant to both ISA and PCI boards.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/tty/mxser.c |   42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 4011386..d82294c 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -2364,7 +2364,6 @@ static void mxser_release_vector(struct mxser_board *brd)
 
 static void mxser_release_ISA_res(struct mxser_board *brd)
 {
-	free_irq(brd->irq, brd);
 	release_region(brd->ports[0].ioaddr, 8 * brd->info->nports);
 	mxser_release_vector(brd);
 }
@@ -2430,6 +2429,7 @@ static void mxser_board_remove(struct mxser_board *brd)
 		tty_unregister_device(mxvar_sdriver, brd->idx + i);
 		tty_port_destroy(&brd->ports[i].port);
 	}
+	free_irq(brd->irq, brd);
 }
 
 static int __init mxser_get_ISA_conf(int cap, struct mxser_board *brd)
@@ -2554,6 +2554,7 @@ static int mxser_probe(struct pci_dev *pdev,
 	struct mxser_board *brd;
 	unsigned int i, j;
 	unsigned long ioaddress;
+	struct device *tty_dev;
 	int retval = -EINVAL;
 
 	for (i = 0; i < MXSER_BOARDS; i++)
@@ -2637,13 +2638,25 @@ static int mxser_probe(struct pci_dev *pdev,
 	if (retval)
 		goto err_rel3;
 
-	for (i = 0; i < brd->info->nports; i++)
-		tty_port_register_device(&brd->ports[i].port, mxvar_sdriver,
-				brd->idx + i, &pdev->dev);
+	for (i = 0; i < brd->info->nports; i++) {
+		tty_dev = tty_port_register_device(&brd->ports[i].port,
+				mxvar_sdriver, brd->idx + i, &pdev->dev);
+		if (IS_ERR(tty_dev)) {
+			retval = PTR_ERR(tty_dev);
+			for (i--; i >= 0; i--)
+				tty_unregister_device(mxvar_sdriver,
+					brd->idx + i);
+			goto err_relbrd;
+		}
+	}
 
 	pci_set_drvdata(pdev, brd);
 
 	return 0;
+err_relbrd:
+	for (i = 0; i < brd->info->nports; i++)
+		tty_port_destroy(&brd->ports[i].port);
+	free_irq(brd->irq, brd);
 err_rel3:
 	pci_release_region(pdev, 3);
 err_zero:
@@ -2665,7 +2678,6 @@ static void mxser_remove(struct pci_dev *pdev)
 
 	mxser_board_remove(brd);
 
-	free_irq(pdev->irq, brd);
 	pci_release_region(pdev, 2);
 	pci_release_region(pdev, 3);
 	pci_disable_device(pdev);
@@ -2683,6 +2695,7 @@ static struct pci_driver mxser_driver = {
 static int __init mxser_module_init(void)
 {
 	struct mxser_board *brd;
+	struct device *tty_dev;
 	unsigned int b, i, m;
 	int retval;
 
@@ -2728,14 +2741,29 @@ static int __init mxser_module_init(void)
 
 		/* mxser_initbrd will hook ISR. */
 		if (mxser_initbrd(brd, NULL) < 0) {
+			mxser_release_ISA_res(brd);
 			brd->info = NULL;
 			continue;
 		}
 
 		brd->idx = m * MXSER_PORTS_PER_BOARD;
-		for (i = 0; i < brd->info->nports; i++)
-			tty_port_register_device(&brd->ports[i].port,
+		for (i = 0; i < brd->info->nports; i++) {
+			tty_dev = tty_port_register_device(&brd->ports[i].port,
 					mxvar_sdriver, brd->idx + i, NULL);
+			if (IS_ERR(tty_dev)) {
+				for (i--; i >= 0; i--)
+					tty_unregister_device(mxvar_sdriver,
+						brd->idx + i);
+				for (i = 0; i < brd->info->nports; i++)
+					tty_port_destroy(&brd->ports[i].port);
+				free_irq(brd->irq, brd);
+				mxser_release_ISA_res(brd);
+				brd->info = NULL;
+				break;
+			}
+		}
+		if (brd->info == NULL)
+			continue;
 
 		m++;
 	}
-- 
1.7.9.5

