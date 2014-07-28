Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaG1MKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:10:33 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49029 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbaG1MJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:09:51 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] staging: comedi: amplc_pc236: split into ISA, PCI and common module
Date: Mon, 28 Jul 2014 13:09:34 +0100
Message-Id: <1406549375-1864-7-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406549375-1864-1-git-send-email-abbotti@mev.co.uk>
References: <1406549375-1864-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "amplc_pc236" driver currently handles both ISA and PCI devices and
uses a small amount of conditional compilation depending which are
enabled.

Move most of the functionality into a new module, "amplc_pc236_common",
and split off support for PCI devices into a new module, "amplc_pci236".
Retain support for ISA devices in the existing module, "amplc_pc236".

Since the `detach` handler (`pc236_detach()`) in the existing module
"amplc_pc236" now only needs to handle ISA devices and only calls
`comedi_legacy_detach()`, just use `comedi_legacy_detach()` directly as
the `detach` handler in `struct comedi_driver amplc_pc236_driver`.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/Kconfig                     |   2 +-
 drivers/staging/comedi/drivers/Makefile            |   4 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       | 363 +--------------------
 drivers/staging/comedi/drivers/amplc_pc236.h       |  45 +++
 .../staging/comedi/drivers/amplc_pc236_common.c    | 206 ++++++++++++
 drivers/staging/comedi/drivers/amplc_pci236.c      | 162 +++++++++
 6 files changed, 429 insertions(+), 353 deletions(-)
 create mode 100644 drivers/staging/comedi/drivers/amplc_pc236.h
 create mode 100644 drivers/staging/comedi/drivers/amplc_pc236_common.c
 create mode 100644 drivers/staging/comedi/drivers/amplc_pci236.c

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 341fc07..36f2c71 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -815,7 +815,7 @@ config COMEDI_AMPLC_PC236_PCI
 	  Enable support for Amplicon PCI236 DIO board.
 
 	  To compile this driver as a module, choose M here: the module will be
-	  called amplc_pc236.
+	  called amplc_pci236.
 
 config COMEDI_AMPLC_PC263_PCI
 	tristate "Amplicon PCI263 relay board support"
diff --git a/drivers/staging/comedi/drivers/Makefile b/drivers/staging/comedi/drivers/Makefile
index 0757a82..8873d48 100644
--- a/drivers/staging/comedi/drivers/Makefile
+++ b/drivers/staging/comedi/drivers/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_COMEDI_SKEL)		+= skel.o
 
 # Comedi ISA drivers
 obj-$(CONFIG_COMEDI_AMPLC_DIO200_ISA)	+= amplc_dio200.o
+obj-$(CONFIG_COMEDI_AMPLC_PC236_ISA)	+= amplc_pc236.o
 obj-$(CONFIG_COMEDI_AMPLC_PC263_ISA)	+= amplc_pc263.o
 obj-$(CONFIG_COMEDI_PCL711)		+= pcl711.o
 obj-$(CONFIG_COMEDI_PCL724)		+= pcl724.o
@@ -80,7 +81,7 @@ obj-$(CONFIG_COMEDI_ADV_PCI1723)	+= adv_pci1723.o
 obj-$(CONFIG_COMEDI_ADV_PCI1724)	+= adv_pci1724.o
 obj-$(CONFIG_COMEDI_ADV_PCI_DIO)	+= adv_pci_dio.o
 obj-$(CONFIG_COMEDI_AMPLC_DIO200_PCI)	+= amplc_dio200_pci.o
-obj-$(CONFIG_COMEDI_AMPLC_PC236)	+= amplc_pc236.o
+obj-$(CONFIG_COMEDI_AMPLC_PC236_PCI)	+= amplc_pci236.o
 obj-$(CONFIG_COMEDI_AMPLC_PC263_PCI)	+= amplc_pci263.o
 obj-$(CONFIG_COMEDI_AMPLC_PCI224)	+= amplc_pci224.o
 obj-$(CONFIG_COMEDI_AMPLC_PCI230)	+= amplc_pci230.o
@@ -138,5 +139,6 @@ obj-$(CONFIG_COMEDI_NI_LABPC_ISADMA)	+= ni_labpc_isadma.o
 
 obj-$(CONFIG_COMEDI_8255)		+= 8255.o
 obj-$(CONFIG_COMEDI_AMPLC_DIO200)	+= amplc_dio200_common.o
