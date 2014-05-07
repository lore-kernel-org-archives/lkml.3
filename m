Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbaEGHEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 03:04:09 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:35042 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaEGHEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 03:04:07 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 1/2] staging: comedi: addi_apci_1564: remove check for timer subdevice
Date: Wed,  7 May 2014 02:03:32 -0500
Message-Id: <1399446212-30465-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399446163-30234-1-git-send-email-chase.southwood@gmail.com>
References: <1399446163-30234-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only board served by this driver always has a timer, so we can init
the timer subdevice without checking first.

The boardinfo about the timer can also be removed and the data used
directly.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi_apci_1564.c | 27 +++++++++----------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 86276cd..d7a5c2f 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -15,9 +15,6 @@ static const struct addi_board apci1564_boardtypes[] = {
 		.i_NbrDoChannel		= 32,
 		.i_DoMaxdata		= 0xffffffff,
 		.i_Timer		= 1,
-		.timer_config		= apci1564_timer_config,
-		.timer_write		= apci1564_timer_write,
-		.timer_read		= apci1564_timer_read,
 	},
 };
 
@@ -119,21 +116,15 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 
 	/*  Allocate and Initialise Timer Subdevice Structures */
 	s = &dev->subdevices[2];
-	if (this_board->i_Timer) {
-		s->type = COMEDI_SUBD_TIMER;
-		s->subdev_flags = SDF_WRITEABLE | SDF_GROUND | SDF_COMMON;
-		s->n_chan = 1;
-		s->maxdata = 0;
-		s->len_chanlist = 1;
-		s->range_table = &range_digital;
-
-		s->insn_write = this_board->timer_write;
-		s->insn_read = this_board->timer_read;
-		s->insn_config = this_board->timer_config;
-		s->insn_bits = this_board->timer_bits;
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
+	s->type = COMEDI_SUBD_TIMER;
+	s->subdev_flags = SDF_WRITEABLE;
+	s->n_chan = 1;
+	s->maxdata = 0;
+	s->len_chanlist = 1;
+	s->range_table = &range_digital;
+	s->insn_write = apci1564_timer_write;
+	s->insn_read = apci1564_timer_read;
+	s->insn_config = apci1564_timer_config;
 
 	return 0;
 }
-- 
1.9.0

