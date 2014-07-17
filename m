Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371AbaGQXKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:10:12 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50695 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329AbaGQXKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:10:10 -0400
Date: Thu, 17 Jul 2014 16:09:58 -0700
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: benh@kernel.crashing.org
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 1/2] workqueue: use the nearest NUMA node, not the local one
Message-ID: <20140717230958.GB32660@linux.vnet.ibm.com>
References: <20140717230923.GA32660@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717230923.GA32660@linux.vnet.ibm.com>
X-Operating-System: Linux 3.13.0-30-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071723-1344-0000-0000-000002E7275A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the presence of memoryless nodes, the workqueue code incorrectly uses
cpu_to_node() to determine what node to prefer memory allocations come
from. cpu_to_mem() should be used instead, which will use the nearest
NUMA node with memory.

Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 35974ac..0bba022 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3547,7 +3547,12 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 		for_each_node(node) {
 			if (cpumask_subset(pool->attrs->cpumask,
 					   wq_numa_possible_cpumask[node])) {
-				pool->node = node;
+				/*
+				 * We could use local_memory_node(node) here,
+				 * but it is expensive and the following caches
+				 * the same value.
+				 */
+				pool->node = cpu_to_mem(cpumask_first(pool->attrs->cpumask));
 				break;
 			}
 		}
@@ -4921,7 +4926,7 @@ static int __init init_workqueues(void)
 			pool->cpu = cpu;
 			cpumask_copy(pool->attrs->cpumask, cpumask_of(cpu));
 			pool->attrs->nice = std_nice[i++];
-			pool->node = cpu_to_node(cpu);
+			pool->node = cpu_to_mem(cpu);
 
 			/* alloc pool ID */
 			mutex_lock(&wq_pool_mutex);

