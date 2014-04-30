Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbaD3CEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:04:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:21860 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbaD3CEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:04:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="531005085"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 10/27] ACPICA: OSL: Move external globals from utglobal.c to acpixf.h using ACPI_INIT_GLOBAL/ACPI_GLOBAL.
Date: Wed, 30 Apr 2014 10:04:35 +0800
Message-Id: <f459c57b5961d1f96ce42be70c8339c69e90ad90.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OSPMs like Linux trend to include all header files but leave empty stub
macros for a feature that is not configured during build.

This patch cleans up global variables that are defined in utglobal.c using
ACPI_INIT_GLOBAL mechanism.  In Linux, such global variables are used by
the subsystems external to ACPICA.
This patch also cleans up global variables that are defined in utglobal.c
using ACPI_GLOBAL mechanism.  In Linux, such global variables are not used
or should not be used by the subsystems external to ACPICA.

External global variables can be redefined by OSPMs using
ACPI_INIT_GLOBAL/ACPI_GLOBAL macros.  Thus the ACPI_GLOBAL/ACPI_INIT_GLOBAL
mechanisms can be used by OSPM to implement stubs for such external
globals.

This patch doesn't include code for Linux to use this new mechanism, thus
no functional changes.  Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
---
 drivers/acpi/acpica/utglobal.c |   22 ----------------------
 include/acpi/acpixf.h          |   35 +++++++++++++++++++++++------------
 2 files changed, 23 insertions(+), 34 deletions(-)

diff --git a/drivers/acpi/acpica/utglobal.c b/drivers/acpi/acpica/utglobal.c
index 825b064..d69be3c 100644
--- a/drivers/acpi/acpica/utglobal.c
+++ b/drivers/acpi/acpica/utglobal.c
@@ -55,28 +55,7 @@ ACPI_MODULE_NAME("utglobal")
  * Static global variable initialization.
  *
  ******************************************************************************/
-/* Debug output control masks */
-u32 acpi_dbg_level = ACPI_DEBUG_DEFAULT;
-
-u32 acpi_dbg_layer = 0;
-
-/* acpi_gbl_FADT is a local copy of the FADT, converted to a common format. */
-
-struct acpi_table_fadt acpi_gbl_FADT;
-u32 acpi_gbl_trace_flags;
-acpi_name acpi_gbl_trace_method_name;
-u8 acpi_gbl_system_awake_and_running;
-u32 acpi_current_gpe_count;
-
-/*
- * ACPI 5.0 introduces the concept of a "reduced hardware platform", meaning
- * that the ACPI hardware is no longer required. A flag in the FADT indicates
- * a reduced HW machine, and that flag is duplicated here for convenience.
- */
-u8 acpi_gbl_reduced_hardware;
-
 /* Various state name strings */
-
 const char *acpi_gbl_sleep_state_names[ACPI_S_STATE_COUNT] = {
 	"\\_S0_",
 	"\\_S1_",
@@ -337,7 +316,6 @@ acpi_status acpi_ut_init_globals(void)
 	acpi_gbl_acpi_hardware_present = TRUE;
 	acpi_gbl_last_owner_id_index = 0;
 	acpi_gbl_next_owner_id_offset = 0;
-	acpi_gbl_trace_method_name = 0;
 	acpi_gbl_trace_dbg_level = 0;
 	acpi_gbl_trace_dbg_layer = 0;
 	acpi_gbl_debugger_configuration = DEBUGGER_THREADING;
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 010816e..8255689 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -185,22 +185,33 @@ ACPI_INIT_GLOBAL(u8, acpi_gbl_disable_ssdt_table_install, FALSE);
 ACPI_INIT_GLOBAL(u8, acpi_gbl_osi_data, 0);
 
 /*
- * Other miscellaneous public globals
+ * ACPI 5.0 introduces the concept of a "reduced hardware platform", meaning
+ * that the ACPI hardware is no longer required. A flag in the FADT indicates
+ * a reduced HW machine, and that flag is duplicated here for convenience.
  */
-extern u32 acpi_current_gpe_count;
-extern struct acpi_table_fadt acpi_gbl_FADT;
-extern u8 acpi_gbl_system_awake_and_running;
-extern u8 acpi_gbl_reduced_hardware;	/* ACPI 5.0 */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_reduced_hardware, FALSE);
 
-/* Runtime configuration of debug print levels */
-
-extern u32 acpi_dbg_level;
-extern u32 acpi_dbg_layer;
+/*
+ * This mechanism is used to trace a specified AML method. The method is
+ * traced each time it is executed.
+ */
+ACPI_INIT_GLOBAL(u32, acpi_gbl_trace_flags, 0);
+ACPI_INIT_GLOBAL(acpi_name, acpi_gbl_trace_method_name, 0);
 
-/* ACPICA runtime options */
+/*
+ * Runtime configuration of debug output control masks. We want the debug
+ * switches statically initialized so they are already set when the debugger
+ * is entered.
+ */
+ACPI_INIT_GLOBAL(u32, acpi_dbg_level, ACPI_DEBUG_DEFAULT);
+ACPI_INIT_GLOBAL(u32, acpi_dbg_layer, 0);
 
-extern u32 acpi_gbl_trace_flags;
-extern acpi_name acpi_gbl_trace_method_name;
+/*
+ * Globals that are publically available
+ */
+ACPI_GLOBAL(u32, acpi_current_gpe_count);
+ACPI_GLOBAL(struct acpi_table_fadt, acpi_gbl_FADT);
+ACPI_GLOBAL(u8, acpi_gbl_system_awake_and_running);
 
 /*
  * Hardware-reduced prototypes. All interfaces that use these macros will
-- 
1.7.10

