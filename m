Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278Ab3HSRtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:49:15 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51495 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3HSRtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:49:13 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH V2 10/10] Add option to automatically enforce module signatures when in Secure Boot mode
Date: Mon, 19 Aug 2013 13:26:11 -0400
Message-Id: <1376933171-9854-11-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UEFI Secure Boot provides a mechanism for ensuring that the firmware will
only load signed bootloaders and kernels. Certain use cases may also
require that all kernel modules also be signed. Add a configuration option
that enforces this automatically when enabled.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 Documentation/x86/zero-page.txt       |  2 ++
 arch/x86/Kconfig                      | 10 ++++++++++
 arch/x86/boot/compressed/eboot.c      | 33 +++++++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/bootparam.h |  3 ++-
 arch/x86/kernel/setup.c               |  6 ++++++
 include/linux/module.h                |  6 ++++++
 kernel/module.c                       |  7 +++++++
 7 files changed, 66 insertions(+), 1 deletion(-)

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
index b32ebf9..6a6c19b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1581,6 +1581,16 @@ config EFI_STUB
 
 	  See Documentation/x86/efi-stub.txt for more information.
 
+config EFI_SECURE_BOOT_SIG_ENFORCE
+        def_bool n
+	prompt "Force module signing when UEFI Secure Boot is enabled"
+	---help---
+	  UEFI Secure Boot provides a mechanism for ensuring that the
+	  firmware will only load signed bootloaders and kernels. Certain
+	  use cases may also require that all kernel modules also be signed.
+	  Say Y here to automatically enable module signature enforcement
+	  when a system boots with UEFI Secure Boot enabled.
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b7388a4..145294d 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -861,6 +861,37 @@ fail:
 	return status;
 }
 
+static int get_secure_boot(efi_system_table_t *_table)
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
@@ -1169,6 +1200,8 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		goto fail;
 
+	boot_params->secure_boot = get_secure_boot(sys_table);
+
 	setup_graphics(boot_params);
 
 	setup_efi_pci(boot_params);
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index c15ddaf..d35da96 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -131,7 +131,8 @@ struct boot_params {
 	__u8  eddbuf_entries;				/* 0x1e9 */
 	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
 	__u8  kbd_status;				/* 0x1eb */
-	__u8  _pad5[3];					/* 0x1ec */
+	__u8  secure_boot;				/* 0x1ec */
+	__u8  _pad5[2];					/* 0x1ec */
 	/*
 	 * The sentinel is set to a nonzero value (0xff) in header.S.
 	 *
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f8ec578..deeb7bc 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1129,6 +1129,12 @@ void __init setup_arch(char **cmdline_p)
 
 	io_delay_init();
 
+#ifdef CONFIG_EFI_SECURE_BOOT_SIG_ENFORCE
+	if (boot_params.secure_boot) {
+		enforce_signed_modules();
+	}
+#endif
+
 	/*
 	 * Parse the ACPI tables for possible boot-time SMP configuration.
 	 */
diff --git a/include/linux/module.h b/include/linux/module.h
index 0c266b2..5a6374a 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -184,6 +184,12 @@ const struct exception_table_entry *search_exception_tables(unsigned long add);
 
 struct notifier_block;
 
+#ifdef CONFIG_MODULE_SIG
+extern void enforce_signed_modules(void);
+#else
+static inline void enforce_signed_modules(void) {};
+#endif
+
 #ifdef CONFIG_MODULES
 
 extern int modules_disabled; /* for sysctl */
diff --git a/kernel/module.c b/kernel/module.c
index 801021e..0ec29c0 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3853,6 +3853,13 @@ void module_layout(struct module *mod,
 EXPORT_SYMBOL(module_layout);
 #endif
 
+#ifdef CONFIG_MODULE_SIG
+void enforce_signed_modules(void)
+{
+	sig_enforce = true;
+}
+#endif
+
 bool secure_modules(void)
 {
 #ifdef CONFIG_MODULE_SIG
-- 
1.8.3.1

