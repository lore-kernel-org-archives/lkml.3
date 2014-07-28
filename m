Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaG1ML2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:11:28 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49023 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbaG1MJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:09:48 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] staging: comedi: amplc_pc236: combine interrupt enable/disable functions
Date: Mon, 28 Jul 2014 13:09:32 +0100
Message-Id: <1406549375-1864-5-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406549375-1864-1-git-send-email-abbotti@mev.co.uk>
References: <1406549375-1864-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`pc236_intr_enable()` and `pc236_intr_disable()` are very similar.
Combine them into a single function `pc236_intr_update()` with a
parameter to indicate whether interrupts are being enabled or disabled.

Change type type of the `enable_irq` member of the private data to
`bool` to match the parameter.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pc236.c | 37 ++++++----------------------
 1 file changed, 7 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 7b78d57..c69aa2d 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -87,7 +87,7 @@ struct pc236_board {
 
 struct pc236_private {
 	unsigned long lcr_iobase; /* PLX PCI9052 config registers in PCIBAR1 */
-	int enable_irq;
+	bool enable_irq;
 };
 
 /* test if ISA supported and this is an ISA board */
@@ -102,39 +102,16 @@ static inline bool is_pci_board(const struct pc236_board *board)
 	return DO_PCI && board->bustype == pci_bustype;
 }
 
-/*
- * This function is called to mark the interrupt as disabled (no command
- * configured on subdevice 1) and to physically disable the interrupt
- * (not possible on the PC36AT, except by removing the IRQ jumper!).
- */
-static void pc236_intr_disable(struct comedi_device *dev)
-{
-	const struct pc236_board *thisboard = comedi_board(dev);
-	struct pc236_private *devpriv = dev->private;
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->spinlock, flags);
-	devpriv->enable_irq = 0;
-	if (thisboard->intr_update_cb)
-		thisboard->intr_update_cb(dev, false);
-	spin_unlock_irqrestore(&dev->spinlock, flags);
-}
-
-/*
- * This function is called to mark the interrupt as enabled (a command
- * configured on subdevice 1) and to physically enable the interrupt
- * (not possible on the PC36AT, except by (re)connecting the IRQ jumper!).
- */
-static void pc236_intr_enable(struct comedi_device *dev)
+static void pc236_intr_update(struct comedi_device *dev, bool enable)
 {
 	const struct pc236_board *thisboard = comedi_board(dev);
 	struct pc236_private *devpriv = dev->private;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->spinlock, flags);
-	devpriv->enable_irq = 1;
+	devpriv->enable_irq = enable;
 	if (thisboard->intr_update_cb)
-		thisboard->intr_update_cb(dev, true);
+		thisboard->intr_update_cb(dev, enable);
 	spin_unlock_irqrestore(&dev->spinlock, flags);
 }
 
@@ -235,7 +212,7 @@ static int pc236_intr_cmdtest(struct comedi_device *dev,
  */
 static int pc236_intr_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
-	pc236_intr_enable(dev);
+	pc236_intr_update(dev, true);
 
 	return 0;
 }
@@ -246,7 +223,7 @@ static int pc236_intr_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 static int pc236_intr_cancel(struct comedi_device *dev,
 			     struct comedi_subdevice *s)
 {
-	pc236_intr_disable(dev);
+	pc236_intr_update(dev, false);
 
 	return 0;
 }
@@ -291,7 +268,7 @@ static int pc236_common_attach(struct comedi_device *dev, unsigned long iobase,
 	s = &dev->subdevices[1];
 	dev->read_subdev = s;
 	s->type = COMEDI_SUBD_UNUSED;
-	pc236_intr_disable(dev);
+	pc236_intr_update(dev, false);
 	if (irq) {
 		if (request_irq(irq, pc236_interrupt, req_irq_flags,
 				dev->board_name, dev) >= 0) {
-- 
2.0.0

