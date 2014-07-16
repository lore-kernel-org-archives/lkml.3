Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934837AbaGPGzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:55:48 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:55203 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933195AbaGPGzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:55:45 -0400
X-IronPort-AV: E=Sophos;i="5.00,901,1396972800"; 
   d="scan'208";a="33339190"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: detach rescuer from pool until the last
Date: Wed, 16 Jul 2014 14:56:50 +0800
Message-ID: <1405493811-26203-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 51697d393922 ("workqueue: use generic attach/detach routine for rescuers"),
The rescuer detaches itself from the pool before put_pwq() so that
the put_unbound_pool() will not destroy the rescuer-attached pool.

It is unnecessary, worker_detach_from_pool() can be used as the last
statement to access to the pool as the same as the regular workers,
put_unbound_pool() will wait for it to detach and then free the pool.

So we move the worker_detach_from_pool() down, make it coincide with
the regular workers.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
This old logic is introduced by the same-purpose but un-accepted patch:
https://lkml.org/lkml/2014/4/12/26

In the old patch, put_unbound_pool() still synchronizes with the workers
exiting via kthread_stop() which means put_unbound_pool() can't destroy the
rescuer-attached pool, so the put_pwq() should be the last statement
for the rescuer.

And after several versions of the patchset, the put_unbound_pool() was
re-implemented and it can wait any un-detached worker including the
rescuers, but the above mentioned old logic is still kept in the code.

The old logic is still correct now, but not grace nor necessary.

 kernel/workqueue.c |    12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a791a8c..dfd9f68 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2300,11 +2300,6 @@ repeat:
 				move_linked_works(work, scheduled, &n);
 
 		process_scheduled_works(rescuer);
-		spin_unlock_irq(&pool->lock);
-
-		worker_detach_from_pool(rescuer, pool);
-
-		spin_lock_irq(&pool->lock);
 
 		/*
 		 * Put the reference grabbed by send_mayday().  @pool won't
@@ -2322,8 +2317,11 @@ repeat:
 			wake_up_worker(pool);
 
 		rescuer->pool = NULL;
-		spin_unlock(&pool->lock);
-		spin_lock(&wq_mayday_lock);
+		spin_unlock_irq(&pool->lock);
+
+		worker_detach_from_pool(rescuer, pool);
+
+		spin_lock_irq(&wq_mayday_lock);
 	}
 
 	spin_unlock_irq(&wq_mayday_lock);
-- 
1.7.4.4

