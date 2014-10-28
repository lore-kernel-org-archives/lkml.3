Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583AbaJ1HtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:49:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbaJ1Dil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:38:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Weston Andros Adamson <dros@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.17 065/146] NFSv4.1/pnfs: replace broken pnfs_put_lseg_async
Date: Tue, 28 Oct 2014 11:33:27 +0800
Message-Id: <20141028033346.193163908@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 6543f803670530f6aa93790d9fa116d8395a537d upstream.

You cannot call pnfs_put_lseg_async() more than once per lseg, so it
is really an inappropriate way to deal with a refcount issue.

Instead, replace it with a function that decrements the refcount, and
puts the final 'free' operation (which is incompatible with locks) on
the workqueue.

Cc: Weston Andros Adamson <dros@primarydata.com>
Fixes: e6cf82d1830f: pnfs: add pnfs_put_lseg_async
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/filelayout/filelayout.c |    2 +-
 fs/nfs/pnfs.c                  |   33 +++++++++++++++++++++++++++------
 fs/nfs/pnfs.h                  |    6 +-----
 3 files changed, 29 insertions(+), 12 deletions(-)

--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -1031,7 +1031,7 @@ filelayout_clear_request_commit(struct n
 	}
 out:
 	nfs_request_remove_commit_list(req, cinfo);
-	pnfs_put_lseg_async(freeme);
+	pnfs_put_lseg_locked(freeme);
 }
 
 static void
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -361,22 +361,43 @@ pnfs_put_lseg(struct pnfs_layout_segment
 }
 EXPORT_SYMBOL_GPL(pnfs_put_lseg);
 
-static void pnfs_put_lseg_async_work(struct work_struct *work)
+static void pnfs_free_lseg_async_work(struct work_struct *work)
 {
 	struct pnfs_layout_segment *lseg;
+	struct pnfs_layout_hdr *lo;
 
 	lseg = container_of(work, struct pnfs_layout_segment, pls_work);
+	lo = lseg->pls_layout;
 
-	pnfs_put_lseg(lseg);
+	pnfs_free_lseg(lseg);
+	pnfs_put_layout_hdr(lo);
 }
 
-void
-pnfs_put_lseg_async(struct pnfs_layout_segment *lseg)
+static void pnfs_free_lseg_async(struct pnfs_layout_segment *lseg)
 {
-	INIT_WORK(&lseg->pls_work, pnfs_put_lseg_async_work);
+	INIT_WORK(&lseg->pls_work, pnfs_free_lseg_async_work);
 	schedule_work(&lseg->pls_work);
 }
-EXPORT_SYMBOL_GPL(pnfs_put_lseg_async);
+
+void
+pnfs_put_lseg_locked(struct pnfs_layout_segment *lseg)
+{
+	if (!lseg)
+		return;
+
+	assert_spin_locked(&lseg->pls_layout->plh_inode->i_lock);
+
+	dprintk("%s: lseg %p ref %d valid %d\n", __func__, lseg,
+		atomic_read(&lseg->pls_refcount),
+		test_bit(NFS_LSEG_VALID, &lseg->pls_flags));
+	if (atomic_dec_and_test(&lseg->pls_refcount)) {
+		struct pnfs_layout_hdr *lo = lseg->pls_layout;
+		pnfs_get_layout_hdr(lo);
+		pnfs_layout_remove_lseg(lo, lseg);
+		pnfs_free_lseg_async(lseg);
+	}
+}
+EXPORT_SYMBOL_GPL(pnfs_put_lseg_locked);
 
 static u64
 end_offset(u64 start, u64 len)
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -183,7 +183,7 @@ extern int nfs4_proc_layoutreturn(struct
 /* pnfs.c */
 void pnfs_get_layout_hdr(struct pnfs_layout_hdr *lo);
 void pnfs_put_lseg(struct pnfs_layout_segment *lseg);
-void pnfs_put_lseg_async(struct pnfs_layout_segment *lseg);
+void pnfs_put_lseg_locked(struct pnfs_layout_segment *lseg);
 
 void set_pnfs_layoutdriver(struct nfs_server *, const struct nfs_fh *, u32);
 void unset_pnfs_layoutdriver(struct nfs_server *);
@@ -422,10 +422,6 @@ static inline void pnfs_put_lseg(struct
 {
 }
 
-static inline void pnfs_put_lseg_async(struct pnfs_layout_segment *lseg)
-{
-}
-
 static inline int pnfs_return_layout(struct inode *ino)
 {
 	return 0;


