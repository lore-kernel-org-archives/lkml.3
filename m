Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934541Ab3DGXZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:25:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46551 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934498Ab3DGXZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:25:24 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Benny Halevy" <bhalevy@tonian.com>,
        "Trond Myklebust" <Trond.Myklebust@netapp.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.957877700@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [24/74] NFSv4.1: Fix a race in pNFS layoutcommit
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

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
---
 fs/nfs/nfs4proc.c |   14 --------------
 fs/nfs/pnfs.c     |   19 ++++++++++++++++++-
 2 files changed, 18 insertions(+), 15 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6108,22 +6108,8 @@ nfs4_layoutcommit_done(struct rpc_task *
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
@@ -1356,11 +1356,27 @@ static void pnfs_list_write_lseg(struct
 
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
@@ -1409,6 +1425,7 @@ void pnfs_cleanup_layoutcommit(struct nf
 
 	if (nfss->pnfs_curr_ld->cleanup_layoutcommit)
 		nfss->pnfs_curr_ld->cleanup_layoutcommit(data);
+	pnfs_list_write_lseg_done(data->args.inode, &data->lseg_list);
 }
 
 /*

