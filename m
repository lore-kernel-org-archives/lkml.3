Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3FNVdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:33:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34522 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab3FNVdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:33:40 -0400
Date: Fri, 14 Jun 2013 14:33:25 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-9c80560654a3fb62ec3b3529ddcf85317537ff85@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, penberg@kernel.org, jacob.shin@amd.com,
        tangchen@cn.fujitsu.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, jacob.shin@amd.com,
        tangchen@cn.fujitsu.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1371128589-8953-19-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-19-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm, numa: Add early_initmem_init() stub
Git-Commit-ID: 9c80560654a3fb62ec3b3529ddcf85317537ff85
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 14 Jun 2013 14:33:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c80560654a3fb62ec3b3529ddcf85317537ff85
Gitweb:     http://git.kernel.org/tip/9c80560654a3fb62ec3b3529ddcf85317537ff85
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 21:03:05 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jun 2013 14:05:11 -0700

x86, mm, numa: Add early_initmem_init() stub

Introduce early_initmem_init() to call early_x86_numa_init(),
which will be used to parse numa info earlier.

Later will call init_mem_mapping for all the nodes.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371128589-8953-19-git-send-email-tangchen@cn.fujitsu.com
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
index d11b1b7..301165e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1162,6 +1162,7 @@ void __init setup_arch(char **cmdline_p)
 
 	early_acpi_boot_init();
 
+	early_initmem_init();
 	initmem_init();
 	memblock_find_dma_reserve();
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 8554656..3c21f16 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -467,6 +467,12 @@ void __init init_mem_mapping(void)
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
index 630e09f..7d76936 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -665,13 +665,16 @@ static void __init early_x86_numa_init(void)
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
