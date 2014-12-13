Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaLMQaf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 11:30:35 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53633 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbaLMQad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 11:30:33 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <548C699D.7080208@jp.fujitsu.com>
Date: Sun, 14 Dec 2014 01:30:21 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>
Subject: [PATCH 1/4] workqueue: add a hook for node hotplug
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com> <548C68DA.20507@jp.fujitsu.com>
In-Reply-To: <548C68DA.20507@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 1/4] add callbackof node hotplug for workqueue.

Because workqueue is numa aware, it pool has node information.
And it should be maintained against node-hotplug.

When a node which exists at boot is unpluged, following error
is detected.
==
SLUB: Unable to allocate memory on node 2 (gfp=0x80d0)
  cache: kmalloc-192, object size: 192, buffer size: 192, default order: 1, min order: 0
  node 0: slabs: 6172, objs: 259224, free: 245741
  node 1: slabs: 3261, objs: 136962, free: 127656
==
This is because pool->node points a stale node.

This patch adds callback function at node hotplug.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com
---
 include/linux/workqueue.h |  6 ++++++
 kernel/workqueue.c        | 18 ++++++++++++++++++
 mm/memory_hotplug.c       |  9 +++++++--
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index b996e6cd..3f2b40b 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -591,4 +591,10 @@ static inline int workqueue_sysfs_register(struct workqueue_struct *wq)
 { return 0; }
 #endif	/* CONFIG_SYSFS */
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+/* notify node hotplug event when pgdat is created/removed */
+void workqueue_register_numanode(int node);
+void workqueue_unregister_numanode(int node);
+#endif
+
 #endif
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 09b685d..f6cb357c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4901,3 +4901,21 @@ static int __init init_workqueues(void)
 	return 0;
 }
 early_initcall(init_workqueues);
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+/*
+ * If a node itself is hot-unpluged by memory hotplug, it's guaranteed that
+ * there are no online cpus on the node. After a node unplug, it's not
+ * guaranteed that a cpuid of newly added by hot-add is tied to a node id
+ * which was determined before node unplug. pool->node should be cleared and
+ * cached pools per cpu should be freed at node unplug
+ */
+
+void workqueue_register_numanode(int nid)
+{
+}
+ 
+void workqueue_unregister_numanode(int nid)
+{
+}
+#endif
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 1bf4807..504b071 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1162,7 +1162,8 @@ int try_online_node(int nid)
 		build_all_zonelists(NULL, NULL);
 		mutex_unlock(&zonelists_mutex);
 	}
-
+	/* Now zonelist for the pgdat is ready */
+	workqueue_register_numanode(nid);
 out:
 	mem_hotplug_done();
 	return ret;
@@ -1914,7 +1915,11 @@ static int check_and_unmap_cpu_on_node(pg_data_t *pgdat)
 	ret = check_cpu_on_node(pgdat);
 	if (ret)
 		return ret;
-
+	/*
+	 * There is no online cpu on the node and this node will go.
+	 * make workqueue to forget this node.
+	 */
+	workqueue_unregister_numanode(pgdat->node_id);
 	/*
 	 * the node will be offlined when we come here, so we can clear
 	 * the cpu_to_node() now.
-- 
1.8.3.1



