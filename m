Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbaFCLlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:41:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43485 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbaFCLlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:41:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 057/138] NFSd: Move default initialisers from create_client() to alloc_client()
Date: Tue,  3 Jun 2014 12:38:23 +0100
Message-Id: <1401795584-22664-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 5694c93e6c4954fa9424c215f75eeb919bddad64 upstream.

Aside from making it clearer what is non-trivial in create_client(), it
also fixes a bug whereby we can call free_client() before idr_init()
has been called.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/nfs4state.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index e271e178dcd3..6b91770a83de 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1071,6 +1071,18 @@ static struct nfs4_client *alloc_client(struct xdr_netobj name)
 		return NULL;
 	}
 	clp->cl_name.len = name.len;
+	INIT_LIST_HEAD(&clp->cl_sessions);
+	idr_init(&clp->cl_stateids);
+	atomic_set(&clp->cl_refcount, 0);
+	clp->cl_cb_state = NFSD4_CB_UNKNOWN;
+	INIT_LIST_HEAD(&clp->cl_idhash);
+	INIT_LIST_HEAD(&clp->cl_openowners);
+	INIT_LIST_HEAD(&clp->cl_delegations);
+	INIT_LIST_HEAD(&clp->cl_lru);
+	INIT_LIST_HEAD(&clp->cl_callbacks);
+	INIT_LIST_HEAD(&clp->cl_revoked);
+	spin_lock_init(&clp->cl_lock);
+	rpc_init_wait_queue(&clp->cl_cb_waitq, "Backchannel slot table");
 	return clp;
 }
 
@@ -1335,7 +1347,6 @@ static struct nfs4_client *create_client(struct xdr_netobj name,
 	if (clp == NULL)
 		return NULL;
 
-	INIT_LIST_HEAD(&clp->cl_sessions);
 	ret = copy_cred(&clp->cl_cred, &rqstp->rq_cred);
 	if (ret) {
 		spin_lock(&nn->client_lock);
@@ -1343,20 +1354,9 @@ static struct nfs4_client *create_client(struct xdr_netobj name,
 		spin_unlock(&nn->client_lock);
 		return NULL;
 	}
-	idr_init(&clp->cl_stateids);
-	atomic_set(&clp->cl_refcount, 0);
-	clp->cl_cb_state = NFSD4_CB_UNKNOWN;
-	INIT_LIST_HEAD(&clp->cl_idhash);
-	INIT_LIST_HEAD(&clp->cl_openowners);
-	INIT_LIST_HEAD(&clp->cl_delegations);
-	INIT_LIST_HEAD(&clp->cl_lru);
-	INIT_LIST_HEAD(&clp->cl_callbacks);
-	INIT_LIST_HEAD(&clp->cl_revoked);
-	spin_lock_init(&clp->cl_lock);
 	nfsd4_init_callback(&clp->cl_cb_null);
 	clp->cl_time = get_seconds();
 	clear_bit(0, &clp->cl_cb_slot_busy);
-	rpc_init_wait_queue(&clp->cl_cb_waitq, "Backchannel slot table");
 	copy_verf(clp, verf);
 	rpc_copy_addr((struct sockaddr *) &clp->cl_addr, sa);
 	gen_confirm(clp);
-- 
1.9.1