+obj-$(CONFIG_COMEDI_AMPLC_PC236)	+= amplc_pc236_common.o
 obj-$(CONFIG_COMEDI_DAS08)		+= das08.o
 obj-$(CONFIG_COMEDI_FC)			+= comedi_fc.o
diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 677911b..b95b877 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -1,6 +1,6 @@
 /*
  * comedi/drivers/amplc_pc236.c
- * Driver for Amplicon PC36AT and PCI236 DIO boards.
+ * Driver for Amplicon PC36AT DIO boards.
  *
  * Copyright (C) 2002 MEV Ltd. <http://www.mev.co.uk/>
  *
@@ -19,21 +19,17 @@
  */
 /*
  * Driver: amplc_pc236
- * Description: Amplicon PC36AT, PCI236
+ * Description: Amplicon PC36AT
  * Author: Ian Abbott <abbotti@mev.co.uk>
- * Devices: [Amplicon] PC36AT (pc36at), PCI236 (pci236)
- * Updated: Thu, 24 Jul 2014 14:25:26 +0000
+ * Devices: [Amplicon] PC36AT (pc36at)
+ * Updated: Fri, 25 Jul 2014 15:32:40 +0000
  * Status: works
  *
  * Configuration options - PC36AT:
  *   [0] - I/O port base address
  *   [1] - IRQ (optional)
  *
- * Manual configuration of PCI board (PCI236) is not supported; it is
- * configured automatically.
- *
- * The PC36AT ISA board and PCI236 PCI board have a single 8255 appearing
- * as subdevice 0.
+ * The PC36AT board has a single 8255 appearing as subdevice 0.
  *
  * Subdevice 1 pretends to be a digital input device, but it always returns
  * 0 when read. However, if you run a command with scan_begin_src=TRIG_EXT,
@@ -45,251 +41,16 @@
  */
 
 #include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/interrupt.h>
 
 #include "../comedidev.h"
 
