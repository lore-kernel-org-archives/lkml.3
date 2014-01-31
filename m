Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbaAaRcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:32:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55189 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524AbaAaRco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:32:44 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 12/14] staging: comedi: 8255_pci: fix for newer PCI-DIO48H
Date: Fri, 31 Jan 2014 09:32:15 -0800
Message-Id: <1391189537-20777-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391189537-20777-1-git-send-email-kamal@canonical.com>
References: <1391189537-20777-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

based on
commit 0283f7a100882684ad32b768f9f1ad81658a0b92 upstream.

At some point, Measurement Computing / ComputerBoards redesigned the
PCI-DIO48H to use a PLX PCI interface chip instead of an AMCC chip.
This meant they had to put their hardware registers in the PCI BAR 2
region instead of PCI BAR 1.  Unfortunately, they kept the same PCI
device ID for the new design.  This means the driver recognizes the
newer cards, but doesn't work (and is likely to screw up the local
configuration registers of the PLX chip) because it's using the wrong
region.

Since  the PCI subvendor and subdevice IDs were both zero on the old
design, but are the same as the vendor and device on the new design, we
can tell the old design and new design apart easily enough.  To avoid
adding extra data to `pci_8255_boards[]`, treat the board as a special
case in `pci_8255_auto_attach[]`.  It's safer to use the fact that the
PCI BAR 2 region will have non-zero length only on the newer design, so
use that fact to distinguish them.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Cc: kernel-team@lists.ubuntu.com
[ ian: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/comedi/drivers/8255_pci.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255_pci.c b/drivers/staging/comedi/drivers/8255_pci.c
index e0a7952..92ee23e 100644
--- a/drivers/staging/comedi/drivers/8255_pci.c
+++ b/drivers/staging/comedi/drivers/8255_pci.c
@@ -122,7 +122,7 @@ static const struct pci_8255_boardinfo pci_8255_boards[] = {
 		.name		= "cb_pci-dio48h",
 		.vendor		= PCI_VENDOR_ID_CB,
 		.device		= PCI_DEVICE_ID_CB_PCIDIO48H,
-		.dio_badr	= 1,
+		.dio_badr	= 1,	/* only for older boards */
 		.n_8255		= 2,
 	}, {
 		.name		= "cb_pci-dio96h",
@@ -224,6 +224,7 @@ static int pci_8255_auto_attach(struct comedi_device *dev,
 	unsigned long len;
 	int ret;
 	int i;
+	int dio_badr;
 
 	board = pci_8255_find_boardinfo(dev, pcidev);
 	if (!board)
@@ -239,8 +240,21 @@ static int pci_8255_auto_attach(struct comedi_device *dev,
 	ret = comedi_pci_enable(pcidev, dev->board_name);
 	if (ret)
 		return ret;
-	iobase = pci_resource_start(pcidev, board->dio_badr);
-	len = pci_resource_len(pcidev, board->dio_badr);
+	dio_badr = board->dio_badr;
+	/*
+	 * For Measurement Computing / ComputerBoards PCI-DIO48H, use the
+	 * PCI BAR 2 region, if non-zero length, else use the PCI BAR 1 region
+	 * from the board entry.  This is because the board was redesigned to
+	 * use a different PCI interface chip, with the user registers in a
+	 * different PCI BAR region.
+	 */
+	if (pcidev->vendor == PCI_VENDOR_ID_CB &&
+	    pcidev->device == PCI_DEVICE_ID_CB_PCIDIO48H &&
+	    pci_resource_len(pcidev, 2))
+		dio_badr = 2;
+
+	iobase = pci_resource_start(pcidev, dio_badr);
+	len = pci_resource_len(pcidev, dio_badr);
 
 	if (board->is_mmio) {
 		devpriv->mmio_base = ioremap(iobase, len);
-- 
1.8.3.2

