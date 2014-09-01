Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbaIALFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:05:36 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39050 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbaIALEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:35 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 28/28] staging: comedi: amplc_pci230: simplify interrupt enable handling
Date: Mon,  1 Sep 2014 12:04:00 +0100
Message-Id: <1409569440-10979-29-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`struct pci230_private` has two members to manage the enabled interrupt
sources.  `int_en` is the interrupt sources we want to be enabled and
`ier` is a shadow of the write-only interrupt enable register.  They
have the same value most of the time.  They differ in the interrupt
handler (`pci230_interrupt()`) itself when it temporarily clears bits in
the interrupt enable register and the `ier` member in order to unlatch
them in hardware, but leaves the `int_en` member alone.  They also
differ in `pci230_ai_stop()` and `pci230_ao_stop()` which clear bits in
the `int_en` member and wait for the interrupt handler to finish before
copying the value to the `ier` member and the interrupt enable register.

Simplify the handling a bit, by making the `ier` member take on the role
of the `int_en` member, and allowing the value to differ from the
interrupt enable register while the interrupt handler is running.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 32 +++++++++------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 7748e17..66e7a47 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -499,8 +499,7 @@ struct pci230_private {
 	unsigned short daccon;		/* DACCON register value */
 	unsigned short adcfifothresh;	/* ADC FIFO threshold (PCI230+/260+) */
 	unsigned short adcg;		/* ADCG register value */
-	unsigned char int_en;		/* Interrupt enable bits */
-	unsigned char ier;		/* Copy of interrupt enable register */
+	unsigned char ier;		/* Interrupt enable bits */
 	unsigned char res_owned[NUM_OWNERS]; /* Owned resources */
 	bool intr_running:1;		/* Flag set in interrupt routine */
 	bool ai_bipolar:1;		/* Flag AI range is bipolar */
@@ -1049,15 +1048,12 @@ static void pci230_ao_stop(struct comedi_device *dev,
 	 * unless we are called from the interrupt routine.
 	 */
 	spin_lock_irqsave(&devpriv->isr_spinlock, irqflags);
-	devpriv->int_en &= ~intsrc;
+	devpriv->ier &= ~intsrc;
 	while (devpriv->intr_running && devpriv->intr_cpuid != THISCPU) {
 		spin_unlock_irqrestore(&devpriv->isr_spinlock, irqflags);
 		spin_lock_irqsave(&devpriv->isr_spinlock, irqflags);
 	}
-	if (devpriv->ier != devpriv->int_en) {
-		devpriv->ier = devpriv->int_en;
-		outb(devpriv->ier, dev->iobase + PCI230_INT_SCE);
-	}
+	outb(devpriv->ier, dev->iobase + PCI230_INT_SCE);
 	spin_unlock_irqrestore(&devpriv->isr_spinlock, irqflags);
 	if (devpriv->hwver >= 2) {
 		/*
@@ -1311,7 +1307,6 @@ static void pci230_ao_start(struct comedi_device *dev,
 			/* Not using DAC FIFO. */
 			/* Enable CT1 timer interrupt. */
 			spin_lock_irqsave(&devpriv->isr_spinlock, irqflags);
-			devpriv->int_en |= PCI230_INT_ZCLK_CT1;
 			devpriv->ier |= PCI230_INT_ZCLK_CT1;
 			outb(devpriv->ier, dev->iobase + PCI230_INT_SCE);
 			spin_unlock_irqrestore(&devpriv->isr_spinlock,
@@ -1327,7 +1322,6 @@ static void pci230_ao_start(struct comedi_device *dev,
 	if (devpriv->hwver >= 2) {
 		/* Using DAC FIFO.  Enable DAC FIFO interrupt. */
 		spin_lock_irqsave(&devpriv->isr_spinlock, irqflags);
-		devpriv->int_en |= PCI230P2_INT_DAC;
 		devpriv->ier |= PCI230P2_INT_DAC;
 		outb(devpriv->ier, dev->iobase + PCI230_INT_SCE);
 		spin_unlock_irqrestore(&devpriv->isr_spinlock, irqflags);
@@ -1892,15 +1886,12 @@ static void pci230_ai_stop(struct comedi_device *dev,
 	 * Disable ADC interrupt and wait for interrupt routine to finish
 	 * running unless we are called from the interrupt routine.
 	 */
-	devpriv->int_en &= ~PCI230_INT_ADC;
+	devpriv->ier &= ~PCI230_INT_ADC;
 	while (devpriv->intr_running && devpriv->intr_cpuid != THISCPU) {
 		spin_unlock_irqrestore(&devpriv->isr_spinlock, irqflags);
 		spin_lock_irqsave(&devpriv->isr_spinlock, irqflags);
 	}
-	if (devpriv->ier != devpriv->int_en) {
-		devpriv->ier = devpriv->int_en;
-		outb(devpriv->ier, dev->iobase + PCI230_INT_SCE);
-	}
+	outb(devpriv->ier, dev->iobase + PCI230_INT_SCE);
 	spin_unlock_irqrestore(&devpriv->isr_spinlock, irqflags);
 	/*
 	 * Reset FIFO, disable FIFO and set start conversion source to none.
@@ -1935,7 +1926,6 @@ static void pci230_ai_start(struct comedi_device *dev,
 
 	/* Enable ADC FIFO trigger level interrupt. */
 	spin_lock_irqsave(&devpriv->isr_spinlock, irqflags);
-	devpriv->int_en |= PCI230_INT_ADC;
 	devpriv->ier |= PCI230_INT_ADC;
 	outb(devpriv->ier, dev->iobase + PCI230_INT_SCE);
 	spin_unlock_irqrestore(&devpriv->isr_spinlock, irqflags);
@@ -2379,7 +2369,7 @@ static int pci230_ai_cancel(struct comedi_device *dev,
 /* Interrupt handler */
 static irqreturn_t pci230_interrupt(int irq, void *d)
 {
-	unsigned char status_int, valid_status_int;
+	unsigned char status_int, valid_status_int, temp_ier;
 	struct comedi_device *dev = (struct comedi_device *)d;
 	struct pci230_private *devpriv = dev->private;
 	struct comedi_subdevice *s;
@@ -2392,14 +2382,14 @@ static irqreturn_t pci230_interrupt(int irq, void *d)
 		return IRQ_NONE;
 
 	spin_lock_irqsave(&devpriv->isr_spinlock, irqflags);
-	valid_status_int = devpriv->int_en & status_int;
+	valid_status_int = devpriv->ier & status_int;
 	/*
 	 * Disable triggered interrupts.
 	 * (Only those interrupts that need re-enabling, are, later in the
 	 * handler).
 	 */
-	devpriv->ier = devpriv->int_en & ~status_int;
-	outb(devpriv->ier, dev->iobase + PCI230_INT_SCE);
+	temp_ier = devpriv->ier & ~status_int;
+	outb(temp_ier, dev->iobase + PCI230_INT_SCE);
 	devpriv->intr_running = true;
 	devpriv->intr_cpuid = THISCPU;
 	spin_unlock_irqrestore(&devpriv->isr_spinlock, irqflags);
@@ -2432,10 +2422,8 @@ static irqreturn_t pci230_interrupt(int irq, void *d)
 
 	/* Reenable interrupts. */
 	spin_lock_irqsave(&devpriv->isr_spinlock, irqflags);
-	if (devpriv->ier != devpriv->int_en) {
-		devpriv->ier = devpriv->int_en;
+	if (devpriv->ier != temp_ier)
 		outb(devpriv->ier, dev->iobase + PCI230_INT_SCE);
-	}
 	devpriv->intr_running = false;
 	spin_unlock_irqrestore(&devpriv->isr_spinlock, irqflags);
 
-- 
2.0.4

