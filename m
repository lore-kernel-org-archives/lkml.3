Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3EMLC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 07:02:29 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57976 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab3EMLC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 07:02:28 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: ni_labpc: fix VIRT_TO_BUS dependency
Date: Mon, 13 May 2013 12:02:15 +0100
Message-Id: <1368442935-25926-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <5190B62C.1070704@mev.co.uk>
References: <5190B62C.1070704@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "ni_labpc" module acts as a low-level comedi driver for various
Nattional Instruments Lab-PC ISA cards if `CONFIG_NI_LABPC_ISA` is
enabled, and also as a common module depended on by the "ni_labpc_cs"
and "ni_labpc_pci" modules.  For ISA cards, it optionally supports the
use of an ISA DMA channel if `CONFIG_ISA_DMA_API` is enabled, using
conditionally compiled code.  This conditionally compiled code also
relies on `virt_to_bus()`, which only exists if `CONFIG_VIRT_TO_BUS` is
enabled.  Therefore, support for ISA DMA should only be compiled in if
both `CONFIG_ISA_DMA_API` and `CONFIG_VIRT_TO_BUS` are defined,
otherwise the "ni_labpc" module fails to compile on kernels that enable
`CONFIG_ISA_DMA_API` but not `CONFIG_VIRT_TO_BUS`.

Conditionally define a new macro `NI_LABPC_ISA_DMA` iff both
`CONFIG_ISA_DMA_API` and `CONFIG_VIRT_TO_BUS` are defined, and change
the conditional compilation tests to use the new macro instead of
`CONFIG_ISA_DMA_API`.

Also, in the "Kconfig", remove the `VIRT_TO_BUS` dependency from the
`COMEDI_NI_LABPC_ISA` option since the dependency is now checked at
compile time.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/Kconfig            |  1 -
 drivers/staging/comedi/drivers/ni_labpc.c | 18 +++++++++++-------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 7871579..c55a79d 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -487,7 +487,6 @@ config COMEDI_NI_ATMIO16D
 config COMEDI_NI_LABPC_ISA
 	tristate "NI Lab-PC and compatibles ISA support"
 	select COMEDI_NI_LABPC
-	depends on VIRT_TO_BUS
 	---help---
 	  Enable support for National Instruments Lab-PC and compatibles
 	  Lab-PC-1200, Lab-PC-1200AI, Lab-PC+.
diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 3d978f3..5078be7 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -75,6 +75,10 @@
 #include "comedi_fc.h"
 #include "ni_labpc.h"
 
+#if defined(CONFIG_ISA_DMA_API) && defined(CONFIG_VIRT_TO_BUS)
+#define NI_LABPC_ISA_DMA
+#endif
+
 /*
  * Register map (all registers are 8-bit)
  */
@@ -465,7 +469,7 @@ static int labpc_ai_insn_read(struct comedi_device *dev,
 	return insn->n;
 }
 
-#ifdef CONFIG_ISA_DMA_API
+#ifdef NI_LABPC_ISA_DMA
 /* utility function that suggests a dma transfer size in bytes */
 static unsigned int labpc_suggest_transfer_size(const struct comedi_cmd *cmd)
 {
@@ -883,7 +887,7 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		return ret;
 	}
 
-#ifdef CONFIG_ISA_DMA_API
+#ifdef NI_LABPC_ISA_DMA
 	/*  figure out what method we will use to transfer data */
 	if (devpriv->dma_chan &&	/*  need a dma channel allocated */
 		/*
@@ -966,7 +970,7 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	labpc_clear_adc_fifo(dev);
 
-#ifdef CONFIG_ISA_DMA_API
+#ifdef NI_LABPC_ISA_DMA
 	/*  set up dma transfer */
 	if (xfer == isa_dma_transfer) {
 		unsigned long irq_flags;
@@ -1041,7 +1045,7 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	return 0;
 }
 
-#ifdef CONFIG_ISA_DMA_API
+#ifdef NI_LABPC_ISA_DMA
 static void labpc_drain_dma(struct comedi_device *dev)
 {
 	struct labpc_private *devpriv = dev->private;
@@ -1145,7 +1149,7 @@ static int labpc_drain_fifo(struct comedi_device *dev)
  * when acquisition is terminated by stop_src == TRIG_EXT). */
 static void labpc_drain_dregs(struct comedi_device *dev)
 {
-#ifdef CONFIG_ISA_DMA_API
+#ifdef NI_LABPC_ISA_DMA
 	struct labpc_private *devpriv = dev->private;
 
 	if (devpriv->current_transfer == isa_dma_transfer)
@@ -1195,7 +1199,7 @@ static irqreturn_t labpc_interrupt(int irq, void *d)
 		return IRQ_HANDLED;
 	}
 
-#ifdef CONFIG_ISA_DMA_API
+#ifdef NI_LABPC_ISA_DMA
 	if (devpriv->current_transfer == isa_dma_transfer) {
 		/*
 		 * if a dma terminal count of external stop trigger
@@ -1731,7 +1735,7 @@ static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-#ifdef CONFIG_ISA_DMA_API
+#ifdef NI_LABPC_ISA_DMA
 	if (dev->irq && (dma_chan == 1 || dma_chan == 3)) {
 		devpriv->dma_buffer = kmalloc(dma_buffer_size,
 					      GFP_KERNEL | GFP_DMA);
-- 
1.8.1.5

