Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047Ab3APQLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:11:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36906 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034Ab3APQK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:10:58 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Weston Andros Adamson <dros@netapp.com>, Tejun Heo <tj@kernel.org>,
        Bruce Fields <bfields@fieldses.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 207/222] SUNRPC: Ensure that we free the rpc_task after cleanups are done
Date: Wed, 16 Jan 2013 13:56:47 -0200
Message-Id: <1358351822-7675-208-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit c6567ed1402c55e19b012e66a8398baec2a726f3 upstream.

This patch ensures that we free the rpc_task after the cleanup callbacks
are done in order to avoid a deadlock problem that can be triggered if
the callback needs to wait for another workqueue item to complete.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Weston Andros Adamson <dros@netapp.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Bruce Fields <bfields@fieldses.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/sunrpc/sched.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index eda32ae..fe2cf2f 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -915,16 +915,35 @@ struct rpc_task *rpc_new_task(const struct rpc_task_setup *setup_data)
 	return task;
 }
 
+/*
+ * rpc_free_task - release rpc task and perform cleanups
+ *
+ * Note that we free up the rpc_task _after_ rpc_release_calldata()
+ * in order to work around a workqueue dependency issue.
+ *
+ * Tejun Heo states:
+ * "Workqueue currently considers two work items to be the same if they're
+ * on the same address and won't execute them concurrently - ie. it
+ * makes a work item which is queued again while being executed wait
+ * for the previous execution to complete.
+ *
+ * If a work function frees the work item, and then waits for an event
+ * which should be performed by another work item and *that* work item
+ * recycles the freed work item, it can create a false dependency loop.
+ * There really is no reliable way to detect this short of verifying
+ * every memory free."
+ *
+ */
 static void rpc_free_task(struct rpc_task *task)
 {
-	const struct rpc_call_ops *tk_ops = task->tk_ops;
-	void *calldata = task->tk_calldata;
+	unsigned short tk_flags = task->tk_flags;
+
+	rpc_release_calldata(task->tk_ops, task->tk_calldata);
 
-	if (task->tk_flags & RPC_TASK_DYNAMIC) {
+	if (tk_flags & RPC_TASK_DYNAMIC) {
 		dprintk("RPC: %5u freeing task\n", task->tk_pid);
 		mempool_free(task, rpc_task_mempool);
 	}
-	rpc_release_calldata(tk_ops, calldata);
 }
 
 static void rpc_async_release(struct work_struct *work)
-- 
1.7.9.5

