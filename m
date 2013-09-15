Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab3IOA57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 20:57:59 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:51751 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab3IOA5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 20:57:54 -0400
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
        "Lee, Chun-Yi" <jlee@suse.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH V4 08/15] Hibernate: introduced RSA key-pair to verify signature of snapshot
Date: Sun, 15 Sep 2013 08:56:54 +0800
Message-Id: <1379206621-18639-9-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1379206621-18639-1-git-send-email-jlee@suse.com>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduced a hibernate_key.c file to query the key pair from EFI variables
and maintain key pair for check signature of S4 snapshot image. We
loaded the private key when snapshot image stored success.

This patch introduced 2 EFI variables for store the key to sign S4 image and
verify signature when S4 wake up. The names and GUID are:
  S4SignKey-fe141863-c070-478e-b8a3-878a5dc9ef21	[BOOT SERVICES][NV]
  S4WakeKey-fe141863-c070-478e-b8a3-878a5dc9ef21	[RUNTIME SERVICES][V]

S4SignKey is used by EFI bootloader to pass the RSA private key that packaged
by PKCS#8 format, kernel will read and parser it when system boot and reload
it when S4 resume. EFI bootloader need gnerate a new private key when every
time system boot.

S4WakeKey is used to parse the RSA public key that packaged by X.509
certificate, kernel will read and parse it for check the signature of
S4 snapshot image when S4 resume.

The follow-up patch will remove S4SignKey and S4WakeKey after load them
to kernel for avoid anyone can access it through efivarfs.

V4:
- Removed duplicate cast of params->hdr.setup_data
- Declare dummy function of setup_s4_keys() and efi_reserve_s4_skey_data() to
  avoid ifdef.
- Use forward_info structure to maintain the empty of forward information and
  new sign key from boot kernel to resume target kernel.
- Use efivar API to access S4WakeKey variable.

V3:
- Load S4 sign key before ExitBootServices.
  Load private key before ExitBootServices() then bootloader doesn't need
  generate key-pair for each booting:
   + Add setup_s4_keys() to eboot.c to load S4 sign key before ExitBootServices.
   + Reserve the memory block of sign key data blob in efi.c
- In Makefile, moved hibernate_keys.o before hibernate.o for load S4 sign
  key before check hibernate image. It makes sure the new sign key will be
  transfer to resume target kernel.
- Set "depends on EFI_STUB" in Kconfig

V2:
Add CONFIG_SNAPSHOT_VERIFICATION for build of hibernate_keys.c depend on
Kconfig.

Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/boot/compressed/eboot.c      |   92 +++++++++++
 arch/x86/include/asm/efi.h            |    9 +
 arch/x86/include/uapi/asm/bootparam.h |    1 +
 arch/x86/platform/efi/efi.c           |   68 ++++++++
 include/linux/efi.h                   |   25 +++
 kernel/power/Kconfig                  |   16 ++-
 kernel/power/Makefile                 |    1 +
 kernel/power/hibernate.c              |    2 +
 kernel/power/hibernate_keys.c         |  292 +++++++++++++++++++++++++++++++++
 kernel/power/power.h                  |   30 ++++
 10 files changed, 534 insertions(+), 2 deletions(-)
 create mode 100644 kernel/power/hibernate_keys.c

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 53bfe4f..983dc7d 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -369,6 +369,96 @@ free_handle:
 	return status;
 }
 
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
+static efi_status_t setup_s4_keys(struct boot_params *params)
+{
+	struct setup_data *data;
+	unsigned long datasize;
+	u32 attr;
+	struct efi_s4_key *s4key;
+	efi_status_t status;
+
+	data = (struct setup_data *)params->hdr.setup_data;
+
+	while (data && data->next)
+		data = (struct setup_data *)(unsigned long)data->next;
+
+	status = efi_call_phys3(sys_table->boottime->allocate_pool,
+				EFI_LOADER_DATA, sizeof(*s4key), &s4key);
+	if (status != EFI_SUCCESS) {
+		efi_printk("Failed to alloc memory for efi_s4_key\n");
+		goto error_setup;
+	}
+
+	s4key->data.type = SETUP_S4_KEY;
+	s4key->data.len = sizeof(struct efi_s4_key) -
+		sizeof(struct setup_data);
+	s4key->data.next = 0;
+	s4key->skey_dsize = 0;
+	s4key->err_status = 0;
+
+	if (data)
+		data->next = (unsigned long)s4key;
+	else
+		params->hdr.setup_data = (unsigned long)s4key;
+
+	/* obtain the size of key data */
+	datasize = 0;
+	status = efi_call_phys5(sys_table->runtime->get_variable,
+				EFI_S4_SIGN_KEY_NAME, &EFI_HIBERNATE_GUID,
+				NULL, &datasize, NULL);
+	if (status != EFI_BUFFER_TOO_SMALL) {
+		efi_printk("Couldn't get S4 key data size\n");
+		goto error_size;
+	}
+	if (datasize > SKEY_DBUF_MAX_SIZE) {
+		efi_printk("The size of S4 sign key is too large\n");
+		status = EFI_UNSUPPORTED;
+		goto error_size;
+	}
+
+	s4key->skey_dsize = datasize;
+	status = efi_call_phys3(sys_table->boottime->allocate_pool,
+				EFI_LOADER_DATA, s4key->skey_dsize,
+				&s4key->skey_data_addr);
+	if (status != EFI_SUCCESS) {
+		efi_printk("Failed to alloc page for S4 key data\n");
+		goto error_s4key;
+	}
+
+	attr = 0;
+	memset((void *)s4key->skey_data_addr, 0, s4key->skey_dsize);
+	status = efi_call_phys5(sys_table->runtime->get_variable,
+				EFI_S4_SIGN_KEY_NAME, &EFI_HIBERNATE_GUID, &attr,
+				&(s4key->skey_dsize), s4key->skey_data_addr);
+	if (status) {
+		efi_printk("Couldn't get S4 key data\n");
+		goto error_gets4key;
+	}
+	if (attr & EFI_VARIABLE_RUNTIME_ACCESS) {
+		efi_printk("S4 sign key can not be a runtime variable\n");
+		memset((void *)s4key->skey_data_addr, 0, s4key->skey_dsize);
+		status = EFI_UNSUPPORTED;
+		goto error_gets4key;
+	}
+
+	return 0;
+
+error_gets4key:
+	efi_call_phys1(sys_table->boottime->free_pool, s4key->skey_data_addr);
+error_s4key:
+error_size:
+	s4key->err_status = status;
+error_setup:
+	return status;
+}
+#else
+static inline efi_status_t setup_s4_keys(struct boot_params *params)
+{
+	return 0;
+}
+#endif /* CONFIG_SNAPSHOT_VERIFICATION */
+
 /*
  * See if we have Graphics Output Protocol
  */
@@ -1209,6 +1299,8 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 
 	setup_efi_pci(boot_params);
 
+	setup_s4_keys(boot_params);
+
 	status = efi_call_phys3(sys_table->boottime->allocate_pool,
 				EFI_LOADER_DATA, sizeof(*gdt),
 				(void **)&gdt);
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 0062a01..56ececa 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -102,6 +102,15 @@ extern void efi_call_phys_epilog(void);
 extern void efi_unmap_memmap(void);
 extern void efi_memory_uc(u64 addr, unsigned long size);
 
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
+struct efi_s4_key {
+	struct setup_data data;
+	unsigned long err_status;
+	unsigned long skey_dsize;
+	void *skey_data_addr;
+};
+#endif
+
 #ifdef CONFIG_EFI
 
 static inline bool efi_is_native(void)
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index 85d7685..79398ff 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -6,6 +6,7 @@
 #define SETUP_E820_EXT			1
 #define SETUP_DTB			2
 #define SETUP_PCI			3
