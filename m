Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab3LRJHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:07:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:15650 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab3LRJGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:06:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="446200500"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH 09/15] ACPICA: Linux: Add stub support for Linux specific variables and functions.
Date: Wed, 18 Dec 2013 17:06:44 +0800
Message-Id: <0f86540cd2b61cd4d6d5086849d6b619d76d9d1d.1387336613.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1387336613.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are global variables and functions not upstreamed to the ACPICA code
base.  Such symbols still can referenced by external users as they are
listed in the acpixf.h.  This patch uses ACPI_GLOBAL and
ACPI_EXTERNAL_RETURN_STATUS mechanism to add stub support for such symbols.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 arch/ia64/kernel/acpi.c         |    1 -
 arch/x86/kernel/acpi/boot.c     |    1 -
 drivers/acpi/bus.c              |    3 ---
 include/acpi/acpixf.h           |   23 ++++++++++++++---------
 include/acpi/platform/aclinux.h |    3 +++
 5 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 59d52e3..28dc6ba 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -61,7 +61,6 @@
 
 #define PREFIX			"ACPI: "
 
-u32 acpi_rsdt_forced;
 unsigned int acpi_cpei_override;
 unsigned int acpi_cpei_phys_cpuid;
 
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 6c0b43b..c83a974 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -46,7 +46,6 @@
 
 #include "sleep.h" /* To include x86_acpi_suspend_lowlevel */
 static int __initdata acpi_force = 0;
-u32 acpi_rsdt_forced;
 int acpi_disabled;
 EXPORT_SYMBOL(acpi_disabled);
 
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 2c38ae2..68d3e70 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -429,9 +429,6 @@ static int __init acpi_bus_init_irq(void)
 	return 0;
 }
 
-u8 acpi_gbl_permanent_mmap;
-
-
 void __init acpi_early_init(void)
 {
 	acpi_status status;
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 8f32dfe..1e93ef6 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -53,9 +53,6 @@
 #include <acpi/actbl.h>
 #include <acpi/acbuffer.h>
 
-extern u8 acpi_gbl_permanent_mmap;
-extern u32 acpi_rsdt_forced;
-
 /*
  * Ensure that the globals are actually defined and initialized only once.
  *
@@ -235,6 +232,10 @@ ACPI_GLOBAL(u8, acpi_gbl_reduced_hardware)
 ACPI_INIT_GLOBAL(u8, acpi_gbl_no_resource_disassembly, FALSE)
  ACPI_INIT_GLOBAL(u8, acpi_gbl_ignore_noop_operator, FALSE)
 #endif
+
+ACPI_GLOBAL(u8, acpi_gbl_permanent_mmap)
+ACPI_GLOBAL(u32, acpi_rsdt_forced)
+
 /*
  * Hardware-reduced prototypes. All interfaces that use these macros will
  * be configured out of the ACPICA build if the ACPI_REDUCED_HARDWARE flag
@@ -361,7 +362,7 @@ ACPI_EXTERNAL_RETURN_STATUS(acpi_status __init acpi_reallocate_root_table(void))
 ACPI_EXTERNAL_RETURN_STATUS(acpi_status __init
 			    acpi_find_root_pointer(acpi_size * rsdp_address))
 
-acpi_status acpi_unload_table_id(acpi_owner_id id);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status acpi_unload_table_id(acpi_owner_id id))
 
 ACPI_EXTERNAL_RETURN_STATUS(acpi_status
 			    acpi_get_table_header(acpi_string signature,
@@ -369,10 +370,12 @@ ACPI_EXTERNAL_RETURN_STATUS(acpi_status
 						  struct acpi_table_header
 						  *out_table_header))
 
-acpi_status
-acpi_get_table_with_size(acpi_string signature,
-	       u32 instance, struct acpi_table_header **out_table,
-	       acpi_size *tbl_size);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_get_table_with_size(acpi_string signature,
+						     u32 instance,
+						     struct acpi_table_header
+						     **out_table,
+						     acpi_size *tbl_size))
 
 ACPI_EXTERNAL_RETURN_STATUS(acpi_status
 			     acpi_get_table(acpi_string signature, u32 instance,
@@ -477,7 +480,9 @@ ACPI_EXTERNAL_RETURN_STATUS(acpi_status
 			    acpi_get_type(acpi_handle object,
 					  acpi_object_type * out_type))
 
-acpi_status acpi_get_id(acpi_handle object, acpi_owner_id * out_type);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_get_id(acpi_handle object,
+					acpi_owner_id * out_type))
 
 ACPI_EXTERNAL_RETURN_STATUS(acpi_status
 			    acpi_get_parent(acpi_handle object,
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index 12ef8be..b1ddf5c 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -133,6 +133,9 @@
 #define acpi_dbg_level                      ACPI_DEBUG_DEFAULT
 #define acpi_dbg_layer                      ACPI_COMPONENT_DEFAULT
 
+#define acpi_gbl_permanent_mmap             FALSE
+#define acpi_rsdt_forced                    FALSE
+
 /* Helpers to protect acpi_gbl_FADT accesses */
 
 #define acpi_get_fadt_revision()    0
-- 
1.7.10.4

