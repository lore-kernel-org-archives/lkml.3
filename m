Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbaFCH3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:29:15 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:37154 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932284AbaFCH3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:29:01 -0400
X-IronPort-AV: E=Sophos;i="4.98,963,1392134400"; 
   d="scan'208";a="31368545"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 2/2] workqueue: stronger test in process_one_work()
Date: Tue, 3 Jun 2014 15:33:28 +0800
Message-ID: <1401780809-12331-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1401780809-12331-1-git-send-email-laijs@cn.fujitsu.com>
References: <1401780809-12331-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When POOL_DISASSOCIATED is cleared, the running worker's local CPU should
be the same as pool->cpu without any exception even during cpu-hotplug.

This fix changes "(proposition_A && proposition_B && proposition_C)"
to "(proposition_B && proposition_C)", so if the old compound proposition
is true, the new one must be true too. so this fix will not hide any
possible bug which can be hit by old test.

CC: Jason J. Herne <jjherne@linux.vnet.ibm.com>
CC: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5ae491e..204dd95 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2015,13 +2015,8 @@ __acquires(&pool->lock)
 
 	lockdep_copy_map(&lockdep_map, &work->lockdep_map);
 #endif
-	/*
-	 * Ensure we're on the correct CPU.  DISASSOCIATED test is
-	 * necessary to avoid spurious warnings from rescuers servicing the
-	 * unbound or a disassociated pool.
-	 */
-	WARN_ON_ONCE(!(worker->flags & WORKER_UNBOUND) &&
-		     !(pool->flags & POOL_DISASSOCIATED) &&
+	/* Ensure we're on the correct CPU. */
+	WARN_ON_ONCE(!(pool->flags & POOL_DISASSOCIATED) &&
 		     raw_smp_processor_id() != pool->cpu);
 
 	/*
-- 
1.7.4.4