+#define SETUP_S4_KEY			4
 
 /* ram_size flags */
 #define RAMDISK_IMAGE_START_MASK	0x07FF
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 90f6ed1..dd807e3 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -704,6 +704,71 @@ static int __init efi_memmap_init(void)
 	return 0;
 }
 
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
+static unsigned long skey_dsize;
+static u64 skey_data_addr;
+static unsigned long skey_err_status;
+
+bool efi_s4_key_available(void)
+{
+	return skey_dsize && skey_data_addr && !skey_err_status;
+}
+
+unsigned long __init efi_copy_skey_data(void *page_addr)
+{
+	void *key_addr;
+
+	if (efi_s4_key_available()) {
+		key_addr = early_ioremap(skey_data_addr, skey_dsize);
+		memcpy(page_addr, key_addr, skey_dsize);
+		early_iounmap(key_addr, skey_dsize);
+	}
+
+	return skey_dsize;
+}
+
+void __init efi_erase_s4_skey_data(void)
+{
+	void *key_addr;
+
+	key_addr = early_ioremap(skey_data_addr, skey_dsize);
+	memset(key_addr, 0, skey_dsize);
+	early_iounmap(key_addr, skey_dsize);
+	memblock_free(skey_data_addr, skey_dsize);
+	skey_data_addr = 0;
+	skey_dsize = 0;
+}
+
+static void __init efi_reserve_s4_skey_data(void)
+{
+	u64 pa_data;
+	struct setup_data *data;
+	struct efi_s4_key *s4key;
+
+	skey_err_status = 0;
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = early_ioremap(pa_data, sizeof(*s4key));
+		if (data->type == SETUP_S4_KEY) {
+			s4key = (struct efi_s4_key *)data;
+			if (!s4key->err_status) {
+				skey_dsize = s4key->skey_dsize;
+				skey_data_addr = (u64) s4key->skey_data_addr;
+				memblock_reserve(skey_data_addr, skey_dsize);
+			} else {
+				skey_err_status = s4key->err_status;
+				pr_err("Get S4 sign key from EFI fail: 0x%lx\n",
+					skey_err_status);
+			}
+		}
+		pa_data = data->next;
+		early_iounmap(data, sizeof(*s4key));
+	}
+}
+#else
+static inline void efi_reserve_s4_skey_data(void) {}
+#endif /* CONFIG_SNAPSHOT_VERIFICATION */
+
 void __init efi_init(void)
 {
 	efi_char16_t *c16;
@@ -729,6 +794,9 @@ void __init efi_init(void)
 
 	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
 
+	/* keep s4 key from setup_data */
+	efi_reserve_s4_skey_data();
+
 	/*
 	 * Show what we know for posterity
 	 */
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 5f8f176..57e78fc 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -389,6 +389,18 @@ typedef efi_status_t efi_query_variable_store_t(u32 attributes, unsigned long si
 #define EFI_FILE_SYSTEM_GUID \
     EFI_GUID(  0x964e5b22, 0x6459, 0x11d2, 0x8e, 0x39, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b )
 
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
+#define EFI_HIBERNATE_GUID \
+    EFI_GUID(0xfe141863, 0xc070, 0x478e, 0xb8, 0xa3, 0x87, 0x8a, 0x5d, 0xc9, 0xef, 0x21)
+/*
+ * The UEFI variable names of the key-pair to verify S4 snapshot image:
+ * S4SignKey-EFI_HIBERNATE_GUID: The private key is used to sign snapshot
+ * S4WakeKey-EFI_HIBERNATE_GUID: The public key is used to verify snapshot
+ */
+#define EFI_S4_SIGN_KEY_NAME    ((efi_char16_t [10]) { 'S', '4', 'S', 'i', 'g', 'n', 'K', 'e', 'y', 0 })
+#define EFI_S4_WAKE_KEY_NAME    ((efi_char16_t [10]) { 'S', '4', 'W', 'a', 'k', 'e', 'K', 'e', 'y', 0 })
+#endif /* CONFIG_SNAPSHOT_VERIFICATION */
+
 typedef struct {
 	efi_guid_t guid;
 	u64 table;
@@ -577,6 +589,19 @@ extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if pos
 extern void efi_late_init(void);
 extern void efi_free_boot_services(void);
 extern efi_status_t efi_query_variable_store(u32 attributes, unsigned long size);
+
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
+struct forward_info_head {
+	bool                    sig_enforce;
+	int                     sig_check_ret;
+	unsigned long           skey_dsize;
+} __attribute__((packed));
+#define SKEY_DBUF_MAX_SIZE      (PAGE_SIZE - sizeof(struct forward_info_head))
+extern bool efi_s4_key_available(void);
+extern unsigned long efi_copy_skey_data(void *page_addr);
+extern void efi_erase_s4_skey_data(void);
+#endif /* CONFIG_SNAPSHOT_VERIFICATION */
+
 #else
 static inline void efi_late_init(void) {}
 static inline void efi_free_boot_services(void) {}
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index d444c4e..b592d88 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -66,8 +66,17 @@ config HIBERNATION
 
 	  For more information take a look at <file:Documentation/power/swsusp.txt>.
 
-config ARCH_SAVE_PAGE_KEYS
-	bool
+config SNAPSHOT_VERIFICATION
+	bool "Hibernate snapshot verification"
+	depends on HIBERNATION
+	depends on EFI_STUB
+	depends on X86
+	select PKCS8_PRIVATE_KEY_INFO_PARSER
+	help
+	  This option provides support for generate anad verify the signautre by
+	  RSA key-pair against hibernate snapshot image. Current mechanism
+	  dependent on UEFI environment. EFI bootloader should generate the
+	  key-pair.
 
 config PM_STD_PARTITION
 	string "Default resume partition"
@@ -91,6 +100,9 @@ config PM_STD_PARTITION
 	  suspended image to. It will simply pick the first available swap 
 	  device.
 
+config ARCH_SAVE_PAGE_KEYS
+	bool
+
 config PM_SLEEP
 	def_bool y
 	depends on SUSPEND || HIBERNATE_CALLBACKS
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index 29472bf..46b6422 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_VT_CONSOLE_SLEEP)	+= console.o
 obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_SUSPEND)		+= suspend.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
+obj-$(CONFIG_SNAPSHOT_VERIFICATION)    += hibernate_keys.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o \
 				   block_io.o
 obj-$(CONFIG_PM_AUTOSLEEP)	+= autosleep.o
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index b26f5f1..90a25c7 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -28,6 +28,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/ctype.h>
 #include <linux/genhd.h>
+#include <linux/key.h>
 
 #include "power.h"
 
@@ -680,6 +681,7 @@ int hibernate(void)
 		pm_restore_gfp_mask();
 	} else {
 		pr_debug("PM: Image restored successfully.\n");
+		restore_sig_forward_info();
 	}
 
  Thaw:
