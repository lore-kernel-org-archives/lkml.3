Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab3LRJGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:06:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:62189 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab3LRJGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:06:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="451879413"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH 02/15] ACPICA: Linux: Add configurability for external globals.
Date: Wed, 18 Dec 2013 17:06:03 +0800
Message-Id: <210435d18043054a1e9976733a2dbe4086291af5.1387336613.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1387336613.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OSPMs like Linux trend to include all header files but leave empty inline
stub variables for a feature that is not configured during build.

This patch configures ACPICA external globals out and defines them into
immediates when CONFIG_ACPI is not enabled.  Lv Zheng.

Known issues:
1. No possible referencs by !CONFIG_ACPI code
   We even don't need to define specific globals into immediates if it is
   impossible that there are references for them in !CONFIG_ACPI code.
   This patch just adds immediates for all of them from ACPICA's
   perspectives.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/acpixf.h           |   11 ++++++++
 include/acpi/platform/aclinux.h |   53 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 76df71d..2fc2094 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -74,13 +74,24 @@ extern u32 acpi_rsdt_forced;
 
 #else
 
+#ifndef ACPI_EXTERN
 #define ACPI_EXTERN extern
+#endif
+
+#ifndef ACPI_GLOBAL
 #define ACPI_GLOBAL(t,a) \
 	extern t a;
+#endif
+
+#ifndef ACPI_INIT_GLOBAL
 #define ACPI_INIT_GLOBAL(t,a,b) \
 	extern t a;
+#endif
+
+#ifndef ACPI_GLOBAL_FADT
 #define ACPI_GLOBAL_FADT \
 	extern struct acpi_table_fadt acpi_gbl_FADT;
+#endif
 
 #endif
 
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index 28f4f4d..68cda04 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -65,6 +65,59 @@
 #endif
 #include <asm/acpi.h>
 
+#ifdef CONFIG_ACPI
+
+/*
+ * External acpi_gbl_FADT users will use Revision and Flags to test
+ * features, such code may not well protected by CONFIG_ACPI.
+ */
+#define acpi_get_fadt_revision()    (acpi_gbl_FADT.header.revision)
+#define acpi_test_fadt_flags(__flags) (acpi_gbl_FADT.flags & (__flags))
+
+#else				/* CONFIG_ACPI */
+
+/* Extarnal globals for __KERNEL__, stubs is needed */
+
+#define ACPI_EXTERN
+#define ACPI_GLOBAL(t,a)
+#define ACPI_INIT_GLOBAL(t,a,b)
+#define ACPI_GLOBAL_FADT
+
+/* Immediates to protect global variables accesses */
+
+#define acpi_current_gpe_count              0
+#define acpi_gbl_trace_flags                0
+#define acpi_gbl_trace_method_name          0
+#define acpi_gbl_system_awake_and_running   FALSE
+#define acpi_gbl_reduced_hardware           FALSE
+#define acpi_gbl_enable_interpreter_slack   FALSE
+#define acpi_gbl_all_methods_serialized     FALSE
+#define acpi_gbl_create_osi_method          TRUE
+#define acpi_gbl_use_default_register_widths TRUE
+#define acpi_gbl_enable_aml_debug_object    FALSE
+#define acpi_gbl_copy_dsdt_locally          FALSE
+#define acpi_gbl_truncate_io_addresses      FALSE
+#define acpi_gbl_disable_auto_repair        FALSE
+#define acpi_gbl_disable_ssdt_table_load    FALSE
+#define acpi_gbl_osi_data                   0
+#define acpi_dbg_level                      ACPI_DEBUG_DEFAULT
+#define acpi_dbg_layer                      ACPI_COMPONENT_DEFAULT
+
+/* Helpers to protect acpi_gbl_FADT accesses */
+
+#define acpi_get_fadt_revision()    0
+#define acpi_test_fadt_flags(__flags) 0
+
+#endif				/* CONFIG_ACPI */
+
+#ifndef ACPI_DISASSEMBLER
+
+/* Immediates to protect global variables accesses */
+
+#define acpi_gbl_no_resource_disassembly    FALSE
+#define acpi_gbl_ignore_noop_operator       FALSE
+#endif
+
 /* Host-dependent types and defines for in-kernel ACPICA */
 
 #define ACPI_MACHINE_WIDTH          BITS_PER_LONG
-- 
1.7.10.4

