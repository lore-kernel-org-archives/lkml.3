Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaDDHzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:55:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45881 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaDDHzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:55:01 -0400
Date: Fri, 4 Apr 2014 00:54:37 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, mjg59@srcf.ucam.org,
        aubrey.li@linux.intel.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mjg59@srcf.ucam.org,
        aubrey.li@linux.intel.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20140404064120.GB11877@gmail.com>
References: <20140404064120.GB11877@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/reboot] [PATCH] x86:
  Try the BIOS reboot method before the PCI reboot method
Git-Commit-ID: d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3
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

Commit-ID:  d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3
Gitweb:     http://git.kernel.org/tip/d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Fri, 4 Apr 2014 08:41:26 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Apr 2014 08:48:03 +0200

[PATCH] x86: Try the BIOS reboot method before the PCI reboot method

Steve reported a reboot hang and bisected it back to this commit:

  a4f1987e4c54 x86, reboot: Add EFI and CF9 reboot methods into the default list

He heroically tested all reboot methods and found the following:

  reboot=t       # triple fault                  ok
  reboot=k       # keyboard ctrl                 FAIL
  reboot=b       # BIOS                          ok
  reboot=a       # ACPI                          FAIL
  reboot=e       # EFI                           FAIL   [system has no EFI]
  reboot=p       # PCI 0xcf9                     FAIL

And I think it's pretty obvious that we should only try 0xcf9 as a
last resort - if at all.

The other observation is that (on this box) we should try the 'BIOS'
method before the PCI method.

Thirdly, CF9_COND is a total misnomer - it should be something like
CF9_SAFE or CF9_CAREFUL, and 'CF9' should be 'CF9_FORCE' ...

So this patch fixes the worst problems:

 - it orders the actual reboot logic to follow the reboot ordering
   pattern - it was in a pretty random order before for no good
   reason.

 - it fixes the CF9 misnomers and uses BOOT_CF9_FORCE and
   BOOT_CF9_SAFE flags to make the code more obvious.

 - it tries the BIOS reboot method before the PCI reboot method.

Reported-and-bisected-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Aubrey <aubrey.li@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Link: http://lkml.kernel.org/r/20140404064120.GB11877@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/reboot.c | 68 +++++++++++++++++++++++++-----------------------
 include/linux/reboot.h   | 14 +++++-----
 2 files changed, 43 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 654b465..527dbcb 100644
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
@@ -468,10 +468,15 @@ void __attribute__((weak)) mach_reboot_fixups(void)
  * 6) If still alive, write to the PCI IO port 0xCF9 to reboot
  * 7) If still alive, inform BIOS to do a proper reboot
  *
- * If the machine is still alive at this stage, it gives up. We default to
- * following the same pattern, except that if we're still alive after (7) we'll
- * try to force a triple fault and then cycle between hitting the keyboard
- * controller and doing that
+ * If the machine is still alive at this stage, it gives up.
+ *
+ * We default to following the same pattern, except that we try
+ * (7) [BIOS] before (6) [PCI], and we add 8): try to force a
+ * triple fault and then cycle between hitting the keyboard
+ * controller and doing that.
+ *
+ * This means that this function can never return, it can misbehave
+ * by not rebooting properly and hanging.
  */
 static void native_machine_emergency_restart(void)
 {
@@ -492,6 +497,11 @@ static void native_machine_emergency_restart(void)
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
 
@@ -509,43 +519,29 @@ static void native_machine_emergency_restart(void)
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
@@ -553,7 +549,15 @@ static void native_machine_emergency_restart(void)
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
 
