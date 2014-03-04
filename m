Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbaCDNOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 08:14:53 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:48747 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757371AbaCDNOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 08:14:47 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 11/13] x86/efi: Wire up CONFIG_EFI_MIXED
Date: Tue,  4 Mar 2014 13:14:19 +0000
Message-Id: <1393938861-16797-12-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
References: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Add the Kconfig option and bump the kernel header version so that boot
loaders can check whether the handover code is available if they want.

The xloadflags field in the bzImage header is also updated to reflect
that the kernel supports both entry points by setting both of
XLF_EFI_HANDOVER_32 and XLF_EFI_HANDOVER_64 when CONFIG_EFI_MIXED=y.
XLF_CAN_BE_LOADED_ABOVE_4G is disabled so that the kernel text is
guaranteed to be addressable with 32-bits.

Note that no boot loaders should be using the bits set in xloadflags to
decide which entry point to jump to. The entire scheme is based on the
concept that 32-bit bootloaders always jump to ->handover_offset and
64-bit loaders always jump to ->handover_offset + 512. We set both bits
merely to inform the boot loader that it's safe to use the native
handover offset even if the machine type in the PE/COFF header claims
otherwise.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/Kconfig            | 14 ++++++++++++++
 arch/x86/boot/header.S      | 15 ++++++++++-----
 arch/x86/include/asm/efi.h  | 11 +++++++++++
 arch/x86/kernel/setup.c     |  2 +-
 arch/x86/platform/efi/efi.c |  7 +------
 5 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cd18b8393400..6eaaa323c891 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1582,6 +1582,20 @@ config EFI_STUB
 
 	  See Documentation/efi-stub.txt for more information.
 
+config EFI_MIXED
+	bool "EFI mixed-mode support"
+	depends on EFI_STUB && X86_64
+	---help---
+	   Enabling this feature allows a 64-bit kernel to be booted
+	   on a 32-bit firmware, provided that your CPU supports 64-bit
+	   mode.
+
+	   Note that it is not possible to boot a mixed-mode enabled
+	   kernel via the EFI boot stub - a bootloader that supports
+	   the EFI handover protocol must be used.
+
+	   If unsure, say N.
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index d69d96653325..256388260c88 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -283,7 +283,7 @@ _start:
 	# Part 2 of the header, from the old setup.S
 
 		.ascii	"HdrS"		# header signature
-		.word	0x020c		# header version number (>= 0x0105)
+		.word	0x020d		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
@@ -375,7 +375,8 @@ xloadflags:
 # define XLF0 0
 #endif
 
-#if defined(CONFIG_RELOCATABLE) && defined(CONFIG_X86_64)
+#if defined(CONFIG_RELOCATABLE) && defined(CONFIG_X86_64) && \
+	!defined(CONFIG_EFI_MIXED)
    /* kernel/boot_param/ramdisk could be loaded above 4g */
 # define XLF1 XLF_CAN_BE_LOADED_ABOVE_4G
 #else
@@ -383,10 +384,14 @@ xloadflags:
 #endif
 
 #ifdef CONFIG_EFI_STUB
-# ifdef CONFIG_X86_64
-#  define XLF23 XLF_EFI_HANDOVER_64		/* 64-bit EFI handover ok */
+# ifdef CONFIG_EFI_MIXED
+#  define XLF23 (XLF_EFI_HANDOVER_32|XLF_EFI_HANDOVER_64)
 # else
-#  define XLF23 XLF_EFI_HANDOVER_32		/* 32-bit EFI handover ok */
+#  ifdef CONFIG_X86_64
+#   define XLF23 XLF_EFI_HANDOVER_64		/* 64-bit EFI handover ok */
+#  else
+#   define XLF23 XLF_EFI_HANDOVER_32		/* 32-bit EFI handover ok */
+#  endif
 # endif
 #else
 # define XLF23 0
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 6b19282c6a33..2f882b7ba1b5 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -151,6 +151,17 @@ static inline bool efi_is_native(void)
 	return IS_ENABLED(CONFIG_X86_64) == efi_enabled(EFI_64BIT);
 }
 
+static inline bool efi_runtime_supported(void)
+{
+	if (efi_is_native())
+		return true;
+
+	if (IS_ENABLED(CONFIG_EFI_MIXED) && !efi_enabled(EFI_OLD_MEMMAP))
+		return true;
+
+	return false;
+}
+
 extern struct console early_efi_console;
 extern void parse_efi_setup(u64 phys_addr, u32 data_len);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 51fe9e538991..30a11fed151b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1243,7 +1243,7 @@ void __init setup_arch(char **cmdline_p)
 	 * mismatched firmware/kernel archtectures since there is no
 	 * support for runtime services.
 	 */
-	if (efi_enabled(EFI_BOOT) && !efi_is_native()) {
+	if (efi_enabled(EFI_BOOT) && !efi_runtime_supported()) {
 		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
 		efi_unmap_memmap();
 	}
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index ea3c4fe3adb5..9179d902c401 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -784,12 +784,7 @@ void __init efi_init(void)
 	if (efi_config_init(arch_tables))
 		return;
 
-	/*
-	 * Note: We currently don't support runtime services on an EFI
-	 * that doesn't match the kernel 32/64-bit mode.
-	 */
-
-	if (!efi_is_native())
+	if (!efi_runtime_supported())
 		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
 	else {
 		if (disable_runtime || efi_runtime_init())
-- 
1.8.5.3

