Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaKRIhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:37:47 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42788 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbaKRIhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:37:39 -0500
From: Ethan Zhao <ethan.zhao@oracle.com>
To: dirk.j.brandewie@intel.com, viresh.kumar@linaro.org, rjw@rjwysocki.net,
        corbet@lwn.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, ethan.kernel@gmail.com, joe.jin@oracle.com,
        brian.maly@oracle.com, Ethan Zhao <ethan.zhao@oracle.com>
Subject: [PATCH 3/3] intel_pstate: add module and kernel command line parameter to ignore ACPI _PPC
Date: Tue, 18 Nov 2014 17:37:02 +0900
Message-Id: <1416299826-15813-4-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416299826-15813-1-git-send-email-ethan.zhao@oracle.com>
References: <1416299826-15813-1-git-send-email-ethan.zhao@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kernel command line parameter
 intel_pstate = ignore_acpi_ppc
and module parameter
 ignore_acpi_ppc = 1
to allow driver to ignore the ACPI _PPC existence even for Sun x86 servers.
These parameter could be used for debug\test\workaround etc purpose.

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
---
 Documentation/kernel-parameters.txt | 3 +++
 drivers/cpufreq/intel_pstate.c      | 8 +++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4c81a86..f502b85 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1446,6 +1446,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 		       disable
 		         Do not enable intel_pstate as the default
 		         scaling driver for the supported processors
+		       ignore_acpi_ppc
+			 Ignore the existence of ACPI method _PPC for Sun x86 servers
+			 and load the driver.
 
 	intremap=	[X86-64, Intel-IOMMU]
 			on	enable Interrupt Remapping (default)
diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 7c5faea..388387b 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -870,6 +870,7 @@ static struct cpufreq_driver intel_pstate_driver = {
 };
 
 static int __initdata no_load;
+static unsigned int  ignore_acpi_ppc;
 
 static int intel_pstate_msrs_not_valid(void)
 {
@@ -990,7 +991,7 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
 		    intel_pstate_no_acpi_pss())
 			return true;
 		if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
-			intel_pstate_has_acpi_ppc())
+			intel_pstate_has_acpi_ppc() && !ignore_acpi_ppc)
 			return true;
 	}
 
@@ -1066,11 +1067,16 @@ static int __init intel_pstate_setup(char *str)
 
 	if (!strcmp(str, "disable"))
 		no_load = 1;
+	if (!strcmp(str, "ignore_acpi_ppc"))
+		ignore_acpi_ppc = 1;
 	return 0;
 }
 early_param("intel_pstate", intel_pstate_setup);
 #endif
 
+module_param(ignore_acpi_ppc, uint, 0644);
+MODULE_PARM_DESC(ignore_acpi_ppc,
+	"value 0 or non-zero. non-zero -> ignore ACPI _PPC and load this driver");
 MODULE_AUTHOR("Dirk Brandewie <dirk.j.brandewie@intel.com>");
 MODULE_DESCRIPTION("'intel_pstate' - P state driver Intel Core processors");
 MODULE_LICENSE("GPL");
-- 
1.8.3.1