diff --git a/kernel/power/hibernate_keys.c b/kernel/power/hibernate_keys.c
new file mode 100644
index 0000000..0bce9ab
--- /dev/null
+++ b/kernel/power/hibernate_keys.c
@@ -0,0 +1,292 @@
+#include <linux/sched.h>
+#include <linux/efi.h>
+#include <linux/mpi.h>
+#include <linux/asn1.h>
+#include <crypto/public_key.h>
+#include <keys/asymmetric-type.h>
+
+#include "power.h"
+
+static unsigned char const_seq = (ASN1_SEQ | (ASN1_CONS << 5));
+
+struct forward_info {
+	struct forward_info_head        head;
+	unsigned char                   skey_data_buf[SKEY_DBUF_MAX_SIZE];
+};
+
+static void *skey_data;
+static void *forward_info_buf;
+static unsigned long skey_dsize;
+
+bool swsusp_page_is_sign_key(struct page *page)
+{
+	unsigned long skey_data_pfn;
+	bool ret;
+
+	if (!skey_data || IS_ERR(skey_data))
+		return false;
+
+	skey_data_pfn = page_to_pfn(virt_to_page(skey_data));
+	ret = (page_to_pfn(page) == skey_data_pfn) ? true : false;
+	if (ret)
+		pr_info("PM: Avoid snapshot the page of S4 sign key.\n");
+
+	return ret;
+}
+
+unsigned long get_sig_forward_info_pfn(void)
+{
+	if (!forward_info_buf)
+		return 0;
+
+	return page_to_pfn(virt_to_page(forward_info_buf));
+}
+
+void fill_sig_forward_info(void *page, int sig_check_ret_in)
+{
+	struct forward_info *info;
+
+	if (!page)
+		return;
+
+	memset(page, 0, PAGE_SIZE);
+	info = (struct forward_info *)page;
+
+	info->head.sig_check_ret = sig_check_ret_in;
+	if (skey_data && !IS_ERR(skey_data) &&
+		skey_dsize <= SKEY_DBUF_MAX_SIZE) {
+		info->head.skey_dsize = skey_dsize;
+		memcpy(info->skey_data_buf, skey_data, skey_dsize);
+	} else
+		pr_info("PM: Fill S4 sign key fail, size: %ld\n", skey_dsize);
+
+	pr_info("PM: Filled sign information to forward buffer\n");
+}
+
+void restore_sig_forward_info(void)
+{
+	struct forward_info *info;
+	int sig_check_ret;
+
+	if (!forward_info_buf) {
+		pr_err("PM: Restore S4 sign key fail\n");
+		return;
+	}
+	info = (struct forward_info *)forward_info_buf;
+
+	sig_check_ret = info->head.sig_check_ret;
+	if (sig_check_ret)
+		pr_info("PM: Signature check fail: %d\n", sig_check_ret);
+
+	if (info->head.skey_dsize <= SKEY_DBUF_MAX_SIZE &&
+		info->skey_data_buf[0] == const_seq) {
+
+		/* restore sign key size and data from buffer */
+		skey_dsize = info->head.skey_dsize;
+		memset(skey_data, 0, PAGE_SIZE);
+		memcpy(skey_data, info->skey_data_buf, skey_dsize);
+	}
+
+	/* reset skey page buffer */
+	memset(forward_info_buf, 0, PAGE_SIZE);
+}
+
+bool skey_data_available(void)
+{
+	bool ret = false;
+
+	/* Sign key is PKCS#8 format that must be a Constructed SEQUENCE */
+	ret = skey_data && !IS_ERR(skey_data) &&
+		(skey_dsize != 0) &&
+		((unsigned char *)skey_data)[0] == const_seq;
+
+	return ret;
+}
+
+struct key *get_sign_key(void)
+{
+	const struct cred *cred = current_cred();
+	struct key *skey;
+	int err;
+
+	if (!skey_data || IS_ERR(skey_data))
+		return ERR_PTR(-EBADMSG);
+
+	skey = key_alloc(&key_type_asymmetric, "s4_sign_key",
+			GLOBAL_ROOT_UID, GLOBAL_ROOT_GID,
+			cred, 0, KEY_ALLOC_NOT_IN_QUOTA);
+	if (IS_ERR(skey)) {
+		pr_err("PM: Allocate s4 sign key error: %ld\n", PTR_ERR(skey));
+		goto error_keyalloc;
+	}
+
+	err = key_instantiate_and_link(skey, skey_data, skey_dsize, NULL, NULL);
+	if (err < 0) {
+		pr_err("PM: S4 sign key instantiate error: %d\n", err);
+		if (skey)
+			key_put(skey);
+		skey = ERR_PTR(err);
+		goto error_keyinit;
+	}
+
+	return skey;
+
+error_keyinit:
+error_keyalloc:
+	return skey;
+}
+
+void erase_skey_data(void)
+{
+	if (!skey_data || IS_ERR(skey_data))
+		return;
+
+	memset(skey_data, 0, PAGE_SIZE);
+}
+
+void destroy_sign_key(struct key *skey)
+{
+	erase_skey_data();
+	if (skey)
+		key_put(skey);
+}
+
+static void *load_wake_key_data(unsigned long *datasize)
+{
+	struct efivar_entry *entry;
+	u32 attr;
+	void *wkey_data;
+	int ret;
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return ERR_PTR(-ENOMEM);
+
+	memcpy(entry->var.VariableName, EFI_S4_WAKE_KEY_NAME, sizeof(EFI_S4_WAKE_KEY_NAME));
+	memcpy(&(entry->var.VendorGuid), &EFI_HIBERNATE_GUID, sizeof(efi_guid_t));
+
+	/* obtain the size */
+	*datasize = 0;
+	ret = efivar_entry_size(entry, datasize);
+	if (ret)
+		goto error_size;
+
+	wkey_data = kzalloc(*datasize, GFP_KERNEL);
+	if (!wkey_data) {
+		ret = -ENOMEM;
+		goto error_size;
+	}
+
+	ret = efivar_entry_get(entry, &attr, datasize, wkey_data);
+	if (ret) {
+		pr_err("PM: Get wake key data error: %d\n", ret);
+		goto error_get;
+	}
+	/* check attributes */
+	if (attr & EFI_VARIABLE_NON_VOLATILE) {
+		pr_err("PM: Wake key has wrong attributes: 0x%x\n", attr);
+		goto error_get;
+	}
+
+	kfree(entry);
+
+	return wkey_data;
+
+error_get:
+	memset(wkey_data, 0, *datasize);
+	kfree(wkey_data);
+	*datasize = 0;
+error_size:
+	kfree(entry);
+
+	return ERR_PTR(ret);
+}
+
+int wkey_data_available(void)
+{
+	static int ret = 1;
+	unsigned long datasize;
+	void *wkey_data;
+
+	if (ret > 0) {
+		wkey_data = load_wake_key_data(&datasize);
+		if (wkey_data && IS_ERR(wkey_data)) {
+			ret = PTR_ERR(wkey_data);
+			goto error;
+		} else {
+			if (wkey_data) {
+				memset(wkey_data, 0, datasize);
+				kfree(wkey_data);
+			}
+			ret = 0;
+		}
+	}
+
+error:
+	return ret;
+}
+
+struct key *get_wake_key(void)
+{
+	const struct cred *cred = current_cred();
+	void *wkey_data;
+	unsigned long datasize = 0;
+	struct key *wkey;
+	int err;
+
+	wkey_data = load_wake_key_data(&datasize);
+	if (IS_ERR(wkey_data)) {
+		wkey = (struct key *)wkey_data;
+		goto error_data;
+	}
+
+	wkey = key_alloc(&key_type_asymmetric, "s4_wake_key",
+			GLOBAL_ROOT_UID, GLOBAL_ROOT_GID,
+			cred, 0, KEY_ALLOC_NOT_IN_QUOTA);
+	if (IS_ERR(wkey)) {
+		pr_err("PM: Allocate s4 wake key error: %ld\n", PTR_ERR(wkey));
+		goto error_keyalloc;
+	}
+	err = key_instantiate_and_link(wkey, wkey_data, datasize, NULL, NULL);
+	if (err < 0) {
+		pr_err("PM: S4 wake key instantiate error: %d\n", err);
+		if (wkey)
+			key_put(wkey);
+		wkey = ERR_PTR(err);
+	}
+
+error_keyalloc:
+	if (wkey_data && !IS_ERR(wkey_data))
+		kfree(wkey_data);
+error_data:
+	return wkey;
+}
+
+size_t get_key_length(const struct key *key)
+{
+	const struct public_key *pk = key->payload.data;
+	size_t len;
+
+	/* TODO: better check the RSA type */
+
+	len = mpi_get_nbits(pk->rsa.n);
+	len = (len + 7) / 8;
+
+	return len;
+}
+
+static int __init init_sign_key_data(void)
+{
+	skey_data = (void *)get_zeroed_page(GFP_KERNEL);
+	forward_info_buf = (void *)get_zeroed_page(GFP_KERNEL);
+
+	if (skey_data && efi_s4_key_available()) {
+		skey_dsize = efi_copy_skey_data(skey_data);
+		efi_erase_s4_skey_data();
+		pr_info("PM: Load s4 sign key from EFI\n");
+	}
+
+	return 0;
+}
+
+late_initcall(init_sign_key_data);
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 7d4b7ff..661f124 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -160,6 +160,36 @@ extern void swsusp_close(fmode_t);
 extern int swsusp_unmark(void);
 #endif
 
+/* kernel/power/hibernate_key.c */
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
+extern bool skey_data_available(void);
+extern struct key *get_sign_key(void);
+extern void erase_skey_data(void);
+extern void destroy_sign_key(struct key *key);
+extern int wkey_data_available(void);
+extern struct key *get_wake_key(void);
+extern size_t get_key_length(const struct key *key);
+
+extern void restore_sig_forward_info(void);
+extern bool swsusp_page_is_sign_key(struct page *page);
+extern unsigned long get_sig_forward_info_pfn(void);
+extern void fill_sig_forward_info(void *page_addr, int sig_check_ret);
+#else
+static inline bool skey_data_available(void)
+{
+	return false;
+}
+static inline void restore_sig_forward_info(void) {}
+static inline bool swsusp_page_is_sign_key(struct page *page)
+{
+	return false;
+}
+static inline unsigned long get_sig_forward_info_pfn(void)
+{
+	return 0;
+}
+#endif /* !CONFIG_SNAPSHOT_VERIFICATION */
+
 /* kernel/power/block_io.c */
 extern struct block_device *hib_resume_bdev;
 
-- 
1.6.0.2

