Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666AbaGPGze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:55:34 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:12940 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933195AbaGPGzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:55:32 -0400
X-IronPort-AV: E=Sophos;i="5.00,901,1396972800"; 
   d="scan'208";a="33339174"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: wake regular worker if need_more_worker() when rescuer leave the pool
Date: Wed, 16 Jul 2014 14:56:36 +0800
Message-ID: <1405493796-26169-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to wake up regular worker when nr_running==1,
so need_more_worker() is sufficient here.

And need_more_worker() gives us better readability due to the name of
"keep_working()" implies the rescuer should keep working now but
the rescuer is actually leaving.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index dfd9f68..7128053 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2308,11 +2308,11 @@ repeat:
 		put_pwq(pwq);
 
 		/*
-		 * Leave this pool.  If keep_working() is %true, notify a
+		 * Leave this pool.  If need_more_worker() is %true, notify a
 		 * regular worker; otherwise, we end up with 0 concurrency
 		 * and stalling the execution.
 		 */
-		if (keep_working(pool))
+		if (need_more_worker(pool))
 			wake_up_worker(pool);
 
 		rescuer->pool = NULL;
-- 
1.7.4.4

