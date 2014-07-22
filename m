Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbaGVFCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:02:45 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:3155 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750790AbaGVFCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:02:44 -0400
X-IronPort-AV: E=Sophos;i="5.00,931,1396972800"; 
   d="scan'208";a="33612966"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH v2] workqueue: detach rescuer from pool until the last
Date: Tue, 22 Jul 2014 13:03:47 +0800
Message-ID: <1406005427-11998-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <20140718225159.GB5739@htj.dyndns.org>
References: <20140718225159.GB5739@htj.dyndns.org>
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
 kernel/workqueue.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index bf837b0..347ac5b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2252,15 +2252,10 @@ repeat:
 				move_linked_works(work, scheduled, &n);
 
 		process_scheduled_works(rescuer);
-		spin_unlock_irq(&pool->lock);
-
-		worker_detach_from_pool(rescuer, pool);
-
-		spin_lock_irq(&pool->lock);
 
 		/*
 		 * Put the reference grabbed by send_mayday().  @pool won't
-		 * go away while we're holding its lock.
+		 * go away while we're still attached to it.
 		 */
 		put_pwq(pwq);
 
@@ -2273,8 +2268,11 @@ repeat:
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

