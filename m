Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab3GJKTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:19:21 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:50090 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab3GJKTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:19:16 -0400
From: Alexander Popov <a13xp0p0v88@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anatolij Gustschin <agust@denx.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Chris Ball <cjb@laptop.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Gerhard Sittig <gsi@denx.de>,
        Timur Tabi <timur@tabi.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [V2 2/2] powerpc/512x: add LocalPlus Bus FIFO device driver
Date: Wed, 10 Jul 2013 14:21:18 +0400
Message-Id: <1373451678-20065-1-git-send-email-a13xp0p0v88@gmail.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is SCLPC device driver for the Freescale MPC512x.
It is needed for Direct Memory Access to the devices on LocalPlus Bus.

Signed-off-by: Alexander Popov <a13xp0p0v88@gmail.com>
---
 arch/powerpc/boot/dts/mpc5121.dtsi            |   8 +-
 arch/powerpc/include/asm/mpc5121.h            |  32 ++
 arch/powerpc/platforms/512x/Kconfig           |   6 +
 arch/powerpc/platforms/512x/Makefile          |   1 +
 arch/powerpc/platforms/512x/mpc512x_lpbfifo.c | 485 ++++++++++++++++++++++++++
 5 files changed, 531 insertions(+), 1 deletion(-)
 create mode 100644 arch/powerpc/platforms/512x/mpc512x_lpbfifo.c

