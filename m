Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbbAVObA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:31:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58024 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbbAVOaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:30:55 -0500
Date: Thu, 22 Jan 2015 06:30:29 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-e714a91f92ca59f7e71e7332b8ec2aa2944f629e@git.kernel.org>
Cc: jiang.liu@linux.intel.com, hpa@zytor.com, joro@8bytes.org,
        mingo@kernel.org, bp@alien8.de, tglx@linutronix.de,
        tony.luck@intel.com, linux-kernel@vger.kernel.org
Reply-To: bp@alien8.de, mingo@kernel.org, jiang.liu@linux.intel.com,
        hpa@zytor.com, joro@8bytes.org, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, tglx@linutronix.de
In-Reply-To: <20150115211703.731329006@linutronix.de>
References: <20150115211703.731329006@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Move apic_init_uniprocessor code
Git-Commit-ID: e714a91f92ca59f7e71e7332b8ec2aa2944f629e
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

Commit-ID:  e714a91f92ca59f7e71e7332b8ec2aa2944f629e
Gitweb:     http://git.kernel.org/tip/e714a91f92ca59f7e71e7332b8ec2aa2944f629e
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:37 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:56 +0100

x86/apic: Move apic_init_uniprocessor code

Move the code to a different place so we can make other functions
inline. Preparatory patch for further cleanups. No change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20150115211703.731329006@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c | 125 ++++++++++++++++++++++----------------------
 1 file changed, 62 insertions(+), 63 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 3b4bdd5..c681e9b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1852,71 +1852,8 @@ void __init register_lapic_address(unsigned long address)
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
@@ -2269,6 +2206,68 @@ void __init apic_set_eoi_write(void (*eoi_write)(u32 reg, u32 v))
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
