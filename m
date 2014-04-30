Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbaD3CFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:05:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:54555 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbaD3CFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:05:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="523496738"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 13/27] ACPICA: OSL: Add configurability for debug output functions.
Date: Wed, 30 Apr 2014 10:04:55 +0800
Message-Id: <b1eed4b8605f7ef43bae1720c106b1a6a558e11b.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends ACPI_HW_DEPENDENT_x mechanism to all debugging output
related functions so that the OSPMs can have full control to configure
them into stub functions.

This patch doesn't include code for Linux to use this new mechanism, thus
no functional change.  Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
---
 include/acpi/acpixf.h |   49 +++++++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 39f432e..923775a 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -256,6 +256,21 @@ ACPI_GLOBAL(u8, acpi_gbl_system_awake_and_running);
 #endif				/* ACPI_NO_ERROR_MESSAGES */
 
 /*
+ * Debugging-output prototypes. All interfaces that use these macros will
+ * be configured out of the ACPICA build if the ACPI_DEBUG_OUTPUT flag is
+ * not defined.
+ */
+#ifdef ACPI_DEBUG_OUTPUT
+#define ACPI_DBG_DEPENDENT_RETURN_VOID(prototype) \
+	prototype;
+
+#else
+#define ACPI_DBG_DEPENDENT_RETURN_VOID(prototype) \
+	static ACPI_INLINE prototype {return;}
+
+#endif				/* ACPI_DEBUG_OUTPUT */
+
+/*
  * Initialization
  */
 acpi_status __init
@@ -716,22 +731,20 @@ ACPI_MSG_DEPENDENT_RETURN_VOID(ACPI_PRINTF_LIKE(3)
 /*
  * Debug output
  */
-#ifdef ACPI_DEBUG_OUTPUT
-ACPI_PRINTF_LIKE(6)
-void ACPI_INTERNAL_VAR_XFACE
-acpi_debug_print(u32 requested_debug_level,
-		 u32 line_number,
-		 const char *function_name,
-		 const char *module_name,
-		 u32 component_id, const char *format, ...);
-
-ACPI_PRINTF_LIKE(6)
-void ACPI_INTERNAL_VAR_XFACE
-acpi_debug_print_raw(u32 requested_debug_level,
-		     u32 line_number,
-		     const char *function_name,
-		     const char *module_name,
-		     u32 component_id, const char *format, ...);
-#endif
-
+ACPI_DBG_DEPENDENT_RETURN_VOID(ACPI_PRINTF_LIKE(6)
+			       void ACPI_INTERNAL_VAR_XFACE
+			       acpi_debug_print(u32 requested_debug_level,
+						u32 line_number,
+						const char *function_name,
+						const char *module_name,
+						u32 component_id,
+						const char *format, ...))
+ACPI_DBG_DEPENDENT_RETURN_VOID(ACPI_PRINTF_LIKE(6)
+				void ACPI_INTERNAL_VAR_XFACE
+				acpi_debug_print_raw(u32 requested_debug_level,
+						     u32 line_number,
+						     const char *function_name,
+						     const char *module_name,
+						     u32 component_id,
+						     const char *format, ...))
 #endif				/* __ACXFACE_H__ */
-- 
1.7.10

