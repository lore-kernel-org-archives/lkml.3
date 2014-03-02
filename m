Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaCBQww (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 11:52:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43583 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbaCBQwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 11:52:51 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <53130A46.1010801@linux.intel.com>
References: <53110977.8080907@linux.intel.com> <53121496.8060603@linux.intel.com> <20140301172256.GA29417@srcf.ucam.org> <53123DCF.7040500@zytor.com> <20140301202139.GA9759@srcf.ucam.org> <ec95d575-070f-4c62-8b27-3ce281cb192e@email.android.com> <53127AA7.8040700@linux.intel.com> <53127C4B.1060505@zytor.com> <53128DA0.9060105@linux.intel.com> <53129256.6060704@zytor.com> <20140302022334.GA1131@srcf.ucam.org> <c4f4929e-6bab-45b9-ac6b-cbdea5fd57e8@email.android.com> <53130A46.1010801@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot sequence loop
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 02 Mar 2014 08:52:17 -0800
To: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Message-ID: <cfbdc582-9fc0-4335-9974-d508c2da1c71@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are unambiguously dead after BIOS.  There is no retry possible...

On March 2, 2014 2:39:02 AM PST, "Li, Aubrey" <aubrey.li@linux.intel.com> wrote:
>Patch refined as below, welcome any comments.
>
>Thanks,
>-Aubrey
>
>[PATCH] x86/reboot: Introduce all of the known reboot methods into the
>default list
>
>Reboot is the last service linux OS provides to the end user. We are
>supposed to make this function more robust than today. This patch adds
>all of the known reboot methods into the default attempt list. The
>machines requiring reboot=efi or reboot=p or reboot=bios get a chance
>to reboot automatically now.
>
>If there is a new reboot method emerged, we are supposed to add it to
>the default list as well, instead of adding the endless dmidecode
>entry.
>
>If one method required is in the default list in this patch but the
>machine reboot still hangs, that means some methods ahead of the
>required method cause the system hangs, then reboot the machine by
>passing reboot= arguments and submit the reboot dmidecode table quirk.
>
>We are supposed to remove the reboot dmidecode table from the kernel,
>but to be safe, we keep it. This patch prevents us from adding more.
>If you happened to have a machine listed in the reboot dmidecode
>table and this patch makes reboot work on your machine, please submit
>a patch to remove the quirk.
>
>Signed-off-by: Aubrey Li <aubrey.li@intel.com>
>---
> arch/x86/kernel/reboot.c |   13 ++++++++-----
> 1 file changed, 8 insertions(+), 5 deletions(-)
>
>diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
>index c752cb4..807007f 100644
>--- a/arch/x86/kernel/reboot.c
>+++ b/arch/x86/kernel/reboot.c
>@@ -464,9 +464,12 @@ void __attribute__((weak))
>mach_reboot_fixups(void)
>  * 2) If still alive, write to the keyboard controller
>  * 3) If still alive, write to the ACPI reboot register again
>  * 4) If still alive, write to the keyboard controller again
>+ * 5) If still alive, call the EFI runtime service to reboot
>+ * 6) If still alive, write to the PCI IO port 0xCF9 to reboot
>+ * 7) If still alive, inform BIOS to do a proper reboot
>  *
>* If the machine is still alive at this stage, it gives up. We default
>to
>- * following the same pattern, except that if we're still alive after
>(4) we'll
>+ * following the same pattern, except that if we're still alive after
>(7) we'll
>* try to force a triple fault and then cycle between hitting the
>keyboard
>  * controller and doing that
>  */
>@@ -502,7 +505,7 @@ static void native_machine_emergency_restart(void)
> 				attempt = 1;
> 				reboot_type = BOOT_ACPI;
> 			} else {
>-				reboot_type = BOOT_TRIPLE;
>+				reboot_type = BOOT_EFI;
> 			}
> 			break;
>
>@@ -516,7 +519,7 @@ static void native_machine_emergency_restart(void)
> 		case BOOT_BIOS:
> 			machine_real_restart(MRR_BIOS);
>
>-			reboot_type = BOOT_KBD;
>+			reboot_type = BOOT_TRIPLE;
> 			break;
>
> 		case BOOT_ACPI:
>@@ -530,7 +533,7 @@ static void native_machine_emergency_restart(void)
> 						 EFI_RESET_WARM :
> 						 EFI_RESET_COLD,
> 						 EFI_SUCCESS, 0, NULL);
>-			reboot_type = BOOT_KBD;
>+			reboot_type = BOOT_CF9;
> 			break;
>
> 		case BOOT_CF9:
>@@ -548,7 +551,7 @@ static void native_machine_emergency_restart(void)
> 				outb(cf9|reboot_code, 0xcf9);
> 				udelay(50);
> 			}
>-			reboot_type = BOOT_KBD;
>+			reboot_type = BOOT_BIOS;
> 			break;
> 		}
> 	}

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
