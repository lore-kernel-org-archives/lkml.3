Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaEWMzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:55:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbaEWMwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:52:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 1/4] AFS: Fix cache manager service handlers
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, linux-afs@lists.infradead.org,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Date: Fri, 23 May 2014 13:52:07 +0100
Message-ID: <20140523125207.25385.21747.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140523125200.25385.8586.stgit@warthog.procyon.org.uk>
References: <20140523125200.25385.8586.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the cache manager RPC service handlers.  The afs_send_empty_reply() and
afs_send_simple_reply() functions:

 (a) Kill the call and free up the buffers associated with it if they fail.

 (b) Return with call intact if it they succeed.

However, none of the callers actually check the result or clean up if
successful - and may use the now non-existent data if it fails.

This was detected by Dan Carpenter using a static checker:

	The patch 08e0e7c82eea: "[AF_RXRPC]: Make the in-kernel AFS
	filesystem use AF_RXRPC." from Apr 26, 2007, leads to the following
	static checker warning:
	"fs/afs/cmservice.c:155 SRXAFSCB_CallBack()
		 warn: 'call' was already freed."

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/cmservice.c |   19 +++++++++++++++++++
 fs/afs/rxrpc.c     |   43 +++++++++++++++++++++----------------------
 2 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/fs/afs/cmservice.c b/fs/afs/cmservice.c
index 1c8c6cc6de30..4b0eff6da674 100644
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -130,6 +130,15 @@ static void afs_cm_destructor(struct afs_call *call)
 {
 	_enter("");
 
+	/* Break the callbacks here so that we do it after the final ACK is
+	 * received.  The step number here must match the final number in
+	 * afs_deliver_cb_callback().
+	 */
+	if (call->unmarshall == 6) {
+		ASSERT(call->server && call->count && call->request);
+		afs_break_callbacks(call->server, call->count, call->request);
+	}
+
 	afs_put_server(call->server);
 	call->server = NULL;
 	kfree(call->buffer);
@@ -272,6 +281,16 @@ static int afs_deliver_cb_callback(struct afs_call *call, struct sk_buff *skb,
 		_debug("trailer");
 		if (skb->len != 0)
 			return -EBADMSG;
+
+		/* Record that the message was unmarshalled successfully so
+		 * that the call destructor can know do the callback breaking
+		 * work, even if the final ACK isn't received.
+		 *
+		 * If the step number changes, then afs_cm_destructor() must be
+		 * updated also.
+		 */
+		call->unmarshall++;
+	case 6:
 		break;
 	}
 
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index ef943df73b8c..9226a6674d7f 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -184,6 +184,19 @@ static void afs_free_call(struct afs_call *call)
 }
 
 /*
+ * End a call
+ */
+static void afs_end_call(struct afs_call *call)
+{
+	if (call->rxcall) {
+		rxrpc_kernel_end_call(call->rxcall);
+		call->rxcall = NULL;
+	}
+	call->type->destructor(call);
+	afs_free_call(call);
+}
+
+/*
  * allocate a call with flat request and reply buffers
  */
 struct afs_call *afs_alloc_flat_call(const struct afs_call_type *type,
@@ -383,11 +396,8 @@ error_do_abort:
 	rxrpc_kernel_abort_call(rxcall, RX_USER_ABORT);
 	while ((skb = skb_dequeue(&call->rx_queue)))
 		afs_free_skb(skb);
-	rxrpc_kernel_end_call(rxcall);
-	call->rxcall = NULL;
 error_kill_call:
-	call->type->destructor(call);
-	afs_free_call(call);
+	afs_end_call(call);
 	_leave(" = %d", ret);
 	return ret;
 }
@@ -509,12 +519,8 @@ static void afs_deliver_to_call(struct afs_call *call)
 	if (call->state >= AFS_CALL_COMPLETE) {
 		while ((skb = skb_dequeue(&call->rx_queue)))
 			afs_free_skb(skb);
-		if (call->incoming) {
-			rxrpc_kernel_end_call(call->rxcall);
-			call->rxcall = NULL;
-			call->type->destructor(call);
-			afs_free_call(call);
-		}
+		if (call->incoming)
+			afs_end_call(call);
 	}
 
 	_leave("");
@@ -564,10 +570,7 @@ static int afs_wait_for_call_to_complete(struct afs_call *call)
 	}
 
 	_debug("call complete");
-	rxrpc_kernel_end_call(call->rxcall);
-	call->rxcall = NULL;
-	call->type->destructor(call);
-	afs_free_call(call);
+	afs_end_call(call);
 	_leave(" = %d", ret);
 	return ret;
 }
@@ -790,10 +793,7 @@ void afs_send_empty_reply(struct afs_call *call)
 		_debug("oom");
 		rxrpc_kernel_abort_call(call->rxcall, RX_USER_ABORT);
 	default:
-		rxrpc_kernel_end_call(call->rxcall);
-		call->rxcall = NULL;
-		call->type->destructor(call);
-		afs_free_call(call);
+		afs_end_call(call);
 		_leave(" [error]");
 		return;
 	}
@@ -823,17 +823,16 @@ void afs_send_simple_reply(struct afs_call *call, const void *buf, size_t len)
 	call->state = AFS_CALL_AWAIT_ACK;
 	n = rxrpc_kernel_send_data(call->rxcall, &msg, len);
 	if (n >= 0) {
+		/* Success */
 		_leave(" [replied]");
 		return;
 	}
+
 	if (n == -ENOMEM) {
 		_debug("oom");
 		rxrpc_kernel_abort_call(call->rxcall, RX_USER_ABORT);
 	}
-	rxrpc_kernel_end_call(call->rxcall);
-	call->rxcall = NULL;
-	call->type->destructor(call);
-	afs_free_call(call);
+	afs_end_call(call);
 	_leave(" [error]");
 }
 

