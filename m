Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab3K0BWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:22:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758752Ab3K0A7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.12 074/116] x86/apic: Disable I/O APIC before shutdown of the local APIC
Date: Tue, 26 Nov 2013 16:57:27 -0800
Message-Id: <20131127005742.043620644@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fenghua Yu <fenghua.yu@intel.com>

commit 522e66464467543c0d88d023336eec4df03ad40b upstream.

In reboot and crash path, when we shut down the local APIC, the I/O APIC is
still active. This may cause issues because external interrupts
can still come in and disturb the local APIC during shutdown process.

To quiet external interrupts, disable I/O APIC before shutdown local APIC.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1382578212-4677-1-git-send-email-fenghua.yu@intel.com
[ I suppose the 'issue' is a hang during shutdown. It's a fine change nevertheless. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/crash.c  |    2 +-
 arch/x86/kernel/reboot.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -127,12 +127,12 @@ void native_machine_crash_shutdown(struc
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
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -550,6 +550,10 @@ static void native_machine_emergency_res
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


