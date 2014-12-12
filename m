Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965817AbaLLKQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:16:12 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:30395 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965746AbaLLKQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:16:10 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44952084"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 1/5] workqueue: fix memory leak in wq_numa_init()
Date: Fri, 12 Dec 2014 18:19:51 +0800
Message-ID: <1418379595-6281-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wq_numa_init() will quit directly on some bonkers cases without freeing the
memory.  Add the missing cleanup code.

Cc: Tejun Heo <tj@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Gu, Zheng" <guz.fnst@cn.fujitsu.com>
Cc: tangchen <tangchen@cn.fujitsu.com>
Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 09b685d..a6fd2b8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4811,6 +4811,9 @@ static void __init wq_numa_init(void)
 		if (WARN_ON(node == NUMA_NO_NODE)) {
 			pr_warn("workqueue: NUMA node mapping not available for cpu%d, disabling NUMA support\n", cpu);
 			/* happens iff arch is bonkers, let's just proceed */
+			for_each_node(node)
+				free_cpumask_var(tbl[node]);
+			kfree(tbl);
 			return;
 		}
 		cpumask_set_cpu(cpu, tbl[node]);
-- 
1.7.4.4

