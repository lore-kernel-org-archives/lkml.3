Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaGaNtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:49:46 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57899 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbaGaNsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:14 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/18] staging: comedi: amplc_pci224: remove "legacy" attach mechanism
Date: Thu, 31 Jul 2014 14:47:50 +0100
Message-Id: <1406814475-5923-14-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the driver no longer supports options in its "legacy" attach
mechanism to describe the jumper settings (or any options beyond
restricting a PCI search to a particular bus and/or slot), there is no
need to retain this mechanism in the driver.  Remove the comedi driver
"attach" handler `pci224_attach()`, and the now unused
`pci224_find_pci_dev()`.  Also, remove the "wildcard" entry from the
board table `pci224_boards[]` as it is no longer needed.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 82 ++-------------------------
 1 file changed, 6 insertions(+), 76 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index fba0198..0bf5e68 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -22,9 +22,8 @@
  * Driver: amplc_pci224
  * Description: Amplicon PCI224, PCI234
  * Author: Ian Abbott <abbotti@mev.co.uk>
- * Devices: [Amplicon] PCI224 (amplc_pci224 or pci224),
- *   PCI234 (amplc_pci224 or pci234)
- * Updated: Wed, 30 Jul 2014 18:08:43 +0000
+ * Devices: [Amplicon] PCI224 (amplc_pci224), PCI234
+ * Updated: Thu, 31 Jul 2014 11:08:03 +0000
  * Status: works, but see caveats
  *
  * Supports:
@@ -46,12 +45,10 @@
  *     scan_begin_src or stop_src may use TRIG_EXT.
  *
  * Configuration options:
- *   [0] - PCI bus of device (optional).
- *   [1] - PCI slot of device (optional).
- *           If bus/slot is not specified, the first available PCI device
- *           will be used.
+ *   none
  *
- * Passing a zero for an option is the same as leaving it unspecified.
+ * Manual configuration of PCI cards is not supported; they are configured
+ * automatically.
  *
  * Output range selection - PCI224:
  *
@@ -350,7 +347,7 @@ static const unsigned char range_check_pci234[4] = {
  * Board descriptions.
  */
 
-enum pci224_model { any_model, pci224_model, pci234_model };
+enum pci224_model { pci224_model, pci234_model };
 
 struct pci224_board {
 	const char *name;
@@ -384,11 +381,6 @@ static const struct pci224_board pci224_boards[] = {
 		.ao_hwrange	= &hwrange_pci234[0],
 		.ao_range_check	= &range_check_pci234[0],
 	},
-	{
-		.name		= "amplc_pci224",
-		.devid		= PCI_DEVICE_ID_INVALID,
-		.model		= any_model,	/* wildcard */
-	},
 };
 
 struct pci224_private {
@@ -1093,49 +1085,6 @@ static const struct pci224_board
 }
 
 /*
- * This function looks for a PCI device matching the requested board name,
- * bus and slot.
- */
-static struct pci_dev *pci224_find_pci_dev(struct comedi_device *dev,
-					   struct comedi_devconfig *it)
-{
-	const struct pci224_board *thisboard = comedi_board(dev);
-	struct pci_dev *pci_dev = NULL;
-	int bus = it->options[0];
-	int slot = it->options[1];
-
-	for_each_pci_dev(pci_dev) {
-		if (bus || slot) {
-			if (bus != pci_dev->bus->number ||
-			    slot != PCI_SLOT(pci_dev->devfn))
-				continue;
-		}
-		if (pci_dev->vendor != PCI_VENDOR_ID_AMPLICON)
-			continue;
-
-		if (thisboard->model == any_model) {
-			/* Match any supported model. */
-			const struct pci224_board *board_ptr;
-
-			board_ptr = pci224_find_pci_board(pci_dev);
-			if (board_ptr == NULL)
-				continue;
-			/* Change board_ptr to matched board. */
-			dev->board_ptr = board_ptr;
-		} else {
-			/* Match specific model name. */
-			if (thisboard->devid != pci_dev->device)
-				continue;
-		}
-		return pci_dev;
-	}
-	dev_err(dev->class_dev,
-		"No supported board found! (req. bus %d, slot %d)\n",
-		bus, slot);
-	return NULL;
-}
-
-/*
  * Common part of attach and auto_attach.
  */
 static int pci224_attach_common(struct comedi_device *dev,
@@ -1229,24 +1178,6 @@ static int pci224_attach_common(struct comedi_device *dev,
 	return 0;
 }
 
-static int pci224_attach(struct comedi_device *dev, struct comedi_devconfig *it)
-{
-	struct pci224_private *devpriv;
-	struct pci_dev *pci_dev;
-
-	dev_info(dev->class_dev, "attach\n");
-
-	devpriv = comedi_alloc_devpriv(dev, sizeof(*devpriv));
-	if (!devpriv)
-		return -ENOMEM;
-
-	pci_dev = pci224_find_pci_dev(dev, it);
-	if (!pci_dev)
-		return -EIO;
-
-	return pci224_attach_common(dev, pci_dev);
-}
-
 static int
 pci224_auto_attach(struct comedi_device *dev, unsigned long context_unused)
 {
@@ -1295,7 +1226,6 @@ static void pci224_detach(struct comedi_device *dev)
 static struct comedi_driver amplc_pci224_driver = {
 	.driver_name	= "amplc_pci224",
 	.module		= THIS_MODULE,
-	.attach		= pci224_attach,
 	.detach		= pci224_detach,
 	.auto_attach	= pci224_auto_attach,
 	.board_name	= &pci224_boards[0].name,
-- 
2.0.0

