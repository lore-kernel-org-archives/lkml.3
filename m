Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaIMSjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 14:39:18 -0400
Received: from mga14.intel.com ([192.55.52.115]:65346 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbaIMSh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 14:37:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,518,1406617200"; 
   d="scan'208";a="590897169"
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Glenn P. Williamson" <glenn.p.williamson@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: [PATCH 6/6] x86/efi: introduce EFI_BOOT_SERVICES_WARN
Date: Sat, 13 Sep 2014 11:36:16 -0700
Message-Id: <1410633376-8822-7-git-send-email-ricardo.neri-calderon@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
References: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There may exist buggy implementations of UEFI firmaware that may still
try to access the EFI_BOOT_SERVICES_* memory regions after the call to
ExitBootServices() has been made. This is a violation of the UEFI
specification.

If selected, this debug option will print a warning message if the
conditions mentioned above are met. Along with the warning, the EFI
platform code will fix up the page fault so that the firmware can
proceed further. We are sure that the page fault will be caused by the
firmware trying to access an unmapped page as the kernel has reserved
such pages.

If not selected, EFI_BOOT_SERVICES_CODE/DATA memory regions will be
reserved and mapped along with the runtime memory regions so that the
buggy firmware does not cause any page faults when trying to accessing
such memory regions. This is the approach from Matthew Garrett in commit
916f676f8dc0 ("x86, efi: Retain boot service code until after switching
to virtual mode").

Being more verbose about this kind of illegal access from the firmware
increases the likelihood of this kind firmware bugs to be fixed.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
 arch/x86/Kconfig            | 12 ++++++++++++
 arch/x86/platform/efi/efi.c |  2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 778178f..d1c958a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1565,6 +1565,18 @@ config EFI_MIXED
 
 	   If unsure, say N.
 
+config EFI_BOOT_SERVICES_WARN
+	bool "Warn about illegal accesses to BOOT_SERVICES memory"
+	depends on EFI
+	---help---
+	   Enable this debug feature to make the kernel issue a warning if
+	   memory regions marked as EFI_BOOT_SERVICES_CODE/DATA are
+	   accessed after the kernel calls ExitBootServices() on the
+	   firmware. Please see the UEFI specification for details on
+	   the expectations of memory usage.
+
+	   If unsure, say N.
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index fd52004..c67637b 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -689,7 +689,7 @@ static void * __init efi_map_regions(int *count, int *pg_shift)
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && !defined(CONFIG_EFI_BOOT_SERVICES_WARN)
 			if (md->type != EFI_BOOT_SERVICES_CODE &&
 			    md->type != EFI_BOOT_SERVICES_DATA)
 #endif
-- 
1.9.1

