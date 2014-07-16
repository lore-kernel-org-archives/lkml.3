Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbaGPKJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:09:09 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:55806 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757535AbaGPKJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:09:07 -0400
X-IronPort-AV: E=Sophos;i="5.00,902,1396972800"; 
   d="scan'208";a="33350985"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/2] workqueue: remove unneeded test before wake up next worker
Date: Wed, 16 Jul 2014 18:09:58 +0800
Message-ID: <1405505409-12058-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
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
 kernel/workqueue.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f8d54c1..6d11b9a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2047,11 +2047,8 @@ __acquires(&pool->lock)
 	if (unlikely(cpu_intensive))
 		worker_set_flags(worker, WORKER_CPU_INTENSIVE, true);
 
-	/*
-	 * Unbound pool isn't concurrency managed and work items should be
-	 * executed ASAP.  Wake up another worker if necessary.
-	 */
-	if ((worker->flags & WORKER_UNBOUND) && need_more_worker(pool))
+	/* Wake up another worker if necessary. */
+	if (need_more_worker(pool))
 		wake_up_worker(pool);
 
 	/*
-- 
1.7.4.4

