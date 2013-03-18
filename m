Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504Ab3CRVfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:35:53 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35934 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933346Ab3CRVcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:32:55 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        kexec@lists.infradead.org, linux-pci@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH 04/12] efi: Enable secure boot lockdown automatically when enabled in firmware
Date: Mon, 18 Mar 2013 17:32:25 -0400
Message-Id: <1363642353-30749-4-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:e0f4:3a1:9c35:d688
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The firmware has a set of flags that indicate whether secure boot is enabled
and enforcing. Use them to indicate whether the kernel should lock itself
down.  We also indicate the machine is in secure boot mode by adding the
EFI_SECURE_BOOT bit for use with efi_enabled.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 Documentation/x86/zero-page.txt       |  3 ++-
 arch/x86/boot/compressed/eboot.c      | 32 ++++++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/bootparam.h |  3 ++-
 arch/x86/kernel/setup.c               |  5 +++++
 include/linux/cred.h                  |  2 ++
 include/linux/efi.h                   |  1 +
 6 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero-page.txt
index 199f453..16f2464 100644
--- a/Documentation/x86/zero-page.txt
+++ b/Documentation/x86/zero-page.txt
@@ -29,7 +29,8 @@ Offset	Proto	Name		Meaning
 1E8/001	ALL	e820_entries	Number of entries in e820_map (below)
 1E9/001	ALL	eddbuf_entries	Number of entries in eddbuf (below)
 1EA/001	ALL	edd_mbr_sig_buf_entries	Number of entries in edd_mbr_sig_buffer
-				(below)
+1EB/001	ALL	kbd_status	Numlock is enabled
+1EC/001	ALL	secure_boot	Kernel should enable secure boot lockdowns
 1EF/001	ALL	sentinel	Used to detect broken bootloaders
 290/040	ALL	edd_mbr_sig_buffer EDD MBR signatures
 2D0/A00	ALL	e820_map	E820 memory map table
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index c205035..96d859d 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -861,6 +861,36 @@ fail:
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
 /*
  * Because the x86 boot code expects to be passed a boot_params we
  * need to create one ourselves (usually the bootloader would create
@@ -1155,6 +1185,8 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		goto fail;
 
+	boot_params->secure_boot = get_secure_boot(sys_table);
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
index 90d8cc9..5ef9285 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1104,6 +1104,11 @@ void __init setup_arch(char **cmdline_p)
 
 	io_delay_init();
 
+	if (boot_params.secure_boot) {
+		set_bit(EFI_SECURE_BOOT, &x86_efi_facility);
+		secureboot_enable();
+	}
+
 	/*
 	 * Parse the ACPI tables for possible boot-time SMP configuration.
 	 */
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 04421e8..9e69542 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -156,6 +156,8 @@ extern int set_security_override_from_ctx(struct cred *, const char *);
 extern int set_create_files_as(struct cred *, struct inode *);
 extern void __init cred_init(void);
 
+extern void secureboot_enable(void);
+
 /*
  * check for validity of credentials
  */
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 9bf2f1f..1bf382b 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -627,6 +627,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
 #define EFI_MEMMAP		4	/* Can we use EFI memory map? */
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
+#define EFI_SECURE_BOOT	6	/* Are we in Secure Boot mode? */
 
 #ifdef CONFIG_EFI
 # ifdef CONFIG_X86
-- 
1.8.1.2

