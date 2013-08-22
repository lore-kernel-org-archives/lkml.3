Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3HVLGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:06:51 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33432 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3HVLGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:06:47 -0400
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
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH 18/18] Hibernate: notify bootloader regenerate key-pair for snapshot verification
Date: Thu, 22 Aug 2013 19:01:57 +0800
Message-Id: <1377169317-5959-19-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1377169317-5959-1-git-send-email-jlee@suse.com>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduced SNAPSHOT_REGEN_KEYS kernel config, enable this
option let kernel notify booloader (e.g. shim) to regenerate key-pair of
snapshot verification for each hibernate.

Kernel loaded S4 sign key in efi stub, so the private key forward from
efi bootloader to kernel in UEFI secure environment. Regenerate key-pair
for each hibernate will gain more security but it hurt the lifetime of
EFI flash memory.

Kernel write an non-volatile runtime efi variable, the name is
GenS4Key-fe141863-c070-478e-b8a3-878a5dc9ef21, to notify efi bootloader
regenerate key-pair for next hibernate cycle.

Userland hibernate tool can write GenS4Key at runtime, kernel will
respect the value but not overwrite it when S4. This mechanism let
userland tool can also notify bootloader to regenerate key-pair through
GenS4Key flag.

Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 kernel/power/Kconfig          |   15 +++++++++++++++
 kernel/power/hibernate_keys.c |   39 +++++++++++++++++++++++++++++++++++++++
 kernel/power/power.h          |    2 ++
 kernel/power/snapshot.c       |    3 +++
 4 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 79b34fa..63bda98 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -78,6 +78,21 @@ config SNAPSHOT_VERIFICATION
 	  dependent on UEFI environment. EFI bootloader should generate the
 	  key-pair.
 
+config SNAPSHOT_REGEN_KEYS
+	bool "Regenerate key-pair for each snapshot verification"
+        depends on SNAPSHOT_VERIFICATION
+	help
+	  Enabled this option let kernel notify booloader (e.g. shim) to
+	  regenerate key-pair of snapshot verification for each hibernate.
+	  Linux kernel write an non-volatile runtime EFI variable, the name
+	  is GenS4Key-fe141863-c070-478e-b8a3-878a5dc9ef21, to notify EFI
+	  bootloader regenerate key-pair for next hibernate cycle.
+
+	  Userland hibernate tool can write GenS4Key at runtime then kernel
+	  will respect the value but not overwrite it when S4. This mechanism
+	  let userland tool can also notify bootloader to regenerate key-pair
+	  through GenS4Key flag.
+
 choice
 	prompt "Which hash algorithm should snapshot be signed with?"
         depends on SNAPSHOT_VERIFICATION
diff --git a/kernel/power/hibernate_keys.c b/kernel/power/hibernate_keys.c
index 1bc5976..60d3e73 100644
--- a/kernel/power/hibernate_keys.c
+++ b/kernel/power/hibernate_keys.c
@@ -7,6 +7,8 @@
 
 #include "power.h"
 
+static efi_char16_t efi_gens4key_name[9] = { 'G', 'e', 'n', 'S', '4', 'K', 'e', 'y', 0 };
+
 static void *skey_data;
 static void *skey_data_buf;
 static unsigned long skey_dsize;
@@ -273,6 +275,42 @@ size_t get_key_length(const struct key *key)
 	return len;
 }
 
+void set_key_regen_flag(void)
+{
+#ifdef CONFIG_SNAPSHOT_REGEN_KEYS
+	unsigned long datasize;
+	u8 gens4key;
+	efi_status_t status;
+
+	/* existing flag may set by userland, respect but not overwrite it */
+	datasize = 0;
+	status = efi.get_variable(efi_gens4key_name, &EFI_HIBERNATE_GUID,
+				  NULL, &datasize, NULL);
+	if (status == EFI_BUFFER_TOO_SMALL)
+		return;
+
+	/* set flag of key-pair regeneration */
+	gens4key = 1;
+	status = efi.set_variable(efi_gens4key_name, &EFI_HIBERNATE_GUID,
+				  EFI_VARIABLE_NON_VOLATILE |
+				  EFI_VARIABLE_BOOTSERVICE_ACCESS |
+				  EFI_VARIABLE_RUNTIME_ACCESS,
+				  1, (void *)&gens4key);
+	if (status)
+		pr_err("PM: Set GenS4Key flag fail: 0x%lx\n", status);
+#endif
+}
+
+static void clean_key_regen_flag(void)
+{
+	/* clean flag of key-pair regeneration */
+	efi.set_variable(efi_gens4key_name, &EFI_HIBERNATE_GUID,
+			 EFI_VARIABLE_NON_VOLATILE |
+			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
+			 EFI_VARIABLE_RUNTIME_ACCESS,
+			 0, NULL);
+}
+
 static int __init init_sign_key_data(void)
 {
 	skey_data = (void *)get_zeroed_page(GFP_KERNEL);
@@ -283,6 +321,7 @@ static int __init init_sign_key_data(void)
 		efi_erase_s4_skey_data();
 		pr_info("PM: Load s4 sign key from EFI\n");
 	}
+	clean_key_regen_flag();
 
 	return 0;
 }
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 84e0b06..3fcde36 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -181,6 +181,7 @@ extern void restore_sign_key_data(void);
 extern bool swsusp_page_is_sign_key(struct page *page);
 extern unsigned long get_skey_data_buf_pfn(void);
 extern void clone_skey_data(void *page_addr);
+extern void set_key_regen_flag(void);
 #else /* !CONFIG_SUSPEND */
 static inline void restore_sign_key_data(void) {}
 static inline bool swsusp_page_is_sign_key(struct page *page)
@@ -191,6 +192,7 @@ static inline unsigned long get_skey_data_buf_pfn(void)
 {
 	return 0;
 }
+static inline void set_key_regen_flag(void) {}
 #endif /* !CONFIG_SNAPSHOT_VERIFICATION */
 
 /* kernel/power/block_io.c */
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index f02e351..12174ff 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1769,6 +1769,9 @@ asmlinkage int swsusp_save(void)
 	printk(KERN_INFO "PM: Hibernation image created (%d pages copied)\n",
 		nr_pages);
 
+	/* set regenerate key flag */
+	set_key_regen_flag();
+
 	return 0;
 }
 
-- 
1.6.4.2

