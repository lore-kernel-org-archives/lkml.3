Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbaCEXjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 18:39:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38220 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbaCEXjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 18:39:53 -0500
Date: Wed, 5 Mar 2014 15:39:35 -0800
From: "tip-bot for Li, Aubrey" <tipbot@zytor.com>
Message-ID: <tip-a4f1987e4c5489a3877eaa7451a68d28c5a3f664@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mjg59@srcf.ucam.org, aubrey.li@linux.intel.com, tglx@linutronix.de,
        aubrey.li@intel.com, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mjg59@srcf.ucam.org, aubrey.li@linux.intel.com, tglx@linutronix.de,
        aubrey.li@intel.com, hpa@linux.intel.com
In-Reply-To: <53130A46.1010801@linux.intel.com>
References: <53130A46.1010801@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/reboot] x86, reboot:
  Add EFI and CF9 reboot methods into the default list
Git-Commit-ID: a4f1987e4c5489a3877eaa7451a68d28c5a3f664
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

Commit-ID:  a4f1987e4c5489a3877eaa7451a68d28c5a3f664
Gitweb:     http://git.kernel.org/tip/a4f1987e4c5489a3877eaa7451a68d28c5a3f664
Author:     Li, Aubrey <aubrey.li@linux.intel.com>
AuthorDate: Sun, 2 Mar 2014 18:39:02 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 5 Mar 2014 15:27:07 -0800

x86, reboot: Add EFI and CF9 reboot methods into the default list

Reboot is the last service linux OS provides to the end user. We are
supposed to make this function more robust than today. This patch adds
all of the known reboot methods into the default attempt list. The
machines requiring reboot=efi or reboot=p or reboot=bios get a chance
to reboot automatically now.

If there is a new reboot method emerged, we are supposed to add it to
the default list as well, instead of adding the endless dmidecode entry.

If one method required is in the default list in this patch but the
machine reboot still hangs, that means some methods ahead of the
required method cause the system hangs, then reboot the machine by
passing reboot= arguments and submit the reboot dmidecode table quirk.

We are supposed to remove the reboot dmidecode table from the kernel,
but to be safe, we keep it. This patch prevents us from adding more.
If you happened to have a machine listed in the reboot dmidecode
table and this patch makes reboot work on your machine, please submit
a patch to remove the quirk.

The default reboot order with this patch is now:

    ACPI > KBD > ACPI > KBD > EFI > CF9_COND > BIOS

Because BIOS and TRIPLE are mutually exclusive (either will either
work or hang the machine) that method is not included.

[ hpa: as with any changes to the reboot order, this patch will have
  to be monitored carefully for regressions. ]

Signed-off-by: Aubrey Li <aubrey.li@intel.com>
Acked-by: Matthew Garrett <mjg59@srcf.ucam.org>
Link: http://lkml.kernel.org/r/53130A46.1010801@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/reboot.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index c752cb4..f601295 100644
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
+			reboot_type = BOOT_CF9;
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
