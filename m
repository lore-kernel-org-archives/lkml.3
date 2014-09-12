Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaILTxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:53:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbaILTxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:53:41 -0400
Date: Sat, 13 Sep 2014 04:53:29 +0900
From: Tejun Heo <theo@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Cc: Gustavo Luiz Duarte <gduarte@redhat.com>,
        Mike Anderson <mike.anderson@us.ibm.com>,
        Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH wq/for-3.18] workqueue: apply __WQ_ORDERED to
 create_singlethread_workqueue()
Message-ID: <20140912195328.GA23756@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e141deffe6a30cfe7dd6ad97f21afa85b80ca3ac Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Sat, 13 Sep 2014 04:14:30 +0900

create_singlethread_workqueue() is a compat interface for singled
threaded workqueue which maps to ordered workqueue w/ rescuer in the
current implementation.  create_singlethread_workqueue() currently
implemented by invoking alloc_workqueue() w/ appropriate parameters.

8719dceae2f9 ("workqueue: reject adjusting max_active or applying
attrs to ordered workqueues") introduced __WQ_ORDERED to protect
ordered workqueues against dynamic attribute changes which can break
ordering guarantees but forgot to apply it to
create_singlethread_workqueue().  While this can be potentially
dangerous, this isn't a problem in practice given the existing uses of
dynamic attribute changes.

Let's make create_singlethread_workqueue() wrap
alloc_ordered_workqueue() instead so that it inherits __WQ_ORDERED and
can implicitly track future ordered_workqueue changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Mike Anderson <mike.anderson@us.ibm.com>
Cc: Gustavo Luiz Duarte <gduarte@redhat.com>
Cc: Tomas Henzl <thenzl@redhat.com>
---
Applied to wq/for-3.18.

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

