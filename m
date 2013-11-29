Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab3K2BjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 20:39:18 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:57993 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3K2BjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 20:39:16 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 01/12] thunderbolt: Add initial cactus ridge NHI support
Date: Fri, 29 Nov 2013 02:35:38 +0100
Message-Id: <1385688949-7101-2-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
References: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thunderbolt hotplug is supposed to be handled by the firmware. But Apple
decided to implement thunderbolt at the operating system level. The
firmare only initializes thunderbolt devices that are present at boot
time. This driver enables hotplug of thunderbolt of non-chained thunderbolt
devices on Apple systems.

This first patch adds the Kconfig file as well the parts of the driver
which talk directly to the hardware (that is pci device setup, interrupt
handling and RX/TX ring management).

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/Kconfig                    |   2 +
 drivers/Makefile                   |   1 +
 drivers/thunderbolt/Kconfig        |  12 +
 drivers/thunderbolt/Makefile       |   3 +
 drivers/thunderbolt/dsl3510.c      | 591 +++++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/dsl3510.h      | 116 ++++++++
 drivers/thunderbolt/dsl3510_regs.h | 102 +++++++
 7 files changed, 827 insertions(+)
 create mode 100644 drivers/thunderbolt/Kconfig
 create mode 100644 drivers/thunderbolt/Makefile
 create mode 100644 drivers/thunderbolt/dsl3510.c
 create mode 100644 drivers/thunderbolt/dsl3510.h
 create mode 100644 drivers/thunderbolt/dsl3510_regs.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index b3138fb..c242b6c 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -170,4 +170,6 @@ source "drivers/phy/Kconfig"
 
 source "drivers/powercap/Kconfig"
 
+source "drivers/thunderbolt/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 3cc8214..0062353 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -155,3 +155,4 @@ obj-$(CONFIG_IPACK_BUS)		+= ipack/
 obj-$(CONFIG_NTB)		+= ntb/
 obj-$(CONFIG_FMC)		+= fmc/
 obj-$(CONFIG_POWERCAP)		+= powercap/
