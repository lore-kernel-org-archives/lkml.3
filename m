Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbaHHUtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:49:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40731 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaHHUtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:49:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ian Kent <raven@themaw.net>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 054/259] fs/seq_file: fallback to vmalloc allocation
Date: Fri,  8 Aug 2014 13:37:57 -0700
Message-Id: <1407530482-4483-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 058504edd02667eef8fac9be27ab3ea74332e9b4 upstream.

There are a couple of seq_files which use the single_open() interface.
This interface requires that the whole output must fit into a single
buffer.

E.g.  for /proc/stat allocation failures have been observed because an
order-4 memory allocation failed due to memory fragmentation.  In such
situations reading /proc/stat is not possible anymore.

Therefore change the seq_file code to fallback to vmalloc allocations
which will usually result in a couple of order-0 allocations and hence
also work if memory is fragmented.

For reference a call trace where reading from /proc/stat failed:

  sadc: page allocation failure: order:4, mode:0x1040d0
  CPU: 1 PID: 192063 Comm: sadc Not tainted 3.10.0-123.el7.s390x #1
  [...]
  Call Trace:
    show_stack+0x6c/0xe8
    warn_alloc_failed+0xd6/0x138
    __alloc_pages_nodemask+0x9da/0xb68
    __get_free_pages+0x2e/0x58
    kmalloc_order_trace+0x44/0xc0
    stat_open+0x5a/0xd8
    proc_reg_open+0x8a/0x140
    do_dentry_open+0x1bc/0x2c8
    finish_open+0x46/0x60
    do_last+0x382/0x10d0
    path_openat+0xc8/0x4f8
    do_filp_open+0x46/0xa8
    do_sys_open+0x114/0x1f0
    sysc_tracego+0x14/0x1a

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Tested-by: David Rientjes <rientjes@google.com>
Cc: Ian Kent <raven@themaw.net>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Thorsten Diehl <thorsten.diehl@de.ibm.com>
Cc: Andrea Righi <andrea@betterlinux.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/seq_file.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 1d641bb..3857b72 100644
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
1.9.1

