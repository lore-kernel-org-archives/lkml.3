Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315AbaDAIcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 04:32:24 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47809 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaDAIcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:32:21 -0400
Date: Tue, 1 Apr 2014 10:32:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/reboot changes for v3.15
Message-ID: <20140401083217.GA23629@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-reboot-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-reboot-for-linus

   # HEAD: fb3bd7b19b2b6ef779d18573c10c00c53cd8add6 x86, reboot: Only use CF9_COND automatically, not CF9

Refine the reboot logic around the CF9 and EFI reboot methods, to make 
it more robust. The expectation is for no working system to break, and 
for a couple of reboot-force systems to start rebooting automatically 
again.

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, reboot: Only use CF9_COND automatically, not CF9

Li, Aubrey (1):
      x86, reboot: Add EFI and CF9 reboot methods into the default list


 arch/x86/kernel/reboot.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index c752cb4..654b465 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -464,9 +464,12 @@ void __attribute__((weak)) mach_reboot_fixups(void)
  * 2) If still alive, write to the keyboard controller
  * 3) If still alive, write to the ACPI reboot register again
  * 4) If still alive, write to the keyboard controller again
+ * 5) If still alive, call the EFI runtime service to reboot
+ * 6) If still alive, write to the PCI IO port 0xCF9 to reboot
+ * 7) If still alive, inform BIOS to do a proper reboot
  *
  * If the machine is still alive at this stage, it gives up. We default to
- * following the same pattern, except that if we're still alive after (4) we'll
+ * following the same pattern, except that if we're still alive after (7) we'll
  * try to force a triple fault and then cycle between hitting the keyboard
  * controller and doing that
  */
@@ -502,7 +505,7 @@ static void native_machine_emergency_restart(void)
 				attempt = 1;
 				reboot_type = BOOT_ACPI;
 			} else {
-				reboot_type = BOOT_TRIPLE;
+				reboot_type = BOOT_EFI;
 			}
 			break;
 
@@ -510,13 +513,15 @@ static void native_machine_emergency_restart(void)
 			load_idt(&no_idt);
 			__asm__ __volatile__("int3");
 
+			/* We're probably dead after this, but... */
 			reboot_type = BOOT_KBD;
 			break;
 
 		case BOOT_BIOS:
 			machine_real_restart(MRR_BIOS);
 
-			reboot_type = BOOT_KBD;
+			/* We're probably dead after this, but... */
+			reboot_type = BOOT_TRIPLE;
 			break;
 
 		case BOOT_ACPI:
@@ -530,7 +535,7 @@ static void native_machine_emergency_restart(void)
 						 EFI_RESET_WARM :
 						 EFI_RESET_COLD,
 						 EFI_SUCCESS, 0, NULL);
-			reboot_type = BOOT_KBD;
+			reboot_type = BOOT_CF9_COND;
 			break;
 
 		case BOOT_CF9:
@@ -548,7 +553,7 @@ static void native_machine_emergency_restart(void)
 				outb(cf9|reboot_code, 0xcf9);
 				udelay(50);
 			}
-			reboot_type = BOOT_KBD;
+			reboot_type = BOOT_BIOS;
 			break;
 		}
 	}
