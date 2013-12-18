Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab3LRJHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:07:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:52009 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab3LRJGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:06:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="426510597"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH 01/15] ACPICA: OSL: Add configurability mechanism for global variables.
Date: Wed, 18 Dec 2013 17:05:56 +0800
Message-Id: <fe16b51fdc16272c6f6d1b27d29eeb285b3fc40b.1387336613.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1387336613.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends ACPI_INIT_GLOBAL mechanism to all global variables so
that the OSPMs can have full control to configure them into immediates.
This patch doesn't include any code for Linux to utilize this mechanism.

Linux practice shows there are external users out of Linux ACPI subsystem
checking ACPICA provided global variables.  Linux trends to protect such
global variables by defining them to default values when specific Kconfig
items are not enabled (particular to ACPICA, it should be CONFIG_ACPI) or
Linux will suffer from build errors complaining the absense of such global
variables.
This patch converts all ACPICA global variables into macro wrapped so that
OSPMs can configure such global variables out by defining ACPI_GLOBAL and
ACPI_INIT_GLOBAL into no-ops.  For the code still referencing such globals
when ACPICA is configured out, OSPMs can either define global variable
symbols into constant variables (static const if it doesn't increase the
size of the OSPMs' binary image) or maintain a big list of the macros in
the "#define AcpiGbl_x v" style.  Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/acglobal.h |  123 -----------------------------
 drivers/acpi/acpica/utglobal.c |    6 --
 include/acpi/acpixf.h          |  170 ++++++++++++++++++++++++++++++++--------
 3 files changed, 138 insertions(+), 161 deletions(-)

diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
index e9f1fc7..923fa29 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -44,127 +44,6 @@
 #ifndef __ACGLOBAL_H__
 #define __ACGLOBAL_H__
 
-/*
- * Ensure that the globals are actually defined and initialized only once.
- *
- * The use of these macros allows a single list of globals (here) in order
- * to simplify maintenance of the code.
- */
-#ifdef DEFINE_ACPI_GLOBALS
-#define ACPI_EXTERN
-#define ACPI_INIT_GLOBAL(a,b) a=b
-#else
-#define ACPI_EXTERN extern
-#define ACPI_INIT_GLOBAL(a,b) a
-#endif
-
-#ifdef DEFINE_ACPI_GLOBALS
-
-/* Public globals, available from outside ACPICA subsystem */
-
-/*****************************************************************************
- *
- * Runtime configuration (static defaults that can be overriden at runtime)
- *
- ****************************************************************************/
-
-/*
- * Enable "slack" in the AML interpreter?  Default is FALSE, and the
- * interpreter strictly follows the ACPI specification. Setting to TRUE
- * allows the interpreter to ignore certain errors and/or bad AML constructs.
- *
- * Currently, these features are enabled by this flag:
- *
- * 1) Allow "implicit return" of last value in a control method
- * 2) Allow access beyond the end of an operation region
- * 3) Allow access to uninitialized locals/args (auto-init to integer 0)
- * 4) Allow ANY object type to be a source operand for the Store() operator
- * 5) Allow unresolved references (invalid target name) in package objects
- * 6) Enable warning messages for behavior that is not ACPI spec compliant
- */
-u8 ACPI_INIT_GLOBAL(acpi_gbl_enable_interpreter_slack, FALSE);
-
-/*
- * Automatically serialize ALL control methods? Default is FALSE, meaning
- * to use the Serialized/not_serialized method flags on a per method basis.
- * Only change this if the ASL code is poorly written and cannot handle
- * reentrancy even though methods are marked "NotSerialized".
- */
-u8 ACPI_INIT_GLOBAL(acpi_gbl_all_methods_serialized, FALSE);
-
-/*
- * Create the predefined _OSI method in the namespace? Default is TRUE
- * because ACPI CA is fully compatible with other ACPI implementations.
- * Changing this will revert ACPI CA (and machine ASL) to pre-OSI behavior.
- */
-u8 ACPI_INIT_GLOBAL(acpi_gbl_create_osi_method, TRUE);
-
-/*
- * Optionally use default values for the ACPI register widths. Set this to
- * TRUE to use the defaults, if an FADT contains incorrect widths/lengths.
- */
-u8 ACPI_INIT_GLOBAL(acpi_gbl_use_default_register_widths, TRUE);
-
-/*
- * Optionally enable output from the AML Debug Object.
- */
-bool ACPI_INIT_GLOBAL(acpi_gbl_enable_aml_debug_object, FALSE);
-
-/*
- * Optionally copy the entire DSDT to local memory (instead of simply
- * mapping it.) There are some BIOSs that corrupt or replace the original
- * DSDT, creating the need for this option. Default is FALSE, do not copy
- * the DSDT.
- */
-u8 ACPI_INIT_GLOBAL(acpi_gbl_copy_dsdt_locally, FALSE);
-
-/*
- * Optionally truncate I/O addresses to 16 bits. Provides compatibility
- * with other ACPI implementations. NOTE: During ACPICA initialization,
- * this value is set to TRUE if any Windows OSI strings have been
- * requested by the BIOS.
- */
-u8 ACPI_INIT_GLOBAL(acpi_gbl_truncate_io_addresses, FALSE);
-
-/*
- * Disable runtime checking and repair of values returned by control methods.
- * Use only if the repair is causing a problem on a particular machine.
- */
-u8 ACPI_INIT_GLOBAL(acpi_gbl_disable_auto_repair, FALSE);
-
-/*
- * Optionally do not load any SSDTs from the RSDT/XSDT during initialization.
- * This can be useful for debugging ACPI problems on some machines.
- */
-u8 ACPI_INIT_GLOBAL(acpi_gbl_disable_ssdt_table_load, FALSE);
-
-/*
- * We keep track of the latest version of Windows that has been requested by
- * the BIOS.
- */
-u8 ACPI_INIT_GLOBAL(acpi_gbl_osi_data, 0);
-
-/* acpi_gbl_FADT is a local copy of the FADT, converted to a common format. */
-
-struct acpi_table_fadt acpi_gbl_FADT;
-u32 acpi_current_gpe_count;
-u32 acpi_gbl_trace_flags;
-acpi_name acpi_gbl_trace_method_name;
-u8 acpi_gbl_system_awake_and_running;
-
-/*
- * ACPI 5.0 introduces the concept of a "reduced hardware platform", meaning
- * that the ACPI hardware is no longer required. A flag in the FADT indicates
- * a reduced HW machine, and that flag is duplicated here for convenience.
- */
-u8 acpi_gbl_reduced_hardware;
-
-#endif				/* DEFINE_ACPI_GLOBALS */
-
-/* Do not disassemble buffers to resource descriptors */
-
-ACPI_EXTERN u8 ACPI_INIT_GLOBAL(acpi_gbl_no_resource_disassembly, FALSE);
-
 /*****************************************************************************
  *
  * ACPI Table globals
@@ -428,8 +307,6 @@ ACPI_EXTERN u8 acpi_gbl_db_output_flags;
 
 #ifdef ACPI_DISASSEMBLER
 
-ACPI_EXTERN u8 ACPI_INIT_GLOBAL(acpi_gbl_ignore_noop_operator, FALSE);
-
 ACPI_EXTERN u8 acpi_gbl_db_opt_disasm;
 ACPI_EXTERN u8 acpi_gbl_db_opt_verbose;
 ACPI_EXTERN u8 acpi_gbl_num_external_methods;
diff --git a/drivers/acpi/acpica/utglobal.c b/drivers/acpi/acpica/utglobal.c
index 81f9a95..b15b822 100644
--- a/drivers/acpi/acpica/utglobal.c
+++ b/drivers/acpi/acpica/utglobal.c
@@ -59,12 +59,6 @@ ACPI_MODULE_NAME("utglobal")
  * We want the debug switches statically initialized so they
  * are already set when the debugger is entered.
  */
-/* Debug switch - level and trace mask */
-u32 acpi_dbg_level = ACPI_DEBUG_DEFAULT;
-
-/* Debug switch - layer (component) mask */
-
-u32 acpi_dbg_layer = 0;
 u32 acpi_gbl_nesting_level = 0;
 
 /* Debugger globals */
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 4278aba9..76df71d 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -57,34 +57,147 @@ extern u8 acpi_gbl_permanent_mmap;
 extern u32 acpi_rsdt_forced;
 
 /*
- * Globals that are publically available
+ * Ensure that the globals are actually defined and initialized only once.
+ *
+ * The use of these macros allows a single list of globals (here) in order
+ * to simplify maintenance of the code.
+ */
+#ifdef DEFINE_ACPI_GLOBALS
+
+#define ACPI_EXTERN
+#define ACPI_GLOBAL(t,a) \
+	t a;
+#define ACPI_INIT_GLOBAL(t,a,b) \
+	t a=b;
+#define ACPI_GLOBAL_FADT \
+	struct acpi_table_fadt acpi_gbl_FADT;
+
+#else
+
+#define ACPI_EXTERN extern
+#define ACPI_GLOBAL(t,a) \
+	extern t a;
+#define ACPI_INIT_GLOBAL(t,a,b) \
+	extern t a;
+#define ACPI_GLOBAL_FADT \
+	extern struct acpi_table_fadt acpi_gbl_FADT;
+
+#endif
+
+/* Public globals, available from outside ACPICA subsystem */
+
+/*****************************************************************************
+ *
+ * Runtime configuration (static defaults that can be overriden at runtime)
+ *
+ ****************************************************************************/
+
+/*
+ * Enable "slack" in the AML interpreter?  Default is FALSE, and the
+ * interpreter strictly follows the ACPI specification. Setting to TRUE
+ * allows the interpreter to ignore certain errors and/or bad AML constructs.
+ *
+ * Currently, these features are enabled by this flag:
+ *
+ * 1) Allow "implicit return" of last value in a control method
+ * 2) Allow access beyond the end of an operation region
+ * 3) Allow access to uninitialized locals/args (auto-init to integer 0)
+ * 4) Allow ANY object type to be a source operand for the Store() operator
+ * 5) Allow unresolved references (invalid target name) in package objects
+ * 6) Enable warning messages for behavior that is not ACPI spec compliant
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_enable_interpreter_slack, FALSE)
+
+/*
+ * Automatically serialize ALL control methods? Default is FALSE, meaning
+ * to use the Serialized/not_serialized method flags on a per method basis.
+ * Only change this if the ASL code is poorly written and cannot handle
+ * reentrancy even though methods are marked "NotSerialized".
  */
-extern u32 acpi_current_gpe_count;
-extern struct acpi_table_fadt acpi_gbl_FADT;
-extern u8 acpi_gbl_system_awake_and_running;
-extern u8 acpi_gbl_reduced_hardware;	/* ACPI 5.0 */
-extern u8 acpi_gbl_osi_data;
-
-/* Runtime configuration of debug print levels */
-
-extern u32 acpi_dbg_level;
-extern u32 acpi_dbg_layer;
-
-/* ACPICA runtime options */
-
-extern u8 acpi_gbl_enable_interpreter_slack;
-extern u8 acpi_gbl_all_methods_serialized;
-extern u8 acpi_gbl_create_osi_method;
-extern u8 acpi_gbl_use_default_register_widths;
-extern acpi_name acpi_gbl_trace_method_name;
-extern u32 acpi_gbl_trace_flags;
-extern bool acpi_gbl_enable_aml_debug_object;
-extern u8 acpi_gbl_copy_dsdt_locally;
-extern u8 acpi_gbl_truncate_io_addresses;
-extern u8 acpi_gbl_disable_auto_repair;
-extern u8 acpi_gbl_disable_ssdt_table_load;
+ACPI_INIT_GLOBAL(u8, acpi_gbl_all_methods_serialized, FALSE)
 
 /*
+ * Create the predefined _OSI method in the namespace? Default is TRUE
+ * because ACPI CA is fully compatible with other ACPI implementations.
+ * Changing this will revert ACPI CA (and machine ASL) to pre-OSI behavior.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_create_osi_method, TRUE)
+
+/*
+ * Optionally use default values for the ACPI register widths. Set this to
+ * TRUE to use the defaults, if an FADT contains incorrect widths/lengths.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_use_default_register_widths, TRUE)
+
+/*
+ * Optionally enable output from the AML Debug Object.
+ */
+ACPI_INIT_GLOBAL(bool, acpi_gbl_enable_aml_debug_object, FALSE)
+
+/*
+ * Optionally copy the entire DSDT to local memory (instead of simply
+ * mapping it.) There are some BIOSs that corrupt or replace the original
+ * DSDT, creating the need for this option. Default is FALSE, do not copy
+ * the DSDT.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_copy_dsdt_locally, FALSE)
+
+/*
+ * Optionally truncate I/O addresses to 16 bits. Provides compatibility
+ * with other ACPI implementations. NOTE: During ACPICA initialization,
+ * this value is set to TRUE if any Windows OSI strings have been
+ * requested by the BIOS.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_truncate_io_addresses, FALSE)
+
+/*
+ * Disable runtime checking and repair of values returned by control methods.
+ * Use only if the repair is causing a problem on a particular machine.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_disable_auto_repair, FALSE)
+
+/*
+ * Optionally do not load any SSDTs from the RSDT/XSDT during initialization.
+ * This can be useful for debugging ACPI problems on some machines.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_disable_ssdt_table_load, FALSE)
+
+/*
+ * We keep track of the latest version of Windows that has been requested by
+ * the BIOS.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_osi_data, 0)
+
+/* acpi_gbl_FADT is a local copy of the FADT, converted to a common format. */
+ ACPI_GLOBAL_FADT
+ACPI_GLOBAL(u32, acpi_current_gpe_count)
+ACPI_GLOBAL(u32, acpi_gbl_trace_flags)
+ACPI_GLOBAL(acpi_name, acpi_gbl_trace_method_name)
+ACPI_GLOBAL(u8, acpi_gbl_system_awake_and_running)
+
+/* Debug switch - level and trace mask */
+#ifdef ACPI_DEBUG_OUTPUT
+ACPI_INIT_GLOBAL(u32, acpi_dbg_level, ACPI_DEBUG_DEFAULT)
+#else
+ACPI_INIT_GLOBAL(u32, acpi_dbg_level, ACPI_NORMAL_DEFAULT)
+#endif
+/* Debug switch - layer (component) mask */
+ACPI_INIT_GLOBAL(u32, acpi_dbg_layer, ACPI_COMPONENT_DEFAULT)
+
+/*
+ * ACPI 5.0 introduces the concept of a "reduced hardware platform", meaning
+ * that the ACPI hardware is no longer required. A flag in the FADT indicates
+ * a reduced HW machine, and that flag is duplicated here for convenience.
+ */
+ACPI_GLOBAL(u8, acpi_gbl_reduced_hardware)
+
+/* Disassembler related globals */
+#ifdef ACPI_DISASSEMBLER
+/* Do not disassemble buffers to resource descriptors */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_no_resource_disassembly, FALSE)
+ ACPI_INIT_GLOBAL(u8, acpi_gbl_ignore_noop_operator, FALSE)
+#endif
+/*
  * Hardware-reduced prototypes. All interfaces that use these macros will
  * be configured out of the ACPICA build if the ACPI_REDUCED_HARDWARE flag
  * is set to TRUE.
@@ -92,25 +205,18 @@ extern u8 acpi_gbl_disable_ssdt_table_load;
 #if (!ACPI_REDUCED_HARDWARE)
 #define ACPI_HW_DEPENDENT_RETURN_STATUS(prototype) \
 	prototype;
-
 #define ACPI_HW_DEPENDENT_RETURN_OK(prototype) \
 	prototype;
-
 #define ACPI_HW_DEPENDENT_RETURN_VOID(prototype) \
 	prototype;
-
 #else
 #define ACPI_HW_DEPENDENT_RETURN_STATUS(prototype) \
 	static ACPI_INLINE prototype {return(AE_NOT_CONFIGURED);}
-
 #define ACPI_HW_DEPENDENT_RETURN_OK(prototype) \
 	static ACPI_INLINE prototype {return(AE_OK);}
-
 #define ACPI_HW_DEPENDENT_RETURN_VOID(prototype) \
 	static ACPI_INLINE prototype {return;}
-
 #endif				/* !ACPI_REDUCED_HARDWARE */
-
 /*
  * Initialization
  */
-- 
1.7.10.4

