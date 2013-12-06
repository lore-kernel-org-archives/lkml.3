Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150Ab3LFX1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:27:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48996 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162436Ab3LFXUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:44 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 099/152] SUNRPC: Avoid deep recursion in rpc_release_client
Date: Fri,  6 Dec 2013 15:10:23 -0800
Message-Id: <1386371476-2477-100-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit d07ba8422f1e58be94cc98a1f475946dc1b89f1b upstream.

In cases where an rpc client has a parent hierarchy, then
rpc_free_client may end up calling rpc_release_client() on the
parent, thus recursing back into rpc_free_client. If the hierarchy
is deep enough, then we can get into situations where the stack
simply overflows.

The fix is to have rpc_release_client() loop so that it can take
care of the parent rpc client hierarchy without needing to
recurse.

Reported-by: Jeff Layton <jlayton@redhat.com>
Reported-by: Weston Andros Adamson <dros@netapp.com>
Reported-by: Bruce Fields <bfields@fieldses.org>
Link: http://lkml.kernel.org/r/2C73011F-0939-434C-9E4D-13A1EB1403D7@netapp.com
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sunrpc/clnt.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 1a3bd4d..d8b6ad9 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -624,14 +624,16 @@ EXPORT_SYMBOL_GPL(rpc_shutdown_client);
 /*
  * Free an RPC client
  */
-static void
+static struct rpc_clnt *
 rpc_free_client(struct rpc_clnt *clnt)
 {
+	struct rpc_clnt *parent = NULL;
+
 	dprintk_rcu("RPC:       destroying %s client for %s\n",
 			clnt->cl_protname,
 			rcu_dereference(clnt->cl_xprt)->servername);
 	if (clnt->cl_parent != clnt)
-		rpc_release_client(clnt->cl_parent);
+		parent = clnt->cl_parent;
 	rpc_clnt_remove_pipedir(clnt);
 	rpc_unregister_client(clnt);
 	rpc_free_iostats(clnt->cl_metrics);
@@ -640,18 +642,17 @@ rpc_free_client(struct rpc_clnt *clnt)
 	xprt_put(rcu_dereference_raw(clnt->cl_xprt));
 	rpciod_down();
 	kfree(clnt);
+	return parent;
 }
 
 /*
  * Free an RPC client
  */
-static void
+static struct rpc_clnt * 
 rpc_free_auth(struct rpc_clnt *clnt)
 {
-	if (clnt->cl_auth == NULL) {
-		rpc_free_client(clnt);
-		return;
-	}
+	if (clnt->cl_auth == NULL)
+		return rpc_free_client(clnt);
 
 	/*
 	 * Note: RPCSEC_GSS may need to send NULL RPC calls in order to
@@ -662,7 +663,8 @@ rpc_free_auth(struct rpc_clnt *clnt)
 	rpcauth_release(clnt->cl_auth);
 	clnt->cl_auth = NULL;
 	if (atomic_dec_and_test(&clnt->cl_count))
-		rpc_free_client(clnt);
+		return rpc_free_client(clnt);
+	return NULL;
 }
 
 /*
@@ -673,10 +675,13 @@ rpc_release_client(struct rpc_clnt *clnt)
 {
 	dprintk("RPC:       rpc_release_client(%p)\n", clnt);
 
-	if (list_empty(&clnt->cl_tasks))
-		wake_up(&destroy_wait);
-	if (atomic_dec_and_test(&clnt->cl_count))
-		rpc_free_auth(clnt);
+	do {
+		if (list_empty(&clnt->cl_tasks))
+			wake_up(&destroy_wait);
+		if (!atomic_dec_and_test(&clnt->cl_count))
+			break;
+		clnt = rpc_free_auth(clnt);
+	} while (clnt != NULL);
 }
 
 /**
-- 
1.8.3.2

