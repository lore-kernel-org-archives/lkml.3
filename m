Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936459Ab3DKVGC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:06:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17239 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935718Ab3DKUtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:15 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=l53_uAN06xQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=yztx1sZkUaUA:10 a=JDjsHSkAAAAA:8 a=UhR5MsZ8AAAA:8 a=VwQbUJbxAAAA:8 a=5LTywwN-4_UmgzhA2_YA:9 a=Hf6muOzgCGQA:10 a=sk_3bZWriPsA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202603.132733164@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Benny Halevy <bhalevy@tonian.com>
Subject: [ 104/171 ] NFSv4.1: Always clear the NFS_INO_LAYOUTCOMMIT in layoutreturn
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0104-NFSv4.1-Always-clear-the-NFS_INO_LAYOUTCOMMIT-in-lay.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

[ Upstream commit 24956804349ca0eadcdde032d65e8c00b4214096 ]

Note that clearing NFS_INO_LAYOUTCOMMIT is tricky, since it requires
you to also clear the NFS_LSEG_LAYOUTCOMMIT bits from the layout
segments.
The only two sites that need to do this are the ones that call
pnfs_return_layout() without first doing a layout commit.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Benny Halevy <bhalevy@tonian.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/nfs/pnfs.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index c5fe1a5..49dffeb5 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -364,6 +364,16 @@ should_free_lseg(struct pnfs_layout_range *lseg_range,
 	       lo_seg_intersecting(lseg_range, recall_range);
 }
 
+static bool pnfs_lseg_dec_and_remove_zero(struct pnfs_layout_segment *lseg,
+		struct list_head *tmp_list)
+{
+	if (!atomic_dec_and_test(&lseg->pls_refcount))
+		return false;
+	put_lseg_common(lseg);
+	list_add(&lseg->pls_list, tmp_list);
+	return true;
+}
+
 /* Returns 1 if lseg is removed from list, 0 otherwise */
 static int mark_lseg_invalid(struct pnfs_layout_segment *lseg,
 			     struct list_head *tmp_list)
@@ -377,11 +387,8 @@ static int mark_lseg_invalid(struct pnfs_layout_segment *lseg,
 		 */
 		dprintk("%s: lseg %p ref %d\n", __func__, lseg,
 			atomic_read(&lseg->pls_refcount));
-		if (atomic_dec_and_test(&lseg->pls_refcount)) {
-			put_lseg_common(lseg);
-			list_add(&lseg->pls_list, tmp_list);
+		if (pnfs_lseg_dec_and_remove_zero(lseg, tmp_list))
 			rv = 1;
-		}
 	}
 	return rv;
 }
@@ -614,6 +621,21 @@ send_layoutget(struct pnfs_layout_hdr *lo,
 	return lseg;
 }
 
+static void pnfs_clear_layoutcommit(struct inode *inode,
+		struct list_head *head)
+{
+	struct nfs_inode *nfsi = NFS_I(inode);
+	struct pnfs_layout_segment *lseg, *tmp;
+
+	if (!test_and_clear_bit(NFS_INO_LAYOUTCOMMIT, &nfsi->flags))
+		return;
+	list_for_each_entry_safe(lseg, tmp, &nfsi->layout->plh_segs, pls_list) {
+		if (!test_and_clear_bit(NFS_LSEG_LAYOUTCOMMIT, &lseg->pls_flags))
+			continue;
+		pnfs_lseg_dec_and_remove_zero(lseg, head);
+	}
+}
+
 /*
  * Initiates a LAYOUTRETURN(FILE), and removes the pnfs_layout_hdr
  * when the layout segment list is empty.
@@ -645,6 +667,7 @@ _pnfs_return_layout(struct inode *ino)
 	/* Reference matched in nfs4_layoutreturn_release */
 	get_layout_hdr(lo);
 	empty = list_empty(&lo->plh_segs);
+	pnfs_clear_layoutcommit(ino, &tmp_list);
 	mark_matching_lsegs_invalid(lo, &tmp_list, NULL);
 	/* Don't send a LAYOUTRETURN if list was initially empty */
 	if (empty) {
@@ -658,8 +681,6 @@ _pnfs_return_layout(struct inode *ino)
 	spin_unlock(&ino->i_lock);
 	pnfs_free_lseg_list(&tmp_list);
 
-	WARN_ON(test_bit(NFS_INO_LAYOUTCOMMIT, &nfsi->flags));
-
 	lrp = kzalloc(sizeof(*lrp), GFP_KERNEL);
 	if (unlikely(lrp == NULL)) {
 		status = -ENOMEM;
@@ -1283,7 +1304,6 @@ static void pnfs_ld_handle_write_error(struct nfs_write_data *data)
 	dprintk("pnfs write error = %d\n", hdr->pnfs_error);
 	if (NFS_SERVER(hdr->inode)->pnfs_curr_ld->flags &
 	    PNFS_LAYOUTRET_ON_ERROR) {
-		clear_bit(NFS_INO_LAYOUTCOMMIT, &NFS_I(hdr->inode)->flags);
 		pnfs_return_layout(hdr->inode);
 	}
 	if (!test_and_set_bit(NFS_IOHDR_REDO, &hdr->flags))
@@ -1435,7 +1455,6 @@ static void pnfs_ld_handle_read_error(struct nfs_read_data *data)
 	dprintk("pnfs read error = %d\n", hdr->pnfs_error);
 	if (NFS_SERVER(hdr->inode)->pnfs_curr_ld->flags &
 	    PNFS_LAYOUTRET_ON_ERROR) {
-		clear_bit(NFS_INO_LAYOUTCOMMIT, &NFS_I(hdr->inode)->flags);
 		pnfs_return_layout(hdr->inode);
 	}
 	if (!test_and_set_bit(NFS_IOHDR_REDO, &hdr->flags))
-- 
1.7.10.4


