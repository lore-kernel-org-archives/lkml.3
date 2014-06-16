Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbaFPJGC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:06:02 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:43785 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbaFPJFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:05:04 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Ian Kent <raven@themaw.net>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 2/2] fs/seq_file: fallback to vmalloc allocation
Date: Mon, 16 Jun 2014 11:04:52 +0200
Message-Id: <1402909492-36486-3-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1402909492-36486-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1402909492-36486-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061609-0342-0000-0000-0000001CD566
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a couple of seq_files which use the single_open() interface.
This interface requires that the whole output must fit into a single buffer.

E.g. for /proc/stat allocation failures have been observed because an order-4
memory allocation failed due to memory fragmentation. In such situations
reading /proc/stat is not possible anymore.

Therefore change the seq_file code to fallback to vmalloc allocations which
will usually result in a couple of order-0 allocations and hence also work
if memory is fragmented.

For reference a call trace where reading from /proc/stat failed:

[62129.701569] sadc: page allocation failure: order:4, mode:0x1040d0
[62129.701573] CPU: 1 PID: 192063 Comm: sadc Not tainted 3.10.0-123.el7.s390x #1
[...]
[62129.701586] Call Trace:
[62129.701588] ([<0000000000111fbe>] show_trace+0xe6/0x130)
[62129.701591] [<0000000000112074>] show_stack+0x6c/0xe8
[62129.701593] [<000000000020d356>] warn_alloc_failed+0xd6/0x138
[62129.701596] [<00000000002114d2>] __alloc_pages_nodemask+0x9da/0xb68
[62129.701598] [<000000000021168e>] __get_free_pages+0x2e/0x58
[62129.701599] [<000000000025a05c>] kmalloc_order_trace+0x44/0xc0
[62129.701602] [<00000000002f3ffa>] stat_open+0x5a/0xd8
[62129.701604] [<00000000002e9aaa>] proc_reg_open+0x8a/0x140
[62129.701606] [<0000000000273b64>] do_dentry_open+0x1bc/0x2c8
[62129.701608] [<000000000027411e>] finish_open+0x46/0x60
[62129.701610] [<000000000028675a>] do_last+0x382/0x10d0
[62129.701612] [<0000000000287570>] path_openat+0xc8/0x4f8
[62129.701614] [<0000000000288bde>] do_filp_open+0x46/0xa8
[62129.701616] [<000000000027541c>] do_sys_open+0x114/0x1f0
[62129.701618] [<00000000005b1c1c>] sysc_tracego+0x14/0x1a

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/seq_file.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 1d641bb108d2..3857b720cb1b 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -8,8 +8,10 @@
 #include <linux/fs.h>
 #include <linux/export.h>
 #include <linux/seq_file.h>
+#include <linux/vmalloc.h>
 #include <linux/slab.h>
 #include <linux/cred.h>
+#include <linux/mm.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -30,6 +32,16 @@ static void seq_set_overflow(struct seq_file *m)
 	m->count = m->size;
 }
 
+static void *seq_buf_alloc(unsigned long size)
+{
+	void *buf;
+
+	buf = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
+	if (!buf && size > PAGE_SIZE)
+		buf = vmalloc(size);
+	return buf;
+}
+
 /**
  *	seq_open -	initialize sequential file
  *	@file: file we initialize
@@ -96,7 +108,7 @@ static int traverse(struct seq_file *m, loff_t offset)
 		return 0;
 	}
 	if (!m->buf) {
-		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
+		m->buf = seq_buf_alloc(m->size = PAGE_SIZE);
 		if (!m->buf)
 			return -ENOMEM;
 	}
@@ -135,9 +147,9 @@ static int traverse(struct seq_file *m, loff_t offset)
 
 Eoverflow:
 	m->op->stop(m, p);
-	kfree(m->buf);
+	kvfree(m->buf);
 	m->count = 0;
-	m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
+	m->buf = seq_buf_alloc(m->size <<= 1);
 	return !m->buf ? -ENOMEM : -EAGAIN;
 }
 
@@ -192,7 +204,7 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 
 	/* grab buffer if we didn't have one */
 	if (!m->buf) {
-		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
+		m->buf = seq_buf_alloc(m->size = PAGE_SIZE);
 		if (!m->buf)
 			goto Enomem;
 	}
@@ -232,9 +244,9 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 		if (m->count < m->size)
 			goto Fill;
 		m->op->stop(m, p);
-		kfree(m->buf);
+		kvfree(m->buf);
 		m->count = 0;
-		m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
+		m->buf = seq_buf_alloc(m->size <<= 1);
 		if (!m->buf)
 			goto Enomem;
 		m->version = 0;
@@ -350,7 +362,7 @@ EXPORT_SYMBOL(seq_lseek);
 int seq_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = file->private_data;
-	kfree(m->buf);
+	kvfree(m->buf);
 	kfree(m);
 	return 0;
 }
@@ -605,13 +617,13 @@ EXPORT_SYMBOL(single_open);
 int single_open_size(struct file *file, int (*show)(struct seq_file *, void *),
 		void *data, size_t size)
 {
-	char *buf = kmalloc(size, GFP_KERNEL);
+	char *buf = seq_buf_alloc(size);
 	int ret;
 	if (!buf)
 		return -ENOMEM;
 	ret = single_open(file, show, data);
 	if (ret) {
-		kfree(buf);
+		kvfree(buf);
 		return ret;
 	}
 	((struct seq_file *)file->private_data)->buf = buf;
-- 
1.8.5.5

