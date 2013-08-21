Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3HUAvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:51:33 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45034 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab3HUAvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:51:25 -0400
From: Libin <huawei.libin@huawei.com>
To: <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <wangyijing@huawei.com>,
        <guohanjun@huawei.com>
Subject: [PATCH v2 3/3] workqueue: Correct/Drop references to gcwq in Documentation
Date: Wed, 21 Aug 2013 08:50:41 +0800
Message-ID: <1377046241-18516-4-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1377046241-18516-1-git-send-email-huawei.libin@huawei.com>
References: <1377046241-18516-1-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes. This patch fixes the post gcwq comments in
Documentation/workqueue.txt.

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 Documentation/workqueue.txt | 72 ++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/Documentation/workqueue.txt b/Documentation/workqueue.txt
index a6ab4b6..5e65b1c 100644
--- a/Documentation/workqueue.txt
+++ b/Documentation/workqueue.txt
@@ -85,16 +85,16 @@ workqueue.
 Special purpose threads, called worker threads, execute the functions
 off of the queue, one after the other.  If no work is queued, the
 worker threads become idle.  These worker threads are managed in so
-called thread-pools.
+called worker-pools.
 
 The cmwq design differentiates between the user-facing workqueues that
 subsystems and drivers queue work items on and the backend mechanism
-which manages thread-pools and processes the queued work items.
+which manages worker-pools and processes the queued work items.
 
-The backend is called gcwq.  There is one gcwq for each possible CPU
-and one gcwq to serve work items queued on unbound workqueues.  Each
-gcwq has two thread-pools - one for normal work items and the other
-for high priority ones.
+There are two worker-pools, one for normal work items and the other
+for high priority ones, for each possible CPU and some extra worker-pools
+to serve work items queued on unbound workqueues - the number of these
+baking pools is dynamic.
 
 Subsystems and drivers can create and queue work items through special
 workqueue API functions as they see fit. They can influence some
@@ -104,13 +104,12 @@ things like CPU locality, reentrancy, concurrency limits, priority and
 more.  To get a detailed overview refer to the API description of
 alloc_workqueue() below.
 
-When a work item is queued to a workqueue, the target gcwq and
-thread-pool is determined according to the queue parameters and
-workqueue attributes and appended on the shared worklist of the
-thread-pool.  For example, unless specifically overridden, a work item
-of a bound workqueue will be queued on the worklist of either normal
-or highpri thread-pool of the gcwq that is associated to the CPU the
-issuer is running on.
+When a work item is queued to a workqueue, the target worker-pool is
+determined according to the queue parameters and workqueue attributes
+and appended on the shared worklist of the worker-pool.  For example,
+unless specifically overridden, a work item of a bound workqueue will
+be queued on the worklist of either normal or highpri worker-pool that
+is associated to the CPU the issuer is running on.
 
 For any worker pool implementation, managing the concurrency level
 (how many execution contexts are active) is an important issue.  cmwq
@@ -118,14 +117,14 @@ tries to keep the concurrency at a minimal but sufficient level.
 Minimal to save resources and sufficient in that the system is used at
 its full capacity.
 
-Each thread-pool bound to an actual CPU implements concurrency
-management by hooking into the scheduler.  The thread-pool is notified
+Each worker-pool bound to an actual CPU implements concurrency
+management by hooking into the scheduler.  The worker-pool is notified
 whenever an active worker wakes up or sleeps and keeps track of the
 number of the currently runnable workers.  Generally, work items are
 not expected to hog a CPU and consume many cycles.  That means
 maintaining just enough concurrency to prevent work processing from
 stalling should be optimal.  As long as there are one or more runnable
-workers on the CPU, the thread-pool doesn't start execution of a new
+workers on the CPU, the worker-pool doesn't start execution of a new
 work, but, when the last running worker goes to sleep, it immediately
 schedules a new worker so that the CPU doesn't sit idle while there
 are pending work items.  This allows using a minimal number of workers
@@ -135,19 +134,20 @@ Keeping idle workers around doesn't cost other than the memory space
 for kthreads, so cmwq holds onto idle ones for a while before killing
 them.
 
-For an unbound wq, the above concurrency management doesn't apply and
-the thread-pools for the pseudo unbound CPU try to start executing all
-work items as soon as possible.  The responsibility of regulating
-concurrency level is on the users.  There is also a flag to mark a
-bound wq to ignore the concurrency management.  Please refer to the
-API section for details.
+For unbound workqueues, the number of backing pools is dynamic.
+Unbound workqueue can be assigned custom attributes using
+apply_workqueue_attrs() and workqueue will automatically create
+backing worker pools matching the attributes. The responsibility of
+regulating concurrency level is on the users.  There is also a flag
+to mark a bound wq to ignore the concurrency management.  Please refer
+to the API section for details.
 
 Forward progress guarantee relies on that workers can be created when
 more execution contexts are necessary, which in turn is guaranteed
 through the use of rescue workers.  All work items which might be used
 on code paths that handle memory reclaim are required to be queued on
 wq's that have a rescue-worker reserved for execution under memory
-pressure.  Else it is possible that the thread-pool deadlocks waiting
+pressure.  Else it is possible that the worker-pool deadlocks waiting
 for execution contexts to free up.
 
 
@@ -178,13 +178,13 @@ resources, scheduled and executed.
 
   WQ_UNBOUND
 
-	Work items queued to an unbound wq are served by a special
-	gcwq which hosts workers which are not bound to any specific
-	CPU.  This makes the wq behave as a simple execution context
-	provider without concurrency management.  The unbound gcwq
-	tries to start execution of work items as soon as possible.
-	Unbound wq sacrifices locality but is useful for the following
-	cases.
+	Work items queued to an unbound wq are served by the special
+	woker-pools which hosts workers which are not bound to any
+	specific CPU.  This makes the wq behave as a simple execution
+	context provider without concurrency management.  The unbound
+	worker-pools tries to start execution of work items as soon as
+	possible.  Unbound wq sacrifices locality but is useful for
+	the following cases.
 
 	* Wide fluctuation in the concurrency level requirement is
 	  expected and using bound wq may end up creating large number
@@ -209,10 +209,10 @@ resources, scheduled and executed.
   WQ_HIGHPRI
 
 	Work items of a highpri wq are queued to the highpri
-	thread-pool of the target gcwq.  Highpri thread-pools are
+	worker-pool of the target cpu.  Highpri worker-pools are
 	served by worker threads with elevated nice level.
 
-	Note that normal and highpri thread-pools don't interact with
+	Note that normal and highpri worker-pools don't interact with
 	each other.  Each maintain its separate pool of workers and
 	implements concurrency management among its workers.
 
@@ -221,7 +221,7 @@ resources, scheduled and executed.
 	Work items of a CPU intensive wq do not contribute to the
 	concurrency level.  In other words, runnable CPU intensive
 	work items will not prevent other work items in the same
-	thread-pool from starting execution.  This is useful for bound
+	worker-pool from starting execution.  This is useful for bound
 	work items which are expected to hog CPU cycles so that their
 	execution is regulated by the system scheduler.
 
@@ -254,9 +254,9 @@ recommended.
 
 Some users depend on the strict execution ordering of ST wq.  The
 combination of @max_active of 1 and WQ_UNBOUND is used to achieve this
-behavior.  Work items on such wq are always queued to the unbound gcwq
-and only one work item can be active at any given time thus achieving
-the same ordering property as ST wq.
+behavior.  Work items on such wq are always queued to the unbound
+worker-pools and only one work item can be active at any given time thus
+achieving the same ordering property as ST wq.
 
 
 5. Example Execution Scenarios
-- 
1.8.2.1


