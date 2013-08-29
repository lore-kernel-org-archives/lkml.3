Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3H2J22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:28:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47972 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3H2J2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:28:04 -0400
Subject: [PATCH 1/2] x86,
 apic: Add boot_cpu_is_bsp() to check if boot cpu is BSP
To: ebiederm@xmission.com, vgoyal@redhat.com
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, hpa@linux.intel.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, jingbai.ma@hp.com
Date: Thu, 29 Aug 2013 18:27:58 +0900
Message-ID: <20130829092758.5476.90694.stgit@localhost6.localdomain6>
In-Reply-To: <20130829092458.5476.10277.stgit@localhost6.localdomain6>
References: <20130829092458.5476.10277.stgit@localhost6.localdomain6>
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
 arch/x86/include/asm/mpspec.h |    3 +++
 arch/x86/kernel/apic/apic.c   |   14 ++++++++++++++
 arch/x86/kernel/setup.c       |    2 ++
 3 files changed, 19 insertions(+)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 626cf70..a8a4338 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -47,10 +47,13 @@ extern int mp_bus_id_to_type[MAX_MP_BUSSES];
 extern DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
 
 extern unsigned int boot_cpu_physical_apicid;
+extern bool boot_cpu_is_bsp;
 extern unsigned int max_physical_apicid;
 extern int mpc_default_type;
 extern unsigned long mp_lapic_addr;
 
+extern void boot_cpu_is_bsp_init(void);
+
 #ifdef CONFIG_X86_LOCAL_APIC
 extern int smp_found_config;
 #else
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index eca89c5..66cab35 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -64,6 +64,12 @@ unsigned disabled_cpus;
 unsigned int boot_cpu_physical_apicid = -1U;
 
 /*
+ * Indicates whether the processor that is doing the boot up, is BSP
+ * processor or not.
+ */
+bool boot_cpu_is_bsp;
+
+/*
  * The highest APIC ID seen during enumeration.
  */
 unsigned int max_physical_apicid;
@@ -2589,3 +2595,11 @@ static int __init lapic_insert_resource(void)
  * that is using request_resource
  */
 late_initcall(lapic_insert_resource);
+
+void boot_cpu_is_bsp_init(void)
+{
+	u32 l, h;
+
+	rdmsr(MSR_IA32_APICBASE, l, h);
+	boot_cpu_is_bsp = (l & MSR_IA32_APICBASE_BSP) ? true : false;
+}
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f8ec578..f47f716 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1169,6 +1169,8 @@ void __init setup_arch(char **cmdline_p)
 
 	early_quirks();
 
+	boot_cpu_is_bsp_init();
+
 	/*
 	 * Read APIC and some other early information from ACPI tables.
 	 */

