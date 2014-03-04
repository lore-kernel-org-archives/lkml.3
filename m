Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbaCDNRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 08:17:39 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:58416 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757321AbaCDNOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 08:14:36 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 05/13] efi: Add separate 32-bit/64-bit definitions
Date: Tue,  4 Mar 2014 13:14:13 +0000
Message-Id: <1393938861-16797-6-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
References: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

The traditional approach of using machine-specific types such as
'unsigned long' does not allow the kernel to interact with firmware
running in a different CPU mode, e.g. 64-bit kernel with 32-bit EFI.

Add distinct EFI structure definitions for both 32-bit and 64-bit so
that we can use them in the 32-bit and 64-bit code paths.

Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/eboot.h |  44 +++++++
 include/linux/efi.h              | 252 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 296 insertions(+)

diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
index 81b6b652b46a..d487e727f1ec 100644
--- a/arch/x86/boot/compressed/eboot.h
+++ b/arch/x86/boot/compressed/eboot.h
@@ -37,6 +37,24 @@ struct efi_graphics_output_mode_info {
 	u32 pixels_per_scan_line;
 } __packed;
 
+struct efi_graphics_output_protocol_mode_32 {
+	u32 max_mode;
+	u32 mode;
+	u32 info;
+	u32 size_of_info;
+	u64 frame_buffer_base;
+	u32 frame_buffer_size;
+} __packed;
+
+struct efi_graphics_output_protocol_mode_64 {
+	u32 max_mode;
+	u32 mode;
+	u64 info;
+	u64 size_of_info;
+	u64 frame_buffer_base;
+	u64 frame_buffer_size;
+} __packed;
+
 struct efi_graphics_output_protocol_mode {
 	u32 max_mode;
 	u32 mode;
@@ -46,6 +64,20 @@ struct efi_graphics_output_protocol_mode {
 	unsigned long frame_buffer_size;
 } __packed;
 
+struct efi_graphics_output_protocol_32 {
+	u32 query_mode;
+	u32 set_mode;
+	u32 blt;
+	u32 mode;
+};
+
+struct efi_graphics_output_protocol_64 {
+	u64 query_mode;
+	u64 set_mode;
+	u64 blt;
+	u64 mode;
+};
+
 struct efi_graphics_output_protocol {
 	void *query_mode;
 	unsigned long set_mode;
@@ -53,6 +85,18 @@ struct efi_graphics_output_protocol {
 	struct efi_graphics_output_protocol_mode *mode;
 };
 
+struct efi_uga_draw_protocol_32 {
+	u32 get_mode;
+	u32 set_mode;
+	u32 blt;
+};
+
+struct efi_uga_draw_protocol_64 {
+	u64 get_mode;
+	u64 set_mode;
+	u64 blt;
+};
+
 struct efi_uga_draw_protocol {
 	void *get_mode;
 	void *set_mode;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 64d532ca890a..6c100ff0cae4 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -153,6 +153,102 @@ typedef struct {
 	u8 sets_to_zero;
 } efi_time_cap_t;
 
+typedef struct {
+	efi_table_hdr_t hdr;
+	u32 raise_tpl;
+	u32 restore_tpl;
+	u32 allocate_pages;
+	u32 free_pages;
+	u32 get_memory_map;
+	u32 allocate_pool;
+	u32 free_pool;
+	u32 create_event;
+	u32 set_timer;
+	u32 wait_for_event;
+	u32 signal_event;
+	u32 close_event;
+	u32 check_event;
+	u32 install_protocol_interface;
+	u32 reinstall_protocol_interface;
+	u32 uninstall_protocol_interface;
+	u32 handle_protocol;
+	u32 __reserved;
+	u32 register_protocol_notify;
+	u32 locate_handle;
+	u32 locate_device_path;
+	u32 install_configuration_table;
+	u32 load_image;
+	u32 start_image;
+	u32 exit;
+	u32 unload_image;
+	u32 exit_boot_services;
+	u32 get_next_monotonic_count;
+	u32 stall;
+	u32 set_watchdog_timer;
+	u32 connect_controller;
+	u32 disconnect_controller;
+	u32 open_protocol;
+	u32 close_protocol;
+	u32 open_protocol_information;
+	u32 protocols_per_handle;
+	u32 locate_handle_buffer;
+	u32 locate_protocol;
+	u32 install_multiple_protocol_interfaces;
+	u32 uninstall_multiple_protocol_interfaces;
+	u32 calculate_crc32;
+	u32 copy_mem;
+	u32 set_mem;
+	u32 create_event_ex;
+} __packed efi_boot_services_32_t;
+
+typedef struct {
+	efi_table_hdr_t hdr;
+	u64 raise_tpl;
+	u64 restore_tpl;
+	u64 allocate_pages;
+	u64 free_pages;
+	u64 get_memory_map;
+	u64 allocate_pool;
+	u64 free_pool;
+	u64 create_event;
+	u64 set_timer;
+	u64 wait_for_event;
+	u64 signal_event;
+	u64 close_event;
+	u64 check_event;
+	u64 install_protocol_interface;
+	u64 reinstall_protocol_interface;
+	u64 uninstall_protocol_interface;
+	u64 handle_protocol;
+	u64 __reserved;
+	u64 register_protocol_notify;
+	u64 locate_handle;
+	u64 locate_device_path;
+	u64 install_configuration_table;
+	u64 load_image;
+	u64 start_image;
+	u64 exit;
+	u64 unload_image;
+	u64 exit_boot_services;
+	u64 get_next_monotonic_count;
+	u64 stall;
+	u64 set_watchdog_timer;
+	u64 connect_controller;
+	u64 disconnect_controller;
+	u64 open_protocol;
+	u64 close_protocol;
+	u64 open_protocol_information;
+	u64 protocols_per_handle;
+	u64 locate_handle_buffer;
+	u64 locate_protocol;
+	u64 install_multiple_protocol_interfaces;
+	u64 uninstall_multiple_protocol_interfaces;
+	u64 calculate_crc32;
+	u64 copy_mem;
+	u64 set_mem;
+	u64 create_event_ex;
+} __packed efi_boot_services_64_t;
+
 /*
  * EFI Boot Services table
  */
@@ -231,6 +327,15 @@ typedef enum {
     EfiPciIoAttributeOperationMaximum
 } EFI_PCI_IO_PROTOCOL_ATTRIBUTE_OPERATION;
 
+typedef struct {
+	u32 read;
+	u32 write;
+} efi_pci_io_protocol_access_32_t;
+
+typedef struct {
+	u64 read;
+	u64 write;
+} efi_pci_io_protocol_access_64_t;
 
 typedef struct {
 	void *read;
@@ -238,6 +343,46 @@ typedef struct {
 } efi_pci_io_protocol_access_t;
 
 typedef struct {
+	u32 poll_mem;
+	u32 poll_io;
+	efi_pci_io_protocol_access_32_t mem;
+	efi_pci_io_protocol_access_32_t io;
+	efi_pci_io_protocol_access_32_t pci;
+	u32 copy_mem;
+	u32 map;
+	u32 unmap;
+	u32 allocate_buffer;
+	u32 free_buffer;
+	u32 flush;
+	u32 get_location;
+	u32 attributes;
+	u32 get_bar_attributes;
+	u32 set_bar_attributes;
+	uint64_t romsize;
+	void *romimage;
+} efi_pci_io_protocol_32;
+
+typedef struct {
+	u64 poll_mem;
+	u64 poll_io;
+	efi_pci_io_protocol_access_64_t mem;
+	efi_pci_io_protocol_access_64_t io;
+	efi_pci_io_protocol_access_64_t pci;
+	u64 copy_mem;
+	u64 map;
+	u64 unmap;
+	u64 allocate_buffer;
+	u64 free_buffer;
+	u64 flush;
+	u64 get_location;
+	u64 attributes;
+	u64 get_bar_attributes;
+	u64 set_bar_attributes;
+	uint64_t romsize;
+	void *romimage;
+} efi_pci_io_protocol_64;
+
+typedef struct {
 	void *poll_mem;
 	void *poll_io;
 	efi_pci_io_protocol_access_t mem;
@@ -292,6 +437,42 @@ typedef struct {
 
 typedef struct {
 	efi_table_hdr_t hdr;
+	u32 get_time;
+	u32 set_time;
+	u32 get_wakeup_time;
+	u32 set_wakeup_time;
+	u32 set_virtual_address_map;
+	u32 convert_pointer;
+	u32 get_variable;
+	u32 get_next_variable;
+	u32 set_variable;
+	u32 get_next_high_mono_count;
+	u32 reset_system;
+	u32 update_capsule;
+	u32 query_capsule_caps;
+	u32 query_variable_info;
+} efi_runtime_services_32_t;
+
+typedef struct {
+	efi_table_hdr_t hdr;
+	u64 get_time;
+	u64 set_time;
+	u64 get_wakeup_time;
+	u64 set_wakeup_time;
+	u64 set_virtual_address_map;
+	u64 convert_pointer;
+	u64 get_variable;
+	u64 get_next_variable;
+	u64 set_variable;
+	u64 get_next_high_mono_count;
+	u64 reset_system;
+	u64 update_capsule;
+	u64 query_capsule_caps;
+	u64 query_variable_info;
+} efi_runtime_services_64_t;
+
+typedef struct {
+	efi_table_hdr_t hdr;
 	void *get_time;
 	void *set_time;
 	void *get_wakeup_time;
@@ -485,6 +666,38 @@ struct efi_memory_map {
 
 typedef struct {
 	u32 revision;
+	u32 parent_handle;
+	u32 system_table;
+	u32 device_handle;
+	u32 file_path;
+	u32 reserved;
+	u32 load_options_size;
+	u32 load_options;
+	u32 image_base;
+	__aligned_u64 image_size;
+	unsigned int image_code_type;
+	unsigned int image_data_type;
+	unsigned long unload;
+} efi_loaded_image_32_t;
+
+typedef struct {
+	u32 revision;
+	u64 parent_handle;
+	u64 system_table;
+	u64 device_handle;
+	u64 file_path;
+	u64 reserved;
+	u32 load_options_size;
+	u64 load_options;
+	u64 image_base;
+	__aligned_u64 image_size;
+	unsigned int image_code_type;
+	unsigned int image_data_type;
+	unsigned long unload;
+} efi_loaded_image_64_t;
+
+typedef struct {
+	u32 revision;
 	void *parent_handle;
 	efi_system_table_t *system_table;
 	void *device_handle;
@@ -511,6 +724,34 @@ typedef struct {
 	efi_char16_t filename[1];
 } efi_file_info_t;
 
+typedef struct {
+	u64 revision;
+	u32 open;
+	u32 close;
+	u32 delete;
+	u32 read;
+	u32 write;
+	u32 get_position;
+	u32 set_position;
+	u32 get_info;
+	u32 set_info;
+	u32 flush;
+} efi_file_handle_32_t;
+
+typedef struct {
+	u64 revision;
+	u64 open;
+	u64 close;
+	u64 delete;
+	u64 read;
+	u64 write;
+	u64 get_position;
+	u64 set_position;
+	u64 get_info;
+	u64 set_info;
+	u64 flush;
+} efi_file_handle_64_t;
+
 typedef struct _efi_file_handle {
 	u64 revision;
 	efi_status_t (*open)(struct _efi_file_handle *,
@@ -809,6 +1050,17 @@ struct efivar_entry {
 	bool deleting;
 };
 
+struct efi_simple_text_output_protocol_32 {
+	u32 reset;
+	u32 output_string;
+	u32 test_string;
+};
+
+struct efi_simple_text_output_protocol_64 {
+	u64 reset;
+	u64 output_string;
+	u64 test_string;
+};
 
 struct efi_simple_text_output_protocol {
 	void *reset;
-- 
1.8.5.3

