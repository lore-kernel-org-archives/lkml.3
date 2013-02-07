Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339Ab3BGUQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 15:16:49 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:42888 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab3BGUQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 15:16:48 -0500
Date: Thu, 7 Feb 2013 12:16:42 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH wq/for-3.9] workqueue: make get_work_pool_id() cheaper
Message-ID: <20130207201642.GT2875@htj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-7-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359657696-2767-7-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

get_work_pool_id() currently first obtains pool using get_work_pool()
and then return pool->id.  For an off-queue work item, this involves
obtaining pool ID from worker->data, performing idr_find() to find the
matching pool and then returning its pool->id which of course is the
same as the one which went into idr_find().

Just open code WORK_STRUCT_CWQ case and directly return pool ID from
work->data.

tj: The original patch dropped on-queue work item handling and renamed
    the function to offq_work_pool_id().  There isn't much benefit in
    doing so.  Handling it only requires a single if() and we need at
    least BUG_ON(), which is also a branch, even if we drop on-queue
    handling.  Open code WORK_STRUCT_CWQ case and keep the function in
    line with get_work_pool().  Rewrote the description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -626,9 +626,13 @@ static struct worker_pool *get_work_pool
  */
 static int get_work_pool_id(struct work_struct *work)
 {
-	struct worker_pool *pool = get_work_pool(work);
+	unsigned long data = atomic_long_read(&work->data);
 
-	return pool ? pool->id : WORK_OFFQ_POOL_NONE;
+	if (data & WORK_STRUCT_CWQ)
+		return ((struct cpu_workqueue_struct *)
+			(data & WORK_STRUCT_WQ_DATA_MASK))->pool->id;
+
+	return data >> WORK_OFFQ_POOL_SHIFT;
 }
 
 static void mark_work_canceling(struct work_struct *work)
