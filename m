Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625AbaFII6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:58:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58538 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932197AbaFIIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 097/146] NFSd: Move default initialisers from create_client() to alloc_client()
Date: Mon,  9 Jun 2014 10:50:32 +0200
Message-Id: <3adce04c026b56960f37b07463319aee631523df.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <trond.myklebust@primarydata.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5694c93e6c4954fa9424c215f75eeb919bddad64 upstream.

Aside from making it clearer what is non-trivial in create_client(), it
also fixes a bug whereby we can call free_client() before idr_init()
has been called.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfsd/nfs4state.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 5cbdf38ffc66..7a32d576ed7e 100644
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
1.9.3

