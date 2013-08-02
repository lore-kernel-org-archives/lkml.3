Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab3HBV3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:29:25 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:58523 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab3HBV3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:29:21 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 4/7] Add proper definitions for some EFI function pointers.
Date: Fri,  2 Aug 2013 14:29:05 -0700
Message-Id: <1375478948-22562-5-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
References: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86/AMD64 EFI stubs must us a call wrapper to convert between
the Linux and EFI ABIs, so void pointers are sufficient.  For ARM,
the ABIs are compatible, so we can directly invoke the function
pointers.  The functions that are used by the ARM stub are updated
to match the EFI definitions.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 include/linux/efi.h |   61 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 17 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 51f5641..779ec8c 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -39,6 +39,8 @@
 typedef unsigned long efi_status_t;
 typedef u8 efi_bool_t;
 typedef u16 efi_char16_t;		/* UNICODE character */
+typedef u64 efi_physical_addr_t;
+typedef void *efi_handle_t;
 
 
 typedef struct {
@@ -96,6 +98,26 @@ typedef	struct {
 #define EFI_MEMORY_DESCRIPTOR_VERSION	1
 
 #define EFI_PAGE_SHIFT		12
+#define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
+
+typedef enum {
+	EfiReservedMemoryType,
+	EfiLoaderCode,
+	EfiLoaderData,
+	EfiBootServicesCode,
+	EfiBootServicesData,
+	EfiRuntimeServicesCode,
+	EfiRuntimeServicesData,
+	EfiConventionalMemory,
+	EfiUnusableMemory,
+	EfiACPIReclaimMemory,
+	EfiACPIMemoryNVS,
+	EfiMemoryMappedIO,
+	EfiMemoryMappedIOPortSpace,
+	EfiPalCode,
+	EfiMaxMemoryType
+} EFI_MEMORY_TYPE;
+
 
 typedef struct {
 	u32 type;
@@ -157,11 +179,12 @@ typedef struct {
 	efi_table_hdr_t hdr;
 	void *raise_tpl;
 	void *restore_tpl;
-	void *allocate_pages;
-	void *free_pages;
-	void *get_memory_map;
-	void *allocate_pool;
-	void *free_pool;
+	int (*allocate_pages)(int, int, unsigned long, efi_physical_addr_t *);
+	int (*free_pages)(efi_physical_addr_t, unsigned long);
+	int (*get_memory_map)(unsigned long *, void *, unsigned long *,
+			      unsigned long *, u32 *);
+	int (*allocate_pool)(int, unsigned long, void **);
+	int (*free_pool)(void *);
 	void *create_event;
 	void *set_timer;
 	void *wait_for_event;
@@ -171,7 +194,7 @@ typedef struct {
 	void *install_protocol_interface;
 	void *reinstall_protocol_interface;
 	void *uninstall_protocol_interface;
-	void *handle_protocol;
+	int (*handle_protocol)(efi_handle_t, efi_guid_t *, void **);
 	void *__reserved;
 	void *register_protocol_notify;
 	void *locate_handle;
@@ -181,7 +204,7 @@ typedef struct {
 	void *start_image;
 	void *exit;
 	void *unload_image;
-	void *exit_boot_services;
+	int (*exit_boot_services)(efi_handle_t, unsigned long);
 	void *get_next_monotonic_count;
 	void *stall;
 	void *set_watchdog_timer;
@@ -488,10 +511,6 @@ typedef struct {
 	unsigned long unload;
 } efi_loaded_image_t;
 
-typedef struct {
-	u64 revision;
-	void *open_volume;
-} efi_file_io_interface_t;
 
 typedef struct {
 	u64 size;
@@ -504,20 +523,28 @@ typedef struct {
 	efi_char16_t filename[1];
 } efi_file_info_t;
 
-typedef struct {
+typedef struct _efi_file_handle {
 	u64 revision;
-	void *open;
-	void *close;
+	int (*open)(struct _efi_file_handle *, struct _efi_file_handle **,
+		    efi_char16_t *, u64, u64);
+	int (*close)(struct _efi_file_handle *);
 	void *delete;
-	void *read;
+	int (*read)(struct _efi_file_handle *, unsigned long *, void *);
 	void *write;
 	void *get_position;
 	void *set_position;
-	void *get_info;
+	int (*get_info)(struct _efi_file_handle *, efi_guid_t *,
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
@@ -787,7 +814,7 @@ struct efivar_entry {
 
 struct efi_simple_text_output_protocol {
 	void *reset;
-	void *output_string;
+	int (*output_string)(void *, void *);
 	void *test_string;
 };
 
-- 
1.7.10.4

