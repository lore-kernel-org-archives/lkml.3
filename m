Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934908AbaKLDMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:12:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933960AbaKLBh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:37:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Coddington <bcodding@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.14 015/203] SUNRPC: Dont wake tasks during connection abort
Date: Wed, 12 Nov 2014 10:14:45 +0900
Message-Id: <20141112011543.406467927@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

commit a743419f420a64d442280845c0377a915b76644f upstream.

When aborting a connection to preserve source ports, don't wake the task in
xs_error_report.  This allows tasks with RPC_TASK_SOFTCONN to succeed if the
connection needs to be re-established since it preserves the task's status
instead of setting it to the status of the aborting kernel_connect().

This may also avoid a potential conflict on the socket's lock.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/sunrpc/xprt.h |    1 +
 net/sunrpc/xprtsock.c       |    4 ++++
 2 files changed, 5 insertions(+)

--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -340,6 +340,7 @@ int			xs_swapper(struct rpc_xprt *xprt,
 #define XPRT_CONNECTION_ABORT	(7)
 #define XPRT_CONNECTION_CLOSE	(8)
 #define XPRT_CONGESTED		(9)
+#define XPRT_CONNECTION_REUSE	(10)
 
 static inline void xprt_set_connected(struct rpc_xprt *xprt)
 {
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -842,6 +842,8 @@ static void xs_error_report(struct sock
 	dprintk("RPC:       xs_error_report client %p, error=%d...\n",
 			xprt, -err);
 	trace_rpc_socket_error(xprt, sk->sk_socket, err);
+	if (test_bit(XPRT_CONNECTION_REUSE, &xprt->state))
+		goto out;
 	xprt_wake_pending_tasks(xprt, err);
  out:
 	read_unlock_bh(&sk->sk_callback_lock);
@@ -2251,7 +2253,9 @@ static void xs_tcp_setup_socket(struct w
 		abort_and_exit = test_and_clear_bit(XPRT_CONNECTION_ABORT,
 				&xprt->state);
 		/* "close" the socket, preserving the local port */
+		set_bit(XPRT_CONNECTION_REUSE, &xprt->state);
 		xs_tcp_reuse_connection(transport);
+		clear_bit(XPRT_CONNECTION_REUSE, &xprt->state);
 
 		if (abort_and_exit)
 			goto out_eagain;


