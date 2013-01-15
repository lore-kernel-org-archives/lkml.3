Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab3AOM5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:57:12 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:40154 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965Ab3AOM5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:57:03 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 21/26] mfd: ab8500-debugfs: Add interrupt debug
Date: Tue, 15 Jan 2013 12:56:01 +0000
Message-Id: <1358254566-12419-22-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

This patch adds an entry in debugfs to check number of interrupts
from the AB.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Reviewed-by: Rabin VINCENT <rabin.vincent@stericsson.com>
---
 drivers/mfd/ab8500-core.c         |    1 +
 drivers/mfd/ab8500-debugfs.c      |   49 +++++++++++++++++++++++++++++++++++++
 include/linux/mfd/abx500/ab8500.h |    2 ++
 3 files changed, 52 insertions(+)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 0f84fc0..580adf3 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -521,6 +521,7 @@ static irqreturn_t ab8500_irq(int irq, void *dev)
 			int virq = ab8500_irq_get_virq(ab8500, line);
 
 			handle_nested_irq(virq);
+			ab8500_debug_register_interrupt(line);
 			value &= ~(1 << bit);
 
 		} while (value);
diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index d23b6cc..8e405af 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -737,6 +737,35 @@ static ssize_t ab8500_val_write(struct file *file,
 }
 
 /*
+ * Interrupt status
+ */
+static u32 num_interrupts[AB8500_MAX_NR_IRQS];
+static int num_interrupt_lines;
+
+void ab8500_debug_register_interrupt(int line)
+{
+	if (line < num_interrupt_lines)
+		num_interrupts[line]++;
+}
+
+static int ab8500_interrupts_print(struct seq_file *s, void *p)
+{
+	int line;
+
+	seq_printf(s, "irq:  number of\n");
+
+	for (line = 0; line < num_interrupt_lines; line++)
+		seq_printf(s, "%3i:  %6i\n", line, num_interrupts[line]);
+
+	return 0;
+}
+
+static int ab8500_interrupts_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab8500_interrupts_print, inode->i_private);
+}
+
+/*
  * - HWREG DB8500 formated routines
  */
 static int ab8500_hwreg_print(struct seq_file *s, void *d)
@@ -1487,6 +1516,14 @@ static const struct file_operations ab8500_val_fops = {
 	.owner = THIS_MODULE,
 };
 
+static const struct file_operations ab8500_interrupts_fops = {
+	.open = ab8500_interrupts_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 static const struct file_operations ab8500_subscribe_fops = {
 	.open = ab8500_subscribe_unsubscribe_open,
 	.write = ab8500_subscribe_write,
@@ -1595,6 +1632,18 @@ static int __devinit ab8500_debug_probe(struct platform_device *plf)
 	if (!file)
 		goto err;
 
+	if (is_ab8500(ab8500))
+		num_interrupt_lines = AB8500_NR_IRQS;
+	else if (is_ab8505(ab8500))
+		num_interrupt_lines = AB8505_NR_IRQS;
+	else if (is_ab9540(ab8500))
+		num_interrupt_lines = AB9540_NR_IRQS;
+
+	file = debugfs_create_file("interrupts", (S_IRUGO),
+	    ab8500_dir, &plf->dev, &ab8500_interrupts_fops);
+	if (!file)
+		goto err;
+
 	file = debugfs_create_file("irq-unsubscribe", (S_IRUGO | S_IWUSR),
 	    ab8500_dir, &plf->dev, &ab8500_unsubscribe_fops);
 	if (!file)
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 4c8d966..83de910 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -347,8 +347,10 @@ static inline int is_ab8500_2p0(struct ab8500 *ab)
 
 #ifdef CONFIG_AB8500_DEBUG
 void ab8500_dump_all_banks(struct device *dev);
+void ab8500_debug_register_interrupt(int line);
 #else
 static inline void ab8500_dump_all_banks(struct device *dev) {}
+static inline void ab8500_debug_register_interrupt(int line) {}
 #endif
 
 #endif /* MFD_AB8500_H */
-- 
1.7.9.5

