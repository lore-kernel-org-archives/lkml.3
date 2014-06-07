Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaFGBhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:37:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36024 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752605AbaFGBXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "J. Bruce Fields" <bfields@redhat.com>,
        "Trond Myklebust" <trond.myklebust@primarydata.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.309462673@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 56/92] NFSd: Move default initialisers from
 create_client() to alloc_client()
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 5694c93e6c4954fa9424c215f75eeb919bddad64 upstream.

Aside from making it clearer what is non-trivial in create_client(), it
also fixes a bug whereby we can call free_client() before idr_init()
has been called.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Also move initialisation of nfs4_client::cl_strhash, but
   not nfs4_client::cl_revoked]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4state.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -986,6 +986,18 @@ static struct nfs4_client *alloc_client(
 	}
 	memcpy(clp->cl_name.data, name.data, name.len);
 	clp->cl_name.len = name.len;
+	INIT_LIST_HEAD(&clp->cl_sessions);
+	idr_init(&clp->cl_stateids);
+	atomic_set(&clp->cl_refcount, 0);
+	clp->cl_cb_state = NFSD4_CB_UNKNOWN;
+	INIT_LIST_HEAD(&clp->cl_idhash);
+	INIT_LIST_HEAD(&clp->cl_strhash);
+	INIT_LIST_HEAD(&clp->cl_openowners);
+	INIT_LIST_HEAD(&clp->cl_delegations);
+	INIT_LIST_HEAD(&clp->cl_lru);
+	INIT_LIST_HEAD(&clp->cl_callbacks);
+	spin_lock_init(&clp->cl_lock);
+	rpc_init_wait_queue(&clp->cl_cb_waitq, "Backchannel slot table");
 	return clp;
 }
 
@@ -1163,7 +1175,6 @@ static struct nfs4_client *create_client
 	if (clp == NULL)
 		return NULL;
 
-	INIT_LIST_HEAD(&clp->cl_sessions);
 
 	princ = svc_gss_principal(rqstp);
 	if (princ) {
@@ -1174,21 +1185,10 @@ static struct nfs4_client *create_client
 		}
 	}
 
-	idr_init(&clp->cl_stateids);
 	memcpy(clp->cl_recdir, recdir, HEXDIR_LEN);
-	atomic_set(&clp->cl_refcount, 0);
-	clp->cl_cb_state = NFSD4_CB_UNKNOWN;
-	INIT_LIST_HEAD(&clp->cl_idhash);
-	INIT_LIST_HEAD(&clp->cl_strhash);
-	INIT_LIST_HEAD(&clp->cl_openowners);
-	INIT_LIST_HEAD(&clp->cl_delegations);
-	INIT_LIST_HEAD(&clp->cl_lru);
-	INIT_LIST_HEAD(&clp->cl_callbacks);
-	spin_lock_init(&clp->cl_lock);
 	INIT_WORK(&clp->cl_cb_null.cb_work, nfsd4_do_callback_rpc);
 	clp->cl_time = get_seconds();
 	clear_bit(0, &clp->cl_cb_slot_busy);
-	rpc_init_wait_queue(&clp->cl_cb_waitq, "Backchannel slot table");
 	copy_verf(clp, verf);
 	rpc_copy_addr((struct sockaddr *) &clp->cl_addr, sa);
 	clp->cl_flavor = rqstp->rq_flavor;

