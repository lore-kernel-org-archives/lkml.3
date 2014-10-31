Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935AbaJaLXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:23:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60066 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758932AbaJaLVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:21:44 -0400
Message-Id: <20141031111549.798090363@infradead.org>
User-Agent: quilt/0.61-1
Date: Fri, 31 Oct 2014 12:10:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: peter@hurleysoftware.com, oleg@redhat.com, rjw@rjwysocki.net,
        torvalds@linux-foundation.org, tglx@linutronix.de, eparis@redhat.com,
        umgwanakikbuti@gmail.com, marcel@holtmann.org, ebiederm@xmission.com,
        davem@davemloft.net, fengguang.wu@intel.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6/7] netdev: Fix sleeping inside wait event
References: <20141031111037.936236584@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-fix-netdev-device_exit_batch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtnl_lock_unregistering*() take rtnl_lock() -- a mutex -- inside a
wait loop. The wait loop relies on current->state to function, but so
does mutex_lock(), nesting them makes for the inner to destroy the
outer state.

Fix this using the new wait_woken() bits.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Acked-by: David S. Miller <davem@davemloft.net>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20141029173110.GE15602@worktop.programming.kicks-ass.net
---
 net/core/dev.c       |   10 +++++-----
 net/core/rtnetlink.c |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7196,11 +7196,10 @@ static void __net_exit rtnl_lock_unregis
 	 */
 	struct net *net;
 	bool unregistering;
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
+	add_wait_queue(&netdev_unregistering_wq, &wait);
 	for (;;) {
-		prepare_to_wait(&netdev_unregistering_wq, &wait,
-				TASK_UNINTERRUPTIBLE);
 		unregistering = false;
 		rtnl_lock();
 		list_for_each_entry(net, net_list, exit_list) {
@@ -7212,9 +7211,10 @@ static void __net_exit rtnl_lock_unregis
 		if (!unregistering)
 			break;
 		__rtnl_unlock();
-		schedule();
+
+		wait_woken(&wait, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 	}
-	finish_wait(&netdev_unregistering_wq, &wait);
+	remove_wait_queue(&netdev_unregistering_wq, &wait);
 }
 
 static void __net_exit default_device_exit_batch(struct list_head *net_list)
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -365,11 +365,10 @@ static void rtnl_lock_unregistering_all(
 {
 	struct net *net;
 	bool unregistering;
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
+	add_wait_queue(&netdev_unregistering_wq, &wait);
 	for (;;) {
-		prepare_to_wait(&netdev_unregistering_wq, &wait,
-				TASK_UNINTERRUPTIBLE);
 		unregistering = false;
 		rtnl_lock();
 		for_each_net(net) {
@@ -381,9 +380,10 @@ static void rtnl_lock_unregistering_all(
 		if (!unregistering)
 			break;
 		__rtnl_unlock();
-		schedule();
+
+		wait_woken(&wait, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 	}
-	finish_wait(&netdev_unregistering_wq, &wait);
+	remove_wait_queue(&netdev_unregistering_wq, &wait);
 }
 
 /**


