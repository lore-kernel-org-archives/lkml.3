Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaGaNta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:49:30 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57913 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbaGaNsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:15 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/18] staging: comedi: amplc_pci224: put board indices in PCI driver_data
Date: Thu, 31 Jul 2014 14:47:52 +0100
Message-Id: <1406814475-5923-16-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `driver_data` member value from the matched entry of the PCI module
device table `amplc_pci224_pci_table[]` is passed through to our comedi
"auto_attach" handler, `pci224_auto_attach()`.  Use that to index
directly into our static board data array `pci224_boards[]` instead of
calling `pci224_find_pci_board()` to search for the entry matching the
PCI device ID.  That function can be removed.  The `devid` and `model`
members of `struct pci224_board` are no longer needed either and can be
removed.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 52 ++++++++++-----------------
 1 file changed, 18 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index bcef9e6..977894d 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -351,8 +351,6 @@ enum pci224_model { pci224_model, pci234_model };
 
 struct pci224_board {
 	const char *name;
-	unsigned short devid;
-	enum pci224_model model;
 	unsigned int ao_chans;
 	unsigned int ao_bits;
 	const struct comedi_lrange *ao_range;
@@ -361,20 +359,16 @@ struct pci224_board {
 };
 
 static const struct pci224_board pci224_boards[] = {
-	{
+	[pci224_model] {
 		.name		= "pci224",
-		.devid		= PCI_DEVICE_ID_AMPLICON_PCI224,
-		.model		= pci224_model,
 		.ao_chans	= 16,
 		.ao_bits	= 12,
 		.ao_range	= &range_pci224,
 		.ao_hwrange	= &hwrange_pci224[0],
 		.ao_range_check	= &range_check_pci224[0],
 	},
-	{
+	[pci234_model] {
 		.name		= "pci234",
-		.devid		= PCI_DEVICE_ID_AMPLICON_PCI234,
-		.model		= pci234_model,
 		.ao_chans	= 4,
 		.ao_bits	= 16,
 		.ao_range	= &range_pci234,
@@ -1071,20 +1065,6 @@ static irqreturn_t pci224_interrupt(int irq, void *d)
 }
 
 /*
- * This function looks for a board matching the supplied PCI device.
- */
-static const struct pci224_board
-*pci224_find_pci_board(struct pci_dev *pci_dev)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(pci224_boards); i++)
-		if (pci_dev->device == pci224_boards[i].devid)
-			return &pci224_boards[i];
-	return NULL;
-}
-
-/*
  * Common part of attach and auto_attach.
  */
 static int pci224_attach_common(struct comedi_device *dev,
@@ -1162,8 +1142,6 @@ static int pci224_attach_common(struct comedi_device *dev,
 	s->cancel = pci224_ao_cancel;
 	s->munge = pci224_ao_munge;
 
-	dev->board_name = thisboard->name;
-
 	if (irq) {
 		ret = request_irq(irq, pci224_interrupt, IRQF_SHARED,
 				  dev->board_name, dev);
@@ -1179,23 +1157,29 @@ static int pci224_attach_common(struct comedi_device *dev,
 }
 
 static int
-pci224_auto_attach(struct comedi_device *dev, unsigned long context_unused)
+pci224_auto_attach(struct comedi_device *dev, unsigned long context_model)
 {
 	struct pci_dev *pci_dev = comedi_to_pci_dev(dev);
+	const struct pci224_board *thisboard = NULL;
 	struct pci224_private *devpriv;
 
-	dev_info(dev->class_dev, "attach pci %s\n", pci_name(pci_dev));
+	if (context_model < ARRAY_SIZE(pci224_boards))
+		thisboard = &pci224_boards[context_model];
+	if (!thisboard || !thisboard->name) {
+		dev_err(dev->class_dev,
+			"amplc_pci224: BUG! cannot determine board type!\n");
+		return -EINVAL;
+	}
+	dev->board_ptr = thisboard;
+	dev->board_name = thisboard->name;
+
+	dev_info(dev->class_dev, "amplc_pci224: attach pci %s - %s\n",
+		 pci_name(pci_dev), dev->board_name);
 
 	devpriv = comedi_alloc_devpriv(dev, sizeof(*devpriv));
 	if (!devpriv)
 		return -ENOMEM;
 
-	dev->board_ptr = pci224_find_pci_board(pci_dev);
-	if (dev->board_ptr == NULL) {
-		dev_err(dev->class_dev,
-			"BUG! cannot determine board type!\n");
-		return -EINVAL;
-	}
 	return pci224_attach_common(dev, pci_dev);
 }
 
@@ -1231,8 +1215,8 @@ static int amplc_pci224_pci_probe(struct pci_dev *dev,
 }
 
 static const struct pci_device_id amplc_pci224_pci_table[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI224) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI234) },
+	{ PCI_VDEVICE(AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI224), pci224_model },
+	{ PCI_VDEVICE(AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI234), pci234_model },
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, amplc_pci224_pci_table);
-- 
2.0.0

