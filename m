Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbaKYO5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:57:08 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42100 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaKYO5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:57:05 -0500
From: Dirk Brandewie <dirk.brandewie@gmail.com>
X-Google-Original-From: Dirk Brandewie <dirk.j.brandewie@intel.com>
Message-ID: <547498BC.9020704@intel.com>
Date: Tue, 25 Nov 2014 06:57:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ethan Zhao <ethan.zhao@oracle.com>, linda.knippers@hp.com,
        viresh.kumar@linaro.org, rjw@rjwysocki.net, corbet@lwn.net
CC: dirk.j.brandewie@intel.com, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ethan.kernel@gmail.com
Subject: Re: [PATCH 1/2 v3] intel_pstate: skip this driver if Sun server has
 _PPC method
References: <1416891578-14171-1-git-send-email-ethan.zhao@oracle.com> <1416891578-14171-2-git-send-email-ethan.zhao@oracle.com>
In-Reply-To: <1416891578-14171-2-git-send-email-ethan.zhao@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 08:59 PM, Ethan Zhao wrote:
> Oracle Sun X86 servers have dynamic power capping capability that works via
> ACPI _PPC method etc, so skip loading this driver if Sun server has ACPI _PPC
> enabled.
>

How about this patch? only compile tested.

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 3468387..db7b8b2 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1025,15 +1025,46 @@ static bool intel_pstate_no_acpi_pss(void)
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
+enum {
+	PSS,
+	PCC,
+};
+
  struct hw_vendor_info {
  	u16  valid;
  	char oem_id[ACPI_OEM_ID_SIZE];
  	char oem_table_id[ACPI_OEM_TABLE_ID_SIZE];
+	int  oem_pwr_table;
  };

  /* Hardware vendor-specific info that has its own power management modes */
  static struct hw_vendor_info vendor_info[] = {
-	{1, "HP    ", "ProLiant"},
+	{1, "HP    ", "ProLiant", PSS},
+	{1, "ORACLE", "X4-2    ", PCC},
+	{1, "ORACLE", "X4-2L   ", PCC},
+	{1, "ORACLE", "X4-2B   ", PCC},
+	{1, "ORACLE", "X3-2    ", PCC},
+	{1, "ORACLE", "X3-2L   ", PCC},
+	{1, "ORACLE", "X3-2B   ", PCC},
+	{1, "ORACLE", "X4470M2 ", PCC},
+	{1, "ORACLE", "X4270M3 ", PCC},
+	{1, "ORACLE", "X4270M2 ", PCC},
+	{1, "ORACLE", "X4170M2 ", PCC},
  	{0, "", ""},
  };

@@ -1057,15 +1088,20 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)

  	for (v_info = vendor_info; v_info->valid; v_info++) {
  		if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
-		    !strncmp(hdr.oem_table_id, v_info->oem_table_id, ACPI_OEM_TABLE_ID_SIZE) &&
-		    intel_pstate_no_acpi_pss())
-			return true;
+		    !strncmp(hdr.oem_table_id, v_info->oem_table_id, ACPI_OEM_TABLE_ID_SIZE))
+			switch (v_info->oem_pwr_table) {
+			case PSS:
+				return intel_pstate_no_acpi_pss();
+			case PCC:
+				return intel_pstate_has_acpi_ppc();
+			}
  	}

  	return false;
  }
  #else /* CONFIG_ACPI not enabled */
  static inline bool intel_pstate_platform_pwr_mgmt_exists(void) { return false; }
+static inline bool intel_pstate_has_acpi_ppc(void) { return false; }
  #endif /* CONFIG_ACPI */

  static int __init intel_pstate_init(void)


