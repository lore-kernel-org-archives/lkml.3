Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbaJIVbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:31:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59333 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560AbaJIVJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <onestero@redhat.com>,
        Gustavo Luiz Duarte <gduarte@redhat.com>,
        Tomas Henzl <thenzl@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 119/163] workqueue: apply __WQ_ORDERED to create_singlethread_workqueue()
Date: Thu,  9 Oct 2014 14:02:24 -0700
Message-Id: <1412888588-26755-120-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit e09c2c295468476a239d13324ce9042ec4de05eb upstream.

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
Fixes: 4c16bd327c ("workqueue: implement NUMA affinity for unbound workqueues")
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/workqueue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 594521b..eff358e 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -455,7 +455,7 @@ __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
 	alloc_workqueue("%s", WQ_FREEZABLE | WQ_UNBOUND | WQ_MEM_RECLAIM, \
 			1, (name))
 #define create_singlethread_workqueue(name)				\
-	alloc_workqueue("%s", WQ_UNBOUND | WQ_MEM_RECLAIM, 1, (name))
+	alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, name)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
-- 
1.9.1

