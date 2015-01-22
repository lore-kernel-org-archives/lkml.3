Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbbAVOcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:32:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58061 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbbAVOcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:32:13 -0500
Date: Thu, 22 Jan 2015 06:31:48 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-374aab339f10f0510cec0e79d752d31d84b08aa2@git.kernel.org>
Cc: bp@alien8.de, joro@8bytes.org, tony.luck@intel.com,
        jiang.liu@linux.intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: tony.luck@intel.com, bp@alien8.de, joro@8bytes.org, hpa@zytor.com,
        tglx@linutronix.de, mingo@kernel.org, jiang.liu@linux.intel.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20150115211704.084765674@linutronix.de>
References: <20150115211704.084765674@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Reuse apic_bsp_setup() for UP APIC setup
Git-Commit-ID: 374aab339f10f0510cec0e79d752d31d84b08aa2
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

Commit-ID:  374aab339f10f0510cec0e79d752d31d84b08aa2
Gitweb:     http://git.kernel.org/tip/374aab339f10f0510cec0e79d752d31d84b08aa2
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:44 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:56 +0100

x86/apic: Reuse apic_bsp_setup() for UP APIC setup

Extend apic_bsp_setup() so the same code flow can be used for
APIC_init_uniprocessor().

Folded Jiangs fix to provide proper ordering of the UP setup.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/20150115211704.084765674@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h |  2 +-
 arch/x86/kernel/apic/apic.c | 53 +++++++++++++++++++--------------------------
 arch/x86/kernel/smpboot.c   |  4 ++--
 3 files changed, 25 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 92f3404..92003f3 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -215,7 +215,7 @@ extern void setup_secondary_APIC_clock(void);
 extern int APIC_init_uniprocessor(void);
 extern int apic_force_enable(unsigned long addr);
 
-extern int apic_bsp_setup(void);
+extern int apic_bsp_setup(bool upmode);
 extern void apic_ap_setup(void);
 
 /*
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 0a41070..437c35b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2202,27 +2202,37 @@ void __init apic_set_eoi_write(void (*eoi_write)(u32 reg, u32 v))
 	}
 }
 
-static void __init bsp_end_local_APIC_setup(void)
+static void __init apic_bsp_up_setup(void)
 {
-	end_local_APIC_setup();
+#ifdef CONFIG_X86_64
+	apic_write(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));
+#else
 	/*
-	 * Now that local APIC setup is completed for BP, configure the fault
-	 * handling for interrupt remapping.
+	 * Hack: In case of kdump, after a crash, kernel might be booting
+	 * on a cpu with non-zero lapic id. But boot_cpu_physical_apicid
+	 * might be zero if read from MP tables. Get it from LAPIC.
 	 */
-	irq_remap_enable_fault_handling();
+# ifdef CONFIG_CRASH_DUMP
+	boot_cpu_physical_apicid = read_apic_id();
+# endif
+#endif
+	physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
 }
 
 /**
  * apic_bsp_setup - Setup function for local apic and io-apic
+ * @upmode:		Force UP mode (for APIC_init_uniprocessor)
  *
  * Returns:
  * apic_id of BSP APIC
  */
-int __init apic_bsp_setup(void)
+int __init apic_bsp_setup(bool upmode)
 {
 	int id;
 
 	connect_bsp_APIC();
+	if (upmode)
+		apic_bsp_up_setup();
 	setup_local_APIC();
 
 	if (x2apic_mode)
@@ -2231,7 +2241,8 @@ int __init apic_bsp_setup(void)
 		id = GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
 
 	enable_IO_APIC();
-	bsp_end_local_APIC_setup();
+	end_local_APIC_setup();
+	irq_remap_enable_fault_handling();
 	setup_IO_APIC();
 	return id;
 }
@@ -2267,32 +2278,12 @@ int __init APIC_init_uniprocessor(void)
 	}
 #endif
 
-	default_setup_apic_routing();
+	if (!smp_found_config)
+		disable_ioapic_support();
 
+	default_setup_apic_routing();
 	verify_local_APIC();
-	connect_bsp_APIC();
-
-#ifdef CONFIG_X86_64
-	apic_write(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));
-#else
-	/*
-	 * Hack: In case of kdump, after a crash, kernel might be booting
-	 * on a cpu with non-zero lapic id. But boot_cpu_physical_apicid
-	 * might be zero if read from MP tables. Get it from LAPIC.
-	 */
-# ifdef CONFIG_CRASH_DUMP
-	boot_cpu_physical_apicid = read_apic_id();
-# endif
-#endif
-	physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
-	setup_local_APIC();
-
-	if (smp_found_config)
-		enable_IO_APIC();
-
-	bsp_end_local_APIC_setup();
-
-	setup_IO_APIC();
+	apic_bsp_setup(true);
 
 	x86_init.timers.setup_percpu_clockev();
 	return 0;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index fe8783d..0a46e5e 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1147,7 +1147,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		return;
 	case SMP_FORCE_UP:
 		disable_smp();
-		apic_bsp_setup();
+		apic_bsp_setup(false);
 		return;
 	case SMP_OK:
 		break;
@@ -1161,7 +1161,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		/* Or can we switch back to PIC here? */
 	}
 
-	cpu0_logical_apicid = apic_bsp_setup();
+	cpu0_logical_apicid = apic_bsp_setup(false);
 
 	/*
 	 * Set up local APIC timer on boot CPU.
