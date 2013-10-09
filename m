Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab3JIXQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 19:16:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59902 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab3JIXQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 19:16:08 -0400
Date: Wed, 9 Oct 2013 16:15:53 -0700
From: tip-bot for HATAYAMA Daisuke <tipbot@zytor.com>
Message-ID: <tip-68c3467bb95a9e99f46d04cb96f60c04bb997ac8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, d.hatayama@jp.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, d.hatayama@jp.fujitsu.com, hpa@linux.intel.com
In-Reply-To: <20130829092758.5476.90694.stgit@localhost6.localdomain6>
References: <20130829092758.5476.90694.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/bsp-hotplug] x86, apic: Add boot_cpu_is_bsp()
  to check if boot cpu is BSP
Git-Commit-ID: 68c3467bb95a9e99f46d04cb96f60c04bb997ac8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 16:15:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68c3467bb95a9e99f46d04cb96f60c04bb997ac8
Gitweb:     http://git.kernel.org/tip/68c3467bb95a9e99f46d04cb96f60c04bb997ac8
Author:     HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
AuthorDate: Thu, 29 Aug 2013 18:27:58 +0900
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 9 Oct 2013 15:41:10 -0700

x86, apic: Add boot_cpu_is_bsp() to check if boot cpu is BSP

Kexec can enter the kdump 2nd kernel on AP if crash happens on AP. To
check if boot cpu is BSP, introduce a helper function
boot_cpu_is_bsp().

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Link: http://lkml.kernel.org/r/20130829092758.5476.90694.stgit@localhost6.localdomain6
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/mpspec.h |  3 +++
 arch/x86/kernel/apic/apic.c   | 14 ++++++++++++++
 arch/x86/kernel/setup.c       |  2 ++
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
index a7eb82d..488709d 100644
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
