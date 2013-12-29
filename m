Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab3L2CMv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:12:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55811 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754417Ab3L2CMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:12:49 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.103489079@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 037/185] x86/apic: Disable I/O APIC before shutdown of
 the local APIC
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/crash.c  | 2 +-
 arch/x86/kernel/reboot.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -95,10 +95,10 @@ void native_machine_crash_shutdown(struc
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
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -652,6 +652,13 @@ void native_machine_shutdown(void)
 
 	/* The boot cpu is always logical cpu 0 */
 	int reboot_cpu_id = 0;
+#endif
+
+#ifdef CONFIG_X86_IO_APIC
+	disable_IO_APIC();
+#endif
+
+#ifdef CONFIG_SMP
 
 #ifdef CONFIG_X86_32
 	/* See if there has been given a command line override */
@@ -675,10 +682,6 @@ void native_machine_shutdown(void)
 
 	lapic_shutdown();
 
-#ifdef CONFIG_X86_IO_APIC
-	disable_IO_APIC();
-#endif
-
 #ifdef CONFIG_HPET_TIMER
 	hpet_disable();
 #endif

