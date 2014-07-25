Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174AbaGYJI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:08:58 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:41152 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760009AbaGYJFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:05:19 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] staging: comedi: amplc_pc236: absorb pc236_pci_common_attach()
Date: Fri, 25 Jul 2014 10:04:52 +0100
Message-Id: <1406279098-8498-7-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
References: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Absorb `pc236_pci_common_attach()` into `pc236_auto_attach()` since
that's the only place it is called from.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pc236.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index f99c7f1..22d3b6f 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -351,22 +351,6 @@ static int pc236_common_attach(struct comedi_device *dev, unsigned long iobase,
 	return 0;
 }
 
-static int pc236_pci_common_attach(struct comedi_device *dev,
-				   struct pci_dev *pci_dev)
-{
-	struct pc236_private *devpriv = dev->private;
-	unsigned long iobase;
-	int ret;
-
-	ret = comedi_pci_enable(dev);
-	if (ret)
-		return ret;
-
-	devpriv->lcr_iobase = pci_resource_start(pci_dev, 1);
-	iobase = pci_resource_start(pci_dev, 2);
-	return pc236_common_attach(dev, iobase, pci_dev->irq, IRQF_SHARED);
-}
-
 static int pc236_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct pc236_board *thisboard = comedi_board(dev);
@@ -400,6 +384,8 @@ static int pc236_auto_attach(struct comedi_device *dev,
 {
 	struct pci_dev *pci_dev = comedi_to_pci_dev(dev);
 	struct pc236_private *devpriv;
+	unsigned long iobase;
+	int ret;
 
 	if (!DO_PCI)
 		return -EINVAL;
@@ -415,7 +401,13 @@ static int pc236_auto_attach(struct comedi_device *dev,
 		dev_err(dev->class_dev, "BUG! cannot determine board type!\n");
 		return -EINVAL;
 	}
-	return pc236_pci_common_attach(dev, pci_dev);
+	ret = comedi_pci_enable(dev);
+	if (ret)
+		return ret;
+
+	devpriv->lcr_iobase = pci_resource_start(pci_dev, 1);
+	iobase = pci_resource_start(pci_dev, 2);
+	return pc236_common_attach(dev, iobase, pci_dev->irq, IRQF_SHARED);
 }
 
 static void pc236_detach(struct comedi_device *dev)
-- 
2.0.0

