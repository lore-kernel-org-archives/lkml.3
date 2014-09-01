Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaIALKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:10:30 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38999 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbaIALEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:20 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/28] staging: comedi: amplc_pci230: no need to manipulate PCI ref count
Date: Mon,  1 Sep 2014 12:03:38 +0100
Message-Id: <1409569440-10979-7-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver no longer supports a "legacy" attach mechanism that searches
for a suitable PCI device and increments it's reference count, but since
the common "detach" handler `pci230_detach()` still has a left-over
`pci_dev_put()`, a matching `pci_dev_get()` is needed in the
"auto_attach" handler `pci230_auto_attach()`.  There is no longer any
reason to "get" and "put" the PCI device, so those calls can be removed.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 393712c..39fa2f6 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2729,23 +2729,12 @@ static int pci230_auto_attach(struct comedi_device *dev,
 			"amplc_pci230: BUG! cannot determine board type!\n");
 		return -EINVAL;
 	}
-	/*
-	 * Need to 'get' the PCI device to match the 'put' in pci230_detach().
-	 * TODO: Remove the pci_dev_get() and matching pci_dev_put() once
-	 * support for manual attachment of PCI devices via pci230_attach()
-	 * has been removed.
-	 */
-	pci_dev_get(pci_dev);
 	return pci230_attach_common(dev, pci_dev);
 }
 
 static void pci230_detach(struct comedi_device *dev)
 {
-	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
-
 	comedi_pci_detach(dev);
-	if (pcidev)
-		pci_dev_put(pcidev);
 }
 
 static struct comedi_driver amplc_pci230_driver = {
-- 
2.0.4

