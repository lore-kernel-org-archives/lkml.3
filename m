Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab3AYTlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 14:41:10 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55857 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab3AYTlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 14:41:04 -0500
Date: Fri, 25 Jan 2013 13:40:50 -0600
From: "Philip J. Kelleher" <pjk1939@us.ibm.com>
To: axboe@kernel.dk
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        brking@linux.vnet.ibm.com
Subject: [PATCH] block: IBM RamSan 70/80 device driver.
Message-ID: <20130125194050.GA28313@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012519-7182-0000-0000-000004B71E7B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joshua H Morris <josh.h.morris@us.ibm.com>
	Philip J Kelleher <pjk1939@us.ibm.com>

This patch includes the device driver for the IBM RamSan family
of PCI SSD flash storage cards. This driver will inlcude support for the
RamSan 70 and 80. The driver presents a block device for device I/O.

Signed-off-by: Philip J Kelleher <pjk1939@us.ibm.com>

-------------------------------------------------------------------------------

diff -uprN -X linux-3.7.3-vanilla/Documentation/dontdiff linux-3.7.3-vanilla/drivers/block/Kconfig linux-3.7.3/drivers/block/Kconfig
--- linux-3.7.3-vanilla/drivers/block/Kconfig	2013-01-17 10:47:40.000000000 -0600
+++ linux-3.7.3/drivers/block/Kconfig	2013-01-23 11:32:01.340302416 -0600
@@ -544,4 +544,15 @@ config BLK_DEV_RBD
 
 	  If unsure, say N.
 
+config BLK_DEV_RSXX
+	tristate "RamSam PCIe Flash SSD Device Driver"
+	depends on PCI
+	help
+	  Device driver for Texas Memory Systems, an IBM company's high
+	  speed PCIe SSD storage devices: RamSan-70(Sugarland) and
+	  RamSan-80(Katy).
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rsxx.
+
 endif # BLK_DEV
diff -uprN -X linux-3.7.3-vanilla/Documentation/dontdiff linux-3.7.3-vanilla/drivers/block/Makefile linux-3.7.3/drivers/block/Makefile
--- linux-3.7.3-vanilla/drivers/block/Makefile	2013-01-17 10:47:40.000000000 -0600
+++ linux-3.7.3/drivers/block/Makefile	2013-01-23 11:32:05.805300901 -0600
@@ -41,4 +41,6 @@ obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
 obj-$(CONFIG_BLK_DEV_RBD)     += rbd.o
 obj-$(CONFIG_BLK_DEV_PCIESSD_MTIP32XX)	+= mtip32xx/
 
+obj-$(CONFIG_BLK_DEV_RSXX) += rsxx/
+
 swim_mod-y	:= swim.o swim_asm.o
