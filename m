Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab3K0BAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:00:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785Ab3K0A7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>,
        Weston Andros Adamson <dros@netapp.com>,
        Bruce Fields <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 3.12 097/116] SUNRPC: Avoid deep recursion in rpc_release_client
Date: Tue, 26 Nov 2013 16:57:50 -0800
Message-Id: <20131127005743.606914626@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/clnt.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -656,14 +656,16 @@ EXPORT_SYMBOL_GPL(rpc_shutdown_client);
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
 			clnt->cl_program->name,
 			rcu_dereference(clnt->cl_xprt)->servername);
 	if (clnt->cl_parent != clnt)
-		rpc_release_client(clnt->cl_parent);
+		parent = clnt->cl_parent;
 	rpc_clnt_remove_pipedir(clnt);
 	rpc_unregister_client(clnt);
 	rpc_free_iostats(clnt->cl_metrics);
@@ -672,18 +674,17 @@ rpc_free_client(struct rpc_clnt *clnt)
 	rpciod_down();
 	rpc_free_clid(clnt);
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
@@ -694,7 +695,8 @@ rpc_free_auth(struct rpc_clnt *clnt)
 	rpcauth_release(clnt->cl_auth);
 	clnt->cl_auth = NULL;
 	if (atomic_dec_and_test(&clnt->cl_count))
-		rpc_free_client(clnt);
+		return rpc_free_client(clnt);
+	return NULL;
 }
 
 /*
@@ -705,10 +707,13 @@ rpc_release_client(struct rpc_clnt *clnt
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
 EXPORT_SYMBOL_GPL(rpc_release_client);
 


