Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab3BGCDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 21:03:16 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:51772 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3BGCDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 21:03:15 -0500
Date: Wed, 6 Feb 2013 18:03:09 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH wq/for-3.9] workqueue: cosmetic update in
 try_to_grab_pending()
Message-ID: <20130207020309.GJ2875@htj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-6-git-send-email-laijs@cn.fujitsu.com>
 <20130207015248.GI2875@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130207015248.GI2875@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent is-work-queued-here test simplification, the nested
if() in try_to_grab_pending() can be collapsed.  Collapse it.

This patch is purely cosmetic.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
A follow-up cleanup patch.

Thanks.

 kernel/workqueue.c |   38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1107,31 +1107,27 @@ static int try_to_grab_pending(struct wo
 	 * item is currently queued on that pool.
 	 */
 	cwq = get_work_cwq(work);
-	if (cwq) {
-		if (cwq->pool == pool) {
-			debug_work_deactivate(work);
+	if (cwq && cwq->pool == pool) {
+		debug_work_deactivate(work);
 
-			/*
-			 * A delayed work item cannot be grabbed directly
-			 * because it might have linked NO_COLOR work items
-			 * which, if left on the delayed_list, will confuse
-			 * cwq->nr_active management later on and cause
-			 * stall.  Make sure the work item is activated
-			 * before grabbing.
-			 */
-			if (*work_data_bits(work) & WORK_STRUCT_DELAYED)
-				cwq_activate_delayed_work(work);
+		/*
+		 * A delayed work item cannot be grabbed directly because
+		 * it might have linked NO_COLOR work items which, if left
+		 * on the delayed_list, will confuse cwq->nr_active
+		 * management later on and cause stall.  Make sure the work
+		 * item is activated before grabbing.
+		 */
+		if (*work_data_bits(work) & WORK_STRUCT_DELAYED)
+			cwq_activate_delayed_work(work);
 
-			list_del_init(&work->entry);
-			cwq_dec_nr_in_flight(get_work_cwq(work),
-				get_work_color(work));
+		list_del_init(&work->entry);
+		cwq_dec_nr_in_flight(get_work_cwq(work), get_work_color(work));
 
-			/* work->data points to cwq iff queued, point to pool */
-			set_work_pool_and_keep_pending(work, pool->id);
+		/* work->data points to cwq iff queued, point to pool */
+		set_work_pool_and_keep_pending(work, pool->id);
 
-			spin_unlock(&pool->lock);
-			return 1;
-		}
+		spin_unlock(&pool->lock);
+		return 1;
 	}
 	spin_unlock(&pool->lock);
 fail:
