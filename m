Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbaIZKd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:33:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbaIZJp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:45:59 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 028/142] svcrdma: Select NFSv4.1 backchannel transport based on forward channel
Date: Fri, 26 Sep 2014 11:43:59 +0200
Message-Id: <849f67c7e1843fbad81a6e0dbbbb1614acbe9c11.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3c45ddf823d679a820adddd53b52c6699c9a05ac upstream.

The current code always selects XPRT_TRANSPORT_BC_TCP for the back
channel, even when the forward channel was not TCP (eg, RDMA). When
a 4.1 mount is attempted with RDMA, the server panics in the TCP BC
code when trying to send CB_NULL.

Instead, construct the transport protocol number from the forward
channel transport or'd with XPRT_TRANSPORT_BC. Transports that do
not support bi-directional RPC will not have registered a "BC"
transport, causing create_backchannel_client() to fail immediately.

Fixes: https://bugzilla.linux-nfs.org/show_bug.cgi?id=265
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfsd/nfs4callback.c                   | 3 ++-
 include/linux/sunrpc/svc_xprt.h          | 1 +
 net/sunrpc/svcsock.c                     | 2 ++
 net/sunrpc/xprt.c                        | 2 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 1 +
 5 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 3eaa6e30a2dc..cc8c5b32043c 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -672,7 +672,8 @@ static int setup_callback_client(struct nfs4_client *clp, struct nfs4_cb_conn *c
 		clp->cl_cb_session = ses;
 		args.bc_xprt = conn->cb_xprt;
 		args.prognumber = clp->cl_cb_session->se_cb_prog;
-		args.protocol = XPRT_TRANSPORT_BC_TCP;
+		args.protocol = conn->cb_xprt->xpt_class->xcl_ident |
+				XPRT_TRANSPORT_BC;
 		args.authflavor = ses->se_cb_sec.flavor;
 	}
 	/* Create RPC client */
diff --git a/include/linux/sunrpc/svc_xprt.h b/include/linux/sunrpc/svc_xprt.h
index b05963f09ebf..f5bfb1a80abe 100644
--- a/include/linux/sunrpc/svc_xprt.h
+++ b/include/linux/sunrpc/svc_xprt.h
@@ -32,6 +32,7 @@ struct svc_xprt_class {
 	struct svc_xprt_ops	*xcl_ops;
 	struct list_head	xcl_list;
 	u32			xcl_max_payload;
+	int			xcl_ident;
 };
 
 /*
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 6ac0f1c3fc28..8c6e9c75c525 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -683,6 +683,7 @@ static struct svc_xprt_class svc_udp_class = {
 	.xcl_owner = THIS_MODULE,
 	.xcl_ops = &svc_udp_ops,
 	.xcl_max_payload = RPCSVC_MAXPAYLOAD_UDP,
+	.xcl_ident = XPRT_TRANSPORT_UDP,
 };
 
 static void svc_udp_init(struct svc_sock *svsk, struct svc_serv *serv)
@@ -1277,6 +1278,7 @@ static struct svc_xprt_class svc_tcp_class = {
 	.xcl_owner = THIS_MODULE,
 	.xcl_ops = &svc_tcp_ops,
 	.xcl_max_payload = RPCSVC_MAXPAYLOAD_TCP,
+	.xcl_ident = XPRT_TRANSPORT_TCP,
 };
 
 void svc_init_xprt_sock(void)
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 095363eee764..42ce6bfc729d 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1290,7 +1290,7 @@ struct rpc_xprt *xprt_create_transport(struct xprt_create *args)
 		}
 	}
 	spin_unlock(&xprt_list_lock);
-	printk(KERN_ERR "RPC: transport (%d) not supported\n", args->ident);
+	dprintk("RPC: transport (%d) not supported\n", args->ident);
 	return ERR_PTR(-EIO);
 
 found:
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 62e4f9bcc387..ed36cb52cd86 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -89,6 +89,7 @@ struct svc_xprt_class svc_rdma_class = {
 	.xcl_owner = THIS_MODULE,
 	.xcl_ops = &svc_rdma_ops,
 	.xcl_max_payload = RPCSVC_MAXPAYLOAD_TCP,
+	.xcl_ident = XPRT_TRANSPORT_RDMA,
 };
 
 struct svc_rdma_op_ctxt *svc_rdma_get_context(struct svcxprt_rdma *xprt)
-- 
2.1.0

