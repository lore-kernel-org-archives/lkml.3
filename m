Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbaDPHkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 03:40:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39358 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbaDPHks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 03:40:48 -0400
Date: Wed, 16 Apr 2014 00:40:13 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-5be44a6fb1edb57d7d2d77151870dcd79c8c0e58@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, mjg59@srcf.ucam.org,
        aubrey.li@linux.intel.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mjg59@srcf.ucam.org,
        aubrey.li@linux.intel.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20140404064120.GB11877@gmail.com>
References: <20140404064120.GB11877@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86:
  Remove the PCI reboot method from the default chain
Git-Commit-ID: 5be44a6fb1edb57d7d2d77151870dcd79c8c0e58
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5be44a6fb1edb57d7d2d77151870dcd79c8c0e58
Gitweb:     http://git.kernel.org/tip/5be44a6fb1edb57d7d2d77151870dcd79c8c0e58
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Fri, 4 Apr 2014 08:41:26 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Apr 2014 08:56:09 +0200

x86: Remove the PCI reboot method from the default chain

Steve reported a reboot hang and bisected it back to this commit:

  a4f1987e4c54 x86, reboot: Add EFI and CF9 reboot methods into the default list

He heroically tested all reboot methods and found the following:

  reboot=t       # triple fault                  ok
  reboot=k       # keyboard ctrl                 FAIL
  reboot=b       # BIOS                          ok
  reboot=a       # ACPI                          FAIL
  reboot=e       # EFI                           FAIL   [system has no EFI]
  reboot=p       # PCI 0xcf9                     FAIL

And I think it's pretty obvious that we should only try PCI 0xcf9 as a
last resort - if at all.

The other observation is that (on this box) we should never try
the PCI reboot method, but close with either the 'triple fault'
or the 'BIOS' (terminal!) reboot methods.

Thirdly, CF9_COND is a total misnomer - it should be something like
CF9_SAFE or CF9_CAREFUL, and 'CF9' should be 'CF9_FORCE' ...

So this patch fixes the worst problems:

 - it orders the actual reboot logic to follow the reboot ordering
   pattern - it was in a pretty random order before for no good
   reason.

 - it fixes the CF9 misnomers and uses BOOT_CF9_FORCE and
   BOOT_CF9_SAFE flags to make the code more obvious.

 - it tries the BIOS reboot method before the PCI reboot method.
   (Since 'BIOS' is a terminal reboot method resulting in a hang
    if it does not work, this is essentially equivalent to removing
    the PCI reboot method from the default reboot chain.)

 - just for the miraculous possibility of terminal (resulting
   in hang) reboot methods of triple fault or BIOS returning
   without having done their job, there's an ordering between
   them as well.

Reported-and-bisected-and-tested-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Aubrey <aubrey.li@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Link: http://lkml.kernel.org/r/20140404064120.GB11877@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/reboot.c | 72 +++++++++++++++++++++++++-----------------------
 include/linux/reboot.h   | 14 +++++-----
 2 files changed, 44 insertions(+), 42 deletions(-)

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
 
