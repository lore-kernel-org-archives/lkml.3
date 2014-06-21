Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaFUEyz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 00:54:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:37695 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbaFUEyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 00:54:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,519,1400050800"; 
   d="scan'208";a="531877074"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Bernd Kuhls" <berndkuhls@hotmail.com>, "Len Brown" <lenb@kernel.org>,
        "Rui Zhang" <rui.zhang@intel.com>,
        "Glenn Williamson" <glenn.p.williamson@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH][BUGFIX] x86/reboot: Disable scheduler before disabling IO APIC
Date: Fri, 20 Jun 2014 21:57:36 -0700
Message-Id: <1403326656-48521-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

During reboot, in the middle of disabling IO APIC, the scheduler may be
triggered by per cpu timer to do load blance. But since the kernel is
already in the process of shutting down and can not execute scheduler's
load balance at this point, it triggers invalid TSS exception and hangs
during reboot.

This happens on some boards (e.g. AsRock ZT87 Extreme4 BIOS 2.70) in 32-bit
kernel reported in Bugzilla 76661 at
https://bugzilla.kernel.org/show_bug.cgi?id=76661

To fix the issue, we disable local irq including per cpu timer before
disabling IO APIC. By doing this, the scheduler will not disturb
disable_IO_APIC().

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Tested-by: berndkuhls@hotmail.com
---
 arch/x86/kernel/reboot.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 52b1157..16111c6 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -574,6 +574,15 @@ static void native_machine_emergency_restart(void)
 void native_machine_shutdown(void)
 {
 	/* Stop the cpus and apics */
+
+#ifdef CONFIG_SMP
+	/*
+	 * Disable the local irq to not receive the per-cpu timer interrupt
+	 * which may trigger scheduler's load balance.
+	 */
+	local_irq_disable();
+#endif
+
 #ifdef CONFIG_X86_IO_APIC
 	/*
 	 * Disabling IO APIC before local APIC is a workaround for
@@ -591,11 +600,8 @@ void native_machine_shutdown(void)
 
 #ifdef CONFIG_SMP
 	/*
-	 * Stop all of the others. Also disable the local irq to
-	 * not receive the per-cpu timer interrupt which may trigger
-	 * scheduler's load balance.
+	 * Stop all of the others.
 	 */
-	local_irq_disable();
 	stop_other_cpus();
 #endif
 
-- 
1.8.1.2

