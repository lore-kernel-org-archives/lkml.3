Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598AbaJDAGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:06:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbaJCVxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Mike Anderson <mike.anderson@us.ibm.com>,
        Oleg Nesterov <onestero@redhat.com>,
        Gustavo Luiz Duarte <gduarte@redhat.com>,
        Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 3.16 244/357] workqueue: apply __WQ_ORDERED to create_singlethread_workqueue()
Date: Fri,  3 Oct 2014 14:30:30 -0700
Message-Id: <20141003212940.833076973@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/workqueue.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -419,7 +419,7 @@ __alloc_workqueue_key(const char *fmt, u
 	alloc_workqueue("%s", WQ_FREEZABLE | WQ_UNBOUND | WQ_MEM_RECLAIM, \
 			1, (name))
 #define create_singlethread_workqueue(name)				\
-	alloc_workqueue("%s", WQ_UNBOUND | WQ_MEM_RECLAIM, 1, (name))
+	alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, name)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 


