Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaGKHtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:49:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:36890 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbaGKHfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:35:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,642,1400050800"; 
   d="scan'208";a="571589403"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC Patch V1 05/30] mm, perf: Use cpu_to_mem()/numa_mem_id() to support memoryless node
Date: Fri, 11 Jul 2014 15:37:22 +0800
Message-Id: <1405064267-11678-6-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_HAVE_MEMORYLESS_NODES is enabled, cpu_to_node()/numa_node_id()
may return a node without memory, and later cause system failure/panic
when calling kmalloc_node() and friends with returned node id.
So use cpu_to_mem()/numa_mem_id() instead to get the nearest node with
memory for the/current cpu.

If CONFIG_HAVE_MEMORYLESS_NODES is disabled, cpu_to_mem()/numa_mem_id()
is the same as cpu_to_node()/numa_node_id().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 kernel/events/callchain.c   |    2 +-
 kernel/events/core.c        |    2 +-
 kernel/events/ring_buffer.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 97b67df8fbfe..09f470a9262e 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -77,7 +77,7 @@ static int alloc_callchain_buffers(void)
 
 	for_each_possible_cpu(cpu) {
 		entries->cpu_entries[cpu] = kmalloc_node(size, GFP_KERNEL,
-							 cpu_to_node(cpu));
+							 cpu_to_mem(cpu));
 		if (!entries->cpu_entries[cpu])
 			goto fail;
 	}
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a33d9a2bcbd7..bb1a5f326309 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7911,7 +7911,7 @@ static void perf_event_init_cpu(int cpu)
 	if (swhash->hlist_refcount > 0) {
 		struct swevent_hlist *hlist;
 
-		hlist = kzalloc_node(sizeof(*hlist), GFP_KERNEL, cpu_to_node(cpu));
+		hlist = kzalloc_node(sizeof(*hlist), GFP_KERNEL, cpu_to_mem(cpu));
 		WARN_ON(!hlist);
 		rcu_assign_pointer(swhash->swevent_hlist, hlist);
 	}
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 146a5792b1d2..22128f58aa0b 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -265,7 +265,7 @@ static void *perf_mmap_alloc_page(int cpu)
 	struct page *page;
 	int node;
 
-	node = (cpu == -1) ? cpu : cpu_to_node(cpu);
+	node = (cpu == -1) ? NUMA_NO_NODE : cpu_to_mem(cpu);
 	page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
 	if (!page)
 		return NULL;
-- 
1.7.10.4

