Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966016AbaLLKQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:16:27 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:51296 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965950AbaLLKQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:16:23 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44952106"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 4/5] workqueue: update NUMA affinity for the node lost CPU
Date: Fri, 12 Dec 2014 18:19:54 +0800
Message-ID: <1418379595-6281-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We fixed the major cases when the numa mapping is changed.

We still have the assumption that when the node<->cpu mapping is changed
the original node is offline, and the current code of memory-hutplug also
prove this.

This assumption might be changed in future and the orig_node is still online
in some cases.  And in these cases, the cpumask of the pwqs of the orig_node
still contains the onlining CPU which is a CPU of another node, and the worker
may run on the onlining CPU (aka run on the wrong node).

So we drop this assumption and make the code calls wq_update_unbound_numa()
to update the affinity in this case.

Cc: Tejun Heo <tj@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Gu, Zheng" <guz.fnst@cn.fujitsu.com>
Cc: tangchen <tangchen@cn.fujitsu.com>
Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7fbabf6..29a96c3 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4007,6 +4007,21 @@ static void wq_update_numa_mapping(int cpu)
 		if (pool->node != node)
 			pool->node = node;
 	}
+
+	/* Test whether we hit the case where orig_node is still online */
+	if (orig_node != NUMA_NO_NODE &&
+	    !cpumask_empty(cpumask_of_node(orig_node))) {
+		struct workqueue_struct *wq;
+		cpu = cpumask_any(cpumask_of_node(orig_node));
+
+		/*
+		 * the pwqs of the orig_node are still allowed on the onlining
+		 * CPU but which is belong to new_node, update NUMA affinity
+		 * for orig_node.
+		 */
+		list_for_each_entry(wq, &workqueues, list)
+			wq_update_unbound_numa(wq, cpu, true);
+	}
 }
 
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
-- 
1.7.4.4

