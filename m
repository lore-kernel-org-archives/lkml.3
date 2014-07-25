Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbaGYJK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:10:57 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:41130 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759874AbaGYJFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:05:17 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] staging: comedi: amplc_pc236: remove manual configuration of PCI boards
Date: Fri, 25 Jul 2014 10:04:49 +0100
Message-Id: <1406279098-8498-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
References: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the code that allows PCI boards to be manually attached by the
`COMEDI_DEVCONFIG` ioctl (or the "comedi_config" application).
Supported PCI boards (PCI236) will be attached automatically at probe
time via `comedi_pci_auto_config()` and the `auto_attach` hook in the
`struct comedi_driver`.

The "wildcard" entry in `pc236_boards[]` was only used when manually
attaching a PCI board using a driver name instead of a board name, so is
no longer needed.  Remove it.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pc236.c | 72 ++++------------------------
 1 file changed, 9 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 7600319..7331ae3 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -21,19 +21,16 @@
  * Driver: amplc_pc236
  * Description: Amplicon PC36AT, PCI236
  * Author: Ian Abbott <abbotti@mev.co.uk>
- * Devices: [Amplicon] PC36AT (pc36at), PCI236 (pci236 or amplc_pc236)
- * Updated: Wed, 01 Apr 2009 15:41:25 +0100
+ * Devices: [Amplicon] PC36AT (pc36at), PCI236 (pci236)
+ * Updated: Thu, 24 Jul 2014 14:25:26 +0000
  * Status: works
  *
  * Configuration options - PC36AT:
  *   [0] - I/O port base address
  *   [1] - IRQ (optional)
  *
- * Configuration options - PCI236:
- *   [0] - PCI bus of device (optional)
- *   [1] - PCI slot of device (optional)
- *   If bus/slot is not specified, the first available PCI device will be
- *   used.
+ * Manual configuration of PCI board (PCI236) is not supported; it is
+ * configured automatically.
  *
  * The PC36AT ISA board and PCI236 PCI board have a single 8255 appearing
  * as subdevice 0.
@@ -85,7 +82,7 @@
  */
 
 enum pc236_bustype { isa_bustype, pci_bustype };
-enum pc236_model { pc36at_model, pci236_model, anypci_model };
+enum pc236_model { pc36at_model, pci236_model };
 
 struct pc236_board {
 	const char *name;
@@ -108,12 +105,6 @@ static const struct pc236_board pc236_boards[] = {
 		.bustype = pci_bustype,
 		.model = pci236_model,
 	},
-	{
-		.name = "amplc_pc236",
-		.devid = PCI_DEVICE_ID_INVALID,
-		.bustype = pci_bustype,
-		.model = anypci_model,	/* wildcard */
-	},
 #endif
 };
 
@@ -149,49 +140,6 @@ static const struct pc236_board *pc236_find_pci_board(struct pci_dev *pci_dev)
 }
 
 /*
- * This function looks for a PCI device matching the requested board name,
- * bus and slot.
- */
-static struct pci_dev *pc236_find_pci_dev(struct comedi_device *dev,
-					  struct comedi_devconfig *it)
-{
-	const struct pc236_board *thisboard = comedi_board(dev);
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
-		if (thisboard->model == anypci_model) {
-			/* Wildcard board matches any supported PCI board. */
-			const struct pc236_board *foundboard;
-
-			foundboard = pc236_find_pci_board(pci_dev);
-			if (foundboard == NULL)
-				continue;
-			/* Replace wildcard board_ptr. */
-			dev->board_ptr = foundboard;
-		} else {
-			/* Match specific model name. */
-			if (pci_dev->device != thisboard->devid)
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
  * This function is called to mark the interrupt as disabled (no command
  * configured on subdevice 1) and to physically disable the interrupt
  * (not possible on the PC36AT, except by removing the IRQ jumper!).
@@ -439,12 +387,10 @@ static int pc236_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 		return pc236_common_attach(dev, dev->iobase, it->options[1], 0);
 	} else if (is_pci_board(thisboard)) {
-		struct pci_dev *pci_dev;
-
-		pci_dev = pc236_find_pci_dev(dev, it);
-		if (!pci_dev)
-			return -EIO;
-		return pc236_pci_common_attach(dev, pci_dev);
+		dev_err(dev->class_dev,
+			"Manual configuration of PCI board '%s' is not supported\n",
+			thisboard->name);
+		return -EIO;
 	}
 
 	dev_err(dev->class_dev, "BUG! cannot determine board type!\n");
-- 
2.0.0

