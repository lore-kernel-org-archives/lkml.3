Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbaLCLtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:49:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbaLCL1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:20 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 055/101] NFSv4: Fix races between nfs_remove_bad_delegation() and delegation return
Date: Wed,  3 Dec 2014 12:26:17 +0100
Message-Id: <1f093632c55db7d63da16f158ed86be8836a40c4.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <trond.myklebust@primarydata.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/delegation.c | 23 +++++++++++++++++++++--
 fs/nfs/delegation.h |  1 +
 fs/nfs/nfs4proc.c   |  2 +-
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 6acc11e6ebad..3ed1be9aade3 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -179,7 +179,11 @@ static int nfs_do_return_delegation(struct inode *inode, struct nfs_delegation *
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
@@ -366,11 +370,13 @@ static int nfs_end_delegation_return(struct inode *inode, struct nfs_delegation
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
@@ -591,10 +597,23 @@ static void nfs_client_mark_return_unused_delegation_types(struct nfs_client *cl
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
index 9a79c7a99d6d..e02b090ab9da 100644
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
index 1d8af4f5842e..9dcfa4248c59 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1579,7 +1579,7 @@ static int nfs4_handle_delegation_recall_error(struct nfs_server *server, struct
 			nfs_inode_find_state_and_recover(state->inode,
 					stateid);
 			nfs4_schedule_stateid_recovery(server, state);
-			return 0;
+			return -EAGAIN;
 		case -NFS4ERR_DELAY:
 		case -NFS4ERR_GRACE:
 			set_bit(NFS_DELEGATED_STATE, &state->flags);
-- 
2.1.3

