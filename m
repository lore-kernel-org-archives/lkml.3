Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab3CRL2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:28:03 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:39451 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3CRL2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:28:00 -0400
X-IronPort-AV: E=Sophos;i="4.84,863,1355097600"; 
   d="scan'208";a="13127027"
From: George Dunlap <george.dunlap@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: George Dunlap <george.dunlap@eu.citrix.com>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, <x86@kernel.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: [PATCH v2] perf: Check all MSRs before passing hw check
Date: Mon, 18 Mar 2013 11:27:25 +0000
Message-ID: <1363606045-6805-1-git-send-email-george.dunlap@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_hw_exists has a number of checks which go to two exit paths:
msr_fail and bios_fail.  Checks classified as msr_fail will cause
check_hw_exists() to return false, causing the PMU not to be used;
bios_fail checks will only cause a warning to be printed, but will
return true.

The problem is that if there are both msr failures and bios failures,
and the routine hits a bios_fail check first, it will exit early and
return true, not finishing the rest of the msr checks.  If those msrs
are in fact broken, it will cause them to be used erroneously.

In the case of a Xen PV VM, the guest OS has read access to all the
MSRs, but write access is white-listed to supported features.  Writes
to unsupported MSRs have no effect.  The PMU MSRs are not (typically)
supported, because they are expensive to save and restore on a VM
context switch.  One of the "msr_fail" checks is supposed to detect
this circumstance (ether for Xen or KVM) and disable the harware PMU.

However, on one of my AMD boxen, there is (apparently) a broken BIOS
which triggers one of the bios_fail checks.  In particular,
MSR_K7_EVNTSEL0 has the ARCH_PERFMON_EVENTSEL_ENABLE bit set.  The
guest kernel detects this because it has read access to all MSRs, and
causes it to skip the rest of the checks and try to use the
non-existent hardware PMU.  This minimally causes a lot of useless
instruction emulation and Xen console spam; it may cause other issues
with the watchdog as well.

This changset causes check_hw_exists() to go through all of the msr
checks, failing and returning false if any of them fail.  This makes
sure that a guest running under Xen without a virtual PMU will detect
that there is no functioning PMU and not attempt to use it.

This problem affects kernels as far back as 3.2, and should thus be
considered for backport.

v2:
 - Print the warning when the event happens so the reg,val make sense
 - But print it only for the first such instance
 - Update changelog to include details of failing system

Signed-off-by: George Dunlap <george.dunlap@eu.citrix.com>
CC: Konrad Wilk <konrad.wilk@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@kernel.org>
CC: x86@kernel.org
CC: Ian Campbell <ian.campbell@citrix.com>
CC: David Vrabel <david.vrabel@citrix.com>
CC: Andrew Cooper <andrew.cooper3@citrix.com>
---
 arch/x86/kernel/cpu/perf_event.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 6774c17..5e2b4d6 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -182,6 +182,19 @@ static bool check_hw_exists(void)
 {
 	u64 val, val_new = ~0;
 	int i, reg, ret = 0;
+	int bios_fail = 0;
+
+#define BIOS_FAIL(_r, _v) \
+do {							\
+	/* 						\
+	 * We still allow the PMU driver to operate: 	\
+	 */ 						\
+	if (!bios_fail) { 				\
+		bios_fail = 1; 				\
+		printk(KERN_CONT "Broken BIOS detected, complain to your hardware vendor.\n"); \
+		printk(KERN_ERR FW_BUG "the BIOS has corrupted hw-PMU resources (MSR %x is %Lx)\n", _r, _v); \
+        } 						\
+} while(0)
 
 	/*
 	 * Check to see if the BIOS enabled any of the counters, if so
@@ -192,8 +205,8 @@ static bool check_hw_exists(void)
 		ret = rdmsrl_safe(reg, &val);
 		if (ret)
 			goto msr_fail;
-		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
-			goto bios_fail;
+		if (val & ARCH_PERFMON_EVENTSEL_ENABLE) 
+			BIOS_FAIL(reg, val);
 	}
 
 	if (x86_pmu.num_counters_fixed) {
@@ -203,10 +216,12 @@ static bool check_hw_exists(void)
 			goto msr_fail;
 		for (i = 0; i < x86_pmu.num_counters_fixed; i++) {
 			if (val & (0x03 << i*4))
-				goto bios_fail;
+				BIOS_FAIL(reg, val);
 		}
 	}
 
+#undef BIOS_FAIL
+
 	/*
 	 * Read the current value, change it and read it back to see if it
 	 * matches, this is needed to detect certain hardware emulators
@@ -223,15 +238,6 @@ static bool check_hw_exists(void)
 
 	return true;
 
-bios_fail:
-	/*
-	 * We still allow the PMU driver to operate:
-	 */
-	printk(KERN_CONT "Broken BIOS detected, complain to your hardware vendor.\n");
-	printk(KERN_ERR FW_BUG "the BIOS has corrupted hw-PMU resources (MSR %x is %Lx)\n", reg, val);
-
-	return true;
-
 msr_fail:
 	printk(KERN_CONT "Broken PMU hardware detected, using software events only.\n");
 	printk(KERN_ERR "Failed to access perfctr msr (MSR %x is %Lx)\n", reg, val_new);
-- 
1.7.9.5

