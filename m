Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152Ab3CGO7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:59:17 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:35449 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab3CGO7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:59:14 -0500
Subject: [RFC PATCH 4/5] crash dump bitmap: add a proc interface for crash
 dump bitmap
To: mingo@redhat.com, kumagai-atsushi@mxc.nes.nec.co.jp, ebiederm@xmission.com,
        hpa@zytor.com, yinghai@kernel.org, vgoyal@redhat.com
From: Jingbai Ma <jingbai.ma@hp.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 07 Mar 2013 22:59:08 +0800
Message-ID: <20130307145907.29098.95120.stgit@k.asiapacific.hpqcorp.net>
In-Reply-To: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net>
References: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a procfs driver for selecting exclude pages in userspace.
/proc/crash_dump_bitmap/

Signed-off-by: Jingbai Ma <jingbai.ma@hp.com>
---
 fs/proc/Makefile            |    1 
 fs/proc/crash_dump_bitmap.c |  221 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 222 insertions(+), 0 deletions(-)
 create mode 100644 fs/proc/crash_dump_bitmap.c

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index 712f24d..2dfcff1 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -27,6 +27,7 @@ proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
 proc-$(CONFIG_NET)		+= proc_net.o
 proc-$(CONFIG_PROC_KCORE)	+= kcore.o
 proc-$(CONFIG_PROC_VMCORE)	+= vmcore.o
+proc-$(CONFIG_CRASH_DUMP_BITMAP)	+= crash_dump_bitmap.o
 proc-$(CONFIG_PROC_DEVICETREE)	+= proc_devtree.o
 proc-$(CONFIG_PRINTK)	+= kmsg.o
 proc-$(CONFIG_PROC_PAGE_MONITOR)	+= page.o
