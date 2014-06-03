Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbaFCH1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:27:40 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:38409 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932329AbaFCH1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:27:37 -0400
X-IronPort-AV: E=Sophos;i="4.98,963,1392134400"; 
   d="scan'208";a="31368490"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: remove the empty check in too_many_workers()
Date: Tue, 3 Jun 2014 15:32:07 +0800
Message-ID: <1401780727-12161-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit ea1abd6197d5 ("workqueue: reimplement idle worker rebinding")
used a trick which simply removes all to-be-bound idle workers from the
idle list and lets them add themselves back after completing rebinding.

And this trick caused the @worker_pool->nr_idle may deviate than the actual
number of idle workers on @worker_pool->idle_list.  More specifically,
nr_idle may be non-zero while ->idle_list is empty.  All users of
->nr_idle and ->idle_list are audited.  The only affected one is
too_many_workers() which is updated to check %false if ->idle_list is
empty regardless of ->nr_idle.

The commit/trick was complicated due to it just tried to simplify an even
more complicated problem (workers had to rebind itself). But the commit
a9ab775bcadf ("workqueue: directly restore CPU affinity of workers
from CPU_ONLINE") fixed all these problems and the mentioned trick was
useless and is gone.

So, now the @worker_pool->nr_idle is exactly the actual number of workers
on @worker_pool->idle_list. too_many_workers() should recover as it was
before the trick. So we remove the empty check.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 724ae35..a1c2c10 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -758,13 +758,6 @@ static bool too_many_workers(struct worker_pool *pool)
 	int nr_idle = pool->nr_idle + managing; /* manager is considered idle */
 	int nr_busy = pool->nr_workers - nr_idle;
 
-	/*
-	 * nr_idle and idle_list may disagree if idle rebinding is in
-	 * progress.  Never return %true if idle_list is empty.
-	 */
-	if (list_empty(&pool->idle_list))
-		return false;
-
 	return nr_idle > 2 && (nr_idle - 2) * MAX_IDLE_WORKERS_RATIO >= nr_busy;
 }
 
-- 
1.7.4.4

