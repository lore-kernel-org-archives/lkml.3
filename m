Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964924Ab3DKN3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:29:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161243Ab3DKN3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:29:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 11/26] nubus: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: linux-m68k@vger.kernel.org, viro@ZenIV.linux.org.uk
Date: Thu, 11 Apr 2013 14:29:09 +0100
Message-ID: <20130411132909.32763.97657.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use create_proc_read_entry() as that is deprecated, but rather use
proc_create_data() and seq_file instead.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-m68k@lists.linux-m68k.org
---

 drivers/nubus/nubus.c |   55 ---------------------------------
 drivers/nubus/proc.c  |   81 ++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/nubus.h |    4 ++
 3 files changed, 80 insertions(+), 60 deletions(-)

diff --git a/drivers/nubus/nubus.c b/drivers/nubus/nubus.c
index 44d01af..43926cd 100644
--- a/drivers/nubus/nubus.c
+++ b/drivers/nubus/nubus.c
@@ -19,7 +19,6 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/hwtest.h>
-#include <linux/proc_fs.h>
 #include <asm/mac_via.h>
 #include <asm/mac_oss.h>
 
@@ -954,56 +953,6 @@ void __init nubus_probe_slot(int slot)
 	}
 }
 
-#if defined(CONFIG_PROC_FS)
-
-/* /proc/nubus stuff */
-
-static int sprint_nubus_board(struct nubus_board* board, char* ptr, int len)
-{
-	if(len < 100)
-		return -1;
-	
-	sprintf(ptr, "Slot %X: %s\n",
-		board->slot, board->name);
-	
-	return strlen(ptr);
-}
-
-static int nubus_read_proc(char *page, char **start, off_t off,
-				int count, int *eof, void *data)
-{
-	int nprinted, len, begin = 0;
-	int size = PAGE_SIZE;
-	struct nubus_board* board;
-	
-	len   = sprintf(page, "Nubus devices found:\n");
-	/* Walk the list of NuBus boards */
-	for (board = nubus_boards; board != NULL; board = board->next)
-	{
-		nprinted = sprint_nubus_board(board, page + len, size - len);
-		if (nprinted < 0)
-			break;
-		len += nprinted;
-		if (len+begin < off) {
-			begin += len;
-			len = 0;
-		}
-		if (len+begin >= off+count)
-			break;
-	}
-	if (len+begin < off)
-		*eof = 1;
-	off -= begin;
-	*start = page + off;
-	len -= off;
-	if (len>count)
-		len = count;
-	if (len<0)
-		len = 0;
-	return len;
-}
-#endif
-
 void __init nubus_scan_bus(void)
 {
 	int slot;
@@ -1041,11 +990,7 @@ static int __init nubus_init(void)
 	nubus_devices = NULL;
 	nubus_boards  = NULL;
 	nubus_scan_bus();
-
-#ifdef CONFIG_PROC_FS
-	create_proc_read_entry("nubus", 0, NULL, nubus_read_proc, NULL);
 	nubus_proc_init();
-#endif
 	return 0;
 }
 
diff --git a/drivers/nubus/proc.c b/drivers/nubus/proc.c
index bb1446b..b8286ed 100644
--- a/drivers/nubus/proc.c
+++ b/drivers/nubus/proc.c
@@ -52,7 +52,6 @@ static int nubus_devices_proc_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations nubus_devices_proc_fops = {
-	.owner		= THIS_MODULE,
 	.open		= nubus_devices_proc_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -61,6 +60,10 @@ static const struct file_operations nubus_devices_proc_fops = {
 
 static struct proc_dir_entry *proc_bus_nubus_dir;
 
+static const struct file_operations nubus_proc_subdir_fops = {
+#warning Need to set some I/O handlers here
+};
+
 static void nubus_proc_subdir(struct nubus_dev* dev,
 			      struct proc_dir_entry* parent,
 			      struct nubus_dir* dir)
@@ -73,10 +76,10 @@ static void nubus_proc_subdir(struct nubus_dev* dev,
 		struct proc_dir_entry* e;
 		
 		sprintf(name, "%x", ent.type);
-#warning Need to set some I/O handlers here
-		e = create_proc_read_entry(name, S_IFREG | S_IRUGO | S_IWUSR,
-					   parent, NULL, NULL);
-		if (!e) return;
+		e = proc_create(name, S_IFREG | S_IRUGO | S_IWUSR, parent,
+				&nubus_proc_subdir_fops);
+		if (!e)
+			return;
 	}
 }
 
@@ -159,6 +162,73 @@ int nubus_proc_detach_device(struct nubus_dev *dev)
 }
 EXPORT_SYMBOL(nubus_proc_detach_device);
 
+/*
+ * /proc/nubus stuff
+ */
+static int nubus_proc_show(struct seq_file *m, void *v)
+{
+	const struct nubus_board *board = v;
+
+	/* Display header on line 1 */
+	if (v == SEQ_START_TOKEN)
+		seq_puts(m, "Nubus devices found:\n");
+	else
+		seq_printf(m, "Slot %X: %s\n", board->slot, board->name);
+	return 0;
+}
+
+static void *nubus_proc_start(struct seq_file *m, loff_t *_pos)
+{
+	struct nubus_board *board;
+	unsigned pos;
+
+	if (*_pos > LONG_MAX)
+		return NULL;
+	pos = *_pos;
+	if (pos == 0)
+		return SEQ_START_TOKEN;
+	for (board = nubus_boards; board; board = board->next)
+		if (--pos == 0)
+			break;
+	return board;
+}
+
+static void *nubus_proc_next(struct seq_file *p, void *v, loff_t *_pos)
+{
+	/* Walk the list of NuBus boards */
+	struct nubus_board *board = v;
+
+	++*_pos;
+	if (v == SEQ_START_TOKEN)
+		board = nubus_boards;
+	else if (board)
+		board = board->next;
+	return board;
+}
+
+static void nubus_proc_stop(struct seq_file *p, void *v)
+{
+}
+
+static const struct seq_operations nubus_proc_seqops = {
+	.start	= nubus_proc_start,
+	.next	= nubus_proc_next,
+	.stop	= nubus_proc_stop,
+	.show	= nubus_proc_show,
+};
+
+static int nubus_proc_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &nubus_proc_seqops);
+}
+
+static const struct file_operations nubus_proc_fops = {
+	.open		= nubus_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 void __init proc_bus_nubus_add_devices(void)
 {
 	struct nubus_dev *dev;
@@ -169,6 +239,7 @@ void __init proc_bus_nubus_add_devices(void)
 
 void __init nubus_proc_init(void)
 {
+	proc_create("nubus", 0, NULL, &nubus_proc_fops);
 	if (!MACH_IS_MAC)
 		return;
 	proc_bus_nubus_dir = proc_mkdir("bus/nubus", NULL);
diff --git a/include/linux/nubus.h b/include/linux/nubus.h
index a8696bb..b374052 100644
--- a/include/linux/nubus.h
+++ b/include/linux/nubus.h
@@ -80,7 +80,11 @@ extern struct nubus_board* nubus_boards;
 
 /* Generic NuBus interface functions, modelled after the PCI interface */
 void nubus_scan_bus(void);
+#ifdef CONFIG_PROC_FS
 extern void nubus_proc_init(void);
+#else
+static inline void nubus_proc_init(void) {}
+#endif
 int get_nubus_list(char *buf);
 int nubus_proc_attach_device(struct nubus_dev *dev);
 int nubus_proc_detach_device(struct nubus_dev *dev);

