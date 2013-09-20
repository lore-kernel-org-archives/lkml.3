Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3ITRoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 13:44:13 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49961 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab3ITRoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 13:44:10 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2] cpufreq: skip loading acpi_cpufreq after intel_pstate
Date: Fri, 20 Sep 2013 10:43:56 -0700
Message-Id: <1379699036-7380-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the hw support intel_pstate and acpi_cpufreq, intel_pstate will
get loaded first.

acpi_cpufreq_init will call acpi_cpufreq_early_init()
and that will allocate perf data and init those perf data in ACPI core,
(that will cover all cpus). But later it will free them as
cpufreq_register_driver(acpi_cpufreq) will fail as init_pstate is
already registered

Use cpufreq_get_current_driver() to check if we can skip the
acpi_cpufreq loading.

-v2: update changelog and separate second part to another patch, according
     to Viresh.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/cpufreq/acpi-cpufreq.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/drivers/cpufreq/acpi-cpufreq.c
===================================================================
--- linux-2.6.orig/drivers/cpufreq/acpi-cpufreq.c
+++ linux-2.6/drivers/cpufreq/acpi-cpufreq.c
@@ -986,6 +986,10 @@ static int __init acpi_cpufreq_init(void
 {
 	int ret;
 
+	/* don't keep reloading if cpufreq_driver exists */
+	if (cpufreq_get_current_driver())
+		return 0;
+
 	if (acpi_disabled)
 		return 0;
 
