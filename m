Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaECH4q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 03:56:46 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:48010 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbaECH4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 03:56:45 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 2/4] staging: comedi: addi_apci_1564: don't allocate unused subdevices
Date: Sat,  3 May 2014 02:56:27 -0500
Message-Id: <1399103787-15547-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399103661-14853-1-git-send-email-chase.southwood@gmail.com>
References: <1399103661-14853-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The addi-data common code always allocates 7 subdevices.  This driver
cannot or will not use the ones we are currently allocating for analog
input and output or EEPROM, so just don't allocate these subdevices at
all.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi_apci_1564.c | 27 +++++--------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 25149b2..31b687c 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -47,7 +47,7 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 	const struct addi_board *this_board = comedi_board(dev);
 	struct addi_private *devpriv;
 	struct comedi_subdevice *s;
-	int ret, n_subdevices;
+	int ret;
 
 	dev->board_name = this_board->pc_DriverName;
 
@@ -69,21 +69,12 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 			dev->irq = pcidev->irq;
 	}
 
-	n_subdevices = 7;
-	ret = comedi_alloc_subdevices(dev, n_subdevices);
+	ret = comedi_alloc_subdevices(dev, 3);
 	if (ret)
 		return ret;
 
-	/*  Allocate and Initialise AI Subdevice Structures */
-	s = &dev->subdevices[0];
-	s->type = COMEDI_SUBD_UNUSED;
-
-	/*  Allocate and Initialise AO Subdevice Structures */
-	s = &dev->subdevices[1];
-	s->type = COMEDI_SUBD_UNUSED;
-
 	/*  Allocate and Initialise DI Subdevice Structures */
-	s = &dev->subdevices[2];
+	s = &dev->subdevices[0];
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
 	s->n_chan = 32;
@@ -94,7 +85,7 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 	s->insn_bits = apci1564_di_insn_bits;
 
 	/*  Allocate and Initialise DO Subdevice Structures */
-	s = &dev->subdevices[3];
+	s = &dev->subdevices[1];
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITEABLE;
 	s->n_chan = 32;
@@ -106,7 +97,7 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 	s->insn_read = apci1564_do_read;
 
 	/*  Allocate and Initialise Timer Subdevice Structures */
-	s = &dev->subdevices[4];
+	s = &dev->subdevices[2];
 	if (this_board->i_Timer) {
 		s->type = COMEDI_SUBD_TIMER;
 		s->subdev_flags = SDF_WRITEABLE | SDF_GROUND | SDF_COMMON;
@@ -123,14 +114,6 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	/*  Allocate and Initialise TTL */
-	s = &dev->subdevices[5];
-	s->type = COMEDI_SUBD_UNUSED;
-
-	/* EEPROM */
-	s = &dev->subdevices[6];
-	s->type = COMEDI_SUBD_UNUSED;
-
 	i_ADDI_Reset(dev);
 	return 0;
 }
-- 
1.9.0

