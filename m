Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab3E1VJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:09:15 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:39814 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab3E1VJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:09:05 -0400
Date: Tue, 28 May 2013 16:08:33 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] rsxx: Adding in debugfs entries.
Message-ID: <20130528210833.GA5065@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052821-7408-0000-0000-000010A7F49D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Adding in some debugfs entries to help with debugging and
testing code.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-05-02 17:17:37.563306101 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-05-02 17:18:22.944239791 -0500
@@ -31,6 +31,8 @@
 #include <linux/slab.h>
 #include <linux/bitops.h>
 #include <linux/delay.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
 
 #include <linux/genhd.h>
 #include <linux/idr.h>
@@ -52,6 +54,191 @@ MODULE_PARM_DESC(force_legacy, "Force th
 static DEFINE_IDA(rsxx_disk_ida);
 static DEFINE_SPINLOCK(rsxx_ida_lock);
 
+/* --------------------Debugfs Setup ------------------- */
+
+static struct dentry *rsxx_debugfs_root;
+
+static int rsxx_attr_pci_regs_show(struct seq_file *m, void *p)
+{
+	struct rsxx_cardinfo *card = m->private;
+
+	seq_printf(m, "HWID		0x%08x\n",
+					ioread32(card->regmap + HWID));
+	seq_printf(m, "SCRATCH		0x%08x\n",
+					ioread32(card->regmap + SCRATCH));
+	seq_printf(m, "ISR		0x%08x\n",
+					ioread32(card->regmap + ISR));
+	seq_printf(m, "IER		0x%08x\n",
+					ioread32(card->regmap + IER));
+	seq_printf(m, "IPR		0x%08x\n",
+					ioread32(card->regmap + IPR));
+	seq_printf(m, "CREG_CMD		0x%08x\n",
+					ioread32(card->regmap + CREG_CMD));
+	seq_printf(m, "CREG_ADD		0x%08x\n",
+					ioread32(card->regmap + CREG_ADD));
+	seq_printf(m, "CREG_CNT		0x%08x\n",
+					ioread32(card->regmap + CREG_CNT));
+	seq_printf(m, "CREG_STAT	0x%08x\n",
+					ioread32(card->regmap + CREG_STAT));
+	seq_printf(m, "CREG_DATA0	0x%08x\n",
+					ioread32(card->regmap + CREG_DATA0));
+	seq_printf(m, "CREG_DATA1	0x%08x\n",
+					ioread32(card->regmap + CREG_DATA1));
+	seq_printf(m, "CREG_DATA2	0x%08x\n",
+					ioread32(card->regmap + CREG_DATA2));
+	seq_printf(m, "CREG_DATA3	0x%08x\n",
+					ioread32(card->regmap + CREG_DATA3));
+	seq_printf(m, "CREG_DATA4	0x%08x\n",
+					ioread32(card->regmap + CREG_DATA4));
+	seq_printf(m, "CREG_DATA5	0x%08x\n",
+					ioread32(card->regmap + CREG_DATA5));
+	seq_printf(m, "CREG_DATA6	0x%08x\n",
+					ioread32(card->regmap + CREG_DATA6));
+	seq_printf(m, "CREG_DATA7	0x%08x\n",
+					ioread32(card->regmap + CREG_DATA7));
+	seq_printf(m, "INTR_COAL	0x%08x\n",
+					ioread32(card->regmap + INTR_COAL));
+	seq_printf(m, "HW_ERROR		0x%08x\n",
+					ioread32(card->regmap + HW_ERROR));
+	seq_printf(m, "DEBUG0		0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG0));
+	seq_printf(m, "DEBUG1		0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG1));
+	seq_printf(m, "DEBUG2		0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG2));
+	seq_printf(m, "DEBUG3		0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG3));
+	seq_printf(m, "DEBUG4		0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG4));
+	seq_printf(m, "DEBUG5		0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG5));
+	seq_printf(m, "DEBUG6		0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG6));
+	seq_printf(m, "DEBUG7		0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG7));
+	seq_printf(m, "RECONFIG		0x%08x\n",
+					ioread32(card->regmap + PCI_RECONFIG));
+
+	return 0;
+}
+
+static int rsxx_attr_stats_show(struct seq_file *m, void *p)
+{
+	struct rsxx_cardinfo *card = m->private;
+	int i;
+
+	for (i = 0; i < card->n_targets; i++) {
+		seq_printf(m, "Ctrl %d CRC Errors	= %d\n",
+				i, card->ctrl[i].stats.crc_errors);
+		seq_printf(m, "Ctrl %d Hard Errors	= %d\n",
+				i, card->ctrl[i].stats.hard_errors);
+		seq_printf(m, "Ctrl %d Soft Errors	= %d\n",
+				i, card->ctrl[i].stats.soft_errors);
+		seq_printf(m, "Ctrl %d Writes Issued	= %d\n",
+				i, card->ctrl[i].stats.writes_issued);
+		seq_printf(m, "Ctrl %d Writes Failed	= %d\n",
+				i, card->ctrl[i].stats.writes_failed);
+		seq_printf(m, "Ctrl %d Reads Issued	= %d\n",
+				i, card->ctrl[i].stats.reads_issued);
+		seq_printf(m, "Ctrl %d Reads Failed	= %d\n",
+				i, card->ctrl[i].stats.reads_failed);
+		seq_printf(m, "Ctrl %d Reads Retried	= %d\n",
+				i, card->ctrl[i].stats.reads_retried);
+		seq_printf(m, "Ctrl %d Discards Issued	= %d\n",
+				i, card->ctrl[i].stats.discards_issued);
+		seq_printf(m, "Ctrl %d Discards Failed	= %d\n",
+				i, card->ctrl[i].stats.discards_failed);
+		seq_printf(m, "Ctrl %d DMA SW Errors	= %d\n",
+				i, card->ctrl[i].stats.dma_sw_err);
+		seq_printf(m, "Ctrl %d DMA HW Faults	= %d\n",
+				i, card->ctrl[i].stats.dma_hw_fault);
+		seq_printf(m, "Ctrl %d DMAs Cancelled	= %d\n",
+				i, card->ctrl[i].stats.dma_cancelled);
+		seq_printf(m, "Ctrl %d SW Queue Depth	= %d\n",
+				i, card->ctrl[i].stats.sw_q_depth);
+		seq_printf(m, "Ctrl %d HW Queue Depth	= %d\n",
+			i, atomic_read(&card->ctrl[i].stats.hw_q_depth));
+	}
+
+	return 0;
+}
+
+static int rsxx_attr_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, rsxx_attr_stats_show, inode->i_private);
+}
+
+static int rsxx_attr_pci_regs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, rsxx_attr_pci_regs_show, inode->i_private);
+}
+
+static const struct file_operations debugfs_stats_fops = {
+	.owner		= THIS_MODULE,
+	.open		= rsxx_attr_stats_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations debugfs_pci_regs_fops = {
+	.owner		= THIS_MODULE,
+	.open		= rsxx_attr_pci_regs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void rsxx_debugfs_dev_new(struct rsxx_cardinfo *card)
+{
+	if (!rsxx_debugfs_root)
+		return;
+
+	card->debugfs_dir = debugfs_create_dir(card->gendisk->disk_name,
+					       rsxx_debugfs_root);
+	if (!card->debugfs_dir)
+		return;
+
+	card->debugfs_stats = debugfs_create_file("stats", S_IRUGO,
+						card->debugfs_dir, card,
+						&debugfs_stats_fops);
+	if (!card->debugfs_stats)
+		return;
+
+	card->debugfs_pci_regs = debugfs_create_file("pci_regs", S_IRUGO,
+						card->debugfs_dir, card,
+						&debugfs_pci_regs_fops);
+	if (!card->debugfs_pci_regs)
+		return;
+}
+
+static void rsxx_debugfs_dev_remove(struct rsxx_cardinfo *card)
+{
+	debugfs_remove(card->debugfs_stats);
+	card->debugfs_stats = NULL;
+
+	debugfs_remove(card->debugfs_pci_regs);
+	card->debugfs_pci_regs = NULL;
+
+	debugfs_remove(card->debugfs_dir);
+	card->debugfs_dir = NULL;
+}
+
+static void rsxx_debugfs_init(void)
+{
+	rsxx_debugfs_root = debugfs_create_dir(DRIVER_NAME, NULL);
+	if (!rsxx_debugfs_root)
+		return;
+}
+
+static void rsxx_debugfs_destroy(void)
+{
+	if (!rsxx_debugfs_root)
+		return;
+	debugfs_remove(rsxx_debugfs_root);
+	rsxx_debugfs_root = NULL;
+}
+
 /*----------------- Interrupt Control & Handling -------------------*/
 
 static void rsxx_mask_interrupts(struct rsxx_cardinfo *card)
@@ -685,6 +872,10 @@ static int rsxx_pci_probe(struct pci_dev
 
 	rsxx_attach_dev(card);
 
+	/************* Setup Debugfs *************/
+	rsxx_debugfs_init();
+	rsxx_debugfs_dev_new(card);
+
 	return 0;
 
 failed_create_dev:
@@ -756,6 +947,9 @@ static void rsxx_pci_remove(struct pci_d
 	/* Prevent work_structs from re-queuing themselves. */
 	card->halt = 1;
 
+	rsxx_debugfs_dev_remove(card);
+	rsxx_debugfs_destroy();
+
 	free_irq(dev->irq, card);
 
 	if (!force_legacy)
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h linux-block/drivers/block/rsxx/rsxx_priv.h
--- linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h	2013-05-02 17:17:37.568374072 -0500
+++ linux-block/drivers/block/rsxx/rsxx_priv.h	2013-05-02 17:17:25.154498245 -0500
@@ -181,6 +181,11 @@ struct rsxx_cardinfo {
 
 	int			n_targets;
 	struct rsxx_dma_ctrl	*ctrl;
+
+	/* Debugfs Variables */
+	struct dentry		*debugfs_dir;
+	struct dentry		*debugfs_stats;
+	struct dentry		*debugfs_pci_regs;
 };
 
 enum rsxx_pci_regmap {

