Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750988Ab3CHFAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:00:05 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51090 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933513Ab3CHFAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 00:00:00 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 12/14] x86, mm, numa: Add early_initmem_init() stub
Date: Thu,  7 Mar 2013 20:58:38 -0800
Message-Id: <1362718720-27048-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

early_initmem_init() will call early_x86_numa_init().

later will call init_mem_mapping for nodes in it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/include/asm/page_types.h |    1 +
 arch/x86/kernel/setup.c           |    1 +
 arch/x86/mm/init_32.c             |    3 +++
 arch/x86/mm/init_64.c             |    3 +++
 arch/x86/mm/numa.c                |   23 +++++++++++++++--------
 5 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index b012b82..d04dd8c 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -55,6 +55,7 @@ bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn);
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
+void early_initmem_init(void);
 extern void initmem_init(void);
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d43545a..c4f1c63 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1133,6 +1133,7 @@ void __init setup_arch(char **cmdline_p)
 
 	early_acpi_boot_init();
 
+	early_initmem_init();
 	initmem_init();
 	memblock_find_dma_reserve();
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 2d19001..3801962 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -660,6 +660,9 @@ void __init find_low_pfn_range(void)
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
+void __init early_initmem_init(void)
+{
+}
 void __init initmem_init(void)
 {
 #ifdef CONFIG_HIGHMEM
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 474e28f..218a4e5 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -640,6 +640,9 @@ kernel_physical_mapping_init(unsigned long start,
 }
 
 #ifndef CONFIG_NUMA
+void __init early_initmem_init(void)
+{
+}
 void __init initmem_init(void)
 {
 	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, 0);
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 23ec6ba..643b39a 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -651,31 +651,38 @@ static bool srat_used __initdata;
  * last fallback is dummy single node config encomapssing whole memory and
  * never fails.
  */
-void __init x86_numa_init(void)
+static void __init early_x86_numa_init(void)
 {
-	int i, nid;
-	struct numa_meminfo *mi = &numa_meminfo;
-
 	if (!numa_off) {
 #ifdef CONFIG_X86_NUMAQ
 		if (!numa_init(numaq_numa_init))
-			goto out;
+			return;
 #endif
 #ifdef CONFIG_ACPI_NUMA
 		if (!numa_init(x86_acpi_numa_init_no_slit)) {
 			srat_used = true;
-			goto out;
+			return;
 		}
 #endif
 #ifdef CONFIG_AMD_NUMA
 		if (!numa_init(amd_numa_init))
-			goto out;
+			return;
 #endif
 	}
 
 	numa_init(dummy_numa_init);
+}
+
+void __init early_initmem_init(void)
+{
+	early_x86_numa_init();
+}
+
+void __init x86_numa_init(void)
+{
+	int i, nid;
+	struct numa_meminfo *mi = &numa_meminfo;
 
-out:
 #ifdef CONFIG_ACPI_NUMA
 	if (srat_used)
 		x86_acpi_numa_init_only_slit();
-- 
1.7.10.4

