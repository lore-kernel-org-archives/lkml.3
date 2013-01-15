Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab3AOM47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:56:59 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:46520 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab3AOM44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:56:56 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 17/26] mfd: ab8500-debugfs: add debugfs node to read all registers
Date: Tue, 15 Jan 2013 12:55:57 +0000
Message-Id: <1358254566-12419-18-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>

Update the ab8500_registers_print() to reuse it from multiple places.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Reviewed-by: Linus WALLEIJ <linus.walleij@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/mfd/ab8500-debugfs.c |   95 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 81 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index a231faf..a1ce55e 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -495,15 +495,12 @@ static irqreturn_t ab8500_debug_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int ab8500_registers_print(struct seq_file *s, void *p)
+/* Prints to seq_file or log_buf */
+static int ab8500_registers_print(struct device *dev, u32 bank,
+				struct seq_file *s)
 {
-	struct device *dev = s->private;
 	unsigned int i;
-	u32 bank = debug_bank;
-
-	seq_printf(s, AB8500_NAME_STRING " register values:\n");
 
-	seq_printf(s, " bank %u:\n", bank);
 	for (i = 0; i < debug_ranges[bank].num_ranges; i++) {
 		u32 reg;
 
@@ -520,22 +517,42 @@ static int ab8500_registers_print(struct seq_file *s, void *p)
 				return err;
 			}
 
-			err = seq_printf(s, "  [%u/0x%02X]: 0x%02X\n", bank,
-				reg, value);
-			if (err < 0) {
-				dev_err(dev, "seq_printf overflow\n");
-				/* Error is not returned here since
-				 * the output is wanted in any case */
-				return 0;
+			if (s) {
+				err = seq_printf(s, "  [%u/0x%02X]: 0x%02X\n",
+					bank, reg, value);
+				if (err < 0) {
+					dev_err(dev,
+					"seq_printf overflow bank=%d reg=%d\n",
+						bank, reg);
+					/* Error is not returned here since
+					 * the output is wanted in any case */
+					return 0;
+				}
+			} else {
+				printk(KERN_INFO" [%u/0x%02X]: 0x%02X\n", bank,
+					reg, value);
 			}
 		}
 	}
 	return 0;
 }
 
+static int ab8500_print_bank_registers(struct seq_file *s, void *p)
+{
+	struct device *dev = s->private;
+	u32 bank = debug_bank;
+
+	seq_printf(s, AB8500_NAME_STRING " register values:\n");
+
+	seq_printf(s, " bank %u:\n", bank);
+
+	ab8500_registers_print(dev, bank, s);
+	return 0;
+}
+
 static int ab8500_registers_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, ab8500_registers_print, inode->i_private);
+	return single_open(file, ab8500_print_bank_registers, inode->i_private);
 }
 
 static const struct file_operations ab8500_registers_fops = {
@@ -546,6 +563,51 @@ static const struct file_operations ab8500_registers_fops = {
 	.owner = THIS_MODULE,
 };
 
+static int ab8500_print_all_banks(struct seq_file *s, void *p)
+{
+	struct device *dev = s->private;
+	unsigned int i;
+	int err;
+
+	seq_printf(s, AB8500_NAME_STRING " register values:\n");
+
+	for (i = 1; i < AB8500_NUM_BANKS; i++) {
+		err = seq_printf(s, " bank %u:\n", i);
+		if (err < 0)
+			dev_err(dev, "seq_printf overflow, bank=%d\n", i);
+
+		ab8500_registers_print(dev, i, s);
+	}
+	return 0;
+}
+
+static int ab8500_all_banks_open(struct inode *inode, struct file *file)
+{
+	struct seq_file *s;
+	int err;
+
+	err = single_open(file, ab8500_print_all_banks, inode->i_private);
+	if (!err) {
+		/* Default buf size in seq_read is not enough */
+		s = (struct seq_file *)file->private_data;
+		s->size = (PAGE_SIZE * 2);
+		s->buf = kmalloc(s->size, GFP_KERNEL);
+		if (!s->buf) {
+			single_release(inode, file);
+			err = -ENOMEM;
+		}
+	}
+	return err;
+}
+
+static const struct file_operations ab8500_all_banks_fops = {
+	.open = ab8500_all_banks_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 static int ab8500_bank_print(struct seq_file *s, void *p)
 {
 	return seq_printf(s, "%d\n", debug_bank);
@@ -1475,6 +1537,11 @@ static int __devinit ab8500_debug_probe(struct platform_device *plf)
 	if (!file)
 		goto err;
 
+	file = debugfs_create_file("all-banks", S_IRUGO,
+	    ab8500_dir, &plf->dev, &ab8500_all_banks_fops);
+	if (!file)
+		goto err;
+
 	file = debugfs_create_file("register-bank", (S_IRUGO | S_IWUSR),
 	    ab8500_dir, &plf->dev, &ab8500_bank_fops);
 	if (!file)
-- 
1.7.9.5

