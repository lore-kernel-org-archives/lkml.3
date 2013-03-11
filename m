Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3CKWIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 18:08:40 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49507 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab3CKWIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 18:08:38 -0400
Date: Mon, 11 Mar 2013 17:08:28 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com,
        josh.h.morris@us.ibm.com
Subject: [Patch 02/02] block: IBM FlashSystem 70/80 sysfs debug.
Message-ID: <20130311220828.GD5833@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031122-3620-0000-0000-00000195D149
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Adding access to pci register, stats, and disk name for debugging
purposes on the IBM FlashSystem 70/80 device driver.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-03-08 09:18:50.165191230 -0600
+++ linux-block/drivers/block/rsxx/core.c	2013-03-08 11:25:42.607178050 -0600
@@ -52,6 +52,183 @@ MODULE_PARM_DESC(force_legacy, "Force th
 static DEFINE_IDA(rsxx_disk_ida);
 static DEFINE_SPINLOCK(rsxx_ida_lock);
 
+/* --------------------Sysfs Setup ---------------------*/
+
+#define RSXX_ATTR(_name, _mode, _show, _store) \
+static struct rsxx_attribute rsxx_attr_##_name = \
+		__ATTR(_name, _mode, _show, _store)
+
+struct rsxx_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct rsxx_cardinfo *,
+			struct rsxx_attribute *, char *);
+	ssize_t	(*store)(struct rsxx_cardinfo *,
+			 struct rsxx_attribute *, const char *, size_t);
+};
+
+static ssize_t rsxx_attr_show(struct kobject *kobj, struct attribute *attr,
+			      char *page)
+{
+	struct rsxx_cardinfo *card;
+	struct rsxx_attribute *card_attr;
+
+	card = container_of(kobj, struct rsxx_cardinfo, kobj);
+	card_attr = container_of(attr, struct rsxx_attribute, attr);
+
+	if (!card_attr->show)
+		return -EIO;
+
+	return card_attr->show(card, card_attr, page);
+}
+
+static ssize_t rsxx_attr_pci_regs_show(struct rsxx_cardinfo *card,
+				       struct rsxx_attribute *attr, char *buf)
+{
+	int i = 0;
+
+	i += sprintf(&buf[i], "HWID             0x%08x\n",
+					ioread32(card->regmap + HWID));
+	i += sprintf(&buf[i], "SCRATCH          0x%08x\n",
+					ioread32(card->regmap + SCRATCH));
+	i += sprintf(&buf[i], "RESET            0x%08x\n",
+					ioread32(card->regmap + RESET));
+	i += sprintf(&buf[i], "ISR              0x%08x\n",
+					ioread32(card->regmap + ISR));
+	i += sprintf(&buf[i], "IER              0x%08x\n",
+					ioread32(card->regmap + IER));
+	i += sprintf(&buf[i], "IPR              0x%08x\n",
+					ioread32(card->regmap + IPR));
+	i += sprintf(&buf[i], "CREG_CMD         0x%08x\n",
+					ioread32(card->regmap + CREG_CMD));
+	i += sprintf(&buf[i], "CREG_ADD         0x%08x\n",
+					ioread32(card->regmap + CREG_ADD));
+	i += sprintf(&buf[i], "CREG_CNT         0x%08x\n",
+					ioread32(card->regmap + CREG_CNT));
+	i += sprintf(&buf[i], "CREG_STAT        0x%08x\n",
+					ioread32(card->regmap + CREG_STAT));
+	i += sprintf(&buf[i], "CREG_DATA0       0x%08x\n",
+					ioread32(card->regmap + CREG_DATA0));
+	i += sprintf(&buf[i], "CREG_DATA1       0x%08x\n",
+					ioread32(card->regmap + CREG_DATA1));
+	i += sprintf(&buf[i], "CREG_DATA2       0x%08x\n",
+					ioread32(card->regmap + CREG_DATA2));
+	i += sprintf(&buf[i], "CREG_DATA3       0x%08x\n",
+					ioread32(card->regmap + CREG_DATA3));
+	i += sprintf(&buf[i], "CREG_DATA4       0x%08x\n",
+					ioread32(card->regmap + CREG_DATA4));
+	i += sprintf(&buf[i], "CREG_DATA5       0x%08x\n",
+					ioread32(card->regmap + CREG_DATA5));
+	i += sprintf(&buf[i], "CREG_DATA6       0x%08x\n",
+					ioread32(card->regmap + CREG_DATA6));
+	i += sprintf(&buf[i], "CREG_DATA7       0x%08x\n",
+					ioread32(card->regmap + CREG_DATA7));
+	i += sprintf(&buf[i], "INTR_COAL        0x%08x\n",
+					ioread32(card->regmap + INTR_COAL));
+	i += sprintf(&buf[i], "HW_ERROR         0x%08x\n",
+					ioread32(card->regmap + HW_ERROR));
+	i += sprintf(&buf[i], "DEBUG0           0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG0));
+	i += sprintf(&buf[i], "DEBUG1           0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG1));
+	i += sprintf(&buf[i], "DEBUG2           0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG2));
+	i += sprintf(&buf[i], "DEBUG3           0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG3));
+	i += sprintf(&buf[i], "DEBUG4           0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG4));
+	i += sprintf(&buf[i], "DEBUG5           0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG5));
+	i += sprintf(&buf[i], "DEBUG6           0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG6));
+	i += sprintf(&buf[i], "DEBUG7           0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG7));
+	i += sprintf(&buf[i], "RECONFIG         0x%08x\n",
+					ioread32(card->regmap + PCI_RECONFIG));
+
+	return i;
+}
+
+RSXX_ATTR(pci_regs, S_IRUSR, rsxx_attr_pci_regs_show, NULL);
+
+static ssize_t rsxx_attr_stats_show(struct rsxx_cardinfo *card,
+					struct rsxx_attribute *attr, char *buf)
+{
+	int i;
+	int j = 0;
+
+	for (i = 0; i < card->n_targets; i++) {
+		j += sprintf(&buf[j], "Ctrl %d CRC Errors       = %d\n",
+			     i, card->ctrl[i].stats.crc_errors);
+		j += sprintf(&buf[j], "Ctrl %d Hard Errors      = %d\n",
+			     i, card->ctrl[i].stats.hard_errors);
+		j += sprintf(&buf[j], "Ctrl %d Soft Errors      = %d\n",
+			     i, card->ctrl[i].stats.soft_errors);
+		j += sprintf(&buf[j], "Ctrl %d Writes Issued    = %d\n",
+			     i, card->ctrl[i].stats.writes_issued);
+		j += sprintf(&buf[j], "Ctrl %d Writes Failed    = %d\n",
+			     i, card->ctrl[i].stats.writes_failed);
+		j += sprintf(&buf[j], "Ctrl %d Reads Issued     = %d\n",
+			     i, card->ctrl[i].stats.reads_issued);
+		j += sprintf(&buf[j], "Ctrl %d Reads Failed     = %d\n",
+			     i, card->ctrl[i].stats.reads_failed);
+		j += sprintf(&buf[j], "Ctrl %d Reads Retried    = %d\n",
+			     i, card->ctrl[i].stats.reads_retried);
+		j += sprintf(&buf[j], "Ctrl %d Discards Issued  = %d\n",
+			     i, card->ctrl[i].stats.discards_issued);
+		j += sprintf(&buf[j], "Ctrl %d Discards Failed  = %d\n",
+			     i, card->ctrl[i].stats.discards_failed);
+		j += sprintf(&buf[j], "Ctrl %d DMA SW Errors    = %d\n",
+			     i, card->ctrl[i].stats.dma_sw_err);
+		j += sprintf(&buf[j], "Ctrl %d DMA HW Faults    = %d\n",
+			     i, card->ctrl[i].stats.dma_hw_fault);
+		j += sprintf(&buf[j], "Ctrl %d DMAs Cancelled   = %d\n",
+			     i, card->ctrl[i].stats.dma_cancelled);
+		j += sprintf(&buf[j], "Ctrl %d SW Queue Depth   = %d\n",
+			     i, card->ctrl[i].stats.sw_q_depth);
+		j += sprintf(&buf[j], "Ctrl %d HW Queue Depth   = %d\n",
+			     i, atomic_read(&card->ctrl[i].stats.hw_q_depth));
+	}
+
+	return j;
+}
+
+RSXX_ATTR(stats, S_IRUSR, rsxx_attr_stats_show, NULL);
+
+static ssize_t rsxx_attr_disk_name_show(struct rsxx_cardinfo *card,
+					struct rsxx_attribute *attr, char *buf)
+{
+	if (card->gendisk)
+		return snprintf(buf, sizeof(card->gendisk->disk_name), "%s\n",
+					card->gendisk->disk_name);
+
+	return sprintf(buf, "disk not attached\n");
+}
+
+RSXX_ATTR(disk_name, S_IRUSR, rsxx_attr_disk_name_show, NULL);
+
+
+static struct attribute *rsxx_attrs[] = {
+	&rsxx_attr_pci_regs.attr,
+	&rsxx_attr_stats.attr,
+	&rsxx_attr_disk_name.attr,
+	NULL,
+};
+
+static struct attribute_group rsxx_attribute_group = {
+	.name = "debug",
+	.attrs = rsxx_attrs,
+};
+
+static int rsxx_sysfs_create(struct rsxx_cardinfo *card)
+{
+	return sysfs_create_group(&card->kobj, &rsxx_attribute_group);
+}
+
+static void rsxx_sysfs_remove(struct rsxx_cardinfo *card)
+{
+	sysfs_remove_group(&card->kobj, &rsxx_attribute_group);
+}
+
 /*----------------- Interrupt Control & Handling -------------------*/
 
 static void rsxx_mask_interrupts(struct rsxx_cardinfo *card)
@@ -503,6 +680,28 @@ static int rsxx_compatibility_check(stru
 	return 0;
 }
 
+static void rsxx_release(struct kobject *kobj)
+{
+	struct rsxx_cardinfo *card;
+
+	card = container_of(kobj, struct rsxx_cardinfo, kobj);
+
+	kobject_put(&card->kobj);
+
+	kfree(card);
+}
+
+static const struct sysfs_ops rsxx_sysfs_ops = {
+	.show	= rsxx_attr_show,
+	.store	= NULL,
+};
+
+static struct kobj_type rsxx_ktype = {
+	.release	= rsxx_release,
+	.sysfs_ops	= &rsxx_sysfs_ops,
+	.default_attrs	= NULL,
+};
+
 static int rsxx_pci_probe(struct pci_dev *dev,
 					const struct pci_device_id *id)
 {
@@ -532,6 +731,15 @@ static int rsxx_pci_probe(struct pci_dev
 	if (st)
 		goto failed_ida_get;
 
+	st = kobject_init_and_add(&card->kobj, &rsxx_ktype,
+				  &card->dev->dev.kobj, "%s", "rsxx");
+	if (st) {
+		dev_err(CARD_TO_DEV(card), "Failed kobject_init_and_add\n");
+		goto failed_kobj_setup;
+	}
+
+	kobject_uevent(&card->kobj, KOBJ_ADD);
+
 	st = pci_enable_device(dev);
 	if (st)
 		goto failed_enable;
@@ -629,6 +837,11 @@ static int rsxx_pci_probe(struct pci_dev
 		goto failed_dma_setup;
 	}
 
+	/************* Setup Sysfs *************/
+	rsxx_sysfs_create(card);
+	if (st)
+		goto failed_sysfs_setup;
+
 	/************* Setup Card Event Handler *************/
 	INIT_WORK(&card->event_work, card_event_handler);
 
@@ -669,6 +882,7 @@ static int rsxx_pci_probe(struct pci_dev
 
 failed_create_dev:
 	rsxx_dma_destroy(card);
+failed_sysfs_setup:
 failed_dma_setup:
 failed_compatiblity_check:
 	spin_lock_irq(&card->irq_lock);
@@ -684,6 +898,7 @@ failed_iomap:
 failed_request_regions:
 failed_dma_mask:
 	pci_disable_device(dev);
+failed_kobj_setup:
 failed_enable:
 	spin_lock(&rsxx_ida_lock);
 	ida_remove(&rsxx_disk_ida, card->disk_id);
@@ -736,6 +951,10 @@ static void rsxx_pci_remove(struct pci_d
 	/* Prevent work_structs from re-queuing themselves. */
 	card->halt = 1;
 
+	rsxx_sysfs_remove(card);
+	kobject_uevent(&card->kobj, KOBJ_REMOVE);
+	kobject_del(&card->kobj);
+
 	free_irq(dev->irq, card);
 
 	if (!force_legacy)
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h linux-block/drivers/block/rsxx/rsxx_priv.h
--- linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h	2013-03-08 09:18:50.184491625 -0600
+++ linux-block/drivers/block/rsxx/rsxx_priv.h	2013-03-08 10:14:43.757184312 -0600
@@ -118,6 +118,7 @@ struct rsxx_dma_ctrl {
 
 struct rsxx_cardinfo {
 	struct pci_dev		*dev;
+	struct kobject		kobj;
 	unsigned int		halt;
 	unsigned int		eeh_state;
 

