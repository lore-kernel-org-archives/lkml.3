Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaIALEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:04:22 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39003 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbaIALET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:19 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/28] staging: comedi: amplc_pci230: remove "legacy" attach mechanism
Date: Mon,  1 Sep 2014 12:03:37 +0100
Message-Id: <1409569440-10979-6-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "amplc_pci230" driver currently retains the legacy attach mechanism
to allow devices to be attached manually via the `COMEDI_DEVCONFIG`
ioctl.  The only real use for this is to pretend that a PCI230+ or
PCI260+ is a PCI230 or PCI260 for backwards compatibility, as they have
different number of bits of resolution on the AI subdevice.  Since the
card would be automatically configured as a PCI230+ or PCI260+ at PCI
probe time anyway, hopefully any users who want it to appear as a PCI230
or PCI260 would have got tired of removing the automatically configured
device and configuring it manually by now and will have updated their
software to cope with the PCI230+ or PCI260+.

Get rid of the legacy attach mechanism by removing the Comedi driver
"attach" handler `pci230_attach()` and associated code.  Also remove the
"wildcard" entry from the board table `pci230_boards[]` as it is no
longer needed.  Don't bother initializing the `board_name`, `offset`,
and `num_names` members of `struct comedi_driver amplc_pci230_driver`
any longer as they are only needed when configuring the device manually.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 92 +++------------------------
 1 file changed, 9 insertions(+), 83 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 56141de..393712c 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -24,24 +24,19 @@
  * Author: Allan Willcox <allanwillcox@ozemail.com.au>,
  *   Steve D Sharples <steve.sharples@nottingham.ac.uk>,
  *   Ian Abbott <abbotti@mev.co.uk>
- * Updated: Wed, 22 Oct 2008 12:34:49 +0100
- * Devices: [Amplicon] PCI230 (pci230 or amplc_pci230),
- *   PCI230+ (pci230+ or amplc_pci230),
- *   PCI260 (pci260 or amplc_pci230), PCI260+ (pci260+ or amplc_pci230)
+ * Updated: Mon, 01 Sep 2014 10:09:16 +0000
+ * Devices: [Amplicon] PCI230 (amplc_pci230), PCI230+, PCI260, PCI260+
  * Status: works
  *
  * Configuration options:
- *   [0] - PCI bus of device (optional).
- *   [1] - PCI slot of device (optional).
- *           If bus/slot is not specified, the first available PCI device
- *           will be used.
+ *   none
  *
- * Configuring a "amplc_pci230" will match any supported card and it will
- * choose the best match, picking the "+" models if possible.  Configuring
- * a "pci230" will match a PCI230 or PCI230+ card and it will be treated as
- * a PCI230.  Configuring a "pci260" will match a PCI260 or PCI260+ card
- * and it will be treated as a PCI260.  Configuring a "pci230+" will match
- * a PCI230+ card.  Configuring a "pci260+" will match a PCI260+ card.
+ * Manual configuration of PCI cards is not supported; they are configured
+ * automatically.
+ *
+ * The PCI230+ and PCI260+ have the same PCI device IDs as the PCI230 and
+ * PCI260, but can be distinguished by the the size of the PCI regions.  A
+ * card will be configured as a "+" model if detected as such.
  *
  * Subdevices:
  *
@@ -201,7 +196,6 @@
  */
 #define PCI_DEVICE_ID_PCI230 0x0000
 #define PCI_DEVICE_ID_PCI260 0x0006
-#define PCI_DEVICE_ID_INVALID 0xffff
 
 /*
  * PCI230 i/o space 1 registers.
@@ -501,11 +495,6 @@ static const struct pci230_board pci230_boards[] = {
 		.ai_chans	= 16,
 		.ai_bits	= 12,
 	},
-	{
-		/* Wildcard matches any above */
-		.name		= "amplc_pci230",
-		.id		= PCI_DEVICE_ID_INVALID,
-	},
 };
 
 struct pci230_private {
@@ -2553,46 +2542,6 @@ static const struct pci230_board *pci230_find_pci_board(struct pci_dev *pci_dev)
 	return NULL;
 }
 
-/* Look for PCI device matching requested board name, bus and slot. */
-static struct pci_dev *pci230_find_pci_dev(struct comedi_device *dev,
-					   struct comedi_devconfig *it)
-{
-	const struct pci230_board *thisboard = comedi_board(dev);
-	struct pci_dev *pci_dev = NULL;
-	int bus = it->options[0];
-	int slot = it->options[1];
-
-	for_each_pci_dev(pci_dev) {
-		/* Check vendor ID (same for all supported PCI boards). */
-		if (pci_dev->vendor != PCI_VENDOR_ID_AMPLICON)
-			continue;
-		/* If bus/slot specified, check them. */
-		if ((bus || slot) &&
-		    (bus != pci_dev->bus->number ||
-		     slot != PCI_SLOT(pci_dev->devfn)))
-			continue;
-		if (thisboard->id == PCI_DEVICE_ID_INVALID) {
-			/* Wildcard board matches any supported PCI board. */
-			const struct pci230_board *foundboard;
-
-			foundboard = pci230_find_pci_board(pci_dev);
-			if (foundboard == NULL)
-				continue;
-			/* Replace wildcard board_ptr. */
-			dev->board_ptr = foundboard;
-		} else {
-			/* Need to match a specific board. */
-			if (!pci230_match_pci_board(thisboard, pci_dev))
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
 static int pci230_alloc_private(struct comedi_device *dev)
 {
 	struct pci230_private *devpriv;
@@ -2761,25 +2710,6 @@ static int pci230_attach_common(struct comedi_device *dev,
 	return 0;
 }
 
-static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
-{
-	const struct pci230_board *thisboard = comedi_board(dev);
-	struct pci_dev *pci_dev;
-	int rc;
-
-	dev_info(dev->class_dev, "amplc_pci230: attach %s %d,%d\n",
-		 thisboard->name, it->options[0], it->options[1]);
-
-	rc = pci230_alloc_private(dev);
-	if (rc)
-		return rc;
-
-	pci_dev = pci230_find_pci_dev(dev, it);
-	if (!pci_dev)
-		return -EIO;
-	return pci230_attach_common(dev, pci_dev);
-}
-
 static int pci230_auto_attach(struct comedi_device *dev,
 			      unsigned long context_unused)
 {
@@ -2821,12 +2751,8 @@ static void pci230_detach(struct comedi_device *dev)
 static struct comedi_driver amplc_pci230_driver = {
 	.driver_name	= "amplc_pci230",
 	.module		= THIS_MODULE,
-	.attach		= pci230_attach,
 	.auto_attach	= pci230_auto_attach,
 	.detach		= pci230_detach,
-	.board_name	= &pci230_boards[0].name,
-	.offset		= sizeof(pci230_boards[0]),
-	.num_names	= ARRAY_SIZE(pci230_boards),
 };
 
 static int amplc_pci230_pci_probe(struct pci_dev *dev,
-- 
2.0.4

