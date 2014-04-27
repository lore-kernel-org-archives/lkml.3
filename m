Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaD0BgQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 21:36:16 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:56457 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbaD0BgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 21:36:14 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 1/6] staging: comedi: addi_apci_1564: remove eeprom support code
Date: Sat, 26 Apr 2014 20:35:58 -0500
Message-Id: <1398562558-5354-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading the eeprom on this board is not necessary.  All information
required is in the boardinfo.

Remove the eeprom support code which is not really useful here.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi_apci_1564.c | 46 +------------------------
 1 file changed, 1 insertion(+), 45 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 5f6d3b5..df8833b 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -7,7 +7,6 @@
 
 #include "addi-data/addi_common.h"
 
-#include "addi-data/addi_eeprom.c"
 #include "addi-data/hwdrv_apci1564.c"
 
 static const struct addi_board apci1564_boardtypes[] = {
@@ -33,23 +32,6 @@ static const struct addi_board apci1564_boardtypes[] = {
 	},
 };
 
-static int i_ADDIDATA_InsnReadEeprom(struct comedi_device *dev,
-				     struct comedi_subdevice *s,
-				     struct comedi_insn *insn,
-				     unsigned int *data)
-{
-	const struct addi_board *this_board = comedi_board(dev);
-	struct addi_private *devpriv = dev->private;
-	unsigned short w_Address = CR_CHAN(insn->chanspec);
-	unsigned short w_Data;
-
-	w_Data = addi_eeprom_readw(devpriv->i_IobaseAmcc,
-		this_board->pc_EepromChip, 2 * w_Address);
-	data[0] = w_Data;
-
-	return insn->n;
-}
-
 static irqreturn_t v_ADDI_Interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
@@ -75,7 +57,6 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 	struct addi_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret, n_subdevices;
-	unsigned int dw_Dummy;
 
 	dev->board_name = this_board->pc_DriverName;
 
@@ -120,23 +101,6 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 			dev->irq = pcidev->irq;
 	}
 
-	/*  Read eepeom and fill addi_board Structure */
-
-	if (this_board->i_PCIEeprom) {
-		if (!(strcmp(this_board->pc_EepromChip, "S5920"))) {
-			/*  Set 3 wait stait */
-			if (!(strcmp(dev->board_name, "apci035")))
-				outl(0x80808082, devpriv->i_IobaseAmcc + 0x60);
-			else
-				outl(0x83838383, devpriv->i_IobaseAmcc + 0x60);
-
-			/*  Enable the interrupt for the controller */
-			dw_Dummy = inl(devpriv->i_IobaseAmcc + 0x38);
-			outl(dw_Dummy | 0x2000, devpriv->i_IobaseAmcc + 0x38);
-		}
-		addi_eeprom_read_info(dev, pci_resource_start(pcidev, 0));
-	}
-
 	n_subdevices = 7;
 	ret = comedi_alloc_subdevices(dev, n_subdevices);
 	if (ret)
@@ -212,15 +176,7 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 
 	/* EEPROM */
 	s = &dev->subdevices[6];
-	if (this_board->i_PCIEeprom) {
-		s->type = COMEDI_SUBD_MEMORY;
-		s->subdev_flags = SDF_READABLE | SDF_INTERNAL;
-		s->n_chan = 256;
-		s->maxdata = 0xffff;
-		s->insn_read = i_ADDIDATA_InsnReadEeprom;
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
+	s->type = COMEDI_SUBD_UNUSED;
 
 	i_ADDI_Reset(dev);
 	return 0;
-- 
1.9.0

