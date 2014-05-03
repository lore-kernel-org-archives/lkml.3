Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaECHzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 03:55:39 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:39528 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaECHzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 03:55:38 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 1/4] staging: comedi: addi_apci_1564: board has 32 digital outputs
Date: Sat,  3 May 2014 02:55:29 -0500
Message-Id: <1399103729-15150-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399103661-14853-1-git-send-email-chase.southwood@gmail.com>
References: <1399103661-14853-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This board always has 32 digital outputs.  Remove the test when
initializing the subdevice.

Also, since this board is the only one supported by this driver, remove
the boardinfo about the digital outputs and just use the data directly in
the subdevice init.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi_apci_1564.c | 29 ++++++++-----------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index ea22530..25149b2 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -17,9 +17,6 @@ static const struct addi_board apci1564_boardtypes[] = {
 		.i_Timer		= 1,
 		.interrupt		= apci1564_interrupt,
 		.reset			= apci1564_reset,
-		.do_config		= apci1564_do_config,
-		.do_bits		= apci1564_do_insn_bits,
-		.do_read		= apci1564_do_read,
 		.timer_config		= apci1564_timer_config,
 		.timer_write		= apci1564_timer_write,
 		.timer_read		= apci1564_timer_read,
@@ -98,23 +95,15 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 
 	/*  Allocate and Initialise DO Subdevice Structures */
 	s = &dev->subdevices[3];
-	if (this_board->i_NbrDoChannel) {
-		s->type = COMEDI_SUBD_DO;
-		s->subdev_flags =
-			SDF_READABLE | SDF_WRITEABLE | SDF_GROUND | SDF_COMMON;
-		s->n_chan = this_board->i_NbrDoChannel;
-		s->maxdata = this_board->i_DoMaxdata;
-		s->len_chanlist = this_board->i_NbrDoChannel;
-		s->range_table = &range_digital;
-
-		/* insn_config - for digital output memory */
-		s->insn_config = this_board->do_config;
-		s->insn_write = this_board->do_write;
-		s->insn_bits = this_board->do_bits;
-		s->insn_read = this_board->do_read;
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
+	s->type = COMEDI_SUBD_DO;
+	s->subdev_flags = SDF_WRITEABLE;
+	s->n_chan = 32;
+	s->maxdata = 0xffffffff;
+	s->len_chanlist = 32;
+	s->range_table = &range_digital;
+	s->insn_config = apci1564_do_config;
+	s->insn_bits = apci1564_do_insn_bits;
+	s->insn_read = apci1564_do_read;
 
 	/*  Allocate and Initialise Timer Subdevice Structures */
 	s = &dev->subdevices[4];
-- 
1.9.0

