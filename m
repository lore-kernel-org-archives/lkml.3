Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741AbaLBTsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:48:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46662 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933276AbaLBTXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:23:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 078/121] NFSv4: Fix races between nfs_remove_bad_delegation() and delegation return
Date: Tue,  2 Dec 2014 11:19:17 -0800
Message-Id: <1417548000-1794-79-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 869f9dfa4d6d57b79e0afc3af14772c2a023eeb1 upstream.

Any attempt to call nfs_remove_bad_delegation() while a delegation is being
returned is currently a no-op. This means that we can end up looping
forever in nfs_end_delegation_return() if something causes the delegation
to be revoked.
This patch adds a mechanism whereby the state recovery code can communicate
to the delegation return code that the delegation is no longer valid and
that it should not be used when reclaiming state.
It also changes the return value for nfs4_handle_delegation_recall_error()
to ensure that nfs_end_delegation_return() does not reattempt the lock
reclaim before state recovery is done.

http://lkml.kernel.org/r/CAN-5tyHwG=Cn2Q9KsHWadewjpTTy_K26ee+UnSvHvG4192p-Xw@mail.gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/delegation.c | 23 +++++++++++++++++++++--
 fs/nfs/delegation.h |  1 +
 fs/nfs/nfs4proc.c   |  2 +-
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 5d8ccec..2897534 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -177,7 +177,11 @@ static int nfs_do_return_delegation(struct inode *inode, struct nfs_delegation *
 {
 	int res = 0;
 
-	res = nfs4_proc_delegreturn(inode, delegation->cred, &delegation->stateid, issync);
+	if (!test_bit(NFS_DELEGATION_REVOKED, &delegation->flags))
+		res = nfs4_proc_delegreturn(inode,
+				delegation->cred,
+				&delegation->stateid,
+				issync);
 	nfs_free_delegation(delegation);
 	return res;
 }
@@ -364,11 +368,13 @@ static int nfs_end_delegation_return(struct inode *inode, struct nfs_delegation
 {
 	struct nfs_client *clp = NFS_SERVER(inode)->nfs_client;
 	struct nfs_inode *nfsi = NFS_I(inode);
-	int err;
+	int err = 0;
 
 	if (delegation == NULL)
 		return 0;
 	do {
+		if (test_bit(NFS_DELEGATION_REVOKED, &delegation->flags))
+			break;
 		err = nfs_delegation_claim_opens(inode, &delegation->stateid);
 		if (!issync || err != -EAGAIN)
 			break;
@@ -589,10 +595,23 @@ static void nfs_client_mark_return_unused_delegation_types(struct nfs_client *cl
 	rcu_read_unlock();
 }
 
+static void nfs_revoke_delegation(struct inode *inode)
+{
+	struct nfs_delegation *delegation;
+	rcu_read_lock();
+	delegation = rcu_dereference(NFS_I(inode)->delegation);
+	if (delegation != NULL) {
+		set_bit(NFS_DELEGATION_REVOKED, &delegation->flags);
+		nfs_mark_return_delegation(NFS_SERVER(inode), delegation);
+	}
+	rcu_read_unlock();
+}
+
 void nfs_remove_bad_delegation(struct inode *inode)
 {
 	struct nfs_delegation *delegation;
 
+	nfs_revoke_delegation(inode);
 	delegation = nfs_inode_detach_delegation(inode);
 	if (delegation) {
 		nfs_inode_find_state_and_recover(inode, &delegation->stateid);
diff --git a/fs/nfs/delegation.h b/fs/nfs/delegation.h
index 9a79c7a..e02b090 100644
--- a/fs/nfs/delegation.h
+++ b/fs/nfs/delegation.h
@@ -31,6 +31,7 @@ enum {
 	NFS_DELEGATION_RETURN_IF_CLOSED,
 	NFS_DELEGATION_REFERENCED,
 	NFS_DELEGATION_RETURNING,
+	NFS_DELEGATION_REVOKED,
 };
 
 int nfs_inode_set_delegation(struct inode *inode, struct rpc_cred *cred, struct nfs_openres *res);
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index f81f845..322c416 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1589,7 +1589,7 @@ static int nfs4_handle_delegation_recall_error(struct nfs_server *server, struct
 			nfs_inode_find_state_and_recover(state->inode,
 					stateid);
 			nfs4_schedule_stateid_recovery(server, state);
-			return 0;
+			return -EAGAIN;
 		case -NFS4ERR_DELAY:
 		case -NFS4ERR_GRACE:
 			set_bit(NFS_DELEGATED_STATE, &state->flags);
-- 
1.9.1

