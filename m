Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaDRPHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 11:07:10 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:64494 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaDRPHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 11:07:07 -0400
Date: Fri, 18 Apr 2014 11:06:53 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] workqueue: fix a possible race condition between rescuer
 and pwq-release
Message-ID: <20140418150653.GB12515@htj.dyndns.org>
References: <20140417162720.GQ15326@htj.dyndns.org>
 <1397827555-19641-1-git-send-email-laijs@cn.fujitsu.com>
 <1397827555-19641-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397827555-19641-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Applied to wq/for-3.15-fixes with put_pwq() relocated and patch
description and comments updated.

Thanks.
-------- 8< --------
>From 4b81955722abe4306096c7b0137e0491a7ba7b0e Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Fri, 18 Apr 2014 11:04:16 -0400

There is a race condition between rescuer_thread() and
pwq_unbound_release_workfn().

Even after a pwq is scheduled for rescue, the associated work items
may be consumed by any worker.  If all of them are consumed before the
rescuer gets to them and the pwq's base ref was put due to attribute
change, the pwq may be released while still being linked on
@wq->maydays list making the rescuer dereference already freed pwq
later.

Make send_mayday() pin the target pwq until the rescuer is done with
it.

tj: Updated comment and patch description.  Moved put_pwq() to after
    the last @pwq->pool access.  This isn't strictly necessarily for
    correctness but is cleaner as the pool is accessed through the
    pwq.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org # v3.10+
---
 kernel/workqueue.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6ba0c60..a6532f2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1916,6 +1916,12 @@ static void send_mayday(struct work_struct *work)
 
 	/* mayday mayday mayday */
 	if (list_empty(&pwq->mayday_node)) {
+		/*
+		 * If @pwq is for an unbound wq, its base ref may be put at
+		 * any time due to an attribute change.  Pin @pwq until the
+		 * rescuer is done with it.
+		 */
+		get_pwq(pwq);
 		list_add_tail(&pwq->mayday_node, &wq->maydays);
 		wake_up_process(wq->rescuer->task);
 	}
@@ -2459,6 +2465,7 @@ repeat:
 
 		rescuer->pool = NULL;
 		spin_unlock(&pool->lock);
+		put_pwq(pwq);	/* put the ref from send_mayday() */
 		spin_lock(&wq_mayday_lock);
 	}
 
-- 
1.9.0

