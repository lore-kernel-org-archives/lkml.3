Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966781Ab3DQWDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 18:03:42 -0400
Received: from relay2.blacknight.com ([78.153.203.205]:52537 "EHLO
	relay2.blacknight.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965974Ab3DQWDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 18:03:39 -0400
From: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
To: matt@console-pimps.org, matthew.garrett@nebula.com
Cc: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, darren.hart@intel.com,
        josh@joshtriplett.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Subject: [PATCH] Remove warning in efi_enter_virtual_mode V2
Date: Wed, 17 Apr 2013 23:05:41 +0100
Message-Id: <1366236341-22615-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some EFI BIOS stores BGRT data in the wrong place and some EFI based
BIOS also requires mapping of boot code/data when doing
efi_enter_virtual_mode.

Current code in efi_enter_virtual_mode maps both EFI_RUNTIME_MEMORY and
BIOS boot code/data.

This patch gives the option to switch off that behavior - if your BIOS
has neither BGRT - nor bugs that require mapping of EFI boot code/data

Removes the following warning when booting Linux with an EFI BIOS that
is bug free on IA32

------------[ cut here ]------------
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
---[ end trace 4eaa2a86a8e2da22 ]---

Mapping only memory EFI_RUNTIME_MEMORY is is consistent with the code in
arch/ia64/kernel/efi.c:efi_enter_virtual_mode();

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue.lkml@nexus-software.ie>
---
 Documentation/kernel-parameters.txt |    4 ++++
 arch/x86/platform/efi/efi.c         |   14 +++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..faaa5cb 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1856,6 +1856,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	noefi		[X86] Disable EFI runtime services support.
 
+	noefi_virt_mapboot
+			[X86] Do not map EFI boot code/data when calling
+			efi_enter_virtual_mode().
+
 	noexec		[IA-64]
 
 	noexec		[X86]
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 5f2ecaf..64f98cd 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -88,6 +88,14 @@ static int __init setup_noefi(char *arg)
 }
 early_param("noefi", setup_noefi);
 
+static bool __initdata virt_mapboot = true;
+static int __init setup_noefi_virt_mapboot(char *arg)
+{
+	virt_mapboot = false;
+	return 0;
+}
+early_param("noefi_virt_mapboot", setup_noefi_virt_mapboot);
+
 int add_efi_memmap;
 EXPORT_SYMBOL(add_efi_memmap);
 
@@ -884,9 +892,9 @@ void __init efi_enter_virtual_mode(void)
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
-		    md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
+		if (!((md->attribute & EFI_MEMORY_RUNTIME) || (virt_mapboot &&
+			(md->type == EFI_BOOT_SERVICES_CODE ||
+			 md->type == EFI_BOOT_SERVICES_DATA))))
 			continue;
 
 		size = md->num_pages << EFI_PAGE_SHIFT;
-- 
1.7.10.4

