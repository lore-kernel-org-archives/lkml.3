Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab3LERhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:37:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38172 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932985Ab3LERhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 29/90] SUNRPC: Avoid deep recursion in rpc_release_client
Date: Thu,  5 Dec 2013 17:35:11 +0000
Message-Id: <1386264972-5399-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sunrpc/clnt.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 6b0dd20..3321e09 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -599,14 +599,16 @@ EXPORT_SYMBOL_GPL(rpc_shutdown_client);
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
 	rpc_unregister_client(clnt);
 	rpc_clnt_remove_pipedir(clnt);
 	rpc_free_iostats(clnt->cl_metrics);
@@ -615,18 +617,17 @@ rpc_free_client(struct rpc_clnt *clnt)
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
@@ -637,7 +638,8 @@ rpc_free_auth(struct rpc_clnt *clnt)
 	rpcauth_release(clnt->cl_auth);
 	clnt->cl_auth = NULL;
 	if (atomic_dec_and_test(&clnt->cl_count))
-		rpc_free_client(clnt);
+		return rpc_free_client(clnt);
+	return NULL;
 }
 
 /*
@@ -648,10 +650,13 @@ rpc_release_client(struct rpc_clnt *clnt)
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

