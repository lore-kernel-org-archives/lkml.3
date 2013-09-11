Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab3IKE6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3IKE5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:02 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=3KM5JZvT8dsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=BAGBkSTFeygA:10 a=pGLkceISAAAA:8 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8 a=LwezXiBaZejMzQoXydwA:9 a=MSl-tDqOz04A:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=VC6pbi3rmde0ltmf:21 a=uH4Ctzs9pp8eyAmA:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042924.452607950@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Yonghua Zheng <younghua.zheng@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [194/251] fs/proc/task_mmu.c: fix buffer overflow in add_page_map()
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0194-fs-proc-task_mmu.c-fix-buffer-overflow-in-add_page_m.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: yonghua zheng <younghua.zheng@gmail.com>

[ Upstream commit 8c8296223f3abb142be8fc31711b18a704c0e7d8 ]

Recently we met quite a lot of random kernel panic issues after enabling
CONFIG_PROC_PAGE_MONITOR.  After debuggind we found this has something
to do with following bug in pagemap:

In struct pagemapread:

  struct pagemapread {
      int pos, len;
      pagemap_entry_t *buffer;
      bool v2;
  };

pos is number of PM_ENTRY_BYTES in buffer, but len is the size of
buffer, it is a mistake to compare pos and len in add_page_map() for
checking buffer is full or not, and this can lead to buffer overflow and
random kernel panic issue.

Correct len to be total number of PM_ENTRY_BYTES in buffer.

[akpm@linux-foundation.org: document pagemapread.pos and .len units, fix PM_ENTRY_BYTES definition]
Signed-off-by: Yonghua Zheng <younghua.zheng@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/proc/task_mmu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 4540b8f..1868fe1 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -693,14 +693,14 @@ typedef struct {
 } pagemap_entry_t;
 
 struct pagemapread {
-	int pos, len;
+	int pos, len;		/* units: PM_ENTRY_BYTES, not bytes */
 	pagemap_entry_t *buffer;
 };
 
 #define PAGEMAP_WALK_SIZE	(PMD_SIZE)
 #define PAGEMAP_WALK_MASK	(PMD_MASK)
 
-#define PM_ENTRY_BYTES      sizeof(u64)
+#define PM_ENTRY_BYTES      sizeof(pagemap_entry_t)
 #define PM_STATUS_BITS      3
 #define PM_STATUS_OFFSET    (64 - PM_STATUS_BITS)
 #define PM_STATUS_MASK      (((1LL << PM_STATUS_BITS) - 1) << PM_STATUS_OFFSET)
@@ -939,8 +939,8 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	if (!count)
 		goto out_task;
 
-	pm.len = PM_ENTRY_BYTES * (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
-	pm.buffer = kmalloc(pm.len, GFP_TEMPORARY);
+	pm.len = (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
+	pm.buffer = kmalloc(pm.len * PM_ENTRY_BYTES, GFP_TEMPORARY);
 	ret = -ENOMEM;
 	if (!pm.buffer)
 		goto out_task;
-- 
1.7.10.4


