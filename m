Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbaKSVsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:48:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933457AbaKSVEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.14 072/122] NFSv4.1: nfs41_clear_delegation_stateid shouldnt trust NFS_DELEGATED_STATE
Date: Wed, 19 Nov 2014 12:52:02 -0800
Message-Id: <20141119205211.196416565@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2057,45 +2057,37 @@ static int nfs40_open_expired(struct nfs
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
@@ -2139,7 +2131,7 @@ static int nfs41_open_expired(struct nfs
 {
 	int status;
 
-	nfs41_clear_delegation_stateid(state);
+	nfs41_check_delegation_stateid(state);
 	status = nfs41_check_open_stateid(state);
 	if (status != NFS_OK)
 		status = nfs4_open_expired(sp, state);


