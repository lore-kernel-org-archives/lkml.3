Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaIALJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:09:18 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39018 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbaIALEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:21 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/28] staging: comedi: amplc_pci230: absorb pci230_alloc_private()
Date: Mon,  1 Sep 2014 12:03:42 +0100
Message-Id: <1409569440-10979-11-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`pci230_alloc_private()` is now only called from `pci230_auto_attach()`
to allocate private device storage and initialize various spin-lock
members therein.  Absorb the body of `pci230_alloc_private()` into
`pci230_auto_attach()` itself.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 28 ++++++++-------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index bd2e648..794e0ca 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2542,21 +2542,6 @@ static const struct pci230_board *pci230_find_pci_board(struct pci_dev *pci_dev)
 	return NULL;
 }
 
-static int pci230_alloc_private(struct comedi_device *dev)
-{
-	struct pci230_private *devpriv;
-
-	devpriv = comedi_alloc_devpriv(dev, sizeof(*devpriv));
-	if (!devpriv)
-		return -ENOMEM;
-
-	spin_lock_init(&devpriv->isr_spinlock);
-	spin_lock_init(&devpriv->res_spinlock);
-	spin_lock_init(&devpriv->ai_stop_spinlock);
-	spin_lock_init(&devpriv->ao_stop_spinlock);
-	return 0;
-}
-
 static int pci230_auto_attach(struct comedi_device *dev,
 			      unsigned long context_unused)
 {
@@ -2569,9 +2554,14 @@ static int pci230_auto_attach(struct comedi_device *dev,
 	dev_info(dev->class_dev, "amplc_pci230: attach pci %s\n",
 		 pci_name(pci_dev));
 
-	rc = pci230_alloc_private(dev);
-	if (rc)
-		return rc;
+	devpriv = comedi_alloc_devpriv(dev, sizeof(*devpriv));
+	if (!devpriv)
+		return -ENOMEM;
+
+	spin_lock_init(&devpriv->isr_spinlock);
+	spin_lock_init(&devpriv->res_spinlock);
+	spin_lock_init(&devpriv->ai_stop_spinlock);
+	spin_lock_init(&devpriv->ao_stop_spinlock);
 
 	dev->board_ptr = pci230_find_pci_board(pci_dev);
 	if (dev->board_ptr == NULL) {
@@ -2580,8 +2570,6 @@ static int pci230_auto_attach(struct comedi_device *dev,
 		return -EINVAL;
 	}
 	thisboard = comedi_board(dev);
-	devpriv = dev->private;
-
 	dev->board_name = thisboard->name;
 
 	rc = comedi_pci_enable(dev);
-- 
2.0.4

