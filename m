Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaKRIjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:39:42 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37452 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbaKRIho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:37:44 -0500
From: Ethan Zhao <ethan.zhao@oracle.com>
To: dirk.j.brandewie@intel.com, viresh.kumar@linaro.org, rjw@rjwysocki.net,
        corbet@lwn.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, ethan.kernel@gmail.com, joe.jin@oracle.com,
        brian.maly@oracle.com, Ethan Zhao <ethan.zhao@oracle.com>
Subject: [PATCH 1/3] intel_pstate: skip the driver if Sun server has ACPI _PPC method
Date: Tue, 18 Nov 2014 17:37:04 +0900
Message-Id: <1416299826-15813-6-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416299826-15813-1-git-send-email-ethan.zhao@oracle.com>
References: <1416299826-15813-1-git-send-email-ethan.zhao@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oracle Sun X86 servers have dynamic power capping capability that works via
ACPI _PPC method etc, so skip loading this driver if Sun server has ACPI _PPC
enabled.

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
---
 drivers/cpufreq/intel_pstate.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 27bb6d3..5498eb0 100644
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
@@ -952,6 +967,7 @@ struct hw_vendor_info {
 /* Hardware vendor-specific info that has its own power management modes */
 static struct hw_vendor_info vendor_info[] = {
 	{1, "HP    ", "ProLiant"},
+	{1, "ORACLE", ""},
 	{0, "", ""},
 };
 
@@ -969,12 +985,16 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
 		    !strncmp(hdr.oem_table_id, v_info->oem_table_id, ACPI_OEM_TABLE_ID_SIZE) &&
 		    intel_pstate_no_acpi_pss())
 			return true;
+		if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
+			intel_pstate_has_acpi_ppc())
+			return true;
 	}
 
 	return false;
 }
 #else /* CONFIG_ACPI not enabled */
 static inline bool intel_pstate_platform_pwr_mgmt_exists(void) { return false; }
+static inline bool intel_pstate_has_acpi_ppc(void) { return false; }
 #endif /* CONFIG_ACPI */
 
 static int __init intel_pstate_init(void)
-- 
1.8.3.1

