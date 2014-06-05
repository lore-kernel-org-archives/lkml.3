Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaFEEVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:21:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbaFEEUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Benny Halevy <bhalevy@tonian.com>, Ben Hutchings <ben@decadent.org.uk>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 092/214] NFSv4.1: Fix a race in pNFS layoutcommit
Date: Wed,  4 Jun 2014 21:17:35 -0700
Message-Id: <20140605041652.013739566@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit a073dbff359f4741013ae4b8395f5364c5e00b48 upstream.

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
[bwh: Backported to 3.2: s/pnfs_put_lseg/put_lseg/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   14 --------------
 fs/nfs/pnfs.c     |   19 ++++++++++++++++++-
 2 files changed, 18 insertions(+), 15 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6297,22 +6297,8 @@ nfs4_layoutcommit_done(struct rpc_task *
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
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1381,11 +1381,27 @@ static void pnfs_list_write_lseg(struct
 
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
@@ -1434,6 +1450,7 @@ void pnfs_cleanup_layoutcommit(struct nf
 
 	if (nfss->pnfs_curr_ld->cleanup_layoutcommit)
 		nfss->pnfs_curr_ld->cleanup_layoutcommit(data);
+	pnfs_list_write_lseg_done(data->args.inode, &data->lseg_list);
 }
 
 /*


