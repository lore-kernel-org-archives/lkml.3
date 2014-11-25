Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbaKYFAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 00:00:32 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24499 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaKYFAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 00:00:30 -0500
From: Ethan Zhao <ethan.zhao@oracle.com>
To: linda.knippers@hp.com, viresh.kumar@linaro.org, rjw@rjwysocki.net,
        corbet@lwn.net, dirk.j.brandewie@intel.com
Cc: linux-doc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ethan.kernel@gmail.com,
        Ethan Zhao <ethan.zhao@oracle.com>
Subject: [PATCH 1/2 v3] intel_pstate: skip this driver if Sun server has _PPC method
Date: Tue, 25 Nov 2014 13:59:37 +0900
Message-Id: <1416891578-14171-2-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416891578-14171-1-git-send-email-ethan.zhao@oracle.com>
References: <1416891578-14171-1-git-send-email-ethan.zhao@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oracle Sun X86 servers have dynamic power capping capability that works via
ACPI _PPC method etc, so skip loading this driver if Sun server has ACPI _PPC
enabled.

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
---
 v2: fix break HP Proliant issue.
 v3: expand the hardware vendor list.

 drivers/cpufreq/intel_pstate.c | 45 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 27bb6d3..fa67fb3 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -943,6 +943,21 @@ static bool intel_pstate_no_acpi_pss(void)
 	return true;
 }
 
+static bool intel_pstate_has_acpi_ppc(void)
+{
+	int i;
+
+	for_each_possible_cpu(i) {
+		struct acpi_processor *pr = per_cpu(processors, i);
+
+		if (!pr)
+			continue;
+		if (acpi_has_method(pr->handle, "_PPC"))
+			return true;
+	}
+	return false;
+}
+
 struct hw_vendor_info {
 	u16  valid;
 	char oem_id[ACPI_OEM_ID_SIZE];
@@ -950,11 +965,26 @@ struct hw_vendor_info {
 };
 
 /* Hardware vendor-specific info that has its own power management modes */
-static struct hw_vendor_info vendor_info[] = {
+static struct hw_vendor_info hp_vendor_info[] = {
 	{1, "HP    ", "ProLiant"},
 	{0, "", ""},
 };
 
+/* The list of Oracle Sun server that has power capping capability */
+static struct hw_vendor_info ora_vendor_info[] = {
+	{1, "ORACLE", "X4-2    "},
+	{1, "ORACLE", "X4-2L   "},
+	{1, "ORACLE", "X4-2B   "},
+	{1, "ORACLE", "X3-2    "},
+	{1, "ORACLE", "X3-2L   "},
+	{1, "ORACLE", "X3-2B   "},
+	{1, "ORACLE", "X4470M2 "},
+	{1, "ORACLE", "X4270M3 "},
+	{1, "ORACLE", "X4270M2 "},
+	{1, "ORACLE", "X4170M2 "},
+	{0, "", ""},
+};
+
 static bool intel_pstate_platform_pwr_mgmt_exists(void)
 {
 	struct acpi_table_header hdr;
@@ -963,18 +993,27 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
 	if (acpi_disabled ||
 	    ACPI_FAILURE(acpi_get_table_header(ACPI_SIG_FADT, 0, &hdr)))
 		return false;
-
-	for (v_info = vendor_info; v_info->valid; v_info++) {
+	/* Check HP devices */
+	for (v_info = hp_vendor_info; v_info->valid; v_info++) {
 		if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
 		    !strncmp(hdr.oem_table_id, v_info->oem_table_id, ACPI_OEM_TABLE_ID_SIZE) &&
 		    intel_pstate_no_acpi_pss())
 			return true;
 	}
+	/* Check Oracle Sun X86 servers */
+	for (v_info = ora_vendor_info; v_info->valid; v_info++) {
+		if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
+			!strncmp(hdr.oem_table_id, v_info->oem_table_id,
+				ACPI_OEM_TABLE_ID_SIZE) &&
+			intel_pstate_has_acpi_ppc())
+			return true;
+	}
 
 	return false;
 }
 #else /* CONFIG_ACPI not enabled */
 static inline bool intel_pstate_platform_pwr_mgmt_exists(void) { return false; }
+static inline bool intel_pstate_has_acpi_ppc(void) { return false; }
 #endif /* CONFIG_ACPI */
 
 static int __init intel_pstate_init(void)
-- 
1.8.3.1

