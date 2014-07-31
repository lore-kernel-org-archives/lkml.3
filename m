Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaGaNtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:49:45 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57901 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbaGaNsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:14 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/18] staging: comedi: amplc_pci224: no need to manipulate PCI ref count
Date: Thu, 31 Jul 2014 14:47:51 +0100
Message-Id: <1406814475-5923-15-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver no longer supports a "legacy" attach mechanism that searches
for a suitable PCI device and increments it's reference count, but since
the common "detach" handler `pci224_detach()` still has a left-over
`pci_dev_put()`, a matching `pci_dev_get()` is needed in the
"auto_attach" handler `pci224_auto_attach()`.  There is no longer any
reason to "get" and "put" the PCI device, so those calls can be removed.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 0bf5e68..bcef9e6 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1196,20 +1196,12 @@ pci224_auto_attach(struct comedi_device *dev, unsigned long context_unused)
 			"BUG! cannot determine board type!\n");
 		return -EINVAL;
 	}
-	/*
-	 * Need to 'get' the PCI device to match the 'put' in pci224_detach().
-	 * TODO: Remove the pci_dev_get() and matching pci_dev_put() once
-	 * support for manual attachment of PCI devices via pci224_attach()
-	 * has been removed.
-	 */
-	pci_dev_get(pci_dev);
 	return pci224_attach_common(dev, pci_dev);
 }
 
 static void pci224_detach(struct comedi_device *dev)
 {
 	struct pci224_private *devpriv = dev->private;
-	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 
 	if (dev->irq)
 		free_irq(dev->irq, dev);
@@ -1219,8 +1211,6 @@ static void pci224_detach(struct comedi_device *dev)
 		kfree(devpriv->ao_scan_order);
 	}
 	comedi_pci_disable(dev);
-	if (pcidev)
-		pci_dev_put(pcidev);
 }
 
 static struct comedi_driver amplc_pci224_driver = {
-- 
2.0.0

