Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbaD3CJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:09:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:49886 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbaD3CEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:04:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="503427955"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 04/27] ACPICA: Update global variable definitions. No functional change.
Date: Wed, 30 Apr 2014 10:03:52 +0800
Message-Id: <abb32efd726fefcd97089cda2b9c640382e59cf4.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all of the public globals to acpixf.h for the convenience
of users. Also:

Adds #ifndef/#endif conditions arround ACPI_GLOBAL and
ACPI_INIT_GLOBAL definition so that OSPMs might be able to:
1. Redefine ACPI_GLOBAL/ACPI_INIT_GLOBAL into no-op, and
2. Redefine external global variables into immediates to implement stubs
   for them.
Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
---
 drivers/acpi/acpica/acglobal.h |  134 +------------------------------------
 include/acpi/acpixf.h          |  143 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 132 insertions(+), 145 deletions(-)

diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
index e7d73eb..115eedc 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -44,144 +44,14 @@
 #ifndef __ACGLOBAL_H__
 #define __ACGLOBAL_H__
 
-/*
- * Ensure that the globals are actually defined and initialized only once.
- *
- * The use of these macros allows a single list of globals (here) in order
- * to simplify maintenance of the code.
- */
-#ifdef DEFINE_ACPI_GLOBALS
-#define ACPI_GLOBAL(type,name) \
-	extern type name; \
-	type name
-
-#define ACPI_INIT_GLOBAL(type,name,value) \
-	type name=value
-
-#else
-#define ACPI_GLOBAL(type,name) \
-	extern type name
-
-#define ACPI_INIT_GLOBAL(type,name,value) \
-	extern type name
-#endif
-
-#ifdef DEFINE_ACPI_GLOBALS
-
-/* Public globals, available from outside ACPICA subsystem */
-
 /*****************************************************************************
  *
- * Runtime configuration (static defaults that can be overriden at runtime)
+ * Globals related to the ACPI tables
  *
  ****************************************************************************/
 
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
-ACPI_INIT_GLOBAL(u8, acpi_gbl_enable_interpreter_slack, FALSE);
-
-/*
- * Automatically serialize all methods that create named objects? Default
- * is TRUE, meaning that all non_serialized methods are scanned once at
- * table load time to determine those that create named objects. Methods
- * that create named objects are marked Serialized in order to prevent
- * possible run-time problems if they are entered by more than one thread.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_auto_serialize_methods, TRUE);
-
-/*
- * Create the predefined _OSI method in the namespace? Default is TRUE
- * because ACPICA is fully compatible with other ACPI implementations.
- * Changing this will revert ACPICA (and machine ASL) to pre-OSI behavior.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_create_osi_method, TRUE);
-
-/*
- * Optionally use default values for the ACPI register widths. Set this to
- * TRUE to use the defaults, if an FADT contains incorrect widths/lengths.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_use_default_register_widths, TRUE);
-
-/*
- * Optionally enable output from the AML Debug Object.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_enable_aml_debug_object, FALSE);
-
-/*
- * Optionally copy the entire DSDT to local memory (instead of simply
- * mapping it.) There are some BIOSs that corrupt or replace the original
- * DSDT, creating the need for this option. Default is FALSE, do not copy
- * the DSDT.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_copy_dsdt_locally, FALSE);
-
-/*
- * Optionally ignore an XSDT if present and use the RSDT instead.
- * Although the ACPI specification requires that an XSDT be used instead
- * of the RSDT, the XSDT has been found to be corrupt or ill-formed on
- * some machines. Default behavior is to use the XSDT if present.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_do_not_use_xsdt, FALSE);
-
-/*
- * Optionally use 32-bit FADT addresses if and when there is a conflict
- * (address mismatch) between the 32-bit and 64-bit versions of the
- * address. Although ACPICA adheres to the ACPI specification which
- * requires the use of the corresponding 64-bit address if it is non-zero,
- * some machines have been found to have a corrupted non-zero 64-bit
- * address. Default is FALSE, do not favor the 32-bit addresses.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_use32_bit_fadt_addresses, FALSE);
-
-/*
- * Optionally truncate I/O addresses to 16 bits. Provides compatibility
- * with other ACPI implementations. NOTE: During ACPICA initialization,
- * this value is set to TRUE if any Windows OSI strings have been
- * requested by the BIOS.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_truncate_io_addresses, FALSE);
-
-/*
- * Disable runtime checking and repair of values returned by control methods.
- * Use only if the repair is causing a problem on a particular machine.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_disable_auto_repair, FALSE);
+/* Master list of all ACPI tables that were found in the RSDT/XSDT */
 
