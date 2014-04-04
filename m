Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaDDHxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:53:55 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59044 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaDDHxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:53:53 -0400
Date: Fri, 4 Apr 2014 09:53:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH] x86: Don't do the BIOS and PCI 0xCF9 reboot methods by
 default
Message-ID: <20140404075350.GA7136@gmail.com>
References: <20140403021411.6236996f@gandalf.local.home>
 <070BEF4AC20468458C22969097656CD91163106C@shsmsx102.ccr.corp.intel.com>
 <533D001A.5030802@linux.intel.com>
 <20140403094155.04cc00bc@gandalf.local.home>
 <533D6BE7.3020608@zytor.com>
 <20140403104721.5f6c32b6@gandalf.local.home>
 <20140404064120.GB11877@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140404064120.GB11877@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Alternatively we could just use the following reboot order:
> 
>  * 1) If the FADT has the ACPI reboot register flag set, try it
>  * 2) If still alive, write to the keyboard controller
>  * 3) If still alive, write to the ACPI reboot register again
>  * 4) If still alive, write to the keyboard controller again
>  * 5) If still alive, call the EFI runtime service to reboot
>  * 6) If still alive, force a triple fault
> 
> I.e. eliminate the 'PCI' and 'BIOS' methods from our default 
> sequence, as both are documented as being able to hang some boxes.

The patch below, on top of my first patch, does that.

Only lightly tested.

My expectation would be that Steve's box reboots fine by default with 
the first patch already, and that it would still reboot fine with the 
second patch applied as well.

Thanks,

	Ingo

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 527dbcb..bd9b0ef 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -470,10 +470,10 @@ void __attribute__((weak)) mach_reboot_fixups(void)
  *
  * If the machine is still alive at this stage, it gives up.
  *
- * We default to following the same pattern, except that we try
- * (7) [BIOS] before (6) [PCI], and we add 8): try to force a
- * triple fault and then cycle between hitting the keyboard
- * controller and doing that.
+ * We default to following the same pattern, except that after
+ * the 5) EFI reboot step we go straight to Linux specific
+ * step 8): try to force a triple fault and then cycle between
+ * hitting the keyboard controller and doing that.
  *
  * This means that this function can never return, it can misbehave
  * by not rebooting properly and hanging.
@@ -525,7 +525,7 @@ static void native_machine_emergency_restart(void)
 						 EFI_RESET_WARM :
 						 EFI_RESET_COLD,
 						 EFI_SUCCESS, 0, NULL);
-			reboot_type = BOOT_BIOS;
+			reboot_type = BOOT_TRIPLE;
 			break;
 
 		case BOOT_BIOS:
