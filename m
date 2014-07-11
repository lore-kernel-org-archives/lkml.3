Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaGKHhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:37:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:37272 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbaGKHhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:37:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,642,1400050800"; 
   d="scan'208";a="571590155"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [RFC Patch V1 25/30] mm, x86, kvm: Use cpu_to_mem()/numa_mem_id() to support memoryless node
Date: Fri, 11 Jul 2014 15:37:42 +0800
Message-Id: <1405064267-11678-26-git-send-email-jiang.liu@linux.intel.com>
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
 arch/x86/kvm/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 801332edefc3..beb7c6d5d51b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2964,7 +2964,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 
 static struct vmcs *alloc_vmcs_cpu(int cpu)
 {
-	int node = cpu_to_node(cpu);
+	int node = cpu_to_mem(cpu);
 	struct page *pages;
 	struct vmcs *vmcs;
 
-- 
1.7.10.4

