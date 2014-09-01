Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbaIALKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:10:51 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39012 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbaIALEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:20 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/28] staging: comedi: amplc_pci230: absorb pci230_attach_common()
Date: Mon,  1 Sep 2014 12:03:40 +0100
Message-Id: <1409569440-10979-9-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`pci230_attach_common()` is now only called from `pci230_auto_attach()`,
so absorb it into that function.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 48 ++++++++++++---------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 35d7f0c..46977e5 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2557,15 +2557,31 @@ static int pci230_alloc_private(struct comedi_device *dev)
 	return 0;
 }
 
-/* Common part of attach and auto_attach. */
-static int pci230_attach_common(struct comedi_device *dev,
-				struct pci_dev *pci_dev)
+static int pci230_auto_attach(struct comedi_device *dev,
+			      unsigned long context_unused)
 {
-	const struct pci230_board *thisboard = comedi_board(dev);
-	struct pci230_private *devpriv = dev->private;
+	struct pci_dev *pci_dev = comedi_to_pci_dev(dev);
+	const struct pci230_board *thisboard;
+	struct pci230_private *devpriv;
 	struct comedi_subdevice *s;
 	int rc;
 
+	dev_info(dev->class_dev, "amplc_pci230: attach pci %s\n",
+		 pci_name(pci_dev));
+
+	rc = pci230_alloc_private(dev);
+	if (rc)
+		return rc;
+
+	dev->board_ptr = pci230_find_pci_board(pci_dev);
+	if (dev->board_ptr == NULL) {
+		dev_err(dev->class_dev,
+			"amplc_pci230: BUG! cannot determine board type!\n");
+		return -EINVAL;
+	}
+	thisboard = comedi_board(dev);
+	devpriv = dev->private;
+
 	comedi_set_hw_dev(dev, &pci_dev->dev);
 
 	dev->board_name = thisboard->name;
@@ -2710,28 +2726,6 @@ static int pci230_attach_common(struct comedi_device *dev,
 	return 0;
 }
 
-static int pci230_auto_attach(struct comedi_device *dev,
-			      unsigned long context_unused)
-{
-	struct pci_dev *pci_dev = comedi_to_pci_dev(dev);
-	int rc;
-
-	dev_info(dev->class_dev, "amplc_pci230: attach pci %s\n",
-		 pci_name(pci_dev));
-
-	rc = pci230_alloc_private(dev);
-	if (rc)
-		return rc;
-
-	dev->board_ptr = pci230_find_pci_board(pci_dev);
-	if (dev->board_ptr == NULL) {
-		dev_err(dev->class_dev,
-			"amplc_pci230: BUG! cannot determine board type!\n");
-		return -EINVAL;
-	}
-	return pci230_attach_common(dev, pci_dev);
-}
-
 static struct comedi_driver amplc_pci230_driver = {
 	.driver_name	= "amplc_pci230",
 	.module		= THIS_MODULE,
-- 
2.0.4

