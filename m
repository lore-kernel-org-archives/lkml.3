Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab3GCSus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:50:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15217 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933250Ab3GCSlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:01 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=nSEXAIb_QpwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=EI9h0IqilWcA:10 a=JDjsHSkAAAAA:8 a=VwQbUJbxAAAA:8 a=J1Y8HTJGAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=Hf6muOzgCGQA:10 a=jeBq3FmKZ4MA:10 a=4N9Db7Z2_RYA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184050.248057578@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [034/141] SUNRPC: Prevent an rpc_task wakeup race
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0034-SUNRPC-Prevent-an-rpc_task-wakeup-race.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

[ Upstream commit a3c3cac5d31879cd9ae2de7874dc6544ca704aec ]

The lockless RPC_IS_QUEUED() test in __rpc_execute means that we need to
be careful about ordering the calls to rpc_test_and_set_running(task) and
rpc_clear_queued(task). If we get the order wrong, then we may end up
testing the RPC_TASK_RUNNING flag after __rpc_execute() has looped
and changed the state of the rpc_task.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/sunrpc/sched.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index cd09810..0e09708 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -305,11 +305,17 @@ EXPORT_SYMBOL_GPL(__rpc_wait_for_completion_task);
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
1.7.10.4


