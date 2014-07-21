Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbaGUNxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:53:55 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:59020 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbaGUNxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:53:54 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: ni_65xx: don't invert outputs by default
Date: Mon, 21 Jul 2014 14:53:31 +0100
Message-Id: <1405950811-5200-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver currently inverts the outputs for the DO (digital output)
subdevice for some of the boards it supports, indicated by the
`invert_outputs` member in the board-specific data being initialized to
1.  It seems this driver shouldn't really be inverting outputs for these
boards at all, but has done so since the driver was first written back
in October 2006.  I've had confirmation that for the PCI-6515 at least,
the output voltage levels are opposite to the values set by the user
program.

The driver by Jon Grierson originally supported only PCI-6514 and
PXI-6514 (and was originally called "ni_6514").  The driver was based on
"ni_6527", which is where the inversion of outputs appears to have come
from.  Over a period of a few days, the driver was enhanced by Frank
Mori Hess to support other boards.  Some of these plainly didn't require
inverted outputs and some guesswork was used to decide which boards
should have inverted outputs.  Some of the boards in question are
described in the manual as having "Sink Outputs" and others are
described as having "Source Outputs", but this does not correspond in
any way with which boards are marked as having inverted outputs, so the
criterion that Frank used is a bit of a mystery!

Change the driver so it doesn't invert the outputs of these by boards by
default, but add a module parameter, "legacy_invert_outputs", that can
be set to 'true' to restore the old behaviour.  Also rename the
`invert_outputs` member of `struct ni_65xx_board` to `legacy_invert`.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_65xx.c | 47 ++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index cad2c28..aba6fbb 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -47,13 +47,21 @@
  *	    (National Instruments) PXI-6521 [ni_65xx]
  *	    (National Instruments) PCI-6528 [ni_65xx]
  *	    (National Instruments) PXI-6528 [ni_65xx]
- * Updated: Wed Oct 18 08:59:11 EDT 2006
+ * Updated: Mon, 21 Jul 2014 12:49:58 +0000
  *
  * Configuration Options: not applicable, uses PCI auto config
  *
  * Based on the PCI-6527 driver by ds.
  * The interrupt subdevice (subdevice 3) is probably broken for all
  * boards except maybe the 6514.
+ *
+ * This driver previously inverted the outputs on PCI-6513 through to
+ * PCI-6519 and on PXI-6513 through to PXI-6515.  It no longer inverts
+ * outputs on those cards by default as it didn't make much sense.  If
+ * you require the outputs to be inverted on those cards for legacy
+ * reasons, set the module parameter "legacy_invert_outputs=true" when
+ * loading the module, or set "ni_65xx.legacy_invert_outputs=true" on
+ * the kernel command line if the driver is built in to the kernel.
  */
 
 /*
@@ -163,7 +171,7 @@ struct ni_65xx_board {
 	unsigned num_dio_ports;
 	unsigned num_di_ports;
 	unsigned num_do_ports;
-	unsigned invert_outputs:1;
+	unsigned legacy_invert:1;
 };
 
 static const struct ni_65xx_board ni_65xx_boards[] = {
@@ -198,58 +206,58 @@ static const struct ni_65xx_board ni_65xx_boards[] = {
 	[BOARD_PCI6513] = {
 		.name		= "pci-6513",
 		.num_do_ports	= 8,
-		.invert_outputs	= 1,
+		.legacy_invert	= 1,
 	},
 	[BOARD_PXI6513] = {
 		.name		= "pxi-6513",
 		.num_do_ports	= 8,
-		.invert_outputs	= 1,
+		.legacy_invert	= 1,
 	},
 	[BOARD_PCI6514] = {
 		.name		= "pci-6514",
 		.num_di_ports	= 4,
 		.num_do_ports	= 4,
-		.invert_outputs	= 1,
+		.legacy_invert	= 1,
 	},
 	[BOARD_PXI6514] = {
 		.name		= "pxi-6514",
 		.num_di_ports	= 4,
 		.num_do_ports	= 4,
-		.invert_outputs	= 1,
+		.legacy_invert	= 1,
 	},
 	[BOARD_PCI6515] = {
 		.name		= "pci-6515",
 		.num_di_ports	= 4,
 		.num_do_ports	= 4,
-		.invert_outputs	= 1,
+		.legacy_invert	= 1,
 	},
 	[BOARD_PXI6515] = {
 		.name		= "pxi-6515",
 		.num_di_ports	= 4,
 		.num_do_ports	= 4,
-		.invert_outputs	= 1,
+		.legacy_invert	= 1,
 	},
 	[BOARD_PCI6516] = {
 		.name		= "pci-6516",
 		.num_do_ports	= 4,
-		.invert_outputs	= 1,
+		.legacy_invert	= 1,
 	},
 	[BOARD_PCI6517] = {
 		.name		= "pci-6517",
 		.num_do_ports	= 4,
-		.invert_outputs	= 1,
+		.legacy_invert	= 1,
 	},
 	[BOARD_PCI6518] = {
 		.name		= "pci-6518",
 		.num_di_ports	= 2,
 		.num_do_ports	= 2,
-		.invert_outputs	= 1,
+		.legacy_invert	= 1,
 	},
 	[BOARD_PCI6519] = {
 		.name		= "pci-6519",
 		.num_di_ports	= 2,
 		.num_do_ports	= 2,
-		.invert_outputs	= 1,
+		.legacy_invert	= 1,
 	},
 	[BOARD_PCI6520] = {
 		.name		= "pci-6520",
@@ -278,6 +286,12 @@ static const struct ni_65xx_board ni_65xx_boards[] = {
 	},
 };
 
+static bool ni_65xx_legacy_invert_outputs;
+module_param_named(legacy_invert_outputs, ni_65xx_legacy_invert_outputs,
+		   bool, 0444);
+MODULE_PARM_DESC(legacy_invert_outputs,
+		 "invert outputs of PCI/PXI-6513/6514/6515/6516/6517/6518/6519 for compatibility with old user code");
+
 struct ni_65xx_private {
 	void __iomem *mmio;
 };
@@ -670,8 +684,13 @@ static int ni_65xx_auto_attach(struct comedi_device *dev,
 		/* the output ports always start after the input ports */
 		s->private = (void *)(unsigned long)board->num_di_ports;
 
-		/* use the io_bits to handle the inverted outputs */
-		s->io_bits	= (board->invert_outputs) ? 0xff : 0x00;
+		/*
+		 * Use the io_bits to handle the inverted outputs.  Inverted
+		 * outputs are only supported if the "legacy_invert_outputs"
+		 * module parameter is set to "true".
+		 */
+		if (ni_65xx_legacy_invert_outputs && board->legacy_invert)
+			s->io_bits = 0xff;
 
 		/* reset all output ports to comedi '0' */
 		for (i = 0; i < board->num_do_ports; ++i) {
-- 
2.0.0

