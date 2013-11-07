Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab3KGPS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:18:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40613 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab3KGPSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:18:54 -0500
Date: Thu, 7 Nov 2013 07:18:36 -0800
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-522e66464467543c0d88d023336eec4df03ad40b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stable@kernel.org, fenghua.yu@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, stable@kernel.org, tglx@linutronix.de
In-Reply-To: <1382578212-4677-1-git-send-email-fenghua.yu@intel.com>
References: <1382578212-4677-1-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Disable I/
 O APIC before shutdown of the local APIC
Git-Commit-ID: 522e66464467543c0d88d023336eec4df03ad40b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 07 Nov 2013 07:18:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  522e66464467543c0d88d023336eec4df03ad40b
Gitweb:     http://git.kernel.org/tip/522e66464467543c0d88d023336eec4df03ad40b
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Wed, 23 Oct 2013 18:30:12 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 7 Nov 2013 10:12:37 +0100

x86/apic: Disable I/O APIC before shutdown of the local APIC

In reboot and crash path, when we shut down the local APIC, the I/O APIC is
still active. This may cause issues because external interrupts
can still come in and disturb the local APIC during shutdown process.

To quiet external interrupts, disable I/O APIC before shutdown local APIC.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1382578212-4677-1-git-send-email-fenghua.yu@intel.com
Cc: <stable@kernel.org>
[ I suppose the 'issue' is a hang during shutdown. It's a fine change nevertheless. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
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
