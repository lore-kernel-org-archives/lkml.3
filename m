Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaIJHVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:21:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:45372 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbaIJHVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:21:39 -0400
Date: Wed, 10 Sep 2014 00:21:35 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>, Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] f2fs: Fix recover when nid of non-inode dnode < nid of
 inode
Message-ID: <20140910072012.GA9242@jaegeuk-mac02.mot-mobility.com>
References: <1410176306-1689-1-git-send-email-ying.huang@intel.com>
 <20140909052356.GA25590@jaegeuk-mac02.hsd1.ca.comcast.net>
 <1410241170.732.373.camel@yhuang-dev>
 <20140909070811.GA26657@jaegeuk-mac02.mot-mobility.com>
 <CAC=cRTMA9AqmHjQqK3=5pAs8yqi25Rzmz8MaZ8=oTDaxHAXU+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC=cRTMA9AqmHjQqK3=5pAs8yqi25Rzmz8MaZ8=oTDaxHAXU+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 07:31:49PM +0800, huang ying wrote:
> On Tue, Sep 9, 2014 at 3:09 PM, Jaegeuk Kim <jaegeuk@kernel.org> wrote:
> 
> > Hi,
> >
> > On Tue, Sep 09, 2014 at 01:39:30PM +0800, Huang Ying wrote:
> > > On Mon, 2014-09-08 at 22:23 -0700, Jaegeuk Kim wrote:
> > > > Hi Huang,
> > > >
> > > > On Mon, Sep 08, 2014 at 07:38:26PM +0800, Huang Ying wrote:
> > > > > For fsync, if the nid of a non-inode dnode < nid of inode and the
> > > > > inode is not checkpointed.  The non-inode dnode may be written before
> > > > > inode.  So in find_fsync_dnodes, f2fs_iget will fail, cause the
> > > > > recovery fail.
> > > > >
> > > > > Usually, inode will be allocated before non-inode dnode, so the nid
> > of
> > > > > inode < nid of non-inode dnode.  But it is possible for the reverse.
> > > > > For example, because of alloc_nid_failed.
> > > > >
> > > > > This is fixed via ignoring non-inode dnode before inode dnode in
> > > > > find_fsync_dnodes.
> > > > >
> > > > > The patch was tested via allocating nid reversely via a debugging
> > > > > patch, that is, from big number to small number.
> > > > >
> > > > > Signed-off-by: Huang, Ying <ying.huang@intel.com>
> > > > > ---
> > > > >  fs/f2fs/recovery.c |    7 ++++---
> > > > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > > >
> > > > > --- a/fs/f2fs/recovery.c
> > > > > +++ b/fs/f2fs/recovery.c
> > > > > @@ -172,8 +172,8 @@ static int find_fsync_dnodes(struct f2fs
> > > > >                   if (IS_INODE(page) && is_dent_dnode(page))
> > > > >                           set_inode_flag(F2FS_I(entry->inode),
> > > > >                                                   FI_INC_LINK);
> > > > > -         } else {
> > > > > -                 if (IS_INODE(page) && is_dent_dnode(page)) {
> > > >
> > > > If this is not inode block, we should add this inode to recover its
> > data blocks.
> > >
> > > Is it possible that there is only non-inode dnode but no inode when
> > > find_fsync_dnodes checking dnodes?  Per my understanding, any changes to
> > > file will cause inode page dirty (for example, mtime changed), so that
> > > we will write inode block.  Is it right?  If so, the solution in this
> > > patch should work too.
> >
> > Your description says that f2fs_iget will fail, which causes the recovery
> > fail.
> > So, I thought it would be better to handle the f2fs_iget failure directly.
> >
> 
> Yes.  That is another way to fix the issue.
> 
> 
> > In addition, we cannot guarantee the write order of dnode and inode.
> > For exmaple,
> > 1. the inode is written by flusher or kswapd, then,
> > 2. f2fs_sync_file writes its dnode.
> >
> > In that case, we can get only non-inode dnode in the node chain, since the
> > inode
> > has not fsync_mark.
> >
> 
> I think your solution is better here, but does not fix all scenarios.  If
> the inode is checkpointed, the file can be recovered, although the inode
> information may be not up to date.  But if the inode is not checkpointed,
> f2fs_iget will fail too and recover will fail.

Ok, let me consider your scenarios.

Term: F: fsync_mark, D: dentry_mark

1. inode(x) | CP | inode(x) | dnode(F)
 -> Lose the latest inode(x). Need to fix.

2. inode(x) | CP | dnode(F) | inode(x)
 -> Impossible, but recover latest dnode(F)

3. CP | inode(x) | dnode(F)
 -> Need to write inode(DF) in f2fs_sync_file.

4. CP | dnode(F) | inode(DF)
 -> If f2fs_iget fails, then goto next.

5. CP | dnode(F) | inode(x)
 -> If f2fs_iget fails, then goto next. But, this is an impossible scenario.
    Drop this dnode(F).

Indeed, there were some missing scenarios.

So, how about this patch?

>From 552dc68c5f07a335d7b55c197bab531efb135521 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk@kernel.org>
Date: Wed, 10 Sep 2014 00:16:34 -0700
Subject: [PATCH] f2fs: fix roll-forward missing scenarios

We can summarize the roll forward recovery scenarios as follows.

[Term] F: fsync_mark, D: dentry_mark

1. inode(x) | CP | inode(x) | dnode(F)
-> Update the latest inode(x).

2. inode(x) | CP | inode(F) | dnode(F)
-> No problem.

3. inode(x) | CP | dnode(F) | inode(x)
-> Impossible, but recover latest dnode(F)

4. inode(x) | CP | dnode(F) | inode(F)
-> No problem.

5. CP | inode(x) | dnode(F)
-> Impossible. Write inode(DF) with dnode(F) by f2fs_sync_file.

6. CP | inode(DF) | dnode(F)
-> No problem.

7. CP | dnode(F) | inode(DF)
-> If f2fs_iget fails, then goto next to find inode(DF).

8. CP | dnode(F) | inode(x)
-> If f2fs_iget fails, then goto next. But, this is an impossible scenario.
   Drop this dnode(F).

So, this patch adds some missing points such as #1, #5, #7, and #8.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c     | 10 ++++++++
 fs/f2fs/recovery.c | 70 +++++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5cde363..2660af2 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -207,6 +207,16 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 			up_write(&fi->i_sem);
 		}
 	} else {
+		/*
+		 * CP | inode(x) | dnode(F)
+		 * We need to remain inode(DF) for roll-forward recovery.
+		 */
+		if (fsync_mark_done(sbi, inode->i_ino) &&
+			!is_checkpointed_node(sbi, F2FS_I(inode)->i_pino)) {
+			mark_inode_dirty_sync(inode);
+			f2fs_write_inode(inode, NULL);
+		}
+
 		/* if there is no written node page, write its inode page */
 		while (!sync_node_pages(sbi, inode->i_ino, &wbc)) {
 			if (fsync_mark_done(sbi, inode->i_ino))
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 6c5a74a..8e69b9d 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -14,6 +14,36 @@
 #include "node.h"
 #include "segment.h"
 
+/*
+ * Roll forward recovery scenarios.
+ *
+ * [Term] F: fsync_mark, D: dentry_mark
+ *
+ * 1. inode(x) | CP | inode(x) | dnode(F)
+ * -> Update the latest inode(x).
+ *
+ * 2. inode(x) | CP | inode(F) | dnode(F)
+ * -> No problem.
+ *
+ * 3. inode(x) | CP | dnode(F) | inode(x)
+ * -> Impossible, but recover latest dnode(F)
+ *
+ * 4. inode(x) | CP | dnode(F) | inode(F)
+ * -> No problem.
+ *
+ * 5. CP | inode(x) | dnode(F)
+ * -> Impossible. Write inode(DF) with dnode(F) by f2fs_sync_file.
+ *
+ * 6. CP | inode(DF) | dnode(F)
+ * -> No problem.
+ *
+ * 7. CP | dnode(F) | inode(DF)
+ * -> If f2fs_iget fails, then goto next to find inode(DF).
+ *
+ * 8. CP | dnode(F) | inode(x)
+ * -> If f2fs_iget fails, then goto next. But, this is an impossible scenario.
+ *    Drop this dnode(F).
+ */
 static struct kmem_cache *fsync_entry_slab;
 
 bool space_for_roll_forward(struct f2fs_sb_info *sbi)
@@ -110,27 +140,32 @@ out:
 	return err;
 }
 
-static int recover_inode(struct inode *inode, struct page *node_page)
+static void __recover_inode(struct inode *inode, struct page *page)
 {
-	struct f2fs_inode *raw_inode = F2FS_INODE(node_page);
+	struct f2fs_inode *raw = F2FS_INODE(page);
+
+	inode->i_mode = le16_to_cpu(raw->i_mode);
+	i_size_write(inode, le64_to_cpu(raw->i_size));
+	inode->i_atime.tv_sec = le64_to_cpu(raw->i_mtime);
+	inode->i_ctime.tv_sec = le64_to_cpu(raw->i_ctime);
+	inode->i_mtime.tv_sec = le64_to_cpu(raw->i_mtime);
+	inode->i_atime.tv_nsec = le32_to_cpu(raw->i_mtime_nsec);
+	inode->i_ctime.tv_nsec = le32_to_cpu(raw->i_ctime_nsec);
+	inode->i_mtime.tv_nsec = le32_to_cpu(raw->i_mtime_nsec);
+}
 
+static int recover_inode(struct inode *inode, struct page *node_page)
+{
 	if (!IS_INODE(node_page))
 		return 0;
 
-	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
-	i_size_write(inode, le64_to_cpu(raw_inode->i_size));
-	inode->i_atime.tv_sec = le64_to_cpu(raw_inode->i_mtime);
-	inode->i_ctime.tv_sec = le64_to_cpu(raw_inode->i_ctime);
-	inode->i_mtime.tv_sec = le64_to_cpu(raw_inode->i_mtime);
-	inode->i_atime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
-	inode->i_ctime.tv_nsec = le32_to_cpu(raw_inode->i_ctime_nsec);
-	inode->i_mtime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
+	__recover_inode(inode, node_page);
 
 	if (is_dent_dnode(node_page))
 		return recover_dentry(node_page, inode);
 
 	f2fs_msg(inode->i_sb, KERN_NOTICE, "recover_inode: ino = %x, name = %s",
-			ino_of_node(node_page), raw_inode->i_name);
+			ino_of_node(node_page), F2FS_INODE(node_page)->i_name);
 	return 0;
 }
 
@@ -186,10 +221,16 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 				break;
 			}
 
+			/*
+			 * CP | dnode(F) | inode(DF)
+			 * For this case, we should not give up now.
+			 */
 			entry->inode = f2fs_iget(sbi->sb, ino_of_node(page));
 			if (IS_ERR(entry->inode)) {
 				err = PTR_ERR(entry->inode);
 				kmem_cache_free(fsync_entry_slab, entry);
+				if (PTR_ERR(entry->inode) == -ENOENT)
+					goto next;
 				break;
 			}
 			list_add_tail(&entry->list, head);
@@ -416,6 +457,13 @@ static int recover_data(struct f2fs_sb_info *sbi,
 		entry = get_fsync_inode(head, ino_of_node(page));
 		if (!entry)
 			goto next;
+		/*
+		 * inode(x) | CP | inode(x) | dnode(F)
+		 * In this case, we can lose the latest inode(x).
+		 * So, call __recover_inode for the inode update.
+		 */
+		if (IS_INODE(page))
+			__recover_inode(entry->inode, page);
 
 		err = do_recover_data(sbi, entry->inode, page, blkaddr);
 		if (err)
-- 
1.8.5.2 (Apple Git-48)

