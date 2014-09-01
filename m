Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaIALMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:12:05 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38988 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbaIALEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:16 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/28] staging: comedi: amplc_pci230: collapse some 'else { if' chains
Date: Mon,  1 Sep 2014 12:03:36 +0100
Message-Id: <1409569440-10979-5-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where the only thing in an `else { ... }` block is another `if`
statement, collapse it to an `else if {` block where it makes sense to
do so.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 55 +++++++++++----------------
 1 file changed, 22 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 0ba06f7..56141de 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -1844,32 +1844,25 @@ static void pci230_ai_update_fifo_trigger_level(struct comedi_device *dev,
 	unsigned short triglev;
 	unsigned short adccon;
 
-	if (cmd->flags & TRIG_WAKE_EOS) {
-		/* Wake at end of scan. */
+	if (cmd->flags & TRIG_WAKE_EOS)
 		wake = scanlen - devpriv->ai_scan_pos;
-	} else {
-		if (cmd->stop_src != TRIG_COUNT ||
-		    devpriv->ai_scan_count >= PCI230_ADC_FIFOLEVEL_HALFFULL ||
-		    scanlen >= PCI230_ADC_FIFOLEVEL_HALFFULL) {
-			wake = PCI230_ADC_FIFOLEVEL_HALFFULL;
-		} else {
-			wake = devpriv->ai_scan_count * scanlen -
-			       devpriv->ai_scan_pos;
-		}
-	}
+	else if (cmd->stop_src != TRIG_COUNT ||
+		 devpriv->ai_scan_count >= PCI230_ADC_FIFOLEVEL_HALFFULL ||
+		 scanlen >= PCI230_ADC_FIFOLEVEL_HALFFULL)
+		wake = PCI230_ADC_FIFOLEVEL_HALFFULL;
+	else
+		wake = devpriv->ai_scan_count * scanlen - devpriv->ai_scan_pos;
 	if (wake >= PCI230_ADC_FIFOLEVEL_HALFFULL) {
 		triglev = PCI230_ADC_INT_FIFO_HALF;
-	} else {
-		if (wake > 1 && devpriv->hwver > 0) {
-			/* PCI230+/260+ programmable FIFO interrupt level. */
-			if (devpriv->adcfifothresh != wake) {
-				devpriv->adcfifothresh = wake;
-				outw(wake, devpriv->daqio + PCI230P_ADCFFTH);
-			}
-			triglev = PCI230P_ADC_INT_FIFO_THRESH;
-		} else {
-			triglev = PCI230_ADC_INT_FIFO_NEMPTY;
+	} else if (wake > 1 && devpriv->hwver > 0) {
+		/* PCI230+/260+ programmable FIFO interrupt level. */
+		if (devpriv->adcfifothresh != wake) {
+			devpriv->adcfifothresh = wake;
+			outw(wake, devpriv->daqio + PCI230P_ADCFFTH);
 		}
+		triglev = PCI230P_ADC_INT_FIFO_THRESH;
+	} else {
+		triglev = PCI230_ADC_INT_FIFO_NEMPTY;
 	}
 	adccon = (devpriv->adccon & ~PCI230_ADC_INT_FIFO_MASK) | triglev;
 	if (adccon != devpriv->adccon) {
@@ -2211,19 +2204,15 @@ static void pci230_handle_ai(struct comedi_device *dev,
 			} else if (status_fifo & PCI230_ADC_FIFO_HALF) {
 				/* FIFO half full. */
 				fifoamount = PCI230_ADC_FIFOLEVEL_HALFFULL;
+			} else if (devpriv->hwver > 0) {
+				/* Read PCI230+/260+ ADC FIFO level. */
+				fifoamount = inw(devpriv->daqio +
+						 PCI230P_ADCFFLEV);
+				if (fifoamount == 0)
+					break;	/* Shouldn't happen. */
 			} else {
 				/* FIFO not empty. */
-				if (devpriv->hwver > 0) {
-					/* Read PCI230+/260+ ADC FIFO level. */
-					fifoamount = inw(devpriv->daqio +
-							 PCI230P_ADCFFLEV);
-					if (fifoamount == 0) {
-						/* Shouldn't happen. */
-						break;
-					}
-				} else {
-					fifoamount = 1;
-				}
+				fifoamount = 1;
 			}
 		}
 		/* Read sample and store in Comedi's circular buffer. */
-- 
2.0.4

