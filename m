Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab3DUMuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 08:50:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40707 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab3DUMuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 08:50:10 -0400
Date: Sun, 21 Apr 2013 05:49:48 -0700
From: tip-bot for George Dunlap <tipbot@zytor.com>
Message-ID: <tip-a5ebe0ba3dff658c5286e8d5f20e4328f719d5a3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, andrew.cooper3@citrix.com,
        ian.campbell@citrix.com, george.dunlap@eu.citrix.com,
        tglx@linutronix.de, david.vrabel@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, ian.campbell@citrix.com,
        andrew.cooper3@citrix.com, george.dunlap@eu.citrix.com,
        david.vrabel@citrix.com, tglx@linutronix.de
In-Reply-To: <1365000388-32448-1-git-send-email-george.dunlap@eu.citrix.com>
References: <1365000388-32448-1-git-send-email-george.dunlap@eu.citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Check all MSRs before passing hw check
Git-Commit-ID: a5ebe0ba3dff658c5286e8d5f20e4328f719d5a3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 21 Apr 2013 05:49:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5ebe0ba3dff658c5286e8d5f20e4328f719d5a3
Gitweb:     http://git.kernel.org/tip/a5ebe0ba3dff658c5286e8d5f20e4328f719d5a3
Author:     George Dunlap <george.dunlap@eu.citrix.com>
AuthorDate: Wed, 3 Apr 2013 15:46:28 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 21 Apr 2013 11:16:29 +0200

perf/x86: Check all MSRs before passing hw check

check_hw_exists() has a number of checks which go to two exit
paths: msr_fail and bios_fail.  Checks classified as msr_fail
will cause check_hw_exists() to return false, causing the PMU
not to be used; bios_fail checks will only cause a warning to be
printed, but will return true.

The problem is that if there are both msr failures and bios
failures, and the routine hits a bios_fail check first, it will
exit early and return true, not finishing the rest of the msr
checks.  If those msrs are in fact broken, it will cause them to
be used erroneously.

In the case of a Xen PV VM, the guest OS has read access to all
the MSRs, but write access is white-listed to supported
features.  Writes to unsupported MSRs have no effect.  The PMU
MSRs are not (typically) supported, because they are expensive
to save and restore on a VM context switch.  One of the
"msr_fail" checks is supposed to detect this circumstance (ether
for Xen or KVM) and disable the harware PMU.

However, on one of my AMD boxen, there is (apparently) a broken
BIOS which triggers one of the bios_fail checks.  In particular,
MSR_K7_EVNTSEL0 has the ARCH_PERFMON_EVENTSEL_ENABLE bit set.
The guest kernel detects this because it has read access to all
MSRs, and causes it to skip the rest of the checks and try to
use the non-existent hardware PMU.  This minimally causes a lot
of useless instruction emulation and Xen console spam; it may
cause other issues with the watchdog as well.

This changset causes check_hw_exists() to go through all of the
msr checks, failing and returning false if any of them fail.
This makes sure that a guest running under Xen without a virtual
PMU will detect that there is no functioning PMU and not attempt
to use it.

This problem affects kernels as far back as 3.2, and should thus
be considered for backport.

Signed-off-by: George Dunlap <george.dunlap@eu.citrix.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Link: http://lkml.kernel.org/r/1365000388-32448-1-git-send-email-george.dunlap@eu.citrix.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5ed7a4c..1025f3c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -180,8 +180,9 @@ static void release_pmc_hardware(void) {}
 
 static bool check_hw_exists(void)
 {
-	u64 val, val_new = ~0;
-	int i, reg, ret = 0;
+	u64 val, val_fail, val_new= ~0;
+	int i, reg, reg_fail, ret = 0;
+	int bios_fail = 0;
 
 	/*
 	 * Check to see if the BIOS enabled any of the counters, if so
@@ -192,8 +193,11 @@ static bool check_hw_exists(void)
 		ret = rdmsrl_safe(reg, &val);
 		if (ret)
 			goto msr_fail;
-		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
-			goto bios_fail;
+		if (val & ARCH_PERFMON_EVENTSEL_ENABLE) {
+			bios_fail = 1;
+			val_fail = val;
+			reg_fail = reg;
+		}
 	}
 
 	if (x86_pmu.num_counters_fixed) {
@@ -202,8 +206,11 @@ static bool check_hw_exists(void)
 		if (ret)
 			goto msr_fail;
 		for (i = 0; i < x86_pmu.num_counters_fixed; i++) {
-			if (val & (0x03 << i*4))
-				goto bios_fail;
+			if (val & (0x03 << i*4)) {
+				bios_fail = 1;
+				val_fail = val;
+				reg_fail = reg;
+			}
 		}
 	}
 
@@ -221,14 +228,13 @@ static bool check_hw_exists(void)
 	if (ret || val != val_new)
 		goto msr_fail;
 
-	return true;
-
-bios_fail:
 	/*
 	 * We still allow the PMU driver to operate:
 	 */
-	printk(KERN_CONT "Broken BIOS detected, complain to your hardware vendor.\n");
-	printk(KERN_ERR FW_BUG "the BIOS has corrupted hw-PMU resources (MSR %x is %Lx)\n", reg, val);
+	if (bios_fail) {
+		printk(KERN_CONT "Broken BIOS detected, complain to your hardware vendor.\n");
+		printk(KERN_ERR FW_BUG "the BIOS has corrupted hw-PMU resources (MSR %x is %Lx)\n", reg_fail, val_fail);
+	}
 
 	return true;
 
