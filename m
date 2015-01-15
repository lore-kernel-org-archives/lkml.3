Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbbAOVY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:24:28 -0500
Received: from www.linutronix.de ([62.245.132.108]:58403 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbbAOVWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:53 -0500
Message-Id: <20150115211703.731329006@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:37 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 18/23] x86/apic: Move apic_init_uniprocessor code
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=x86-apic-move-apic-init-up.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the code to a different place so we can make other functions
inline. Preparatory patch for further cleanups. No change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c |  125 +++++++++++++++++++++-----------------------
 1 file changed, 62 insertions(+), 63 deletions(-)

Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1850,71 +1850,8 @@ void __init register_lapic_address(unsig
 	}
 }
 
-/*
- * This initializes the IO-APIC and APIC hardware if this is
- * a UP kernel.
- */
 int apic_version[MAX_LOCAL_APIC];
 
-int __init APIC_init_uniprocessor(void)
-{
-	if (disable_apic) {
-		pr_info("Apic disabled\n");
-		return -1;
-	}
-#ifdef CONFIG_X86_64
-	if (!cpu_has_apic) {
-		disable_apic = 1;
-		pr_info("Apic disabled by BIOS\n");
-		return -1;
-	}
-#else
-	if (!smp_found_config && !cpu_has_apic)
-		return -1;
-
-	/*
-	 * Complain if the BIOS pretends there is one.
-	 */
-	if (!cpu_has_apic &&
-	    APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
-		pr_err("BIOS bug, local APIC 0x%x not detected!...\n",
-			boot_cpu_physical_apicid);
-		return -1;
-	}
-#endif
-
-	default_setup_apic_routing();
-
-	verify_local_APIC();
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
-	/* Enable IO-APICs before enabling error vector */
-	enable_IO_APIC();
-
-	bsp_end_local_APIC_setup();
-
-	if (smp_found_config)
-		setup_IO_APIC();
-
-	x86_init.timers.setup_percpu_clockev();
-	return 0;
-}
-
 /*
  * Local APIC interrupts
  */
@@ -2267,6 +2204,68 @@ void __init apic_set_eoi_write(void (*eo
 }
 
 /*
+ * This initializes the IO-APIC and APIC hardware if this is
+ * a UP kernel.
+ */
+int __init APIC_init_uniprocessor(void)
+{
+	if (disable_apic) {
+		pr_info("Apic disabled\n");
+		return -1;
+	}
+#ifdef CONFIG_X86_64
+	if (!cpu_has_apic) {
+		disable_apic = 1;
+		pr_info("Apic disabled by BIOS\n");
+		return -1;
+	}
+#else
+	if (!smp_found_config && !cpu_has_apic)
+		return -1;
+
+	/*
+	 * Complain if the BIOS pretends there is one.
+	 */
+	if (!cpu_has_apic &&
+	    APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
+		pr_err("BIOS bug, local APIC 0x%x not detected!...\n",
+			boot_cpu_physical_apicid);
+		return -1;
+	}
+#endif
+
+	default_setup_apic_routing();
+
+	verify_local_APIC();
+	connect_bsp_APIC();
+
+#ifdef CONFIG_X86_64
+	apic_write(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));
+#else
+	/*
+	 * Hack: In case of kdump, after a crash, kernel might be booting
+	 * on a cpu with non-zero lapic id. But boot_cpu_physical_apicid
+	 * might be zero if read from MP tables. Get it from LAPIC.
+	 */
+# ifdef CONFIG_CRASH_DUMP
+	boot_cpu_physical_apicid = read_apic_id();
+# endif
+#endif
+	physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
+	setup_local_APIC();
+
+	if (smp_found_config)
+		enable_IO_APIC();
+
+	bsp_end_local_APIC_setup();
+
+	setup_IO_APIC();
+
+	x86_init.timers.setup_percpu_clockev();
+	return 0;
+}
+
+/*
  * Power management
  */
 #ifdef CONFIG_PM


