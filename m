Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbaFCH21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:28:27 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:15541 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932080AbaFCH2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:28:25 -0400
X-IronPort-AV: E=Sophos;i="4.98,963,1392134400"; 
   d="scan'208";a="31368522"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: clear leftover flags when detached
Date: Tue, 3 Jun 2014 15:32:52 +0800
Message-ID: <1401780772-12263-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a worker is detached, the worker->flags may still have WORKER_UNBOUND
or WORKER_REBOUND, it is OK for all cases:
  1) if it is a normal worker, the worker will be dead, it is OK.
  2) if it is a rescuer, it may re-attach to a pool with this leftover flag[s],
     it is still correct except it may cause unneeded wakeup.

It is correct but not good, so we just remove the leftover flags.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7dc6e66..9f53abd 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1663,6 +1663,9 @@ static void worker_detach_from_pool(struct worker *worker,
 		detach_completion = pool->detach_completion;
 	mutex_unlock(&pool->attach_mutex);
 
+	/* clear leftover flags without pool->lock after it is detached */
+	worker->flags &= ~(WORKER_UNBOUND | WORKER_REBOUND);
+
 	if (detach_completion)
 		complete(detach_completion);
 }
-- 
1.7.4.4

