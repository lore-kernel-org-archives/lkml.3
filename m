Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbaAJKQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:16:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:7186 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbaAJKQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:16:34 -0500
X-IronPort-AV: E=Sophos;i="4.95,637,1384272000"; 
   d="scan'208";a="9400711"
Message-ID: <52CFC6C4.7030309@cn.fujitsu.com>
Date: Fri, 10 Jan 2014 18:09:08 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [f2fs-dev][PATCH 2/3] f2fs: move alloc new orphan node out of lock
 protection region
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/10 18:15:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/10 18:15:28,
	Serialize complete at 2014/01/10 18:15:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move alloc new orphan node out of lock protection region.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/checkpoint.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index af92c74..007f64c 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -219,26 +219,29 @@ void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 	struct list_head *head, *this;
 	struct orphan_inode_entry *new = NULL, *orphan = NULL;
 
+	new = f2fs_kmem_cache_alloc(orphan_entry_slab, GFP_ATOMIC);
+	new->ino = ino;
+
 	mutex_lock(&sbi->orphan_inode_mutex);
 	head = &sbi->orphan_inode_list;
 	list_for_each(this, head) {
 		orphan = list_entry(this, struct orphan_inode_entry, list);
-		if (orphan->ino == ino)
-			goto out;
+		if (orphan->ino == ino) {
+			mutex_unlock(&sbi->orphan_inode_mutex);
+			kmem_cache_free(orphan_entry_slab, new);
+			return;
+		}
+
 		if (orphan->ino > ino)
 			break;
 		orphan = NULL;
 	}
 
-	new = f2fs_kmem_cache_alloc(orphan_entry_slab, GFP_ATOMIC);
-	new->ino = ino;
-
 	/* add new_oentry into list which is sorted by inode number */
 	if (orphan)
 		list_add(&new->list, this->prev);
 	else
 		list_add_tail(&new->list, head);
-out:
 	mutex_unlock(&sbi->orphan_inode_mutex);
 }
 
-- 
1.7.7

