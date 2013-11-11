Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab3KKQWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:22:07 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:33900 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab3KKQV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:21:56 -0500
Date: Mon, 11 Nov 2013 17:21:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/apic change for v3.13
Message-ID: <20131111162152.GA11580@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-apic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-apic-for-linus

   # HEAD: 522e66464467543c0d88d023336eec4df03ad40b x86/apic: Disable I/O APIC before shutdown of the local APIC

A single fix to the IO-APIC / local-APIC shutdown sequence.

 Thanks,

	Ingo

------------------>
Fenghua Yu (1):
      x86/apic: Disable I/O APIC before shutdown of the local APIC


 arch/x86/kernel/crash.c  | 2 +-
 arch/x86/kernel/reboot.c | 8 ++++----
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
