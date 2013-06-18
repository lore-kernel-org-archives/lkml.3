Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217Ab3FRTxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:53:44 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45121 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab3FRTxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:53:43 -0400
Date: Tue, 18 Jun 2013 14:52:21 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 11/11] rsxx: Adding in debugfs entries.
Message-ID: <20130618195220.GL6492@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061819-7182-0000-0000-000007644BC7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Adding debugfs entries to help with debugging and testing and
testing code.

pci_regs:
       	This entry will spit out all of the data stored on the BAR.

stats:
       	This entry will display all of the driver stats for each
       	DMA channel.

cram:
	This will allow read/write ability to the CRAM address space
	on our adapter's CPU.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------



diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-06-18 10:43:20.122915891 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-06-18 09:59:49.887843442 -0500
@@ -31,6 +31,8 @@
 #include <linux/slab.h>
 #include <linux/bitops.h>
 #include <linux/delay.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
 
 #include <linux/genhd.h>
 #include <linux/idr.h>
@@ -58,6 +60,274 @@ MODULE_PARM_DESC(sync_start, "On by Defa
 static DEFINE_IDA(rsxx_disk_ida);
 static DEFINE_SPINLOCK(rsxx_ida_lock);
 
+/* --------------------Debugfs Setup ------------------- */
+
+struct rsxx_cram {
+	u32 f_pos;
+	u32 offset;
+	void *i_private;
+};
+
+static int rsxx_attr_pci_regs_show(struct seq_file *m, void *p)
+{
+	struct rsxx_cardinfo *card = m->private;
+
+	seq_printf(m, "HWID		0x%08x\n",
+					ioread32(card->regmap + HWID));
+	seq_printf(m, "SCRATCH		0x%08x\n",
+					ioread32(card->regmap + SCRATCH));
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
+static ssize_t rsxx_cram_read(struct file *fp, char __user *ubuf,
+			      size_t cnt, loff_t *ppos)
+{
+	struct rsxx_cram *info = fp->private_data;
+	struct rsxx_cardinfo *card = info->i_private;
+	char *buf;
+	int st;
+
+	buf = kzalloc(sizeof(*buf) * cnt, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	info->f_pos = (u32)*ppos + info->offset;
+
+	st = rsxx_creg_read(card, CREG_ADD_CRAM + info->f_pos, cnt, buf, 1);
+	if (st)
+		return st;
+
+	st = copy_to_user(ubuf, buf, cnt);
+	if (st)
+		return st;
+
+	info->offset += cnt;
+
+	kfree(buf);
+
+	return cnt;
+}
+
+static ssize_t rsxx_cram_write(struct file *fp, const char __user *ubuf,
+			       size_t cnt, loff_t *ppos)
+{
+	struct rsxx_cram *info = fp->private_data;
+	struct rsxx_cardinfo *card = info->i_private;
+	char *buf;
+	int st;
+
+	buf = kzalloc(sizeof(*buf) * cnt, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	st = copy_from_user(buf, ubuf, cnt);
+	if (st)
+		return st;
+
+	info->f_pos = (u32)*ppos + info->offset;
+
+	st = rsxx_creg_write(card, CREG_ADD_CRAM + info->f_pos, cnt, buf, 1);
+	if (st)
+		return st;
+
+	info->offset += cnt;
+
+	kfree(buf);
+
+	return cnt;
+}
+
+static int rsxx_cram_open(struct inode *inode, struct file *file)
+{
+	struct rsxx_cram *info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->i_private = inode->i_private;
+	info->f_pos = file->f_pos;
+	file->private_data = info;
+
+	return 0;
+}
+
+static int rsxx_cram_release(struct inode *inode, struct file *file)
+{
+	struct rsxx_cram *info = file->private_data;
+
+	if (!info)
+		return 0;
+
+	kfree(info);
+	file->private_data = NULL;
+
+	return 0;
+}
+
+static const struct file_operations debugfs_cram_fops = {
+	.owner		= THIS_MODULE,
+	.open		= rsxx_cram_open,
+	.read		= rsxx_cram_read,
+	.write		= rsxx_cram_write,
+	.release	= rsxx_cram_release,
+};
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
+	struct dentry *debugfs_stats;
+	struct dentry *debugfs_pci_regs;
+	struct dentry *debugfs_cram;
+
+	card->debugfs_dir = debugfs_create_dir(card->gendisk->disk_name, NULL);
+	if (IS_ERR_OR_NULL(card->debugfs_dir))
+		goto failed_debugfs_dir;
+
+	debugfs_stats = debugfs_create_file("stats", S_IRUGO,
+					    card->debugfs_dir, card,
+					    &debugfs_stats_fops);
+	if (IS_ERR_OR_NULL(debugfs_stats))
+		goto failed_debugfs_stats;
+
+	debugfs_pci_regs = debugfs_create_file("pci_regs", S_IRUGO,
+					       card->debugfs_dir, card,
+					       &debugfs_pci_regs_fops);
+	if (IS_ERR_OR_NULL(debugfs_pci_regs))
+		goto failed_debugfs_pci_regs;
+
+	debugfs_cram = debugfs_create_file("cram", S_IRUGO | S_IWUSR,
+					   card->debugfs_dir, card,
+					   &debugfs_cram_fops);
+	if (IS_ERR_OR_NULL(debugfs_cram))
+		goto failed_debugfs_cram;
+
+	return;
+failed_debugfs_cram:
+	debugfs_remove(debugfs_pci_regs);
+failed_debugfs_pci_regs:
+	debugfs_remove(debugfs_stats);
+failed_debugfs_stats:
+	debugfs_remove(card->debugfs_dir);
+failed_debugfs_dir:
+	card->debugfs_dir = NULL;
+}
+
 /*----------------- Interrupt Control & Handling -------------------*/
 
 static void rsxx_mask_interrupts(struct rsxx_cardinfo *card)
@@ -741,6 +1011,9 @@ static int rsxx_pci_probe(struct pci_dev
 
 	rsxx_attach_dev(card);
 
+	/************* Setup Debugfs *************/
+	rsxx_debugfs_dev_new(card);
+
 	return 0;
 
 failed_create_dev:
@@ -818,6 +1091,8 @@ static void rsxx_pci_remove(struct pci_d
 	/* Prevent work_structs from re-queuing themselves. */
 	card->halt = 1;
 
+	debugfs_remove_recursive(card->debugfs_dir);
+
 	free_irq(dev->irq, card);
 
 	if (!force_legacy)
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h linux-block/drivers/block/rsxx/rsxx_priv.h
--- linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h	2013-06-18 10:43:15.357143278 -0500
+++ linux-block/drivers/block/rsxx/rsxx_priv.h	2013-06-18 10:42:54.860843902 -0500
@@ -185,6 +185,8 @@ struct rsxx_cardinfo {
 
 	int			n_targets;
 	struct rsxx_dma_ctrl	*ctrl;
+
+	struct dentry		*debugfs_dir;
 };
 
 enum rsxx_pci_regmap {
@@ -287,6 +289,7 @@ enum rsxx_creg_addr {
 	CREG_ADD_CAPABILITIES		= 0x80001050,
 	CREG_ADD_LOG			= 0x80002000,
 	CREG_ADD_NUM_TARGETS		= 0x80003000,
+	CREG_ADD_CRAM			= 0xA0000000,
 	CREG_ADD_CONFIG			= 0xB0000000,
 };
 

