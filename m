Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934392Ab3JPMwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:52:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58801 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934006Ab3JPMwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:52:22 -0400
Subject: [PATCH v3 1/2] x86,
 apic: Add boot_cpu_is_bsp() to check if boot cpu is BSP
To: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Date: Wed, 16 Oct 2013 21:52:20 +0900
Message-ID: <20131016125220.15573.70445.stgit@localhost6.localdomain6>
In-Reply-To: <20131016125104.15573.90313.stgit@localhost6.localdomain6>
References: <20131016125104.15573.90313.stgit@localhost6.localdomain6>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kexec can enter the kdump 2nd kernel on AP if crash happens on AP. To
check if boot cpu is BSP, introduce a helper function
boot_cpu_is_bsp().

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 arch/x86/include/asm/mpspec.h |    7 +++++++
 arch/x86/kernel/apic/apic.c   |   17 +++++++++++++++++
 arch/x86/kernel/setup.c       |    2 ++
 3 files changed, 26 insertions(+)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 626cf70..54d5f98 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -47,11 +47,18 @@ extern int mp_bus_id_to_type[MAX_MP_BUSSES];
 extern DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
 
 extern unsigned int boot_cpu_physical_apicid;
+extern bool boot_cpu_is_bsp;
 extern unsigned int max_physical_apicid;
 extern int mpc_default_type;
 extern unsigned long mp_lapic_addr;
 
 #ifdef CONFIG_X86_LOCAL_APIC
+extern void boot_cpu_is_bsp_init(void);
+#else
+static inline void boot_cpu_is_bsp_init(void) { };
+#endif
+
+#ifdef CONFIG_X86_LOCAL_APIC
 extern int smp_found_config;
 #else
 # define smp_found_config 0
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a7eb82d..1433ade 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -64,6 +64,12 @@ unsigned disabled_cpus;
 unsigned int boot_cpu_physical_apicid = -1U;
 
 /*
+ * Indicates whether the processor that is doing the boot up, is BSP
+ * processor or not.
+ */
+bool boot_cpu_is_bsp = true;
+
+/*
  * The highest APIC ID seen during enumeration.
  */
 unsigned int max_physical_apicid;
@@ -2589,3 +2595,14 @@ static int __init lapic_insert_resource(void)
  * that is using request_resource
  */
 late_initcall(lapic_insert_resource);
+
+void __init boot_cpu_is_bsp_init(void)
+{
+	u32 l, h;
+
+	if (boot_cpu_data.x86 >= 6 && cpu_has_apic) {
+		rdmsr(MSR_IA32_APICBASE, l, h);
+		if (!(l & MSR_IA32_APICBASE_BSP))
+			boot_cpu_is_bsp = false;
+	}
+}
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f0de629..a30bc06 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1166,6 +1166,8 @@ void __init setup_arch(char **cmdline_p)
 
 	early_quirks();
 
+	boot_cpu_is_bsp_init();
+
 	/*
 	 * Read APIC and some other early information from ACPI tables.
 	 */

