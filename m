Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbaD3CGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:06:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:36761 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756883AbaD3CGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:06:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="532135394"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 21/27] ACPICA: acpidump: Add support to force using RSDT.
Date: Wed, 30 Apr 2014 10:05:48 +0800
Message-Id: <a947d03abc49bdd4493fbfaf9226ded7ea7a7996.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds "-x" and "-x -x" options to disable XSDT for acpidump.

The single "-x" can be used to stop using XSDT, RSDT will be forced to find
static tables, note that XSDT will still be dumped. The double "-x" can
stop dumping XSDT, which is useful when the XSDT address reported by RSDP
is pointing to an invalid address.

It is reported there are platforms having broken XSDT shipped, acpidump
will stop working while accessing such XSDT. This patch adds new option so
that users can force acpidump to dump tables listed in the RSDT. Lv Zheng.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=73911
Buglink: https://bugs.archlinux.org/task/39811
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Reported-and-tested-by: Bruce Chiarelli <mano155@gmail.com>
Reported-and-tested-by: Spyros Stathopoulos <spystath@gmail.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
---
 .../acpi/os_specific/service_layers/oslinuxtbl.c   |   32 +++++++++++++++++---
 tools/power/acpi/tools/acpidump/acpidump.h         |   23 +++++++-------
 tools/power/acpi/tools/acpidump/apmain.c           |   13 +++++++-
 3 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c b/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c
index a8cd344..e0699e6 100644
--- a/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c
+++ b/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c
@@ -505,6 +505,28 @@ static acpi_status osl_load_rsdp(void)
 
 /******************************************************************************
  *
+ * FUNCTION:    osl_can_use_xsdt
+ *
+ * PARAMETERS:  None
+ *
+ * RETURN:      TRUE if XSDT is allowed to be used.
+ *
+ * DESCRIPTION: This function collects logic that can be used to determine if
+ *              XSDT should be used instead of RSDT.
+ *
+ *****************************************************************************/
+
+static u8 osl_can_use_xsdt(void)
+{
+	if (gbl_revision && !acpi_gbl_do_not_use_xsdt) {
+		return (TRUE);
+	} else {
+		return (FALSE);
+	}
+}
+
+/******************************************************************************
+ *
  * FUNCTION:    osl_table_initialize
  *
  * PARAMETERS:  None
@@ -535,7 +557,7 @@ static acpi_status osl_table_initialize(void)
 
 	/* Get XSDT from memory */
 
