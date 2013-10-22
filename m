Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3JVG6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 02:58:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43141 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753152Ab3JVG6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 02:58:18 -0400
X-IronPort-AV: E=Sophos;i="4.93,546,1378828800"; 
   d="scan'208";a="8824931"
Message-ID: <526620AA.60007@cn.fujitsu.com>
Date: Tue, 22 Oct 2013 14:52:26 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH V2] f2fs: introduce f2fs_kmem_cache_alloc to hide the unfailed,
 kmem cache allocation
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/22 14:55:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/22 14:55:43,
	Serialize complete at 2013/10/22 14:55:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the unfailed version of kmem_cache_alloc named f2fs_kmem_cache_alloc
to hide the retry routine and make the code a bit cleaner.

v2:
   Fix the wrong use of 'retry' tag pointed out by Gao feng.
   Use more neat code to remove redundant tag suggested by Haicheng Li.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/checkpoint.c |   26 +++++++-------------------
 fs/f2fs/f2fs.h       |   15 +++++++++++++++
 fs/f2fs/gc.c         |    8 ++------
 fs/f2fs/node.c       |   27 +++++++++++----------------
 4 files changed, 35 insertions(+), 41 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 8d16071..6fb484c 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -226,12 +226,8 @@ void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 			break;
 		orphan = NULL;
 	}
-retry:
-	new = kmem_cache_alloc(orphan_entry_slab, GFP_ATOMIC);
-	if (!new) {
-		cond_resched();
-		goto retry;
-	}
+
+	new = f2fs_kmem_cache_alloc(orphan_entry_slab, GFP_ATOMIC);
 	new->ino = ino;
 
 	/* add new_oentry into list which is sorted by inode number */
@@ -484,12 +480,8 @@ void set_dirty_dir_page(struct inode *inode, struct page *page)
 
 	if (!S_ISDIR(inode->i_mode))
 		return;
-retry:
-	new = kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
-	if (!new) {
-		cond_resched();
-		goto retry;
-	}
+
+	new = f2fs_kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
 	new->inode = inode;
 	INIT_LIST_HEAD(&new->list);
 
@@ -506,13 +498,9 @@ retry:
 void add_dirty_dir_inode(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-	struct dir_inode_entry *new;
-retry:
-	new = kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
-	if (!new) {
-		cond_resched();
-		goto retry;
-	}
+	struct dir_inode_entry *new =
+			f2fs_kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
+
 	new->inode = inode;
 	INIT_LIST_HEAD(&new->list);
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 171c52f..2949275 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -18,6 +18,7 @@
 #include <linux/crc32.h>
 #include <linux/magic.h>
 #include <linux/kobject.h>
+#include <linux/sched.h>
 
 /*
  * For mount options
@@ -787,6 +788,20 @@ static inline struct kmem_cache *f2fs_kmem_cache_create(const char *name,
 	return kmem_cache_create(name, size, 0, SLAB_RECLAIM_ACCOUNT, ctor);
 }
 
+static inline void *f2fs_kmem_cache_alloc(struct kmem_cache *cachep,
+						gfp_t flags)
+{
+	void *entry;
+retry:
+	entry = kmem_cache_alloc(cachep, flags);
+	if (!entry) {
+		cond_resched();
+		goto retry;
+	}
+
+	return entry;
+}
+
 #define RAW_IS_INODE(p)	((p)->footer.nid == (p)->footer.ino)
 
 static inline bool IS_INODE(struct page *page)
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index fbad968..7914b92 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -361,12 +361,8 @@ static void add_gc_inode(struct inode *inode, struct list_head *ilist)
 		iput(inode);
 		return;
 	}
-repeat:
-	new_ie = kmem_cache_alloc(winode_slab, GFP_NOFS);
-	if (!new_ie) {
-		cond_resched();
-		goto repeat;
-	}
+
+	new_ie = f2fs_kmem_cache_alloc(winode_slab, GFP_NOFS);
 	new_ie->inode = inode;
 	list_add_tail(&new_ie->list, ilist);
 }
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index ef80f79..4fa3fd5 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1296,23 +1296,18 @@ static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build)
 	if (nid == 0)
 		return 0;
 
-	if (!build)
-		goto retry;
-
-	/* do not add allocated nids */
-	read_lock(&nm_i->nat_tree_lock);
-	ne = __lookup_nat_cache(nm_i, nid);
-	if (ne && nat_get_blkaddr(ne) != NULL_ADDR)
-		allocated = true;
-	read_unlock(&nm_i->nat_tree_lock);
-	if (allocated)
-		return 0;
-retry:
-	i = kmem_cache_alloc(free_nid_slab, GFP_NOFS);
-	if (!i) {
-		cond_resched();
-		goto retry;
+	if (build) {
+		/* do not add allocated nids */
+		read_lock(&nm_i->nat_tree_lock);
+		ne = __lookup_nat_cache(nm_i, nid);
+		if (ne && nat_get_blkaddr(ne) != NULL_ADDR)
+			allocated = true;
+		read_unlock(&nm_i->nat_tree_lock);
+		if (allocated)
+			return 0;
 	}
+
+	i = f2fs_kmem_cache_alloc(free_nid_slab, GFP_NOFS);
 	i->nid = nid;
 	i->state = NID_NEW;
 
-- 
1.7.7