+obj-$(CONFIG_THUNDERBOLT)	+= thunderbolt/
diff --git a/drivers/thunderbolt/Kconfig b/drivers/thunderbolt/Kconfig
new file mode 100644
index 0000000..281787a
--- /dev/null
+++ b/drivers/thunderbolt/Kconfig
@@ -0,0 +1,12 @@
+menuconfig THUNDERBOLT
+	tristate "Apple Thunderbolt hotplug support"
+	default no
+	help
+	  Cactus Ridge Thunderbolt Controller driver
+	  This driver is required if you want to hotplug Thunderbolt devices on
+	  Apple hardware.
+
+	  Device chaining is currently not supported.
+
+	  To compile this driver a module, choose M here. The module will be
+	  called thunderbolt.
diff --git a/drivers/thunderbolt/Makefile b/drivers/thunderbolt/Makefile
new file mode 100644
index 0000000..32b0504
--- /dev/null
+++ b/drivers/thunderbolt/Makefile
@@ -0,0 +1,3 @@
+obj-${CONFIG_THUNDERBOLT} := thunderbolt.o
+thunderbolt-objs := dsl3510.o
+
diff --git a/drivers/thunderbolt/dsl3510.c b/drivers/thunderbolt/dsl3510.c
new file mode 100644
index 0000000..2a326f6
--- /dev/null
+++ b/drivers/thunderbolt/dsl3510.c
@@ -0,0 +1,591 @@
+/*
+ * Cactus Ridge NHI driver
+ *
+ * Copyright (c) 2013 Andreas Noever <andreas.noever@gmail.com>
+ */
+
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+
+#include "dsl3510.h"
+#include "dsl3510_regs.h"
+
+#define RING_TYPE(ring) ((ring)->is_tx ? "TX ring" : "RX ring")
+
+static int get_interrupt_index(struct tb_ring *ring)
+{
+	int bit = ring->hop;
+	if (!ring->is_tx)
+		bit += ring->nhi->hop_count;
+	return bit;
+}
+
+/**
+ * interrupt_active() - activate/deactivate interrupts for a single ring
+ *
+ * ring->nhi->lock must be held.
+ */
+static void interrupt_active(struct tb_ring *ring, bool active)
+{
+	int reg = get_interrupt_index(ring) / 32 + REG_RING_INTERRUPT_BASE;
+	int bit = get_interrupt_index(ring) & 31;
+	u32 value;
+	value = ioread32(ring->nhi->iobase + reg);
+	if (active) {
+		if (value & (1 << bit)) {
+			dev_WARN(&ring->nhi->pdev->dev,
+				 "interrupt for %s %d is already enabled\n",
+				 RING_TYPE(ring),
+				 ring->hop);
+		}
+		value |= 1 << bit;
+	} else {
+		if (!(value & (1 << bit))) {
+			dev_WARN(&ring->nhi->pdev->dev,
+				 "interrupt for %s %d is already disabled\n",
+				 RING_TYPE(ring),
+				 ring->hop);
+		}
+		value &= ~(1 << bit);
+	}
+	dev_info(&ring->nhi->pdev->dev,
+		 "%s interrupt at register %#x bit %d (new value: %#x)\n",
+		 active ? "enabling" : "disabling",
+		 reg,
+		 bit,
+		 value);
+	iowrite32(value, ring->nhi->iobase + reg);
+}
+
+/**
+ * dsl3510_disable_interrupts() - disable interrupts for all rings
+ */
+static void dsl3510_disable_interrupts(struct tb_nhi *nhi)
+{
+	int i = 0;
+	/* disable interrupts */
+	for (i = 0; i < RING_INTERRUPT_REG_COUNT(nhi); i++)
+		iowrite32(0, nhi->iobase + REG_RING_INTERRUPT_BASE + 4 * i);
+
+	/* clear interrupt status bits */
+	for (i = 0; i < RING_NOTIFY_REG_COUNT(nhi); i++)
+		ioread32(nhi->iobase + REG_RING_NOTIFY_BASE + 4 * i);
+}
+
+static void __iomem *ring_desc_base(struct tb_ring *ring)
+{
+	void __iomem *io = ring->nhi->iobase;
+	io += ring->is_tx ? REG_TX_RING_BASE : REG_RX_RING_BASE;
+	io += ring->hop * 16;
+	return io;
+}
+
+static void __iomem *ring_options_base(struct tb_ring *ring)
+{
+	void __iomem *io = ring->nhi->iobase;
+	io += ring->is_tx ? REG_TX_OPTIONS_BASE : REG_RX_OPTIONS_BASE;
+	io += ring->hop * 32;
+	return io;
+}
+
+static void ring_iowrite16desc(struct tb_ring *ring, u32 value, u32 offset)
+{
+	iowrite16(value, ring_desc_base(ring) + offset);
+}
+
+static void ring_iowrite32desc(struct tb_ring *ring, u32 value, u32 offset)
+{
+	iowrite32(value, ring_desc_base(ring) + offset);
+}
+
+static void ring_iowrite64desc(struct tb_ring *ring, u64 value, u32 offset)
+{
+	iowrite32(value, ring_desc_base(ring) + offset);
+	iowrite32(value >> 32, ring_desc_base(ring) + offset + 4);
+}
+
+static void ring_iowrite32options(struct tb_ring *ring, u32 value, u32 offset)
+{
+	iowrite32(value, ring_options_base(ring) + offset);
+}
+
+static bool ring_full(struct tb_ring *ring)
+{
+	return ((ring->head + 1) % ring->size) == ring->tail;
+}
+
+static bool ring_empty(struct tb_ring *ring)
+{
+	return ring->head == ring->tail;
+}
+
+/* ring->lock is held. */
+static void ring_write_descriptors(struct tb_ring *ring)
+{
+	struct ring_packet *pkg, *n;
+	struct ring_desc *descriptor;
+	list_for_each_entry_safe(pkg, n, &ring->queue, list) {
+		if (ring_full(ring))
+			break;
+		list_move_tail(&pkg->list, &ring->in_flight);
+		descriptor = &ring->descriptors[ring->head];
+		descriptor->phys = pkg->buffer_phy;
+		descriptor->time = 0;
+		descriptor->flags = RING_DESC_POSTED | RING_DESC_INTERRUPT;
+		if (ring->is_tx) {
+			descriptor->length = pkg->size;
+			descriptor->eof = pkg->eof;
+			descriptor->sof = pkg->sof;
+		}
+		ring->head = (ring->head + 1) % ring->size;
+		ring_iowrite16desc(ring, ring->head, ring->is_tx ? 10 : 8);
+	}
+}
+
+static void ring_handle_interrupt(struct work_struct *work)
+{
+	struct tb_ring *ring = container_of(work, typeof(*ring), work);
+	struct ring_packet *pkg, *n;
+	bool invoke_callback = false;
+	mutex_lock(&ring->lock);
+	if (ring->in_shutdown)
+		goto out;
+	list_for_each_entry_safe(pkg, n, &ring->in_flight, list) {
+		if (ring_empty(ring))
+			break;
+		if (!(ring->descriptors[ring->tail].flags & RING_DESC_COMPLETED))
+			break;
+		list_move_tail(&pkg->list, &ring->done);
+		invoke_callback = true;
+		if (!ring->is_tx) {
+			pkg->size = ring->descriptors[ring->tail].length;
+			pkg->eof = ring->descriptors[ring->tail].eof;
+			pkg->sof = ring->descriptors[ring->tail].sof;
+			pkg->flags = ring->descriptors[ring->tail].flags;
+			if (pkg->sof != 0)
+				dev_WARN(&ring->nhi->pdev->dev,
+					 "%s %d got unexpected SOF: %#x\n",
+					 RING_TYPE(ring),
+					 ring->hop,
+					 pkg->sof);
+
+			/*
+			 * known flags:
+			 * raw enabled: 0xa
+			 * raw not enabled: 0xb
+			 * partial packet (>MAX_FRAME_SIZE): 0xe
+			 */
+			if (pkg->flags != 0xa && pkg->flags != 0xb)
+				dev_WARN(&ring->nhi->pdev->dev,
+					 "%s %d got unexpected flags: %#x\n",
+					 RING_TYPE(ring),
+					 ring->hop,
+					 pkg->flags);
+		}
+		ring->tail = (ring->tail + 1) % ring->size;
+	}
+
+	ring_write_descriptors(ring);
+out:
+	mutex_unlock(&ring->lock); /* allow the callback to queue new work */
+	if (invoke_callback)
+		ring->callback(ring, ring->callback_data);
+}
+
+void __ring_enqueue(struct tb_ring *ring, struct ring_packet *pkg)
+{
+	mutex_lock(&ring->lock);
+	if (ring->in_shutdown) {
+		pkg->canceled = true;
+		list_add_tail(&pkg->list, &ring->done);
+	} else {
+		pkg->canceled = false;
+		list_add_tail(&pkg->list, &ring->queue);
+		ring_write_descriptors(ring);
+	}
+	mutex_unlock(&ring->lock);
+}
+
+/**
+ * ring_poll() - return completed packet if any
+ *
+ * Return: Returns the first completed packet from the done queue. Returns NULL
+ * if the queue is empty.
+ */
+struct ring_packet *ring_poll(struct tb_ring *ring)
+{
+	struct ring_packet *pkg = NULL;
+	mutex_lock(&ring->lock);
+	if (!list_empty(&ring->done)) {
+		pkg = list_entry(ring->done.next, typeof(*pkg), list);
+		list_del(&pkg->list);
+	}
+	mutex_unlock(&ring->lock);
+	return pkg;
+}
+
+static struct tb_ring *ring_alloc(struct tb_nhi *nhi, u32 hop, int size,
+				  ring_cb callback, void *callback_data,
+				  bool transmit)
+{
+	struct tb_ring *ring = NULL;
+	dev_info(&nhi->pdev->dev,
+		 "allocating %s ring %d\n",
+		 transmit ? "TX" : "RX",
+		 hop);
+	mutex_lock(&nhi->lock);
+	if (hop >= nhi->hop_count) {
+		dev_WARN(&nhi->pdev->dev, "invalid hop: %d\n", hop);
+		goto err;
+	}
+	if (transmit && nhi->tx_rings[hop]) {
+		dev_WARN(&nhi->pdev->dev, "TX hop %d already allocated\n", hop);
+		goto err;
+	} else if (!transmit && nhi->rx_rings[hop]) {
+		dev_WARN(&nhi->pdev->dev, "RX hop %d already allocated\n", hop);
+		goto err;
+	}
+	ring = kzalloc(sizeof(*ring), GFP_KERNEL);
+	if (!ring)
+		goto err;
+
+	mutex_init(&ring->lock);
+	ring->nhi = nhi;
+	ring->size = size;
+	ring->hop = hop;
+	ring->head = 0;
+	ring->tail = 0;
+	ring->descriptors = dma_alloc_coherent(&ring->nhi->pdev->dev,
+					       size * sizeof(*ring->descriptors),
+					       &ring->descriptors_dma,
+					       GFP_KERNEL | __GFP_ZERO);
+	if (!ring->descriptors)
+		goto err;
+
+	ring->callback = callback;
+	ring->callback_data = callback_data;
+	ring->is_tx = transmit;
+	ring->in_shutdown = false;
+	INIT_LIST_HEAD(&ring->queue);
+	INIT_LIST_HEAD(&ring->in_flight);
+	INIT_LIST_HEAD(&ring->done);
+	INIT_WORK(&ring->work, ring_handle_interrupt);
+
+	if (transmit)
+		nhi->tx_rings[hop] = ring;
+	else
+		nhi->rx_rings[hop] = ring;
+
+	ring_iowrite64desc(ring, ring->descriptors_dma, 0);
+	if (ring->is_tx) {
+		ring_iowrite32desc(ring, size, 12);
+		ring_iowrite32options(ring, 0, 4); /* time releated ? */
+		ring_iowrite32options(ring,
+				      RING_FLAG_ENABLE | RING_FLAG_RAW,
+				      0);
+	} else {
+		ring_iowrite32desc(ring, (TB_FRAME_SIZE << 16) | size, 12);
+		ring_iowrite32options(ring, 0xffffffff, 4); /* SOF EOF mask */
+		ring_iowrite32options(ring,
+				      RING_FLAG_ENABLE | RING_FLAG_RAW,
+				      0);
+	}
+	interrupt_active(ring, true);
+	mutex_unlock(&nhi->lock);
+	return ring;
+err:
+	mutex_unlock(&nhi->lock);
+	if (ring)
+		mutex_destroy(&ring->lock);
+	kfree(ring);
+	return NULL;
+}
+
+struct tb_ring *ring_alloc_tx(struct tb_nhi *nhi, int hop, int size,
+			      ring_cb callback, void *callback_data)
+{
+	return ring_alloc(nhi, hop, size, callback, callback_data, true);
+}
+
+struct tb_ring *ring_alloc_rx(struct tb_nhi *nhi, int hop, int size,
+			      ring_cb callback, void *callback_data)
+{
+	return ring_alloc(nhi, hop, size, callback, callback_data, false);
+}
+
+/**
+ * ring_drain_and_free() - shutdown a ring
+ *
+ * This method will disable the ring, cancel all packets and repeatedly
+ * call the callback function until all packets have been drained through
+ * ring_poll.
+ *
+ * When this method returns all invocations of ring->callback will have
+ * finished.
+ *
+ * Must NOT be called from ring->callback!
+ */
+void ring_drain_and_free(struct tb_ring *ring)
+{
+	struct ring_packet *pkg;
+	dev_info(&ring->nhi->pdev->dev,
+		 "stopping %s %d\n",
+		 RING_TYPE(ring),
+		 ring->hop);
+
+	mutex_lock(&ring->nhi->lock);
+	mutex_lock(&ring->lock);
+	if (ring->in_shutdown) {
+		dev_WARN(&ring->nhi->pdev->dev,
+			 "%s %d already in_shutdown!\n",
+			 RING_TYPE(ring),
+			 ring->is_tx);
+		mutex_unlock(&ring->nhi->lock);
+		mutex_unlock(&ring->lock);
+		return;
+	}
+	ring->in_shutdown = true;
+
+	interrupt_active(ring, false);
+	if (ring->is_tx)
+		ring->nhi->tx_rings[ring->hop] = NULL;
+	else
+		ring->nhi->rx_rings[ring->hop] = NULL;
+
+	ring_iowrite32options(ring, 0, 0);
+	ring_iowrite64desc(ring, 0, 0);
+	ring_iowrite16desc(ring, 0, ring->is_tx ? 10 : 8);
+	ring_iowrite32desc(ring, 0, 12);
+	dma_free_coherent(&ring->nhi->pdev->dev,
+			  ring->size * sizeof(*ring->descriptors),
+			  ring->descriptors,
+			  ring->descriptors_dma);
+	ring->descriptors = 0;
+	ring->descriptors_dma = 0;
+	ring->head = 0;
+	ring->tail = 0;
+	ring->size = 0;
+
+	/* Move all packets to the done queue and mark them as canceled. */
+	list_for_each_entry(pkg, &ring->in_flight, list)
+		pkg->canceled = true;
+	list_for_each_entry(pkg, &ring->queue, list)
+		pkg->canceled = true;
+	list_splice_tail(&ring->in_flight, &ring->done);
+	list_splice_tail(&ring->queue, &ring->done);
+
+	mutex_unlock(&ring->lock);
+	mutex_unlock(&ring->nhi->lock);
+	/*
+	 * From this point on ring->work will not get scheduled again. Any new
+	 * packets added to the ring will be directly canceled and moved to the
+	 * done queue. The in_flight and queue lists will remain empty.
+	 */
+	cancel_work_sync(&ring->work);
+
+	mutex_lock(&ring->lock);
+	while (!list_empty(&ring->done)) {
+		mutex_unlock(&ring->lock);
+		ring->callback(ring, ring->callback_data);
+		mutex_lock(&ring->lock);
+	}
+	mutex_unlock(&ring->lock);
+	mutex_destroy(&ring->lock);
+	kfree(ring);
+}
+
+static void dsl3510_handle_interrupt(struct work_struct *work)
+{
+	struct tb_nhi *nhi = container_of(work, typeof(*nhi), interrupt_task);
+	int value = 0; /* Suppress uninitialized usage warning. */
+	int bit;
+	int hop = -1;
+	int type = 0; /* current interrupt type 0: TX, 1: RX, 2: RX overflow */
+	struct tb_ring *ring;
+
+	mutex_lock(&nhi->lock);
+
+	/*
+	 * Starting at REG_RING_NOTIFY_BASE there are three status bitfields
+	 * (TX, RX, RX overflow). We iterate over the bits and read a new
+	 * dwords as required. The registers are cleared on read.
+	 */
+	for (bit = 0; bit < 3 * nhi->hop_count; bit++) {
+		if (bit % 32 == 0)
+			value = ioread32(nhi->iobase
+					 + REG_RING_NOTIFY_BASE
+					 + 4 * (bit / 32));
+		if (++hop == nhi->hop_count) {
+			hop = 0;
+			type++;
+		}
+		if ((value & (1 << (bit % 32))) == 0)
+			continue;
+		if (type == 2) {
+			dev_warn(&nhi->pdev->dev,
+				 "RX overflow for ring %d\n",
+				 hop);
+			continue;
+		}
+		if (type == 0)
+			ring = nhi->tx_rings[hop];
+		else
+			ring = nhi->rx_rings[hop];
+		if (ring == NULL) {
+			dev_warn(&nhi->pdev->dev,
+				 "got interrupt for inactive %s ring %d\n",
+				 type ? "RX" : "TX",
+				 hop);
+			continue;
+		}
+		schedule_work(&ring->work);
+	}
+	mutex_unlock(&nhi->lock);
+}
+
+static irqreturn_t dsl3510_msi(int irq, void *data)
+{
+	struct tb_nhi *nhi = data;
+	schedule_work(&nhi->interrupt_task);
+	return IRQ_HANDLED;
+}
+
+static void dsl3510_shutdown(struct tb_nhi *nhi)
+{
+	int i;
+	dev_info(&nhi->pdev->dev, "shutdown\n");
+
+	for (i = 0; i < nhi->hop_count; i++) {
+		if (nhi->tx_rings[i])
+			dev_WARN(&nhi->pdev->dev,
+				 "TX ring %d is still active\n",
+				 i);
+		if (nhi->rx_rings[i])
+			dev_WARN(&nhi->pdev->dev,
+				 "RX ring %d is still active\n",
+				 i);
+	}
+	dsl3510_disable_interrupts(nhi);
+	/*
+	 * We have to release the irq before calling flush_work. Otherwise an
+	 * already executing IRQ handler could call schedule_work again.
+	 */
+	devm_free_irq(&nhi->pdev->dev, nhi->pdev->irq, nhi);
+	flush_work(&nhi->interrupt_task);
+	mutex_destroy(&nhi->lock);
+}
+
+static int dsl3510_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct tb_nhi *nhi;
+	int res;
+
+	res = pcim_enable_device(pdev);
+	if (res) {
+		dev_err(&pdev->dev, "cannot enable PCI device, aborting\n");
+		return res;
+	}
+
+	res = pci_enable_msi(pdev);
+	if (res) {
+		dev_err(&pdev->dev, "cannot enable MSI, aborting\n");
+		return res;
+	}
+
+	res = pcim_iomap_regions(pdev, 1 << 0, "DSL3510");
+	if (res) {
+		dev_err(&pdev->dev, "cannot obtain PCI resources, aborting\n");
+		return res;
+	}
+
+	nhi = devm_kzalloc(&pdev->dev, sizeof(*nhi), GFP_KERNEL);
+	if (!nhi)
+		return -ENOMEM;
+
+	nhi->pdev = pdev;
+	/* cannot fail - table is allocated bin pcim_iomap_regions */
+	nhi->iobase = pcim_iomap_table(pdev)[0];
+	nhi->hop_count = ioread32(nhi->iobase + REG_HOP_COUNT) & 0x3ff;
+	if (nhi->hop_count != 12)
+		dev_warn(&pdev->dev,
+			 "unexpected hop count: %d\n",
+			 nhi->hop_count);
+	INIT_WORK(&nhi->interrupt_task, dsl3510_handle_interrupt);
+
+	nhi->tx_rings = devm_kzalloc(&pdev->dev,
+				     nhi->hop_count * sizeof(struct tb_ring),
+				     GFP_KERNEL);
+	nhi->rx_rings = devm_kzalloc(&pdev->dev,
+				     nhi->hop_count * sizeof(struct tb_ring),
+				     GFP_KERNEL);
+	if (!nhi->tx_rings || !nhi->rx_rings)
+		return -ENOMEM;
+
+	dsl3510_disable_interrupts(nhi); /* In case someone left them on. */
+	res = devm_request_irq(&pdev->dev,
+			       pdev->irq,
+			       dsl3510_msi,
+			       0,
+			       "dsl3510",
+			       nhi);
+	if (res) {
+		dev_err(&pdev->dev, "request_irq failed, aborting\n");
+		return res;
+	}
+
+	mutex_init(&nhi->lock);
+
+	pci_set_master(pdev);
+
+	/* magic value - clock related? */
+	iowrite32(3906250 / 10000, nhi->iobase + 0x38c00);
+
+	pci_set_drvdata(pdev, nhi); /* for dsl3510_remove only */
+
+	return 0;
+}
+
+static void dsl3510_remove(struct pci_dev *pdev)
+{
+	struct tb_nhi *nhi = pci_get_drvdata(pdev);
+	dsl3510_shutdown(nhi);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(dsl3510_ids) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x1547)},
+	{ 0,}
+};
+
+MODULE_DEVICE_TABLE(pci, dsl3510_ids);
+
+static struct pci_driver dsl3510_driver = {
+	.name = "dsl3510",
+	.id_table = dsl3510_ids,
+	.probe = dsl3510_probe,
+	.remove = dsl3510_remove,
+};
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Andreas Noever <andreas.noever@gmail.com>");
+
+static int __init dsl3510_init(void)
+{
+	struct pci_dev *dev = pci_get_device(PCI_VENDOR_ID_INTEL, 0x1547, NULL);
+	if (dev)
+		pci_dev_put(dev);
+	else
+		printk(KERN_INFO "thunderbolt controller not found, try booting with acpi_osi=Darwin");
+
+	return pci_register_driver(&dsl3510_driver);
+}
+
+static void __exit dsl3510_unload(void)
+{
+	pci_unregister_driver(&dsl3510_driver);
+}
+
+module_init(dsl3510_init);
+module_exit(dsl3510_unload);
diff --git a/drivers/thunderbolt/dsl3510.h b/drivers/thunderbolt/dsl3510.h
new file mode 100644
index 0000000..b4b946d
--- /dev/null
+++ b/drivers/thunderbolt/dsl3510.h
@@ -0,0 +1,116 @@
+/*
+ * Cactus Ridge NHI driver
+ *
+ * Copyright (c) 2013 Andreas Noever <andreas.noever@gmail.com>
+ */
+
+#ifndef DSL3510_H_
+#define DSL3510_H_
+
+#include <linux/mutex.h>
+#include <linux/workqueue.h>
+
+/**
+ * struct tb_nhi - thunderbolt native host interface
+ */
+struct tb_nhi {
+	struct mutex lock; /*
+			    * Must be held during ring creation/destruction.
+			    * Is acquired by interrupt_task to when dispatching
+			    * interrupts to individual rings.
+			    **/
+	struct pci_dev *pdev;
+	void __iomem *iobase;
+	struct tb_ring **tx_rings;
+	struct tb_ring **rx_rings;
+	struct work_struct interrupt_task;
+	u32 hop_count; /* Number of rings (end point hops) supported by NHI. */
+};
+
+typedef void (*ring_cb)(struct tb_ring*, void*);
+
+/**
+ * struct tb_ring - thunderbolt TX or RX ring associated with a NHI
+ *
+ * Will invoke callback once data is available. You should then call ring_poll
+ * repeatedly to retrieve all completed (or canceled) packets.
+ */
+struct tb_ring {
+	struct mutex lock; /* must be acquired after nhi->lock */
+	struct tb_nhi *nhi;
+	int size;
+	int hop;
+	int head; /* write next descriptor here */
+	int tail; /* complete next descriptor here */
+	struct ring_desc *descriptors;
+	dma_addr_t descriptors_dma;
+	ring_cb callback;
+	void *callback_data;
+	struct list_head queue;
+	struct list_head in_flight;
+	struct list_head done;
+	struct work_struct work;
+	bool is_tx;
+	bool in_shutdown;
+};
+
+/**
+ * struct ring_packet - packet for use with ring_rx/ring_tx
+ */
+struct ring_packet {
+	void *buffer;
+	dma_addr_t buffer_phy;
+	struct list_head list;
+	u32 size:12;
+	u16 flags:12;
+	u32 eof:4;
+	u32 sof:4;
+	u8 canceled:1;
+};
+
+#define TB_FRAME_SIZE 0x100    /* minimum size for ring_rx */
+
+struct tb_ring *ring_alloc_tx(struct tb_nhi *nhi, int hop, int size,
+			      ring_cb callback, void *callback_data);
+struct tb_ring *ring_alloc_rx(struct tb_nhi *nhi, int hop, int size,
+			      ring_cb callback, void *callback_data);
+void ring_drain_and_free(struct tb_ring *ring);
+
+void __ring_enqueue(struct tb_ring *ring, struct ring_packet *pkg);
+
+/**
+ * ring_rx() - enqueue a packet on an RX ring
+ *
+ * If the ring is about to shut down the packet will be marked as canceled and
+ * put on the done queue.
+ *
+ * pkg->buffer and pkg->buffer_phy have to be set. The buffer must contain at
+ * least TB_FRAME_SIZE bytes. After pkg has been handled and retrieved through
+ * ring_poll pkg->canceled, pkg->size, pkg->eof, pkg->sof and pkg->flags will
+ * be set.
+ */
+static inline void ring_rx(struct tb_ring *ring, struct ring_packet *pkg)
+{
+	WARN_ON(ring->is_tx);
+	__ring_enqueue(ring, pkg);
+}
+
+/**
+ * ring_tx() - enqueue a packet on an TX ring
+ *
+ * If the ring is about to shut down the packet will be marked as canceled and
+ * put on the done queue.
+ *
+ * pkg->buffer, pkg->buffer_phy, pkg->size, pkg->eof, pkg->sof have to be set.
+ * After pkg has been handled and retrieved through ring_poll pkg->canceled
+ * will be set.
+ */
+static inline void ring_tx(struct tb_ring *ring, struct ring_packet *pkg)
+{
+	WARN_ON(!ring->is_tx);
+	__ring_enqueue(ring, pkg);
+}
+
+struct ring_packet *ring_poll(struct tb_ring *ring);
+
+#endif
diff --git a/drivers/thunderbolt/dsl3510_regs.h b/drivers/thunderbolt/dsl3510_regs.h
new file mode 100644
index 0000000..fdfc758
--- /dev/null
+++ b/drivers/thunderbolt/dsl3510_regs.h
@@ -0,0 +1,102 @@
+/*
+ * Cactus Ridge registers
+ *
+ * Copyright (c) 2013 Andreas Noever <andreas.noever@gmail.com>
+ */
+
+#ifndef DSL3510_REGS_H_
+#define DSL3510_REGS_H_
+
+#include <linux/types.h>
+
+enum ring_flags {
+	RING_FLAG_ISOCH_ENABLE = 1 << 27, /* TX only ? */
+	RING_FLAG_E2E_FLOW_CONTROL = 1 << 28,
+	RING_FLAG_PCI_NO_SNOOP = 1 << 29,
+	RING_FLAG_RAW = 1 << 30, /* ignore EOF/SOF mask, include checksum */
+	RING_FLAG_ENABLE = 1 << 31,
+};
+
+enum ring_desc_flags {
+	RING_DESC_ISOCH = 0x1, /* TX only ? */
+	RING_DESC_COMPLETED = 0x2, /* set by NHI */
+	RING_DESC_POSTED = 0x4, /* always set this */
+	RING_DESC_INTERRUPT = 0x8, /* request an interrupt on completion */
+};
+
+/**
+ * struct ring_desc - TX/RX ring entry
+ *
+ * For TX set length/eof/sof.
+ * For RX length/eof/sof are set by the NHI.
+ */
+struct ring_desc {
+	u64 phys;
+	u32 length:12;
+	u32 eof:4;
+	u32 sof:4;
+	enum ring_desc_flags flags:12;
+	u32 time; /* write zero */
+} __packed;
+
+/* NHI registers in bar 0 */
+
+/*
+ * 16 bytes per entry, one entry for every hop (REG_HOP_COUNT)
+ * 00: physical pointer to an array of struct ring_desc
+ * 08: unknown
+ * 10: ring head (index of first non posted descriptor)
+ * 12: descriptor count
+ */
+#define REG_TX_RING_BASE	0x00000
+
+/*
+ * 16 bytes per entry, one entry for every hop (REG_HOP_COUNT)
+ * 00: physical pointer to an array of struct ring_desc
+ * 08: ring head (index of first not posted descriptor)
+ * 10: unknown
+ * 12: descriptor count
+ * 14: max frame sizes (anything larger than 0x100 has no effect)
+ */
+#define REG_RX_RING_BASE	0x08000
+
+/*
+ * 32 bytes per entry, one entry for every hop (REG_HOP_COUNT)
+ * 00: enum_ring_flags
+ * 04: isoch time stamp ?? (write 0)
+ * ..: unknown
+ */
+#define REG_TX_OPTIONS_BASE	0x19800
+
+/*
+ * 32 bytes per entry, one entry for every hop (REG_HOP_COUNT)
+ * 00: enum ring_flags
+ *     If RING_FLAG_E2E_FLOW_CONTROL is set then bits 13-23 must be set to
+ *     the corresponding TX hop id.
+ * 04: EOF/SOF mask (ignored for RING_FLAG_RAW rings)
+ * 08: EOF/SOF mask (ignored for RING_FLAG_RAW rings)
+ * ..: unknown
+ */
+#define REG_RX_OPTIONS_BASE	0x29800
+
+/*
+ * three bitfields: tx, rx, rx overflow
+ * Every bitfield contains one bit for every hop (REG_HOP_COUNT). Registers are
+ * cleared on read. New interrupts are fired only after ALL registers have been
+ * read (even those containing only disabled rings).
+ */
+#define REG_RING_NOTIFY_BASE	0x37800
+#define RING_NOTIFY_REG_COUNT(nhi) ((31 + 3 * nhi->hop_count) / 32)
+
+/*
+ * two bitfields: rx, tx
+ * Both bitfields contains one bit for every hop (REG_HOP_COUNT). To
+ * enable/disable interrupts set/clear the corresponding bits.
+ */
+#define REG_RING_INTERRUPT_BASE	0x38200
+#define RING_INTERRUPT_REG_COUNT(nhi) ((31 + 2 * nhi->hop_count) / 32)
+
+/* The last 11 bits contain the number of hops supported by the NHI port. */
+#define REG_HOP_COUNT		0x39640
+
+#endif
-- 
1.8.4.2

