Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbaGZDE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 23:04:27 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:16072 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751853AbaGZDEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 23:04:05 -0400
X-IronPort-AV: E=Sophos;i="5.00,965,1396972800"; 
   d="scan'208";a="33802426"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/3] workqueue: migrate the new worker before add it to idle_list
Date: Sat, 26 Jul 2014 11:04:49 +0800
Message-ID: <1406343900-32423-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1406343900-32423-1-git-send-email-laijs@cn.fujitsu.com>
References: <1406343900-32423-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an undocumented requirement for create_worker() that it can
only be called from existing worker (aka. manager) except the first call.

The reason is that the current create_worker() queues the new worker to
idle_list at first and then wake up it.  But the new worker is not
guaranteed to be migrated until it is waken up.  Thus the
wq_worker_sleeping() may see the new non-local worker from the idle_list
if this block of code is not executed on the local CPU to disable
wq_worker_sleeping().  Existing worker can guarantee to run on local
CPU when !DISASSOCIATED, so create_worker() is required to be called
from existing worker/manager only currently.

But we are planning to allow create_worker() to be called out side
from its workers and the requirement should be alleviated.  So we exchange
the order of the code, the new worker is woken up before queued
to idle_list.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 370f947..1d44d8d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1708,8 +1708,13 @@ static struct worker *create_worker(struct worker_pool *pool)
 	/* start the newly created worker */
 	spin_lock_irq(&pool->lock);
 	worker->pool->nr_workers++;
-	worker_enter_idle(worker);
+	/*
+	 * Wake up the worker at first and then queue it to the idle_list,
+	 * so that it is ensued that the wq_worker_sleeping() sees the worker
+	 * had been migrated properly when sees this worker in the idle_list.
+	 */
 	wake_up_process(worker->task);
+	worker_enter_idle(worker);
 	spin_unlock_irq(&pool->lock);
 
 	return worker;
-- 
1.7.4.4

