Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaELHu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:50:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:45626 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbaELHu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:50:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1033,1389772800"; 
   d="scan'208";a="510117684"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v3 1/2] ACPI: Cleanup to convert acpi.no_static_ssdt into a compile-time configurable.
Date: Mon, 12 May 2014 15:49:59 +0800
Message-Id: <5a2b1a503fbc65f63a18ca28727e023e5f48efcd.1399880919.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1396925060.git.lv.zheng@intel.com>
References: <cover.1396925060.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User can specify a DSDT with SSDT embedded, in which case, no_static_ssdt
must be enforced during compile-time.  If we don't do that and forget to
specify acpi.no_static_ssdt as a boot parameter, then:
1. The AML executable will be executed twice, the second execution is
   running under a changed environment.
2. The namespace object conflicts will result in an AE_ALREADY_EXISTS
   exception;
3. The namespace objects that are deleted from the original SSDT will be
   restored by the auto loading of the original SSDT.

Note that:
1. The DSDT customization is a compile-time feature, thus the SSDT
   inclusion indication of the DSDT customization should also be
   implemented as a compile-time configurable.
2. According to the commit log:
    Commit: 67effe8fff32f60bdf51cba484766ba6003005bb
    Subject: ACPI: add "acpi_no_auto_ssdt" bootparam
   The acpi.no_static_ssdt (originally acpi.no_auto_ssdt) was introduced to
   be used for this use case.  And over a long time, there is no other
   situation than this requires this boot parameter.
This patch thus converts the runtime kernel parameter into the compile-time
configuration item.

References: https://bugzilla.kernel.org/show_bug.cgi?id=3774
Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=69711
Original-by: Enrico Etxe Arte <goitizena.generoa@gmail.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 Documentation/kernel-parameters.txt |   10 ----------
 drivers/acpi/Kconfig                |   32 ++++++++++++++++++++++++++------
 drivers/acpi/internal.h             |    5 +++++
 drivers/acpi/osl.c                  |    8 +++-----
 drivers/acpi/tables.c               |    2 ++
 5 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 831fb1e..ceba0d6 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -237,16 +237,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			This feature is enabled by default.
 			This option allows to turn off the feature.
 
-	acpi_no_static_ssdt	[HW,ACPI]
-			Disable installation of static SSDTs at early boot time
-			By default, SSDTs contained in the RSDT/XSDT will be
-			installed automatically and they will appear under
-			/sys/firmware/acpi/tables.
-			This option turns off this feature.
-			Note that specifying this option does not affect
-			dynamic table installation which will install SSDT
-			tables to /sys/firmware/acpi/tables/dynamic.
-
 	acpica_no_return_repair [HW, ACPI]
 			Disable AML predefined validation mechanism
 			This mechanism can repair the evaluation result to make
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index c0160bb..51dc3b8 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -216,22 +216,40 @@ config ACPI_NUMA
 	depends on (X86 || IA64)
 	default y if IA64_GENERIC || IA64_SGI_SN2
 
-config ACPI_CUSTOM_DSDT_FILE
-	string "Custom DSDT Table file to include"
-	default ""
+menu "Table override"
+
+menuconfig ACPI_CUSTOM_DSDT
+	bool "Customize DSDT"
 	depends on !STANDALONE
 	help
 	  This option supports a custom DSDT by linking it into the kernel.
 	  See Documentation/acpi/dsdt-override.txt
 
+	  If unsure, say N.
+
+if ACPI_CUSTOM_DSDT
+
+config ACPI_CUSTOM_DSDT_FILE
+	string "Custom DSDT Table file to include"
+	default ""
+	help
 	  Enter the full path name to the file which includes the AmlCode
 	  declaration.
 
 	  If unsure, don't enter a file name.
 
-config ACPI_CUSTOM_DSDT
-	bool
-	default ACPI_CUSTOM_DSDT_FILE != ""
+config ACPI_CUSTOM_DSDT_WITH_SSDT
+	bool "Customize DSDT with static SSDTs included"
+	depends on ACPI_CUSTOM_DSDT
+	help
+	  This option allows a DSDT override to optionally be a DSDT+SSDT
+	  override.  In which case, Linux should stop loading static SSDTs
+          from RSDT/XSDT.  Otherwise, the load time AML execution of the
+	  SSDTs will be errornously executed twice.
+
+	  If unsure, say N.
+
+endif
 
 config ACPI_INITRD_TABLE_OVERRIDE
 	bool "ACPI tables override via initrd"
@@ -243,6 +261,8 @@ config ACPI_INITRD_TABLE_OVERRIDE
 	  initrd, therefore it's safe to say Y.
 	  See Documentation/acpi/initrd_table_override.txt for details
 
+endmenu
+
 config ACPI_DEBUG
 	bool "Debug Statements"
 	default n
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 9573913..f84ef59 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -57,6 +57,11 @@ void acpi_cmos_rtc_init(void);
 #else
 static inline void acpi_cmos_rtc_init(void) {}
 #endif
+#ifdef CONFIG_ACPI_CUSTOM_DSDT_WITH_SSDT
+void __init acpi_ssdt_customized(void);
+#else
+static inline void acpi_ssdt_customized(void) {}
+#endif
 
 extern bool acpi_force_hot_remove;
 
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 9aeae41..c6024c2 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1770,15 +1770,13 @@ acpi_status acpi_os_release_object(acpi_cache_t * cache, void *object)
 }
 #endif
 
-static int __init acpi_no_static_ssdt_setup(char *s)
+#ifdef CONFIG_ACPI_CUSTOM_DSDT_WITH_SSDT
+void __init acpi_ssdt_customized(void)
 {
 	acpi_gbl_disable_ssdt_table_install = TRUE;
 	pr_info("ACPI: static SSDT installation disabled\n");
-
-	return 0;
 }
-
-early_param("acpi_no_static_ssdt", acpi_no_static_ssdt_setup);
+#endif
 
 static int __init acpi_disable_return_repair(char *s)
 {
diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index 2178229..aaf2177 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -184,6 +184,7 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
 	}
 }
 
+#include "internal.h"
 
 int __init
 acpi_table_parse_entries(char *id,
@@ -333,6 +334,7 @@ int __init acpi_table_init(void)
 {
 	acpi_status status;
 
+	acpi_ssdt_customized();
 	status = acpi_initialize_tables(initial_tables, ACPI_MAX_TABLES, 0);
 	if (ACPI_FAILURE(status))
 		return -EINVAL;
-- 
1.7.10

