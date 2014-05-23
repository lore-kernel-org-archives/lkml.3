Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaEWDeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 23:34:10 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:38247 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaEWDdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 23:33:46 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org
Cc: mingo@kernel.org, peterz@infradead.org, riel@redhat.com, mgorman@suse.de,
        davidlohr@hp.com, aswin@hp.com, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] mm/rmap: share the i_mmap_rwsem
Date: Thu, 22 May 2014 20:33:25 -0700
Message-Id: <1400816006-3083-5-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1400816006-3083-1-git-send-email-davidlohr@hp.com>
References: <1400816006-3083-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similarly to rmap_walk_anon() and collect_procs_anon(),
there is opportunity to share the lock in rmap_walk_file()
and collect_procs_file() for file backed pages.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 include/linux/fs.h  | 10 ++++++++++
 mm/memory-failure.c |  4 ++--
 mm/rmap.c           |  4 ++--
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 60a1d7d..4c2c228 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -467,6 +467,16 @@ static inline void i_mmap_unlock_write(struct address_space *mapping)
 	up_write(&mapping->i_mmap_rwsem);
 }
 
+static inline void i_mmap_lock_read(struct address_space *mapping)
+{
+	down_read(&mapping->i_mmap_rwsem);
+}
+
+static inline void i_mmap_unlock_read(struct address_space *mapping)
+{
+	up_read(&mapping->i_mmap_rwsem);
+}
+
 /*
  * Might pages of this file be mapped into userspace?
  */
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 1389a28..acbcd8e 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -434,7 +434,7 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
 	struct task_struct *tsk;
 	struct address_space *mapping = page->mapping;
 
-	i_mmap_lock_write(mapping);
+	i_mmap_lock_read(mapping);
 	read_lock(&tasklist_lock);
 	for_each_process(tsk) {
 		pgoff_t pgoff = page_pgoff(page);
@@ -456,7 +456,7 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
 		}
 	}
 	read_unlock(&tasklist_lock);
-	i_mmap_unlock_write(mapping);
+	i_mmap_unlock_read(mapping);
 }
 
 /*
diff --git a/mm/rmap.c b/mm/rmap.c
index 9a56e4f..5841dcb 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1685,7 +1685,7 @@ static int rmap_walk_file(struct page *page, struct rmap_walk_control *rwc)
 
 	if (!mapping)
 		return ret;
-	i_mmap_lock_write(mapping);
+	i_mmap_lock_read(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
 
@@ -1708,7 +1708,7 @@ static int rmap_walk_file(struct page *page, struct rmap_walk_control *rwc)
 	ret = rwc->file_nonlinear(page, mapping, rwc->arg);
 
 done:
-	i_mmap_unlock_write(mapping);
+	i_mmap_unlock_read(mapping);
 	return ret;
 }
 
-- 
1.8.1.4

