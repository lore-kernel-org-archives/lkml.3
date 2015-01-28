Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbbA2JIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:08:39 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44931 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760616AbbA2JIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:08:34 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>,
        Joel Becker <jlbec@evilplan.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 003/176] ocfs2: fix journal commit deadlock
Date: Wed, 28 Jan 2015 15:27:13 +0100
Message-Id: <e5a7d2e6d991b775dbd8407d7c589ef6709f112a.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junxiao Bi <junxiao.bi@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ocfs2/aops.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index f37d3c0e2053..dd2c4e4ec691 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -912,7 +912,7 @@ void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
 	}
 }
 
-static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
+static void ocfs2_unlock_pages(struct ocfs2_write_ctxt *wc)
 {
 	int i;
 
@@ -933,7 +933,11 @@ static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
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
@@ -2055,11 +2059,19 @@ out_write_size:
 	di->i_mtime_nsec = di->i_ctime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
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
2.2.2

