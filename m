Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaEWMws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:52:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbaEWMwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:52:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 3/4] AFS: Fix kafs module unloading
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>, dhowells@redhat.com,
        Nathaniel Wesley Filardo <nwf@cs.jhu.edu>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 23 May 2014 13:52:22 +0100
Message-ID: <20140523125222.25385.35821.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140523125200.25385.8586.stgit@warthog.procyon.org.uk>
References: <20140523125200.25385.8586.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathaniel Wesley Filardo <nwf@cs.jhu.edu>

At present, it is not possible to successfully unload the kafs module if there
are outstanding async outgoing calls (those made with afs_make_call()).  This
appears to be due to the changes introduced by:

	commit 059499453a9abd1857d442b44da8b4c126dc72a8
	Author: Tejun Heo <tj@kernel.org>
	Date:   Fri Mar 7 10:24:50 2014 -0500
	Subject: afs: don't use PREPARE_WORK

which didn't go far enough.  The problem is due to:

 (1) The aforementioned commit introduced a separate handler function pointer
     in the call, call->async_workfn, in addition to the original workqueue
     item, call->async_work, for asynchronous operations because workqueues
     subsystem cannot handle the workqueue item pointer being changed whilst
     the item is queued or being processed.

 (2) afs_async_workfn() was introduced in that commit to be the callback for
     call->async_work.  Its sole purpose is to run whatever call->async_workfn
     points to.

 (3) call->async_workfn is only used from afs_async_workfn(), which is only
     set on async_work by afs_collect_incoming_call() - ie. for incoming
     calls.

 (4) call->async_workfn is *not* set by afs_make_call() when outgoing calls are
     made, and call->async_work is set afs_process_async_call() - and not
     afs_async_workfn().

 (5) afs_process_async_call() now changes call->async_workfn rather than
     call->async_work to point to afs_delete_async_call() to clean up, but this
     is only effective for incoming calls because call->async_work does not
     point to afs_async_workfn() for outgoing calls.

 (6) Because, for incoming calls, call->async_work remains pointing to
     afs_process_async_call() this results in an infinite loop.

Instead, make the workqueue uniformly vector through call->async_workfn, via
afs_async_workfn() and simply initialise call->async_workfn to point to
afs_process_async_call() in afs_make_call().

Signed-off-by: Nathaniel Wesley Filardo <nwf@cs.jhu.edu>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
---

 fs/afs/rxrpc.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 1a1110b1a7ff..5a05014ea7b0 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -58,6 +58,13 @@ static void afs_collect_incoming_call(struct work_struct *);
 static struct sk_buff_head afs_incoming_calls;
 static DECLARE_WORK(afs_collect_incoming_call_work, afs_collect_incoming_call);
 
+static void afs_async_workfn(struct work_struct *work)
+{
+	struct afs_call *call = container_of(work, struct afs_call, async_work);
+
+	call->async_workfn(work);
+}
+
 /*
  * open an RxRPC socket and bind it to be a server for callback notifications
  * - the socket is left in blocking mode and non-blocking ops use MSG_DONTWAIT
@@ -348,7 +355,8 @@ int afs_make_call(struct in_addr *addr, struct afs_call *call, gfp_t gfp,
 	       atomic_read(&afs_outstanding_calls));
 
 	call->wait_mode = wait_mode;
-	INIT_WORK(&call->async_work, afs_process_async_call);
+	call->async_workfn = afs_process_async_call;
+	INIT_WORK(&call->async_work, afs_async_workfn);
 
 	memset(&srx, 0, sizeof(srx));
 	srx.srx_family = AF_RXRPC;
@@ -672,13 +680,6 @@ void afs_transfer_reply(struct afs_call *call, struct sk_buff *skb)
 	call->reply_size += len;
 }
 
-static void afs_async_workfn(struct work_struct *work)
-{
-	struct afs_call *call = container_of(work, struct afs_call, async_work);
-
-	call->async_workfn(work);
-}
-
 /*
  * accept the backlog of incoming calls
  */

