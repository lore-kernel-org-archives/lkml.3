Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab3IIQBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:01:18 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45194 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3IIQBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:01:13 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        linux-efi@vger.kernel.org, jmorris@namei.org,
        linux-security-module@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 12/12] Add option to automatically set securelevel when in Secure Boot mode
Date: Mon,  9 Sep 2013 11:49:46 -0400
Message-Id: <1378741786-18430-13-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:5d52:9ee3:3e84:6668
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
 arch/x86/kernel/setup.c               |  7 +++++++
 5 files changed, 60 insertions(+), 1 deletion(-)

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
index 30c40f0..6c2b0fd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1595,6 +1595,19 @@ config EFI_STUB
 
 	  See Documentation/x86/efi-stub.txt for more information.
 
+config EFI_SECURE_BOOT_SECURELEVEL
+        def_bool n
+	depends on SECURITY_SECURELEVEL
+	depends on EFI
+	prompt "Automatically set securelevel when UEFI Secure Boot is enabled"
+	---help---
+	  UEFI Secure Boot provides a mechanism for ensuring that the
+	  firmware will only load signed bootloaders and kernels. Certain
+	  use cases may also require that the kernel restrict any userspace
+	  mechanism that could insert untrusted code into the kernel.
+	  Say Y here to automatically enable securelevel enforcement
+	  when a system boots with UEFI Secure Boot enabled.
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b7388a4..53bfe4f 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -12,6 +12,7 @@
 #include <asm/efi.h>
 #include <asm/setup.h>
 #include <asm/desc.h>
+#include <asm/bootparam_utils.h>
 
 #undef memcpy			/* Use memcpy from misc.c */
 
@@ -861,6 +862,37 @@ fail:
 	return status;
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
@@ -1169,6 +1201,10 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		goto fail;
 
+	sanitize_boot_params(boot_params);
+
+	boot_params->secure_boot = get_secure_boot();
+
 	setup_graphics(boot_params);
 
 	setup_efi_pci(boot_params);
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index c15ddaf..85d7685 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -131,7 +131,8 @@ struct boot_params {
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
index f0de629..35ecc60 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -50,6 +50,7 @@
 #include <linux/init_ohci1394_dma.h>
 #include <linux/kvm_para.h>
 #include <linux/dma-contiguous.h>
+#include <linux/security.h>
 
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -1126,6 +1127,12 @@ void __init setup_arch(char **cmdline_p)
 
 	io_delay_init();
 
+#ifdef CONFIG_EFI_SECURE_BOOT_SECURELEVEL
+	if (boot_params.secure_boot) {
+		set_securelevel(1);
+	}
+#endif
+
 	/*
 	 * Parse the ACPI tables for possible boot-time SMP configuration.
 	 */
-- 
1.8.3.1

