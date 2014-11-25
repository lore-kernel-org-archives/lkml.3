Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbaKYLCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:02:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58985 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbaKYKnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 197/254] NFSv4.1: nfs41_clear_delegation_stateid shouldn't trust NFS_DELEGATED_STATE
Date: Tue, 25 Nov 2014 10:39:07 +0000
Message-Id: <1416912004-5928-198-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 0c116cadd94b16b30b1dd90d38b2784d9b39b01a upstream.

This patch removes the assumption made previously, that we only need to
check the delegation stateid when it matches the stateid on a cached
open.

If we believe that we hold a delegation for this file, then we must assume
that its stateid may have been revoked or expired too. If we don't test it
then our state recovery process may end up caching open/lock state in a
situation where it should not.
We therefore rename the function nfs41_clear_delegation_stateid as
nfs41_check_delegation_stateid, and change it to always run through the
delegation stateid test and recovery process as outlined in RFC5661.

http://lkml.kernel.org/r/CAN-5tyHwG=Cn2Q9KsHWadewjpTTy_K26ee+UnSvHvG4192p-Xw@mail.gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/nfs4proc.c | 42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index fc97ec1f9037..fe949828bf47 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2117,45 +2117,37 @@ static int nfs40_open_expired(struct nfs4_state_owner *sp, struct nfs4_state *st
 }
 
 #if defined(CONFIG_NFS_V4_1)
-static void nfs41_clear_delegation_stateid(struct nfs4_state *state)
+static void nfs41_check_delegation_stateid(struct nfs4_state *state)
 {
 	struct nfs_server *server = NFS_SERVER(state->inode);
-	nfs4_stateid *stateid = &state->stateid;
+	nfs4_stateid stateid;
 	struct nfs_delegation *delegation;
-	struct rpc_cred *cred = NULL;
-	int status = -NFS4ERR_BAD_STATEID;
-
-	/* If a state reset has been done, test_stateid is unneeded */
-	if (test_bit(NFS_DELEGATED_STATE, &state->flags) == 0)
-		return;
+	struct rpc_cred *cred;
+	int status;
 
 	/* Get the delegation credential for use by test/free_stateid */
 	rcu_read_lock();
 	delegation = rcu_dereference(NFS_I(state->inode)->delegation);
-	if (delegation != NULL &&
-	    nfs4_stateid_match(&delegation->stateid, stateid)) {
-		cred = get_rpccred(delegation->cred);
-		rcu_read_unlock();
-		status = nfs41_test_stateid(server, stateid, cred);
-		trace_nfs4_test_delegation_stateid(state, NULL, status);
-	} else
+	if (delegation == NULL) {
 		rcu_read_unlock();
+		return;
+	}
+
+	nfs4_stateid_copy(&stateid, &delegation->stateid);
+	cred = get_rpccred(delegation->cred);
+	rcu_read_unlock();
+	status = nfs41_test_stateid(server, &stateid, cred);
+	trace_nfs4_test_delegation_stateid(state, NULL, status);
 
 	if (status != NFS_OK) {
 		/* Free the stateid unless the server explicitly
 		 * informs us the stateid is unrecognized. */
 		if (status != -NFS4ERR_BAD_STATEID)
-			nfs41_free_stateid(server, stateid, cred);
-		nfs_remove_bad_delegation(state->inode);
-
-		write_seqlock(&state->seqlock);
-		nfs4_stateid_copy(&state->stateid, &state->open_stateid);
-		write_sequnlock(&state->seqlock);
-		clear_bit(NFS_DELEGATED_STATE, &state->flags);
+			nfs41_free_stateid(server, &stateid, cred);
+		nfs_finish_clear_delegation_stateid(state);
 	}
 
-	if (cred != NULL)
-		put_rpccred(cred);
+	put_rpccred(cred);
 }
 
 /**
@@ -2199,7 +2191,7 @@ static int nfs41_open_expired(struct nfs4_state_owner *sp, struct nfs4_state *st
 {
 	int status;
 
-	nfs41_clear_delegation_stateid(state);
+	nfs41_check_delegation_stateid(state);
 	status = nfs41_check_open_stateid(state);
 	if (status != NFS_OK)
 		status = nfs4_open_expired(sp, state);
-- 
2.1.0

