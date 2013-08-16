Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab3HPWiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:38:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51503 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab3HPWiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:38:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yonghua Zheng <younghua.zheng@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 122/133] fs/proc/task_mmu.c: fix buffer overflow in add_page_map()
Date: Fri, 16 Aug 2013 15:34:24 -0700
Message-Id: <1376692475-28413-123-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: yonghua zheng <younghua.zheng@gmail.com>

commit 8c8296223f3abb142be8fc31711b18a704c0e7d8 upstream.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/proc/task_mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index ca5ce7f..f31d90f 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -792,14 +792,14 @@ typedef struct {
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
@@ -1038,8 +1038,8 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
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
1.8.1.2

