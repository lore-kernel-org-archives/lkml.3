Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab3LaBgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 20:36:54 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:46304 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3LaBgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 20:36:51 -0500
From: Rostislav Lisovy <lisovy@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: pisa@cmp.felk.cvut.cz, Rostislav Lisovy <lisovy@gmail.com>
Subject: [PATCH] comedi: Humusoft MF634 and MF624 DAQ cards driver
Date: Tue, 31 Dec 2013 02:36:36 +0100
Message-Id: <1388453796-17088-2-git-send-email-lisovy@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388453796-17088-1-git-send-email-lisovy@gmail.com>
References: <1388453796-17088-1-git-send-email-lisovy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 create mode 100644 drivers/staging/comedi/drivers/mf6x4.c

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index bfa27e7..89e25b4 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -884,6 +884,12 @@ config COMEDI_GSC_HPDI
 	  To compile this driver as a module, choose M here: the module will be
 	  called gsc_hpdi.
 
+config COMEDI_MF6X4
+	tristate "Humusoft MF634 and MF624 DAQ Card support"
+	---help---
+	  This driver supports both Humusoft MF634 and MF624 Data acquisition
+	  cards. The legacy Humusoft MF614 card is not supported.
+
 config COMEDI_ICP_MULTI
 	tristate "Inova ICP_MULTI support"
 	---help---
diff --git a/drivers/staging/comedi/drivers/Makefile b/drivers/staging/comedi/drivers/Makefile
index 94cbd26..9e979a9 100644
--- a/drivers/staging/comedi/drivers/Makefile
+++ b/drivers/staging/comedi/drivers/Makefile
@@ -110,6 +110,7 @@ obj-$(CONFIG_COMEDI_NI_PCIMIO)		+= ni_pcimio.o
 obj-$(CONFIG_COMEDI_RTD520)		+= rtd520.o
 obj-$(CONFIG_COMEDI_S626)		+= s626.o
 obj-$(CONFIG_COMEDI_SSV_DNP)		+= ssv_dnp.o
+obj-$(CONFIG_COMEDI_MF6X4)		+= mf6x4.o
 
 # Comedi PCMCIA drivers
 obj-$(CONFIG_COMEDI_CB_DAS16_CS)	+= cb_das16_cs.o