-#include "comedi_fc.h"
-#include "8255.h"
-#include "plx9052.h"
-
-#define DO_ISA	IS_ENABLED(CONFIG_COMEDI_AMPLC_PC236_ISA)
-#define DO_PCI	IS_ENABLED(CONFIG_COMEDI_AMPLC_PC236_PCI)
-
-/* PC36AT / PCI236 registers */
-
-/* Disable, and clear, interrupts */
-#define PCI236_INTR_DISABLE	(PLX9052_INTCSR_LI1POL |	\
-				 PLX9052_INTCSR_LI2POL |	\
-				 PLX9052_INTCSR_LI1SEL |	\
-				 PLX9052_INTCSR_LI1CLRINT)
-
-/* Enable, and clear, interrupts */
-#define PCI236_INTR_ENABLE	(PLX9052_INTCSR_LI1ENAB |	\
-				 PLX9052_INTCSR_LI1POL |	\
-				 PLX9052_INTCSR_LI2POL |	\
-				 PLX9052_INTCSR_PCIENAB |	\
-				 PLX9052_INTCSR_LI1SEL |	\
-				 PLX9052_INTCSR_LI1CLRINT)
-
-/*
- * Board descriptions for Amplicon PC36AT and PCI236.
- */
-
-enum pc236_bustype { isa_bustype, pci_bustype };
-
-struct pc236_board {
-	const char *name;
-	enum pc236_bustype bustype;
-	void (*intr_update_cb)(struct comedi_device *dev, bool enable);
-	bool (*intr_chk_clr_cb)(struct comedi_device *dev);
-};
-
-struct pc236_private {
-	unsigned long lcr_iobase; /* PLX PCI9052 config registers in PCIBAR1 */
-	bool enable_irq;
-};
-
-/* test if ISA supported and this is an ISA board */
-static inline bool is_isa_board(const struct pc236_board *board)
-{
-	return DO_ISA && board->bustype == isa_bustype;
-}
-
-/* test if PCI supported and this is a PCI board */
-static inline bool is_pci_board(const struct pc236_board *board)
-{
-	return DO_PCI && board->bustype == pci_bustype;
-}
-
-static void pc236_intr_update(struct comedi_device *dev, bool enable)
-{
-	const struct pc236_board *thisboard = comedi_board(dev);
-	struct pc236_private *devpriv = dev->private;
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->spinlock, flags);
-	devpriv->enable_irq = enable;
-	if (thisboard->intr_update_cb)
-		thisboard->intr_update_cb(dev, enable);
-	spin_unlock_irqrestore(&dev->spinlock, flags);
-}
-
-/*
- * This function is called when an interrupt occurs to check whether
- * the interrupt has been marked as enabled and was generated by the
- * board.  If so, the function prepares the hardware for the next
- * interrupt.
- * Returns false if the interrupt should be ignored.
- */
-static bool pc236_intr_check(struct comedi_device *dev)
-{
-	const struct pc236_board *thisboard = comedi_board(dev);
-	struct pc236_private *devpriv = dev->private;
-	bool retval = false;
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->spinlock, flags);
-	if (devpriv->enable_irq) {
-		if (thisboard->intr_chk_clr_cb)
-			retval = thisboard->intr_chk_clr_cb(dev);
-		else
-			retval = true;
-	}
-	spin_unlock_irqrestore(&dev->spinlock, flags);
-
-	return retval;
-}
-
-/*
- * Input from subdevice 1.
- * Copied from the comedi_parport driver.
- */
-static int pc236_intr_insn(struct comedi_device *dev,
-			   struct comedi_subdevice *s, struct comedi_insn *insn,
-			   unsigned int *data)
-{
-	data[1] = 0;
-	return insn->n;
-}
-
-/*
- * Subdevice 1 command test.
- * Copied from the comedi_parport driver.
- */
-static int pc236_intr_cmdtest(struct comedi_device *dev,
-			      struct comedi_subdevice *s,
-			      struct comedi_cmd *cmd)
-{
-	int err = 0;
-
-	/* Step 1 : check if triggers are trivially valid */
-
-	err |= cfc_check_trigger_src(&cmd->start_src, TRIG_NOW);
-	err |= cfc_check_trigger_src(&cmd->scan_begin_src, TRIG_EXT);
-	err |= cfc_check_trigger_src(&cmd->convert_src, TRIG_FOLLOW);
-	err |= cfc_check_trigger_src(&cmd->scan_end_src, TRIG_COUNT);
-	err |= cfc_check_trigger_src(&cmd->stop_src, TRIG_NONE);
-
-	if (err)
-		return 1;
-
-	/* Step 2a : make sure trigger sources are unique */
-	/* Step 2b : and mutually compatible */
-
-	if (err)
-		return 2;
-
-	/* Step 3: check it arguments are trivially valid */
-
-	err |= cfc_check_trigger_arg_is(&cmd->start_arg, 0);
-	err |= cfc_check_trigger_arg_is(&cmd->scan_begin_arg, 0);
-	err |= cfc_check_trigger_arg_is(&cmd->convert_arg, 0);
-	err |= cfc_check_trigger_arg_is(&cmd->scan_end_arg, cmd->chanlist_len);
-	err |= cfc_check_trigger_arg_is(&cmd->stop_arg, 0);
-
-	if (err)
-		return 3;
-
-	/* step 4: ignored */
-
-	if (err)
-		return 4;
-
-	return 0;
-}
-
-/*
- * Subdevice 1 command.
- */
-static int pc236_intr_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
-{
-	pc236_intr_update(dev, true);
-
-	return 0;
-}
-
-/*
- * Subdevice 1 cancel command.
- */
-static int pc236_intr_cancel(struct comedi_device *dev,
-			     struct comedi_subdevice *s)
-{
-	pc236_intr_update(dev, false);
-
-	return 0;
-}
-
-/*
- * Interrupt service routine.
- * Based on the comedi_parport driver.
- */
-static irqreturn_t pc236_interrupt(int irq, void *d)
-{
-	struct comedi_device *dev = d;
-	struct comedi_subdevice *s = dev->read_subdev;
-	bool handled;
-
-	handled = pc236_intr_check(dev);
-	if (dev->attached && handled) {
-		comedi_buf_put(s, 0);
-		s->async->events |= COMEDI_CB_BLOCK | COMEDI_CB_EOS;
-		comedi_event(dev, s);
-	}
-	return IRQ_RETVAL(handled);
-}
-
-static int pc236_common_attach(struct comedi_device *dev, unsigned long iobase,
-			       unsigned int irq, unsigned long req_irq_flags)
-{
-	struct comedi_subdevice *s;
-	int ret;
-
-	dev->iobase = iobase;
-
-	ret = comedi_alloc_subdevices(dev, 2);
-	if (ret)
-		return ret;
-
-	s = &dev->subdevices[0];
-	/* digital i/o subdevice (8255) */
-	ret = subdev_8255_init(dev, s, NULL, iobase);
-	if (ret)
-		return ret;
-
-	s = &dev->subdevices[1];
-	dev->read_subdev = s;
-	s->type = COMEDI_SUBD_UNUSED;
-	pc236_intr_update(dev, false);
-	if (irq) {
-		if (request_irq(irq, pc236_interrupt, req_irq_flags,
-				dev->board_name, dev) >= 0) {
-			dev->irq = irq;
-			s->type = COMEDI_SUBD_DI;
-			s->subdev_flags = SDF_READABLE | SDF_CMD_READ;
-			s->n_chan = 1;
-			s->maxdata = 1;
-			s->range_table = &range_digital;
-			s->insn_bits = pc236_intr_insn;
-			s->len_chanlist	= 1;
-			s->do_cmdtest = pc236_intr_cmdtest;
-			s->do_cmd = pc236_intr_cmd;
-			s->cancel = pc236_intr_cancel;
-		}
-	}
-
-	return 0;
-}
+#include "amplc_pc236.h"
 
 static int pc236_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct pc236_private *devpriv;
 	int ret;
 
