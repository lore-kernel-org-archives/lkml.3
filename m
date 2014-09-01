Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaIALEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:04:30 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39018 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbaIALE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:27 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/28] staging: comedi: amplc_pci230: use comedi_range_is_bipolar()
Date: Mon,  1 Sep 2014 12:03:51 +0100
Message-Id: <1409569440-10979-20-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the inline `comedi_range_is_bipolar()` function from "comedidev.h"
to decide whether a range is bipolar or unipolar instead of using the
local static arrays `pci230_ai_bipolar[]` and `pci230_ao_bipolar[]`
which can then be removed.

Change the types of the `ai_bipolar` and `ao_bipolar` members of `struct
pci230_private` to `bool` to match the return value of
`comedi_range_is_bipolar()` and change them into single-bit bitfields to
save a bit of space.  Also change the type and name of some local
variables in `pci230_ai_check_chanlist()` that hold the result of
`comedi_range_is_bipolar()`.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 6cd235d..8959820 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -506,11 +506,11 @@ struct pci230_private {
 	unsigned short adcfifothresh;	/* ADC FIFO threshold (PCI230+/260+) */
 	unsigned short adcg;		/* ADCG register value */
 	unsigned char int_en;		/* Interrupt enable bits */
-	unsigned char ai_bipolar;	/* Flag AI range is bipolar */
-	unsigned char ao_bipolar;	/* Flag AO range is bipolar */
 	unsigned char ier;		/* Copy of interrupt enable register */
 	unsigned char intr_running;	/* Flag set in interrupt routine */
 	unsigned char res_owner[NUM_RESOURCES]; /* Shared resource owners */
+	bool ai_bipolar:1;		/* Flag AI range is bipolar */
+	bool ao_bipolar:1;		/* Flag AO range is bipolar */
 };
 
 /* PCI230 clock source periods in ns */
@@ -538,9 +538,6 @@ static const struct comedi_lrange pci230_ai_range = {
 /* PCI230 analogue gain bits for each input range. */
 static const unsigned char pci230_ai_gain[7] = { 0, 1, 2, 3, 1, 2, 3 };
 
-/* PCI230 adccon bipolar flag for each analogue input range. */
-static const unsigned char pci230_ai_bipolar[7] = { 1, 1, 1, 1, 0, 0, 0 };
-
 /* PCI230 analogue output range table */
 static const struct comedi_lrange pci230_ao_range = {
 	2, {
@@ -549,9 +546,6 @@ static const struct comedi_lrange pci230_ao_range = {
 	}
 };
 
-/* PCI230 daccon bipolar flag for each analogue output range. */
-static const unsigned char pci230_ao_bipolar[2] = { 0, 1 };
-
 static unsigned short pci230_ai_read(struct comedi_device *dev)
 {
 	const struct pci230_board *thisboard = comedi_board(dev);
@@ -809,7 +803,7 @@ static int pci230_ai_insn_read(struct comedi_device *dev,
 	adccon = PCI230_ADC_TRIG_Z2CT2 | PCI230_ADC_FIFO_EN;
 	/* Set Z2-CT2 output low to avoid any false triggers. */
 	i8254_set_mode(dev->iobase + PCI230_Z2_CT_BASE, 0, 2, I8254_MODE0);
-	devpriv->ai_bipolar = pci230_ai_bipolar[range];
+	devpriv->ai_bipolar = comedi_range_is_bipolar(s, range);
 	if (aref == AREF_DIFF) {
 		/* Differential. */
 		gainshift = chan * 2;
@@ -892,7 +886,7 @@ static int pci230_ao_insn_write(struct comedi_device *dev,
 	 * Set range - see analogue output range table; 0 => unipolar 10V,
 	 * 1 => bipolar +/-10V range scale
 	 */
-	devpriv->ao_bipolar = pci230_ao_bipolar[range];
+	devpriv->ao_bipolar = comedi_range_is_bipolar(s, range);
 	outw(range, devpriv->daqio + PCI230_DACCON);
 
 	for (i = 0; i < insn->n; i++) {
@@ -1424,7 +1418,7 @@ static int pci230_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	 * 1 => bipolar +/-10V range scale
 	 */
 	range = CR_RANGE(cmd->chanlist[0]);
-	devpriv->ao_bipolar = pci230_ao_bipolar[range];
+	devpriv->ao_bipolar = comedi_range_is_bipolar(s, range);
 	daccon = devpriv->ao_bipolar ? PCI230_DAC_OR_BIP : PCI230_DAC_OR_UNI;
 	/* Use DAC FIFO for hardware version 2 onwards. */
 	if (devpriv->hwver >= 2) {
@@ -1514,7 +1508,7 @@ static int pci230_ai_check_chanlist(struct comedi_device *dev,
 	unsigned int prev_chan = 0;
 	unsigned int prev_range = 0;
 	unsigned int prev_aref = 0;
-	unsigned int prev_polarity = 0;
+	bool prev_bipolar = false;
 	unsigned int subseq_len = 0;
 	int i;
 
@@ -1523,7 +1517,7 @@ static int pci230_ai_check_chanlist(struct comedi_device *dev,
 		unsigned int chan = CR_CHAN(chanspec);
 		unsigned int range = CR_RANGE(chanspec);
 		unsigned int aref = CR_AREF(chanspec);
-		unsigned int polarity = pci230_ai_bipolar[range];
+		bool bipolar = comedi_range_is_bipolar(s, range);
 
 		if (aref == AREF_DIFF && chan >= max_diff_chan) {
 			dev_dbg(dev->class_dev,
@@ -1555,7 +1549,7 @@ static int pci230_ai_check_chanlist(struct comedi_device *dev,
 				return -EINVAL;
 			}
 
-			if (polarity != prev_polarity) {
+			if (bipolar != prev_bipolar) {
 				dev_dbg(dev->class_dev,
 					"%s: channel sequence ranges must be all bipolar or all unipolar\n",
 					__func__);
@@ -1573,7 +1567,7 @@ static int pci230_ai_check_chanlist(struct comedi_device *dev,
 		prev_chan = chan;
 		prev_range = range;
 		prev_aref = aref;
-		prev_polarity = polarity;
+		prev_bipolar = bipolar;
 	}
 
 	if (subseq_len == 0)
@@ -2296,7 +2290,7 @@ static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	}
 
 	range = CR_RANGE(cmd->chanlist[0]);
-	devpriv->ai_bipolar = pci230_ai_bipolar[range];
+	devpriv->ai_bipolar = comedi_range_is_bipolar(s, range);
 	if (devpriv->ai_bipolar)
 		adccon |= PCI230_ADC_IR_BIP;
 	else
-- 
2.0.4

