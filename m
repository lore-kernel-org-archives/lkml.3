Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbaFEAPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:15:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaFDXWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.14 148/228] NFSd: Move default initialisers from create_client() to alloc_client()
Date: Wed,  4 Jun 2014 16:22:57 -0700
Message-Id: <20140604232352.771540501@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 5694c93e6c4954fa9424c215f75eeb919bddad64 upstream.

Aside from making it clearer what is non-trivial in create_client(), it
also fixes a bug whereby we can call free_client() before idr_init()
has been called.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1078,6 +1078,18 @@ static struct nfs4_client *alloc_client(
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
 
@@ -1347,7 +1359,6 @@ static struct nfs4_client *create_client
 	if (clp == NULL)
 		return NULL;
 
-	INIT_LIST_HEAD(&clp->cl_sessions);
 	ret = copy_cred(&clp->cl_cred, &rqstp->rq_cred);
 	if (ret) {
 		spin_lock(&nn->client_lock);
@@ -1355,20 +1366,9 @@ static struct nfs4_client *create_client
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