-	if (gbl_rsdp.revision) {
+	if (gbl_rsdp.revision && !gbl_do_not_dump_xsdt) {
 		if (gbl_xsdt) {
 			free(gbl_xsdt);
 			gbl_xsdt = NULL;
@@ -668,7 +690,7 @@ static acpi_status osl_list_bios_tables(void)
 	acpi_status status = AE_OK;
 	u32 i;
 
-	if (gbl_revision) {
+	if (osl_can_use_xsdt()) {
 		item_size = sizeof(u64);
 		table_data =
 		    ACPI_CAST8(gbl_xsdt) + sizeof(struct acpi_table_header);
@@ -690,7 +712,7 @@ static acpi_status osl_list_bios_tables(void)
 	/* Search RSDT/XSDT for the requested table */
 
 	for (i = 0; i < number_of_tables; ++i, table_data += item_size) {
-		if (gbl_revision) {
+		if (osl_can_use_xsdt()) {
 			table_address =
 			    (acpi_physical_address) (*ACPI_CAST64(table_data));
 		} else {
@@ -809,7 +831,7 @@ osl_get_bios_table(char *signature,
 		table_length = ap_get_table_length(mapped_table);
 	} else {		/* Case for a normal ACPI table */
 
-		if (gbl_revision) {
+		if (osl_can_use_xsdt()) {
 			item_size = sizeof(u64);
 			table_data =
 			    ACPI_CAST8(gbl_xsdt) +
@@ -833,7 +855,7 @@ osl_get_bios_table(char *signature,
 		/* Search RSDT/XSDT for the requested table */
 
 		for (i = 0; i < number_of_tables; ++i, table_data += item_size) {
-			if (gbl_revision) {
+			if (osl_can_use_xsdt()) {
 				table_address =
 				    (acpi_physical_address) (*ACPI_CAST64
 							     (table_data));
diff --git a/tools/power/acpi/tools/acpidump/acpidump.h b/tools/power/acpi/tools/acpidump/acpidump.h
index 3361b9e..46f5195 100644
--- a/tools/power/acpi/tools/acpidump/acpidump.h
+++ b/tools/power/acpi/tools/acpidump/acpidump.h
@@ -41,32 +41,34 @@
  * POSSIBILITY OF SUCH DAMAGES.
  */
 
-#include <acpi/acpi.h>
-#include "accommon.h"
-#include "actables.h"
-
-#include <stdio.h>
-#include <fcntl.h>
-#include <errno.h>
-#include <sys/stat.h>
-
 /*
  * Global variables. Defined in main.c only, externed in all other files
  */
 #ifdef _DECLARE_GLOBALS
 #define EXTERN
 #define INIT_GLOBAL(a,b)        a=b
+#define DEFINE_ACPI_GLOBALS     1
 #else
 #define EXTERN                  extern
 #define INIT_GLOBAL(a,b)        a
 #endif
 
+#include <acpi/acpi.h>
+#include "accommon.h"
+#include "actables.h"
+
+#include <stdio.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/stat.h>
+
 /* Globals */
 
 EXTERN u8 INIT_GLOBAL(gbl_summary_mode, FALSE);
 EXTERN u8 INIT_GLOBAL(gbl_verbose_mode, FALSE);
 EXTERN u8 INIT_GLOBAL(gbl_binary_mode, FALSE);
 EXTERN u8 INIT_GLOBAL(gbl_dump_customized_tables, FALSE);
+EXTERN u8 INIT_GLOBAL(gbl_do_not_dump_xsdt, FALSE);
 EXTERN FILE INIT_GLOBAL(*gbl_output_file, NULL);
 EXTERN char INIT_GLOBAL(*gbl_output_filename, NULL);
 EXTERN u64 INIT_GLOBAL(gbl_rsdp_base, 0);
@@ -74,10 +76,7 @@ EXTERN u64 INIT_GLOBAL(gbl_rsdp_base, 0);
 /* Globals required for use with ACPICA modules */
 
 #ifdef _DECLARE_GLOBALS
-u8 acpi_gbl_enable_interpreter_slack = FALSE;
 u8 acpi_gbl_integer_byte_width = 8;
-u32 acpi_dbg_level = 0;
-u32 acpi_dbg_layer = 0;
 #endif
 
 /* Action table used to defer requested options */
diff --git a/tools/power/acpi/tools/acpidump/apmain.c b/tools/power/acpi/tools/acpidump/apmain.c
index 70d71ec..51e8d63 100644
--- a/tools/power/acpi/tools/acpidump/apmain.c
+++ b/tools/power/acpi/tools/acpidump/apmain.c
@@ -80,7 +80,7 @@ struct ap_dump_action action_table[AP_MAX_ACTIONS];
 u32 current_action = 0;
 
 #define AP_UTILITY_NAME             "ACPI Binary Table Dump Utility"
-#define AP_SUPPORTED_OPTIONS        "?a:bcf:hn:o:r:svz"
+#define AP_SUPPORTED_OPTIONS        "?a:bcf:hn:o:r:svxz"
 
 /******************************************************************************
  *
@@ -109,6 +109,8 @@ static void ap_display_usage(void)
 	ACPI_OPTION("-a <Address>", "Get table via a physical address");
 	ACPI_OPTION("-f <BinaryFile>", "Get table via a binary file");
 	ACPI_OPTION("-n <Signature>", "Get table via a name/signature");
+	ACPI_OPTION("-x", "Do not use but dump XSDT");
+	ACPI_OPTION("-x -x", "Do not use or dump XSDT");
 
 	printf("\n"
 	       "Invocation without parameters dumps all available tables\n"
@@ -210,6 +212,15 @@ static int ap_do_options(int argc, char **argv)
 			gbl_summary_mode = TRUE;
 			continue;
 
+		case 'x':	/* Do not use XSDT */
+
+			if (!acpi_gbl_do_not_use_xsdt) {
+				acpi_gbl_do_not_use_xsdt = TRUE;
+			} else {
+				gbl_do_not_dump_xsdt = TRUE;
+			}
+			continue;
+
 		case 'v':	/* Revision/version */
 
 			printf(ACPI_COMMON_SIGNON(AP_UTILITY_NAME));
-- 
1.7.10