-	if (!DO_ISA)
-		return -EINVAL;
-
 	devpriv = comedi_alloc_devpriv(dev, sizeof(*devpriv));
 	if (!devpriv)
 		return -ENOMEM;
@@ -298,82 +59,10 @@ static int pc236_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	return pc236_common_attach(dev, dev->iobase, it->options[1], 0);
-}
-
-static void pci236_intr_update_cb(struct comedi_device *dev, bool enable)
-{
-	struct pc236_private *devpriv = dev->private;
-
-	/* this will also clear the "local interrupt 1" latch */
-	outl(enable ? PCI236_INTR_ENABLE : PCI236_INTR_DISABLE,
-	     devpriv->lcr_iobase + PLX9052_INTCSR);
-}
-
-static bool pci236_intr_chk_clr_cb(struct comedi_device *dev)
-{
-	struct pc236_private *devpriv = dev->private;
-
-	/* check if interrupt occurred */
-	if (!(inl(devpriv->lcr_iobase + PLX9052_INTCSR) &
-	      PLX9052_INTCSR_LI1STAT))
-		return false;
-	/* clear the interrupt */
-	pci236_intr_update_cb(dev, devpriv->enable_irq);
-	return true;
-}
-
-static const struct pc236_board pc236_pci_board = {
-	.name = "pci236",
-	.intr_update_cb = pci236_intr_update_cb,
-	.intr_chk_clr_cb = pci236_intr_chk_clr_cb,
-	.bustype = pci_bustype,
-};
-
-static int pc236_auto_attach(struct comedi_device *dev,
-				       unsigned long context_unused)
-{
-	struct pci_dev *pci_dev = comedi_to_pci_dev(dev);
-	struct pc236_private *devpriv;
-	unsigned long iobase;
-	int ret;
-
-	if (!DO_PCI)
-		return -EINVAL;
-
-	dev_info(dev->class_dev, "attach pci %s\n", pci_name(pci_dev));
-
-	devpriv = comedi_alloc_devpriv(dev, sizeof(*devpriv));
-	if (!devpriv)
-		return -ENOMEM;
-
-	dev->board_ptr = &pc236_pci_board;
-	dev->board_name = pc236_pci_board.name;
-	ret = comedi_pci_enable(dev);
-	if (ret)
-		return ret;
-
-	devpriv->lcr_iobase = pci_resource_start(pci_dev, 1);
-	iobase = pci_resource_start(pci_dev, 2);
-	return pc236_common_attach(dev, iobase, pci_dev->irq, IRQF_SHARED);
-}
-
-static void pc236_detach(struct comedi_device *dev)
-{
-	const struct pc236_board *thisboard = comedi_board(dev);
-
-	if (!thisboard)
-		return;
-	if (is_isa_board(thisboard)) {
-		comedi_legacy_detach(dev);
-	} else if (is_pci_board(thisboard)) {
-		if (dev->irq)
-			free_irq(dev->irq, dev);
-		comedi_pci_disable(dev);
-	}
+	return amplc_pc236_common_attach(dev, dev->iobase, it->options[1], 0);
 }
 