diff --git a/fs/proc/crash_dump_bitmap.c b/fs/proc/crash_dump_bitmap.c
new file mode 100644
index 0000000..77ecaae
--- /dev/null
+++ b/fs/proc/crash_dump_bitmap.c
@@ -0,0 +1,221 @@
+/*
+ *    fs/proc/crash_dump_bitmap.c
+ *    Interface for controlling the crash dump bitmap from user space.
+ *
+ *    (C) Copyright 2013 Hewlett-Packard Development Company, L.P.
+ *    Author: Jingbai Ma <jingbai.ma@hp.com>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of version 2 of the GNU General Public License as
+ *    published by the Free Software Foundation.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ *    General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/jiffies.h>
+#include <linux/crash_dump.h>
+#include <linux/crash_dump_bitmap.h>
+
+#ifdef CONFIG_CRASH_DUMP_BITMAP
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jingbai Ma <jingbai.ma@hp.com>");
+MODULE_DESCRIPTION("Crash dump bitmap support driver");
+
+static const char *proc_dir_name = "crash_dump_bitmap";
+static const char *proc_page_status_name = "page_status";
+static const char *proc_dump_level_name = "dump_level";
+
+static struct proc_dir_entry *proc_dir, *proc_page_status, *proc_dump_level;
+
+static unsigned int get_dump_level(void)
+{
+	unsigned int dump_level;
+
+	dump_level = crash_dump_bitmap_ctrl.exclude_zero_pages
+		? CRASH_DUMP_LEVEL_EXCLUDE_ZERO_PAGES : 0;
+	dump_level |= crash_dump_bitmap_ctrl.exclude_cache_pages
+		? CRASH_DUMP_LEVEL_EXCLUDE_CACHE_PAGES : 0;
+	dump_level |= crash_dump_bitmap_ctrl.exclude_cache_private_pages
+		? CRASH_DUMP_LEVEL_EXCLUDE_CACHE_PRIVATE_PAGES : 0;
+	dump_level |= crash_dump_bitmap_ctrl.exclude_user_pages
+		? CRASH_DUMP_LEVEL_EXCLUDE_USER_PAGES : 0;
+	dump_level |= crash_dump_bitmap_ctrl.exclude_free_pages
+		? CRASH_DUMP_LEVEL_EXCLUDE_FREE_PAGES : 0;
+
+	return dump_level;
+}
+
+static void set_dump_level(unsigned int dump_level)
+{
+	crash_dump_bitmap_ctrl.exclude_zero_pages =
+		(dump_level & CRASH_DUMP_LEVEL_EXCLUDE_ZERO_PAGES) ? 1 : 0;
+	crash_dump_bitmap_ctrl.exclude_cache_pages =
+		(dump_level & CRASH_DUMP_LEVEL_EXCLUDE_CACHE_PAGES) ? 1 : 0;
+	crash_dump_bitmap_ctrl.exclude_cache_private_pages =
+		(dump_level & CRASH_DUMP_LEVEL_EXCLUDE_CACHE_PRIVATE_PAGES)
+		 ? 1 : 0;
+	crash_dump_bitmap_ctrl.exclude_user_pages =
+		(dump_level & CRASH_DUMP_LEVEL_EXCLUDE_USER_PAGES) ? 1 : 0;
+	crash_dump_bitmap_ctrl.exclude_free_pages =
+		(dump_level & CRASH_DUMP_LEVEL_EXCLUDE_FREE_PAGES) ? 1 : 0;
+}
+
+static int proc_page_status_show(struct seq_file *m, void *v)
+{
+	u64 start, duration;
+
+	if (!crash_dump_bitmap_mem) {
+		seq_printf(m,
+			"crash_dump_bitmap: crash_dump_bitmap_mem not found!\n");
+
+		return -EINVAL;
+	}
+
+	seq_printf(m, "Exclude page flag status:\n");
+	seq_printf(m, "    exclude_dump_bitmap_pages=%d\n",
+		crash_dump_bitmap_ctrl.exclude_crash_dump_bitmap_pages);
+	seq_printf(m, "    exclude_zero_pages=%d\n",
+		crash_dump_bitmap_ctrl.exclude_zero_pages);
+	seq_printf(m, "    exclude_cache_pages=%d\n",
+		crash_dump_bitmap_ctrl.exclude_cache_pages);
+	seq_printf(m, "    exclude_cache_private_pages=%d\n",
+		crash_dump_bitmap_ctrl.exclude_cache_private_pages);
+	seq_printf(m, "    exclude_user_pages=%d\n",
+		crash_dump_bitmap_ctrl.exclude_user_pages);
+	seq_printf(m, "    exclude_free_pages=%d\n",
+		crash_dump_bitmap_ctrl.exclude_free_pages);
+
+	seq_printf(m, "Scanning all memory pages:\n");
+	start = get_jiffies_64();
+	generate_crash_dump_bitmap();
+	duration = get_jiffies_64() - start;
+	seq_printf(m, "    Done. Duration=%dms\n", jiffies_to_msecs(duration));
+
+	seq_printf(m, "Excluded memory page status:\n");
+	seq_printf(m, "    cache_pages=%ld\n",
+		crash_dump_bitmap_info.cache_pages);
+	seq_printf(m, "    cache_private_pages=%ld\n",
+		crash_dump_bitmap_info.cache_private_pages);
+	seq_printf(m, "    user_pages=%ld\n",
+		crash_dump_bitmap_info.user_pages);
+	seq_printf(m, "    free_pages=%ld\n",
+		crash_dump_bitmap_info.free_pages);
+	seq_printf(m, "    hwpoison_pages=%ld\n",
+		crash_dump_bitmap_info.hwpoison_pages);
+
+	return 0;
+}
+
+static int proc_page_status_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_page_status_show, NULL);
+}
+
+static const struct file_operations proc_page_status_fops = {
+	.open		= proc_page_status_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int proc_dump_level_show(struct seq_file *m, void *v)
+{
+	if (!crash_dump_bitmap_mem) {
+		seq_printf(m,
+			"crash_dump_bitmap: crash_dump_bitmap_mem not found!\n");
+
+		return -EINVAL;
+	}
+
+	seq_printf(m, "%d\n", get_dump_level());
+
+	return 0;
+}
+
+static ssize_t proc_dump_level_write(struct file *file,
+	const char __user *buffer, size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned int dump_level;
+
+	ret = kstrtouint_from_user(buffer, count, 10, &dump_level);
+	if (ret)
+		return -EFAULT;
+
+	set_dump_level(dump_level);
+
+	pr_info("crash_dump_bitmap: new dump_level=%d\n", dump_level);
+
+	return count;
+}
+
+static int proc_dump_level_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_dump_level_show, NULL);
+}
+
+static const struct file_operations proc_dump_level_fops = {
+	.open		= proc_dump_level_open,
+	.read		= seq_read,
+	.write		= proc_dump_level_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+int __init init_proc_crash_dump_bitmap(void)
+{
+	if (is_kdump_kernel() || (crash_dump_bitmap_mem == 0)
+		|| (crash_dump_bitmap_mem_size == 0))
+		return 0;
+
+	proc_dir = proc_mkdir(proc_dir_name, NULL);
+	if (proc_dir == NULL) {
+		pr_err("crash_dump_bitmap: proc_mkdir failed!\n");
+		return -EINVAL;
+	}
+
+	proc_page_status = proc_create(proc_page_status_name, 0444,
+		proc_dir, &proc_page_status_fops);
+	if (proc_page_status == NULL) {
+		pr_err("crash_dump_bitmap: create procfs %s failed!\n",
+			proc_page_status_name);
+		remove_proc_entry(proc_dir_name, NULL);
+		return -EINVAL;
+	}
+
+	proc_dump_level = proc_create(proc_dump_level_name, 0644,
+		proc_dir, &proc_dump_level_fops);
+	if (proc_dump_level == NULL) {
+		pr_err("crash_dump_bitmap: create procfs %s failed!\n",
+			proc_dump_level_name);
+		remove_proc_entry(proc_page_status_name, proc_dir);
+		remove_proc_entry(proc_dir_name, NULL);
+		return -EINVAL;
+	}
+
+	pr_info("crash_dump_bitmap: procfs driver initialized successfully!\n");
+
+	return 0;
+}
+
+void __exit cleanup_proc_crash_dump_bitmap(void)
+{
+	remove_proc_entry(proc_dump_level_name, proc_dir);
+	remove_proc_entry(proc_page_status_name, proc_dir);
+	remove_proc_entry(proc_dir_name, NULL);
+
+	pr_info("crash_dump_bitmap: procfs driver unloaded!\n");
+}
+
+module_init(init_proc_crash_dump_bitmap);
+module_exit(cleanup_proc_crash_dump_bitmap);
+
+#endif /* CONFIG_CRASH_DUMP_BITMAP */

