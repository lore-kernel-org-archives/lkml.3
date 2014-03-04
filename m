Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbaCDVDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:03:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630AbaCDUD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        John <da_audiophile@yahoo.com>, Borislav Petkov <bp@alien8.de>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.13 098/172] SUNRPC: Ensure that gss_auth isnt freed before its upcall messages
Date: Tue,  4 Mar 2014 12:03:02 -0800
Message-Id: <20140304200302.846910842@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 9eb2ddb48ce3a7bd745c14a933112994647fa3cd upstream.

Fix a race in which the RPC client is shutting down while the
gss daemon is processing a downcall. If the RPC client manages to
shut down before the gss daemon is done, then the struct gss_auth
used in gss_release_msg() may have already been freed.

Link: http://lkml.kernel.org/r/1392494917.71728.YahooMailNeo@web140002.mail.bf1.yahoo.com
Reported-by: John <da_audiophile@yahoo.com>
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/auth_gss/auth_gss.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -108,6 +108,7 @@ struct gss_auth {
 static DEFINE_SPINLOCK(pipe_version_lock);
 static struct rpc_wait_queue pipe_version_rpc_waitqueue;
 static DECLARE_WAIT_QUEUE_HEAD(pipe_version_waitqueue);
+static void gss_put_auth(struct gss_auth *gss_auth);
 
 static void gss_free_ctx(struct gss_cl_ctx *);
 static const struct rpc_pipe_ops gss_upcall_ops_v0;
@@ -320,6 +321,7 @@ gss_release_msg(struct gss_upcall_msg *g
 	if (gss_msg->ctx != NULL)
 		gss_put_ctx(gss_msg->ctx);
 	rpc_destroy_wait_queue(&gss_msg->rpc_waitqueue);
+	gss_put_auth(gss_msg->auth);
 	kfree(gss_msg);
 }
 
@@ -500,6 +502,7 @@ gss_alloc_msg(struct gss_auth *gss_auth,
 		if (err)
 			goto err_free_msg;
 	};
+	kref_get(&gss_auth->kref);
 	return gss_msg;
 err_free_msg:
 	kfree(gss_msg);
@@ -1071,6 +1074,12 @@ gss_free_callback(struct kref *kref)
 }
 
 static void
+gss_put_auth(struct gss_auth *gss_auth)
+{
+	kref_put(&gss_auth->kref, gss_free_callback);
+}
+
+static void
 gss_destroy(struct rpc_auth *auth)
 {
 	struct gss_auth *gss_auth = container_of(auth,
@@ -1091,7 +1100,7 @@ gss_destroy(struct rpc_auth *auth)
 	gss_auth->gss_pipe[1] = NULL;
 	rpcauth_destroy_credcache(auth);
 
-	kref_put(&gss_auth->kref, gss_free_callback);
+	gss_put_auth(gss_auth);
 }
 
 /*
@@ -1262,7 +1271,7 @@ gss_destroy_nullcred(struct rpc_cred *cr
 	call_rcu(&cred->cr_rcu, gss_free_cred_callback);
 	if (ctx)
 		gss_put_ctx(ctx);
-	kref_put(&gss_auth->kref, gss_free_callback);
+	gss_put_auth(gss_auth);
 }
 
 static void


