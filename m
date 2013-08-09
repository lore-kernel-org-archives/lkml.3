Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030339Ab3HICCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:02:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030244Ab3HIB7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shaohua Li <shli@fusionio.com>, Tejun Heo <tj@kernel.org>
Subject: [ 083/102] workqueue: copy workqueue_attrs with all fields
Date: Thu,  8 Aug 2013 18:57:59 -0700
Message-Id: <20130809015029.824949476@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaohua Li <shli@kernel.org>

commit 2865a8fb44cc32420407362cbda80c10fa09c6b2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3398,6 +3398,12 @@ static void copy_workqueue_attrs(struct
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
@@ -3565,6 +3571,12 @@ static struct worker_pool *get_unbound_p
 	lockdep_set_subclass(&pool->lock, 1);	/* see put_pwq() */
 	copy_workqueue_attrs(pool->attrs, attrs);
 
+	/*
+	 * no_numa isn't a worker_pool attribute, always clear it.  See
+	 * 'struct workqueue_attrs' comments for detail.
+	 */
+	pool->attrs->no_numa = false;
+
 	/* if cpumask is contained inside a NUMA node, we belong to that node */
 	if (wq_numa_enabled) {
 		for_each_node(node) {


