Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab3JJPus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:50:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53087 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590Ab3JJPun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:50:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Triplett <josh@joshtriplett.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 055/104] x86, efi: Don't map Boot Services on i386
Date: Thu, 10 Oct 2013 08:41:43 -0700
Message-Id: <1381419752-29733-56-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Boyer <jwboyer@redhat.com>

commit 700870119f49084da004ab588ea2b799689efaf7 upstream.

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
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/platform/efi/efi.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index fe2ac4f..cc657c8 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -900,10 +900,13 @@ void __init efi_enter_virtual_mode(void)
 
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
1.8.1.2

