Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaEZLyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 07:54:05 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:48230 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751549AbaEZLyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 07:54:03 -0400
X-IronPort-AV: E=Sophos;i="4.98,912,1392134400"; 
   d="scan'208";a="31014760"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/2] workqueue: remove the unneeded "while(true)" loop and adjust the indent
Date: Mon, 26 May 2014 19:58:13 +0800
Message-ID: <1401105501-13307-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1401105501-13307-1-git-send-email-laijs@cn.fujitsu.com>
References: <1401105501-13307-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the current first-flusher always passes the cascading responsibility
to the next flusher, the body of "while(true)" loop is running exactly once,
"while(true)" loop is unneeded. So we remove the "while(true)" loop and
adjust the indent.

Note, there is no "continue" inside the "while(true)" loop, but there are
three "break" inside the loop. The first one is in the inner loop, we don't
touch it except adjusting the indent. The second one is changed to
"goto out_unlock". The third one is in the end of the loop, it is just
removed.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   84 ++++++++++++++++++++++++---------------------------
 1 files changed, 40 insertions(+), 44 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 948a84f..3d8bcbe 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2507,6 +2507,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 		.flush_color = -1,
 		.done = COMPLETION_INITIALIZER_ONSTACK(this_flusher.done),
 	};
+	struct wq_flusher *next, *tmp;
 	int next_color;
 
 	lock_map_acquire(&wq->lockdep_map);
@@ -2577,59 +2578,54 @@ void flush_workqueue(struct workqueue_struct *wq)
 	WARN_ON_ONCE(!list_empty(&this_flusher.list));
 	WARN_ON_ONCE(wq->flush_color != this_flusher.flush_color);
 
-	while (true) {
-		struct wq_flusher *next, *tmp;
-
-		/* complete all the flushers sharing the current flush color */
-		list_for_each_entry_safe(next, tmp, &wq->flusher_queue, list) {
-			if (next->flush_color != wq->flush_color)
-				break;
-			list_del_init(&next->list);
-			complete(&next->done);
-		}
+	/* complete all the flushers sharing the current flush color */
+	list_for_each_entry_safe(next, tmp, &wq->flusher_queue, list) {
+		if (next->flush_color != wq->flush_color)
+			break;
+		list_del_init(&next->list);
+		complete(&next->done);
+	}
 
-		WARN_ON_ONCE(!list_empty(&wq->flusher_overflow) &&
-			     wq->flush_color != work_next_color(wq->work_color));
+	WARN_ON_ONCE(!list_empty(&wq->flusher_overflow) &&
+		     wq->flush_color != work_next_color(wq->work_color));
 
-		/* this flush_color is finished, advance by one */
-		wq->flush_color = work_next_color(wq->flush_color);
+	/* this flush_color is finished, advance by one */
+	wq->flush_color = work_next_color(wq->flush_color);
 
-		/* one color has been freed, handle overflow queue */
-		if (!list_empty(&wq->flusher_overflow)) {
-			/*
-			 * Assign the same color to all overflowed
-			 * flushers, advance work_color and append to
-			 * flusher_queue.  This is the start-to-wait
-			 * phase for these overflowed flushers.
-			 */
-			list_for_each_entry(tmp, &wq->flusher_overflow, list)
-				tmp->flush_color = wq->work_color;
+	/* one color has been freed, handle overflow queue */
+	if (!list_empty(&wq->flusher_overflow)) {
+		/*
+		 * Assign the same color to all overflowed
+		 * flushers, advance work_color and append to
+		 * flusher_queue.  This is the start-to-wait
+		 * phase for these overflowed flushers.
+		 */
+		list_for_each_entry(tmp, &wq->flusher_overflow, list)
+			tmp->flush_color = wq->work_color;
 
-			wq->work_color = work_next_color(wq->work_color);
+		wq->work_color = work_next_color(wq->work_color);
 
-			list_splice_tail_init(&wq->flusher_overflow,
-					      &wq->flusher_queue);
-			flush_workqueue_prep_pwqs(wq, -1, wq->work_color);
-		}
+		list_splice_tail_init(&wq->flusher_overflow,
+				      &wq->flusher_queue);
+		flush_workqueue_prep_pwqs(wq, -1, wq->work_color);
+	}
 
-		if (list_empty(&wq->flusher_queue)) {
-			WARN_ON_ONCE(wq->flush_color != wq->work_color);
-			break;
-		}
+	if (list_empty(&wq->flusher_queue)) {
+		WARN_ON_ONCE(wq->flush_color != wq->work_color);
+		goto out_unlock;
+	}
 
-		/*
-		 * Need to flush more colors.  Make the next flusher
-		 * the new first flusher and arm pwqs.
-		 */
-		WARN_ON_ONCE(wq->flush_color == wq->work_color);
-		WARN_ON_ONCE(wq->flush_color != next->flush_color);
+	/*
+	 * Need to flush more colors.  Make the next flusher
+	 * the new first flusher and arm pwqs.
+	 */
+	WARN_ON_ONCE(wq->flush_color == wq->work_color);
+	WARN_ON_ONCE(wq->flush_color != next->flush_color);
 
-		list_del_init(&next->list);
-		wq->first_flusher = next;
+	list_del_init(&next->list);
+	wq->first_flusher = next;
 
-		flush_workqueue_prep_pwqs(wq, wq->flush_color, -1);
-		break;
-	}
+	flush_workqueue_prep_pwqs(wq, wq->flush_color, -1);
 
 out_unlock:
 	mutex_unlock(&wq->mutex);
-- 
1.7.4.4