diff --git a/drivers/staging/comedi/drivers/mf6x4.c b/drivers/staging/comedi/drivers/mf6x4.c
new file mode 100644
index 0000000..46c7ce5
--- /dev/null
+++ b/drivers/staging/comedi/drivers/mf6x4.c
@@ -0,0 +1,368 @@
+/*
+ *  comedi/drivers/mf6x4.c
+ *  Driver for Humusoft MF634 and MF624 Data acquisition cards
+ *
+ *  COMEDI - Linux Control and Measurement Device Interface
+ *  Copyright (C) 2000 David A. Schleef <ds@schleef.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+/*
+ * Driver: mf6x4
+ * Description: Humusoft MF634 and MF624 Data acquisition card driver
+ * Devices: Humusoft MF634, Humusoft MF624
+ * Author: Rostislav Lisovy <lisovy@gmail.com>
+ * Status: works
+ * Updated:
+ * Configuration Options: none
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include "../comedidev.h"
+
+/* PCI Vendor ID, Device ID */
+#define PCI_VENDOR_ID_HUMUSOFT          		0x186c
+#define PCI_DEVICE_ID_MF624				0x0624
+#define PCI_DEVICE_ID_MF634				0x0634
+
+/* Registers present in BAR0 memory region */
+#define MF624_GPIOC_reg					0x54
+
+#define MF6X4_GPIOC_EOLC /* End Of Last Conversion */	(1 << 17)
+#define MF6X4_GPIOC_LDAC /* Load DACs */		(1 << 23)
+#define MF6X4_GPIOC_DACEN				(1 << 26)
+
+/* BAR1 registers */
+#define MF6X4_DIN_reg					0x10
+#define MF6X4_DIN_mask					0xff
+#define MF6X4_DOUT_reg					0x10
+#define MF6X4_DOUT_mask					0xff
+
+#define MF6X4_ADSTART_reg				0x20
+#define MF6X4_ADDATA_reg				0x00
+#define MF6X4_ADDATA_mask				0x3fff
+#define MF6X4_ADCTRL_reg				0x00
+#define MF6X4_ADCTRL_mask				0xff
+
+#define MF6X4_DA0_reg					0x20
+#define MF6X4_DA1_reg					0x22
+#define MF6X4_DA2_reg					0x24
+#define MF6X4_DA3_reg					0x26
+#define MF6X4_DA4_reg					0x28
+#define MF6X4_DA5_reg					0x2a
+#define MF6X4_DA6_reg					0x2c
+#define MF6X4_DA7_reg					0x2e
+#define MF6X4_DA_mask					0x3fff
+#define MF6X4_DAC_CHANN_CNT				8
+
+/* BAR2 registers */
+#define MF634_GPIOC_reg					0x68
+
+/* Make a fault-tolerant mapping from DAC cahnnel id obtained as
+an int to real HW-dependent offset value */
+static unsigned int mf6x4_dac_channels[MF6X4_DAC_CHANN_CNT] = {
+	[0] = MF6X4_DA0_reg,
+	[1] = MF6X4_DA1_reg,
+	[2] = MF6X4_DA2_reg,
+	[3] = MF6X4_DA3_reg,
+	[4] = MF6X4_DA4_reg,
+	[5] = MF6X4_DA5_reg,
+	[6] = MF6X4_DA6_reg,
+	[7] = MF6X4_DA7_reg,
+};
+
+enum mf6x4_boardid {
+	BOARD_MF634,
+	BOARD_MF624,
+};
+
+struct mf6x4_board {
+	const char *name;
+	unsigned int bar_nums[3]; /* We need to keep track of the
+				     order of BARs used by the cards */
+};
+
+static const struct mf6x4_board mf6x4_boards[] = {
+	[BOARD_MF634] = {
+		.name           = "mf634",
+		.bar_nums	= {0, 2, 3},
+	},
+	[BOARD_MF624] = {
+		.name           = "mf624",
+		.bar_nums	= {0, 2, 4},
+	},
+};
+
+struct mf6x4_private {
+	struct pci_dev *pci_dev;
+
+	/* Documentation for both MF634 and MF624 describes registers
+	present in BAR0, 1 and 2 regions.
+	The real (i.e. in HW) BAR numbers are different for MF624 and
+	MF634 yet we will call them 0, 1, 2 */
+	void __iomem *bar0_mem;
+	void __iomem *bar1_mem;
+	void __iomem *bar2_mem;
+
+	void __iomem *gpioc_reg; /* This configuration register has the same
+		content for the both cards however it liess in different BARs
+		on different offsets -- this helps to make the access easier */
+};
+
+static int mf6x4_dio_insn_bits(struct comedi_device *dev,
+			       struct comedi_subdevice *s,
+			       struct comedi_insn *insn, unsigned int *data)
+{
+	struct mf6x4_private *devpriv = dev->private;
+
+	switch (s->type) {
+	case COMEDI_SUBD_DI: /* DIN */
+		data[1] = ioread16(devpriv->bar1_mem + MF6X4_DIN_reg) & MF6X4_DIN_mask;
+		break;
+
+	case COMEDI_SUBD_DO: /* DOUT */
+		/* data[0] -- mask
+		   data[1] -- actual value */
+		if (data[0]) {
+			s->state &= ~data[0];
+			s->state |= (data[0] & data[1]);
+
+			iowrite16(s->state & MF6X4_DOUT_mask,
+				devpriv->bar1_mem + MF6X4_DOUT_reg);
+
+			data[1] = s->state;
+		}
+		break;
+	}
+
+	return insn->n;
+}
+
+static int mf6x4_ai_insn_read(struct comedi_device *dev,
+			      struct comedi_subdevice *s,
+			      struct comedi_insn *insn, unsigned int *data)
+{
+	struct mf6x4_private *devpriv = dev->private;
+	unsigned int chan = CR_CHAN(insn->chanspec);
+	unsigned int timeout = 100;
+	unsigned int eolc;
+	unsigned int n;
+	unsigned int i;
+	int d;
+
+	/* Set the ADC channel number in the scan list */
+	iowrite16((1 << chan) & MF6X4_ADCTRL_mask,
+		devpriv->bar1_mem + MF6X4_ADCTRL_reg);
+
+	for (n = 0; n < insn->n; n++) {
+		/* Trigger ADC conversion by reading ADSTART */
+		ioread16(devpriv->bar1_mem + MF6X4_ADSTART_reg);
+
+		/* Wait until the conversion finishes or times out */
+		for (i = 0; i < timeout; i++) {
+			eolc = ioread32(devpriv->gpioc_reg) & MF6X4_GPIOC_EOLC;
+
+			if (!eolc)
+				break;
+		}
+		if (i == timeout) {
+			dev_warn(dev->class_dev, "ADC conversion timed out\n");
+			return -ETIMEDOUT;
+		}
+
+		/* Read the actual value */
+		d = ioread16(devpriv->bar1_mem + MF6X4_ADDATA_reg);
+		d &= MF6X4_ADDATA_mask;
+		data[n] = d;
+	}
+
+	iowrite16(0x0, devpriv->bar1_mem + MF6X4_ADCTRL_reg);
+
+	return n;
+}
+
+static int mf6x4_ao_insn_write(struct comedi_device *dev,
+			       struct comedi_subdevice *s,
+			       struct comedi_insn *insn, unsigned int *data)
+{
+	struct mf6x4_private *devpriv = dev->private;
+	int chan = CR_CHAN(insn->chanspec);
+	uint32_t gpioc;
+	int i;
+
+	chan = (chan < MF6X4_DAC_CHANN_CNT) ? chan : 0;
+
+	/* Enable instantaneous update of converters outputs + Enable DACs */
+	gpioc = ioread32(devpriv->gpioc_reg);
+	iowrite32((gpioc & ~MF6X4_GPIOC_LDAC) | MF6X4_GPIOC_DACEN, devpriv->gpioc_reg);
+
+	/* Writing a list of values to an AO channel is probably not
+	   very useful, but that's how the interface is defined. */
+	for (i = 0; i < insn->n; i++) {
+		iowrite16(data[i] & MF6X4_DA_mask,
+			devpriv->bar1_mem + mf6x4_dac_channels[chan]);
+	}
+
+	return i;
+}
+
+static int mf6x4_auto_attach(struct comedi_device *dev, unsigned long context)
+{
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
+	const struct mf6x4_board *board = NULL;
+	struct mf6x4_private *devpriv;
+	struct comedi_subdevice *s;
+	int ret;
+
+	if (context < ARRAY_SIZE(mf6x4_boards))
+		board = &mf6x4_boards[context];
+	else
+		return -ENODEV;
+
+	dev->board_ptr = board;
+	dev->board_name = board->name;
+
+	ret = comedi_pci_enable(dev); /* pci_enable_device(), pci_request_regions() */
+	if (ret)
+		return ret;
+
+	devpriv = comedi_alloc_devpriv(dev, sizeof(*devpriv));
+	if (!devpriv)
+		return -ENOMEM;
+
+	devpriv->bar0_mem = pci_ioremap_bar(pcidev, board->bar_nums[0]);
+	if (!devpriv->bar0_mem) {
+		dev_err(dev->class_dev, "Failed to remap Device configuration BAR\n");
+		ret = -ENODEV;
+		goto out;
+	}
+
+	devpriv->bar1_mem = pci_ioremap_bar(pcidev, board->bar_nums[1]);
+	if (!devpriv->bar1_mem) {
+		dev_err(dev->class_dev, "Failed to remap ADC, DAC, DIO BAR\n");
+		ret = -ENODEV;
+		goto out;
+	}
+
+	devpriv->bar2_mem = pci_ioremap_bar(pcidev, board->bar_nums[2]);
+	if (!devpriv->bar2_mem) {
+		dev_err(dev->class_dev, "Failed to remap Counter/timer BAR\n");
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (board == &mf6x4_boards[BOARD_MF634]) {
+		devpriv->gpioc_reg = devpriv->bar2_mem + MF634_GPIOC_reg;
+	} else if (board == &mf6x4_boards[BOARD_MF624]) {
+		devpriv->gpioc_reg = devpriv->bar0_mem + MF624_GPIOC_reg;
+	} else { /* Definitely should not happen */
+		devpriv->gpioc_reg = NULL;
+	}
+
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		goto out;
+
+	/* ADC */
+	s = &dev->subdevices[0];
+	s->type = COMEDI_SUBD_AI;
+	s->subdev_flags = SDF_READABLE | SDF_GROUND;
+	s->n_chan = 8;
+	s->range_table = &range_bipolar10;
+	s->maxdata = (1 << 14) - 1;	/* 14 bits ADC */
+	s->insn_read = mf6x4_ai_insn_read;
+
+	/* DAC */
+	s = &dev->subdevices[1];
+	s->type = COMEDI_SUBD_AO;
+	s->subdev_flags = SDF_WRITABLE;
+	s->n_chan = 8;
+	s->range_table = &range_bipolar10;
+	s->maxdata = (1 << 14) - 1;	/* 14 bits DAC */
+	s->insn_write = mf6x4_ao_insn_write;
+
+	/* DIN */
+	s = &dev->subdevices[2];
+	s->type = COMEDI_SUBD_DI;
+	s->subdev_flags = SDF_READABLE;
+	s->n_chan = 8;
+	s->range_table = &range_digital;
+	s->maxdata = 1;
+	s->insn_bits = mf6x4_dio_insn_bits;
+
+	/* DOUT */
+	s = &dev->subdevices[3];
+	s->type = COMEDI_SUBD_DO;
+	s->subdev_flags = SDF_WRITABLE;
+	s->n_chan = 8;
+	s->range_table = &range_digital;
+	s->maxdata = 1;
+	s->insn_bits = mf6x4_dio_insn_bits;
+
+	return 0;
+
+out:
+	/* dev->private is freed automatically */
+	return ret;
+}
+
+/*
+ * _detach is called to deconfigure a device. It should deallocate resources.
+ * This function is also called when _attach() fails, so it should be careful
+ * not to release resources that were not necessarily allocated by _attach().
+ * dev->private and dev->subdevices are deallocated automatically by the core.
+ */
+static void mf6x4_detach(struct comedi_device *dev)
+{
+	struct mf6x4_private *devpriv = dev->private;
+
+	if (devpriv->bar0_mem)
+		iounmap(devpriv->bar0_mem);
+	if (devpriv->bar1_mem)
+		iounmap(devpriv->bar1_mem);
+	if (devpriv->bar2_mem)
+		iounmap(devpriv->bar2_mem);
+
+	comedi_pci_disable(dev); /* pci_release_regions(), pci_disable_device() */
+}
+
+static struct comedi_driver mf6x4_driver = {
+	.driver_name    = "mf6x4",
+	.module         = THIS_MODULE,
+	.auto_attach    = mf6x4_auto_attach,
+	.detach         = mf6x4_detach,
+};
+
+static int mf6x4_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
+{
+	return comedi_pci_auto_config(dev, &mf6x4_driver, id->driver_data);
+}
+
+static const struct pci_device_id mf6x4_pci_table[] = {
+	{ PCI_VDEVICE(HUMUSOFT, PCI_DEVICE_ID_MF634), BOARD_MF634 },
+	{ PCI_VDEVICE(HUMUSOFT, PCI_DEVICE_ID_MF624), BOARD_MF624 },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, mf6x4_pci_table);
+
+static struct pci_driver mf6x4_pci_driver = {
+	.name           = "mf6x4",
+	.id_table       = mf6x4_pci_table,
+	.probe          = mf6x4_pci_probe,
+	.remove         = comedi_pci_auto_unconfig,
+};
+
+module_comedi_pci_driver(mf6x4_driver, mf6x4_pci_driver);
+
+MODULE_AUTHOR("Rostislav Lisovy <lisovy@gmail.com>");
+MODULE_DESCRIPTION("Comedi MF634 and MF624 DAQ cards driver");
+MODULE_LICENSE("GPL");
-- 
1.8.3.2

