Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaIALJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:09:17 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39023 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbaIALEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:21 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/28] staging: comedi: amplc_pci230: remove ao_chans member
Date: Mon,  1 Sep 2014 12:03:44 +0100
Message-Id: <1409569440-10979-13-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI230(+) has an AO subdevice with 2 channels, but the PCI260(+) has
none.

The `ao_chans` member of `struct pci230_board` indicates whether the
board has an AO subdevice and the number of AO channels.  The
`ao_bits` member indicates the AO sample width in bits and will only be
non-zero for boards with an AO subdevice.

Use `ao_bits` to indicate whether the board has an AO subdevice.  If it
has, assume the the number of AO channels is 2.  Then the `ao_chans`
member becomes redundant and can be removed.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 42a79d2..75b0e79 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -455,7 +455,6 @@ struct pci230_board {
 	const char *name;
 	unsigned short id;
 	int ai_bits;
-	int ao_chans;
 	int ao_bits;
 	int have_dio;
 	unsigned int min_hwver;	/* Minimum hardware version supported. */
@@ -466,7 +465,6 @@ static const struct pci230_board pci230_boards[] = {
 		.name		= "pci230+",
 		.id		= PCI_DEVICE_ID_PCI230,
 		.ai_bits	= 16,
-		.ao_chans	= 2,
 		.ao_bits	= 12,
 		.have_dio	= 1,
 		.min_hwver	= 1,
@@ -481,7 +479,6 @@ static const struct pci230_board pci230_boards[] = {
 		.name		= "pci230",
 		.id		= PCI_DEVICE_ID_PCI230,
 		.ai_bits	= 12,
-		.ao_chans	= 2,
 		.ao_bits	= 12,
 		.have_dio	= 1,
 	},
@@ -2609,7 +2606,7 @@ static int pci230_auto_attach(struct comedi_device *dev,
 				 */
 				extfunc |= PCI230P_EXTFUNC_GAT_EXTTRIG;
 			}
-			if (thisboard->ao_chans > 0 && devpriv->hwver >= 2) {
+			if (thisboard->ao_bits && devpriv->hwver >= 2) {
 				/* Enable DAC FIFO functionality. */
 				extfunc |= PCI230P2_EXTFUNC_DACFIFO;
 			}
@@ -2670,15 +2667,15 @@ static int pci230_auto_attach(struct comedi_device *dev,
 
 	s = &dev->subdevices[1];
 	/* analog output subdevice */
-	if (thisboard->ao_chans > 0) {
+	if (thisboard->ao_bits) {
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_WRITABLE | SDF_GROUND;
-		s->n_chan = thisboard->ao_chans;
+		s->n_chan = 2;
 		s->maxdata = (1 << thisboard->ao_bits) - 1;
 		s->range_table = &pci230_ao_range;
 		s->insn_write = pci230_ao_insn_write;
 		s->insn_read = comedi_readback_insn_read;
-		s->len_chanlist = thisboard->ao_chans;
+		s->len_chanlist = 2;
 		if (dev->irq) {
 			dev->write_subdev = s;
 			s->subdev_flags |= SDF_CMD_WRITE;
-- 
2.0.4

