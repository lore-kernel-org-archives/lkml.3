Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936436Ab3DKVGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:06:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16652 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935719Ab3DKUtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:15 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=BzMOaOaKbI0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=lffyWzORy2wA:10 a=JDjsHSkAAAAA:8 a=UhR5MsZ8AAAA:8 a=VwQbUJbxAAAA:8 a=C48bUtl0UorUZ1PyTTsA:9 a=Hf6muOzgCGQA:10 a=sk_3bZWriPsA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202602.981576419@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Benny Halevy <bhalevy@tonian.com>
Subject: [ 103/171 ] NFSv4.1: Fix a race in pNFS layoutcommit
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0103-NFSv4.1-Fix-a-race-in-pNFS-layoutcommit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

[ Upstream commit a073dbff359f4741013ae4b8395f5364c5e00b48 ]

We need to clear the NFS_LSEG_LAYOUTCOMMIT bits atomically with the
NFS_INO_LAYOUTCOMMIT bit, otherwise we may end up with situations
where the two are out of sync.
The first half of the problem is to ensure that pnfs_layoutcommit_inode
clears the NFS_LSEG_LAYOUTCOMMIT bit through pnfs_list_write_lseg.
We still need to keep the reference to those segments until the RPC call
is finished, so in order to make it clear _where_ those references come
from, we add a helper pnfs_list_write_lseg_done() that cleans up after
pnfs_list_write_lseg.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Benny Halevy <bhalevy@tonian.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/nfs/nfs4proc.c |   14 --------------
 fs/nfs/pnfs.c     |   19 ++++++++++++++++++-
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 7bff871..2c6c214 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6549,22 +6549,8 @@ nfs4_layoutcommit_done(struct rpc_task *task, void *calldata)
 static void nfs4_layoutcommit_release(void *calldata)
 {
 	struct nfs4_layoutcommit_data *data = calldata;
-	struct pnfs_layout_segment *lseg, *tmp;
-	unsigned long *bitlock = &NFS_I(data->args.inode)->flags;
 
 	pnfs_cleanup_layoutcommit(data);
-	/* Matched by references in pnfs_set_layoutcommit */
-	list_for_each_entry_safe(lseg, tmp, &data->lseg_list, pls_lc_list) {
-		list_del_init(&lseg->pls_lc_list);
-		if (test_and_clear_bit(NFS_LSEG_LAYOUTCOMMIT,
-				       &lseg->pls_flags))
-			put_lseg(lseg);
-	}
-
-	clear_bit_unlock(NFS_INO_LAYOUTCOMMITTING, bitlock);
-	smp_mb__after_clear_bit();
-	wake_up_bit(bitlock, NFS_INO_LAYOUTCOMMITTING);
-
 	put_rpccred(data->cred);
 	kfree(data);
 }
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 2e00fea..c5fe1a5 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1567,11 +1567,27 @@ static void pnfs_list_write_lseg(struct inode *inode, struct list_head *listp)
 
 	list_for_each_entry(lseg, &NFS_I(inode)->layout->plh_segs, pls_list) {
 		if (lseg->pls_range.iomode == IOMODE_RW &&
-		    test_bit(NFS_LSEG_LAYOUTCOMMIT, &lseg->pls_flags))
+		    test_and_clear_bit(NFS_LSEG_LAYOUTCOMMIT, &lseg->pls_flags))
 			list_add(&lseg->pls_lc_list, listp);
 	}
 }
 
+static void pnfs_list_write_lseg_done(struct inode *inode, struct list_head *listp)
+{
+	struct pnfs_layout_segment *lseg, *tmp;
+	unsigned long *bitlock = &NFS_I(inode)->flags;
+
+	/* Matched by references in pnfs_set_layoutcommit */
+	list_for_each_entry_safe(lseg, tmp, listp, pls_lc_list) {
+		list_del_init(&lseg->pls_lc_list);
+		put_lseg(lseg);
+	}
+
+	clear_bit_unlock(NFS_INO_LAYOUTCOMMITTING, bitlock);
+	smp_mb__after_clear_bit();
+	wake_up_bit(bitlock, NFS_INO_LAYOUTCOMMITTING);
+}
+
 void pnfs_set_lo_fail(struct pnfs_layout_segment *lseg)
 {
 	if (lseg->pls_range.iomode == IOMODE_RW) {
@@ -1622,6 +1638,7 @@ void pnfs_cleanup_layoutcommit(struct nfs4_layoutcommit_data *data)
 
 	if (nfss->pnfs_curr_ld->cleanup_layoutcommit)
 		nfss->pnfs_curr_ld->cleanup_layoutcommit(data);
+	pnfs_list_write_lseg_done(data->args.inode, &data->lseg_list);
 }
 
 /*
-- 
1.7.10.4


