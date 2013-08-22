Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab3HVLFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:05:14 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60020 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab3HVLFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:05:09 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        Matthew Garrett <mjg@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH 10/18] efi: Enable secure boot lockdown automatically when enabled in firmware
Date: Thu, 22 Aug 2013 19:01:49 +0800
Message-Id: <1377169317-5959-11-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1377169317-5959-1-git-send-email-jlee@suse.com>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

The firmware has a set of flags that indicate whether secure boot is enabled
and enforcing. Use them to indicate whether the kernel should lock itself
down.  We also indicate the machine is in secure boot mode by adding the
EFI_SECURE_BOOT bit for use with efi_enabled.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Acked-by: Lee, Chun-Yi <jlee@suse.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 Documentation/x86/zero-page.txt        |    2 ++
 arch/x86/boot/compressed/eboot.c       |   32 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/bootparam_utils.h |    8 ++++++--
 arch/x86/include/uapi/asm/bootparam.h  |    3 ++-
 arch/x86/kernel/setup.c                |    7 +++++++
 include/linux/cred.h                   |    2 ++
 include/linux/efi.h                    |    1 +
 7 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero-page.txt
index 199f453..ff651d3 100644
--- a/Documentation/x86/zero-page.txt
+++ b/Documentation/x86/zero-page.txt
@@ -30,6 +30,8 @@ Offset	Proto	Name		Meaning
 1E9/001	ALL	eddbuf_entries	Number of entries in eddbuf (below)
 1EA/001	ALL	edd_mbr_sig_buf_entries	Number of entries in edd_mbr_sig_buffer
 				(below)
+1EB/001	ALL	kbd_status	Numlock is enabled
+1EC/001	ALL	secure_boot	Kernel should enable secure boot lockdowns
 1EF/001	ALL	sentinel	Used to detect broken bootloaders
 290/040	ALL	edd_mbr_sig_buffer EDD MBR signatures
 2D0/A00	ALL	e820_map	E820 memory map table
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index d606463..9baee3e 100644
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
@@ -1169,6 +1199,8 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		goto fail;
 
+	boot_params->secure_boot = get_secure_boot(sys_table);
+
 	setup_graphics(boot_params);
 
 	setup_efi_pci(boot_params);
diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
index 653668d..69a6c08 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -38,9 +38,13 @@ static void sanitize_boot_params(struct boot_params *boot_params)
 		memset(&boot_params->olpc_ofw_header, 0,
 		       (char *)&boot_params->efi_info -
 			(char *)&boot_params->olpc_ofw_header);
-		memset(&boot_params->kbd_status, 0,
+		memset(&boot_params->kbd_status, 0, sizeof(boot_params->kbd_status));
+		/* don't clear boot_params->secure_boot.  we set that ourselves
+		 * earlier.
+		 */
+		memset(&boot_params->_pad5[0], 0,
 		       (char *)&boot_params->hdr -
-		       (char *)&boot_params->kbd_status);
+		       (char *)&boot_params->_pad5[0]);
 		memset(&boot_params->_pad7[0], 0,
 		       (char *)&boot_params->edd_mbr_sig_buffer[0] -
 			(char *)&boot_params->_pad7[0]);
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
index f8ec578..2a8168a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1129,6 +1129,13 @@ void __init setup_arch(char **cmdline_p)
 
 	io_delay_init();
 
+	if (boot_params.secure_boot) {
+#ifdef CONFIG_EFI
+		set_bit(EFI_SECURE_BOOT, &x86_efi_facility);
+#endif
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
index 5f8f176..febce85 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -634,6 +634,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
 #define EFI_MEMMAP		4	/* Can we use EFI memory map? */
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
+#define EFI_SECURE_BOOT	6	/* Are we in Secure Boot mode? */
 
 #ifdef CONFIG_EFI
 # ifdef CONFIG_X86
-- 
1.6.4.2

