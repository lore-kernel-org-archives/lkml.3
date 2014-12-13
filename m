Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbaLMQfh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 11:35:37 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37749 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbaLMQfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 11:35:36 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <548C6ACD.4090609@jp.fujitsu.com>
Date: Sun, 14 Dec 2014 01:35:25 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>
Subject: [PATCH 3/4] workqueue: remove per-node unbound pool when node goes
 offline.
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com> <548C68DA.20507@jp.fujitsu.com>
In-Reply-To: <548C68DA.20507@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove node aware unbound pools if node goes offline.

scan unbound workqueue and remove numa affine pool when
a node goes offline.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 kernel/workqueue.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 35f4f00..07b4eb5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4921,11 +4921,40 @@ early_initcall(init_workqueues);
  * cached pools per cpu should be freed at node unplug
  */
 
+/*
+ * Replace per-node pwq with dfl_pwq because this node disappers.
+ * The new pool will be set at CPU_ONLINE by wq_update_unbound_numa.
+ */
+static void wq_release_unbound_numa(struct workqueue_struct *wq, int nid)
+{
+	struct pool_workqueue *old_pwq = NULL;
+
+	if (!wq_numa_enabled || !(wq->flags & WQ_UNBOUND))
+		return;
+	mutex_lock(&wq->mutex);
+	if (wq->unbound_attrs->no_numa)
+		goto out_unlock;
+	spin_lock_irq(&wq->dfl_pwq->pool->lock);
+	get_pwq(wq->dfl_pwq);
+	spin_unlock_irq(&wq->dfl_pwq->pool->lock);
+	old_pwq = numa_pwq_tbl_install(wq, nid, wq->dfl_pwq);
+out_unlock:
+	mutex_unlock(&wq->mutex);
+	put_pwq_unlocked(old_pwq);
+	return;
+}
+
 void workqueue_register_numanode(int nid)
 {
 }
  
 void workqueue_unregister_numanode(int nid)
 {
+	struct workqueue_struct *wq;
+
+	mutex_lock(&wq_pool_mutex);
+	list_for_each_entry(wq, &workqueues, list)
+		wq_release_unbound_numa(wq, nid);
+	mutex_unlock(&wq_pool_mutex);
 }
 #endif
-- 
1.8.3.1



