Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaGaNsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:48:50 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57921 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbaGaNsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:16 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/18] staging: comedi: amplc_pci224: absorb pci224_attach_common()
Date: Thu, 31 Jul 2014 14:47:54 +0100
Message-Id: <1406814475-5923-18-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`pci224_attach_common()` is now only called from `pci225_auto_attach()`,
so absorb it into that function.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 56 +++++++++++----------------
 1 file changed, 22 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 4fceb7c..4b45319 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1057,18 +1057,33 @@ static irqreturn_t pci224_interrupt(int irq, void *d)
 	return IRQ_RETVAL(retval);
 }
 
-/*
- * Common part of attach and auto_attach.
- */
-static int pci224_attach_common(struct comedi_device *dev,
-				struct pci_dev *pci_dev)
+static int
+pci224_auto_attach(struct comedi_device *dev, unsigned long context_model)
 {
-	const struct pci224_board *thisboard = comedi_board(dev);
-	struct pci224_private *devpriv = dev->private;
+	struct pci_dev *pci_dev = comedi_to_pci_dev(dev);
+	const struct pci224_board *thisboard = NULL;
+	struct pci224_private *devpriv;
 	struct comedi_subdevice *s;
 	unsigned int irq;
 	int ret;
 
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
+
+	devpriv = comedi_alloc_devpriv(dev, sizeof(*devpriv));
+	if (!devpriv)
+		return -ENOMEM;
+
 	comedi_set_hw_dev(dev, &pci_dev->dev);
 
 	ret = comedi_pci_enable(dev);
@@ -1149,33 +1164,6 @@ static int pci224_attach_common(struct comedi_device *dev,
 	return 0;
 }
 
-static int
-pci224_auto_attach(struct comedi_device *dev, unsigned long context_model)
-{
-	struct pci_dev *pci_dev = comedi_to_pci_dev(dev);
-	const struct pci224_board *thisboard = NULL;
-	struct pci224_private *devpriv;
-
-	if (context_model < ARRAY_SIZE(pci224_boards))
-		thisboard = &pci224_boards[context_model];
-	if (!thisboard || !thisboard->name) {
-		dev_err(dev->class_dev,
-			"amplc_pci224: BUG! cannot determine board type!\n");
-		return -EINVAL;
-	}
-	dev->board_ptr = thisboard;
-	dev->board_name = thisboard->name;
-
-	dev_info(dev->class_dev, "amplc_pci224: attach pci %s - %s\n",
-		 pci_name(pci_dev), dev->board_name);
-
-	devpriv = comedi_alloc_devpriv(dev, sizeof(*devpriv));
-	if (!devpriv)
-		return -ENOMEM;
-
-	return pci224_attach_common(dev, pci_dev);
-}
-
 static void pci224_detach(struct comedi_device *dev)
 {
 	struct pci224_private *devpriv = dev->private;
-- 
2.0.0

