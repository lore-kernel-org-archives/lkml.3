Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab3EGOl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:41:28 -0400
Received: from relay3.sgi.com ([192.48.152.1]:49955 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755148Ab3EGOkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:40:39 -0400
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -v8 11/11] Move arch/x86 reboot= handling to generic kernel.
Date: Tue,  7 May 2013 09:39:55 -0500
Message-Id: <1367937595-32241-12-git-send-email-holt@sgi.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367937595-32241-1-git-send-email-holt@sgi.com>
References: <1367937595-32241-1-git-send-email-holt@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge together the unicore32, arm, and x86 reboot= command line
parameter handling.

Signed-off-by: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>
Cc: Arm Mailing List <linux-arm-kernel@lists.infradead.org>
---
 Documentation/kernel-parameters.txt      |  18 ++++-
 arch/arm/kernel/process.c                |  10 ---
 arch/unicore32/kernel/process.c          |  10 ---
 arch/x86/include/asm/emergency-restart.h |  12 ----
 arch/x86/kernel/apic/x2apic_uv_x.c       |   2 +-
 arch/x86/kernel/reboot.c                 | 111 +------------------------------
 include/linux/reboot.h                   |  17 +++++
 kernel/reboot.c                          |  90 ++++++++++++++++++++++++-
 8 files changed, 125 insertions(+), 145 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c3bfacb..87e8dea 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2677,9 +2677,21 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Run specified binary instead of /init from the ramdisk,
 			used for early userspace startup. See initrd.
 
-	reboot=		[BUGS=X86-32,BUGS=ARM,BUGS=IA-64] Rebooting mode
-			Format: <reboot_mode>[,<reboot_mode2>[,...]]
-			See arch/*/kernel/reboot.c or arch/*/kernel/process.c
+	reboot=		[KNL]
+			Format (x86 or x86_64):
+				[w[arm] | c[old]] \
+				[,] s[mp]#### \
+				[,b[ios] | a[cpi] | k[bd] | t[riple] | e[fi] | p[ci]] \
+				[,f[orce]
+			Format (all other archs):
+				[s[oft] | h[ard]] \
+				[,b[ios] | a[cpi] | k[bd] | t[riple] | e[fi] | p[ci]] \
+				[,f[orce]]
+			Where reboot_mode is one of warm (soft) or cold,
+			      reboot_type is one of bios, acpi, kbd, triple, efi, or pci,
+			      reboot_force is either force or not specified,
+			      reboot_cpu is s[mp]#### with #### being the processor
+					(in decimal) to be used for rebooting.
 
 	relax_domain_level=
 			[KNL, SMP] Set scheduler's default relax_domain_level.
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 58c0d7a..304b102 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -175,16 +175,6 @@ void arch_cpu_idle(void)
 		default_idle();
 }
 
-enum reboot_mode reboot_mode;
-
-static int __init reboot_setup(char *str)
-{
-	if ('s' == str[0])
-		reboot_mode = REBOOT_WARM;
-	return 1;
-}
-__setup("reboot=", reboot_setup);
-
 void machine_shutdown(void)
 {
 #ifdef CONFIG_SMP
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index 9dc6e48..fdb8e79 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -51,16 +51,6 @@ void arch_cpu_idle(void)
 	local_irq_enable();
 }
 
