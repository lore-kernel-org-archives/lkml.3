Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab3FDRGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:06:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48568 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758488Ab3FDRDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:03:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 37/75] SUNRPC: Prevent an rpc_task wakeup race
Date: Tue,  4 Jun 2013 09:55:21 -0700
Message-Id: <1370364959-9475-38-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit a3c3cac5d31879cd9ae2de7874dc6544ca704aec upstream.

The lockless RPC_IS_QUEUED() test in __rpc_execute means that we need to
be careful about ordering the calls to rpc_test_and_set_running(task) and
rpc_clear_queued(task). If we get the order wrong, then we may end up
testing the RPC_TASK_RUNNING flag after __rpc_execute() has looped
and changed the state of the rpc_task.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sunrpc/sched.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index f8529fc..5356b12 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -324,11 +324,17 @@ EXPORT_SYMBOL_GPL(__rpc_wait_for_completion_task);
  * Note: If the task is ASYNC, and is being made runnable after sitting on an
  * rpc_wait_queue, this must be called with the queue spinlock held to protect
  * the wait queue operation.
+ * Note the ordering of rpc_test_and_set_running() and rpc_clear_queued(),
+ * which is needed to ensure that __rpc_execute() doesn't loop (due to the
+ * lockless RPC_IS_QUEUED() test) before we've had a chance to test
+ * the RPC_TASK_RUNNING flag.
  */
 static void rpc_make_runnable(struct rpc_task *task)
 {
+	bool need_wakeup = !rpc_test_and_set_running(task);
+
 	rpc_clear_queued(task);
-	if (rpc_test_and_set_running(task))
+	if (!need_wakeup)
 		return;
 	if (RPC_IS_ASYNC(task)) {
 		INIT_WORK(&task->u.tk_work, rpc_async_schedule);
-- 
1.8.1.2

