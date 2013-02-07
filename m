Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab3BGAxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:53:12 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:34301 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab3BGAxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:53:07 -0500
Date: Wed, 6 Feb 2013 16:53:02 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH wq/for-3.9] workqueue: make work->data point to pool after
 try_to_grab_pending()
Message-ID: <20130207005302.GH2875@htj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-5-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359657696-2767-5-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

We plan to use work->data pointing to cwq as the synchronization
invariant when determining whether a given work item is on a locked
pool or not, which requires work->data pointing to cwq only while the
work item is queued on the associated pool.

With delayed_work updated not to overload work->data for target
workqueue recording, the only case where we still have off-queue
work->data pointing to cwq is try_to_grab_pending() which doesn't
update work->data after stealing a queued work item.  There's no
reason for try_to_grab_pending() to not update work->data to point to
the pool instead of cwq, like the normal execution does.

This patch adds set_work_pool_and_keep_pending() which makes
work->data point to pool instead of cwq but keeps the pending bit
unlike set_work_pool_and_clear_pending() (surprise!).

After this patch, it's guaranteed that only queued work items point to
cwqs.

This patch doesn't introduce any visible behavior change.

tj: Renamed the new helper function to match
    set_work_pool_and_clear_pending() and rewrote the description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -556,6 +556,13 @@ static void set_work_cwq(struct work_str
 		      WORK_STRUCT_PENDING | WORK_STRUCT_CWQ | extra_flags);
 }
 
+static void set_work_pool_and_keep_pending(struct work_struct *work,
+					   int pool_id)
+{
+	set_work_data(work, (unsigned long)pool_id << WORK_OFFQ_POOL_SHIFT,
+		      WORK_STRUCT_PENDING);
+}
+
 static void set_work_pool_and_clear_pending(struct work_struct *work,
 					    int pool_id)
 {
@@ -1115,6 +1122,9 @@ static int try_to_grab_pending(struct wo
 			cwq_dec_nr_in_flight(get_work_cwq(work),
 				get_work_color(work));
 
+			/* work->data points to cwq iff queued, point to pool */
+			set_work_pool_and_keep_pending(work, pool->id);
+
 			spin_unlock(&pool->lock);
 			return 1;
 		}
