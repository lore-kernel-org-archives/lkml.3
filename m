Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935432Ab3DHJvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:51:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42623 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934938Ab3DHJvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 010/102] NFSv4.1: Fix a race in pNFS layoutcommit
Date: Mon,  8 Apr 2013 10:49:25 +0100
Message-Id: <1365414657-29191-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5:
  - adjust context
  - function rename pnfs_put_lseg -> put_lseg ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/nfs4proc.c | 14 --------------
 fs/nfs/pnfs.c     | 19 ++++++++++++++++++-
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 81d51aa..b96aa12 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6501,22 +6501,8 @@ nfs4_layoutcommit_done(struct rpc_task *task, void *calldata)
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
index 8229a0e..958d512 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1546,11 +1546,27 @@ static void pnfs_list_write_lseg(struct inode *inode, struct list_head *listp)
 
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
@@ -1601,6 +1617,7 @@ void pnfs_cleanup_layoutcommit(struct nfs4_layoutcommit_data *data)
 
 	if (nfss->pnfs_curr_ld->cleanup_layoutcommit)
 		nfss->pnfs_curr_ld->cleanup_layoutcommit(data);
+	pnfs_list_write_lseg_done(data->args.inode, &data->lseg_list);
 }
 
 /*
-- 
1.8.1.2

