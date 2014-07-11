Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaGKHhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:37:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:37329 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbaGKHhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:37:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,642,1400050800"; 
   d="scan'208";a="571590213"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Lans Zhang <jia.zhang@windriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [RFC Patch V1 27/30] x86, numa: Kill useless code to improve code readability
Date: Fri, 11 Jul 2014 15:37:44 +0800
Message-Id: <1405064267-11678-28-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to x86 boot sequence, early_cpu_to_node() always returns
NUMA_NO_NODE when called from numa_init(). So kill useless code
to improve code readability.

Related code sequence as below:
x86_cpu_to_node_map is set until step 2, so it is still the default
value (NUMA_NO_NODE) when accessed at step 1.

start_kernel()
	setup_arch()
		initmem_init()
			x86_numa_init()
				numa_init()
					early_cpu_to_node()
1)						return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
		acpi_boot_init();
		sfi_init()
		x86_dtb_init()
			generic_processor_info()
				early_per_cpu(x86_cpu_to_apicid, cpu) = apicid;
		init_cpu_to_node()
			numa_set_node(cpu, node);
2)				per_cpu(x86_cpu_to_node_map, cpu) = node;

	rest_init()
		kernel_init()
			smp_init()
				native_cpu_up()
					start_secondary()
						numa_set_node()
							per_cpu(x86_cpu_to_node_map, cpu) = node;

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/mm/numa.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index a32b706c401a..eec4f6c322bb 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -545,8 +545,6 @@ static void __init numa_init_array(void)
 
 	rr = first_node(node_online_map);
 	for (i = 0; i < nr_cpu_ids; i++) {
-		if (early_cpu_to_node(i) != NUMA_NO_NODE)
-			continue;
 		numa_set_node(i, rr);
 		rr = next_node(rr, node_online_map);
 		if (rr == MAX_NUMNODES)
@@ -633,14 +631,6 @@ static int __init numa_init(int (*init_func)(void))
 	if (ret < 0)
 		return ret;
 
-	for (i = 0; i < nr_cpu_ids; i++) {
-		int nid = early_cpu_to_node(i);
-
-		if (nid == NUMA_NO_NODE)
-			continue;
-		if (!node_online(nid))
-			numa_clear_node(i);
-	}
 	numa_init_array();
 
 	/*
-- 
1.7.10.4

