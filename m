Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaB1EMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 23:12:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:22509 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbaB1EL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 23:11:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,559,1389772800"; 
   d="scan'208";a="483311210"
Message-ID: <53100C8D.1060001@linux.intel.com>
Date: Fri, 28 Feb 2014 12:11:57 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Len.Brown@intel.com, Adam Williamson <awilliam@redhat.com>
Subject: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot sequence
 loop
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to introduce BOOT_EFI and BOOT_CF9 in the reboot sequence
loop, to fix the reboot problem on the known Intel Bay Trail-T based
platform, for example, ASUS-T100 and Dell Venue 8/11 Pro. These
platforms don't support ACPI reboot, we expect to call EFI runtime
service to handle this case, and CF9 is an alternate after EFI.

We don't need any dmidecode based quirks any more, we don't need extra
"reboot=efi" or "reboot=p" in the command line. The machine can be
rebooted automatically with the patch.

References: https://bugzilla.kernel.org/show_bug.cgi?id=70931
Signed-off-by Aubrey Li <aubrey.li@intel.com>
---
 arch/x86/kernel/reboot.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index c752cb4..1b58e00 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -462,11 +462,12 @@ void __attribute__((weak)) mach_reboot_fixups(void)
  *
  * 1) If the FADT has the ACPI reboot register flag set, try it
  * 2) If still alive, write to the keyboard controller
- * 3) If still alive, write to the ACPI reboot register again
- * 4) If still alive, write to the keyboard controller again
+ * 3) If still alive, call EFI runtime service
+ * 4) If still alive, write to the PCI IO port 0xCF9
+ * 5) If still alive, try (1)~(4) one time again
  *
  * If the machine is still alive at this stage, it gives up. We default to
- * following the same pattern, except that if we're still alive after
(4) we'll
+ * following the same pattern, except that if we're still alive after
(5) we'll
  * try to force a triple fault and then cycle between hitting the keyboard
  * controller and doing that
  */
@@ -500,7 +501,7 @@ static void native_machine_emergency_restart(void)
 			}
 			if (attempt == 0 && orig_reboot_type == BOOT_ACPI) {
 				attempt = 1;
-				reboot_type = BOOT_ACPI;
+				reboot_type = BOOT_EFI;
 			} else {
 				reboot_type = BOOT_TRIPLE;
 			}
@@ -530,7 +531,7 @@ static void native_machine_emergency_restart(void)
 						 EFI_RESET_WARM :
 						 EFI_RESET_COLD,
 						 EFI_SUCCESS, 0, NULL);
-			reboot_type = BOOT_KBD;
+			reboot_type = BOOT_CF9;
 			break;

 		case BOOT_CF9:
@@ -548,7 +549,7 @@ static void native_machine_emergency_restart(void)
 				outb(cf9|reboot_code, 0xcf9);
 				udelay(50);
 			}
-			reboot_type = BOOT_KBD;
+			reboot_type = BOOT_ACPI;
 			break;
 		}
 	}
-- 
1.7.10.4
