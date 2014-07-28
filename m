Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaG1MJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:09:54 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49017 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbaG1MJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:09:47 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] staging: comedi: amplc_pc236: add callback to enable/disable interrupt
Date: Mon, 28 Jul 2014 13:09:31 +0100
Message-Id: <1406549375-1864-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406549375-1864-1-git-send-email-abbotti@mev.co.uk>
References: <1406549375-1864-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an optional callback function pointer to the board data to be called
when interrupts are logically enabled or disabled to update the hardware
registers.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pc236.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 32275a5..7b78d57 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -82,6 +82,7 @@ enum pc236_bustype { isa_bustype, pci_bustype };
 struct pc236_board {
 	const char *name;
 	enum pc236_bustype bustype;
+	void (*intr_update_cb)(struct comedi_device *dev, bool enable);
 };
 
 struct pc236_private {
@@ -114,8 +115,8 @@ static void pc236_intr_disable(struct comedi_device *dev)
 
 	spin_lock_irqsave(&dev->spinlock, flags);
 	devpriv->enable_irq = 0;
-	if (is_pci_board(thisboard))
-		outl(PCI236_INTR_DISABLE, devpriv->lcr_iobase + PLX9052_INTCSR);
+	if (thisboard->intr_update_cb)
+		thisboard->intr_update_cb(dev, false);
 	spin_unlock_irqrestore(&dev->spinlock, flags);
 }
 
@@ -132,8 +133,8 @@ static void pc236_intr_enable(struct comedi_device *dev)
 
 	spin_lock_irqsave(&dev->spinlock, flags);
 	devpriv->enable_irq = 1;
-	if (is_pci_board(thisboard))
-		outl(PCI236_INTR_ENABLE, devpriv->lcr_iobase + PLX9052_INTCSR);
+	if (thisboard->intr_update_cb)
+		thisboard->intr_update_cb(dev, true);
 	spin_unlock_irqrestore(&dev->spinlock, flags);
 }
 
@@ -330,8 +331,17 @@ static int pc236_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return pc236_common_attach(dev, dev->iobase, it->options[1], 0);
 }
 
+static void pci236_intr_update_cb(struct comedi_device *dev, bool enable)
+{
+	struct pc236_private *devpriv = dev->private;
+
+	outl(enable ? PCI236_INTR_ENABLE : PCI236_INTR_DISABLE,
+	     devpriv->lcr_iobase + PLX9052_INTCSR);
+}
+
 static const struct pc236_board pc236_pci_board = {
 	.name = "pci236",
+	.intr_update_cb = pci236_intr_update_cb,
 	.bustype = pci_bustype,
 };
 
-- 
2.0.0