diff -uprN -X linux-3.7.3-vanilla/Documentation/dontdiff linux-3.7.3-vanilla/drivers/block/rsxx/config.c linux-3.7.3/drivers/block/rsxx/config.c
--- linux-3.7.3-vanilla/drivers/block/rsxx/config.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-3.7.3/drivers/block/rsxx/config.c	2013-01-23 11:30:02.192552501 -0600
@@ -0,0 +1,213 @@
+/*
+* Filename: config.c
+*
+*
+* Authors: Joshua Morris <josh.h.morris@us.ibm.com>
+*	Philip Kelleher <pjk1939@us.ibm.com>
+*
+* (C) Copyright 2013 IBM Corporation
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation; either version 2 of the
+* License, or (at your option) any later version.
+*
+* This program is distributed in the hope that it will be useful, but
+* WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+* General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software Foundation,
+* Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+*/
+
+#include <linux/types.h>
+#include <linux/crc32.h>
+#include <linux/swab.h>
+
+#include "rsxx_priv.h"
+#include "rsxx_cfg.h"
+
+static void initialize_config(void *config)
+{
+	struct rsxx_card_cfg *cfg = (struct rsxx_card_cfg *) config;
+
+	cfg->hdr.version = RSXX_CFG_VERSION;
+
+	cfg->data.block_size        = RSXX_HW_BLK_SIZE;
+	cfg->data.stripe_size       = RSXX_HW_BLK_SIZE;
+	cfg->data.vendor_id         = RSXX_VENDOR_ID_TMS_IBM;
+	cfg->data.cache_order       = (-1);
+	cfg->data.intr_coal.mode    = RSXX_INTR_COAL_DISABLED;
+	cfg->data.intr_coal.count   = 0;
+	cfg->data.intr_coal.latency = 0;
+}
+
+static u32 config_data_crc32(struct rsxx_card_cfg *cfg)
+{
+	/*
+	 * Return the compliment of the CRC to ensure compatibility
+	 * (i.e. this is how early rsxx drivers did it.)
+	 */
+
+	return ~crc32(~0, &cfg->data, sizeof(cfg->data));
+}
+
+
+/*----------------- Config Byte Swap Functions -------------------*/
+static void config_hdr_be_to_cpu(struct card_cfg_hdr *hdr)
+{
+	hdr->version = be32_to_cpu((__force __be32) hdr->version);
+	hdr->crc     = be32_to_cpu((__force __be32) hdr->crc);
+}
+
+static void config_hdr_cpu_to_be(struct card_cfg_hdr *hdr)
+{
+	hdr->version = (__force u32) cpu_to_be32(hdr->version);
+	hdr->crc     = (__force u32) cpu_to_be32(hdr->crc);
+}
+
+static void config_data_swab(struct rsxx_card_cfg *cfg)
+{
+	u32 *data = (u32 *) &cfg->data;
+	int i;
+
+	for (i = 0; i < (sizeof(cfg->data) / 4); i++)
+		data[i] = swab32(data[i]);
+}
+
+static void config_data_le_to_cpu(struct rsxx_card_cfg *cfg)
+{
+	u32 *data = (u32 *) &cfg->data;
+	int i;
+
+	for (i = 0; i < (sizeof(cfg->data) / 4); i++)
+		data[i] = le32_to_cpu((__force __le32) data[i]);
+}
+
+static void config_data_cpu_to_le(struct rsxx_card_cfg *cfg)
+{
+	u32 *data = (u32 *) &cfg->data;
+	int i;
+
+	for (i = 0; i < (sizeof(cfg->data) / 4); i++)
+		data[i] = (__force u32) cpu_to_le32(data[i]);
+}
+
+
+/*----------------- Config Operations ------------------*/
+int rsxx_save_config(struct rsxx_cardinfo *card)
+{
+	struct rsxx_card_cfg cfg;
+	int st;
+
+	memcpy(&cfg, &card->config, sizeof(cfg));
+
+	if (unlikely(cfg.hdr.version != RSXX_CFG_VERSION)) {
+		dev_err(CARD_TO_DEV(card),
+			"Cannot save config with invalid version %d\n",
+			cfg.hdr.version);
+		return -EINVAL;
+	}
+
+	/* Convert data to little endian for the CRC calculation. */
+	config_data_cpu_to_le(&cfg);
+
+	cfg.hdr.crc = config_data_crc32(&cfg);
+
+	/*
+	 * Swap the data from little endian to big endian so it can be
+	 * stored.
+	 */
+	config_data_swab(&cfg);
+	config_hdr_cpu_to_be(&cfg.hdr);
+
+	st = rsxx_creg_write(card, CREG_ADD_CONFIG, sizeof(cfg), &cfg, 1);
+	if (st)
+		return st;
+
+	return 0;
+}
+
+int rsxx_load_config(struct rsxx_cardinfo *card)
+{
+	int st;
+	u32 crc;
+
+	st = rsxx_creg_read(card, CREG_ADD_CONFIG, sizeof(card->config),
+				&card->config, 1);
+	if (st) {
+		dev_err(CARD_TO_DEV(card),
+			"Failed reading card config.\n");
+		return st;
+	}
+
+	config_hdr_be_to_cpu(&card->config.hdr);
+
+	if (card->config.hdr.version == RSXX_CFG_VERSION) {
+		/*
+		 * We calculate the CRC with the data in little endian, because
+		 * early drivers did not take big endian CPUs into account.
+		 * The data is always stored in big endian, so we need to byte
+		 * swap it before calculating the CRC.
+		 */
+
+		config_data_swab(&card->config);
+
+		/* Check the CRC */
+		crc = config_data_crc32(&card->config);
+		if (crc != card->config.hdr.crc) {
+			dev_err(CARD_TO_DEV(card),
+				"Config corruption detected!\n");
+			dev_info(CARD_TO_DEV(card),
+				"CRC (sb x%08x is x%08x)\n",
+				card->config.hdr.crc, crc);
+			return -EIO;
+		}
+
+		/* Convert the data to CPU byteorder */
+		config_data_le_to_cpu(&card->config);
+
+	} else if (card->config.hdr.version != 0) {
+		dev_err(CARD_TO_DEV(card),
+			"Invalid config version %d.\n",
+			card->config.hdr.version);
+		/*
+		 * Config version changes require special handling from the
+		 * user
+		 */
+		return -EINVAL;
+	} else {
+		dev_info(CARD_TO_DEV(card),
+			"Initializing card configuration.\n");
+		initialize_config(card);
+		st = rsxx_save_config(card);
+		if (st)
+			return st;
+	}
+
+	card->config_valid = 1;
+
+	dev_dbg(CARD_TO_DEV(card), "version:     x%08x\n",
+		card->config.hdr.version);
+	dev_dbg(CARD_TO_DEV(card), "crc:         x%08x\n",
+		card->config.hdr.crc);
+	dev_dbg(CARD_TO_DEV(card), "block_size:  x%08x\n",
+		card->config.data.block_size);
+	dev_dbg(CARD_TO_DEV(card), "stripe_size: x%08x\n",
+		card->config.data.stripe_size);
+	dev_dbg(CARD_TO_DEV(card), "vendor_id:   x%08x\n",
+		card->config.data.vendor_id);
+	dev_dbg(CARD_TO_DEV(card), "cache_order: x%08x\n",
+		card->config.data.cache_order);
+	dev_dbg(CARD_TO_DEV(card), "mode:        x%08x\n",
+		card->config.data.intr_coal.mode);
+	dev_dbg(CARD_TO_DEV(card), "count:       x%08x\n",
+		card->config.data.intr_coal.count);
+	dev_dbg(CARD_TO_DEV(card), "latency:     x%08x\n",
+		 card->config.data.intr_coal.latency);
+
+	return 0;
+}
+
diff -uprN -X linux-3.7.3-vanilla/Documentation/dontdiff linux-3.7.3-vanilla/drivers/block/rsxx/core.c linux-3.7.3/drivers/block/rsxx/core.c
--- linux-3.7.3-vanilla/drivers/block/rsxx/core.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-3.7.3/drivers/block/rsxx/core.c	2013-01-23 11:30:02.197281363 -0600
@@ -0,0 +1,651 @@
+/*
+* Filename: core.c
+*
+*
+* Authors: Joshua Morris <josh.h.morris@us.ibm.com>
+*	Philip Kelleher <pjk1939@us.ibm.com>
+*
+* (C) Copyright 2013 IBM Corporation
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation; either version 2 of the
+* License, or (at your option) any later version.
+*
+* This program is distributed in the hope that it will be useful, but
+* WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+* General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software Foundation,
+* Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+*/
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/reboot.h>
+#include <linux/slab.h>
+#include <linux/bitops.h>
+
+#include <linux/genhd.h>
+#include <linux/idr.h>
+
+#include "rsxx_priv.h"
+#include "rsxx_cfg.h"
+
+#define NO_LEGACY 0
+
+MODULE_DESCRIPTION("IBM RamSan PCIe Flash SSD Device Driver");
+MODULE_AUTHOR("Texas Memory Systems, an IBM Company <support@ramsan.com>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRIVER_VERSION);
+
+static unsigned int force_legacy = NO_LEGACY;
+module_param(force_legacy, uint, 0444);
+MODULE_PARM_DESC(force_legacy, "Force the use of legacy type PCI interrupts");
+
+static DEFINE_IDA(rsxx_disk_ida);
+static DEFINE_SPINLOCK(rsxx_ida_lock);
+
+/*----------------- Interrupt Control & Handling -------------------*/
+static void __enable_intr(unsigned int *mask, unsigned int intr)
+{
+	*mask |= intr;
+}
+
+static void __disable_intr(unsigned int *mask, unsigned int intr)
+{
+	*mask &= ~intr;
+}
+
+/*
+ * NOTE: Disabling the IER will disable the hardware interrupt.
+ * Disabling the ISR will disable the software handling of the ISR bit.
+ *
+ * Enable/Disable interrupt functions assume the card->irq_lock
+ * is held by the caller.
+ */
+void rsxx_enable_ier(struct rsxx_cardinfo *card, unsigned int intr)
+{
+	if (unlikely(card->halt))
+		return;
+
+	__enable_intr(&card->ier_mask, intr);
+	iowrite32(card->ier_mask, card->regmap + IER);
+}
+
+void rsxx_disable_ier(struct rsxx_cardinfo *card, unsigned int intr)
+{
+	__disable_intr(&card->ier_mask, intr);
+	iowrite32(card->ier_mask, card->regmap + IER);
+}
+
+void rsxx_enable_ier_and_isr(struct rsxx_cardinfo *card,
+				 unsigned int intr)
+{
+	if (unlikely(card->halt))
+		return;
+
+	__enable_intr(&card->isr_mask, intr);
+	__enable_intr(&card->ier_mask, intr);
+	iowrite32(card->ier_mask, card->regmap + IER);
+}
+void rsxx_disable_ier_and_isr(struct rsxx_cardinfo *card,
+				  unsigned int intr)
+{
+	__disable_intr(&card->isr_mask, intr);
+	__disable_intr(&card->ier_mask, intr);
+	iowrite32(card->ier_mask, card->regmap + IER);
+}
+
+irqreturn_t rsxx_isr(int irq, void *pdata)
+{
+	struct rsxx_cardinfo *card = (struct rsxx_cardinfo *) pdata;
+	unsigned int isr;
+	int handled = 0;
+	int reread_isr;
+	int i;
+
+	spin_lock(&card->irq_lock);
+
+	do {
+		reread_isr = 0;
+
+		isr = ioread32(card->regmap + ISR);
+		if (isr == 0xffffffff) {
+			/*
+			 * A few systems seem to have an intermittent issue
+			 * where PCI reads return all Fs, but retrying the read
+			 * a little later will return as expected.
+			 */
+			dev_info(CARD_TO_DEV(card),
+				"ISR = 0xFFFFFFFF, retrying later\n");
+			break;
+		}
+
+		isr &= card->isr_mask;
+		if (!isr)
+			break;
+
+		for (i = 0; i < card->n_targets; i++) {
+			if (isr & CR_INTR_DMA(i)) {
+				if (card->ier_mask & CR_INTR_DMA(i)) {
+					rsxx_disable_ier(card, CR_INTR_DMA(i));
+					reread_isr = 1;
+				}
+				queue_work(card->ctrl[i].done_wq,
+					   &card->ctrl[i].dma_done_work);
+				handled++;
+			}
+		}
+
+		if (isr & CR_INTR_CREG) {
+			schedule_work(&card->creg_ctrl.done_work);
+			handled++;
+		}
+
+		if (isr & CR_INTR_EVENT) {
+			schedule_work(&card->event_work);
+			rsxx_disable_ier_and_isr(card, CR_INTR_EVENT);
+			handled++;
+		}
+	} while (reread_isr);
+
+	spin_unlock(&card->irq_lock);
+
+	return handled ? IRQ_HANDLED : IRQ_NONE;
+}
+
+/*----------------- Card Event Handler -------------------*/
+static void card_state_change(struct rsxx_cardinfo *card,
+			      unsigned int new_state)
+{
+	int st;
+
+	dev_info(CARD_TO_DEV(card),
+		"card state change detected.(%s -> %s)\n",
+		rsxx_card_state_to_str(card->state),
+		rsxx_card_state_to_str(new_state));
+
+	card->state = new_state;
+
+	/* Don't attach DMA interfaces if the card has an invalid config */
+	if (!card->config_valid)
+		return;
+
+	switch (new_state) {
+	case CARD_STATE_RD_ONLY_FAULT:
+		dev_crit(CARD_TO_DEV(card),
+			"Hardware has entered read-only mode!\n");
+		/*
+		 * Fall through so the DMA devices can be attached and
+		 * the user can attempt to pull off their data.
+		 */
+	case CARD_STATE_GOOD:
+		st = rsxx_get_card_size8(card, &card->size8);
+		if (st)
+			dev_err(CARD_TO_DEV(card),
+				"Failed attaching DMA devices\n");
+
+		if (card->config_valid)
+			set_capacity(card->gendisk, card->size8 >> 9);
+		break;
+
+	case CARD_STATE_FAULT:
+		dev_crit(CARD_TO_DEV(card),
+			"Hardware Fault reported!\n");
+		/* Fall through. */
+
+	/* Everything else, detach DMA interface if it's attached. */
+	case CARD_STATE_SHUTDOWN:
+	case CARD_STATE_STARTING:
+	case CARD_STATE_FORMATTING:
+	case CARD_STATE_UNINITIALIZED:
+	case CARD_STATE_SHUTTING_DOWN:
+	/*
+	 * dStroy is a term coined by marketing to represent the low level
+	 * secure erase.
+	 */
+	case CARD_STATE_DSTROYING:
+		set_capacity(card->gendisk, 0);
+		break;
+	}
+}
+
+static void card_event_handler(struct work_struct *work)
+{
+	struct rsxx_cardinfo *card;
+	unsigned int state;
+	unsigned long flags;
+	int st;
+
+	card = container_of(work, struct rsxx_cardinfo, event_work);
+
+	if (unlikely(card->halt))
+		return;
+
+	/*
+	 * Enable the interrupt now to avoid any weird race conditions where a
+	 * state change might occur while rsxx_get_card_state() is
+	 * processing a returned creg cmd.
+	 */
+	spin_lock_irqsave(&card->irq_lock, flags);
+	rsxx_enable_ier_and_isr(card, CR_INTR_EVENT);
+	spin_unlock_irqrestore(&card->irq_lock, flags);
+
+	st = rsxx_get_card_state(card, &state);
+	if (st) {
+		dev_info(CARD_TO_DEV(card),
+			"Failed reading state after event.\n");
+		return;
+	}
+
+	if (card->state != state)
+		card_state_change(card, state);
+
+	if (card->creg_ctrl.creg_stats.stat & CREG_STAT_LOG_PENDING)
+		rsxx_read_hw_log(card);
+}
+
+
+char *rsxx_card_state_to_str(unsigned int state)
+{
+	static char *state_strings[] = {
+		"Unknown", "Shutdown", "Starting", "Formatting",
+		"Uninitialized", "Good", "Shutting Down",
+		"Fault", "Read Only Fault", "dStroying"
+	};
+
+	return state_strings[ffs(state)];
+}
+
+/*----------------- Card Operations -------------------*/
+static int card_shutdown(struct rsxx_cardinfo *card)
+{
+	unsigned int state;
+	signed long start;
+	const int timeout = msecs_to_jiffies(120000);
+	int st;
+
+	/* We can't issue a shutdown if the card is in a transition state */
+	start = jiffies;
+	do {
+		st = rsxx_get_card_state(card, &state);
+		if (st)
+			return st;
+	} while (state == CARD_STATE_STARTING &&
+		 (jiffies - start < timeout));
+
+	if (state == CARD_STATE_STARTING)
+		return -ETIMEDOUT;
+
+	/* Only issue a shutdown if we need to */
+	if ((state != CARD_STATE_SHUTTING_DOWN) &&
+	    (state != CARD_STATE_SHUTDOWN)) {
+		st = rsxx_issue_card_cmd(card, CARD_CMD_SHUTDOWN);
+		if (st)
+			return st;
+	}
+
+	start = jiffies;
+	do {
+		st = rsxx_get_card_state(card, &state);
+		if (st)
+			return st;
+	} while (state != CARD_STATE_SHUTDOWN &&
+		 (jiffies - start < timeout));
+
+	if (state != CARD_STATE_SHUTDOWN)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+/*----------------- Driver Initialization & Setup -------------------*/
+/* Returns:   0 if the driver is compatible with the device
+	     -1 if the driver is NOT compatible with the device */
+static int rsxx_compatibility_check(struct rsxx_cardinfo *card)
+{
+	unsigned char pci_rev;
+
+	pci_read_config_byte(card->dev, PCI_REVISION_ID, &pci_rev);
+
+	if (pci_rev > RS70_PCI_REV_SUPPORTED)
+		return -1;
+	return 0;
+}
+
+static int __devinit rsxx_pci_probe(struct pci_dev *dev,
+					const struct pci_device_id *id)
+{
+	struct rsxx_cardinfo *card;
+	unsigned long flags;
+	int st;
+
+	dev_info(&dev->dev, "PCI-Flash SSD discovered\n");
+
+	card = kzalloc(sizeof(*card), GFP_KERNEL);
+	if (!card)
+		return -ENOMEM;
+
+	card->dev = dev;
+	pci_set_drvdata(dev, card);
+
+	do {
+		if (!ida_pre_get(&rsxx_disk_ida, GFP_KERNEL)) {
+			st = -ENOMEM;
+			goto failed_ida_get;
+		}
+
+		spin_lock(&rsxx_ida_lock);
+		st = ida_get_new(&rsxx_disk_ida, &card->disk_id);
+		spin_unlock(&rsxx_ida_lock);
+	} while (st == -EAGAIN);
+
+	if (st)
+		goto failed_ida_get;
+
+	st = pci_enable_device(dev);
+	if (st)
+		goto failed_enable;
+
+	pci_set_master(dev);
+	pci_set_dma_max_seg_size(dev, RSXX_HW_BLK_SIZE);
+
+	st = pci_set_dma_mask(dev, DMA_BIT_MASK(64));
+	if (st) {
+		dev_err(CARD_TO_DEV(card),
+			"No usable DMA configuration,aborting\n");
+		goto failed_dma_mask;
+	}
+
+	st = pci_request_regions(dev, DRIVER_NAME);
+	if (st) {
+		dev_err(CARD_TO_DEV(card),
+			"Failed to request memory region\n");
+		goto failed_request_regions;
+	}
+
+	if (pci_resource_len(dev, 0) == 0) {
+		dev_err(CARD_TO_DEV(card), "BAR0 has length 0!\n");
+		st = -ENOMEM;
+		goto failed_iomap;
+	}
+
+	card->regmap = pci_iomap(dev, 0, 0);
+	if (!card->regmap) {
+		dev_err(CARD_TO_DEV(card), "Failed to map BAR0\n");
+		st = -ENOMEM;
+		goto failed_iomap;
+	}
+
+	spin_lock_init(&card->irq_lock);
+	card->halt = 0;
+
+	spin_lock_irqsave(&card->irq_lock, flags);
+	rsxx_disable_ier_and_isr(card, CR_INTR_ALL);
+	spin_unlock_irqrestore(&card->irq_lock, flags);
+
+	if (!force_legacy) {
+		st = pci_enable_msi(dev);
+		if (st)
+			dev_warn(CARD_TO_DEV(card),
+				"Failed to enable MSI\n");
+	}
+
+	st = request_irq(dev->irq, rsxx_isr, IRQF_DISABLED | IRQF_SHARED,
+			 DRIVER_NAME, card);
+	if (st) {
+		dev_err(CARD_TO_DEV(card),
+			"Failed requesting IRQ%d\n", dev->irq);
+		goto failed_irq;
+	}
+
+	/************* Setup Processor Command Interface *************/
+	rsxx_creg_setup(card);
+
+	spin_lock_irqsave(&card->irq_lock, flags);
+	rsxx_enable_ier_and_isr(card, CR_INTR_CREG);
+	spin_unlock_irqrestore(&card->irq_lock, flags);
+
+	st = rsxx_compatibility_check(card);
+	if (st) {
+		dev_warn(CARD_TO_DEV(card),
+			"Incompatible driver detected. Please update the driver.\n");
+		st = -EINVAL;
+		goto failed_compatiblity_check;
+	}
+
+	/************* Load Card Config *************/
+	st = rsxx_load_config(card);
+	if (st)
+		dev_err(CARD_TO_DEV(card),
+			"Failed loading card config\n");
+
+	/************* Setup DMA Engine *************/
+	st = rsxx_get_num_targets(card, &card->n_targets);
+	if (st)
+		dev_info(CARD_TO_DEV(card),
+			"Failed reading the number of DMA targets\n");
+
+	card->ctrl = kzalloc(card->n_targets * sizeof(*card->ctrl), GFP_KERNEL);
+	if (!card->ctrl) {
+		st = -ENOMEM;
+		goto failed_dma_setup;
+	}
+
+	st = rsxx_dma_setup(card);
+	if (st) {
+		dev_info(CARD_TO_DEV(card),
+			"Failed to setup DMA engine\n");
+		goto failed_dma_setup;
+	}
+
+	/************* Setup Card Event Handler *************/
+	INIT_WORK(&card->event_work, card_event_handler);
+
+	st = rsxx_setup_dev(card);
+	if (st)
+		goto failed_create_dev;
+
+	rsxx_get_card_state(card, &card->state);
+
+	dev_info(CARD_TO_DEV(card),
+		"card state: %s\n",
+		rsxx_card_state_to_str(card->state));
+
+	/*
+	 * Now that the DMA Engine and devices have been setup,
+	 * we can enable the event interrupt(it kicks off actions in
+	 * those layers so we couldn't enable it right away.)
+	 */
+	spin_lock_irqsave(&card->irq_lock, flags);
+	rsxx_enable_ier_and_isr(card, CR_INTR_EVENT);
+	spin_unlock_irqrestore(&card->irq_lock, flags);
+
+	if (card->state == CARD_STATE_SHUTDOWN) {
+		st = rsxx_issue_card_cmd(card, CARD_CMD_STARTUP);
+		if (st)
+			dev_crit(CARD_TO_DEV(card),
+				"Failed issuing card startup\n");
+	} else if (card->state == CARD_STATE_GOOD ||
+		   card->state == CARD_STATE_RD_ONLY_FAULT) {
+		st = rsxx_get_card_size8(card, &card->size8);
+		if (st)
+			card->size8 = 0;
+	}
+
+	rsxx_attach_dev(card);
+
+	return 0;
+
+failed_create_dev:
+	rsxx_dma_destroy(card);
+failed_dma_setup:
+failed_compatiblity_check:
+	spin_lock_irqsave(&card->irq_lock, flags);
+	rsxx_disable_ier_and_isr(card, CR_INTR_ALL);
+	spin_unlock_irqrestore(&card->irq_lock, flags);
+	free_irq(dev->irq, card);
+	if (!force_legacy)
+		pci_disable_msi(dev);
+failed_irq:
+	pci_iounmap(dev, card->regmap);
+failed_iomap:
+	pci_release_regions(dev);
+failed_request_regions:
+failed_dma_mask:
+	pci_disable_device(dev);
+failed_enable:
+	spin_lock(&rsxx_ida_lock);
+	ida_remove(&rsxx_disk_ida, card->disk_id);
+	spin_unlock(&rsxx_ida_lock);
+failed_ida_get:
+	kfree(card);
+
+	return st;
+}
+
+static void __devexit rsxx_pci_remove(struct pci_dev *dev)
+{
+	struct rsxx_cardinfo *card = pci_get_drvdata(dev);
+	unsigned long flags;
+	int st;
+	int i;
+
+	if (!card)
+		return;
+
+	dev_info(CARD_TO_DEV(card),
+		"Removing PCI-Flash SSD.\n");
+
+	rsxx_detach_dev(card);
+
+	for (i = 0; i < card->n_targets; i++) {
+		spin_lock_irqsave(&card->irq_lock, flags);
+		rsxx_disable_ier_and_isr(card, CR_INTR_DMA(i));
+		spin_unlock_irqrestore(&card->irq_lock, flags);
+	}
+
+	st = card_shutdown(card);
+	if (st)
+		dev_crit(CARD_TO_DEV(card), "Shutdown failed!\n");
+
+	/* Sync outstanding event handlers. */
+	spin_lock_irqsave(&card->irq_lock, flags);
+	rsxx_disable_ier_and_isr(card, CR_INTR_EVENT);
+	spin_unlock_irqrestore(&card->irq_lock, flags);
+
+	/* Prevent work_structs from re-queuing themselves. */
+	card->halt = 1;
+
+	cancel_work_sync(&card->event_work);
+
+	rsxx_destroy_dev(card);
+	rsxx_dma_destroy(card);
+
+	spin_lock_irqsave(&card->irq_lock, flags);
+	rsxx_disable_ier_and_isr(card, CR_INTR_ALL);
+	spin_unlock_irqrestore(&card->irq_lock, flags);
+	free_irq(dev->irq, card);
+
+	if (!force_legacy)
+		pci_disable_msi(dev);
+
+	rsxx_creg_destroy(card);
+
+	pci_iounmap(dev, card->regmap);
+
+	pci_disable_device(dev);
+	pci_release_regions(dev);
+
+	kfree(card);
+}
+
+static int rsxx_pci_suspend(struct pci_dev *dev, pm_message_t state)
+{
+	/* We don't support suspend at this time. */
+	return -ENOSYS;
+}
+
+static void rsxx_pci_shutdown(struct pci_dev *dev)
+{
+	struct rsxx_cardinfo *card = pci_get_drvdata(dev);
+	unsigned long flags;
+	int i;
+
+	if (!card)
+		return;
+
+	dev_info(CARD_TO_DEV(card), "Shutting down PCI-Flash SSD.\n");
+
+	rsxx_detach_dev(card);
+
+	for (i = 0; i < card->n_targets; i++) {
+		spin_lock_irqsave(&card->irq_lock, flags);
+		rsxx_disable_ier_and_isr(card, CR_INTR_DMA(i));
+		spin_unlock_irqrestore(&card->irq_lock, flags);
+	}
+
+	card_shutdown(card);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(rsxx_pci_ids) = {
+	{PCI_DEVICE(PCI_VENDOR_ID_TMS_IBM, PCI_DEVICE_ID_RS70_FLASH)},
+	{PCI_DEVICE(PCI_VENDOR_ID_TMS_IBM, PCI_DEVICE_ID_RS70D_FLASH)},
+	{PCI_DEVICE(PCI_VENDOR_ID_TMS_IBM, PCI_DEVICE_ID_RS80_FLASH)},
+	{PCI_DEVICE(PCI_VENDOR_ID_TMS_IBM, PCI_DEVICE_ID_RS81_FLASH)},
+	{0,},
+};
+
+MODULE_DEVICE_TABLE(pci, rsxx_pci_ids);
+
+static struct pci_driver rsxx_pci_driver = {
+	.name		= DRIVER_NAME,
+	.id_table	= rsxx_pci_ids,
+	.probe		= rsxx_pci_probe,
+	.remove		= __devexit_p(rsxx_pci_remove),
+	.suspend	= rsxx_pci_suspend,
+	.shutdown	= rsxx_pci_shutdown,
+};
+
+static int __init rsxx_core_init(void)
+{
+	int st;
+
+	st = rsxx_dev_init();
+	if (st)
+		return st;
+
+	st = rsxx_dma_init();
+	if (st)
+		goto dma_init_failed;
+
+	st = rsxx_creg_init();
+	if (st)
+		goto creg_init_failed;
+
+	return pci_register_driver(&rsxx_pci_driver);
+
+creg_init_failed:
+	rsxx_dma_cleanup();
+dma_init_failed:
+	rsxx_dev_cleanup();
+
+	return st;
+}
+
+static void __exit rsxx_core_cleanup(void)
+{
+	pci_unregister_driver(&rsxx_pci_driver);
+	rsxx_creg_cleanup();
+	rsxx_dma_cleanup();
+	rsxx_dev_cleanup();
+}
+
+module_init(rsxx_core_init);
+module_exit(rsxx_core_cleanup);
diff -uprN -X linux-3.7.3-vanilla/Documentation/dontdiff linux-3.7.3-vanilla/drivers/block/rsxx/cregs.c linux-3.7.3/drivers/block/rsxx/cregs.c
--- linux-3.7.3-vanilla/drivers/block/rsxx/cregs.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-3.7.3/drivers/block/rsxx/cregs.c	2013-01-23 11:30:02.204327904 -0600
@@ -0,0 +1,743 @@
+/*
+* Filename: cregs.c
+*
+*
+* Authors: Joshua Morris <josh.h.morris@us.ibm.com>
+*	Philip Kelleher <pjk1939@us.ibm.com>
+*
+* (C) Copyright 2013 IBM Corporation
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation; either version 2 of the
+* License, or (at your option) any later version.
+*
+* This program is distributed in the hope that it will be useful, but
+* WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+* General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software Foundation,
+* Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+*/
+
+#include <linux/completion.h>
+#include <linux/slab.h>
+
+#include "rsxx_priv.h"
+
+#define CREG_TIMEOUT_MSEC	10000
+
+typedef void (*creg_cmd_cb)(struct rsxx_cardinfo *card,
+			    struct creg_cmd *cmd,
+			    int st);
+
+struct creg_cmd {
+	struct list_head list;
+	creg_cmd_cb cb;
+	void *cb_private;
+	unsigned int op;
+	unsigned int addr;
+	int cnt8;
+	void *buf;
+	unsigned int stream;
+	unsigned int status;
+};
+
+static struct kmem_cache *creg_cmd_pool;
+
+
+/*------------ Private Functions --------------*/
+
+#if defined(__LITTLE_ENDIAN)
+#define LITTLE_ENDIAN 1
+#elif defined(__BIG_ENDIAN)
+#define LITTLE_ENDIAN 0
+#else
+#error Unknown endianess!!! Aborting...
+#endif
+
+static void copy_to_creg_data(struct rsxx_cardinfo *card,
+			      int cnt8,
+			      void *buf,
+			      unsigned int stream)
+{
+	int i = 0;
+	u32 *data = buf;
+
+	for (i = 0; cnt8 > 0; i++, cnt8 -= 4) {
+		/*
+		 * Firmware implementation makes it necessary to byte swap on
+		 * little endian processors.
+		 */
+		if (LITTLE_ENDIAN && stream)
+			iowrite32be(data[i], card->regmap + CREG_DATA(i));
+		else
+			iowrite32(data[i], card->regmap + CREG_DATA(i));
+	}
+}
+
+
+static void copy_from_creg_data(struct rsxx_cardinfo *card,
+				int cnt8,
+				void *buf,
+				unsigned int stream)
+{
+	int i = 0;
+	u32 *data = buf;
+
+	for (i = 0; cnt8 > 0; i++, cnt8 -= 4) {
+		/*
+		 * Firmware implementation makes it necessary to byte swap on
+		 * little endian processors.
+		 */
+		if (LITTLE_ENDIAN && stream)
+			data[i] = ioread32be(card->regmap + CREG_DATA(i));
+		else
+			data[i] = ioread32(card->regmap + CREG_DATA(i));
+	}
+}
+
+static struct creg_cmd *pop_active_cmd(struct rsxx_cardinfo *card)
+{
+	struct creg_cmd *cmd;
+
+	/*
+	 * Spin lock is needed because this can be called in atomic/interrupt
+	 * context.
+	 */
+	spin_lock_bh(&card->creg_ctrl.pop_lock);
+	cmd = card->creg_ctrl.active_cmd;
+	card->creg_ctrl.active_cmd = NULL;
+	spin_unlock_bh(&card->creg_ctrl.pop_lock);
+
+	return cmd;
+}
+
+static void creg_issue_cmd(struct rsxx_cardinfo *card, struct creg_cmd *cmd)
+{
+	iowrite32(cmd->addr, card->regmap + CREG_ADD);
+	iowrite32(cmd->cnt8, card->regmap + CREG_CNT);
+
+	if (cmd->op == CREG_OP_WRITE) {
+		if (cmd->buf)
+			copy_to_creg_data(card, cmd->cnt8,
+					  cmd->buf, cmd->stream);
+	}
+
+	/* Data copy must complete before initiating the command. */
+	wmb();
+
+	/* Setting the valid bit will kick off the command. */
+	iowrite32(cmd->op, card->regmap + CREG_CMD);
+}
+
+static void creg_kick_queue(struct rsxx_cardinfo *card)
+{
+	if (card->creg_ctrl.active || list_empty(&card->creg_ctrl.queue))
+		return;
+
+	card->creg_ctrl.active = 1;
+	card->creg_ctrl.active_cmd = list_first_entry(&card->creg_ctrl.queue,
+						      struct creg_cmd, list);
+	list_del(&card->creg_ctrl.active_cmd->list);
+	card->creg_ctrl.q_depth--;
+
+	/*
+	 * We have to set the timer before we push the new command. Otherwise,
+	 * we could create a race condition that would occur if the timer
+	 * was not canceled, and expired after the new command was pushed,
+	 * but before the command was issued to hardware.
+	 */
+	mod_timer(&card->creg_ctrl.cmd_timer,
+				jiffies + msecs_to_jiffies(CREG_TIMEOUT_MSEC));
+
+	creg_issue_cmd(card, card->creg_ctrl.active_cmd);
+}
+
+static int creg_queue_cmd(struct rsxx_cardinfo *card,
+			  unsigned int op,
+			  unsigned int addr,
+			  unsigned int cnt8,
+			  void *buf,
+			  int stream,
+			  creg_cmd_cb callback,
+			  void *cb_private)
+{
+	struct creg_cmd *cmd;
+
+	/* Don't queue stuff up if we're halted. */
+	if (unlikely(card->halt))
+		return -EINVAL;
+
+	if (card->creg_ctrl.reset)
+		return -EAGAIN;
+
+	if (cnt8 > MAX_CREG_DATA8)
+		return -EINVAL;
+
+	cmd = kmem_cache_alloc(creg_cmd_pool, GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&cmd->list);
+
+	cmd->op		= op;
+	cmd->addr	= addr;
+	cmd->cnt8	= cnt8;
+	cmd->buf	= buf;
+	cmd->stream	= stream;
+	cmd->cb		= callback;
+	cmd->cb_private = cb_private;
+	cmd->status	= 0;
+
+	mutex_lock(&card->creg_ctrl.lock);
+	list_add_tail(&cmd->list, &card->creg_ctrl.queue);
+	card->creg_ctrl.q_depth++;
+	creg_kick_queue(card);
+	mutex_unlock(&card->creg_ctrl.lock);
+
+	return 0;
+}
+
+static void creg_cmd_timed_out(unsigned long data)
+{
+	struct rsxx_cardinfo *card = (struct rsxx_cardinfo *) data;
+	struct creg_cmd *cmd;
+
+	cmd = pop_active_cmd(card);
+	if (cmd == NULL) {
+		card->creg_ctrl.creg_stats.creg_timeout++;
+		dev_warn(CARD_TO_DEV(card),
+			"No active command associated with timeout!\n");
+		return;
+	}
+
+	if (cmd->cb)
+		cmd->cb(card, cmd, -ETIMEDOUT);
+
+	kmem_cache_free(creg_cmd_pool, cmd);
+
+	spin_lock(&card->creg_ctrl.pop_lock);
+	card->creg_ctrl.active = 0;
+	creg_kick_queue(card);
+	spin_unlock(&card->creg_ctrl.pop_lock);
+}
+
+
+static void creg_cmd_done(struct work_struct *work)
+{
+	struct rsxx_cardinfo *card;
+	struct creg_cmd *cmd;
+	int st = 0;
+
+	card = container_of(work, struct rsxx_cardinfo,
+			    creg_ctrl.done_work);
+
+	/*
+	 * The timer could not be cancelled for some reason,
+	 * race to pop the active command.
+	 */
+	if (del_timer_sync(&card->creg_ctrl.cmd_timer) == 0)
+		card->creg_ctrl.creg_stats.failed_cancel_timer++;
+
+	cmd = pop_active_cmd(card);
+	if (cmd == NULL) {
+		dev_err(CARD_TO_DEV(card),
+			"Spurious creg interrupt!\n");
+		return;
+	}
+
+	card->creg_ctrl.creg_stats.stat = ioread32(card->regmap + CREG_STAT);
+	cmd->status = card->creg_ctrl.creg_stats.stat;
+	if ((cmd->status & CREG_STAT_STATUS_MASK) == 0) {
+		dev_err(CARD_TO_DEV(card),
+			"Invalid status on creg command\n");
+		/*
+		 * At this point we're probably reading garbage from HW. Don't
+		 * do anything else that could mess up the system and let
+		 * the sync function return an error.
+		 */
+		st = -EIO;
+		goto creg_done;
+	} else if (cmd->status & CREG_STAT_ERROR) {
+		st = -EIO;
+	}
+
+	if ((cmd->op == CREG_OP_READ)) {
+		unsigned int cnt8 = ioread32(card->regmap + CREG_CNT);
+
+		/* Paranoid Sanity Checks */
+		if (!cmd->buf) {
+			dev_err(CARD_TO_DEV(card),
+				"Buffer not given for read.\n");
+			st = -EIO;
+			goto creg_done;
+		}
+		if (cnt8 != cmd->cnt8) {
+			dev_err(CARD_TO_DEV(card),
+				"count mismatch\n");
+			st = -EIO;
+			goto creg_done;
+		}
+
+		copy_from_creg_data(card, cnt8, cmd->buf, cmd->stream);
+	}
+
+creg_done:
+	if (cmd->cb)
+		cmd->cb(card, cmd, st);
+
+	kmem_cache_free(creg_cmd_pool, cmd);
+
+	mutex_lock(&card->creg_ctrl.lock);
+	card->creg_ctrl.active = 0;
+	creg_kick_queue(card);
+	mutex_unlock(&card->creg_ctrl.lock);
+}
+
+static void creg_reset(struct rsxx_cardinfo *card)
+{
+	struct creg_cmd *cmd = NULL;
+	struct creg_cmd *tmp;
+	unsigned long flags;
+
+	if (!mutex_trylock(&card->creg_ctrl.reset_lock))
+		return;
+
+	card->creg_ctrl.reset = 1;
+	spin_lock_irqsave(&card->irq_lock, flags);
+	rsxx_disable_ier_and_isr(card, CR_INTR_CREG | CR_INTR_EVENT);
+	spin_unlock_irqrestore(&card->irq_lock, flags);
+
+	dev_warn(CARD_TO_DEV(card),
+		"Resetting creg interface for recovery\n");
+
+	/* Cancel outstanding commands */
+	mutex_lock(&card->creg_ctrl.lock);
+	list_for_each_entry_safe(cmd, tmp, &card->creg_ctrl.queue, list) {
+		list_del(&cmd->list);
+		card->creg_ctrl.q_depth--;
+		if (cmd->cb)
+			cmd->cb(card, cmd, -ECANCELED);
+		kmem_cache_free(creg_cmd_pool, cmd);
+	}
+
+	cmd = card->creg_ctrl.active_cmd;
+	card->creg_ctrl.active_cmd = NULL;
+	if (cmd) {
+		if (timer_pending(&card->creg_ctrl.cmd_timer))
+			del_timer_sync(&card->creg_ctrl.cmd_timer);
+
+		if (cmd->cb)
+			cmd->cb(card, cmd, -ECANCELED);
+		kmem_cache_free(creg_cmd_pool, cmd);
+
+		card->creg_ctrl.active = 0;
+	}
+	mutex_unlock(&card->creg_ctrl.lock);
+
+	card->creg_ctrl.reset = 0;
+	spin_lock_irqsave(&card->irq_lock, flags);
+	rsxx_enable_ier_and_isr(card, CR_INTR_CREG | CR_INTR_EVENT);
+	spin_unlock_irqrestore(&card->irq_lock, flags);
+
+	mutex_unlock(&card->creg_ctrl.reset_lock);
+}
+
+/* Used for synchronous accesses */
+struct creg_completion {
+	struct completion	*cmd_done;
+	int			st;
+	u32			creg_status;
+};
+
+static void creg_cmd_done_cb(struct rsxx_cardinfo *card,
+			     struct creg_cmd *cmd,
+			     int st)
+{
+	struct creg_completion *cmd_completion;
+
+	cmd_completion = (struct creg_completion *)cmd->cb_private;
+	BUG_ON(!cmd_completion);
+
+	cmd_completion->st = st;
+	cmd_completion->creg_status = cmd->status;
+	complete(cmd_completion->cmd_done);
+}
+
+static int __issue_creg_rw(struct rsxx_cardinfo *card,
+			   unsigned int op,
+			   unsigned int addr,
+			   unsigned int cnt8,
+			   void *buf,
+			   int stream,
+			   unsigned int *hw_stat)
+{
+	DECLARE_COMPLETION_ONSTACK(cmd_done);
+	struct creg_completion completion;
+	unsigned long timeout;
+	int st;
+
+	INIT_COMPLETION(cmd_done);
+	completion.cmd_done = &cmd_done;
+	completion.st = 0;
+	completion.creg_status = 0;
+
+	st = creg_queue_cmd(card, op, addr, cnt8, buf, stream, creg_cmd_done_cb,
+			    &completion);
+	if (st)
+		return st;
+
+	timeout = msecs_to_jiffies((CREG_TIMEOUT_MSEC *
+				    card->creg_ctrl.q_depth) + 20000);
+
+	/*
+	 * The creg interface is guaranteed to complete. It has a timeout
+	 * mechanism that will kick in if hardware does not respond.
+	 */
+	st = wait_for_completion_timeout(completion.cmd_done, timeout);
+	if (st == 0) {
+		/*
+		 * This is really bad, because the kernel timer did not
+		 * expire and notify us of a timeout!
+		 */
+		dev_crit(CARD_TO_DEV(card),
+			"cregs timer failed\n");
+		creg_reset(card);
+		return -EIO;
+	}
+
+	*hw_stat = completion.creg_status;
+
+	if (completion.st) {
+		dev_warn(CARD_TO_DEV(card),
+			"creg command failed(%d x%08x)\n",
+			completion.st, addr);
+		return completion.st;
+	}
+
+	return 0;
+}
+
+static int issue_creg_rw(struct rsxx_cardinfo *card,
+			 u32 addr,
+			 unsigned int size8,
+			 void *data,
+			 int stream,
+			 int read)
+{
+	unsigned int hw_stat;
+	unsigned int xfer;
+	unsigned int op;
+	int st;
+
+	op = read ? CREG_OP_READ : CREG_OP_WRITE;
+
+	do {
+		xfer = min_t(unsigned int, size8, MAX_CREG_DATA8);
+
+		st = __issue_creg_rw(card, op, addr, xfer,
+				     data, stream, &hw_stat);
+		if (st)
+			return st;
+
+		data   = (void *)((char *)data + xfer);
+		addr  += xfer;
+		size8 -= xfer;
+	} while (size8);
+
+	return 0;
+}
+
+/* ---------------------------- Public API ---------------------------------- */
+int rsxx_creg_write(struct rsxx_cardinfo *card,
+			u32 addr,
+			unsigned int size8,
+			void *data,
+			int byte_stream)
+{
+	return issue_creg_rw(card, addr, size8, data, byte_stream, 0);
+}
+
+int rsxx_creg_read(struct rsxx_cardinfo *card,
+		       u32 addr,
+		       unsigned int size8,
+		       void *data,
+		       int byte_stream)
+{
+	return issue_creg_rw(card, addr, size8, data, byte_stream, 1);
+}
+
+int rsxx_get_card_state(struct rsxx_cardinfo *card, unsigned int *state)
+{
+	return rsxx_creg_read(card, CREG_ADD_CARD_STATE,
+				  sizeof(*state), state, 0);
+}
+
+int rsxx_get_card_size8(struct rsxx_cardinfo *card, u64 *size8)
+{
+	unsigned int size;
+	int st;
+
+	st = rsxx_creg_read(card, CREG_ADD_CARD_SIZE,
+				sizeof(size), &size, 0);
+	if (st)
+		return st;
+
+	*size8 = (u64)size * RSXX_HW_BLK_SIZE;
+	return 0;
+}
+
+int rsxx_get_num_targets(struct rsxx_cardinfo *card,
+			     unsigned int *n_targets)
+{
+	return rsxx_creg_read(card, CREG_ADD_NUM_TARGETS,
+				  sizeof(*n_targets), n_targets, 0);
+}
+
+int rsxx_get_card_capabilities(struct rsxx_cardinfo *card,
+				   u32 *capabilities)
+{
+	return rsxx_creg_read(card, CREG_ADD_CAPABILITIES,
+				  sizeof(*capabilities), capabilities, 0);
+}
+
+int rsxx_issue_card_cmd(struct rsxx_cardinfo *card, u32 cmd)
+{
+	return rsxx_creg_write(card, CREG_ADD_CARD_CMD,
+				   sizeof(cmd), &cmd, 0);
+}
+
+
+/*----------------- HW Log Functions -------------------*/
+static void hw_log_msg(struct rsxx_cardinfo *card, const char *str, int len)
+{
+	static char level;
+
+	/*
+	 * New messages start with "<#>", where # is the log level. Messages
+	 * that extend past the log buffer will use the previous level
+	 */
+	if ((len > 3) && (str[0] == '<') && (str[2] == '>')) {
+		level = str[1];
+		str += 3; /* Skip past the log level. */
+		len -= 3;
+	}
+
+	switch (level) {
+	case '0':
+		dev_emerg(CARD_TO_DEV(card), "HW: %.*s", len, str);
+		break;
+	case '1':
+		dev_alert(CARD_TO_DEV(card), "HW: %.*s", len, str);
+		break;
+	case '2':
+		dev_crit(CARD_TO_DEV(card), "HW: %.*s", len, str);
+		break;
+	case '3':
+		dev_err(CARD_TO_DEV(card), "HW: %.*s", len, str);
+		break;
+	case '4':
+		dev_warn(CARD_TO_DEV(card), "HW: %.*s", len, str);
+		break;
+	case '5':
+		dev_notice(CARD_TO_DEV(card), "HW: %.*s", len, str);
+		break;
+	case '6':
+		dev_info(CARD_TO_DEV(card), "HW: %.*s", len, str);
+		break;
+	case '7':
+		dev_dbg(CARD_TO_DEV(card), "HW: %.*s", len, str);
+		break;
+	default:
+		dev_info(CARD_TO_DEV(card), "HW: %.*s", len, str);
+		break;
+	}
+}
+
+/*
+ * The substrncpy() function copies to string(up to count bytes) point to by src
+ * (including the terminating '\0' character) to dest. Returns the number of
+ * bytes copied to dest.
+ */
+static int substrncpy(char *dest, const char *src, int count)
+{
+	int max_cnt = count;
+
+	while (count) {
+		count--;
+		*dest = *src;
+		if (*dest == '\0')
+			break;
+		src++;
+		dest++;
+	}
+	return max_cnt - count;
+}
+
+
+static void read_hw_log_done(struct rsxx_cardinfo *card,
+			     struct creg_cmd *cmd,
+			     int st)
+{
+	char *buf;
+	char *log_str;
+	int cnt;
+	int len;
+	int off;
+
+	buf = cmd->buf;
+	off = 0;
+
+	/* Failed getting the log message */
+	if (st)
+		return;
+
+	while (off < cmd->cnt8) {
+		log_str = &card->log.buf[card->log.buf_len];
+		cnt = min(cmd->cnt8 - off, LOG_BUF_SIZE8 - card->log.buf_len);
+		len = substrncpy(log_str, &buf[off], cnt);
+
+		off += len;
+		card->log.buf_len += len;
+
+		/*
+		 * Flush the log if we've hit the end of a message or if we've
+		 * run out of buffer space.
+		 */
+		if ((log_str[len - 1] == '\0')  ||
+		    (card->log.buf_len == LOG_BUF_SIZE8)) {
+			if (card->log.buf_len != 1) /* Don't log blank lines. */
+				hw_log_msg(card, card->log.buf,
+					   card->log.buf_len);
+			card->log.buf_len = 0;
+		}
+
+	}
+
+	if (cmd->status & CREG_STAT_LOG_PENDING)
+		rsxx_read_hw_log(card);
+}
+
+int rsxx_read_hw_log(struct rsxx_cardinfo *card)
+{
+	int st;
+
+	st = creg_queue_cmd(card, CREG_OP_READ, CREG_ADD_LOG,
+			    sizeof(card->log.tmp), card->log.tmp,
+			    1, read_hw_log_done, NULL);
+	if (st)
+		dev_err(CARD_TO_DEV(card),
+			"Failed getting log text\n");
+
+	return st;
+}
+
+/*-------------- IOCTL REG Access ------------------*/
+static int issue_reg_cmd(struct rsxx_cardinfo *card,
+			 struct rsxx_reg_access *cmd,
+			 int read)
+{
+	unsigned int op = read ? CREG_OP_READ : CREG_OP_WRITE;
+
+	return __issue_creg_rw(card, op, cmd->addr, cmd->cnt, cmd->data,
+			       cmd->stream, &cmd->stat);
+}
+
+int rsxx_reg_access(struct rsxx_cardinfo *card,
+			struct rsxx_reg_access __user *ucmd,
+			int read)
+{
+	struct rsxx_reg_access cmd;
+	int st;
+
+	st = copy_from_user(&cmd, ucmd, sizeof(cmd));
+	if (st)
+		return -EFAULT;
+
+	st = issue_reg_cmd(card, &cmd, read);
+	if (st)
+		return st;
+
+	st = put_user(cmd.stat, &ucmd->stat);
+	if (st)
+		return -EFAULT;
+
+	if (read) {
+		st = copy_to_user(ucmd->data, cmd.data, cmd.cnt);
+		if (st)
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+/*------------ Initialization & Setup --------------*/
+int rsxx_creg_setup(struct rsxx_cardinfo *card)
+{
+	card->creg_ctrl.active_cmd = NULL;
+
+	INIT_WORK(&card->creg_ctrl.done_work, creg_cmd_done);
+	mutex_init(&card->creg_ctrl.reset_lock);
+	INIT_LIST_HEAD(&card->creg_ctrl.queue);
+	mutex_init(&card->creg_ctrl.lock);
+	spin_lock_init(&card->creg_ctrl.pop_lock);
+	setup_timer(&card->creg_ctrl.cmd_timer, creg_cmd_timed_out,
+		    (unsigned long) card);
+
+	return 0;
+}
+
+void rsxx_creg_destroy(struct rsxx_cardinfo *card)
+{
+	struct creg_cmd *cmd;
+	struct creg_cmd *tmp;
+	int cnt = 0;
+
+	/* Cancel outstanding commands */
+	mutex_lock(&card->creg_ctrl.lock);
+	list_for_each_entry_safe(cmd, tmp, &card->creg_ctrl.queue, list) {
+		list_del(&cmd->list);
+		if (cmd->cb)
+			cmd->cb(card, cmd, -ECANCELED);
+		kmem_cache_free(creg_cmd_pool, cmd);
+		cnt++;
+	}
+
+	if (cnt)
+		dev_info(CARD_TO_DEV(card),
+			"Canceled %d queue creg commands\n", cnt);
+
+	cmd = card->creg_ctrl.active_cmd;
+	card->creg_ctrl.active_cmd = NULL;
+	if (cmd) {
+		if (timer_pending(&card->creg_ctrl.cmd_timer))
+			del_timer_sync(&card->creg_ctrl.cmd_timer);
+
+		if (cmd->cb)
+			cmd->cb(card, cmd, -ECANCELED);
+		dev_info(CARD_TO_DEV(card),
+			"Canceled active creg command\n");
+		kmem_cache_free(creg_cmd_pool, cmd);
+	}
+	mutex_unlock(&card->creg_ctrl.lock);
+
+	cancel_work_sync(&card->creg_ctrl.done_work);
+}
+
+
+int rsxx_creg_init(void)
+{
+	creg_cmd_pool = KMEM_CACHE(creg_cmd, SLAB_HWCACHE_ALIGN);
+	if (!creg_cmd_pool)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void rsxx_creg_cleanup(void)
+{
+	kmem_cache_destroy(creg_cmd_pool);
+}
diff -uprN -X linux-3.7.3-vanilla/Documentation/dontdiff linux-3.7.3-vanilla/drivers/block/rsxx/dev.c linux-3.7.3/drivers/block/rsxx/dev.c
--- linux-3.7.3-vanilla/drivers/block/rsxx/dev.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-3.7.3/drivers/block/rsxx/dev.c	2013-01-23 11:30:02.188259210 -0600
@@ -0,0 +1,366 @@
+/*
+* Filename: dev.c
+*
+*
+* Authors: Joshua Morris <josh.h.morris@us.ibm.com>
+*	Philip Kelleher <pjk1939@us.ibm.com>
+*
+* (C) Copyright 2013 IBM Corporation
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation; either version 2 of the
+* License, or (at your option) any later version.
+*
+* This program is distributed in the hope that it will be useful, but
+* WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+* General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software Foundation,
+* Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+*/
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+
+#include <linux/hdreg.h>
+#include <linux/genhd.h>
+#include <linux/blkdev.h>
+#include <linux/bio.h>
+
+#include <linux/fs.h>
+
+#include "rsxx_priv.h"
+
+static unsigned int blkdev_minors = 64;
+module_param(blkdev_minors, uint, 0444);
+MODULE_PARM_DESC(blkdev_minors, "Number of minors(partitions)");
+
+/*
+ * For now I'm making this tweakable in case any applications hit this limit.
+ * If you see a "bio too big" error in the log you will need to raise this
+ * value.
+ */
+static unsigned int blkdev_max_hw_sectors = 1024;
+module_param(blkdev_max_hw_sectors, uint, 0444);
+MODULE_PARM_DESC(blkdev_max_hw_sectors, "Max hw sectors for a single BIO");
+
+static unsigned int enable_blkdev = 1;
+module_param(enable_blkdev , uint, 0444);
+MODULE_PARM_DESC(enable_blkdev, "Enable block device interfaces");
+
+
+struct rsxx_bio_meta {
+	struct bio	*bio;
+	atomic_t	pending_dmas;
+	atomic_t	error;
+	unsigned long	start_time;
+};
+
+static struct kmem_cache *bio_meta_pool;
+
+/*----------------- Block Device Operations -----------------*/
+static int rsxx_blkdev_ioctl(struct block_device *bdev,
+				 fmode_t mode,
+				 unsigned int cmd,
+				 unsigned long arg)
+{
+	struct rsxx_cardinfo *card = bdev->bd_disk->private_data;
+
+	switch (cmd) {
+	case RSXX_GETREG:
+		return rsxx_reg_access(card, (void __user *)arg, 1);
+	case RSXX_SETREG:
+		return rsxx_reg_access(card, (void __user *)arg, 0);
+	}
+
+	return -ENOTTY;
+}
+
+static int rsxx_getgeo(struct block_device *bdev, struct hd_geometry *geo)
+{
+	struct rsxx_cardinfo *card = bdev->bd_disk->private_data;
+	u64 blocks = card->size8 >> 9;
+
+	/*
+	 * get geometry: Fake it. I haven't found any drivers that set
+	 * geo->start, so we won't either.
+	 */
+	if (card->size8) {
+		geo->heads = 64;
+		geo->sectors = 16;
+		do_div(blocks, (geo->heads * geo->sectors));
+		geo->cylinders = blocks;
+	} else {
+		geo->heads = 0;
+		geo->sectors = 0;
+		geo->cylinders = 0;
+	}
+	return 0;
+}
+
+static const struct block_device_operations rsxx_fops = {
+	.owner		= THIS_MODULE,
+	.getgeo		= rsxx_getgeo,
+	.ioctl		= rsxx_blkdev_ioctl,
+};
+
+static void disk_stats_start(struct rsxx_cardinfo *card, struct bio *bio)
+{
+	struct hd_struct *part0 = &card->gendisk->part0;
+	int rw = bio_data_dir(bio);
+	int cpu;
+
+	cpu = part_stat_lock();
+
+	part_round_stats(cpu, part0);
+	part_inc_in_flight(part0, rw);
+
+	part_stat_unlock();
+}
+
+static void disk_stats_complete(struct rsxx_cardinfo *card,
+				struct bio *bio,
+				unsigned long start_time)
+{
+	struct hd_struct *part0 = &card->gendisk->part0;
+	unsigned long duration = jiffies - start_time;
+	int rw = bio_data_dir(bio);
+	int cpu;
+
+	cpu = part_stat_lock();
+
+	part_stat_add(cpu, part0, sectors[rw], bio_sectors(bio));
+	part_stat_inc(cpu, part0, ios[rw]);
+	part_stat_add(cpu, part0, ticks[rw], duration);
+
+	part_round_stats(cpu, part0);
+	part_dec_in_flight(part0, rw);
+
+	part_stat_unlock();
+}
+
+static void bio_dma_done_cb(struct rsxx_cardinfo *card,
+			    void *cb_data,
+			    unsigned int error)
+{
+	struct rsxx_bio_meta *meta = (struct rsxx_bio_meta *)cb_data;
+
+	if (error)
+		atomic_set(&meta->error, 1);
+
+	if (atomic_dec_and_test(&meta->pending_dmas)) {
+		disk_stats_complete(card, meta->bio, meta->start_time);
+
+		bio_endio(meta->bio, atomic_read(&meta->error) ? -EIO : 0);
+		kmem_cache_free(bio_meta_pool, meta);
+	}
+}
+
+static void rsxx_make_request(struct request_queue *q, struct bio *bio)
+{
+	struct rsxx_cardinfo *card = q->queuedata;
+	struct rsxx_bio_meta *bio_meta;
+	int st = -EINVAL;
+
+	might_sleep();
+
+	if (unlikely(card->halt)) {
+		st = -EFAULT;
+		goto req_err;
+	}
+
+	if (unlikely(card->dma_fault)) {
+		st = (-EFAULT);
+		goto req_err;
+	}
+
+	if (bio->bi_size == 0) {
+		dev_err(CARD_TO_DEV(card), "size zero BIO!\n");
+		goto req_err;
+	}
+
+	bio_meta = kmem_cache_alloc(bio_meta_pool, GFP_KERNEL);
+	if (!bio_meta) {
+		st = -ENOMEM;
+		goto req_err;
+	}
+
+	bio_meta->bio = bio;
+	atomic_set(&bio_meta->error, 0);
+	atomic_set(&bio_meta->pending_dmas, 0);
+	bio_meta->start_time = jiffies;
+
+	disk_stats_start(card, bio);
+
+	dev_dbg(CARD_TO_DEV(card), "BIO[%c]: meta: %p addr8: x%llx size: %d\n",
+		 bio_data_dir(bio) ? 'W' : 'R', bio_meta,
+		 (u64)bio->bi_sector << 9, bio->bi_size);
+
+	st = rsxx_dma_queue_bio(card, bio, &bio_meta->pending_dmas,
+				    bio_dma_done_cb, bio_meta);
+	if (st)
+		goto queue_err;
+
+	return;
+
+queue_err:
+	kmem_cache_free(bio_meta_pool, bio_meta);
+req_err:
+	bio_endio(bio, st);
+}
+
+/*----------------- Device Setup -------------------*/
+static bool rsxx_discard_supported(struct rsxx_cardinfo *card)
+{
+	unsigned char pci_rev;
+
+	pci_read_config_byte(card->dev, PCI_REVISION_ID, &pci_rev);
+
+	return (pci_rev >= RSXX_DISCARD_SUPPORT);
+}
+
+static unsigned short rsxx_get_logical_block_size(
+					struct rsxx_cardinfo *card)
+{
+	u32 capabilities = 0;
+	int st;
+
+	st = rsxx_get_card_capabilities(card, &capabilities);
+	if (st)
+		dev_warn(CARD_TO_DEV(card),
+			"Failed reading card capabilities register\n");
+
+	/* Earlier firmware did not have support for 512 byte accesses */
+	if (capabilities & CARD_CAP_SUBPAGE_WRITES)
+		return 512;
+	else
+		return RSXX_HW_BLK_SIZE;
+}
+
+int rsxx_attach_dev(struct rsxx_cardinfo *card)
+{
+	mutex_lock(&card->dev_lock);
+
+	/* The block device requires the stripe size from the config. */
+	if (enable_blkdev) {
+		if (card->config_valid)
+			set_capacity(card->gendisk, card->size8 >> 9);
+		else
+			set_capacity(card->gendisk, 0);
+		add_disk(card->gendisk);
+
+		card->bdev_attached = 1;
+	}
+
+	mutex_unlock(&card->dev_lock);
+
+	return 0;
+}
+
+void rsxx_detach_dev(struct rsxx_cardinfo *card)
+{
+	mutex_lock(&card->dev_lock);
+
+	if (card->bdev_attached) {
+		del_gendisk(card->gendisk);
+		card->bdev_attached = 0;
+	}
+
+	mutex_unlock(&card->dev_lock);
+}
+
+int rsxx_setup_dev(struct rsxx_cardinfo *card)
+{
+	unsigned short blk_size;
+
+	mutex_init(&card->dev_lock);
+
+	if (!enable_blkdev)
+		return 0;
+
+	card->major = register_blkdev(0, DRIVER_NAME);
+	if (card->major < 0) {
+		dev_err(CARD_TO_DEV(card), "Failed to get major number\n");
+		return -ENOMEM;
+	}
+
+	card->queue = blk_alloc_queue(GFP_KERNEL);
+	if (!card->queue) {
+		dev_err(CARD_TO_DEV(card), "Failed queue alloc\n");
+		unregister_blkdev(card->major, DRIVER_NAME);
+		return -ENOMEM;
+	}
+
+	card->gendisk = alloc_disk(blkdev_minors);
+	if (!card->gendisk) {
+		dev_err(CARD_TO_DEV(card), "Failed disk alloc\n");
+		blk_cleanup_queue(card->queue);
+		unregister_blkdev(card->major, DRIVER_NAME);
+		return -ENOMEM;
+	}
+
+	blk_size = rsxx_get_logical_block_size(card);
+
+	blk_queue_make_request(card->queue, rsxx_make_request);
+	blk_queue_bounce_limit(card->queue, BLK_BOUNCE_ANY);
+	blk_queue_dma_alignment(card->queue, blk_size - 1);
+	blk_queue_max_hw_sectors(card->queue, blkdev_max_hw_sectors);
+	blk_queue_logical_block_size(card->queue, blk_size);
+	blk_queue_physical_block_size(card->queue, RSXX_HW_BLK_SIZE);
+	blk_queue_max_discard_sectors(card->queue, RSXX_HW_BLK_SIZE >> 9);
+
+	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, card->queue);
+	if (rsxx_discard_supported(card)) {
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, card->queue);
+		card->queue->limits.discard_granularity = RSXX_HW_BLK_SIZE;
+		card->queue->limits.discard_alignment   = RSXX_HW_BLK_SIZE;
+		card->queue->limits.discard_zeroes_data = 1;
+	}
+
+	card->queue->queuedata = card;
+
+	snprintf(card->gendisk->disk_name, sizeof(card->gendisk->disk_name),
+		 "rsxx%d", card->disk_id);
+	card->gendisk->driverfs_dev = &card->dev->dev;
+	card->gendisk->major = card->major;
+	card->gendisk->first_minor = 0;
+	card->gendisk->fops = &rsxx_fops;
+	card->gendisk->private_data = card;
+	card->gendisk->queue = card->queue;
+
+	return 0;
+}
+
+void rsxx_destroy_dev(struct rsxx_cardinfo *card)
+{
+	if (!enable_blkdev)
+		return;
+
+	put_disk(card->gendisk);
+	card->gendisk = NULL;
+
+	blk_cleanup_queue(card->queue);
+	unregister_blkdev(card->major, DRIVER_NAME);
+}
+
+int rsxx_dev_init(void)
+{
+	bio_meta_pool = KMEM_CACHE(rsxx_bio_meta, SLAB_HWCACHE_ALIGN);
+	if (!bio_meta_pool)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void rsxx_dev_cleanup(void)
+{
+	kmem_cache_destroy(bio_meta_pool);
+}
+
+
diff -uprN -X linux-3.7.3-vanilla/Documentation/dontdiff linux-3.7.3-vanilla/drivers/block/rsxx/dma.c linux-3.7.3/drivers/block/rsxx/dma.c
--- linux-3.7.3-vanilla/drivers/block/rsxx/dma.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-3.7.3/drivers/block/rsxx/dma.c	2013-01-23 11:30:02.182313340 -0600
@@ -0,0 +1,997 @@
+/*
+* Filename: dma.c
+*
+*
+* Authors: Joshua Morris <josh.h.morris@us.ibm.com>
+*	Philip Kelleher <pjk1939@us.ibm.com>
+*
+* (C) Copyright 2013 IBM Corporation
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation; either version 2 of the
+* License, or (at your option) any later version.
+*
+* This program is distributed in the hope that it will be useful, but
+* WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+* General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software Foundation,
+* Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+*/
+
+#include "rsxx_priv.h"
+
+struct rsxx_dma {
+	struct list_head	 list;
+	u8			 cmd;
+	unsigned int		 laddr;     /* Logical address on the ramsan */
+	struct {
+		u32		 off;
+		u32		 cnt;
+	} sub_page;
+	dma_addr_t		 dma_addr;
+	struct page		 *page;
+	unsigned int		 pg_off;    /* Page Offset */
+	rsxx_dma_cb		 cb;
+	void			 *cb_data;
+};
+
+/* This timeout is used to detect a stalled DMA channel */
+#define DMA_ACTIVITY_TIMEOUT	msecs_to_jiffies(10000)
+
+struct hw_status {
+	u8	status;
+	u8	tag;
+	__le16	count;
+	__le32	_rsvd2;
+	__le64	_rsvd3;
+} __packed;
+
+enum rsxx_dma_status {
+	DMA_SW_ERR    = 0x1,
+	DMA_HW_FAULT  = 0x2,
+	DMA_CANCELLED = 0x4,
+};
+
+struct hw_cmd {
+	u8	command;
+	u8	tag;
+	u8	_rsvd;
+	u8	sub_page; /* Bit[0:2]: 512byte offset */
+			  /* Bit[4:6]: 512byte count */
+	__le32	device_addr;
+	__le64	host_addr;
+} __packed;
+
+enum rsxx_hw_cmd {
+	HW_CMD_BLK_DISCARD	= 0x70,
+	HW_CMD_BLK_WRITE	= 0x80,
+	HW_CMD_BLK_READ		= 0xC0,
+	HW_CMD_BLK_RECON_READ	= 0xE0,
+};
+
+enum rsxx_hw_status {
+	HW_STATUS_CRC		= 0x01,
+	HW_STATUS_HARD_ERR	= 0x02,
+	HW_STATUS_SOFT_ERR	= 0x04,
+	HW_STATUS_FAULT		= 0x08,
+};
+
+#define STATUS_BUFFER_SIZE8     4096
+#define COMMAND_BUFFER_SIZE8    4096
+
+static struct kmem_cache *rsxx_dma_pool;
+
+struct dma_tracker {
+	int			next_tag;
+	struct rsxx_dma	*dma;
+};
+
+#define DMA_TRACKER_LIST_SIZE8 (sizeof(struct dma_tracker_list) + \
+		(sizeof(struct dma_tracker) * RSXX_MAX_OUTSTANDING_CMDS))
+
+struct dma_tracker_list {
+	spinlock_t		lock;
+	int			head;
+	struct dma_tracker	list[0];
+};
+
+
+/*----------------- Misc Utility Functions -------------------*/
+unsigned int rsxx_addr8_to_laddr(u64 addr8, struct rsxx_cardinfo *card)
+{
+	unsigned long long tgt_addr8;
+
+	tgt_addr8 = ((addr8 >> card->_stripe.upper_shift) &
+		      card->_stripe.upper_mask) |
+		    ((addr8) & card->_stripe.lower_mask);
+	do_div(tgt_addr8, RSXX_HW_BLK_SIZE);
+	return tgt_addr8;
+}
+
+unsigned int rsxx_get_dma_tgt(struct rsxx_cardinfo *card, u64 addr8)
+{
+	unsigned int tgt;
+
+	tgt = (addr8 >> card->_stripe.target_shift) & card->_stripe.target_mask;
+
+	return tgt;
+}
+
+static void rsxx_dma_queue_reset(struct rsxx_cardinfo *card)
+{
+	/* Reset all DMA Command/Status Queues */
+	iowrite32(DMA_QUEUE_RESET, card->regmap + RESET);
+}
+
+static unsigned int get_dma_size(struct rsxx_dma *dma)
+{
+	if (dma->sub_page.cnt)
+		return dma->sub_page.cnt << 9;
+	else
+		return RSXX_HW_BLK_SIZE;
+}
+
+
+/*----------------- DMA Tracker -------------------*/
+static void set_tracker_dma(struct dma_tracker_list *trackers,
+			    int tag,
+			    struct rsxx_dma *dma)
+{
+	trackers->list[tag].dma = dma;
+}
+
+static struct rsxx_dma *get_tracker_dma(struct dma_tracker_list *trackers,
+					    int tag)
+{
+	return trackers->list[tag].dma;
+}
+
+static int pop_tracker(struct dma_tracker_list *trackers)
+{
+	int tag;
+
+	spin_lock(&trackers->lock);
+	tag = trackers->head;
+	if (tag != -1) {
+		trackers->head = trackers->list[tag].next_tag;
+		trackers->list[tag].next_tag = -1;
+	}
+	spin_unlock(&trackers->lock);
+
+	return tag;
+}
+
+static void push_tracker(struct dma_tracker_list *trackers, int tag)
+{
+	spin_lock(&trackers->lock);
+	trackers->list[tag].next_tag = trackers->head;
+	trackers->head = tag;
+	trackers->list[tag].dma = NULL;
+	spin_unlock(&trackers->lock);
+}
+
+
+/*----------------- Interrupt Coalescing -------------*/
+/*
+ * Interrupt Coalescing Register Format:
+ * Interrupt Timer (64ns units) [15:0]
+ * Interrupt Count [24:16]
+ * Reserved [31:25]
+*/
+#define INTR_COAL_LATENCY_MASK       (0x0000ffff)
+
+#define INTR_COAL_COUNT_SHIFT        16
+#define INTR_COAL_COUNT_BITS         9
+#define INTR_COAL_COUNT_MASK         (((1 << INTR_COAL_COUNT_BITS) - 1) << \
+					INTR_COAL_COUNT_SHIFT)
+#define INTR_COAL_LATENCY_UNITS_NS   64
+
+
+static u32 dma_intr_coal_val(u32 mode, u32 count, u32 latency)
+{
+	u32 latency_units = latency / INTR_COAL_LATENCY_UNITS_NS;
+
+	if (mode == RSXX_INTR_COAL_DISABLED)
+		return 0;
+
+	return ((count << INTR_COAL_COUNT_SHIFT) & INTR_COAL_COUNT_MASK) |
+			(latency_units & INTR_COAL_LATENCY_MASK);
+
+}
+
+static void dma_intr_coal_auto_tune(struct rsxx_cardinfo *card)
+{
+	int i;
+	u32 q_depth = 0;
+	u32 intr_coal;
+
+	if (card->config.data.intr_coal.mode != RSXX_INTR_COAL_AUTO_TUNE)
+		return;
+
+	for (i = 0; i < card->n_targets; i++)
+		q_depth += atomic_read(&card->ctrl[i].stats.hw_q_depth);
+
+	intr_coal = dma_intr_coal_val(card->config.data.intr_coal.mode,
+				      q_depth / 2,
+				      card->config.data.intr_coal.latency);
+	iowrite32(intr_coal, card->regmap + INTR_COAL);
+}
+
+/*----------------- RSXX DMA Handling -------------------*/
+static void rsxx_complete_dma(struct rsxx_cardinfo *card,
+				  struct rsxx_dma *dma,
+				  unsigned int status)
+{
+	if (status & DMA_SW_ERR)
+		printk_ratelimited(KERN_ERR
+				   "SW Error in DMA(cmd x%02x, laddr x%08x)\n",
+				   dma->cmd, dma->laddr);
+	if (status & DMA_HW_FAULT)
+		printk_ratelimited(KERN_ERR
+				   "HW Fault in DMA(cmd x%02x, laddr x%08x)\n",
+				   dma->cmd, dma->laddr);
+	if (status & DMA_CANCELLED)
+		printk_ratelimited(KERN_ERR
+				   "DMA Cancelled(cmd x%02x, laddr x%08x)\n",
+				   dma->cmd, dma->laddr);
+
+	if (dma->dma_addr)
+		pci_unmap_page(card->dev, dma->dma_addr, get_dma_size(dma),
+			       dma->cmd == HW_CMD_BLK_WRITE ?
+					   PCI_DMA_TODEVICE :
+					   PCI_DMA_FROMDEVICE);
+
+	if (dma->cb)
+		dma->cb(card, dma->cb_data, status ? 1 : 0);
+
+	kmem_cache_free(rsxx_dma_pool, dma);
+}
+
+static void rsxx_requeue_dma(struct rsxx_dma_ctrl *ctrl,
+				 struct rsxx_dma *dma)
+{
+	/*
+	 * Requeued DMAs go to the front of the queue so they are issued
+	 * first.
+	 */
+	spin_lock(&ctrl->queue_lock);
+	list_add(&dma->list, &ctrl->queue);
+	spin_unlock(&ctrl->queue_lock);
+}
+
+static void rsxx_handle_dma_error(struct rsxx_dma_ctrl *ctrl,
+				      struct rsxx_dma *dma,
+				      u8 hw_st)
+{
+	unsigned int status = 0;
+	int requeue_cmd = 0;
+
+	dev_dbg(CARD_TO_DEV(ctrl->card),
+		"Handling DMA error(cmd x%02x, laddr x%08x st:x%02x)\n",
+		dma->cmd, dma->laddr, hw_st);
+
+	if (hw_st & HW_STATUS_CRC)
+		ctrl->stats.crc_errors++;
+	if (hw_st & HW_STATUS_HARD_ERR)
+		ctrl->stats.hard_errors++;
+	if (hw_st & HW_STATUS_SOFT_ERR)
+		ctrl->stats.soft_errors++;
+
+	switch (dma->cmd) {
+	case HW_CMD_BLK_READ:
+		if (hw_st & (HW_STATUS_CRC | HW_STATUS_HARD_ERR)) {
+			if (ctrl->card->scrub_hard) {
+				dma->cmd = HW_CMD_BLK_RECON_READ;
+				requeue_cmd = 1;
+				ctrl->stats.reads_retried++;
+			} else {
+				status |= DMA_HW_FAULT;
+				ctrl->stats.reads_failed++;
+			}
+		} else if (hw_st & HW_STATUS_FAULT) {
+			status |= DMA_HW_FAULT;
+			ctrl->stats.reads_failed++;
+		}
+
+		break;
+	case HW_CMD_BLK_RECON_READ:
+		if (hw_st & (HW_STATUS_CRC | HW_STATUS_HARD_ERR)) {
+			/* Data could not be reconstructed. */
+			status |= DMA_HW_FAULT;
+			ctrl->stats.reads_failed++;
+		}
+
+		break;
+	case HW_CMD_BLK_WRITE:
+		status |= DMA_HW_FAULT;
+		ctrl->stats.writes_failed++;
+
+		break;
+	case HW_CMD_BLK_DISCARD:
+		status |= DMA_HW_FAULT;
+		ctrl->stats.discards_failed++;
+
+		break;
+	default:
+		dev_err(CARD_TO_DEV(ctrl->card),
+			"Unknown command in DMA!(cmd: x%02x "
+			   "laddr x%08x st: x%02x\n",
+			   dma->cmd, dma->laddr, hw_st);
+		status |= DMA_SW_ERR;
+
+		break;
+	}
+
+	if (requeue_cmd)
+		rsxx_requeue_dma(ctrl, dma);
+	else
+		rsxx_complete_dma(ctrl->card, dma, status);
+}
+
+static void dma_engine_stalled(unsigned long data)
+{
+	struct rsxx_dma_ctrl *ctrl = (struct rsxx_dma_ctrl *)data;
+
+	if (atomic_read(&ctrl->stats.hw_q_depth) == 0)
+		return;
+
+	if (ctrl->cmd.idx != ioread32(ctrl->regmap + SW_CMD_IDX)) {
+		/*
+		 * The dma engine was stalled because the SW_CMD_IDX write
+		 * was lost. Issue it again to recover.
+		 */
+		dev_warn(CARD_TO_DEV(ctrl->card),
+			"SW_CMD_IDX write was lost, re-writing...\n");
+		iowrite32(ctrl->cmd.idx, ctrl->regmap + SW_CMD_IDX);
+		mod_timer(&ctrl->activity_timer,
+			  jiffies + DMA_ACTIVITY_TIMEOUT);
+	} else {
+		dev_warn(CARD_TO_DEV(ctrl->card),
+			"DMA channel %d has stalled, faulting interface.\n",
+			ctrl->id);
+		ctrl->card->dma_fault = 1;
+	}
+}
+
+static void rsxx_issue_dmas(struct work_struct *work)
+{
+	struct rsxx_dma_ctrl *ctrl;
+	struct rsxx_dma *dma;
+	int tag;
+	int cmds_pending = 0;
+	struct hw_cmd *hw_cmd_buf;
+
+	ctrl = container_of(work, struct rsxx_dma_ctrl, issue_dma_work);
+	hw_cmd_buf = ctrl->cmd.buf;
+
+	if (unlikely(ctrl->card->halt))
+		return;
+
+	while (1) {
+		spin_lock(&ctrl->queue_lock);
+		if (list_empty(&ctrl->queue)) {
+			spin_unlock(&ctrl->queue_lock);
+			break;
+		}
+		spin_unlock(&ctrl->queue_lock);
+
+		tag = pop_tracker(ctrl->trackers);
+		if (tag == -1)
+			break;
+
+		spin_lock(&ctrl->queue_lock);
+		dma = list_entry(ctrl->queue.next, struct rsxx_dma, list);
+		list_del(&dma->list);
+		ctrl->stats.sw_q_depth--;
+		spin_unlock(&ctrl->queue_lock);
+
+		/*
+		 * This will catch any DMAs that slipped in right before the
+		 * fault, but was queued after all the other DMAs were
+		 * cancelled.
+		 */
+		if (unlikely(ctrl->card->dma_fault)) {
+			push_tracker(ctrl->trackers, tag);
+			rsxx_complete_dma(ctrl->card, dma, DMA_CANCELLED);
+			continue;
+		}
+
+		set_tracker_dma(ctrl->trackers, tag, dma);
+		hw_cmd_buf[ctrl->cmd.idx].command  = dma->cmd;
+		hw_cmd_buf[ctrl->cmd.idx].tag      = tag;
+		hw_cmd_buf[ctrl->cmd.idx]._rsvd    = 0;
+		hw_cmd_buf[ctrl->cmd.idx].sub_page =
+					((dma->sub_page.cnt & 0x7) << 4) |
+					 (dma->sub_page.off & 0x7);
+
+		hw_cmd_buf[ctrl->cmd.idx].device_addr =
+					cpu_to_le32(dma->laddr);
+
+		hw_cmd_buf[ctrl->cmd.idx].host_addr =
+					cpu_to_le64(dma->dma_addr);
+
+		dev_dbg(CARD_TO_DEV(ctrl->card),
+			"Issue DMA%d(laddr %d tag %d) to idx %d\n",
+			ctrl->id, dma->laddr, tag, ctrl->cmd.idx);
+
+		ctrl->cmd.idx = (ctrl->cmd.idx + 1) & RSXX_CS_IDX_MASK;
+		cmds_pending++;
+
+		if (dma->cmd == HW_CMD_BLK_WRITE)
+			ctrl->stats.writes_issued++;
+		else if (dma->cmd == HW_CMD_BLK_DISCARD)
+			ctrl->stats.discards_issued++;
+		else
+			ctrl->stats.reads_issued++;
+	}
+
+	/* Let HW know we've queued commands. */
+	if (cmds_pending) {
+		/*
+		 * We must guarantee that the CPU writes to 'ctrl->cmd.buf'
+		 * (which is in PCI-consistent system-memory) from the loop
+		 * above make it into the coherency domain before the
+		 * following PIO "trigger" updating the cmd.idx.  A WMB is
+		 * sufficient. We need not explicitly CPU cache-flush since
+		 * the memory is a PCI-consistent (ie; coherent) mapping.
+		 */
+		wmb();
+
+		atomic_add(cmds_pending, &ctrl->stats.hw_q_depth);
+		mod_timer(&ctrl->activity_timer,
+			  jiffies + DMA_ACTIVITY_TIMEOUT);
+		iowrite32(ctrl->cmd.idx, ctrl->regmap + SW_CMD_IDX);
+	}
+}
+
+static void rsxx_dma_done(struct work_struct *work)
+{
+	struct rsxx_dma_ctrl *ctrl;
+	struct rsxx_dma *dma;
+	unsigned long flags;
+	u16 count;
+	u8 status;
+	u8 tag;
+	struct hw_status *hw_st_buf;
+
+	ctrl = container_of(work, struct rsxx_dma_ctrl, dma_done_work);
+	hw_st_buf = ctrl->status.buf;
+
+	if (unlikely(ctrl->card->halt) ||
+	    unlikely(ctrl->card->dma_fault))
+		return;
+
+	count = le16_to_cpu(hw_st_buf[ctrl->status.idx].count);
+
+	while (count == ctrl->e_cnt) {
+		/*
+		 * The read memory-barrier is necessary to keep aggressive
+		 * processors/optimizers (such as the PPC Apple G5) from
+		 * reordering the following status-buffer tag & status read
+		 * *before* the count read on subsequent iterations of the
+		 * loop!
+		 */
+		rmb();
+
+		status = hw_st_buf[ctrl->status.idx].status;
+		tag    = hw_st_buf[ctrl->status.idx].tag;
+
+		dma = get_tracker_dma(ctrl->trackers, tag);
+		if (dma == NULL) {
+			spin_lock_irqsave(&ctrl->card->irq_lock, flags);
+			rsxx_disable_ier(ctrl->card, CR_INTR_DMA_ALL);
+			spin_unlock_irqrestore(&ctrl->card->irq_lock, flags);
+
+			dev_err(CARD_TO_DEV(ctrl->card),
+				"No tracker for tag %d "
+				"(idx %d id %d)\n",
+				tag, ctrl->status.idx, ctrl->id);
+			return;
+		}
+
+		dev_dbg(CARD_TO_DEV(ctrl->card),
+			"Completing DMA%d"
+			"(laddr x%x tag %d st: x%x cnt: x%04x) from idx %d.\n",
+			ctrl->id, dma->laddr, tag, status, count,
+			ctrl->status.idx);
+
+		atomic_dec(&ctrl->stats.hw_q_depth);
+
+		mod_timer(&ctrl->activity_timer,
+			  jiffies + DMA_ACTIVITY_TIMEOUT);
+
+		if (status)
+			rsxx_handle_dma_error(ctrl, dma, status);
+		else
+			rsxx_complete_dma(ctrl->card, dma, 0);
+
+		push_tracker(ctrl->trackers, tag);
+
+		ctrl->status.idx = (ctrl->status.idx + 1) &
+				   RSXX_CS_IDX_MASK;
+		ctrl->e_cnt++;
+
+		count = le16_to_cpu(hw_st_buf[ctrl->status.idx].count);
+	}
+
+	dma_intr_coal_auto_tune(ctrl->card);
+
+	if (atomic_read(&ctrl->stats.hw_q_depth) == 0)
+		del_timer_sync(&ctrl->activity_timer);
+
+	spin_lock_irqsave(&ctrl->card->irq_lock, flags);
+	rsxx_enable_ier(ctrl->card, CR_INTR_DMA(ctrl->id));
+	spin_unlock_irqrestore(&ctrl->card->irq_lock, flags);
+
+	spin_lock(&ctrl->queue_lock);
+	if (ctrl->stats.sw_q_depth)
+		queue_work(ctrl->issue_wq, &ctrl->issue_dma_work);
+	spin_unlock(&ctrl->queue_lock);
+}
+
+static int rsxx_cleanup_dma_queue(struct rsxx_cardinfo *card,
+				      struct list_head *q)
+{
+	struct rsxx_dma *dma;
+	struct rsxx_dma *tmp;
+	int cnt = 0;
+
+	list_for_each_entry_safe(dma, tmp, q, list) {
+		list_del(&dma->list);
+
+		if (dma->dma_addr)
+			pci_unmap_page(card->dev, dma->dma_addr,
+				       get_dma_size(dma),
+				       (dma->cmd == HW_CMD_BLK_WRITE) ?
+				       PCI_DMA_TODEVICE :
+				       PCI_DMA_FROMDEVICE);
+		kmem_cache_free(rsxx_dma_pool, dma);
+		cnt++;
+	}
+
+	return cnt;
+}
+
+static int rsxx_queue_discard(struct rsxx_cardinfo *card,
+				  struct list_head *q,
+				  unsigned int laddr,
+				  rsxx_dma_cb cb,
+				  void *cb_data)
+{
+	struct rsxx_dma *dma;
+
+	dma = kmem_cache_alloc(rsxx_dma_pool, GFP_KERNEL);
+	if (!dma)
+		return -ENOMEM;
+
+	dma->cmd          = HW_CMD_BLK_DISCARD;
+	dma->laddr        = laddr;
+	dma->dma_addr     = 0;
+	dma->sub_page.off = 0;
+	dma->sub_page.cnt = 0;
+	dma->page         = NULL;
+	dma->pg_off       = 0;
+	dma->cb	          = cb;
+	dma->cb_data      = cb_data;
+
+	dev_dbg(CARD_TO_DEV(card), "Queuing[D] laddr %x\n", dma->laddr);
+
+	list_add_tail(&dma->list, q);
+
+	return 0;
+}
+
+static int rsxx_queue_dma(struct rsxx_cardinfo *card,
+			      struct list_head *q,
+			      int dir,
+			      unsigned int dma_off,
+			      unsigned int dma_len,
+			      unsigned int laddr,
+			      struct page *page,
+			      unsigned int pg_off,
+			      rsxx_dma_cb cb,
+			      void *cb_data)
+{
+	struct rsxx_dma *dma;
+
+	dma = kmem_cache_alloc(rsxx_dma_pool, GFP_KERNEL);
+	if (!dma)
+		return -ENOMEM;
+
+	dma->dma_addr = pci_map_page(card->dev, page, pg_off, dma_len,
+				     dir ? PCI_DMA_TODEVICE :
+				     PCI_DMA_FROMDEVICE);
+	if (!dma->dma_addr) {
+		kmem_cache_free(rsxx_dma_pool, dma);
+		return -ENOMEM;
+	}
+
+	dma->cmd          = dir ? HW_CMD_BLK_WRITE : HW_CMD_BLK_READ;
+	dma->laddr        = laddr;
+	dma->sub_page.off = (dma_off >> 9);
+	dma->sub_page.cnt = (dma_len >> 9);
+	dma->page         = page;
+	dma->pg_off       = pg_off;
+	dma->cb	          = cb;
+	dma->cb_data      = cb_data;
+
+	dev_dbg(CARD_TO_DEV(card),
+		"Queuing[%c] laddr %x off %d cnt %d page %p pg_off %d\n",
+		dir ? 'W' : 'R', dma->laddr, dma->sub_page.off,
+		dma->sub_page.cnt, dma->page, dma->pg_off);
+
+	/* Queue the DMA */
+	list_add_tail(&dma->list, q);
+
+	return 0;
+}
+
+int rsxx_dma_queue_bio(struct rsxx_cardinfo *card,
+			   struct bio *bio,
+			   atomic_t *n_dmas,
+			   rsxx_dma_cb cb,
+			   void *cb_data)
+{
+	struct list_head dma_list[RSXX_MAX_TARGETS];
+	struct bio_vec *bvec;
+	unsigned long long addr8;
+	unsigned int laddr;
+	unsigned int bv_len;
+	unsigned int bv_off;
+	unsigned int dma_off;
+	unsigned int dma_len;
+	int dma_cnt[RSXX_MAX_TARGETS];
+	int tgt;
+	int st;
+	int i;
+
+	addr8 = bio->bi_sector << 9; /* sectors are 512 bytes */
+	atomic_set(n_dmas, 0);
+
+	for (i = 0; i < card->n_targets; i++) {
+		INIT_LIST_HEAD(&dma_list[i]);
+		dma_cnt[i] = 0;
+	}
+
+	if (bio->bi_rw & REQ_DISCARD) {
+		bv_len = bio->bi_size;
+
+		while (bv_len > 0) {
+			tgt   = rsxx_get_dma_tgt(card, addr8);
+			laddr = rsxx_addr8_to_laddr(addr8, card);
+
+			st = rsxx_queue_discard(card, &dma_list[tgt], laddr,
+						    cb, cb_data);
+			if (st)
+				goto bvec_err;
+
+			dma_cnt[tgt]++;
+			atomic_inc(n_dmas);
+			addr8  += RSXX_HW_BLK_SIZE;
+			bv_len -= RSXX_HW_BLK_SIZE;
+		}
+	} else {
+		bio_for_each_segment(bvec, bio, i) {
+			bv_len = bvec->bv_len;
+			bv_off = bvec->bv_offset;
+
+			while (bv_len > 0) {
+				tgt   = rsxx_get_dma_tgt(card, addr8);
+				laddr = rsxx_addr8_to_laddr(addr8, card);
+				dma_off = addr8 & RSXX_HW_BLK_MASK;
+				dma_len = min(bv_len,
+					      RSXX_HW_BLK_SIZE - dma_off);
+
+				st = rsxx_queue_dma(card, &dma_list[tgt],
+							bio_data_dir(bio),
+							dma_off, dma_len,
+							laddr, bvec->bv_page,
+							bv_off, cb, cb_data);
+				if (st)
+					goto bvec_err;
+
+				dma_cnt[tgt]++;
+				atomic_inc(n_dmas);
+				addr8  += dma_len;
+				bv_off += dma_len;
+				bv_len -= dma_len;
+			}
+		}
+	}
+
+	for (i = 0; i < card->n_targets; i++) {
+		if (!list_empty(&dma_list[i])) {
+			spin_lock(&card->ctrl[i].queue_lock);
+			card->ctrl[i].stats.sw_q_depth += dma_cnt[i];
+			list_splice_tail(&dma_list[i], &card->ctrl[i].queue);
+			spin_unlock(&card->ctrl[i].queue_lock);
+
+			queue_work(card->ctrl[i].issue_wq,
+				   &card->ctrl[i].issue_dma_work);
+		}
+	}
+
+	return 0;
+
+bvec_err:
+	for (i = 0; i < card->n_targets; i++)
+		rsxx_cleanup_dma_queue(card, &dma_list[i]);
+
+	return st;
+}
+
+
+/*----------------- DMA Engine Initialization & Setup -------------------*/
+static int rsxx_dma_ctrl_init(struct pci_dev *dev,
+				  struct rsxx_dma_ctrl *ctrl)
+{
+	int i;
+
+	memset(&ctrl->stats, 0, sizeof(ctrl->stats));
+
+	ctrl->status.buf = pci_alloc_consistent(dev, STATUS_BUFFER_SIZE8,
+						&ctrl->status.dma_addr);
+	ctrl->cmd.buf = pci_alloc_consistent(dev, COMMAND_BUFFER_SIZE8,
+					     &ctrl->cmd.dma_addr);
+	if (ctrl->status.buf == NULL || ctrl->cmd.buf == NULL)
+		return -ENOMEM;
+
+	ctrl->trackers = vmalloc(DMA_TRACKER_LIST_SIZE8);
+	if (!ctrl->trackers)
+		return -ENOMEM;
+
+	ctrl->trackers->head = 0;
+	for (i = 0; i < RSXX_MAX_OUTSTANDING_CMDS; i++) {
+		ctrl->trackers->list[i].next_tag = i + 1;
+		ctrl->trackers->list[i].dma = NULL;
+	}
+	ctrl->trackers->list[RSXX_MAX_OUTSTANDING_CMDS-1].next_tag = -1;
+	spin_lock_init(&ctrl->trackers->lock);
+
+	spin_lock_init(&ctrl->queue_lock);
+	INIT_LIST_HEAD(&ctrl->queue);
+
+	setup_timer(&ctrl->activity_timer, dma_engine_stalled,
+		    (unsigned long)ctrl);
+
+	ctrl->issue_wq = alloc_ordered_workqueue(DRIVER_NAME"_issue", 0);
+	if (!ctrl->issue_wq)
+		return -ENOMEM;
+
+	ctrl->done_wq = alloc_ordered_workqueue(DRIVER_NAME"_done", 0);
+	if (!ctrl->done_wq)
+		return -ENOMEM;
+
+	INIT_WORK(&ctrl->issue_dma_work, rsxx_issue_dmas);
+	INIT_WORK(&ctrl->dma_done_work, rsxx_dma_done);
+
+	memset(ctrl->status.buf, 0xac, STATUS_BUFFER_SIZE8);
+	iowrite32(lower_32_bits(ctrl->status.dma_addr),
+		  ctrl->regmap + SB_ADD_LO);
+	iowrite32(upper_32_bits(ctrl->status.dma_addr),
+		  ctrl->regmap + SB_ADD_HI);
+
+	memset(ctrl->cmd.buf, 0x83, COMMAND_BUFFER_SIZE8);
+	iowrite32(lower_32_bits(ctrl->cmd.dma_addr), ctrl->regmap + CB_ADD_LO);
+	iowrite32(upper_32_bits(ctrl->cmd.dma_addr), ctrl->regmap + CB_ADD_HI);
+
+	ctrl->status.idx = ioread32(ctrl->regmap + HW_STATUS_CNT);
+	if (ctrl->status.idx > RSXX_MAX_OUTSTANDING_CMDS) {
+		dev_crit(&dev->dev, "Failed reading status cnt x%x\n",
+			 ctrl->status.idx);
+		return -EINVAL;
+	}
+	iowrite32(ctrl->status.idx, ctrl->regmap + HW_STATUS_CNT);
+	iowrite32(ctrl->status.idx, ctrl->regmap + SW_STATUS_CNT);
+
+	ctrl->cmd.idx = ioread32(ctrl->regmap + HW_CMD_IDX);
+	if (ctrl->cmd.idx > RSXX_MAX_OUTSTANDING_CMDS) {
+		dev_crit(&dev->dev, "Failed reading cmd cnt x%x\n",
+			 ctrl->status.idx);
+		return -EINVAL;
+	}
+	iowrite32(ctrl->cmd.idx, ctrl->regmap + HW_CMD_IDX);
+	iowrite32(ctrl->cmd.idx, ctrl->regmap + SW_CMD_IDX);
+
+	wmb();
+
+	return 0;
+}
+
+int rsxx_dma_stripe_setup(struct rsxx_cardinfo *card,
+			      unsigned int stripe_size8)
+{
+	if (!is_power_of_2(stripe_size8)) {
+		dev_err(CARD_TO_DEV(card),
+			"stripe_size is NOT a power of 2!\n");
+		return -EINVAL;
+	}
+
+	card->_stripe.lower_mask = stripe_size8 - 1;
+
+	card->_stripe.upper_mask  = ~(card->_stripe.lower_mask);
+	card->_stripe.upper_shift = ffs(card->n_targets) - 1;
+
+	card->_stripe.target_mask = card->n_targets - 1;
+	card->_stripe.target_shift = ffs(stripe_size8) - 1;
+
+	dev_dbg(CARD_TO_DEV(card), "_stripe.lower_mask   = x%016llx\n",
+		card->_stripe.lower_mask);
+	dev_dbg(CARD_TO_DEV(card), "_stripe.upper_shift  = x%016llx\n",
+		card->_stripe.upper_shift);
+	dev_dbg(CARD_TO_DEV(card), "_stripe.upper_mask   = x%016llx\n",
+		card->_stripe.upper_mask);
+	dev_dbg(CARD_TO_DEV(card), "_stripe.target_mask  = x%016llx\n",
+		card->_stripe.target_mask);
+	dev_dbg(CARD_TO_DEV(card), "_stripe.target_shift = x%016llx\n",
+		card->_stripe.target_shift);
+
+	return 0;
+}
+
+int rsxx_dma_configure(struct rsxx_cardinfo *card)
+{
+	u32 intr_coal;
+
+	intr_coal = dma_intr_coal_val(card->config.data.intr_coal.mode,
+				      card->config.data.intr_coal.count,
+				      card->config.data.intr_coal.latency);
+	iowrite32(intr_coal, card->regmap + INTR_COAL);
+
+	return rsxx_dma_stripe_setup(card, card->config.data.stripe_size);
+}
+
+int rsxx_dma_setup(struct rsxx_cardinfo *card)
+{
+	unsigned long flags;
+	int st;
+	int i;
+
+	dev_info(CARD_TO_DEV(card),
+		"Initializing %d DMA targets\n",
+		card->n_targets);
+
+	/* Regmap is divided up into 4K chunks. One for each DMA channel */
+	for (i = 0; i < card->n_targets; i++)
+		card->ctrl[i].regmap = card->regmap + (i * 4096);
+
+	card->dma_fault = 0;
+
+	/* Reset the DMA queues */
+	rsxx_dma_queue_reset(card);
+
+	/************* Setup DMA Control *************/
+	for (i = 0; i < card->n_targets; i++) {
+		st = rsxx_dma_ctrl_init(card->dev, &card->ctrl[i]);
+		if (st)
+			goto failed_dma_setup;
+
+		card->ctrl[i].card = card;
+		card->ctrl[i].id = i;
+	}
+
+	card->scrub_hard = 1;
+
+	if (card->config_valid)
+		rsxx_dma_configure(card);
+
+	/* Enable the interrupts after all setup has completed. */
+	for (i = 0; i < card->n_targets; i++) {
+		spin_lock_irqsave(&card->irq_lock, flags);
+		rsxx_enable_ier_and_isr(card, CR_INTR_DMA(i));
+		spin_unlock_irqrestore(&card->irq_lock, flags);
+	}
+
+	return 0;
+
+failed_dma_setup:
+	for (i = 0; i < card->n_targets; i++) {
+		struct rsxx_dma_ctrl *ctrl = &card->ctrl[i];
+
+		if (ctrl->issue_wq) {
+			destroy_workqueue(ctrl->issue_wq);
+			ctrl->issue_wq = NULL;
+		}
+
+		if (ctrl->done_wq) {
+			destroy_workqueue(ctrl->done_wq);
+			ctrl->done_wq = NULL;
+		}
+
+		if (ctrl->trackers)
+			vfree(ctrl->trackers);
+
+		if (ctrl->status.buf)
+			pci_free_consistent(card->dev, STATUS_BUFFER_SIZE8,
+					    ctrl->status.buf,
+					    ctrl->status.dma_addr);
+		if (ctrl->cmd.buf)
+			pci_free_consistent(card->dev, COMMAND_BUFFER_SIZE8,
+					    ctrl->cmd.buf, ctrl->cmd.dma_addr);
+	}
+
+	return st;
+}
+
+
+void rsxx_dma_destroy(struct rsxx_cardinfo *card)
+{
+	struct rsxx_dma_ctrl *ctrl;
+	struct rsxx_dma *dma;
+	int i, j;
+	int cnt = 0;
+
+	for (i = 0; i < card->n_targets; i++) {
+		ctrl = &card->ctrl[i];
+
+		if (ctrl->issue_wq) {
+			destroy_workqueue(ctrl->issue_wq);
+			ctrl->issue_wq = NULL;
+		}
+
+		if (ctrl->done_wq) {
+			destroy_workqueue(ctrl->done_wq);
+			ctrl->done_wq = NULL;
+		}
+
+		if (timer_pending(&ctrl->activity_timer))
+			del_timer_sync(&ctrl->activity_timer);
+
+		/* Clean up the DMA queue */
+		spin_lock(&ctrl->queue_lock);
+		cnt = rsxx_cleanup_dma_queue(card, &ctrl->queue);
+		spin_unlock(&ctrl->queue_lock);
+
+		if (cnt)
+			dev_info(CARD_TO_DEV(card),
+				"Freed %d queued DMAs on channel %d\n",
+				cnt, i);
+
+		/* Clean up issued DMAs */
+		for (j = 0; j < RSXX_MAX_OUTSTANDING_CMDS; j++) {
+			dma = get_tracker_dma(ctrl->trackers, j);
+			if (dma) {
+				pci_unmap_page(card->dev, dma->dma_addr,
+					       get_dma_size(dma),
+					       (dma->cmd == HW_CMD_BLK_WRITE) ?
+					       PCI_DMA_TODEVICE :
+					       PCI_DMA_FROMDEVICE);
+				kmem_cache_free(rsxx_dma_pool, dma);
+				cnt++;
+			}
+		}
+
+		if (cnt)
+			dev_info(CARD_TO_DEV(card),
+				"Freed %d pending DMAs on channel %d\n",
+				cnt, i);
+
+		vfree(ctrl->trackers);
+
+		pci_free_consistent(card->dev, STATUS_BUFFER_SIZE8,
+				    ctrl->status.buf, ctrl->status.dma_addr);
+		pci_free_consistent(card->dev, COMMAND_BUFFER_SIZE8,
+				    ctrl->cmd.buf, ctrl->cmd.dma_addr);
+	}
+}
+
+
+int rsxx_dma_init(void)
+{
+	rsxx_dma_pool = KMEM_CACHE(rsxx_dma, SLAB_HWCACHE_ALIGN);
+	if (!rsxx_dma_pool)
+		return -ENOMEM;
+
+	return 0;
+}
+
+
+void rsxx_dma_cleanup(void)
+{
+	kmem_cache_destroy(rsxx_dma_pool);
+}
+
diff -uprN -X linux-3.7.3-vanilla/Documentation/dontdiff linux-3.7.3-vanilla/drivers/block/rsxx/Makefile linux-3.7.3/drivers/block/rsxx/Makefile
--- linux-3.7.3-vanilla/drivers/block/rsxx/Makefile	1969-12-31 18:00:00.000000000 -0600
+++ linux-3.7.3/drivers/block/rsxx/Makefile	2013-01-23 11:30:02.201561787 -0600
@@ -0,0 +1,2 @@
+obj-$(CONFIG_BLK_DEV_RSXX) += rsxx.o
+rsxx-y := config.o core.o cregs.o dev.o dma.o
diff -uprN -X linux-3.7.3-vanilla/Documentation/dontdiff linux-3.7.3-vanilla/drivers/block/rsxx/rsxx_cfg.h linux-3.7.3/drivers/block/rsxx/rsxx_cfg.h
--- linux-3.7.3-vanilla/drivers/block/rsxx/rsxx_cfg.h	1969-12-31 18:00:00.000000000 -0600
+++ linux-3.7.3/drivers/block/rsxx/rsxx_cfg.h	2013-01-23 11:30:02.203251460 -0600
@@ -0,0 +1,72 @@
+/*
+* Filename: rsXX_cfg.h
+*
+*
+* Authors: Joshua Morris <josh.h.morris@us.ibm.com>
+*	Philip Kelleher <pjk1939@us.ibm.com>
+*
+* (C) Copyright 2013 IBM Corporation
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation; either version 2 of the
+* License, or (at your option) any later version.
+*
+* This program is distributed in the hope that it will be useful, but
+* WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+* General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software Foundation,
+* Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+*/
+
+#ifndef __RSXX_CFG_H__
+#define __RSXX_CFG_H__
+
+/* NOTE: Config values will be saved in network byte order (i.e. Big endian) */
+#include <linux/types.h>
+
+/*
+ * The card config version must match the driver's expected version. If it does
+ * not, the DMA interfaces will not be attached and the user will need to
+ * initialize/upgrade the card configuration using the card config utility.
+ */
+#define RSXX_CFG_VERSION	4
+
+struct card_cfg_hdr {
+	__u32	version;
+	__u32	crc;
+};
+
+struct card_cfg_data {
+	__u32	block_size;
+	__u32	stripe_size;
+	__u32	vendor_id;
+	__u32	cache_order;
+	struct {
+		__u32	mode;	/* Disabled, manual, auto-tune... */
+		__u32	count;	/* Number of intr to coalesce     */
+		__u32	latency;/* Max wait time (in ns)          */
+	} intr_coal;
+};
+
+struct rsxx_card_cfg {
+	struct card_cfg_hdr	hdr;
+	struct card_cfg_data	data;
+};
+
+/* Vendor ID Values */
+#define RSXX_VENDOR_ID_TMS_IBM		0
+#define RSXX_VENDOR_ID_DSI		1
+#define RSXX_VENDOR_COUNT		2
+
+/* Interrupt Coalescing Values */
+#define RSXX_INTR_COAL_DISABLED           0
+#define RSXX_INTR_COAL_EXPLICIT           1
+#define RSXX_INTR_COAL_AUTO_TUNE          2
+
+
+#endif /* __RSXX_CFG_H__ */
+
diff -uprN -X linux-3.7.3-vanilla/Documentation/dontdiff linux-3.7.3-vanilla/drivers/block/rsxx/rsxx.h linux-3.7.3/drivers/block/rsxx/rsxx.h
--- linux-3.7.3-vanilla/drivers/block/rsxx/rsxx.h	1969-12-31 18:00:00.000000000 -0600
+++ linux-3.7.3/drivers/block/rsxx/rsxx.h	2013-01-23 11:30:02.242235381 -0600
@@ -0,0 +1,43 @@
+/*
+* Filename: rsxx.h
+*
+*
+* Authors: Joshua Morris <josh.h.morris@us.ibm.com>
+*	Philip Kelleher <pjk1939@us.ibm.com>
+*
+* (C) Copyright 2013 IBM Corporation
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation; either version 2 of the
+* License, or (at your option) any later version.
+*
+* This program is distributed in the hope that it will be useful, but
+* WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+* General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software Foundation,
+* Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+*/
+
+#ifndef __RSXX_H__
+#define __RSXX_H__
+
+/*----------------- IOCTL Definitions -------------------*/
+
+struct rsxx_reg_access {
+	__u32 addr;
+	__u32 cnt;
+	__u32 stat;
+	__u32 stream;
+	__u32 data[8];
+};
+
+#define RSXX_IOC_MAGIC 'r'
+
+#define RSXX_GETREG _IOWR(RSXX_IOC_MAGIC, 0x20, struct rsxx_reg_access)
+#define RSXX_SETREG _IOWR(RSXX_IOC_MAGIC, 0x21, struct rsxx_reg_access)
+
+#endif /* __RSXX_H_ */
diff -uprN -X linux-3.7.3-vanilla/Documentation/dontdiff linux-3.7.3-vanilla/drivers/block/rsxx/rsxx_priv.h linux-3.7.3/drivers/block/rsxx/rsxx_priv.h
--- linux-3.7.3-vanilla/drivers/block/rsxx/rsxx_priv.h	1969-12-31 18:00:00.000000000 -0600
+++ linux-3.7.3/drivers/block/rsxx/rsxx_priv.h	2013-01-23 11:30:02.240235657 -0600
@@ -0,0 +1,408 @@
+/*
+* Filename: rsxx_priv.h
+*
+*
+* Authors: Joshua Morris <josh.h.morris@us.ibm.com>
+*	Philip Kelleher <pjk1939@us.ibm.com>
+*
+* (C) Copyright 2013 IBM Corporation
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation; either version 2 of the
+* License, or (at your option) any later version.
+*
+* This program is distributed in the hope that it will be useful, but
+* WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+* General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software Foundation,
+* Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+*/
+
+#ifndef __RSXX_PRIV_H__
+#define __RSXX_PRIV_H__
+
+#include <linux/version.h>
+#include <linux/semaphore.h>
+
+#include <linux/fs.h>
+#include <linux/interrupt.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/sysfs.h>
+#include <linux/workqueue.h>
+#include <linux/bio.h>
+#include <linux/vmalloc.h>
+#include <linux/timer.h>
+#include <linux/ioctl.h>
+
+#include "rsxx.h"
+#include "rsxx_cfg.h"
+
+struct proc_cmd;
+
+#define PCI_VENDOR_ID_TMS_IBM		0x15B6
+#define PCI_DEVICE_ID_RS70_FLASH	0x0019
+#define PCI_DEVICE_ID_RS70D_FLASH	0x001A
+#define PCI_DEVICE_ID_RS80_FLASH	0x001C
+#define PCI_DEVICE_ID_RS81_FLASH	0x001E
+
+#define RS70_PCI_REV_SUPPORTED	4
+
+#define DRIVER_NAME "rsxx"
+#define DRIVER_VERSION "3.7"
+
+/* Block size is 4096 */
+#define RSXX_HW_BLK_SHIFT		12
+#define RSXX_HW_BLK_SIZE		(1 << RSXX_HW_BLK_SHIFT)
+#define RSXX_HW_BLK_MASK		(RSXX_HW_BLK_SIZE - 1)
+
+#define MAX_CREG_DATA8	32
+#define LOG_BUF_SIZE8	128
+
+#define RSXX_MAX_OUTSTANDING_CMDS	255
+#define RSXX_CS_IDX_MASK		0xff
+
+#define RSXX_MAX_TARGETS	8
+
+struct dma_tracker_list;
+
+/* DMA Command/Status Buffer structure */
+struct rsxx_cs_buffer {
+	dma_addr_t	dma_addr;
+	void		*buf;
+	u32		idx;
+};
+
+struct rsxx_dma_stats {
+	u32 crc_errors;
+	u32 hard_errors;
+	u32 soft_errors;
+	u32 writes_issued;
+	u32 writes_failed;
+	u32 reads_issued;
+	u32 reads_failed;
+	u32 reads_retried;
+	u32 discards_issued;
+	u32 discards_failed;
+	u32 done_rescheduled;
+	u32 issue_rescheduled;
+	u32 sw_q_depth;		/* Number of DMAs on the SW queue. */
+	atomic_t hw_q_depth;	/* Number of DMAs queued to HW. */
+};
+
+struct rsxx_dma_ctrl {
+	struct rsxx_cardinfo		*card;
+	int				id;
+	void				__iomem *regmap;
+	struct rsxx_cs_buffer		status;
+	struct rsxx_cs_buffer		cmd;
+	u16				e_cnt;
+	spinlock_t			queue_lock;
+	struct list_head		queue;
+	struct workqueue_struct		*issue_wq;
+	struct work_struct		issue_dma_work;
+	struct workqueue_struct		*done_wq;
+	struct work_struct		dma_done_work;
+	struct timer_list		activity_timer;
+	struct dma_tracker_list		*trackers;
+	struct rsxx_dma_stats		stats;
+};
+
+struct rsxx_cardinfo {
+	struct pci_dev		*dev;
+	unsigned int		halt;
+
+	void			__iomem *regmap;
+	spinlock_t		irq_lock;
+	unsigned int		isr_mask;
+	unsigned int		ier_mask;
+
+	struct rsxx_card_cfg	config;
+	int			config_valid;
+
+	/* Embedded CPU Communication */
+	struct {
+		struct mutex		lock;
+		bool			active;
+		struct creg_cmd		*active_cmd;
+		struct work_struct	done_work;
+		struct list_head	queue;
+		unsigned int		q_depth;
+		/* Cache the creg status to prevent ioreads */
+		struct {
+			u32		stat;
+			u32		failed_cancel_timer;
+			u32		creg_timeout;
+		} creg_stats;
+		struct timer_list	cmd_timer;
+		struct mutex		reset_lock;
+		spinlock_t		pop_lock;
+		int			reset;
+	} creg_ctrl;
+
+	struct {
+		char tmp[MAX_CREG_DATA8];
+		char buf[LOG_BUF_SIZE8]; /* terminated */
+		int buf_len;
+	} log;
+
+	struct work_struct	event_work;
+	unsigned int		state;
+	u64			size8;
+
+	/* Lock the device attach/detach function */
+	struct mutex		dev_lock;
+
+	/* Block Device Variables */
+	bool			bdev_attached;
+	int			disk_id;
+	int			major;
+	struct request_queue	*queue;
+	struct gendisk		*gendisk;
+	struct {
+		/* Used to convert a byte address to a device address. */
+		u64 lower_mask;
+		u64 upper_shift;
+		u64 upper_mask;
+		u64 target_mask;
+		u64 target_shift;
+	} _stripe;
+	unsigned int		dma_fault;
+
+	int			scrub_hard;
+
+	int			n_targets;
+	struct rsxx_dma_ctrl	*ctrl;
+};
+
+enum rsxx_pci_regmap {
+	HWID		= 0x00,	/* Hardware Identification Register */
+	SCRATCH		= 0x04, /* Scratch/Debug Register */
+	RESET		= 0x08, /* Reset Register */
+	ISR		= 0x10, /* Interrupt Status Register */
+	IER		= 0x14, /* Interrupt Enable Register */
+	IPR		= 0x18, /* Interrupt Poll Register */
+	CB_ADD_LO	= 0x20, /* Command Host Buffer Address [31:0] */
+	CB_ADD_HI	= 0x24, /* Command Host Buffer Address [63:32]*/
+	HW_CMD_IDX	= 0x28, /* Hardware Processed Command Index */
+	SW_CMD_IDX	= 0x2C, /* Software Processed Command Index */
+	SB_ADD_LO	= 0x30, /* Status Host Buffer Address [31:0] */
+	SB_ADD_HI	= 0x34, /* Status Host Buffer Address [63:32] */
+	HW_STATUS_CNT	= 0x38, /* Hardware Status Counter */
+	SW_STATUS_CNT	= 0x3C, /* Deprecated */
+	CREG_CMD	= 0x40, /* CPU Command Register */
+	CREG_ADD	= 0x44, /* CPU Address Register */
+	CREG_CNT	= 0x48, /* CPU Count Register */
+	CREG_STAT	= 0x4C, /* CPU Status Register */
+	CREG_DATA0	= 0x50, /* CPU Data Registers */
+	CREG_DATA1	= 0x54,
+	CREG_DATA2	= 0x58,
+	CREG_DATA3	= 0x5C,
+	CREG_DATA4	= 0x60,
+	CREG_DATA5	= 0x64,
+	CREG_DATA6	= 0x68,
+	CREG_DATA7	= 0x6c,
+	INTR_COAL	= 0x70, /* Interrupt Coalescing Register */
+	HW_ERROR	= 0x74, /* Card Error Register */
+	PCI_DEBUG0	= 0x78, /* PCI Debug Registers */
+	PCI_DEBUG1	= 0x7C,
+	PCI_DEBUG2	= 0x80,
+	PCI_DEBUG3	= 0x84,
+	PCI_DEBUG4	= 0x88,
+	PCI_DEBUG5	= 0x8C,
+	PCI_DEBUG6	= 0x90,
+	PCI_DEBUG7	= 0x94,
+	PCI_POWER_THROTTLE = 0x98,
+	PERF_CTRL	= 0x9c,
+	PERF_TIMER_LO	= 0xa0,
+	PERF_TIMER_HI	= 0xa4,
+	PERF_RD512_LO	= 0xa8,
+	PERF_RD512_HI	= 0xac,
+	PERF_WR512_LO	= 0xb0,
+	PERF_WR512_HI	= 0xb4,
+};
+
+enum rsxx_intr {
+	CR_INTR_DMA0	= 0x00000001,
+	CR_INTR_CREG	= 0x00000002,
+	CR_INTR_DMA1	= 0x00000004,
+	CR_INTR_EVENT	= 0x00000008,
+	CR_INTR_DMA2	= 0x00000010,
+	CR_INTR_DMA3	= 0x00000020,
+	CR_INTR_DMA4	= 0x00000040,
+	CR_INTR_DMA5	= 0x00000080,
+	CR_INTR_DMA6	= 0x00000100,
+	CR_INTR_DMA7	= 0x00000200,
+	CR_INTR_DMA_ALL = 0x000003f5,
+	CR_INTR_ALL	= 0xffffffff,
+};
+
+static inline int CR_INTR_DMA(int N)
+{
+	static const unsigned int _CR_INTR_DMA[] = {
+		CR_INTR_DMA0, CR_INTR_DMA1, CR_INTR_DMA2, CR_INTR_DMA3,
+		CR_INTR_DMA4, CR_INTR_DMA5, CR_INTR_DMA6, CR_INTR_DMA7
+	};
+	return _CR_INTR_DMA[N];
+}
+enum rsxx_pci_reset {
+	DMA_QUEUE_RESET		= 0x00000001,
+};
+
+enum rsxx_pci_revision {
+	RSXX_DISCARD_SUPPORT = 2,
+};
+
+enum rsxx_creg_cmd {
+	CREG_CMD_TAG_MASK	= 0x0000FF00,
+	CREG_OP_WRITE		= 0x000000C0,
+	CREG_OP_READ		= 0x000000E0,
+};
+
+enum rsxx_creg_addr {
+	CREG_ADD_CARD_CMD		= 0x80001000,
+	CREG_ADD_CARD_STATE		= 0x80001004,
+	CREG_ADD_CARD_SIZE		= 0x8000100c,
+	CREG_ADD_CAPABILITIES		= 0x80001050,
+	CREG_ADD_LOG			= 0x80002000,
+	CREG_ADD_NUM_TARGETS		= 0x80003000,
+	CREG_ADD_CONFIG			= 0xB0000000,
+};
+
+enum rsxx_creg_card_cmd {
+	CARD_CMD_STARTUP		= 1,
+	CARD_CMD_SHUTDOWN		= 2,
+	CARD_CMD_LOW_LEVEL_FORMAT	= 3,
+	CARD_CMD_FPGA_RECONFIG_BR	= 4,
+	CARD_CMD_FPGA_RECONFIG_MAIN	= 5,
+	CARD_CMD_BACKUP			= 6,
+	CARD_CMD_RESET			= 7,
+	CARD_CMD_deprecated		= 8,
+	CARD_CMD_UNINITIALIZE		= 9,
+	CARD_CMD_DSTROY_EMERGENCY	= 10,
+	CARD_CMD_DSTROY_NORMAL		= 11,
+	CARD_CMD_DSTROY_EXTENDED	= 12,
+	CARD_CMD_DSTROY_ABORT		= 13,
+};
+
+enum rsxx_card_state {
+	CARD_STATE_SHUTDOWN		= 0x00000001,
+	CARD_STATE_STARTING		= 0x00000002,
+	CARD_STATE_FORMATTING		= 0x00000004,
+	CARD_STATE_UNINITIALIZED	= 0x00000008,
+	CARD_STATE_GOOD			= 0x00000010,
+	CARD_STATE_SHUTTING_DOWN	= 0x00000020,
+	CARD_STATE_FAULT		= 0x00000040,
+	CARD_STATE_RD_ONLY_FAULT	= 0x00000080,
+	CARD_STATE_DSTROYING		= 0x00000100,
+};
+
+enum rsxx_led {
+	LED_DEFAULT	= 0x0,
+	LED_IDENTIFY	= 0x1,
+	LED_SOAK	= 0x2,
+};
+
+enum rsxx_creg_flash_lock {
+	CREG_FLASH_LOCK		= 1,
+	CREG_FLASH_UNLOCK	= 2,
+};
+
+enum rsxx_card_capabilities {
+	CARD_CAP_SUBPAGE_WRITES = 0x00000080,
+};
+
+enum rsxx_creg_stat {
+	CREG_STAT_STATUS_MASK	= 0x00000003,
+	CREG_STAT_SUCCESS	= 0x1,
+	CREG_STAT_ERROR		= 0x2,
+	CREG_STAT_CHAR_PENDING	= 0x00000004, /* Character I/O pending bit */
+	CREG_STAT_LOG_PENDING	= 0x00000008, /* HW log message pending bit */
+	CREG_STAT_TAG_MASK	= 0x0000ff00,
+};
+
+static inline unsigned int CREG_DATA(int N)
+{
+	return CREG_DATA0 + (N << 2);
+}
+
+/*----------------- Convenient Log Wrappers -------------------*/
+#define CARD_TO_DEV(__CARD)	(&(__CARD)->dev->dev)
+
+/***** config.c *****/
+int rsxx_load_config(struct rsxx_cardinfo *card);
+int rsxx_save_config(struct rsxx_cardinfo *card);
+
+/***** core.c *****/
+void rsxx_enable_ier(struct rsxx_cardinfo *card, unsigned int intr);
+void rsxx_disable_ier(struct rsxx_cardinfo *card, unsigned int intr);
+void rsxx_enable_ier_and_isr(struct rsxx_cardinfo *card,
+				 unsigned int intr);
+void rsxx_disable_ier_and_isr(struct rsxx_cardinfo *card,
+				  unsigned int intr);
+char *rsxx_card_state_to_str(unsigned int state);
+irqreturn_t rsxx_isr(int irq, void *pdata);
+
+/***** dev.c *****/
+int rsxx_attach_dev(struct rsxx_cardinfo *card);
+void rsxx_detach_dev(struct rsxx_cardinfo *card);
+int rsxx_setup_dev(struct rsxx_cardinfo *card);
+void rsxx_destroy_dev(struct rsxx_cardinfo *card);
+int rsxx_dev_init(void);
+void rsxx_dev_cleanup(void);
+
+/***** dma.c ****/
+typedef void (*rsxx_dma_cb)(struct rsxx_cardinfo *card,
+				void *cb_data,
+				unsigned int status);
+int rsxx_dma_setup(struct rsxx_cardinfo *card);
+void rsxx_dma_destroy(struct rsxx_cardinfo *card);
+int rsxx_dma_init(void);
+void rsxx_dma_cleanup(void);
+int rsxx_dma_configure(struct rsxx_cardinfo *card);
+int rsxx_dma_queue_bio(struct rsxx_cardinfo *card,
+			   struct bio *bio,
+			   atomic_t *n_dmas,
+			   rsxx_dma_cb cb,
+			   void *cb_data);
+int rsxx_dma_stripe_setup(struct rsxx_cardinfo *card,
+			      unsigned int stripe_size8);
+unsigned int rsxx_get_dma_tgt(struct rsxx_cardinfo *card, u64 addr8);
+unsigned int rsxx_addr8_to_laddr(u64 addr8, struct rsxx_cardinfo *card);
+
+/***** cregs.c *****/
+int rsxx_creg_write(struct rsxx_cardinfo *card, u32 addr,
+			unsigned int size8,
+			void *data,
+			int byte_stream);
+int rsxx_creg_read(struct rsxx_cardinfo *card,
+		       u32 addr,
+		       unsigned int size8,
+		       void *data,
+		       int byte_stream);
+int rsxx_read_hw_log(struct rsxx_cardinfo *card);
+int rsxx_get_card_state(struct rsxx_cardinfo *card,
+			    unsigned int *state);
+int rsxx_get_card_size8(struct rsxx_cardinfo *card, u64 *size8);
+int rsxx_get_num_targets(struct rsxx_cardinfo *card,
+			     unsigned int *n_targets);
+int rsxx_get_card_capabilities(struct rsxx_cardinfo *card,
+				   u32 *capabilities);
+int rsxx_issue_card_cmd(struct rsxx_cardinfo *card, u32 cmd);
+int rsxx_creg_setup(struct rsxx_cardinfo *card);
+void rsxx_creg_destroy(struct rsxx_cardinfo *card);
+int rsxx_creg_init(void);
+void rsxx_creg_cleanup(void);
+
+int rsxx_reg_access(struct rsxx_cardinfo *card,
+			struct rsxx_reg_access __user *ucmd,
+			int read);
+
+
+
+#endif /* __DRIVERS_BLOCK_RSXX_H__ */
diff -uprN -X linux-3.7.3-vanilla/Documentation/dontdiff linux-3.7.3-vanilla/MAINTAINERS linux-3.7.3/MAINTAINERS
--- linux-3.7.3-vanilla/MAINTAINERS	2013-01-17 10:47:40.000000000 -0600
+++ linux-3.7.3/MAINTAINERS	2013-01-23 11:31:34.317301300 -0600
@@ -6071,6 +6071,12 @@ S:	Maintained
 F:	Documentation/blockdev/ramdisk.txt
 F:	drivers/block/brd.c
 
+RAMSAM DRIVER (IBM RamSan 70/80 PCI SSD Flash Card)
+M:	Joshua Morris <josh.h.morris@us.ibm.com>
+M:	Philip Kelleher <pjk1939@us.ibm.com>
+S:	Maintained
+F:	drivers/block/rsxx/
+
 RANDOM NUMBER DRIVER
 M:	Theodore Ts'o" <tytso@mit.edu>
 S:	Maintained

