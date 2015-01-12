Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbbALS4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:56:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58142 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbbALSaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Junxiao Bi <junxiao.bi@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 146/216] ocfs2: fix journal commit deadlock
Date: Mon, 12 Jan 2015 18:28:44 +0000
Message-Id: <1421087394-2712-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxiao Bi <junxiao.bi@oracle.com>

commit 136f49b9171074872f2a14ad0ab10486d1ba13ca upstream.

For buffer write, page lock will be got in write_begin and released in
write_end, in ocfs2_write_end_nolock(), before it unlock the page in
ocfs2_free_write_ctxt(), it calls ocfs2_run_deallocs(), this will ask
for the read lock of journal->j_trans_barrier.  Holding page lock and
ask for journal->j_trans_barrier breaks the locking order.

This will cause a deadlock with journal commit threads, ocfs2cmt will
get write lock of journal->j_trans_barrier first, then it wakes up
kjournald2 to do the commit work, at last it waits until done.  To
commit journal, kjournald2 needs flushing data first, it needs get the
cache page lock.

Since some ocfs2 cluster locks are holding by write process, this
deadlock may hung the whole cluster.

unlock pages before ocfs2_run_deallocs() can fix the locking order, also
put unlock before ocfs2_commit_trans() to make page lock is unlocked
before j_trans_barrier to preserve unlocking order.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Wengang Wang <wen.gang.wang@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ocfs2/aops.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 4a231a166cf8..c04183b008da 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -894,7 +894,7 @@ void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
 	}
 }
 
-static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
+static void ocfs2_unlock_pages(struct ocfs2_write_ctxt *wc)
 {
 	int i;
 
@@ -915,7 +915,11 @@ static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
 		page_cache_release(wc->w_target_page);
 	}
 	ocfs2_unlock_and_free_pages(wc->w_pages, wc->w_num_pages);
+}
 
+static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
+{
+	ocfs2_unlock_pages(wc);
 	brelse(wc->w_di_bh);
 	kfree(wc);
 }
@@ -2041,11 +2045,19 @@ out_write_size:
 	ocfs2_update_inode_fsync_trans(handle, inode, 1);
 	ocfs2_journal_dirty(handle, wc->w_di_bh);
 
+	/* unlock pages before dealloc since it needs acquiring j_trans_barrier
+	 * lock, or it will cause a deadlock since journal commit threads holds
+	 * this lock and will ask for the page lock when flushing the data.
+	 * put it here to preserve the unlock order.
+	 */
+	ocfs2_unlock_pages(wc);
+
 	ocfs2_commit_trans(osb, handle);
 
 	ocfs2_run_deallocs(osb, &wc->w_dealloc);
 
-	ocfs2_free_write_ctxt(wc);
+	brelse(wc->w_di_bh);
+	kfree(wc);
 
 	return copied;
 }
-- 
2.1.4

