Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab3A2GOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 01:14:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:29170 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574Ab3A2GOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 01:14:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,557,1355126400"; 
   d="scan'208";a="253974425"
Message-ID: <510768B6.3070000@intel.com>
Date: Tue, 29 Jan 2013 14:14:14 +0800
From: xtu4 <xiaobing.tu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, guifang.tang@intel.com,
        linX.z.chen@intel.com, akpm@linux-foundation.org
Subject: Avoid high order memory allocating with kmalloc, when read large
 seq file
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] [SEQ_FILE] Avoid high order memory allocating with kmalloc
  when read large seq file

currently, when dumpstate access /proc/xxx/binder , this binder include 
lots of info,
it will use seq_read in kernel, in this function, it will trigger high 
order memory alloc,
when read binder info or other large file, this will cause memory 
presure when system
don't have contious high order memory, it will lead to high kswap 
workload to reclaim the
page. so change kmalloc to vmalloc, it can avoid contiously high order 
memory allocating.
[ 4356.532357] dumpstate: page allocation failure: order:4, mode:0x40d0
[ 4356.532400] Pid: 18256, comm: dumpstate Tainted: G         C 
3.0.34-141128-g4be7088 #1
[ 4356.532416] Call Trace:
[ 4356.532443]  [<c185c836>] ? printk+0x1d/0x1f
[ 4356.532467]  [<c12cde1f>] warn_alloc_failed+0xbf/0xf0
[ 4356.532491]  [<c12d0aba>] __alloc_pages_nodemask+0x4ba/0x6a0
[ 4356.532521]  [<c12d0d1c>] __get_free_pages+0x1c/0x30
[ 4356.532541]  [<c12f51e1>] kmalloc_order_trace+0x21/0xd0
[ 4356.532561]  [<c131d0f7>] ? seq_read+0x137/0x390
[ 4356.532579]  [<c12f549a>] __kmalloc+0x20a/0x230
[ 4356.532596]  [<c131d0f7>] ? seq_read+0x137/0x390
[ 4356.532616]  [<c12d343c>] ? put_page+0x2c/0x40
[ 4356.532634]  [<c12f4a7d>] ? kfree+0xcd/0x160
[ 4356.532655]  [<c18656cd>] ? mutex_unlock+0xd/0x10
[ 4356.532675]  [<c131d109>] seq_read+0x149/0x390
[ 4356.532697]  [<c130062c>] vfs_read+0x8c/0x160
[ 4356.532716]  [<c131cfc0>] ? seq_lseek+0x180/0x180
[ 4356.532735]  [<c130073d>] sys_read+0x3d/0x70
[ 4356.532755]  [<c1866e91>] syscall_call+0x7/0xb
[ 4356.532777]  [<c1860000>] ? log_dir_items+0x33d/0x40c
Signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
Signed-off-by: linX z chen <linX.z.chen@intel.com>
Signed-off-by: guifang tang <guifang.tang@intel.com>
Change-Id: I892c97d02cf25e59b23c9bc68dff754ea01c1d56
---
  fs/seq_file.c |   18 +++++++++++++++---
  1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index dba43c3..20b8e36 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -209,8 +209,17 @@ ssize_t seq_read(struct file *file, char __user 
*buf, size_t size, loff_t *ppos)
          if (m->count < m->size)
              goto Fill;
          m->op->stop(m, p);
-        kfree(m->buf);
-        m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
+        if (m->size > 2 * PAGE_SIZE) {
+            vfree(m->buf);
+        } else
+            kfree(m->buf);
+        m->size <<= 1;
+        if (m->size > 2 * PAGE_SIZE) {
+            m->buf = vmalloc(m->size);
+        } else
+            m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
+
+
          if (!m->buf)
              goto Enomem;
          m->count = 0;
@@ -325,7 +334,10 @@ EXPORT_SYMBOL(seq_lseek);
  int seq_release(struct inode *inode, struct file *file)
  {
      struct seq_file *m = file->private_data;
-    kfree(m->buf);
+    if (m->size > 2 * PAGE_SIZE) {
+        vfree(m->buf);
+    } else
+        kfree(m->buf);
      kfree(m);
      return 0;
  }
-- 
1.7.6

