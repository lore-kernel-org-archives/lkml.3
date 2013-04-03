Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab3DCThq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:37:46 -0400
Received: from relay3.sgi.com ([192.48.152.1]:51227 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759815Ab3DCThp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:37:45 -0400
Date: Wed, 3 Apr 2013 14:37:43 -0500
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>,
        Shawn Guo <shawn.guo@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH] Do not force shutdown/reboot to boot cpu.
Message-ID: <20130403193743.GB29151@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We noticed that recently, reboot of a 1024 cpu machine takes approx 16
minutes of just stopping the cpus.  The slowdown was tracked to commit
f96972f which went into v3.7 and then to the stable trees.

x86 does not need to be running the boot cpu to pull reset and I don't
think it is really needed for shutdown either.

I decided to go the "simple" way and make this a config option that is
selected by the x86 arch.  I don't know which other arch's would also
benefit, if any.

Signed-off-by: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russ Anderson <rja@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: <stable@vger.kernel.org>

---
 arch/x86/Kconfig        | 3 +++
 kernel/Kconfig.shutdown | 3 +++
 kernel/sys.c            | 4 ++++
 3 files changed, 10 insertions(+)
 create mode 100644 kernel/Kconfig.shutdown

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 70c0f3d..9611942 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -120,6 +120,7 @@ config X86
 	select OLD_SIGSUSPEND3 if X86_32 || IA32_EMULATION
 	select OLD_SIGACTION if X86_32
 	select COMPAT_OLD_SIGACTION if IA32_EMULATION
+	select ARCH_SHUTDOWN_TO_ANY_CPU
 
 config INSTRUCTION_DECODER
 	def_bool y
@@ -839,6 +840,8 @@ config SCHED_MC
 	  making when dealing with multi-core CPU chips at a cost of slightly
 	  increased overhead in some places. If unsure say N here.
 
+source "kernel/Kconfig.shutdown"
+
 source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
diff --git a/kernel/Kconfig.shutdown b/kernel/Kconfig.shutdown
new file mode 100644
index 0000000..d79fc04
--- /dev/null
+++ b/kernel/Kconfig.shutdown
@@ -0,0 +1,3 @@
+
+config ARCH_SHUTDOWN_TO_ANY_CPU
+	bool
diff --git a/kernel/sys.c b/kernel/sys.c
index 39c9c4a..c0b8880 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -369,7 +369,9 @@ EXPORT_SYMBOL(unregister_reboot_notifier);
 void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
+#ifndef CONFIG_ARCH_SHUTDOWN_TO_ANY_CPU
 	disable_nonboot_cpus();
+#endif
 	if (!cmd)
 		printk(KERN_EMERG "Restarting system.\n");
 	else
@@ -413,7 +415,9 @@ void kernel_power_off(void)
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
 	if (pm_power_off_prepare)
 		pm_power_off_prepare();
+#ifndef CONFIG_ARCH_SHUTDOWN_TO_ANY_CPU
 	disable_nonboot_cpus();
+#endif
 	syscore_shutdown();
 	printk(KERN_EMERG "Power down.\n");
 	kmsg_dump(KMSG_DUMP_POWEROFF);
-- 
1.8.1.2

