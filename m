Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3FEAxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 20:53:04 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39072 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3FEAxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 20:53:00 -0400
Message-ID: <51AE8BE4.8050409@oracle.com>
Date: Wed, 05 Jun 2013 08:52:52 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
CC: Neil Gu <qing.gu@oracle.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI: update user_policy.max when _PPC updated
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When _PPC changed dynamically the user_policy.max will not be updated,
this prevent CPU run on the highest frequency.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/acpi/processor_perflib.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index e854582..e01aa7d 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -180,6 +180,7 @@ static void acpi_processor_ppc_ost(acpi_handle handle, int status)
 int acpi_processor_ppc_has_changed(struct acpi_processor *pr, int event_flag)
 {
 	int ret;
+	unsigned int saved = (unsigned int)pr->performance_platform_limit;
 
 	if (ignore_ppc) {
 		/*
@@ -204,8 +205,22 @@ int acpi_processor_ppc_has_changed(struct acpi_processor *pr, int event_flag)
 	}
 	if (ret < 0)
 		return (ret);
-	else
+	else {
+		unsigned int ppc = (unsigned int)pr->performance_platform_limit;
+
+		if (saved != ppc) {
+			struct cpufreq_policy *policy;
+
+			policy = cpufreq_cpu_get(pr->id);
+			if (likely(policy))
+				policy->user_policy.max =
+					pr->performance->states[ppc].
+					core_frequency * 1000;
+			cpufreq_cpu_put(policy);
+		}
+
 		return cpufreq_update_policy(pr->id);
+	}
 }
 
 int acpi_processor_get_bios_limit(int cpu, unsigned int *limit)
-- 
1.8.1.4

