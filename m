Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760213AbaGYJKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:10:55 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:41137 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbaGYJFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:05:18 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] staging: comedi: amplc_pc236: no need to manipulate PCI ref count
Date: Fri, 25 Jul 2014 10:04:50 +0100
Message-Id: <1406279098-8498-5-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
References: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that this driver no longer supports "manual" attachment of PCI
devices in its `attach` hook (`pc236_attach()`), it no longer has code
that searches for a suitable PCI device and increments its reference
count.  Since the driver no longer has any reason for incrementing and
decrementing the PCI device's reference count, the calls to
`pci_dev_get()` and `pci_dev_put()` can be removed.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pc236.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 7331ae3..cf45c58 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -417,13 +417,6 @@ static int pc236_auto_attach(struct comedi_device *dev,
 		dev_err(dev->class_dev, "BUG! cannot determine board type!\n");
 		return -EINVAL;
 	}
-	/*
-	 * Need to 'get' the PCI device to match the 'put' in pc236_detach().
-	 * TODO: Remove the pci_dev_get() and matching pci_dev_put() once
-	 * support for manual attachment of PCI devices via pc236_attach()
-	 * has been removed.
-	 */
-	pci_dev_get(pci_dev);
 	return pc236_pci_common_attach(dev, pci_dev);
 }
 
@@ -438,13 +431,9 @@ static void pc236_detach(struct comedi_device *dev)
 	if (is_isa_board(thisboard)) {
 		comedi_legacy_detach(dev);
 	} else if (is_pci_board(thisboard)) {
-		struct pci_dev *pcidev = comedi_to_pci_dev(dev);
-
 		if (dev->irq)
 			free_irq(dev->irq, dev);
 		comedi_pci_disable(dev);
-		if (pcidev)
-			pci_dev_put(pcidev);
 	}
 }
 
-- 
2.0.0

