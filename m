Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaBTUqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:46:44 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:45926 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbaBTUos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:44:48 -0500
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org
Subject: [PATCH 7/9] afs: don't use PREPARE_WORK
Date: Thu, 20 Feb 2014 15:44:29 -0500
Message-Id: <1392929071-16555-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392929071-16555-1-git-send-email-tj@kernel.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
and a nasty surprise in terms of reentrancy guarantee as workqueue
considers work items to be different if they don't have the same work
function.

afs_call->async_work is multiplexed with multiple work functions.
Introduce afs_async_workfn() which invokes afs_call->async_workfn and
always use it as the work function and update the users to set the
->async_workfn field instead of overriding the work function using
PREPARE_WORK().

It would probably be best to route this with other related updates
through the workqueue tree.

Compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org
---
 fs/afs/internal.h |  1 +
 fs/afs/rxrpc.c    | 12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 6621f80..be75b50 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -75,6 +75,7 @@ struct afs_call {
 	const struct afs_call_type *type;	/* type of call */
 	const struct afs_wait_mode *wait_mode;	/* completion wait mode */
 	wait_queue_head_t	waitq;		/* processes awaiting completion */
+	work_func_t		async_workfn;
 	struct work_struct	async_work;	/* asynchronous work processor */
 	struct work_struct	work;		/* actual work processor */
 	struct sk_buff_head	rx_queue;	/* received packets */
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 8ad8c2a..ef943df 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -644,7 +644,7 @@ static void afs_process_async_call(struct work_struct *work)
 
 		/* we can't just delete the call because the work item may be
 		 * queued */
-		PREPARE_WORK(&call->async_work, afs_delete_async_call);
+		call->async_workfn = afs_delete_async_call;
 		queue_work(afs_async_calls, &call->async_work);
 	}
 
@@ -663,6 +663,13 @@ void afs_transfer_reply(struct afs_call *call, struct sk_buff *skb)
 	call->reply_size += len;
 }
 
+static void afs_async_workfn(struct work_struct *work)
+{
+	struct afs_call *call = container_of(work, struct afs_call, async_work);
+
+	call->async_workfn(work);
+}
+
 /*
  * accept the backlog of incoming calls
  */
@@ -685,7 +692,8 @@ static void afs_collect_incoming_call(struct work_struct *work)
 				return;
 			}
 
-			INIT_WORK(&call->async_work, afs_process_async_call);
+			call->async_workfn = afs_process_async_call;
+			INIT_WORK(&call->async_work, afs_async_workfn);
 			call->wait_mode = &afs_async_incoming_call;
 			call->type = &afs_RXCMxxxx;
 			init_waitqueue_head(&call->waitq);
-- 
1.8.5.3

