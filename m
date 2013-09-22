Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3IVWty (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:49:54 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:48883 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3IVWp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:45:27 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 02/18] Add proper definitions for some EFI function pointers.
Date: Sun, 22 Sep 2013 15:45:26 -0700
Message-Id: <1379889942-3135-3-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86/AMD64 EFI stubs must use a call wrapper to convert between
the Linux and EFI ABIs, so void pointers are sufficient.  For ARM,
the ABIs are compatible, so we can directly invoke the function
pointers.  The functions that are used by the ARM stub are updated
to match the EFI definitions.
Also add some EFI types used by EFI functions.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
Acked-by: Mark Salter <msalter@redhat.com>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
---
 arch/x86/boot/compressed/eboot.h |    8 ------
 include/linux/efi.h              |   50 ++++++++++++++++++++++++++------------
 2 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
index e5b0a8f..0226510 100644
--- a/arch/x86/boot/compressed/eboot.h
+++ b/arch/x86/boot/compressed/eboot.h
@@ -10,8 +10,6 @@
 #define SEG_GRANULARITY_4KB	(1 << 0)
 
 #define DESC_TYPE_CODE_DATA	(1 << 0)
-
-#define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
 #define EFI_READ_CHUNK_SIZE	(1024 * 1024)
 
 #define EFI_CONSOLE_OUT_DEVICE_GUID    \
@@ -62,10 +60,4 @@ struct efi_uga_draw_protocol {
 	void *blt;
 };
 
-struct efi_simple_text_output_protocol {
-	void *reset;
-	void *output_string;
-	void *test_string;
-};
-
 #endif /* BOOT_COMPRESSED_EBOOT_H */
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 5f8f176..840ab28 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -39,6 +39,8 @@
 typedef unsigned long efi_status_t;
 typedef u8 efi_bool_t;
 typedef u16 efi_char16_t;		/* UNICODE character */
+typedef u64 efi_physical_addr_t;
+typedef void *efi_handle_t;
 
 
 typedef struct {
@@ -96,6 +98,7 @@ typedef	struct {
 #define EFI_MEMORY_DESCRIPTOR_VERSION	1
 
 #define EFI_PAGE_SHIFT		12
+#define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
 
 typedef struct {
 	u32 type;
@@ -157,11 +160,13 @@ typedef struct {
 	efi_table_hdr_t hdr;
 	void *raise_tpl;
 	void *restore_tpl;
-	void *allocate_pages;
-	void *free_pages;
-	void *get_memory_map;
-	void *allocate_pool;
-	void *free_pool;
+	efi_status_t (*allocate_pages)(int, int, unsigned long,
+				       efi_physical_addr_t *);
+	efi_status_t (*free_pages)(efi_physical_addr_t, unsigned long);
+	efi_status_t (*get_memory_map)(unsigned long *, void *, unsigned long *,
+				       unsigned long *, u32 *);
+	efi_status_t (*allocate_pool)(int, unsigned long, void **);
+	efi_status_t (*free_pool)(void *);
 	void *create_event;
 	void *set_timer;
 	void *wait_for_event;
@@ -171,7 +176,7 @@ typedef struct {
 	void *install_protocol_interface;
 	void *reinstall_protocol_interface;
 	void *uninstall_protocol_interface;
-	void *handle_protocol;
+	efi_status_t (*handle_protocol)(efi_handle_t, efi_guid_t *, void **);
 	void *__reserved;
 	void *register_protocol_notify;
 	void *locate_handle;
@@ -181,7 +186,7 @@ typedef struct {
 	void *start_image;
 	void *exit;
 	void *unload_image;
-	void *exit_boot_services;
+	efi_status_t (*exit_boot_services)(efi_handle_t, unsigned long);
 	void *get_next_monotonic_count;
 	void *stall;
 	void *set_watchdog_timer;
@@ -488,10 +493,6 @@ typedef struct {
 	unsigned long unload;
 } efi_loaded_image_t;
 
-typedef struct {
-	u64 revision;
-	void *open_volume;
-} efi_file_io_interface_t;
 
 typedef struct {
 	u64 size;
@@ -504,20 +505,30 @@ typedef struct {
 	efi_char16_t filename[1];
 } efi_file_info_t;
 
-typedef struct {
+typedef struct _efi_file_handle {
 	u64 revision;
-	void *open;
-	void *close;
+	efi_status_t (*open)(struct _efi_file_handle *,
+			     struct _efi_file_handle **,
+			     efi_char16_t *, u64, u64);
+	efi_status_t (*close)(struct _efi_file_handle *);
 	void *delete;
-	void *read;
+	efi_status_t (*read)(struct _efi_file_handle *, unsigned long *,
+			     void *);
 	void *write;
 	void *get_position;
 	void *set_position;
-	void *get_info;
+	efi_status_t (*get_info)(struct _efi_file_handle *, efi_guid_t *,
+			unsigned long *, void *);
 	void *set_info;
 	void *flush;
 } efi_file_handle_t;
 
+typedef struct _efi_file_io_interface {
+	u64 revision;
+	int (*open_volume)(struct _efi_file_io_interface *,
+			   efi_file_handle_t **);
+} efi_file_io_interface_t;
+
 #define EFI_FILE_MODE_READ	0x0000000000000001
 #define EFI_FILE_MODE_WRITE	0x0000000000000002
 #define EFI_FILE_MODE_CREATE	0x8000000000000000
@@ -784,6 +795,13 @@ struct efivar_entry {
 	struct kobject kobj;
 };
 
+
+struct efi_simple_text_output_protocol {
+	void *reset;
+	efi_status_t (*output_string)(void *, void *);
+	void *test_string;
+};
+
 extern struct list_head efivar_sysfs_list;
 
 static inline void
-- 
1.7.10.4

