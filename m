Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaKYKlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:41:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58324 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbaKYKlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Coddington <bcodding@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 071/254] SUNRPC: Don't wake tasks during connection abort
Date: Tue, 25 Nov 2014 10:37:01 +0000
Message-Id: <1416912004-5928-72-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/sunrpc/xprt.h | 1 +
 net/sunrpc/xprtsock.c       | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index fcbfe8783243..cf391eef2e6d 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -357,6 +357,7 @@ int			xs_swapper(struct rpc_xprt *xprt, int enable);
 #define XPRT_CONNECTION_ABORT	(7)
 #define XPRT_CONNECTION_CLOSE	(8)
 #define XPRT_CONGESTED		(9)
+#define XPRT_CONNECTION_REUSE	(10)
 
 static inline void xprt_set_connected(struct rpc_xprt *xprt)
 {
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index be8bbd5d65ec..ab52cefa8f39 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -842,6 +842,8 @@ static void xs_error_report(struct sock *sk)
 	dprintk("RPC:       xs_error_report client %p, error=%d...\n",
 			xprt, -err);
 	trace_rpc_socket_error(xprt, sk->sk_socket, err);
+	if (test_bit(XPRT_CONNECTION_REUSE, &xprt->state))
+		goto out;
 	xprt_wake_pending_tasks(xprt, err);
  out:
 	read_unlock_bh(&sk->sk_callback_lock);
@@ -2241,7 +2243,9 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 		abort_and_exit = test_and_clear_bit(XPRT_CONNECTION_ABORT,
 				&xprt->state);
 		/* "close" the socket, preserving the local port */
+		set_bit(XPRT_CONNECTION_REUSE, &xprt->state);
 		xs_tcp_reuse_connection(transport);
+		clear_bit(XPRT_CONNECTION_REUSE, &xprt->state);
 
 		if (abort_and_exit)
 			goto out_eagain;
-- 
2.1.0