-static const struct pc236_board pc236_isa_boards[] = {
+static const struct pc236_board pc236_boards[] = {
 	{
 		.name = "pc36at",
 		.bustype = isa_bustype,
@@ -384,42 +73,14 @@ static struct comedi_driver amplc_pc236_driver = {
 	.driver_name = "amplc_pc236",
 	.module = THIS_MODULE,
 	.attach = pc236_attach,
-	.auto_attach = pc236_auto_attach,
-	.detach = pc236_detach,
-#if DO_ISA
-	.board_name = &pc236_isa_boards[0].name,
+	.detach = comedi_legacy_detach,
+	.board_name = &pc236_boards[0].name,
 	.offset = sizeof(struct pc236_board),
-	.num_names = ARRAY_SIZE(pc236_isa_boards),
-#endif
-};
-
-#if DO_PCI
-static const struct pci_device_id pc236_pci_table[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, 0x0009) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, pc236_pci_table);
-
-static int amplc_pc236_pci_probe(struct pci_dev *dev,
-				 const struct pci_device_id *id)
-{
-	return comedi_pci_auto_config(dev, &amplc_pc236_driver,
-				      id->driver_data);
-}
-
-static struct pci_driver amplc_pc236_pci_driver = {
-	.name = "amplc_pc236",
-	.id_table = pc236_pci_table,
-	.probe = &amplc_pc236_pci_probe,
-	.remove		= comedi_pci_auto_unconfig,
+	.num_names = ARRAY_SIZE(pc236_boards),
 };
 
-module_comedi_pci_driver(amplc_pc236_driver, amplc_pc236_pci_driver);
-#else
 module_comedi_driver(amplc_pc236_driver);
-#endif
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
-MODULE_DESCRIPTION("Comedi low-level driver");
+MODULE_DESCRIPTION("Comedi driver for Amplicon PC36AT DIO boards");
 MODULE_LICENSE("GPL");
diff --git a/drivers/staging/comedi/drivers/amplc_pc236.h b/drivers/staging/comedi/drivers/amplc_pc236.h
new file mode 100644
index 0000000..37348f1
--- /dev/null
+++ b/drivers/staging/comedi/drivers/amplc_pc236.h
@@ -0,0 +1,45 @@
+/*
+ * comedi/drivers/amplc_pc236.h
+ * Header for "amplc_pc236", "amplc_pci236" and "amplc_pc236_common".
+ *
+ * Copyright (C) 2002-2014 MEV Ltd. <http://www.mev.co.uk/>
+ *
+ * COMEDI - Linux Control and Measurement Device Interface
+ * Copyright (C) 2000 David A. Schleef <ds@schleef.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef AMPLC_PC236_H_INCLUDED
+#define AMPLC_PC236_H_INCLUDED
+
+#include <linux/types.h>
+
+struct comedi_device;
+
+enum pc236_bustype { isa_bustype, pci_bustype };
+
+struct pc236_board {
+	const char *name;
+	enum pc236_bustype bustype;
+	void (*intr_update_cb)(struct comedi_device *dev, bool enable);
+	bool (*intr_chk_clr_cb)(struct comedi_device *dev);
+};
+
+struct pc236_private {
+	unsigned long lcr_iobase; /* PLX PCI9052 config registers in PCIBAR1 */
+	bool enable_irq;
+};
+
+int amplc_pc236_common_attach(struct comedi_device *dev, unsigned long iobase,
+			      unsigned int irq, unsigned long req_irq_flags);
+
+#endif
diff --git a/drivers/staging/comedi/drivers/amplc_pc236_common.c b/drivers/staging/comedi/drivers/amplc_pc236_common.c
new file mode 100644
index 0000000..18e237c
--- /dev/null
+++ b/drivers/staging/comedi/drivers/amplc_pc236_common.c
@@ -0,0 +1,206 @@
+/*
+ * comedi/drivers/amplc_pc236_common.c
+ * Common support code for "amplc_pc236" and "amplc_pci236".
+ *
+ * Copyright (C) 2002-2014 MEV Ltd. <http://www.mev.co.uk/>
+ *
+ * COMEDI - Linux Control and Measurement Device Interface
+ * Copyright (C) 2000 David A. Schleef <ds@schleef.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/interrupt.h>
+
+#include "../comedidev.h"
+
+#include "amplc_pc236.h"
+#include "comedi_fc.h"
+#include "8255.h"
+
+static void pc236_intr_update(struct comedi_device *dev, bool enable)
+{
+	const struct pc236_board *thisboard = comedi_board(dev);
+	struct pc236_private *devpriv = dev->private;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->spinlock, flags);
+	devpriv->enable_irq = enable;
+	if (thisboard->intr_update_cb)
+		thisboard->intr_update_cb(dev, enable);
+	spin_unlock_irqrestore(&dev->spinlock, flags);
+}
+
+/*
+ * This function is called when an interrupt occurs to check whether
+ * the interrupt has been marked as enabled and was generated by the
+ * board.  If so, the function prepares the hardware for the next
+ * interrupt.
+ * Returns false if the interrupt should be ignored.
+ */
+static bool pc236_intr_check(struct comedi_device *dev)
+{
+	const struct pc236_board *thisboard = comedi_board(dev);
+	struct pc236_private *devpriv = dev->private;
+	bool retval = false;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->spinlock, flags);
+	if (devpriv->enable_irq) {
+		if (thisboard->intr_chk_clr_cb)
+			retval = thisboard->intr_chk_clr_cb(dev);
+		else
+			retval = true;
+	}
+	spin_unlock_irqrestore(&dev->spinlock, flags);
+
+	return retval;
+}
+
+static int pc236_intr_insn(struct comedi_device *dev,
+			   struct comedi_subdevice *s, struct comedi_insn *insn,
+			   unsigned int *data)
+{
+	data[1] = 0;
+	return insn->n;
+}
+
+static int pc236_intr_cmdtest(struct comedi_device *dev,
+			      struct comedi_subdevice *s,
+			      struct comedi_cmd *cmd)
+{
+	int err = 0;
+
+	/* Step 1 : check if triggers are trivially valid */
+
+	err |= cfc_check_trigger_src(&cmd->start_src, TRIG_NOW);
+	err |= cfc_check_trigger_src(&cmd->scan_begin_src, TRIG_EXT);
+	err |= cfc_check_trigger_src(&cmd->convert_src, TRIG_FOLLOW);
+	err |= cfc_check_trigger_src(&cmd->scan_end_src, TRIG_COUNT);
+	err |= cfc_check_trigger_src(&cmd->stop_src, TRIG_NONE);
+
+	if (err)
+		return 1;
+
+	/* Step 2a : make sure trigger sources are unique */
+	/* Step 2b : and mutually compatible */
+
+	if (err)
+		return 2;
+
+	/* Step 3: check it arguments are trivially valid */
+
+	err |= cfc_check_trigger_arg_is(&cmd->start_arg, 0);
+	err |= cfc_check_trigger_arg_is(&cmd->scan_begin_arg, 0);
+	err |= cfc_check_trigger_arg_is(&cmd->convert_arg, 0);
+	err |= cfc_check_trigger_arg_is(&cmd->scan_end_arg, cmd->chanlist_len);
+	err |= cfc_check_trigger_arg_is(&cmd->stop_arg, 0);
+
+	if (err)
+		return 3;
+
+	/* step 4: ignored */
+
+	if (err)
+		return 4;
+
+	return 0;
+}
+
+static int pc236_intr_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
+{
+	pc236_intr_update(dev, true);
+
+	return 0;
+}
+
+static int pc236_intr_cancel(struct comedi_device *dev,
+			     struct comedi_subdevice *s)
+{
+	pc236_intr_update(dev, false);
+
+	return 0;
+}
+
+static irqreturn_t pc236_interrupt(int irq, void *d)
+{
+	struct comedi_device *dev = d;
+	struct comedi_subdevice *s = dev->read_subdev;
+	bool handled;
+
+	handled = pc236_intr_check(dev);
+	if (dev->attached && handled) {
+		comedi_buf_put(s, 0);
+		s->async->events |= COMEDI_CB_BLOCK | COMEDI_CB_EOS;
+		comedi_event(dev, s);
+	}
+	return IRQ_RETVAL(handled);
+}
+
+int amplc_pc236_common_attach(struct comedi_device *dev, unsigned long iobase,
+			      unsigned int irq, unsigned long req_irq_flags)
+{
+	struct comedi_subdevice *s;
+	int ret;
+
+	dev->iobase = iobase;
+
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
+
+	s = &dev->subdevices[0];
+	/* digital i/o subdevice (8255) */
+	ret = subdev_8255_init(dev, s, NULL, iobase);
+	if (ret)
+		return ret;
+
+	s = &dev->subdevices[1];
+	dev->read_subdev = s;
+	s->type = COMEDI_SUBD_UNUSED;
+	pc236_intr_update(dev, false);
+	if (irq) {
+		if (request_irq(irq, pc236_interrupt, req_irq_flags,
+				dev->board_name, dev) >= 0) {
+			dev->irq = irq;
+			s->type = COMEDI_SUBD_DI;
+			s->subdev_flags = SDF_READABLE | SDF_CMD_READ;
+			s->n_chan = 1;
+			s->maxdata = 1;
+			s->range_table = &range_digital;
+			s->insn_bits = pc236_intr_insn;
+			s->len_chanlist	= 1;
+			s->do_cmdtest = pc236_intr_cmdtest;
+			s->do_cmd = pc236_intr_cmd;
+			s->cancel = pc236_intr_cancel;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(amplc_pc236_common_attach);
+
+static int __init amplc_pc236_common_init(void)
+{
+	return 0;
+}
+module_init(amplc_pc236_common_init);
+
+static void __exit amplc_pc236_common_exit(void)
+{
+}
+module_exit(amplc_pc236_common_exit);
+
+
+MODULE_AUTHOR("Comedi http://www.comedi.org");
+MODULE_DESCRIPTION("Comedi helper for amplc_pc236 and amplc_pci236");
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/comedi/drivers/amplc_pci236.c b/drivers/staging/comedi/drivers/amplc_pci236.c
new file mode 100644
index 0000000..a7e7a6f
--- /dev/null
+++ b/drivers/staging/comedi/drivers/amplc_pci236.c
@@ -0,0 +1,162 @@
+/*
+ * comedi/drivers/amplc_pci236.c
+ * Driver for Amplicon PCI236 DIO boards.
+ *
+ * Copyright (C) 2002-2014 MEV Ltd. <http://www.mev.co.uk/>
+ *
+ * COMEDI - Linux Control and Measurement Device Interface
+ * Copyright (C) 2000 David A. Schleef <ds@schleef.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+/*
+ * Driver: amplc_pci236
+ * Description: Amplicon PCI236
+ * Author: Ian Abbott <abbotti@mev.co.uk>
+ * Devices: [Amplicon] PCI236 (amplc_pci236)
+ * Updated: Fri, 25 Jul 2014 15:32:40 +0000
+ * Status: works
+ *
+ * Configuration options:
+ *   none
+ *
+ * Manual configuration of PCI board (PCI236) is not supported; it is
+ * configured automatically.
+ *
+ * The PCI236 board has a single 8255 appearing as subdevice 0.
+ *
+ * Subdevice 1 pretends to be a digital input device, but it always
+ * returns 0 when read. However, if you run a command with
+ * scan_begin_src=TRIG_EXT, a rising edge on port C bit 3 acts as an
+ * external trigger, which can be used to wake up tasks.  This is like
+ * the comedi_parport device.  If no interrupt is connected, then
+ * subdevice 1 is unused.
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+
+#include "../comedidev.h"
+
+#include "amplc_pc236.h"
+#include "plx9052.h"
+
+/* Disable, and clear, interrupts */
+#define PCI236_INTR_DISABLE	(PLX9052_INTCSR_LI1POL |	\
+				 PLX9052_INTCSR_LI2POL |	\
+				 PLX9052_INTCSR_LI1SEL |	\
+				 PLX9052_INTCSR_LI1CLRINT)
+
+/* Enable, and clear, interrupts */
+#define PCI236_INTR_ENABLE	(PLX9052_INTCSR_LI1ENAB |	\
+				 PLX9052_INTCSR_LI1POL |	\
+				 PLX9052_INTCSR_LI2POL |	\
+				 PLX9052_INTCSR_PCIENAB |	\
+				 PLX9052_INTCSR_LI1SEL |	\
+				 PLX9052_INTCSR_LI1CLRINT)
+
+static void pci236_intr_update_cb(struct comedi_device *dev, bool enable)
+{
+	struct pc236_private *devpriv = dev->private;
+
+	/* this will also clear the "local interrupt 1" latch */
+	outl(enable ? PCI236_INTR_ENABLE : PCI236_INTR_DISABLE,
+	     devpriv->lcr_iobase + PLX9052_INTCSR);
+}
+
+static bool pci236_intr_chk_clr_cb(struct comedi_device *dev)
+{
+	struct pc236_private *devpriv = dev->private;
+
+	/* check if interrupt occurred */
+	if (!(inl(devpriv->lcr_iobase + PLX9052_INTCSR) &
+	      PLX9052_INTCSR_LI1STAT))
+		return false;
+	/* clear the interrupt */
+	pci236_intr_update_cb(dev, devpriv->enable_irq);
+	return true;
+}
+
+static const struct pc236_board pc236_pci_board = {
+	.name = "pci236",
+	.intr_update_cb = pci236_intr_update_cb,
+	.intr_chk_clr_cb = pci236_intr_chk_clr_cb,
+	.bustype = pci_bustype,
+};
+
+static int pci236_auto_attach(struct comedi_device *dev,
+			      unsigned long context_unused)
+{
+	struct pci_dev *pci_dev = comedi_to_pci_dev(dev);
+	struct pc236_private *devpriv;
+	unsigned long iobase;
+	int ret;
+
+	dev_info(dev->class_dev, "amplc_pci236: attach pci %s\n",
+		 pci_name(pci_dev));
+
+	devpriv = comedi_alloc_devpriv(dev, sizeof(*devpriv));
+	if (!devpriv)
+		return -ENOMEM;
+
+	dev->board_ptr = &pc236_pci_board;
+	dev->board_name = pc236_pci_board.name;
+	ret = comedi_pci_enable(dev);
+	if (ret)
+		return ret;
+
+	devpriv->lcr_iobase = pci_resource_start(pci_dev, 1);
+	iobase = pci_resource_start(pci_dev, 2);
+	return amplc_pc236_common_attach(dev, iobase, pci_dev->irq,
+					 IRQF_SHARED);
+}
+
+static void pci236_detach(struct comedi_device *dev)
+{
+	if (dev->irq)
+		free_irq(dev->irq, dev);
+	comedi_pci_disable(dev);
+}
+
+static struct comedi_driver amplc_pci236_driver = {
+	.driver_name = "amplc_pci236",
+	.module = THIS_MODULE,
+	.auto_attach = pci236_auto_attach,
+	.detach = pci236_detach,
+};
+
+static const struct pci_device_id pci236_pci_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, 0x0009) },
+	{ 0 }
+};
+
+MODULE_DEVICE_TABLE(pci, pci236_pci_table);
+
+static int amplc_pci236_pci_probe(struct pci_dev *dev,
+				  const struct pci_device_id *id)
+{
+	return comedi_pci_auto_config(dev, &amplc_pci236_driver,
+				      id->driver_data);
+}
+
+static struct pci_driver amplc_pci236_pci_driver = {
+	.name		= "amplc_pci236",
+	.id_table	= pci236_pci_table,
+	.probe		= &amplc_pci236_pci_probe,
+	.remove		= comedi_pci_auto_unconfig,
+};
+
+module_comedi_pci_driver(amplc_pci236_driver, amplc_pci236_pci_driver);
+
+MODULE_AUTHOR("Comedi http://www.comedi.org");
+MODULE_DESCRIPTION("Comedi driver for Amplicon PCI236 DIO boards");
+MODULE_LICENSE("GPL");
-- 
2.0.0

