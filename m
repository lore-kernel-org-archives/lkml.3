Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbaBZUQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:16:12 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44214 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaBZUQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:16:09 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        linux-efi@vger.kernel.org, jmorris@namei.org,
        linux-security-module@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 12/12] Add option to automatically set trusted_kernel when in Secure Boot mode
Date: Wed, 26 Feb 2014 15:11:13 -0500
Message-Id: <1393445473-15068-13-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UEFI Secure Boot provides a mechanism for ensuring that the firmware will
only load signed bootloaders and kernels. Certain use cases may also
require that the kernel prevent userspace from inserting untrusted kernel
code at runtime. Add a configuration option that enforces this automatically
when enabled.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 Documentation/x86/zero-page.txt       |  2 ++
 arch/x86/Kconfig                      | 13 +++++++++++++
 arch/x86/boot/compressed/eboot.c      | 36 +++++++++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/bootparam.h |  3 ++-
 arch/x86/kernel/setup.c               |  6 ++++++
 5 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero-page.txt
index 199f453..ec38acf 100644
--- a/Documentation/x86/zero-page.txt
+++ b/Documentation/x86/zero-page.txt
@@ -30,6 +30,8 @@ Offset	Proto	Name		Meaning
 1E9/001	ALL	eddbuf_entries	Number of entries in eddbuf (below)
 1EA/001	ALL	edd_mbr_sig_buf_entries	Number of entries in edd_mbr_sig_buffer
 				(below)
+1EB/001	ALL     kbd_status      Numlock is enabled
+1EC/001	ALL     secure_boot	Secure boot is enabled in the firmware
 1EF/001	ALL	sentinel	Used to detect broken bootloaders
 290/040	ALL	edd_mbr_sig_buffer EDD MBR signatures
 2D0/A00	ALL	e820_map	E820 memory map table
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..3856dfb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1585,6 +1585,19 @@ config EFI_STUB
 
 	  See Documentation/efi-stub.txt for more information.
 
+config EFI_SECURE_BOOT_TRUSTED_KERNEL
+        def_bool n
+	depends on SECURITY_TRUSTED_KERNEL
+	depends on EFI
+	prompt "Automatically set trusted_kernel with UEFI Secure Boot"
+	---help---
+	  UEFI Secure Boot provides a mechanism for ensuring that the
+	  firmware will only load signed bootloaders and kernels. Certain
+	  use cases may also require that the kernel restrict any userspace
+	  mechanism that could insert untrusted code into the kernel.
+	  Say Y here to automatically enable trusted_kernel enforcement
+	  when a system boots with UEFI Secure Boot enabled.
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index a7677ba..4836551 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -12,6 +12,7 @@
 #include <asm/efi.h>
 #include <asm/setup.h>
 #include <asm/desc.h>
+#include <asm/bootparam_utils.h>
 
 #undef memcpy			/* Use memcpy from misc.c */
 
@@ -421,6 +422,37 @@ void setup_graphics(struct boot_params *boot_params)
 }
 
 
+static int get_secure_boot(void)
+{
+	u8 sb, setup;
+	unsigned long datasize = sizeof(sb);
+	efi_guid_t var_guid = EFI_GLOBAL_VARIABLE_GUID;
+	efi_status_t status;
+
+	status = efi_call_phys5(sys_table->runtime->get_variable,
+				L"SecureBoot", &var_guid, NULL, &datasize, &sb);
+
+	if (status != EFI_SUCCESS)
+		return 0;
+
+	if (sb == 0)
+		return 0;
+
+
+	status = efi_call_phys5(sys_table->runtime->get_variable,
+				L"SetupMode", &var_guid, NULL, &datasize,
+				&setup);
+
+	if (status != EFI_SUCCESS)
+		return 0;
+
+	if (setup == 1)
+		return 0;
+
+	return 1;
+}
+
+
 /*
  * Because the x86 boot code expects to be passed a boot_params we
  * need to create one ourselves (usually the bootloader would create
@@ -760,6 +792,10 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		goto fail;
 
+	sanitize_boot_params(boot_params);
+
+	boot_params->secure_boot = get_secure_boot();
+
 	setup_graphics(boot_params);
 
 	setup_efi_pci(boot_params);
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index 225b098..90dbfb7 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -133,7 +133,8 @@ struct boot_params {
 	__u8  eddbuf_entries;				/* 0x1e9 */
 	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
 	__u8  kbd_status;				/* 0x1eb */
-	__u8  _pad5[3];					/* 0x1ec */
+	__u8  secure_boot;				/* 0x1ec */
+	__u8  _pad5[2];					/* 0x1ed */
 	/*
 	 * The sentinel is set to a nonzero value (0xff) in header.S.
 	 *
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 06853e6..875258e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -50,6 +50,7 @@
 #include <linux/init_ohci1394_dma.h>
 #include <linux/kvm_para.h>
 #include <linux/dma-contiguous.h>
+#include <linux/security.h>
 
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -1143,6 +1144,11 @@ void __init setup_arch(char **cmdline_p)
 
 	io_delay_init();
 
+#ifdef CONFIG_EFI_SECURE_BOOT_TRUSTED_KERNEL
+	if (boot_params.secure_boot)
+		set_trusted_kernel(true);
+#endif
+
 	/*
 	 * Parse the ACPI tables for possible boot-time SMP configuration.
 	 */
-- 
1.8.5.3

