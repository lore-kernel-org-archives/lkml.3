Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaCHBNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:13:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbaCHBHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roland Dreier <roland@purestorage.com>, Jens Axboe <axboe@kernel.dk>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 65/99] block: Dont access request after it might be freed
Date: Fri,  7 Mar 2014 17:08:01 -0800
Message-Id: <20140308010613.682595687@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 893d290f1d7496db97c9471bc352ad4a11dc8a25 upstream.

After we've done __elv_add_request() and __blk_run_queue() in
blk_execute_rq_nowait(), the request might finish and be freed
immediately.  Therefore checking if the type is REQ_TYPE_PM_RESUME
isn't safe afterwards, because if it isn't, rq might be gone.
Instead, check beforehand and stash the result in a temporary.

This fixes crashes in blk_execute_rq_nowait() I get occasionally when
running with lots of memory debugging options enabled -- I think this
race is usually harmless because the window for rq to be reallocated
is so small.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[xr: Backported to 3.4: adjust context]
Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-exec.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -49,8 +49,18 @@ void blk_execute_rq_nowait(struct reques
 			   rq_end_io_fn *done)
 {
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
+	bool is_pm_resume;
 
 	WARN_ON(irqs_disabled());
+
+	rq->rq_disk = bd_disk;
+	rq->end_io = done;
+	/*
+	 * need to check this before __blk_run_queue(), because rq can
+	 * be freed before that returns.
+	 */
+	is_pm_resume = rq->cmd_type == REQ_TYPE_PM_RESUME;
+
 	spin_lock_irq(q->queue_lock);
 
 	if (unlikely(blk_queue_dead(q))) {
@@ -66,7 +76,7 @@ void blk_execute_rq_nowait(struct reques
 	__elv_add_request(q, rq, where);
 	__blk_run_queue(q);
 	/* the queue is stopped so it won't be run */
-	if (rq->cmd_type == REQ_TYPE_PM_RESUME)
+	if (is_pm_resume)
 		q->request_fn(q);
 	spin_unlock_irq(q->queue_lock);
 }


