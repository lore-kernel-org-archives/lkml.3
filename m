Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509AbaICWGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:06:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933399AbaICWGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:06:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.10 52/55] svcrdma: Select NFSv4.1 backchannel transport based on forward channel
Date: Wed,  3 Sep 2014 15:05:42 -0700
Message-Id: <20140903220502.240543853@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220453.653576908@linuxfoundation.org>
References: <20140903220453.653576908@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4callback.c                   |    3 ++-
 include/linux/sunrpc/svc_xprt.h          |    1 +
 net/sunrpc/svcsock.c                     |    2 ++
 net/sunrpc/xprt.c                        |    2 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    1 +
 5 files changed, 7 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -672,7 +672,8 @@ static int setup_callback_client(struct
 		clp->cl_cb_session = ses;
 		args.bc_xprt = conn->cb_xprt;
 		args.prognumber = clp->cl_cb_session->se_cb_prog;
-		args.protocol = XPRT_TRANSPORT_BC_TCP;
+		args.protocol = conn->cb_xprt->xpt_class->xcl_ident |
+				XPRT_TRANSPORT_BC;
 		args.authflavor = ses->se_cb_sec.flavor;
 	}
 	/* Create RPC client */
--- a/include/linux/sunrpc/svc_xprt.h
+++ b/include/linux/sunrpc/svc_xprt.h
@@ -32,6 +32,7 @@ struct svc_xprt_class {
 	struct svc_xprt_ops	*xcl_ops;
 	struct list_head	xcl_list;
 	u32			xcl_max_payload;
+	int			xcl_ident;
 };
 
 /*
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -683,6 +683,7 @@ static struct svc_xprt_class svc_udp_cla
 	.xcl_owner = THIS_MODULE,
 	.xcl_ops = &svc_udp_ops,
 	.xcl_max_payload = RPCSVC_MAXPAYLOAD_UDP,
+	.xcl_ident = XPRT_TRANSPORT_UDP,
 };
 
 static void svc_udp_init(struct svc_sock *svsk, struct svc_serv *serv)
@@ -1275,6 +1276,7 @@ static struct svc_xprt_class svc_tcp_cla
 	.xcl_owner = THIS_MODULE,
 	.xcl_ops = &svc_tcp_ops,
 	.xcl_max_payload = RPCSVC_MAXPAYLOAD_TCP,
+	.xcl_ident = XPRT_TRANSPORT_TCP,
 };
 
 void svc_init_xprt_sock(void)
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1290,7 +1290,7 @@ struct rpc_xprt *xprt_create_transport(s
 		}
 	}
 	spin_unlock(&xprt_list_lock);
-	printk(KERN_ERR "RPC: transport (%d) not supported\n", args->ident);
+	dprintk("RPC: transport (%d) not supported\n", args->ident);
 	return ERR_PTR(-EIO);
 
 found:
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -89,6 +89,7 @@ struct svc_xprt_class svc_rdma_class = {
 	.xcl_owner = THIS_MODULE,
 	.xcl_ops = &svc_rdma_ops,
 	.xcl_max_payload = RPCSVC_MAXPAYLOAD_TCP,
+	.xcl_ident = XPRT_TRANSPORT_RDMA,
 };
 
 struct svc_rdma_op_ctxt *svc_rdma_get_context(struct svcxprt_rdma *xprt)


