Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbaIALGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:06:09 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38999 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbaIALEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:33 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 26/28] staging: comedi: amplc_pci230: reduce indentation in pci230_ai_start()
Date: Mon,  1 Sep 2014 12:03:58 +0100
Message-Id: <1409569440-10979-27-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 229 +++++++++++++-------------
 1 file changed, 112 insertions(+), 117 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index b0313c8..27ff5be 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -1928,139 +1928,134 @@ static void pci230_ai_start(struct comedi_device *dev,
 		async->events |= COMEDI_CB_EOA;
 		pci230_ai_stop(dev, s);
 		comedi_event(dev, s);
-	} else {
-		/* Enable ADC FIFO trigger level interrupt. */
-		spin_lock_irqsave(&devpriv->isr_spinlock, irqflags);
-		devpriv->int_en |= PCI230_INT_ADC;
-		devpriv->ier |= PCI230_INT_ADC;
-		outb(devpriv->ier, dev->iobase + PCI230_INT_SCE);
-		spin_unlock_irqrestore(&devpriv->isr_spinlock, irqflags);
+		return;
+	}
 
-		/*
-		 * Update conversion trigger source which is currently set
-		 * to CT2 output, which is currently stuck high.
-		 */
-		switch (cmd->convert_src) {
-		default:
-			conv = PCI230_ADC_TRIG_NONE;
-			break;
-		case TRIG_TIMER:
-			/* Using CT2 output. */
-			conv = PCI230_ADC_TRIG_Z2CT2;
-			break;
-		case TRIG_EXT:
-			if (cmd->convert_arg & CR_EDGE) {
-				if ((cmd->convert_arg & CR_INVERT) == 0) {
-					/* Trigger on +ve edge. */
-					conv = PCI230_ADC_TRIG_EXTP;
-				} else {
-					/* Trigger on -ve edge. */
-					conv = PCI230_ADC_TRIG_EXTN;
-				}
+	/* Enable ADC FIFO trigger level interrupt. */
+	spin_lock_irqsave(&devpriv->isr_spinlock, irqflags);
+	devpriv->int_en |= PCI230_INT_ADC;
+	devpriv->ier |= PCI230_INT_ADC;
+	outb(devpriv->ier, dev->iobase + PCI230_INT_SCE);
+	spin_unlock_irqrestore(&devpriv->isr_spinlock, irqflags);
+
+	/*
+	 * Update conversion trigger source which is currently set
+	 * to CT2 output, which is currently stuck high.
+	 */
+	switch (cmd->convert_src) {
+	default:
+		conv = PCI230_ADC_TRIG_NONE;
+		break;
+	case TRIG_TIMER:
+		/* Using CT2 output. */
+		conv = PCI230_ADC_TRIG_Z2CT2;
+		break;
+	case TRIG_EXT:
+		if (cmd->convert_arg & CR_EDGE) {
+			if ((cmd->convert_arg & CR_INVERT) == 0) {
+				/* Trigger on +ve edge. */
+				conv = PCI230_ADC_TRIG_EXTP;
 			} else {
-				/* Backwards compatibility. */
-				if (cmd->convert_arg) {
-					/* Trigger on +ve edge. */
-					conv = PCI230_ADC_TRIG_EXTP;
-				} else {
-					/* Trigger on -ve edge. */
-					conv = PCI230_ADC_TRIG_EXTN;
-				}
+				/* Trigger on -ve edge. */
+				conv = PCI230_ADC_TRIG_EXTN;
+			}
+		} else {
+			/* Backwards compatibility. */
+			if (cmd->convert_arg) {
+				/* Trigger on +ve edge. */
+				conv = PCI230_ADC_TRIG_EXTP;
+			} else {
+				/* Trigger on -ve edge. */
+				conv = PCI230_ADC_TRIG_EXTN;
 			}
-			break;
-		case TRIG_INT:
-			/*
-			 * Use CT2 output for software trigger due to problems
-			 * in differential mode on PCI230/260.
-			 */
-			conv = PCI230_ADC_TRIG_Z2CT2;
-			break;
 		}
-		devpriv->adccon =
-		    (devpriv->adccon & ~PCI230_ADC_TRIG_MASK) | conv;
-		outw(devpriv->adccon, devpriv->daqio + PCI230_ADCCON);
-		if (cmd->convert_src == TRIG_INT)
-			async->inttrig = pci230_ai_inttrig_convert;
-
+		break;
+	case TRIG_INT:
 		/*
-		 * Update FIFO interrupt trigger level, which is currently
-		 * set to "full".
+		 * Use CT2 output for software trigger due to problems
+		 * in differential mode on PCI230/260.
 		 */
-		pci230_ai_update_fifo_trigger_level(dev, s);
-		if (cmd->convert_src == TRIG_TIMER) {
-			/* Update timer gates. */
-			unsigned char zgat;
+		conv = PCI230_ADC_TRIG_Z2CT2;
+		break;
+	}
+	devpriv->adccon = (devpriv->adccon & ~PCI230_ADC_TRIG_MASK) | conv;
+	outw(devpriv->adccon, devpriv->daqio + PCI230_ADCCON);
+	if (cmd->convert_src == TRIG_INT)
+		async->inttrig = pci230_ai_inttrig_convert;
+
+	/*
+	 * Update FIFO interrupt trigger level, which is currently
+	 * set to "full".
+	 */
+	pci230_ai_update_fifo_trigger_level(dev, s);
+	if (cmd->convert_src == TRIG_TIMER) {
+		/* Update timer gates. */
+		unsigned char zgat;
 
-			if (cmd->scan_begin_src != TRIG_FOLLOW) {
+		if (cmd->scan_begin_src != TRIG_FOLLOW) {
+			/*
+			 * Conversion timer CT2 needs to be gated by
+			 * inverted output of monostable CT2.
+			 */
+			zgat = GAT_CONFIG(2, GAT_NOUTNM2);
+		} else {
+			/*
+			 * Conversion timer CT2 needs to be gated on
+			 * continuously.
+			 */
+			zgat = GAT_CONFIG(2, GAT_VCC);
+		}
+		outb(zgat, dev->iobase + PCI230_ZGAT_SCE);
+		if (cmd->scan_begin_src != TRIG_FOLLOW) {
+			/* Set monostable CT0 trigger source. */
+			switch (cmd->scan_begin_src) {
+			default:
+				zgat = GAT_CONFIG(0, GAT_VCC);
+				break;
+			case TRIG_EXT:
 				/*
-				 * Conversion timer CT2 needs to be gated by
-				 * inverted output of monostable CT2.
+				 * For CT0 on PCI230, the external trigger
+				 * (gate) signal comes from PPC0, which is
+				 * channel 16 of the DIO subdevice.  The
+				 * application needs to configure this as an
+				 * input in order to use it as an external scan
+				 * trigger.
 				 */
-				zgat = GAT_CONFIG(2, GAT_NOUTNM2);
-			} else {
+				zgat = GAT_CONFIG(0, GAT_EXT);
+				break;
+			case TRIG_TIMER:
 				/*
-				 * Conversion timer CT2 needs to be gated on
-				 * continuously.
+				 * Monostable CT0 triggered by rising edge on
+				 * inverted output of CT1 (falling edge on CT1).
 				 */
-				zgat = GAT_CONFIG(2, GAT_VCC);
+				zgat = GAT_CONFIG(0, GAT_NOUTNM2);
+				break;
+			case TRIG_INT:
+				/*
+				 * Monostable CT0 is triggered by inttrig
+				 * function waggling the CT0 gate source.
+				 */
+				zgat = GAT_CONFIG(0, GAT_VCC);
+				break;
 			}
 			outb(zgat, dev->iobase + PCI230_ZGAT_SCE);
-			if (cmd->scan_begin_src != TRIG_FOLLOW) {
-				/* Set monostable CT0 trigger source. */
-				switch (cmd->scan_begin_src) {
-				default:
-					zgat = GAT_CONFIG(0, GAT_VCC);
-					break;
-				case TRIG_EXT:
-					/*
-					 * For CT0 on PCI230, the external
-					 * trigger (gate) signal comes from
-					 * PPC0, which is channel 16 of the DIO
-					 * subdevice.  The application needs to
-					 * configure this as an input in order
-					 * to use it as an external scan
-					 * trigger.
-					 */
-					zgat = GAT_CONFIG(0, GAT_EXT);
-					break;
-				case TRIG_TIMER:
-					/*
-					 * Monostable CT0 triggered by rising
-					 * edge on inverted output of CT1
-					 * (falling edge on CT1).
-					 */
-					zgat = GAT_CONFIG(0, GAT_NOUTNM2);
-					break;
-				case TRIG_INT:
-					/*
-					 * Monostable CT0 is triggered by
-					 * inttrig function waggling the CT0
-					 * gate source.
-					 */
-					zgat = GAT_CONFIG(0, GAT_VCC);
-					break;
-				}
+			switch (cmd->scan_begin_src) {
+			case TRIG_TIMER:
+				/*
+				 * Scan period timer CT1 needs to be
+				 * gated on to start counting.
+				 */
+				zgat = GAT_CONFIG(1, GAT_VCC);
 				outb(zgat, dev->iobase + PCI230_ZGAT_SCE);
-				switch (cmd->scan_begin_src) {
-				case TRIG_TIMER:
-					/*
-					 * Scan period timer CT1 needs to be
-					 * gated on to start counting.
-					 */
-					zgat = GAT_CONFIG(1, GAT_VCC);
-					outb(zgat,
-					     dev->iobase + PCI230_ZGAT_SCE);
-					break;
-				case TRIG_INT:
-					async->inttrig =
-					    pci230_ai_inttrig_scan_begin;
-					break;
-				}
+				break;
+			case TRIG_INT:
+				async->inttrig = pci230_ai_inttrig_scan_begin;
+				break;
 			}
-		} else if (cmd->convert_src != TRIG_INT) {
-			/* No longer need Z2-CT2. */
-			pci230_release_shared(dev, RES_Z2CT2, OWNER_AICMD);
 		}
+	} else if (cmd->convert_src != TRIG_INT) {
+		/* No longer need Z2-CT2. */
+		pci230_release_shared(dev, RES_Z2CT2, OWNER_AICMD);
 	}
 }
 
-- 
2.0.4

