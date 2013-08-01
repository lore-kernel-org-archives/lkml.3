Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3HAMfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 08:35:43 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:62914 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab3HAMfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:35:42 -0400
Date: Thu, 1 Aug 2013 08:35:32 -0400
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] workqueue: copy workqueue_attrs with all fields
Message-ID: <20130801123532.GC24966@htj.dyndns.org>
References: <20130729062412.GA6448@kernel.org>
 <20130729111401.GA20951@mtj.dyndns.org>
 <20130729125259.GA9306@kernel.org>
 <20130729153523.GA22605@mtj.dyndns.org>
 <20130730054955.GA5225@kernel.org>
 <20130730141419.GG12016@htj.dyndns.org>
 <20130731013929.GB1504@kernel.org>
 <20130731102752.GD2810@htj.dyndns.org>
 <20130801015636.GA12580@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801015636.GA12580@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Applied w/ some doc updates to wq/for-3.11f-fixes.

Thanks a lot!
---------- 8< -----------
>From 4fb228c35f4522f83abacaecc9838f0ab391a9b6 Mon Sep 17 00:00:00 2001
From: Shaohua Li <shli@kernel.org>
Date: Thu, 1 Aug 2013 09:56:36 +0800

 $echo '0' > /sys/bus/workqueue/devices/xxx/numa
 $cat /sys/bus/workqueue/devices/xxx/numa

I got 1. It should be 0, the reason is copy_workqueue_attrs() called
in apply_workqueue_attrs() doesn't copy no_numa field.

Fix it by making copy_workqueue_attrs() copy ->no_numa too.  This
would also make get_unbound_pool() set a pool's ->no_numa attribute
according to the workqueue attributes used when the pool was created.
While harmelss, as ->no_numa isn't a pool attribute, this is a bit
confusing.  Clear it explicitly.

tj: Updated description and comments a bit.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
---
 kernel/workqueue.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 55f5f0a..cc5fa06 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3416,6 +3416,12 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 {
 	to->nice = from->nice;
 	cpumask_copy(to->cpumask, from->cpumask);
+	/*
+	 * Unlike hash and equality test, this function doesn't ignore
+	 * ->no_numa as it is used for both pool and wq attrs.  Instead,
+	 * get_unbound_pool() explicitly clears ->no_numa after copying.
+	 */
+	to->no_numa = from->no_numa;
 }
 
 /* hash value of the content of @attr */
@@ -3583,6 +3589,12 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	lockdep_set_subclass(&pool->lock, 1);	/* see put_pwq() */
 	copy_workqueue_attrs(pool->attrs, attrs);
 
+	/*
+	 * no_numa isn't a worker_pool attribute, always clear it.  See
+	 * 'struct workqueue_attrs' comments for detail.
+	 */
+	pool->attrs->no_numa = 0;
+
 	/* if cpumask is contained inside a NUMA node, we belong to that node */
 	if (wq_numa_enabled) {
 		for_each_node(node) {
-- 
1.8.3.1

