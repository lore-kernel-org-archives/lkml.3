Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaKRJsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:48:17 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:42710 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaKRJsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:48:13 -0500
From: Peter Hung <hpeter@gmail.com>
X-Google-Original-From: Peter Hung <hpeter+linux_kernel@gmail.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hung <hpeter+linux_kernel@gmail.com>
Subject: [PATCH] Fix IO address calculation with Multi-Fintek PCI-to-UART Product
Date: Tue, 18 Nov 2014 17:48:08 +0800
Message-Id: <1416304088-6049-1-git-send-email-hpeter+linux_kernel@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Hung <hpeter+linux_kernel@gmail.com>
---
 drivers/tty/serial/8250/8250_pci.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 0468e15..255bc56 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1551,28 +1551,31 @@ static int pci_fintek_setup(struct serial_private *priv,
 {
 	struct pci_dev *pdev = priv->dev;
 	unsigned long base;
-	unsigned long iobase;
+	unsigned long iobase = 0;
 	unsigned long ciobase = 0;
 	u8 config_base;
+	u32 bar_data[3];
+	
 
 	/*
 	 * We are supposed to be able to read these from the PCI config space,
 	 * but the values there don't seem to match what we need to use, so
 	 * just use these hard-coded values for now, as they are correct.
 	 */
+
 	switch (idx) {
-	case 0: iobase = 0xe000; config_base = 0x40; break;
-	case 1: iobase = 0xe008; config_base = 0x48; break;
-	case 2: iobase = 0xe010; config_base = 0x50; break;
-	case 3: iobase = 0xe018; config_base = 0x58; break;
-	case 4: iobase = 0xe020; config_base = 0x60; break;
-	case 5: iobase = 0xe028; config_base = 0x68; break;
-	case 6: iobase = 0xe030; config_base = 0x70; break;
-	case 7: iobase = 0xe038; config_base = 0x78; break;
-	case 8: iobase = 0xe040; config_base = 0x80; break;
-	case 9: iobase = 0xe048; config_base = 0x88; break;
-	case 10: iobase = 0xe050; config_base = 0x90; break;
-	case 11: iobase = 0xe058; config_base = 0x98; break;
+	case 0: config_base = 0x40; break;
+	case 1: config_base = 0x48; break;
+	case 2: config_base = 0x50; break;
+	case 3: config_base = 0x58; break;
+	case 4: config_base = 0x60; break;
+	case 5: config_base = 0x68; break;
+	case 6: config_base = 0x70; break;
+	case 7: config_base = 0x78; break;
+	case 8: config_base = 0x80; break;
+	case 9: config_base = 0x88; break;
+	case 10: config_base = 0x90; break;
+	case 11: config_base = 0x98; break;
 	default:
 		/* Unknown number of ports, get out of here */
 		return -EINVAL;
@@ -1583,9 +1586,17 @@ static int pci_fintek_setup(struct serial_private *priv,
 		ciobase = (int)(base + (0x8 * idx));
 	}
 
+	pci_read_config_dword(pdev, 0x24, &bar_data[0]);
+	pci_read_config_dword(pdev, 0x20, &bar_data[1]);
+	pci_read_config_dword(pdev, 0x1c, &bar_data[2]);
+
+	/* Calculate Real IO Port */
+	iobase = (bar_data[idx/4] & 0xffffffE0) + (idx % 4) * 8;
+
 	dev_dbg(&pdev->dev, "%s: idx=%d iobase=0x%lx ciobase=0x%lx config_base=0x%2x\n",
 		__func__, idx, iobase, ciobase, config_base);
 
+
 	/* Enable UART I/O port */
 	pci_write_config_byte(pdev, config_base + 0x00, 0x01);
 
-- 
1.9.1

