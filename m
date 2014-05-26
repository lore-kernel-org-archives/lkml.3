Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaEZLyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 07:54:04 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:56011 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751624AbaEZLyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 07:54:02 -0400
X-IronPort-AV: E=Sophos;i="4.98,912,1392134400"; 
   d="scan'208";a="31014759"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/2] workqueue: always pass cascading responsibility to the next flusher
Date: Mon, 26 May 2014 19:58:12 +0800
Message-ID: <1401105501-13307-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the end of the cascading code of flush_workqueue(), the current
first-flusher will hand over the cascading-responsibility to the next
flusher and make the next flusher to be the new first-flusher.

But when the current first-flusher finds out that the color of the next
flusher is already done, it will deprive first-flusher role from
the next, and repeat cascading by itself for optimization.

This optimization saves one mutex_lock(&wq->mutex) due to the current
first-flusher already held it.

This optimization reduces the cascading-latency, because the next flusher
is not running currently, it will delay a little when we keep the next's
responsibility for cascading.

This optimization may also have other benefits. However, it is slow-path
and low-probability-hit case, and it is not good at these aspects:
    1) it adds a special case and makes the code complex, bad for review.
    2) it adds a special state for the first-flusher which is allowed to
       be deprived. It causes a race and we have to check wq->first_flusher
       again with mutex held: 4ce48b37bfed ("workqueue: fix race condition
       in flush_workqueue()").

Since it is slow-path, we remove this optimization and pass the cascading
responsibility to the next flusher unconditionally. And the race condition
mentioned above is gone, so we also revert the 4ce48b37bfed by removing
the checking.

And since it always passes the cascading responsibility to the next flusher,
it doesn't need to repeat to cascade, and the "while(true)" can be removed.
But if we remove the "while(true)" loop and adjust the indent, "git diff"
will result a complex patch which is hard to review. So we will remove the
"while(true)" loop in the next patch which makes two patches are good
for review. This patch just uses a "break" to disable repeating cascading
at the end of the loop.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index bc3c188..948a84f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2572,10 +2572,6 @@ void flush_workqueue(struct workqueue_struct *wq)
 
 	mutex_lock(&wq->mutex);
 
-	/* we might have raced, check again with mutex held */
-	if (wq->first_flusher != &this_flusher)
-		goto out_unlock;
-
 	wq->first_flusher = NULL;
 
 	WARN_ON_ONCE(!list_empty(&this_flusher.list));
@@ -2631,14 +2627,8 @@ void flush_workqueue(struct workqueue_struct *wq)
 		list_del_init(&next->list);
 		wq->first_flusher = next;
 
-		if (flush_workqueue_prep_pwqs(wq, wq->flush_color, -1))
-			break;
-
-		/*
-		 * Meh... this color is already done, clear first
-		 * flusher and repeat cascading.
-		 */
-		wq->first_flusher = NULL;
+		flush_workqueue_prep_pwqs(wq, wq->flush_color, -1);
+		break;
 	}
 
 out_unlock:
-- 
1.7.4.4

