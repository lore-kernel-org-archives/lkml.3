Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbaAMRJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:09:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52875 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbaAMQBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 018/208] x86/apic: Disable I/O APIC before shutdown of the local APIC
Date: Mon, 13 Jan 2014 15:57:39 +0000
Message-Id: <1389628849-1614-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/crash.c  | 2 +-
 arch/x86/kernel/reboot.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 74467fe..0b9d44d 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -127,10 +127,10 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 	cpu_emergency_vmxoff();
 	cpu_emergency_svm_disable();
 
-	lapic_shutdown();
 #if defined(CONFIG_X86_IO_APIC)
 	disable_IO_APIC();
 #endif
+	lapic_shutdown();
 #ifdef CONFIG_HPET_TIMER
 	hpet_disable();
 #endif
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 5f4ad27..ca1787b 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -542,6 +542,10 @@ static void native_machine_emergency_restart(void)
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
@@ -554,10 +558,6 @@ void native_machine_shutdown(void)
 
 	lapic_shutdown();
 
-#ifdef CONFIG_X86_IO_APIC
-	disable_IO_APIC();
-#endif
-
 #ifdef CONFIG_HPET_TIMER
 	hpet_disable();
 #endif
-- 
1.8.3.2

