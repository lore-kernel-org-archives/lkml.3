Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab3AMRrY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:47:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35156 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755666Ab3AMRpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:49 -0500
Message-Id: <20130113174301.254522617@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:21 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Weston Andros Adamson <dros@netapp.com>, Tejun Heo <tj@kernel.org>,
        Bruce Fields <bfields@fieldses.org>
Subject: [ 26/49] SUNRPC: Ensure that we free the rpc_task after cleanups are done
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/sched.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index d17a704..b4133bd 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -934,16 +934,35 @@ struct rpc_task *rpc_new_task(const struct rpc_task_setup *setup_data)
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