diff --git a/arch/powerpc/boot/dts/mpc5121.dtsi b/arch/powerpc/boot/dts/mpc5121.dtsi
index bd14c00..6e0b0c0 100644
--- a/arch/powerpc/boot/dts/mpc5121.dtsi
+++ b/arch/powerpc/boot/dts/mpc5121.dtsi
@@ -261,7 +261,13 @@
 		/* LocalPlus controller */
 		lpc@10000 {
 			compatible = "fsl,mpc5121-lpc";
-			reg = <0x10000 0x200>;
+			reg = <0x10000 0x100>;
+		};
+
+		sclpc@10100 {
+			compatible = "fsl,mpc512x-lpbfifo";
+			reg = <0x10100 0x50>;
+			interrupts = <7 0x8>;
 		};
 
 		pata@10200 {
diff --git a/arch/powerpc/include/asm/mpc5121.h b/arch/powerpc/include/asm/mpc5121.h
index 8ae133e..f416a7e 100644
--- a/arch/powerpc/include/asm/mpc5121.h
+++ b/arch/powerpc/include/asm/mpc5121.h
@@ -69,4 +69,36 @@ struct mpc512x_lpc {
 
 int mpc512x_cs_config(unsigned int cs, u32 val);
 
+/*
+ * SCLPC Module (LPB FIFO)
+ */
+enum lpb_dev_portsize {
+	LPB_DEV_PORTSIZE_UNDEFINED = 0,
+	LPB_DEV_PORTSIZE_1_BYTE = 1,
+	LPB_DEV_PORTSIZE_2_BYTES = 2,
+	LPB_DEV_PORTSIZE_4_BYTES = 4,
+	LPB_DEV_PORTSIZE_8_BYTES = 8,
+};
+
+enum mpc512x_lpbfifo_req_dir {
+	MPC512X_LPBFIFO_REQ_DIR_READ,
+	MPC512X_LPBFIFO_REQ_DIR_WRITE,
+};
+
+struct mpc512x_lpbfifo_request {
+	unsigned int cs;
+	phys_addr_t bus_phys;	/* physical address of some device on lpb */
+	void *ram_virt;		/* virtual address of some region in ram */
+
+	/* Details of transfer */
+	u32 size;
+	enum lpb_dev_portsize portsize;
+	enum mpc512x_lpbfifo_req_dir dir;
+
+	/* Call when the transfer is finished */
+	void (*callback)(struct mpc512x_lpbfifo_request *);
+};
+
+extern int mpc512x_lpbfifo_submit(struct mpc512x_lpbfifo_request *req);
+
 #endif /* __ASM_POWERPC_MPC5121_H__ */
diff --git a/arch/powerpc/platforms/512x/Kconfig b/arch/powerpc/platforms/512x/Kconfig
index fc9c1cb..0db8aa9 100644
--- a/arch/powerpc/platforms/512x/Kconfig
+++ b/arch/powerpc/platforms/512x/Kconfig
@@ -10,6 +10,12 @@ config PPC_MPC512x
 	select USB_EHCI_BIG_ENDIAN_MMIO
 	select USB_EHCI_BIG_ENDIAN_DESC
 
+config PPC_MPC512x_LPBFIFO
+	tristate "MPC512x LocalPlus bus FIFO driver"
+	depends on PPC_MPC512x && MPC512X_DMA
+	help
+	  Enable support for the Freescale MPC512x SCLPC.
+
 config MPC5121_ADS
 	bool "Freescale MPC5121E ADS"
 	depends on PPC_MPC512x
diff --git a/arch/powerpc/platforms/512x/Makefile b/arch/powerpc/platforms/512x/Makefile
index 72fb934..df932fa 100644
--- a/arch/powerpc/platforms/512x/Makefile
+++ b/arch/powerpc/platforms/512x/Makefile
@@ -2,6 +2,7 @@
 # Makefile for the Freescale PowerPC 512x linux kernel.
 #
 obj-y				+= clock.o mpc512x_shared.o
+obj-$(CONFIG_PPC_MPC512x_LPBFIFO) += mpc512x_lpbfifo.o
 obj-$(CONFIG_MPC5121_ADS)	+= mpc5121_ads.o mpc5121_ads_cpld.o
 obj-$(CONFIG_MPC512x_GENERIC)	+= mpc512x_generic.o
 obj-$(CONFIG_PDM360NG)		+= pdm360ng.o
diff --git a/arch/powerpc/platforms/512x/mpc512x_lpbfifo.c b/arch/powerpc/platforms/512x/mpc512x_lpbfifo.c
new file mode 100644
index 0000000..6bd8aab
--- /dev/null
+++ b/arch/powerpc/platforms/512x/mpc512x_lpbfifo.c
@@ -0,0 +1,485 @@
+/*
+ * LocalPlus Bus SCLPC driver for the Freescale MPC512x.
+ *
+ * Copyright (C) Promcontroller, 2013.
+ *
+ * Author is Alexander Popov <a13xp0p0v88@gmail.com>.
+ *
+ * The driver design is based on mpc52xx_lpbfifo driver
+ * written by Grant Likely <grant.likely@secretlab.ca>.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <asm/io.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <asm/mpc5121.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-direction.h>
+#include <linux/dma-mapping.h>
+
+MODULE_AUTHOR("Alexander Popov <a13xp0p0v88@gmail.com>");
+MODULE_DESCRIPTION("MPC512x LocalPlus FIFO device driver");
+MODULE_LICENSE("GPL");
+
+#define DRV_NAME "mpc512x_lpbfifo"
+
+#define LPBFIFO_REG_PACKET_SIZE		(0x00)
+#define LPBFIFO_REG_START_ADDRESS	(0x04)
+#define LPBFIFO_REG_CONTROL		(0x08)
+#define LPBFIFO_REG_ENABLE		(0x0C)
+#define LPBFIFO_REG_STATUS		(0x14)
+#define LPBFIFO_REG_BYTES_DONE		(0x18)
+#define LPBFIFO_REG_EMB_SHARE_COUNTER	(0x1C)
+#define LPBFIFO_REG_EMB_PAUSE_CONTROL	(0x20)
+#define LPBFIFO_REG_FIFO_DATA		(0x40)
+#define LPBFIFO_REG_FIFO_STATUS		(0x44)
+#define LPBFIFO_REG_FIFO_CONTROL	(0x48)
+#define LPBFIFO_REG_FIFO_ALARM		(0x4C)
+
+#define DMA_LPC_CHANNEL_NUMBER		26
+#define DEFAULT_WORDS_PER_TRANSFER	1
+
+static struct mpc512x_lpbfifo {
+	struct device *dev;
+	struct resource res;
+	void __iomem *regs;
+	int irq;
+	spinlock_t lock;
+
+	/* Current state data */
+	int im_last; /* For "last one out turns off the lights" principle */
+	struct mpc512x_lpbfifo_request *req;
+	dma_addr_t ram_bus_addr;
+	struct dma_chan *chan;
+} lpbfifo;
+
+/*
+ * Before we can wrap up handling current mpc512x_lpbfifo_request
+ * and execute the callback registered in it we should:
+ *  1. recognize that everything is really done,
+ *  2. free memory and dmaengine channel.
+ *
+ * Writing from RAM to registers of some device on LPB (transmit)
+ * is not really done until the LPB FIFO completion irq triggers.
+ *
+ * For being sure that writing from registers of some device on LPB
+ * to RAM (receive) is really done we should wait
+ * for mpc512x_lpbfifo_callback() to be called by DMA driver.
+ * In this case LPB FIFO completion irq will not appear at all.
+ *
+ * Moreover, freeing memory and dmaengine channel is not safe until
+ * mpc512x_lpbfifo_callback() is called.
+ *
+ * So to make it simple:
+ * last one out turns off the lights.
+ */
+
+/*
+ * mpc512x_lpbfifo_irq - IRQ handler for LPB FIFO
+ */
+static irqreturn_t mpc512x_lpbfifo_irq(int irq, void *dev_id)
+{
+	struct mpc512x_lpbfifo_request *req;
+	unsigned long flags;
+	u32 status;
+
+	spin_lock_irqsave(&lpbfifo.lock, flags);
+
+	req = lpbfifo.req;
+	if (!req) {
+		spin_unlock_irqrestore(&lpbfifo.lock, flags);
+		pr_err("bogus LPBFIFO IRQ\n");
+		return IRQ_HANDLED;
+	}
+
+	if (req->dir == MPC512X_LPBFIFO_REQ_DIR_READ) {
+		spin_unlock_irqrestore(&lpbfifo.lock, flags);
+		pr_err("bogus LPBFIFO IRQ (we are waiting DMA IRQ)\n");
+		return IRQ_HANDLED;
+	}
+
+	/* Clear the interrupt flag */
+	status = in_8(lpbfifo.regs + LPBFIFO_REG_STATUS);
+	if (status & 0x01)
+		out_8(lpbfifo.regs + LPBFIFO_REG_STATUS, 0x01);
+	else
+		out_be32(lpbfifo.regs + LPBFIFO_REG_ENABLE, 0x01010000);
+
+	if (!lpbfifo.im_last) {
+		/*  I'm not the last: DMA is still in progress. */
+		lpbfifo.im_last = 1;
+		spin_unlock_irqrestore(&lpbfifo.lock, flags);
+	} else {
+		/* I'm last. Let's wrap up. */
+		/* Set the FIFO as idle */
+		req = lpbfifo.req;
+		lpbfifo.req = NULL;
+
+		/* The spinlock must be dropped
+		 * before executing the callback,
+		 * otherwise we could end up with a deadlock
+		 * or nested spinlock condition. */
+		spin_unlock_irqrestore(&lpbfifo.lock, flags);
+		if (req->callback)
+			req->callback(req);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * mpc512x_lpbfifo_callback is called by DMA driver
+ * when DMA transaction is finished.
+ */
+static void mpc512x_lpbfifo_callback(void *param)
+{
+	unsigned long flags;
+	struct mpc512x_lpbfifo_request *req;
+	enum dma_data_direction dir;
+
+	spin_lock_irqsave(&lpbfifo.lock, flags);
+
+	/* Free resources */
+	if (lpbfifo.req->dir == MPC512X_LPBFIFO_REQ_DIR_WRITE)
+		dir = DMA_TO_DEVICE;
+	else
+		dir = DMA_FROM_DEVICE;
+	dma_unmap_single(lpbfifo.chan->device->dev,
+			lpbfifo.ram_bus_addr, lpbfifo.req->size, dir);
+	dma_release_channel(lpbfifo.chan);
+
+	if (lpbfifo.req->dir == MPC512X_LPBFIFO_REQ_DIR_WRITE &&
+							!lpbfifo.im_last) {
+		/* I'm not the last: LPB FIFO is still writing data. */
+		lpbfifo.im_last = 1;
+		spin_unlock_irqrestore(&lpbfifo.lock, flags);
+	} else {
+		/* I'm the last or alone here. Let's wrap up. */
+		/* Set the FIFO as idle */
+		req = lpbfifo.req;
+		lpbfifo.req = NULL;
+
+		/* The spinlock must be dropped
+		 * before executing the callback,
+		 * otherwise we could end up with a deadlock
+		 * or nested spinlock condition. */
+		spin_unlock_irqrestore(&lpbfifo.lock, flags);
+		if (req->callback)
+			req->callback(req);
+	}
+}
+
+static bool channel_filter(struct dma_chan *chan, void *filter_param)
+{
+	if (chan->chan_id == DMA_LPC_CHANNEL_NUMBER)
+		return true;
+	else
+		return false;
+}
+
+static int mpc512x_lpbfifo_kick(struct mpc512x_lpbfifo_request *req)
+{
+	u32 bits;
+	int no_incr = 0;
+	u32 bpt;
+	dma_cap_mask_t cap_mask;
+	dma_filter_fn fn = channel_filter;
+	struct dma_device *dma_dev = NULL;
+	struct scatterlist sg;
+	enum dma_data_direction dir;
+	struct dma_slave_config dma_conf = {};
+	struct dma_async_tx_descriptor *dma_tx = NULL;
+	dma_cookie_t cookie;
+	int e;
+
+	/* 1. Check requirements: */
+	/* Packet size must be a multiple of 4 bytes since
+	 * FIFO Data Word Register (which provides data to DMA controller)
+	 * allows only "full-word" (4 bytes) access
+	 * according Reference Manual */
+	if (!IS_ALIGNED(req->size, 4)) {
+		e = -EINVAL;
+		goto err_align;
+	}
+
+	/* Physical address of the device on LPB and packet size
+	 * must be aligned/multiple of BPT (bytes per transaction)
+	 * according Reference Manual */
+	if (req->portsize != LPB_DEV_PORTSIZE_UNDEFINED) {
+		bpt = req->portsize;
+		no_incr = 1;
+	} else
+		bpt = DEFAULT_WORDS_PER_TRANSFER << 2; /* makes life easier */
+
+	if (!IS_ALIGNED(req->bus_phys | req->size, bpt)) {
+			e = -EFAULT;
+			goto err_align;
+	}
+
+	/* 2. Prepare DMA */
+	dma_cap_zero(cap_mask);
+	dma_cap_set(DMA_SLAVE, cap_mask);
+	lpbfifo.chan = dma_request_channel(cap_mask, fn, NULL);
+	if (!lpbfifo.chan) {
+		e = -ENODEV;
+		goto err_align;
+	}
+	dma_dev = lpbfifo.chan->device;
+
+	sg_init_table(&sg, 1);
+	if (req->dir == MPC512X_LPBFIFO_REQ_DIR_WRITE)
+		dir = DMA_TO_DEVICE;
+	else
+		dir = DMA_FROM_DEVICE;
+	sg_dma_address(&sg) = dma_map_single(dma_dev->dev,
+			req->ram_virt, req->size, dir);
+	if (dma_mapping_error(dma_dev->dev, sg_dma_address(&sg))) {
+		pr_err("dma_mapping_error\n");
+		e = -EFAULT;
+		goto err_dma_map;
+	}
+	lpbfifo.ram_bus_addr = sg_dma_address(&sg); /* will free it later */
+	sg_dma_len(&sg) = req->size;
+
+	/* We should limit the maximum number of words
+	 * (units with FIFO Data Register size)
+	 * that can be read from / written to the FIFO
+	 * in one DMA burst.
+	 * This measure and FIFO watermarks will prevent
+	 * DMA controller from overtaking FIFO
+	 * and causing FIFO underflow / overflow error. */
+	dma_conf.dst_maxburst = DEFAULT_WORDS_PER_TRANSFER;
+	dma_conf.src_maxburst = DEFAULT_WORDS_PER_TRANSFER;
+
+	if (req->dir == MPC512X_LPBFIFO_REQ_DIR_WRITE) {
+		dma_conf.direction = DMA_MEM_TO_DEV;
+		dma_conf.dst_addr = lpbfifo.res.start + LPBFIFO_REG_FIFO_DATA;
+	} else {
+		dma_conf.direction = DMA_DEV_TO_MEM;
+		dma_conf.src_addr = lpbfifo.res.start + LPBFIFO_REG_FIFO_DATA;
+	}
+	dma_conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	dma_conf.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+
+	/* Make DMA channel work with LPB FIFO data register */
+	if (dma_dev->device_control(lpbfifo.chan,
+				DMA_SLAVE_CONFIG, (unsigned long)&dma_conf)) {
+		goto err_dma_prep;
+	}
+
+	dma_tx = dmaengine_prep_slave_sg(lpbfifo.chan, &sg,
+						1, dma_conf.direction, 0);
+	if (!dma_tx) {
+		pr_err("dmaengine_prep_slave_sg failed\n");
+		e = -ENOSPC;
+		goto err_dma_prep;
+	}
+
+	dma_tx->callback = mpc512x_lpbfifo_callback;
+	dma_tx->callback_param = NULL;
+
+	/* 3. Prepare FIFO */
+	/* Set and clear the reset bits;
+	 * is good practice in Reference Manual */
+	out_be32(lpbfifo.regs + LPBFIFO_REG_ENABLE, 0x01010000);
+	out_be32(lpbfifo.regs + LPBFIFO_REG_ENABLE, 0x0);
+
+	/* Configure the watermarks.
+	 *
+	 * RAM->DMA->FIFO->LPB_DEV (write):
+	 *  High watermark (7 * 4) free bytes (according Reference Manual)
+	 *  Low watermark 996 bytes (whole FIFO - 28 bytes)
+	 *
+	 * LPB_DEV->FIFO->DMA->RAM (read):
+	 *  High watermark (1024 - 4) free bytes
+	 *   (whole FIFO - DEFAULT_WORDS_PER_TRANSFER)
+	 *  Low watermark 0 bytes
+	 */
+	if (req->dir == MPC512X_LPBFIFO_REQ_DIR_WRITE) {
+		out_be16(lpbfifo.regs + LPBFIFO_REG_FIFO_CONTROL, 0x0700);
+		out_be32(lpbfifo.regs + LPBFIFO_REG_FIFO_ALARM, 0x000003e4);
+	} else {
+		out_be16(lpbfifo.regs + LPBFIFO_REG_FIFO_CONTROL, 0x0);
+		out_be32(lpbfifo.regs + LPBFIFO_REG_FIFO_ALARM, 0x000003fc);
+	}
+
+	/* Start address is a physical address of the region
+	 * which belongs to the device on localplus bus */
+	out_be32(lpbfifo.regs + LPBFIFO_REG_START_ADDRESS, req->bus_phys);
+
+	/* Configure chip select, transfer direction,
+	 * address increment option and bytes per transfer option */
+	bits = (req->cs & 0x7) << 24;
+	if (req->dir == MPC512X_LPBFIFO_REQ_DIR_READ)
+		bits |= 3 << 16; /* read mode bit and flush bit */
+	if (no_incr)
+		bits |= 1 << 8;
+	bits |= bpt & 0x3f;
+	out_be32(lpbfifo.regs + LPBFIFO_REG_CONTROL, bits);
+
+	/* Unmask irqs */
+	bits = 0x00000201; /* set error irq & master enabled bit */
+	if (req->dir == MPC512X_LPBFIFO_REQ_DIR_WRITE)
+		bits |= 0x00000100; /* set completion irq too */
+	out_be32(lpbfifo.regs + LPBFIFO_REG_ENABLE, bits);
+
+	/* 4. Set packet size and kick FIFO off */
+	bits = req->size;
+	bits |= (1<<31); /* set restart bit */
+	out_be32(lpbfifo.regs + LPBFIFO_REG_PACKET_SIZE, bits);
+
+
+	/* 5. Then kick DMA off */
+	cookie = dma_tx->tx_submit(dma_tx);
+	if (dma_submit_error(cookie)) {
+		pr_err("DMA tx_submit failed\n");
+		e = -ENOSPC;
+		goto err_dma_submit;
+	}
+
+	return 0;
+
+ err_dma_submit:
+
+ err_dma_prep:
+	dma_unmap_single(dma_dev->dev, sg_dma_address(&sg), req->size, dir);
+
+ err_dma_map:
+	sg_dma_address(&sg) = 0;
+	dma_release_channel(lpbfifo.chan);
+
+ err_align:
+	return e;
+}
+
+int mpc512x_lpbfifo_submit(struct mpc512x_lpbfifo_request *req)
+{
+	unsigned long flags;
+	int result = 0;
+
+	if (!lpbfifo.regs)
+		return -ENODEV;
+
+	spin_lock_irqsave(&lpbfifo.lock, flags);
+
+	/* A transfer is in progress
+	 * if the req pointer is already set */
+	if (lpbfifo.req) {
+		spin_unlock_irqrestore(&lpbfifo.lock, flags);
+		return -EBUSY;
+	}
+
+	/* (128 kBytes - 4 Bytes) is a maximum packet size
+	 * that LPB FIFO and DMA controller can handle together
+	 * while exchanging DEFAULT_WORDS_PER_TRANSFER = 1
+	 * per hardware request */
+	if (req->size > 131068) {
+		spin_unlock_irqrestore(&lpbfifo.lock, flags);
+		return -ENOSPC;
+	}
+
+	/* Setup the transfer */
+	lpbfifo.im_last = 0;
+	lpbfifo.req = req;
+
+	result = mpc512x_lpbfifo_kick(req);
+	if (result != 0)
+		lpbfifo.req = NULL;	/* Set the FIFO as idle */
+
+	spin_unlock_irqrestore(&lpbfifo.lock, flags);
+
+	return result;
+}
+EXPORT_SYMBOL(mpc512x_lpbfifo_submit);
+
+static int mpc512x_lpbfifo_probe(struct platform_device *pdev)
+{
+	struct resource *r = &lpbfifo.res;
+	int e = 0, rc = -ENOMEM;
+
+	if (of_address_to_resource(pdev->dev.of_node, 0, r)) {
+		e = -ENODEV;
+		goto err_res;
+	}
+
+	if (!request_mem_region(r->start, resource_size(r), DRV_NAME)) {
+		e = -EBUSY;
+		goto err_res;
+	}
+
+	lpbfifo.irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
+	if (!lpbfifo.irq) {
+		e = -ENODEV;
+		goto err_res;
+	}
+
+	lpbfifo.regs = ioremap(r->start, resource_size(r));
+	if (!lpbfifo.regs) {
+		e = -ENOMEM;
+		goto err_regs;
+	}
+
+	spin_lock_init(&lpbfifo.lock);
+
+	/* Put FIFO into reset state */
+	out_be32(lpbfifo.regs + LPBFIFO_REG_ENABLE, 0x01010000);
+
+	lpbfifo.dev = &pdev->dev;
+
+	rc = request_irq(lpbfifo.irq,
+				mpc512x_lpbfifo_irq, 0, DRV_NAME, &lpbfifo);
+	if (rc) {
+		e = -ENODEV;
+		goto err_irq;
+	}
+
+	return 0;
+
+ err_irq:
+	iounmap(lpbfifo.regs);
+	lpbfifo.regs = NULL;
+
+ err_regs:
+	release_mem_region(r->start, resource_size(r));
+
+ err_res:
+	dev_err(&pdev->dev, "mpc512x_lpbfifo_probe() failed\n");
+	return e;
+}
+
+static int mpc512x_lpbfifo_remove(struct platform_device *pdev)
+{
+	/* Put FIFO in reset */
+	out_be32(lpbfifo.regs + LPBFIFO_REG_ENABLE, 0x01010000);
+
+	free_irq(lpbfifo.irq, &lpbfifo);
+	iounmap(lpbfifo.regs);
+	release_mem_region(lpbfifo.res.start, resource_size(&lpbfifo.res));
+	lpbfifo.regs = NULL;
+	lpbfifo.dev = NULL;
+
+	return 0;
+}
+
+static const struct of_device_id mpc512x_lpbfifo_match[] = {
+	{ .compatible = "fsl,mpc512x-lpbfifo", },
+	{},
+};
+
+static struct platform_driver mpc512x_lpbfifo_driver = {
+	.probe = mpc512x_lpbfifo_probe,
+	.remove = mpc512x_lpbfifo_remove,
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = mpc512x_lpbfifo_match,
+	},
+};
+module_platform_driver(mpc512x_lpbfifo_driver);
-- 
1.7.11.3

