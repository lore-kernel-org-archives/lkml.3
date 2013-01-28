Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab3A1Qoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:44:39 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34034 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab3A1Qmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:42:52 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH 04/15] efi: Enable secure boot lockdown automatically when enabled in firmware
Date: Mon, 28 Jan 2013 11:42:28 -0500
Message-Id: <1359391359-25783-5-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
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
 Documentation/x86/zero-page.txt       |  2 ++
 arch/x86/boot/compressed/eboot.c      | 32 ++++++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/bootparam.h |  3 ++-
 arch/x86/kernel/setup.c               |  5 +++++
 include/linux/cred.h                  |  2 ++
 include/linux/efi.h                   |  1 +
 6 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero-page.txt
index cf5437d..7f9ed48 100644
--- a/Documentation/x86/zero-page.txt
+++ b/Documentation/x86/zero-page.txt
@@ -27,6 +27,8 @@ Offset	Proto	Name		Meaning
 1E9/001	ALL	eddbuf_entries	Number of entries in eddbuf (below)
 1EA/001	ALL	edd_mbr_sig_buf_entries	Number of entries in edd_mbr_sig_buffer
 				(below)
+1EB/001	ALL	kbd_status	Numlock is enabled
+1EC/001	ALL	secure_boot	Kernel should enable secure boot lockdowns
 290/040	ALL	edd_mbr_sig_buffer EDD MBR signatures
 2D0/A00	ALL	e820_map	E820 memory map table
 				(array of struct e820entry)
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 18e329c..f44adce 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -848,6 +848,36 @@ fail:
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
@@ -1142,6 +1172,8 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		goto fail;
 
+	boot_params->secure_boot = get_secure_boot(sys_table);
+
 	setup_graphics(boot_params);
 
 	setup_efi_pci(boot_params);
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index 92862cd..422e056 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -115,7 +115,8 @@ struct boot_params {
 	__u8  eddbuf_entries;				/* 0x1e9 */
 	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
 	__u8  kbd_status;				/* 0x1eb */
-	__u8  _pad6[5];					/* 0x1ec */
+	__u8  secure_boot;				/* 0x1ec */
+	__u8  _pad6[4];					/* 0x1ed */
 	struct setup_header hdr;    /* setup header */	/* 0x1f1 */
 	__u8  _pad7[0x290-0x1f1-sizeof(struct setup_header)];
 	__u32 edd_mbr_sig_buffer[EDD_MBR_SIG_MAX];	/* 0x290 */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 8b24289..5355a54 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1042,6 +1042,11 @@ void __init setup_arch(char **cmdline_p)
 
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
index 7a9498a..1ae16b6 100644
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
1.8.0.2

