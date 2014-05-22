Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaEVIkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:40:05 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:32794 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752379AbaEVIkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:40:01 -0400
X-IronPort-AV: E=Sophos;i="4.98,885,1392134400"; 
   d="scan'208";a="30863992"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: remove the unneeded cpu_relax() in __queue_work()
Date: Thu, 22 May 2014 16:44:16 +0800
Message-ID: <1400748257-14165-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pwq->refcnt == 0, the retrying is guaranteed to make forward-progress.
The comment above the code explains it well:

	/*
	 * pwq is determined and locked.  For unbound pools, we could have
	 * raced with pwq release and it could already be dead.  If its
	 * refcnt is zero, repeat pwq selection.  Note that pwqs never die
	 * without another pwq replacing it in the numa_pwq_tbl or while
	 * work items are executing on it, so the retrying is guaranteed to
	 * make forward-progress.
	 */

It means the cpu_relax() here is useless and sometimes misleading,
it should retry directly and make some progress rather than waste time.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 23f9a2b..98b38b5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1368,7 +1368,6 @@ retry:
 	if (unlikely(!pwq->refcnt)) {
 		if (wq->flags & WQ_UNBOUND) {
 			spin_unlock(&pwq->pool->lock);
-			cpu_relax();
 			goto retry;
 		}
 		/* oops */
-- 
1.7.4.4

