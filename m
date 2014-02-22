Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaBVMMK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 07:12:10 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:35477 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaBVMMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 07:12:09 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] workqueue: Guarantee work function memory ordering
Date: Sat, 22 Feb 2014 07:11:51 -0500
Message-Id: <1393071111-5128-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users of the workqueue api may assume the workqueue provides a
memory ordering guarantee for re-queued work items; ie., that
if a work item is not queue-able then the previously queued
work instance is not running and so any memory operations
which occur before queuing the work will be visible to the work
function.

For example, code of the form:
    add new data to work on
    queue work
assumes that this latest data is acted upon, either by the
newly queued instance (if it could be queued) or by the not-yet-
running instance (if a new instance could not be queued).

Provide this implicit memory ordering guarantee; prevent
speculative loads in the work function from occurring before
the current work instance is marked not pending (and thus has
started). This, in turn, guarantees that stores occurring before
schedule_work/queue_work are visible to either the not-yet-running
work instance (if new work could not be queued) or that new work
is queued (and thus ensuring the new data is acted upon).

Note that preventing early stores is unnecessary because no
conclusion can be reached about the state of the work function
from outside the work function by ordering early stores after
clearing PENDING (other than testing PENDING).

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 kernel/workqueue.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 82ef9f3..a4b241d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2201,6 +2201,16 @@ __acquires(&pool->lock)
 
 	spin_unlock_irq(&pool->lock);
 
+	/*
+	 * Paired with the implied mb of test_and_set_bit(PENDING).
+	 * Guarantees speculative loads which occur in the work item
+	 * function do not complete before PENDING is cleared in
+	 * set_work_pool_and_clear_pending() above. In turn, this
+	 * ensures that stores are either visible to the not-yet-
+	 * running work instance or a new instance is queueable.
+	 */
+	smp_rmb();
+
 	lock_map_acquire_read(&pwq->wq->lockdep_map);
 	lock_map_acquire(&lockdep_map);
 	trace_workqueue_execute_start(work);
-- 
1.8.1.2

