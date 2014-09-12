Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaILUYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:24:32 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:53718 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaILUYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:24:30 -0400
Date: Sat, 13 Sep 2014 05:24:25 +0900
From: Tejun Heo <tj@kernel.org>
To: Tejun Heo <theo@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Gustavo Luiz Duarte <gduarte@redhat.com>,
        Mike Anderson <mike.anderson@us.ibm.com>,
        Tomas Henzl <thenzl@redhat.com>,
        "\"workqueue: implement NUMA affinity for unbound workqueues\"" 
	<4c16bd327c@mtj.dyndns.org>
Subject: [PATCH v2 wq/for-3.17-fixes] workqueue: apply __WQ_ORDERED to
 create_singlethread_workqueue()
Message-ID: <20140912202425.GF6298@mtj.dyndns.org>
References: <20140912195328.GA23756@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140912195328.GA23756@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e09c2c295468476a239d13324ce9042ec4de05eb Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Sat, 13 Sep 2014 04:14:30 +0900

create_singlethread_workqueue() is a compat interface for single
threaded workqueue which maps to ordered workqueue w/ rescuer in the
current implementation.  create_singlethread_workqueue() currently
implemented by invoking alloc_workqueue() w/ appropriate parameters.

8719dceae2f9 ("workqueue: reject adjusting max_active or applying
attrs to ordered workqueues") introduced __WQ_ORDERED to protect
ordered workqueues against dynamic attribute changes which can break
ordering guarantees but forgot to apply it to
create_singlethread_workqueue().  This in itself is okay as nobody
currently uses dynamic attribute change on workqueues created with
create_singlethread_workqueue().

However, 4c16bd327c ("workqueue: implement NUMA affinity for unbound
workqueues") broke singlethreaded guarantee for ordered workqueues
through allocating a separate pool_workqueue on each NUMA node by
default.  A later change 8a2b75384444 ("workqueue: fix ordered
workqueues in NUMA setups") fixed it by allocating only one global
pool_workqueue if __WQ_ORDERED is set.

Combined, the __WQ_ORDERED omission in create_singlethread_workqueue()
became critical breaking its single threadedness and ordering
guarantee.

Let's make create_singlethread_workqueue() wrap
alloc_ordered_workqueue() instead so that it inherits __WQ_ORDERED and
can implicitly track future ordered_workqueue changes.

v2: I missed that __WQ_ORDERED now protects against pwq splitting
    across NUMA nodes and incorrectly described the patch as a
    nice-to-have fix to protect against future dynamic attribute
    usages.  Oleg pointed out that this is actually a critical
    breakage due to 8a2b75384444 ("workqueue: fix ordered workqueues
    in NUMA setups").

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Mike Anderson <mike.anderson@us.ibm.com>
Cc: Oleg Nesterov <onestero@redhat.com>
Cc: Gustavo Luiz Duarte <gduarte@redhat.com>
Cc: Tomas Henzl <thenzl@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 4c16bd327c ("workqueue: implement NUMA affinity for unbound workqueues")
---
Applied to wq/for-3.17-fixes.

Thanks.

 include/linux/workqueue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index a0cc2e9..b996e6cd 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -419,7 +419,7 @@ __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
 	alloc_workqueue("%s", WQ_FREEZABLE | WQ_UNBOUND | WQ_MEM_RECLAIM, \
 			1, (name))
 #define create_singlethread_workqueue(name)				\
-	alloc_workqueue("%s", WQ_UNBOUND | WQ_MEM_RECLAIM, 1, (name))
+	alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, name)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
-- 
1.9.3

