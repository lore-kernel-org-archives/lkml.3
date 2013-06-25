Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab3FYSdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:33:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab3FYSdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>
Subject: [ 25/95] parisc: parport0: fix this legacy no-device port driver!
Date: Tue, 25 Jun 2013 11:32:12 -0700
Message-Id: <20130625182156.494533371@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 4edb38695d9a3cd62739f8595e21f36f0aabf4c2 upstream.

Fix the above kernel error from parport_announce_port() on 32bit GSC
machines (e.g. B160L). The parport driver requires now a pointer to the
device struct.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/parport/parport_gsc.c |    6 +++---
 drivers/parport/parport_gsc.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/parport/parport_gsc.c
+++ b/drivers/parport/parport_gsc.c
@@ -234,7 +234,7 @@ static int parport_PS2_supported(struct
 
 struct parport *parport_gsc_probe_port(unsigned long base,
 				       unsigned long base_hi, int irq,
-				       int dma, struct pci_dev *dev)
+				       int dma, struct parisc_device *padev)
 {
 	struct parport_gsc_private *priv;
 	struct parport_operations *ops;
@@ -258,7 +258,6 @@ struct parport *parport_gsc_probe_port(u
 	priv->ctr_writable = 0xff;
 	priv->dma_buf = 0;
 	priv->dma_handle = 0;
-	priv->dev = dev;
 	p->base = base;
 	p->base_hi = base_hi;
 	p->irq = irq;
@@ -282,6 +281,7 @@ struct parport *parport_gsc_probe_port(u
 		return NULL;
 	}
 
+	p->dev = &padev->dev;
 	p->base_hi = base_hi;
 	p->modes = tmp.modes;
 	p->size = (p->modes & PARPORT_MODE_EPP)?8:3;
@@ -373,7 +373,7 @@ static int parport_init_chip(struct pari
 	}
 	
 	p = parport_gsc_probe_port(port, 0, dev->irq,
-			/* PARPORT_IRQ_NONE */ PARPORT_DMA_NONE, NULL);
+			/* PARPORT_IRQ_NONE */ PARPORT_DMA_NONE, dev);
 	if (p)
 		parport_count++;
 	dev_set_drvdata(&dev->dev, p);
--- a/drivers/parport/parport_gsc.h
+++ b/drivers/parport/parport_gsc.h
@@ -217,6 +217,6 @@ extern void parport_gsc_dec_use_count(vo
 extern struct parport *parport_gsc_probe_port(unsigned long base,
 						unsigned long base_hi,
 						int irq, int dma,
-						struct pci_dev *dev);
+						struct parisc_device *padev);
 
 #endif	/* __DRIVERS_PARPORT_PARPORT_GSC_H */


