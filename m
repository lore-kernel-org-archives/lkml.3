Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3LRJMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:12:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:36680 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab3LRJHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:07:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="451880170"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC DBG PATCH] ACPICA: Add CONFIG_ACPI=n build test support.
Date: Wed, 18 Dec 2013 17:07:28 +0800
Message-Id: <f82182940fe88b1b6428eecc2df1cb1684f0ca80.1387336613.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1387336613.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file can be used to detect ACPICA configurability/build issues in
CONFIG_ACPI=n environment.
This patch is only used for unit test purpose, do not merge it into
public linux kernel source trees.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 init/Makefile |    2 +-
 init/acpica.c |  318 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 319 insertions(+), 1 deletion(-)
 create mode 100644 init/acpica.c

diff --git a/init/Makefile b/init/Makefile
index 7bc47ee..0f655de 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y                          := main.o version.o mounts.o
+obj-y                          := main.o version.o mounts.o acpica.o
 ifneq ($(CONFIG_BLK_DEV_INITRD),y)
 obj-y                          += noinitramfs.o
 else
diff --git a/init/acpica.c b/init/acpica.c
new file mode 100644
index 0000000..ae9fc61
--- /dev/null
+++ b/init/acpica.c
@@ -0,0 +1,318 @@
+/*
+ * ACPICA build testing for CONFIG_ACPI=n
+ *
+ * Copyright (C) 2013, Intel Corporation
+ *   Author: Lv Zheng <lv.zheng@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/acpica.h>
+
+#define FUNC_CONST_PTR_1(ptr, func, v1)				\
+	do {							\
+		ptr = func(v1);					\
+		printk("%s result is %p.\n", #func, ptr);	\
+	} while (0)
+#define FUNC_0(status, func)					\
+	do {							\
+		status = func();				\
+		printk("%s result is %d.\n", #func, status);	\
+	} while (0)
+#define FUNC_1(status, func, v1)				\
+	do {							\
+		status = func(v1);				\
+		printk("%s result is %d.\n", #func, status);	\
+	} while (0)
+#define FUNC_2(status, func, v1, v2)				\
+	do {							\
+		status = func(v1, v2);				\
+		printk("%s result is %d.\n", #func, status);	\
+	} while (0)
+#define FUNC_3(status, func, v1, v2, v3)			\
+	do {							\
+		status = func(v1, v2, v3);			\
+		printk("%s result is %d.\n", #func, status);	\
+	} while (0)
+#define FUNC_4(status, func, v1, v2, v3, v4)			\
+	do {							\
+		status = func(v1, v2, v3, v4);			\
+		printk("%s result is %d.\n", #func, status);	\
+	} while (0)
+#define FUNC_5(status, func, v1, v2, v3, v4, v5)		\
+	do {							\
+		status = func(v1, v2, v3, v4, v5);		\
+		printk("%s result is %d.\n", #func, status);	\
+	} while (0)
+#define FUNC_6(status, func, v1, v2, v3, v4, v5, v6)		\
+	do {							\
+		status = func(v1, v2, v3, v4, v5, v6);		\
+		printk("%s result is %d.\n", #func, status);	\
+	} while (0)
+#define FUNC_7(status, func, v1, v2, v3, v4, v5, v6, v7)	\
+	do {							\
+		status = func(v1, v2, v3, v4, v5, v6, v7);	\
+		printk("%s result is %d.\n", #func, status);	\
+	} while (0)
+
+#define FUNC_VOID_3(func, v1, v2, v3)				\
+	do {							\
+		func(v1, v2, v3);				\
+	} while (0)
+#define FUNC_VOID_4(func, v1, v2, v3, v4)			\
+	do {							\
+		func(v1, v2, v3, v4);				\
+	} while (0)
+#define FUNC_VOID_6(func, v1, v2, v3, v4, v5, v6)		\
+	do {							\
+		func(v1, v2, v3, v4, v5, v6);			\
+	} while (0)
+
+#define ACCESS_GLOBAL(gbl, val)					\
+	do {							\
+		if ((gbl) == (val)) {				\
+			printk("%s global equals.\n", #gbl);	\
+		} else {					\
+			printk("%s global not equals.\n", #gbl);\
+		}						\
+	} while (0)
+#define ACCESS_FADT_FLAG(flg)					\
+	do {							\
+		if (acpi_test_fadt_flags(flg)) {		\
+			printk("%s flag set\n", #flg);		\
+		} else {					\
+			printk("%s flag cleared.\n", #flg);	\
+		}						\
+	} while (0)
+
+#define ACPI_SNAME(str)						\
+	((u16)((u16)((str)[0]) | ((u16)((str)[1]) << 8)))
+
+#define ACPI_LNAME(str)						\
+	((u32)((u32)ACPI_SNAME(str) | ((u32)ACPI_SNAME((str)+2) << 16)))
+
+#define ACPI_LLNAME(str)					\
+	((u64)((u64)ACPI_LNAME(str) | ((u64)ACPI_LNAME((str)+4) << 32)))
+
+static void test_macros(void)
+{
+	void *mem;
+	u64 a_u64 = ACPI_LLNAME("ABCDEFGH");
+	u32 a_u32 = ACPI_LNAME("ABCD");
+	u16 a_u16 = ACPI_SNAME("AB");
+	u8 a_u8 = 'A';
+
+	mem = ACPI_ALLOCATE(sizeof(u64));
+	ACPI_FREE(mem);
+	mem = ACPI_ALLOCATE_ZEROED(sizeof(u64));
+	ACPI_FREE(mem);
+
+	a_u32 = ACPI_LODWORD(a_u64) + ACPI_HIDWORD(a_u64);
+	a_u32 = ACPI_LODWORD(a_u32) + ACPI_HIDWORD(a_u32);
+	a_u32 = ACPI_LODWORD(a_u16) + ACPI_HIDWORD(a_u16);
+	a_u32 = ACPI_LODWORD(a_u8)  + ACPI_HIDWORD(a_u8);
+
+	a_u16 = ACPI_LOWORD(a_u64) + ACPI_HIWORD(a_u64);
+	a_u16 = ACPI_LOWORD(a_u32) + ACPI_HIWORD(a_u32);
+	a_u16 = ACPI_LOWORD(a_u16) + ACPI_HIWORD(a_u16);
+	a_u16 = ACPI_LOWORD(a_u8)  + ACPI_HIWORD(a_u8);
+
+	a_u8 = ACPI_LOBYTE(a_u64) + ACPI_HIBYTE(a_u64);
+	a_u8 = ACPI_LOBYTE(a_u32) + ACPI_HIBYTE(a_u32);
+	a_u8 = ACPI_LOBYTE(a_u16) + ACPI_HIBYTE(a_u16);
+	a_u8 = ACPI_LOBYTE(a_u8)  + ACPI_HIBYTE(a_u8);
+
+	ACPI_SET_BIT(a_u64, 1);
+	ACPI_SET_BIT(a_u32, 1);
+	ACPI_SET_BIT(a_u16, 1);
+	ACPI_SET_BIT(a_u8,  1);
+	ACPI_CLEAR_BIT(a_u64, 1);
+	ACPI_CLEAR_BIT(a_u32, 1);
+	ACPI_CLEAR_BIT(a_u16, 1);
+	ACPI_CLEAR_BIT(a_u8,  1);
+}
+
+static void test_globals(void)
+{
+	ACCESS_GLOBAL(acpi_current_gpe_count, 0);
+	ACCESS_GLOBAL(acpi_gbl_trace_flags, 0);
+	ACCESS_GLOBAL(acpi_gbl_trace_method_name, 0);
+	ACCESS_GLOBAL(acpi_gbl_system_awake_and_running, FALSE);
+	ACCESS_GLOBAL(acpi_gbl_reduced_hardware, FALSE);
+	ACCESS_GLOBAL(acpi_gbl_enable_interpreter_slack, FALSE);
+	ACCESS_GLOBAL(acpi_gbl_all_methods_serialized, FALSE);
+	ACCESS_GLOBAL(acpi_gbl_create_osi_method, TRUE);
+	ACCESS_GLOBAL(acpi_gbl_use_default_register_widths, TRUE);
+	ACCESS_GLOBAL(acpi_gbl_enable_aml_debug_object, FALSE);
+	ACCESS_GLOBAL(acpi_gbl_copy_dsdt_locally, FALSE);
+	ACCESS_GLOBAL(acpi_gbl_truncate_io_addresses, FALSE);
+	ACCESS_GLOBAL(acpi_gbl_disable_auto_repair, FALSE);
+	ACCESS_GLOBAL(acpi_gbl_disable_ssdt_table_load, FALSE);
+	ACCESS_GLOBAL(acpi_gbl_osi_data, 0);
+	ACCESS_GLOBAL(acpi_dbg_level, ACPI_DEBUG_DEFAULT);
+	ACCESS_GLOBAL(acpi_dbg_layer, ACPI_COMPONENT_DEFAULT);
+#ifdef ACPI_DISASSEMBLER
+	ACCESS_GLOBAL(acpi_gbl_no_resource_disassembly, FALSE);
+	ACCESS_GLOBAL(acpi_gbl_ignore_noop_operator, FALSE);
+#endif
+	ACCESS_GLOBAL(acpi_gbl_permanent_mmap, FALSE);
+	ACCESS_GLOBAL(acpi_rsdt_forced, FALSE);
+
+	printk("FADT revision is %d.\n", acpi_get_fadt_revision());
+
+	ACCESS_FADT_FLAG(ACPI_FADT_WBINVD);
+}
+
+static void test_functions(void)
+{
+	acpi_status status;
+	const void *pointer;
+
+	FUNC_0(status, acpi_enable);
+	FUNC_0(status, acpi_disable);
+#ifdef ACPI_FUTURE_USAGE
+	FUNC_0(status, acpi_subsystem_status);
+	FUNC_1(status, acpi_get_system_info, NULL);
+#endif
+	FUNC_1(status, acpi_get_statistics, NULL);
+	FUNC_CONST_PTR_1(pointer, acpi_format_exception, 0);
+	FUNC_0(status, acpi_purge_cached_objects);
+	FUNC_1(status, acpi_install_interface, NULL);
+	FUNC_1(status, acpi_remove_interface, NULL);
+	FUNC_1(status, acpi_update_interfaces, 0);
+	FUNC_4(status, acpi_check_address_range, 0, 0, 0, false);
+	FUNC_3(status, acpi_decode_pld_buffer, NULL, 0, NULL);
+	FUNC_1(status, acpi_load_table, NULL);
+	FUNC_1(status, acpi_unload_parent_table, NULL);
+	FUNC_1(status, acpi_unload_table_id, 0);
+	FUNC_3(status, acpi_get_table_header, NULL, 0, NULL);
+	FUNC_4(status, acpi_get_table_with_size, NULL, 0, NULL, NULL);
+	FUNC_3(status, acpi_get_table, NULL, 0, NULL);
+	FUNC_2(status, acpi_get_table_by_index, 0, NULL);
+	FUNC_2(status, acpi_install_table_handler, NULL, NULL);
+	FUNC_1(status, acpi_remove_table_handler, NULL);
+	FUNC_7(status, acpi_walk_namespace, 0, NULL, 0, NULL, NULL, NULL, NULL);
+	FUNC_4(status, acpi_get_devices, NULL, NULL, NULL, NULL);
+	FUNC_3(status, acpi_get_name, NULL, 0, NULL);
+	FUNC_3(status, acpi_get_handle, NULL, NULL, NULL);
+	FUNC_3(status, acpi_attach_data, NULL, NULL, NULL);
+	FUNC_2(status, acpi_detach_data, NULL, NULL);
+	FUNC_3(status, acpi_get_data, NULL, NULL, NULL);
+	FUNC_4(status, acpi_debug_trace, NULL, 0, 0, 0);
+	FUNC_4(status, acpi_evaluate_object, NULL, NULL, NULL, NULL);
+	FUNC_5(status, acpi_evaluate_object_typed, NULL, NULL, NULL, NULL, 0);
+	FUNC_2(status, acpi_get_object_info, NULL, NULL);
+	FUNC_1(status, acpi_install_method, NULL);
+	FUNC_4(status, acpi_get_next_object, 0, NULL, NULL, NULL);
+	FUNC_2(status, acpi_get_type, NULL, NULL);
+	FUNC_2(status, acpi_get_id, NULL, NULL);
+	FUNC_2(status, acpi_get_parent, NULL, NULL);
+	FUNC_2(status, acpi_install_initialization_handler, NULL, 0);
+	FUNC_2(status, acpi_install_sci_handler, NULL, NULL);
+	FUNC_1(status, acpi_remove_sci_handler, NULL);
+	FUNC_2(status, acpi_install_global_event_handler, NULL, NULL);
+	FUNC_3(status, acpi_install_fixed_event_handler, 0, NULL, NULL);
+	FUNC_2(status, acpi_remove_fixed_event_handler, 0, NULL);
+	FUNC_5(status, acpi_install_gpe_handler, NULL, 0, 0, NULL, NULL);
+	FUNC_3(status, acpi_remove_gpe_handler, NULL, 0, NULL);
+	FUNC_4(status, acpi_install_notify_handler, NULL, 0, NULL, NULL);
+	FUNC_3(status, acpi_remove_notify_handler, NULL, 0, NULL);
+	FUNC_5(status, acpi_install_address_space_handler, NULL, 0, NULL, NULL, NULL);
+	FUNC_3(status, acpi_remove_address_space_handler, NULL, 0, NULL);
+#ifdef ACPI_FUTURE_USAGE
+	FUNC_1(status, acpi_install_exception_handler, NULL);
+#endif
+	FUNC_1(status, acpi_install_interface_handler, NULL);
+	FUNC_2(status, acpi_acquire_global_lock, 0, NULL);
+	FUNC_1(status, acpi_release_global_lock, 0);
+	FUNC_3(status, acpi_acquire_mutex, NULL, NULL, 0);
+	FUNC_2(status, acpi_release_mutex, NULL, NULL);
+	FUNC_2(status, acpi_enable_event, 0, 0);
+	FUNC_2(status, acpi_disable_event, 0, 0);
+	FUNC_1(status, acpi_clear_event, 0);
+	FUNC_2(status, acpi_get_event_status, 0, NULL);
+	FUNC_0(status, acpi_update_all_gpes);
+	FUNC_2(status, acpi_enable_gpe, NULL, 0);
+	FUNC_2(status, acpi_disable_gpe, NULL, 0);
+	FUNC_2(status, acpi_clear_gpe, NULL, 0);
+	FUNC_3(status, acpi_set_gpe, NULL, 0, 0);
+	FUNC_2(status, acpi_finish_gpe, NULL, 0);
+	FUNC_3(status, acpi_setup_gpe_for_wake, NULL, NULL, 0);
+	FUNC_3(status, acpi_set_gpe_wake_mask, NULL, 0, 0);
+	FUNC_3(status, acpi_get_gpe_status, NULL, 0, NULL);
+	FUNC_0(status, acpi_disable_all_gpes);
+	FUNC_0(status, acpi_enable_all_runtime_gpes);
+	FUNC_2(status, acpi_get_gpe_device, 0, NULL);
+	FUNC_4(status, acpi_install_gpe_block, NULL, NULL, 0, 0);
+	FUNC_1(status, acpi_remove_gpe_block, NULL);
+	FUNC_4(status, acpi_get_vendor_resource, NULL, NULL, NULL, NULL);
+	FUNC_2(status, acpi_get_current_resources, NULL, NULL);
+#ifdef ACPI_FUTURE_USAGE
+	FUNC_2(status, acpi_get_possible_resources, NULL, NULL);
+#endif
+	FUNC_2(status, acpi_get_event_resources, NULL, NULL);
+	FUNC_3(status, acpi_walk_resource_buffer, NULL, NULL, NULL);
+	FUNC_4(status, acpi_walk_resources, NULL, NULL, NULL, NULL);
+	FUNC_2(status, acpi_set_current_resources, NULL, NULL);
+	FUNC_2(status, acpi_get_irq_routing_table, NULL, NULL);
+	FUNC_2(status, acpi_resource_to_address64, NULL, NULL);
+	FUNC_3(status, acpi_buffer_to_resource, NULL, 0, NULL);
+	FUNC_0(status, acpi_reset);
+	FUNC_2(status, acpi_read, NULL, NULL);
+	FUNC_2(status, acpi_write, 0, NULL);
+	FUNC_2(status, acpi_read_bit_register, 0, NULL);
+	FUNC_2(status, acpi_write_bit_register, 0, 0);
+	FUNC_3(status, acpi_get_sleep_type_data, 0, NULL, NULL);
+	FUNC_1(status, acpi_enter_sleep_state_prep, 0);
+	FUNC_1(status, acpi_enter_sleep_state, 0);
+	FUNC_0(status, acpi_enter_sleep_state_s4bios);
+	FUNC_1(status, acpi_leave_sleep_state_prep, 0);
+	FUNC_1(status, acpi_leave_sleep_state, 0);
+	FUNC_1(status, acpi_set_firmware_waking_vector, 0);
+#if ACPI_MACHINE_WIDTH == 64
+	FUNC_1(status, acpi_set_firmware_waking_vector64, 0);
+#endif
+#ifdef ACPI_FUTURE_USAGE
+	FUNC_1(status, acpi_get_timer_resolution, NULL);
+	FUNC_1(status, acpi_get_timer, NULL);
+	FUNC_3(status, acpi_get_timer_duration, 0, 0, NULL);
+#endif
+
+	FUNC_VOID_3(acpi_error, NULL, 0, NULL);
+	FUNC_VOID_4(acpi_exception, NULL, 0, 0, NULL);
+	FUNC_VOID_3(acpi_warning, NULL, 0, NULL);
+	FUNC_VOID_3(acpi_info, NULL, 0, NULL);
+	FUNC_VOID_3(acpi_bios_error, NULL, 0, NULL);
+	FUNC_VOID_3(acpi_bios_warning, NULL, 0, NULL);
+	FUNC_VOID_6(acpi_debug_print, 0, 0, NULL, NULL, 0, NULL);
+	FUNC_VOID_6(acpi_debug_print_raw, 0, 0, NULL, NULL, 0, NULL);
+}
+
+static void __init test_init_functions(void)
+{
+	acpi_status status;
+
+	FUNC_3(status, acpi_initialize_tables, NULL, 0, false);
+	FUNC_0(status, acpi_initialize_subsystem);
+	FUNC_1(status, acpi_enable_subsystem, 0);
+	FUNC_1(status, acpi_initialize_objects, 0);
+	FUNC_0(status, acpi_terminate);
+	FUNC_0(status, acpi_load_tables);
+	FUNC_0(status, acpi_reallocate_root_table);
+	FUNC_1(status, acpi_find_root_pointer, NULL);
+}
+
+static int __init acpica_test_init(void)
+{
+	test_init_functions();
+	test_functions();
+	test_globals();
+	test_macros();
+
+	return 0;
+}
+
+fs_initcall(acpica_test_init);
-- 
1.7.10

