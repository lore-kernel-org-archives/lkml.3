Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab3JXAiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 20:38:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:37401 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab3JXAiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 20:38:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="397603611"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH] x86/apic: Disable I/O APIC before shutdown local APIC
Date: Wed, 23 Oct 2013 18:30:12 -0700
Message-Id: <1382578212-4677-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

In reboot and crash path, when shutdown local APIC, I/O APIC is still active.
This may cause issues because external interrupts can still come in and
disturb local APIC during shutdown process. To quiet external interrupts,
disable I/O APIC before shutdown local APIC.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/crash.c  |    2 +-
 arch/x86/kernel/reboot.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index e0e0841..18677a9 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -127,12 +127,12 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 	cpu_emergency_vmxoff();
 	cpu_emergency_svm_disable();
 
-	lapic_shutdown();
 #ifdef CONFIG_X86_IO_APIC
 	/* Prevent crash_kexec() from deadlocking on ioapic_lock. */
 	ioapic_zap_locks();
 	disable_IO_APIC();
 #endif
+	lapic_shutdown();
 #ifdef CONFIG_HPET_TIMER
 	hpet_disable();
 #endif
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 7e920bf..618ce26 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -550,6 +550,10 @@ static void native_machine_emergency_restart(void)
 void native_machine_shutdown(void)
 {
 	/* Stop the cpus and apics */
+#ifdef CONFIG_X86_IO_APIC
+	disable_IO_APIC();
+#endif
+
 #ifdef CONFIG_SMP
 	/*
 	 * Stop all of the others. Also disable the local irq to
@@ -562,10 +566,6 @@ void native_machine_shutdown(void)
 
 	lapic_shutdown();
 
-#ifdef CONFIG_X86_IO_APIC
-	disable_IO_APIC();
-#endif
-
 #ifdef CONFIG_HPET_TIMER
 	hpet_disable();
 #endif
-- 
1.6.0.3

