Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251AbaD2Iid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:38:33 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:48225 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbaD2Ii3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:38:29 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 6/6 v2] staging: comedi: addi_apci_1564: remove use of devpriv->s_EeParameters
Date: Tue, 29 Apr 2014 03:38:20 -0500
Message-Id: <1398760700-19397-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398562711-6313-1-git-send-email-chase.southwood@gmail.com>
References: <1398562711-6313-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver no longer reads the eeprom to find the board specific data,
all the necessary data is in the boardinfo. Use the boardinfo directly
instead of passing through devpriv->s_EeParameters.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
2: Incorrect patch title fixed.

Ian and Hartley,

The auto_attach() function is starting to look much better now.  My next patchset
will be geared towards only allocating subdevices which are actually used.

Thanks,
Chase

 drivers/staging/comedi/drivers/addi_apci_1564.c | 27 +++++--------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index d5be8d3..b34ae34 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -65,22 +65,6 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 	dev->iobase = pci_resource_start(pcidev, 2);
 	devpriv->i_IobaseAmcc = pci_resource_start(pcidev, 1);
 
-	/* Initialize parameters that can be overridden in EEPROM */
-	devpriv->s_EeParameters.i_NbrAiChannel = this_board->i_NbrAiChannel;
-	devpriv->s_EeParameters.i_NbrAoChannel = this_board->i_NbrAoChannel;
-	devpriv->s_EeParameters.i_AiMaxdata = this_board->i_AiMaxdata;
-	devpriv->s_EeParameters.i_AoMaxdata = this_board->i_AoMaxdata;
-	devpriv->s_EeParameters.i_NbrDiChannel = this_board->i_NbrDiChannel;
-	devpriv->s_EeParameters.i_NbrDoChannel = this_board->i_NbrDoChannel;
-	devpriv->s_EeParameters.i_DoMaxdata = this_board->i_DoMaxdata;
-	devpriv->s_EeParameters.i_Timer = this_board->i_Timer;
-	devpriv->s_EeParameters.ui_MinAcquisitiontimeNs =
-		this_board->ui_MinAcquisitiontimeNs;
-	devpriv->s_EeParameters.ui_MinDelaytimeNs =
-		this_board->ui_MinDelaytimeNs;
-
-	/* ## */
-
 	if (pcidev->irq > 0) {
 		ret = request_irq(pcidev->irq, v_ADDI_Interrupt, IRQF_SHARED,
 				  dev->board_name, dev);
@@ -114,14 +98,13 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 
 	/*  Allocate and Initialise DO Subdevice Structures */
 	s = &dev->subdevices[3];
-	if (devpriv->s_EeParameters.i_NbrDoChannel) {
+	if (this_board->i_NbrDoChannel) {
 		s->type = COMEDI_SUBD_DO;
 		s->subdev_flags =
 			SDF_READABLE | SDF_WRITEABLE | SDF_GROUND | SDF_COMMON;
-		s->n_chan = devpriv->s_EeParameters.i_NbrDoChannel;
-		s->maxdata = devpriv->s_EeParameters.i_DoMaxdata;
-		s->len_chanlist =
-			devpriv->s_EeParameters.i_NbrDoChannel;
+		s->n_chan = this_board->i_NbrDoChannel;
+		s->maxdata = this_board->i_DoMaxdata;
+		s->len_chanlist = this_board->i_NbrDoChannel;
 		s->range_table = &range_digital;
 
 		/* insn_config - for digital output memory */
@@ -135,7 +118,7 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 
 	/*  Allocate and Initialise Timer Subdevice Structures */
 	s = &dev->subdevices[4];
-	if (devpriv->s_EeParameters.i_Timer) {
+	if (this_board->i_Timer) {
 		s->type = COMEDI_SUBD_TIMER;
 		s->subdev_flags = SDF_WRITEABLE | SDF_GROUND | SDF_COMMON;
 		s->n_chan = 1;
-- 
1.9.0

