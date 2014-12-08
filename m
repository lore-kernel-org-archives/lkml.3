Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbaLHRoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:44:12 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:47948 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780AbaLHRoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:44:11 -0500
Date: Mon, 8 Dec 2014 12:44:06 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH wq/for-3.19 2/3] workqueue: keep track of the flushing task
 and pool manager
Message-ID: <20141208174406.GC12274@htj.dyndns.org>
References: <20141208174326.GB12274@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141208174326.GB12274@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add wq_barrier->task and worker_pool->manager to keep track of the
flushing task and pool manager respectively.  These are purely
informational and will be used to implement sysrq dump of workqueues.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -159,6 +159,7 @@ struct worker_pool {
 
 	/* see manage_workers() for details on the two manager mutexes */
 	struct mutex		manager_arb;	/* manager arbitration */
+	struct worker		*manager;	/* L: purely informational */
 	struct mutex		attach_mutex;	/* attach/detach exclusion */
 	struct list_head	workers;	/* A: attached workers */
 	struct completion	*detach_completion; /* all workers detached */
@@ -1927,9 +1928,11 @@ static bool manage_workers(struct worker
 	 */
 	if (!mutex_trylock(&pool->manager_arb))
 		return ret;
+	pool->manager = worker;
 
 	ret |= maybe_create_worker(pool);
 
+	pool->manager = NULL;
 	mutex_unlock(&pool->manager_arb);
 	return ret;
 }
@@ -2319,6 +2322,7 @@ repeat:
 struct wq_barrier {
 	struct work_struct	work;
 	struct completion	done;
+	struct task_struct	*task;	/* purely informational */
 };
 
 static void wq_barrier_func(struct work_struct *work)
@@ -2367,6 +2371,7 @@ static void insert_wq_barrier(struct poo
 	INIT_WORK_ONSTACK(&barr->work, wq_barrier_func);
 	__set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(&barr->work));
 	init_completion(&barr->done);
+	barr->task = current;
 
 	/*
 	 * If @target is currently being executed, schedule the
