Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab3ILHz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 03:55:26 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:50179 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348Ab3ILHzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 03:55:25 -0400
Date: Thu, 12 Sep 2013 08:55:00 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Darren Hart <darren.hart@intel.com>
Cc: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>,
        matthew.garrett@nebula.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
Message-ID: <20130912075500.GC895@console-pimps.org>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
 <516EAC4A.6040202@console-pimps.org>
 <516F1B90.9040508@nexus-software.ie>
 <516FD24A.3070502@console-pimps.org>
 <51700876.1000305@intel.com>
 <51701D2E.6060903@console-pimps.org>
 <51708D3D.9010707@intel.com>
 <5170F736.2060803@console-pimps.org>
 <1378835007.19978.125.camel@dvhart-mobl4.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378835007.19978.125.camel@dvhart-mobl4.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep, at 10:43:27AM, Darren Hart wrote:
> Josh OK'd this, but as far as I can tell, it hasn't made it upstream
> yet. Matt was there an alternate fixed pushed?

Nope, this one slipped through the cracks. Thanks for following up!

Here's the patch I just applied on the 'urgent' branch.

---

>From e285df5368b33efcc9a0ca5b4ed87b0e0c590218 Mon Sep 17 00:00:00 2001
From: Josh Boyer <jwboyer@redhat.com>
Date: Thu, 18 Apr 2013 07:51:34 -0700
Subject: [PATCH] x86, efi: Don't map Boot Services on i386

Add patch to fix 32bit EFI service mapping (rhbz 726701)

Multiple people are reporting hitting the following WARNING on i386,

  WARNING: at arch/x86/mm/ioremap.c:102 __ioremap_caller+0x3d3/0x440()
  Modules linked in:
  Pid: 0, comm: swapper Not tainted 3.9.0-rc7+ #95
  Call Trace:
   [<c102b6af>] warn_slowpath_common+0x5f/0x80
   [<c1023fb3>] ? __ioremap_caller+0x3d3/0x440
   [<c1023fb3>] ? __ioremap_caller+0x3d3/0x440
   [<c102b6ed>] warn_slowpath_null+0x1d/0x20
   [<c1023fb3>] __ioremap_caller+0x3d3/0x440
   [<c106007b>] ? get_usage_chars+0xfb/0x110
   [<c102d937>] ? vprintk_emit+0x147/0x480
   [<c1418593>] ? efi_enter_virtual_mode+0x1e4/0x3de
   [<c102406a>] ioremap_cache+0x1a/0x20
   [<c1418593>] ? efi_enter_virtual_mode+0x1e4/0x3de
   [<c1418593>] efi_enter_virtual_mode+0x1e4/0x3de
   [<c1407984>] start_kernel+0x286/0x2f4
   [<c1407535>] ? repair_env_string+0x51/0x51
   [<c1407362>] i386_start_kernel+0x12c/0x12f

Due to the workaround described in commit 916f676f8 ("x86, efi: Retain
boot service code until after switching to virtual mode") EFI Boot
Service regions are mapped for a period during boot. Unfortunately, with
the limited size of the i386 direct kernel map it's possible that some
of the Boot Service regions will not be directly accessible, which
causes them to be ioremap()'d, triggering the above warning as the
regions are marked as E820_RAM in the e820 memmap.

There are currently only two situations where we need to map EFI Boot
Service regions,

  1. To workaround the firmware bug described in 916f676f8
  2. To access the ACPI BGRT image

but since we haven't seen an i386 implementation that requires either,
this simple fix should suffice for now.

[ Added to changelog - Matt ]

Reported-by: Bryan O'Donoghue <bryan.odonoghue.lkml@nexus-software.ie>
Acked-by: Tom Zanussi <tom.zanussi@intel.com>
Acked-by: Darren Hart <dvhart@linux.intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/platform/efi/efi.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 90f6ed1..c7e22ab 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -912,10 +912,13 @@ void __init efi_enter_virtual_mode(void)
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
-		    md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
-			continue;
+		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
+#ifdef CONFIG_X86_64
+			if (md->type != EFI_BOOT_SERVICES_CODE &&
+			    md->type != EFI_BOOT_SERVICES_DATA)
+#endif
+				continue;
+		}
 
 		size = md->num_pages << EFI_PAGE_SHIFT;
 		end = md->phys_addr + size;
-- 
1.8.1.4

-- 
Matt Fleming, Intel Open Source Technology Center
