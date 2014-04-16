Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbaDPNWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:22:08 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:59460 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbaDPNWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:22:05 -0400
Date: Wed, 16 Apr 2014 15:21:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20140416132157.GA14255@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   # HEAD: 5be44a6fb1edb57d7d2d77151870dcd79c8c0e58 x86: Remove the PCI reboot method from the default chain

Various fixes:

 - reboot regression fix
 - build message spam fix
 - GPU quirk fix
 - 'make kvmconfig' fix

Plus the wire-up of the renameat2() system call on i386.

  out-of-topic modifications in x86-urgent-for-linus:
  -----------------------------------------------------
  include/linux/reboot.h             # 5be44a6: x86: Remove the PCI reboot method

 Thanks,

	Ingo

------------------>
Antonio Borneo (1):
      x86/platform: Fix "make O=dir kvmconfig"

Ingo Molnar (1):
      x86: Remove the PCI reboot method from the default chain

Masahiro Yamada (1):
      x86/build: Supress "Nothing to be done for ..." messages

Miklos Szeredi (1):
      i386: Wire up the renameat2() syscall

Ville Syrjälä (1):
      x86/gpu: Fix sign extension issue in Intel graphics stolen memory quirks


 arch/x86/Makefile                |  4 +--
 arch/x86/kernel/early-quirks.c   |  2 +-
 arch/x86/kernel/reboot.c         | 72 +++++++++++++++++++++-------------------
 arch/x86/syscalls/Makefile       |  2 ++
 arch/x86/syscalls/syscall_32.tbl |  1 +
 arch/x86/tools/Makefile          |  2 ++
 include/linux/reboot.h           | 14 ++++----
 7 files changed, 52 insertions(+), 45 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 3b9348a..0db8910 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -250,8 +250,8 @@ archclean:
 PHONY += kvmconfig
 kvmconfig:
 	$(if $(wildcard $(objtree)/.config),, $(error You need an existing .config for this target))
-	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config arch/x86/configs/kvm_guest.config
-	$(Q)yes "" | $(MAKE) oldconfig
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config $(srctree)/arch/x86/configs/kvm_guest.config
+	$(Q)yes "" | $(MAKE) -f $(srctree)/Makefile oldconfig
 
 define archhelp
   echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index b0cc380..6e2537c 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -240,7 +240,7 @@ static u32 __init intel_stolen_base(int num, int slot, int func, size_t stolen_s
 	return base;
 }
 
-#define KB(x)	((x) * 1024)
+#define KB(x)	((x) * 1024UL)
 #define MB(x)	(KB (KB (x)))
 #define GB(x)	(MB (KB (x)))
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 654b465..3399d3a 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -114,8 +114,8 @@ EXPORT_SYMBOL(machine_real_restart);
  */
 static int __init set_pci_reboot(const struct dmi_system_id *d)
 {
-	if (reboot_type != BOOT_CF9) {
-		reboot_type = BOOT_CF9;
+	if (reboot_type != BOOT_CF9_FORCE) {
+		reboot_type = BOOT_CF9_FORCE;
 		pr_info("%s series board detected. Selecting %s-method for reboots.\n",
 			d->ident, "PCI");
 	}
@@ -458,20 +458,23 @@ void __attribute__((weak)) mach_reboot_fixups(void)
 }
 
 /*
- * Windows compatible x86 hardware expects the following on reboot:
+ * To the best of our knowledge Windows compatible x86 hardware expects
+ * the following on reboot:
  *
  * 1) If the FADT has the ACPI reboot register flag set, try it
  * 2) If still alive, write to the keyboard controller
  * 3) If still alive, write to the ACPI reboot register again
  * 4) If still alive, write to the keyboard controller again
  * 5) If still alive, call the EFI runtime service to reboot
- * 6) If still alive, write to the PCI IO port 0xCF9 to reboot
- * 7) If still alive, inform BIOS to do a proper reboot
+ * 6) If no EFI runtime service, call the BIOS to do a reboot
  *
- * If the machine is still alive at this stage, it gives up. We default to
- * following the same pattern, except that if we're still alive after (7) we'll
- * try to force a triple fault and then cycle between hitting the keyboard
- * controller and doing that
+ * We default to following the same pattern. We also have
+ * two other reboot methods: 'triple fault' and 'PCI', which
+ * can be triggered via the reboot= kernel boot option or
+ * via quirks.
+ *
+ * This means that this function can never return, it can misbehave
+ * by not rebooting properly and hanging.
  */
 static void native_machine_emergency_restart(void)
 {
@@ -492,6 +495,11 @@ static void native_machine_emergency_restart(void)
 	for (;;) {
 		/* Could also try the reset bit in the Hammer NB */
 		switch (reboot_type) {
+		case BOOT_ACPI:
+			acpi_reboot();
+			reboot_type = BOOT_KBD;
+			break;
+
 		case BOOT_KBD:
 			mach_reboot_fixups(); /* For board specific fixups */
 
@@ -509,43 +517,29 @@ static void native_machine_emergency_restart(void)
 			}
 			break;
 
-		case BOOT_TRIPLE:
-			load_idt(&no_idt);
-			__asm__ __volatile__("int3");
-
-			/* We're probably dead after this, but... */
-			reboot_type = BOOT_KBD;
-			break;
-
-		case BOOT_BIOS:
-			machine_real_restart(MRR_BIOS);
-
-			/* We're probably dead after this, but... */
-			reboot_type = BOOT_TRIPLE;
-			break;
-
-		case BOOT_ACPI:
-			acpi_reboot();
-			reboot_type = BOOT_KBD;
-			break;
-
 		case BOOT_EFI:
 			if (efi_enabled(EFI_RUNTIME_SERVICES))
 				efi.reset_system(reboot_mode == REBOOT_WARM ?
 						 EFI_RESET_WARM :
 						 EFI_RESET_COLD,
 						 EFI_SUCCESS, 0, NULL);
-			reboot_type = BOOT_CF9_COND;
+			reboot_type = BOOT_BIOS;
+			break;
+
+		case BOOT_BIOS:
+			machine_real_restart(MRR_BIOS);
+
+			/* We're probably dead after this, but... */
+			reboot_type = BOOT_CF9_SAFE;
 			break;
 
-		case BOOT_CF9:
+		case BOOT_CF9_FORCE:
 			port_cf9_safe = true;
 			/* Fall through */
 
-		case BOOT_CF9_COND:
+		case BOOT_CF9_SAFE:
 			if (port_cf9_safe) {
-				u8 reboot_code = reboot_mode == REBOOT_WARM ?
-					0x06 : 0x0E;
+				u8 reboot_code = reboot_mode == REBOOT_WARM ?  0x06 : 0x0E;
 				u8 cf9 = inb(0xcf9) & ~reboot_code;
 				outb(cf9|2, 0xcf9); /* Request hard reset */
 				udelay(50);
@@ -553,7 +547,15 @@ static void native_machine_emergency_restart(void)
 				outb(cf9|reboot_code, 0xcf9);
 				udelay(50);
 			}
-			reboot_type = BOOT_BIOS;
+			reboot_type = BOOT_TRIPLE;
+			break;
+
+		case BOOT_TRIPLE:
+			load_idt(&no_idt);
+			__asm__ __volatile__("int3");
+
+			/* We're probably dead after this, but... */
+			reboot_type = BOOT_KBD;
 			break;
 		}
 	}
diff --git a/arch/x86/syscalls/Makefile b/arch/x86/syscalls/Makefile
index f325af2..3323c27 100644
--- a/arch/x86/syscalls/Makefile
+++ b/arch/x86/syscalls/Makefile
@@ -54,5 +54,7 @@ syshdr-$(CONFIG_X86_64)		+= syscalls_64.h
 
 targets	+= $(uapisyshdr-y) $(syshdr-y)
 
+PHONY += all
 all: $(addprefix $(uapi)/,$(uapisyshdr-y))
 all: $(addprefix $(out)/,$(syshdr-y))
+	@:
diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index 96bc506..d6b8679 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -359,3 +359,4 @@
 350	i386	finit_module		sys_finit_module
 351	i386	sched_setattr		sys_sched_setattr
 352	i386	sched_getattr		sys_sched_getattr
+353	i386	renameat2		sys_renameat2
diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index e812034..604a37e 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -40,4 +40,6 @@ $(obj)/insn_sanity.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/ina
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 hostprogs-y	+= relocs
 relocs-objs     := relocs_32.o relocs_64.o relocs_common.o
+PHONY += relocs
 relocs: $(obj)/relocs
+	@:
diff --git a/include/linux/reboot.h b/include/linux/reboot.h
index 9e7db9e..48bf152 100644
--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -20,13 +20,13 @@ enum reboot_mode {
 extern enum reboot_mode reboot_mode;
 
 enum reboot_type {
-	BOOT_TRIPLE = 't',
-	BOOT_KBD = 'k',
-	BOOT_BIOS = 'b',
-	BOOT_ACPI = 'a',
-	BOOT_EFI = 'e',
-	BOOT_CF9 = 'p',
-	BOOT_CF9_COND = 'q',
+	BOOT_TRIPLE	= 't',
+	BOOT_KBD	= 'k',
+	BOOT_BIOS	= 'b',
+	BOOT_ACPI	= 'a',
+	BOOT_EFI	= 'e',
+	BOOT_CF9_FORCE	= 'p',
+	BOOT_CF9_SAFE	= 'q',
 };
 extern enum reboot_type reboot_type;
 
