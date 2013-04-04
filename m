Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765566Ab3DDXtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:49:46 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32245 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765429Ab3DDXsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:48:03 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH v3 18/22] x86, mm, numa: Add early_initmem_init() stub
Date: Thu,  4 Apr 2013 16:46:22 -0700
Message-Id: <1365119186-23487-19-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

early_initmem_init() call early_x86_numa_init() to parse numa info early.

Later will call init_mem_mapping for nodes in it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/include/asm/page_types.h | 1 +
 arch/x86/kernel/setup.c           | 1 +
 arch/x86/mm/init.c                | 6 ++++++
 arch/x86/mm/numa.c                | 7 +++++--
 4 files changed, 13 insertions(+), 2 deletions(-)

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
index 2d29bc0..d40e16e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1135,6 +1135,7 @@ void __init setup_arch(char **cmdline_p)
 
 	early_acpi_boot_init();
 
+	early_initmem_init();
 	initmem_init();
 	memblock_find_dma_reserve();
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index abcc241..28b294f 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -450,6 +450,12 @@ void __init init_mem_mapping(void)
 	early_memtest(0, max_pfn_mapped << PAGE_SHIFT);
 }
 
+#ifndef CONFIG_NUMA
+void __init early_initmem_init(void)
+{
+}
+#endif
+
 /*
  * devmem_is_allowed() checks to see if /dev/mem access to a certain address
  * is valid. The argument is a physical page number.
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 182e085..c2d4653 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -668,13 +668,16 @@ static void __init early_x86_numa_init(void)
 	numa_init(dummy_numa_init);
 }
 
+void __init early_initmem_init(void)
+{
+	early_x86_numa_init();
+}
+
 void __init x86_numa_init(void)
 {
 	int i, nid;
 	struct numa_meminfo *mi = &numa_meminfo;
 
-	early_x86_numa_init();
-
 #ifdef CONFIG_ACPI_NUMA
 	if (srat_used)
 		x86_acpi_numa_init_slit();
-- 
1.8.1.4