-/*
- * Optionally do not install any SSDTs from the RSDT/XSDT during initialization.
- * This can be useful for debugging ACPI problems on some machines.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_disable_ssdt_table_install, FALSE);
-
-/*
- * We keep track of the latest version of Windows that has been requested by
- * the BIOS.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_osi_data, 0);
-
-#endif				/* DEFINE_ACPI_GLOBALS */
-
-/*****************************************************************************
- *
- * ACPI Table globals
- *
- ****************************************************************************/
-
-/*
- * Master list of all ACPI tables that were found in the RSDT/XSDT.
- */
 ACPI_GLOBAL(struct acpi_table_list, acpi_gbl_root_table_list);
 
 /* DSDT information. Used to check for DSDT corruption */
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 913d076..010816e 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -56,13 +56,141 @@
 extern u8 acpi_gbl_permanent_mmap;
 
 /*
- * Globals that are publically available
+ * Ensure that the globals are actually defined and initialized only once.
+ *
+ * The use of these macros allows a single list of globals (here) in order
+ * to simplify maintenance of the code.
+ */
+#ifdef DEFINE_ACPI_GLOBALS
+#define ACPI_GLOBAL(type,name) \
+	extern type name; \
+	type name
+
+#define ACPI_INIT_GLOBAL(type,name,value) \
+	type name=value
+
+#else
+#ifndef ACPI_GLOBAL
+#define ACPI_GLOBAL(type,name) \
+	extern type name
+#endif
+
+#ifndef ACPI_INIT_GLOBAL
+#define ACPI_INIT_GLOBAL(type,name,value) \
+	extern type name
+#endif
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
+ACPI_INIT_GLOBAL(u8, acpi_gbl_enable_interpreter_slack, FALSE);
+
+/*
+ * Automatically serialize all methods that create named objects? Default
+ * is TRUE, meaning that all non_serialized methods are scanned once at
+ * table load time to determine those that create named objects. Methods
+ * that create named objects are marked Serialized in order to prevent
+ * possible run-time problems if they are entered by more than one thread.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_auto_serialize_methods, TRUE);
+
+/*
+ * Create the predefined _OSI method in the namespace? Default is TRUE
+ * because ACPICA is fully compatible with other ACPI implementations.
+ * Changing this will revert ACPICA (and machine ASL) to pre-OSI behavior.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_create_osi_method, TRUE);
+
+/*
+ * Optionally use default values for the ACPI register widths. Set this to
+ * TRUE to use the defaults, if an FADT contains incorrect widths/lengths.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_use_default_register_widths, TRUE);
+
+/*
+ * Optionally enable output from the AML Debug Object.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_enable_aml_debug_object, FALSE);
+
+/*
+ * Optionally copy the entire DSDT to local memory (instead of simply
+ * mapping it.) There are some BIOSs that corrupt or replace the original
+ * DSDT, creating the need for this option. Default is FALSE, do not copy
+ * the DSDT.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_copy_dsdt_locally, FALSE);
+
+/*
+ * Optionally ignore an XSDT if present and use the RSDT instead.
+ * Although the ACPI specification requires that an XSDT be used instead
+ * of the RSDT, the XSDT has been found to be corrupt or ill-formed on
+ * some machines. Default behavior is to use the XSDT if present.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_do_not_use_xsdt, FALSE);
+
+/*
+ * Optionally use 32-bit FADT addresses if and when there is a conflict
+ * (address mismatch) between the 32-bit and 64-bit versions of the
+ * address. Although ACPICA adheres to the ACPI specification which
+ * requires the use of the corresponding 64-bit address if it is non-zero,
+ * some machines have been found to have a corrupted non-zero 64-bit
+ * address. Default is FALSE, do not favor the 32-bit addresses.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_use32_bit_fadt_addresses, FALSE);
+
+/*
+ * Optionally truncate I/O addresses to 16 bits. Provides compatibility
+ * with other ACPI implementations. NOTE: During ACPICA initialization,
+ * this value is set to TRUE if any Windows OSI strings have been
+ * requested by the BIOS.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_truncate_io_addresses, FALSE);
+
+/*
+ * Disable runtime checking and repair of values returned by control methods.
+ * Use only if the repair is causing a problem on a particular machine.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_disable_auto_repair, FALSE);
+
+/*
+ * Optionally do not install any SSDTs from the RSDT/XSDT during initialization.
+ * This can be useful for debugging ACPI problems on some machines.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_disable_ssdt_table_install, FALSE);
+
+/*
+ * We keep track of the latest version of Windows that has been requested by
+ * the BIOS.  ACPI 5.0.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_osi_data, 0);
+
+/*
+ * Other miscellaneous public globals
  */
 extern u32 acpi_current_gpe_count;
 extern struct acpi_table_fadt acpi_gbl_FADT;
 extern u8 acpi_gbl_system_awake_and_running;
 extern u8 acpi_gbl_reduced_hardware;	/* ACPI 5.0 */
-extern u8 acpi_gbl_osi_data;
 
 /* Runtime configuration of debug print levels */
 
@@ -71,19 +199,8 @@ extern u32 acpi_dbg_layer;
 
 /* ACPICA runtime options */
 
-extern u8 acpi_gbl_auto_serialize_methods;
-extern u8 acpi_gbl_copy_dsdt_locally;
-extern u8 acpi_gbl_create_osi_method;
-extern u8 acpi_gbl_disable_auto_repair;
-extern u8 acpi_gbl_disable_ssdt_table_install;
-extern u8 acpi_gbl_do_not_use_xsdt;
-extern u8 acpi_gbl_enable_aml_debug_object;
-extern u8 acpi_gbl_enable_interpreter_slack;
 extern u32 acpi_gbl_trace_flags;
 extern acpi_name acpi_gbl_trace_method_name;
-extern u8 acpi_gbl_truncate_io_addresses;
-extern u8 acpi_gbl_use32_bit_fadt_addresses;
-extern u8 acpi_gbl_use_default_register_widths;
 
 /*
  * Hardware-reduced prototypes. All interfaces that use these macros will
-- 
1.7.10

