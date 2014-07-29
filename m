Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbaG2MCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:02:25 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51671 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbaG2L6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:58:48 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/19] staging: comedi: amplc_pci230: omit '!= 0' from logical expressions
Date: Tue, 29 Jul 2014 12:58:20 +0100
Message-Id: <1406635107-27950-13-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since anything non-zero is logically "true", don't bother doing
"not-equal" comparisons with zero.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 75 +++++++++++++--------------
 1 file changed, 36 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 311c497..4222e28 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -672,16 +672,15 @@ static int get_resources(struct comedi_device *dev, unsigned int res_mask,
 	ok = 1;
 	claimed = 0;
 	spin_lock_irqsave(&devpriv->res_spinlock, irqflags);
-	for (b = 1, i = 0; (i < NUM_RESOURCES) && (res_mask != 0);
-	     b <<= 1, i++) {
-		if ((res_mask & b) != 0) {
+	for (b = 1, i = 0; (i < NUM_RESOURCES) && res_mask; b <<= 1, i++) {
+		if (res_mask & b) {
 			res_mask &= ~b;
 			if (devpriv->res_owner[i] == OWNER_NONE) {
 				devpriv->res_owner[i] = owner;
 				claimed |= b;
 			} else if (devpriv->res_owner[i] != owner) {
-				for (b = 1, i = 0; claimed != 0; b <<= 1, i++) {
-					if ((claimed & b) != 0) {
+				for (b = 1, i = 0; claimed; b <<= 1, i++) {
+					if (claimed & b) {
 						devpriv->res_owner[i] =
 						    OWNER_NONE;
 						claimed &= ~b;
@@ -711,9 +710,8 @@ static void put_resources(struct comedi_device *dev, unsigned int res_mask,
 	unsigned long irqflags;
 
 	spin_lock_irqsave(&devpriv->res_spinlock, irqflags);
-	for (b = 1, i = 0; (i < NUM_RESOURCES) && (res_mask != 0);
-	     b <<= 1, i++) {
-		if ((res_mask & b) != 0) {
+	for (b = 1, i = 0; (i < NUM_RESOURCES) && res_mask; b <<= 1, i++) {
+		if (res_mask & b) {
 			res_mask &= ~b;
 			if (devpriv->res_owner[i] == owner)
 				devpriv->res_owner[i] = OWNER_NONE;
@@ -1086,7 +1084,7 @@ static int pci230_ao_cmdtest(struct comedi_device *dev,
 		 * External trigger - for PCI230+ hardware version 2 onwards.
 		 */
 		/* Trigger number must be 0. */
-		if ((cmd->scan_begin_arg & ~CR_FLAGS_MASK) != 0) {
+		if (cmd->scan_begin_arg & ~CR_FLAGS_MASK) {
 			cmd->scan_begin_arg = COMBINE(cmd->scan_begin_arg, 0,
 						      ~CR_FLAGS_MASK);
 			err |= -EINVAL;
@@ -1095,8 +1093,8 @@ static int pci230_ao_cmdtest(struct comedi_device *dev,
 		 * The only flags allowed are CR_EDGE and CR_INVERT.
 		 * The CR_EDGE flag is ignored.
 		 */
-		if ((cmd->scan_begin_arg &
-		     (CR_FLAGS_MASK & ~(CR_EDGE | CR_INVERT))) != 0) {
+		if (cmd->scan_begin_arg &
+		    (CR_FLAGS_MASK & ~(CR_EDGE | CR_INVERT))) {
 			cmd->scan_begin_arg = COMBINE(cmd->scan_begin_arg, 0,
 						      CR_FLAGS_MASK &
 						      ~(CR_EDGE | CR_INVERT));
@@ -1258,7 +1256,7 @@ static int pci230_handle_ao_fifo(struct comedi_device *dev,
 	}
 	if (events == 0) {
 		/* Check for FIFO underrun. */
-		if ((dacstat & PCI230P2_DAC_FIFO_UNDERRUN_LATCHED) != 0) {
+		if (dacstat & PCI230P2_DAC_FIFO_UNDERRUN_LATCHED) {
 			dev_err(dev->class_dev, "AO FIFO underrun\n");
 			events |= COMEDI_CB_OVERFLOW | COMEDI_CB_ERROR;
 		}
@@ -1275,11 +1273,11 @@ static int pci230_handle_ao_fifo(struct comedi_device *dev,
 	}
 	if (events == 0) {
 		/* Determine how much room is in the FIFO (in samples). */
-		if ((dacstat & PCI230P2_DAC_FIFO_FULL) != 0)
+		if (dacstat & PCI230P2_DAC_FIFO_FULL)
 			room = PCI230P2_DAC_FIFOROOM_FULL;
-		else if ((dacstat & PCI230P2_DAC_FIFO_HALF) != 0)
+		else if (dacstat & PCI230P2_DAC_FIFO_HALF)
 			room = PCI230P2_DAC_FIFOROOM_HALFTOFULL;
-		else if ((dacstat & PCI230P2_DAC_FIFO_EMPTY) != 0)
+		else if (dacstat & PCI230P2_DAC_FIFO_EMPTY)
 			room = PCI230P2_DAC_FIFOROOM_EMPTY;
 		else
 			room = PCI230P2_DAC_FIFOROOM_ONETOHALF;
@@ -1317,13 +1315,12 @@ static int pci230_handle_ao_fifo(struct comedi_device *dev,
 		}
 		/* Check if FIFO underrun occurred while writing to FIFO. */
 		dacstat = inw(dev->iobase + PCI230_DACCON);
-		if ((dacstat & PCI230P2_DAC_FIFO_UNDERRUN_LATCHED) != 0) {
+		if (dacstat & PCI230P2_DAC_FIFO_UNDERRUN_LATCHED) {
 			dev_err(dev->class_dev, "AO FIFO underrun\n");
 			events |= COMEDI_CB_OVERFLOW | COMEDI_CB_ERROR;
 		}
 	}
-	if ((events &
-	     (COMEDI_CB_EOA | COMEDI_CB_ERROR | COMEDI_CB_OVERFLOW)) != 0) {
+	if (events & (COMEDI_CB_EOA | COMEDI_CB_ERROR | COMEDI_CB_OVERFLOW)) {
 		/* Stopping AO due to completion or error. */
 		pci230_ao_stop(dev, s);
 		running = 0;
@@ -1341,7 +1338,7 @@ static int pci230_ao_inttrig_scan_begin(struct comedi_device *dev,
 	struct pci230_private *devpriv = dev->private;
 	unsigned long irqflags;
 
-	if (trig_num != 0)
+	if (trig_num)
 		return -EINVAL;
 
 	spin_lock_irqsave(&devpriv->ao_stop_spinlock, irqflags);
@@ -1656,7 +1653,7 @@ static int pci230_ai_check_chanlist(struct comedi_device *dev,
 	if (subseq_len == 0)
 		subseq_len = cmd->chanlist_len;
 
-	if ((cmd->chanlist_len % subseq_len) != 0) {
+	if (cmd->chanlist_len % subseq_len) {
 		dev_dbg(dev->class_dev,
 			"%s: sequence must repeat exactly\n", __func__);
 		return -EINVAL;
@@ -1674,7 +1671,7 @@ static int pci230_ai_check_chanlist(struct comedi_device *dev,
 	 * the bug, but the second one does, and we can't tell them apart!
 	 */
 	if (devpriv->hwver > 0 && devpriv->hwver < 4) {
-		if (subseq_len > 1 && CR_CHAN(cmd->chanlist[0]) != 0) {
+		if (subseq_len > 1 && CR_CHAN(cmd->chanlist[0])) {
 			dev_info(dev->class_dev,
 				 "amplc_pci230: ai_cmdtest: Buggy PCI230+/260+ h/w version %u requires first channel of multi-channel sequence to be 0 (corrected in h/w version 4)\n",
 				 devpriv->hwver);
@@ -1786,9 +1783,9 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 		 * convert_arg == (CR_EDGE | CR_INVERT | 0)
 		 *                => trigger on -ve edge.
 		 */
-		if ((cmd->convert_arg & CR_FLAGS_MASK) != 0) {
+		if (cmd->convert_arg & CR_FLAGS_MASK) {
 			/* Trigger number must be 0. */
-			if ((cmd->convert_arg & ~CR_FLAGS_MASK) != 0) {
+			if (cmd->convert_arg & ~CR_FLAGS_MASK) {
 				cmd->convert_arg = COMBINE(cmd->convert_arg, 0,
 							   ~CR_FLAGS_MASK);
 				err |= -EINVAL;
@@ -1829,13 +1826,13 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 		 * scan_begin_arg==0 => use PPC0 input -> gate of CT0 -> gate
 		 * of CT2 (sample convert trigger is CT2)
 		 */
-		if ((cmd->scan_begin_arg & ~CR_FLAGS_MASK) != 0) {
+		if (cmd->scan_begin_arg & ~CR_FLAGS_MASK) {
 			cmd->scan_begin_arg = COMBINE(cmd->scan_begin_arg, 0,
 						      ~CR_FLAGS_MASK);
 			err |= -EINVAL;
 		}
 		/* The only flag allowed is CR_EDGE, which is ignored. */
-		if ((cmd->scan_begin_arg & CR_FLAGS_MASK & ~CR_EDGE) != 0) {
+		if (cmd->scan_begin_arg & CR_FLAGS_MASK & ~CR_EDGE) {
 			cmd->scan_begin_arg = COMBINE(cmd->scan_begin_arg, 0,
 						      CR_FLAGS_MASK & ~CR_EDGE);
 			err |= -EINVAL;
@@ -1898,7 +1895,7 @@ static void pci230_ai_update_fifo_trigger_level(struct comedi_device *dev,
 	unsigned short triglev;
 	unsigned short adccon;
 
-	if ((cmd->flags & TRIG_WAKE_EOS) != 0) {
+	if (cmd->flags & TRIG_WAKE_EOS) {
 		/* Wake at end of scan. */
 		wake = scanlen - devpriv->ai_scan_pos;
 	} else {
@@ -1939,7 +1936,7 @@ static int pci230_ai_inttrig_convert(struct comedi_device *dev,
 	struct pci230_private *devpriv = dev->private;
 	unsigned long irqflags;
 
-	if (trig_num != 0)
+	if (trig_num)
 		return -EINVAL;
 
 	spin_lock_irqsave(&devpriv->ai_stop_spinlock, irqflags);
@@ -1986,7 +1983,7 @@ static int pci230_ai_inttrig_scan_begin(struct comedi_device *dev,
 	unsigned long irqflags;
 	unsigned char zgat;
 
-	if (trig_num != 0)
+	if (trig_num)
 		return -EINVAL;
 
 	spin_lock_irqsave(&devpriv->ai_stop_spinlock, irqflags);
@@ -2088,7 +2085,7 @@ static void pci230_ai_start(struct comedi_device *dev,
 			conv = PCI230_ADC_TRIG_Z2CT2;
 			break;
 		case TRIG_EXT:
-			if ((cmd->convert_arg & CR_EDGE) != 0) {
+			if (cmd->convert_arg & CR_EDGE) {
 				if ((cmd->convert_arg & CR_INVERT) == 0) {
 					/* Trigger on +ve edge. */
 					conv = PCI230_ADC_TRIG_EXTP;
@@ -2098,7 +2095,7 @@ static void pci230_ai_start(struct comedi_device *dev,
 				}
 			} else {
 				/* Backwards compatibility. */
-				if (cmd->convert_arg != 0) {
+				if (cmd->convert_arg) {
 					/* Trigger on +ve edge. */
 					conv = PCI230_ADC_TRIG_EXTP;
 				} else {
@@ -2252,7 +2249,7 @@ static void pci230_handle_ai(struct comedi_device *dev,
 		if (fifoamount == 0) {
 			/* Read FIFO state. */
 			status_fifo = inw(dev->iobase + PCI230_ADCCON);
-			if ((status_fifo & PCI230_ADC_FIFO_FULL_LATCHED) != 0) {
+			if (status_fifo & PCI230_ADC_FIFO_FULL_LATCHED) {
 				/*
 				 * Report error otherwise FIFO overruns will go
 				 * unnoticed by the caller.
@@ -2260,10 +2257,10 @@ static void pci230_handle_ai(struct comedi_device *dev,
 				dev_err(dev->class_dev, "AI FIFO overrun\n");
 				events |= COMEDI_CB_OVERFLOW | COMEDI_CB_ERROR;
 				break;
-			} else if ((status_fifo & PCI230_ADC_FIFO_EMPTY) != 0) {
+			} else if (status_fifo & PCI230_ADC_FIFO_EMPTY) {
 				/* FIFO empty. */
 				break;
-			} else if ((status_fifo & PCI230_ADC_FIFO_HALF) != 0) {
+			} else if (status_fifo & PCI230_ADC_FIFO_HALF) {
 				/* FIFO half full. */
 				fifoamount = PCI230_ADC_FIFOLEVEL_HALFFULL;
 			} else {
@@ -2304,8 +2301,8 @@ static void pci230_handle_ai(struct comedi_device *dev,
 		events |= COMEDI_CB_BLOCK;
 	}
 	async->events |= events;
-	if ((async->events & (COMEDI_CB_EOA | COMEDI_CB_ERROR |
-			      COMEDI_CB_OVERFLOW)) != 0) {
+	if (async->events & (COMEDI_CB_EOA | COMEDI_CB_ERROR |
+			     COMEDI_CB_OVERFLOW)) {
 		/* disable hardware conversions */
 		pci230_ai_stop(dev, s);
 	} else {
@@ -2561,19 +2558,19 @@ static irqreturn_t pci230_interrupt(int irq, void *d)
 	 * two.
 	 */
 
-	if ((valid_status_int & PCI230_INT_ZCLK_CT1) != 0) {
+	if (valid_status_int & PCI230_INT_ZCLK_CT1) {
 		s = dev->write_subdev;
 		pci230_handle_ao_nofifo(dev, s);
 		comedi_event(dev, s);
 	}
 
-	if ((valid_status_int & PCI230P2_INT_DAC) != 0) {
+	if (valid_status_int & PCI230P2_INT_DAC) {
 		s = dev->write_subdev;
 		pci230_handle_ao_fifo(dev, s);
 		comedi_event(dev, s);
 	}
 
-	if ((valid_status_int & PCI230_INT_ADC) != 0) {
+	if (valid_status_int & PCI230_INT_ADC) {
 		s = dev->read_subdev;
 		pci230_handle_ai(dev, s);
 		comedi_event(dev, s);
@@ -2741,7 +2738,7 @@ static int pci230_attach_common(struct comedi_device *dev,
 			}
 		}
 		outw(extfunc, dev->iobase + PCI230P_EXTFUNC);
-		if ((extfunc & PCI230P2_EXTFUNC_DACFIFO) != 0) {
+		if (extfunc & PCI230P2_EXTFUNC_DACFIFO) {
 			/*
 			 * Temporarily enable DAC FIFO, reset it and disable
 			 * FIFO wraparound.
-- 
2.0.0

