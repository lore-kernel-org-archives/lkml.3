Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbbAVOcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:32:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58055 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbbAVOcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:32:00 -0500
Date: Thu, 22 Jan 2015 06:31:30 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-613c25efbdc763ee8b9d732368106d2456279356@git.kernel.org>
Cc: jiang.liu@linux.intel.com, tony.luck@intel.com, bp@alien8.de,
        mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org
Reply-To: linux-kernel@vger.kernel.org, joro@8bytes.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, bp@alien8.de,
        tony.luck@intel.com, jiang.liu@linux.intel.com
In-Reply-To: <20150115211703.987833932@linutronix.de>
References: <20150115211703.987833932@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/smpboot: Sanitize uniprocessor init
Git-Commit-ID: 613c25efbdc763ee8b9d732368106d2456279356
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  613c25efbdc763ee8b9d732368106d2456279356
Gitweb:     http://git.kernel.org/tip/613c25efbdc763ee8b9d732368106d2456279356
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:42 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:56 +0100

x86/smpboot: Sanitize uniprocessor init

The UP related setups for local apic are mangled into smp_sanity_check().

That results in duplicate calls to disable_smp() and makes the code
hard to follow. Let smp_sanity_check() return dedicated values for the
various exit reasons and handle them at the call site.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20150115211703.987833932@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/smpboot.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index d538709..fe8783d 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -990,6 +990,8 @@ void arch_disable_smp_support(void)
  */
 static __init void disable_smp(void)
 {
+	pr_info("SMP disabled\n");
+
 	disable_ioapic_support();
 
 	init_cpu_present(cpumask_of(0));
@@ -1003,6 +1005,13 @@ static __init void disable_smp(void)
 	cpumask_set_cpu(0, cpu_core_mask(0));
 }
 
+enum {
+	SMP_OK,
+	SMP_NO_CONFIG,
+	SMP_NO_APIC,
+	SMP_FORCE_UP,
+};
+
 /*
  * Various sanity checks.
  */
@@ -1050,10 +1059,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	if (!smp_found_config && !acpi_lapic) {
 		preempt_enable();
 		pr_notice("SMP motherboard not detected\n");
-		disable_smp();
-		if (APIC_init_uniprocessor())
-			pr_notice("Local APIC not detected. Using dummy APIC emulation.\n");
-		return -1;
+		return SMP_NO_CONFIG;
 	}
 
 	/*
@@ -1077,7 +1083,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 				boot_cpu_physical_apicid);
 			pr_err("... forcing use of dummy APIC emulation (tell your hw vendor)\n");
 		}
-		return -1;
+		return SMP_NO_APIC;
 	}
 
 	verify_local_APIC();
@@ -1087,12 +1093,10 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	 */
 	if (!max_cpus) {
 		pr_info("SMP mode deactivated\n");
-		disable_ioapic_support();
-		apic_bsp_setup();
-		return -1;
+		return SMP_FORCE_UP;
 	}
 
-	return 0;
+	return SMP_OK;
 }
 
 static void __init smp_cpu_index_default(void)
@@ -1132,10 +1136,21 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	}
 	set_cpu_sibling_map(0);
 
-	if (smp_sanity_check(max_cpus) < 0) {
-		pr_info("SMP disabled\n");
+	switch (smp_sanity_check(max_cpus)) {
+	case SMP_NO_CONFIG:
 		disable_smp();
+		if (APIC_init_uniprocessor())
+			pr_notice("Local APIC not detected. Using dummy APIC emulation.\n");
+		return;
+	case SMP_NO_APIC:
+		disable_smp();
+		return;
+	case SMP_FORCE_UP:
+		disable_smp();
+		apic_bsp_setup();
 		return;
+	case SMP_OK:
+		break;
 	}
 
 	default_setup_apic_routing();
