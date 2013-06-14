Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3FNVdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:33:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34509 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab3FNVda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:33:30 -0400
Date: Fri, 14 Jun 2013 14:33:16 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-f8e2d4e7235c816cf0a23aa2d32c57c0d4f8a3f2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tony.luck@intel.com, fenghua.yu@intel.com,
        tangchen@cn.fujitsu.com, tglx@linutronix.de, hpa@linux.intel.com,
        rjw@sisk.pl
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tony.luck@intel.com, fenghua.yu@intel.com,
        tangchen@cn.fujitsu.com, tglx@linutronix.de, rjw@sisk.pl,
        hpa@linux.intel.com
In-Reply-To: <1371128589-8953-18-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-18-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, ACPI, numa, ia64: split SLIT handling out
Git-Commit-ID: f8e2d4e7235c816cf0a23aa2d32c57c0d4f8a3f2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 14 Jun 2013 14:33:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f8e2d4e7235c816cf0a23aa2d32c57c0d4f8a3f2
Gitweb:     http://git.kernel.org/tip/f8e2d4e7235c816cf0a23aa2d32c57c0d4f8a3f2
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 21:03:04 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jun 2013 14:05:08 -0700

x86, ACPI, numa, ia64: split SLIT handling out

We need to handle slit later, as it need to allocate buffer for distance
matrix. Also we do not need SLIT info before init_mem_mapping. So move
SLIT parsing procedure later.

x86_acpi_numa_init() will be splited into x86_acpi_numa_init_srat() and
x86_acpi_numa_init_slit().

It should not break ia64 by replacing acpi_numa_init with
acpi_numa_init_srat/acpi_numa_init_slit/acpi_num_arch_fixup.

-v2: Change name to acpi_numa_init_srat/acpi_numa_init_slit according tj.
     remove the reset_numa_distance() in numa_init(), as get we only set
     distance in slit handling.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371128589-8953-18-git-send-email-tangchen@cn.fujitsu.com
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
Tested-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/ia64/kernel/setup.c    |  4 +++-
 arch/x86/include/asm/acpi.h |  3 ++-
 arch/x86/mm/numa.c          | 14 ++++++++++++--
 arch/x86/mm/srat.c          | 11 +++++++----
 drivers/acpi/numa.c         | 13 +++++++------
 include/linux/acpi.h        |  3 ++-
 6 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index 13bfdd2..5f7db4a 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -558,7 +558,9 @@ setup_arch (char **cmdline_p)
 	acpi_table_init();
 	early_acpi_boot_init();
 # ifdef CONFIG_ACPI_NUMA
-	acpi_numa_init();
+	acpi_numa_init_srat();
+	acpi_numa_init_slit();
+	acpi_numa_arch_fixup();
 #  ifdef CONFIG_ACPI_HOTPLUG_CPU
 	prefill_possible_map();
 #  endif
diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index b31bf97..651db0b 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -178,7 +178,8 @@ static inline void disable_acpi(void) { }
 
 #ifdef CONFIG_ACPI_NUMA
 extern int acpi_numa;
-extern int x86_acpi_numa_init(void);
+int x86_acpi_numa_init_srat(void);
+void x86_acpi_numa_init_slit(void);
 #endif /* CONFIG_ACPI_NUMA */
 
 #define acpi_unlazy_tlb(x)	leave_mm(x)
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 3254f22..630e09f 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -595,7 +595,6 @@ static int __init numa_init(int (*init_func)(void))
 
 	nodes_clear(numa_nodes_parsed);
 	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
-	numa_reset_distance();
 
 	ret = init_func();
 	if (ret < 0)
@@ -633,6 +632,10 @@ static int __init dummy_numa_init(void)
 	return 0;
 }
 
+#ifdef CONFIG_ACPI_NUMA
+static bool srat_used __initdata;
+#endif
+
 /**
  * x86_numa_init - Initialize NUMA
  *
@@ -648,8 +651,10 @@ static void __init early_x86_numa_init(void)
 			return;
 #endif
 #ifdef CONFIG_ACPI_NUMA
-		if (!numa_init(x86_acpi_numa_init))
+		if (!numa_init(x86_acpi_numa_init_srat)) {
+			srat_used = true;
 			return;
+		}
 #endif
 #ifdef CONFIG_AMD_NUMA
 		if (!numa_init(amd_numa_init))
@@ -667,6 +672,11 @@ void __init x86_numa_init(void)
 
 	early_x86_numa_init();
 
+#ifdef CONFIG_ACPI_NUMA
+	if (srat_used)
+		x86_acpi_numa_init_slit();
+#endif
+
 	numa_emulation(&numa_meminfo, numa_distance_cnt);
 
 	node_possible_map = numa_nodes_parsed;
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index cdd0da9..443f9ef 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -185,14 +185,17 @@ out_err:
 	return -1;
 }
 
-void __init acpi_numa_arch_fixup(void) {}
-
-int __init x86_acpi_numa_init(void)
+int __init x86_acpi_numa_init_srat(void)
 {
 	int ret;
 
-	ret = acpi_numa_init();
+	ret = acpi_numa_init_srat();
 	if (ret < 0)
 		return ret;
 	return srat_disabled() ? -EINVAL : 0;
 }
+
+void __init x86_acpi_numa_init_slit(void)
+{
+	acpi_numa_init_slit();
+}
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 33e609f..6460db4 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -282,7 +282,7 @@ acpi_table_parse_srat(enum acpi_srat_type id,
 					    handler, max_entries);
 }
 
-int __init acpi_numa_init(void)
+int __init acpi_numa_init_srat(void)
 {
 	int cnt = 0;
 
@@ -303,11 +303,6 @@ int __init acpi_numa_init(void)
 					    NR_NODE_MEMBLKS);
 	}
 
-	/* SLIT: System Locality Information Table */
-	acpi_table_parse(ACPI_SIG_SLIT, acpi_parse_slit);
-
-	acpi_numa_arch_fixup();
-
 	if (cnt < 0)
 		return cnt;
 	else if (!parsed_numa_memblks)
@@ -315,6 +310,12 @@ int __init acpi_numa_init(void)
 	return 0;
 }
 
+void __init acpi_numa_init_slit(void)
+{
+	/* SLIT: System Locality Information Table */
+	acpi_table_parse(ACPI_SIG_SLIT, acpi_parse_slit);
+}
+
 int acpi_get_pxm(acpi_handle h)
 {
 	unsigned long long pxm;
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 4e3731b..92463b5 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -85,7 +85,8 @@ int early_acpi_boot_init(void);
 int acpi_boot_init (void);
 void acpi_boot_table_init (void);
 int acpi_mps_check (void);
-int acpi_numa_init (void);
+int acpi_numa_init_srat(void);
+void acpi_numa_init_slit(void);
 
 int acpi_table_init (void);
 int acpi_table_parse(char *id, acpi_tbl_table_handler handler);
