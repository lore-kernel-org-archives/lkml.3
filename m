Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab3CHFDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:03:13 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43478 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759432Ab3CHE7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:59:46 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Subject: [PATCH 11/14] x86, acpi, numa: split SLIT handling out
Date: Thu,  7 Mar 2013 20:58:37 -0800
Message-Id: <1362718720-27048-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to handle slit later, as it need to allocate buffer.

Also we only need srat info before init_mem_mapping.

x86_acpi_numa_init become x86_acpi_numa_init_only_slit
x86_acpi_numa_init_no_slit.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
---
 arch/x86/include/asm/acpi.h |    3 ++-
 arch/x86/mm/numa.c          |   13 ++++++++++++-
 arch/x86/mm/srat.c          |    8 ++++++--
 drivers/acpi/numa.c         |   22 +++++++++++++++++++---
 include/linux/acpi.h        |    2 ++
 5 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index b31bf97..9f171a7 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -178,7 +178,8 @@ static inline void disable_acpi(void) { }
 
 #ifdef CONFIG_ACPI_NUMA
 extern int acpi_numa;
-extern int x86_acpi_numa_init(void);
+int x86_acpi_numa_init_no_slit(void);
+void x86_acpi_numa_init_only_slit(void);
 #endif /* CONFIG_ACPI_NUMA */
 
 #define acpi_unlazy_tlb(x)	leave_mm(x)
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index ace0370..23ec6ba 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -640,6 +640,10 @@ static int __init dummy_numa_init(void)
 	return 0;
 }
 
+#ifdef CONFIG_ACPI_NUMA
+static bool srat_used __initdata;
+#endif
+
 /**
  * x86_numa_init - Initialize NUMA
  *
@@ -658,8 +662,10 @@ void __init x86_numa_init(void)
 			goto out;
 #endif
 #ifdef CONFIG_ACPI_NUMA
-		if (!numa_init(x86_acpi_numa_init))
+		if (!numa_init(x86_acpi_numa_init_no_slit)) {
+			srat_used = true;
 			goto out;
+		}
 #endif
 #ifdef CONFIG_AMD_NUMA
 		if (!numa_init(amd_numa_init))
@@ -670,6 +676,11 @@ void __init x86_numa_init(void)
 	numa_init(dummy_numa_init);
 
 out:
+#ifdef CONFIG_ACPI_NUMA
+	if (srat_used)
+		x86_acpi_numa_init_only_slit();
+#endif
+
 	numa_emulation(&numa_meminfo, numa_distance_cnt);
 
 	for (i = 0; i < mi->nr_blks; i++) {
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index cdd0da9..47a62b2 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -187,11 +187,15 @@ out_err:
 
 void __init acpi_numa_arch_fixup(void) {}
 
-int __init x86_acpi_numa_init(void)
+void __init x86_acpi_numa_init_only_slit(void)
+{
+	acpi_numa_init_only_slit();
+}
+int __init x86_acpi_numa_init_no_slit(void)
 {
 	int ret;
 
-	ret = acpi_numa_init();
+	ret = acpi_numa_init_no_slit();
 	if (ret < 0)
 		return ret;
 	return srat_disabled() ? -EINVAL : 0;
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 33e609f..2215718 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -282,7 +282,13 @@ acpi_table_parse_srat(enum acpi_srat_type id,
 					    handler, max_entries);
 }
 
-int __init acpi_numa_init(void)
+void __init acpi_numa_init_only_slit(void)
+{
+	/* SLIT: System Locality Information Table */
+	acpi_table_parse(ACPI_SIG_SLIT, acpi_parse_slit);
+}
+
+static int __init __acpi_numa_init(bool with_slit)
 {
 	int cnt = 0;
 
@@ -303,8 +309,8 @@ int __init acpi_numa_init(void)
 					    NR_NODE_MEMBLKS);
 	}
 
-	/* SLIT: System Locality Information Table */
-	acpi_table_parse(ACPI_SIG_SLIT, acpi_parse_slit);
+	if (with_slit)
+		acpi_numa_init_only_slit();
 
 	acpi_numa_arch_fixup();
 
@@ -315,6 +321,16 @@ int __init acpi_numa_init(void)
 	return 0;
 }
 
+int __init acpi_numa_init(void)
+{
+	return __acpi_numa_init(true);
+}
+
+int __init acpi_numa_init_no_slit(void)
+{
+	return __acpi_numa_init(false);
+}
+
 int acpi_get_pxm(acpi_handle h)
 {
 	unsigned long long pxm;
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 46a8a89..bfd2852 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -86,6 +86,8 @@ int acpi_boot_init (void);
 void acpi_boot_table_init (void);
 int acpi_mps_check (void);
 int acpi_numa_init (void);
+int acpi_numa_init_no_slit(void);
+void acpi_numa_init_only_slit(void);
 
 int acpi_table_init (void);
 int acpi_table_parse(char *id, acpi_tbl_table_handler handler);
-- 
1.7.10.4

