Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab3IEFM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 01:12:59 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:44508 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab3IEFM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 01:12:58 -0400
From: Libin <huawei.libin@huawei.com>
To: <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <wangyijing@huawei.com>,
        <guohanjun@huawei.com>, <wujianguo@huawei.com>
Subject: [PATCH] workqueue: fix ordered workqueue in multi NUMA nodes platform
Date: Thu, 5 Sep 2013 13:10:44 +0800
Message-ID: <1378357844-15632-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In platform with multi NUMA nodes, there is no ordering guarantee
with the workqueue created by calling alloc_ordered_workqueue().

Add member ordered_pwq in structure workqueue_struct, used to hold
the first choice of pwq, in order to avoid breaking its ordering
guarantee under enqueueing work in different NUMA nodes.

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 kernel/workqueue.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 29b7985..42c6c29 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -249,6 +249,7 @@ struct workqueue_struct {
 
 	struct workqueue_attrs	*unbound_attrs;	/* WQ: only for unbound wqs */
 	struct pool_workqueue	*dfl_pwq;	/* WQ: only for unbound wqs */
+	struct pool_workqueue   *ordered_pwq;   /* WQ: only for ordered wqs */
 
 #ifdef CONFIG_SYSFS
 	struct wq_device	*wq_dev;	/* I: for sysfs interface */
@@ -1326,10 +1327,19 @@ retry:
 
 	/* pwq which will be used unless @work is executing elsewhere */
 	if (!(wq->flags & WQ_UNBOUND))
-		pwq = per_cpu_ptr(wq->cpu_pwqs, cpu);
-	else
-		pwq = unbound_pwq_by_node(wq, cpu_to_node(cpu));
+	    pwq = per_cpu_ptr(wq->cpu_pwqs, cpu);
+	else {
+	    pwq = unbound_pwq_by_node(wq, cpu_to_node(cpu));
+	    if (wq->flags & __WQ_ORDERED) {
+		mutex_lock(&wq->mutex);
+		if (wq->ordered_pwq == NULL)
+		    wq->ordered_pwq = pwq;
+		else
+		    pwq = wq->ordered_pwq;
+		mutex_unlock(&wq->mutex);
+	    }
 
+	}
 	/*
 	 * If @work was previously on a different pool, it might still be
 	 * running there, in which case the work needs to be queued on that
-- 
1.8.2.1


