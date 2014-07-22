Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaGVFBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:01:08 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:19244 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750940AbaGVFBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:01:07 -0400
X-IronPort-AV: E=Sophos;i="5.00,931,1396972800"; 
   d="scan'208";a="33612895"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/2 V2] workqueue: remove unneeded test before wake up next worker
Date: Tue, 22 Jul 2014 13:01:59 +0800
Message-ID: <1406005330-11864-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <20140718225317.GC5739@htj.dyndns.org>
References: <20140718225317.GC5739@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this code:
	if ((worker->flags & WORKER_UNBOUND) && need_more_worker(pool))
		wake_up_worker(pool);

the first test is unneeded. Even the first test is removed, it doesn't affect
the wake-up logic when WORKER_UNBOUND. And it will not introduce any useless
wake-up when !WORKER_UNBOUND since the nr_running >= 1 except only one case.
It will introduce useless/redundant wake-up when cpu_intensive, but this
case is rare and next patch will also remove this redundant wake-up.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a791a8c..cd75689 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2048,10 +2048,13 @@ __acquires(&pool->lock)
 		worker_set_flags(worker, WORKER_CPU_INTENSIVE, true);
 
 	/*
-	 * Unbound pool isn't concurrency managed and work items should be
-	 * executed ASAP.  Wake up another worker if necessary.
+	 * Wake up another worker if necessary.  It is a no-op
+	 * when the current worker is concurrency managed since
+	 * pool->nr_running >= 1.  But it is required for non-concurrency
+	 * managed workers, mainly for unbound pool which requries
+	 * chain execution of currently pending work items ASAP.
 	 */
-	if ((worker->flags & WORKER_UNBOUND) && need_more_worker(pool))
+	if (need_more_worker(pool))
 		wake_up_worker(pool);
 
 	/*
-- 
1.7.4.4

