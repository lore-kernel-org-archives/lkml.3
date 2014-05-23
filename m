Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaEWMwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:52:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbaEWMwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:52:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 4/4] AFS: Pass an afs_call* to call->async_workfn() instead
 of a work_struct*
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>, dhowells@redhat.com,
        Nathaniel Wesley Filardo <nwf@cs.jhu.edu>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 23 May 2014 13:52:29 +0100
Message-ID: <20140523125229.25385.25445.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140523125200.25385.8586.stgit@warthog.procyon.org.uk>
References: <20140523125200.25385.8586.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call->async_workfn() can take an afs_call* arg rather than a work_struct* as
the functions assigned there are now called from afs_async_workfn() which has
to call container_of() anyway.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Nathaniel Wesley Filardo <nwf@cs.jhu.edu>
Reviewed-by: Tejun Heo <tj@kernel.org>
---

 fs/afs/internal.h |    2 +-
 fs/afs/rxrpc.c    |   14 ++++----------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index be75b500005d..590b55f46d61 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -75,7 +75,7 @@ struct afs_call {
 	const struct afs_call_type *type;	/* type of call */
 	const struct afs_wait_mode *wait_mode;	/* completion wait mode */
 	wait_queue_head_t	waitq;		/* processes awaiting completion */
-	work_func_t		async_workfn;
+	void (*async_workfn)(struct afs_call *call); /* asynchronous work function */
 	struct work_struct	async_work;	/* asynchronous work processor */
 	struct work_struct	work;		/* actual work processor */
 	struct sk_buff_head	rx_queue;	/* received packets */
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 5a05014ea7b0..03a3beb17004 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -25,7 +25,7 @@ static void afs_wake_up_call_waiter(struct afs_call *);
 static int afs_wait_for_call_to_complete(struct afs_call *);
 static void afs_wake_up_async_call(struct afs_call *);
 static int afs_dont_wait_for_call_to_complete(struct afs_call *);
-static void afs_process_async_call(struct work_struct *);
+static void afs_process_async_call(struct afs_call *);
 static void afs_rx_interceptor(struct sock *, unsigned long, struct sk_buff *);
 static int afs_deliver_cm_op_id(struct afs_call *, struct sk_buff *, bool);
 
@@ -62,7 +62,7 @@ static void afs_async_workfn(struct work_struct *work)
 {
 	struct afs_call *call = container_of(work, struct afs_call, async_work);
 
-	call->async_workfn(work);
+	call->async_workfn(call);
 }
 
 /*
@@ -623,11 +623,8 @@ static int afs_dont_wait_for_call_to_complete(struct afs_call *call)
 /*
  * delete an asynchronous call
  */
-static void afs_delete_async_call(struct work_struct *work)
+static void afs_delete_async_call(struct afs_call *call)
 {
-	struct afs_call *call =
-		container_of(work, struct afs_call, async_work);
-
 	_enter("");
 
 	afs_free_call(call);
@@ -640,11 +637,8 @@ static void afs_delete_async_call(struct work_struct *work)
  * - on a multiple-thread workqueue this work item may try to run on several
  *   CPUs at the same time
  */
-static void afs_process_async_call(struct work_struct *work)
+static void afs_process_async_call(struct afs_call *call)
 {
-	struct afs_call *call =
-		container_of(work, struct afs_call, async_work);
-
 	_enter("");
 
 	if (!skb_queue_empty(&call->rx_queue))

