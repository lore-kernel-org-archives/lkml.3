Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaDDGsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:48:53 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:54448 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbaDDGlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:41:24 -0400
Date: Fri, 4 Apr 2014 08:41:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH] x86: Try the BIOS reboot method before the PCI reboot method
Message-ID: <20140404064120.GB11877@gmail.com>
References: <20140403021411.6236996f@gandalf.local.home>
 <070BEF4AC20468458C22969097656CD91163106C@shsmsx102.ccr.corp.intel.com>
 <533D001A.5030802@linux.intel.com>
 <20140403094155.04cc00bc@gandalf.local.home>
 <533D6BE7.3020608@zytor.com>
 <20140403104721.5f6c32b6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403104721.5f6c32b6@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 03 Apr 2014 07:10:47 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > Could you tell which of these modes work on your box:

Basically my thinking is that the patch should be reverted, if my fix 
below does not work.

I distilled your test results into:

  reboot=t       # triple fault                  ok
  reboot=k       # keyboard ctrl                 FAIL
  reboot=b       # BIOS                          ok
  reboot=a       # ACPI                          FAIL
  reboot=e       # EFI                           FAIL   [system has no EFI]
  reboot=p       # PCI 0xcf9                     FAIL
 
And I think it's pretty obvious that we should only try 0xcf9 as a 
last resort - if at all. For some reason the 0xcf9 reboot method got 
marked 'safe' - why is that? If only pci_direct_probe() had funny 
extra lines /* like this */ ...

The other observation is that (on this box) we should try the 'BIOS' 
method before the PCI method.

Thirdly, CF9_COND is a total misnomer - it should be something like 
CF9_SAFE or CF9_CAREFUL, and 'CF9' should be 'CF9_FORCE' ...

[ Plus all the BOOT_ flags are total misnomers as well, why aren't 
  they named REBOOT_ ...? ]

Anyway, the patch below fixes the worst problems:

 - it orders the actual reboot logic to follow the reboot ordering 
   pattern - it was in a pretty random order before for no good 
   reason.

 - it fixes the CF9 misnomers and uses BOOT_CF9_FORCE and 
   BOOT_CF9_SAFE flags to make the code more obvious.

 - it tries the BIOS reboot method before the PCI reboot method.

Only build tested.

Alternatively we could just use the following reboot order:

 * 1) If the FADT has the ACPI reboot register flag set, try it
 * 2) If still alive, write to the keyboard controller
 * 3) If still alive, write to the ACPI reboot register again
 * 4) If still alive, write to the keyboard controller again
 * 5) If still alive, call the EFI runtime service to reboot
 * 6) If still alive, force a triple fault

I.e. eliminate the 'PCI' and 'BIOS' methods from our default sequence, 
as both are documented as being able to hang some boxes.

Thanks,

	Ingo

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
 