-static enum reboot_mode reboot_mode;
-
-int __init reboot_setup(char *str)
-{
-	if ('s' == str[0])
-		reboot_mode = REBOOT_WARM;
-	return 1;
-}
-__setup("reboot=", reboot_setup);
-
 void machine_halt(void)
 {
 	gpio_set_value(GPO_SOFT_OFF, 0);
diff --git a/arch/x86/include/asm/emergency-restart.h b/arch/x86/include/asm/emergency-restart.h
index 75ce3f4..77a99ac 100644
--- a/arch/x86/include/asm/emergency-restart.h
+++ b/arch/x86/include/asm/emergency-restart.h
@@ -1,18 +1,6 @@
 #ifndef _ASM_X86_EMERGENCY_RESTART_H
 #define _ASM_X86_EMERGENCY_RESTART_H
 
-enum reboot_type {
-	BOOT_TRIPLE = 't',
-	BOOT_KBD = 'k',
-	BOOT_BIOS = 'b',
-	BOOT_ACPI = 'a',
-	BOOT_EFI = 'e',
-	BOOT_CF9 = 'p',
-	BOOT_CF9_COND = 'q',
-};
-
-extern enum reboot_type reboot_type;
-
 extern void machine_emergency_restart(void);
 
 #endif /* _ASM_X86_EMERGENCY_RESTART_H */
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 794f6eb..958e3e4 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -25,6 +25,7 @@
 #include <linux/kdebug.h>
 #include <linux/delay.h>
 #include <linux/crash_dump.h>
+#include <linux/reboot.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
@@ -36,7 +37,6 @@
 #include <asm/ipi.h>
 #include <asm/smp.h>
 #include <asm/x86_init.h>
-#include <asm/emergency-restart.h>
 #include <asm/nmi.h>
 
 /* BMC sets a bit this MMR non-zero before sending an NMI */
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d42e3b2..563ed91 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -36,22 +36,6 @@ void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
 static const struct desc_ptr no_idt = {};
-static enum reboot_mode reboot_mode = REBOOT_COLD;
-enum reboot_type reboot_type = BOOT_ACPI;
-int reboot_force;
-
-/*
- * This variable is used privately to keep track of whether or not
- * reboot_type is still set to its default value (i.e., reboot= hasn't
- * been set on the command line).  This is needed so that we can
- * suppress DMI scanning for reboot quirks.  Without it, it's
- * impossible to override a faulty reboot quirk without recompiling.
- */
-static int reboot_default = 1;
-
-#ifdef CONFIG_SMP
-static int reboot_cpu = -1;
-#endif
 
 /*
  * This is set if we need to go through the 'emergency' path.
@@ -64,79 +48,6 @@ static int reboot_emergency;
 bool port_cf9_safe = false;
 
 /*
- * reboot=b[ios] | s[mp] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old] | p[ci]
- * warm   Don't set the cold reboot flag
- * cold   Set the cold reboot flag
- * bios   Reboot by jumping through the BIOS
- * smp    Reboot by executing reset on BSP or other CPU
- * triple Force a triple fault (init)
- * kbd    Use the keyboard controller. cold reset (default)
- * acpi   Use the RESET_REG in the FADT
- * efi    Use efi reset_system runtime service
- * pci    Use the so-called "PCI reset register", CF9
- * force  Avoid anything that could hang.
- */
-static int __init reboot_setup(char *str)
-{
-	for (;;) {
-		/*
-		 * Having anything passed on the command line via
-		 * reboot= will cause us to disable DMI checking
-		 * below.
-		 */
-		reboot_default = 0;
-
-		switch (*str) {
-		case 'w':
-			reboot_mode = REBOOT_WARM;
-			break;
-
-		case 'c':
-			reboot_mode = REBOOT_COLD;
-			break;
-
-#ifdef CONFIG_SMP
-		case 's':
-			if (isdigit(*(str+1))) {
-				reboot_cpu = (int) (*(str+1) - '0');
-				if (isdigit(*(str+2)))
-					reboot_cpu = reboot_cpu*10 + (int)(*(str+2) - '0');
-			}
-			/*
-			 * We will leave sorting out the final value
-			 * when we are ready to reboot, since we might not
-			 * have detected BSP APIC ID or smp_num_cpu
-			 */
-			break;
-#endif /* CONFIG_SMP */
-
-		case 'b':
-		case 'a':
-		case 'k':
-		case 't':
-		case 'e':
-		case 'p':
-			reboot_type = *str;
-			break;
-
-		case 'f':
-			reboot_force = 1;
-			break;
-		}
-
-		str = strchr(str, ',');
-		if (str)
-			str++;
-		else
-			break;
-	}
-	return 1;
-}
-
-__setup("reboot=", reboot_setup);
-
-
-/*
  * Reboot options and system auto-detection code provided by
  * Dell Inc. so their systems "just work". :-)
  */
@@ -616,26 +527,10 @@ void native_machine_shutdown(void)
 {
 	/* Stop the cpus and apics */
 #ifdef CONFIG_SMP
-
-	/* The boot cpu is always logical cpu 0 */
-	int reboot_cpu_id = 0;
-
-	/* See if there has been given a command line override */
-	if ((reboot_cpu != -1) && (reboot_cpu < nr_cpu_ids) &&
-		cpu_online(reboot_cpu))
-		reboot_cpu_id = reboot_cpu;
-
-	/* Make certain the cpu I'm about to reboot on is online */
-	if (!cpu_online(reboot_cpu_id))
-		reboot_cpu_id = smp_processor_id();
-
-	/* Make certain I only run on the appropriate processor */
-	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
-
 	/*
-	 * O.K Now that I'm on the appropriate processor, stop all of the
-	 * others. Also disable the local irq to not receive the per-cpu
-	 * timer interrupt which may trigger scheduler's load balance.
+	 * Stop all of the others. Also disable the local irq to
+	 * not receive the per-cpu timer interrupt which may trigger
+	 * scheduler's load balance.
 	 */
 	local_irq_disable();
 	stop_other_cpus();
diff --git a/include/linux/reboot.h b/include/linux/reboot.h
index 26cf11b..bc77231 100644
--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -15,6 +15,23 @@ enum reboot_mode {
 	REBOOT_WARM,
 	REBOOT_GPIO,
 };
+extern enum reboot_mode reboot_mode;
+
+enum reboot_type {
+	BOOT_TRIPLE = 't',
+	BOOT_KBD = 'k',
+	BOOT_BIOS = 'b',
+	BOOT_ACPI = 'a',
+	BOOT_EFI = 'e',
+	BOOT_CF9 = 'p',
+	BOOT_CF9_COND = 'q',
+};
+extern enum reboot_type reboot_type;
+
+extern int reboot_default;
+extern int reboot_cpu;
+extern int reboot_force;
+
 
 extern int register_reboot_notifier(struct notifier_block *);
 extern int unregister_reboot_notifier(struct notifier_block *);
diff --git a/kernel/reboot.c b/kernel/reboot.c
index 0a97794..e0f640b 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -6,6 +6,7 @@
 
 #define pr_fmt(fmt)	"reboot: " fmt
 
+#include <linux/ctype.h>
 #include <linux/export.h>
 #include <linux/kexec.h>
 #include <linux/kmod.h>
@@ -87,7 +88,7 @@ EXPORT_SYMBOL(unregister_reboot_notifier);
 static void migrate_to_reboot_cpu(void)
 {
 	/* The boot cpu is always logical cpu 0 */
-	int reboot_cpu = 0;
+	int reboot_cpu = reboot_cpu;
 
 	cpu_hotplug_disable();
 
@@ -343,3 +344,90 @@ int orderly_poweroff(bool force)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(orderly_poweroff);
+
+int reboot_default;
+enum reboot_mode reboot_mode = REBOOT_COLD;
+int reboot_cpu;
+enum reboot_type reboot_type = BOOT_ACPI;
+int reboot_force;
+
+/*
+ * reboot=b[ios] | s[mp] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old] | p[ci]
+ * warm   Don't set the cold reboot flag
+ * cold   Set the cold reboot flag
+ * bios   Reboot by jumping through the BIOS
+ * smp    Reboot by executing reset on BSP or other CPU
+ * triple Force a triple fault (init)
+ * kbd    Use the keyboard controller. cold reset (default)
+ * acpi   Use the RESET_REG in the FADT
+ * efi    Use efi reset_system runtime service
+ * pci    Use the so-called "PCI reset register", CF9
+ * force  Avoid anything that could hang.
+ */
+static int __init reboot_setup(char *str)
+{
+	for (;;) {
+		/*
+		 * Having anything passed on the command line via
+		 * reboot= will cause us to disable DMI checking
+		 * below.
+		 */
+		reboot_default = 0;
+
+		switch (*str) {
+#if defined(CONFIG_X86) || defined(CONFIG_X86_64)
+		case 'w':
+			reboot_mode = REBOOT_WARM;
+			break;
+
+		case 'c':
+			reboot_mode = REBOOT_COLD;
+			break;
+
+#ifdef CONFIG_SMP
+		case 's':
+			if (isdigit(*(str+1))) {
+				reboot_cpu = (int) (*(str+1) - '0');
+				if (isdigit(*(str+2)))
+					reboot_cpu = reboot_cpu*10 + (int)(*(str+2) - '0');
+			}
+			/*
+			 * We will leave sorting out the final value
+			 * when we are ready to reboot, since we might not
+			 * have detected BSP APIC ID or smp_num_cpu
+			 */
+			break;
+#endif /* CONFIG_SMP */
+
+#else
+		case 's':
+			reboot_mode = REBOOT_WARM;
+		case 'h':
+			reboot_mode = REBOOT_COLD;
+		case 'g':
+			reboot_mode = REBOOT_GPIO;
+#endif
+
+		case 'b':
+		case 'a':
+		case 'k':
+		case 't':
+		case 'e':
+		case 'p':
+			reboot_type = *str;
+			break;
+
+		case 'f':
+			reboot_force = 1;
+			break;
+		}
+
+		str = strchr(str, ',');
+		if (str)
+			str++;
+		else
+			break;
+	}
+	return 1;
+}
+__setup("reboot=", reboot_setup);
-- 
1.8.2.1

