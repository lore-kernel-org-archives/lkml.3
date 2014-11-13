Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaKMSwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:52:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbaKMSwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:52:01 -0500
From: Lenny Szubowicz <lszubowi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        Joseph.Szczypek@hp.com, lszubowi@redhat.com
Subject: [PATCH] cpufreq: pcc: Enable autoload of pcc-cpufreq for ACPI processors
Date: Thu, 13 Nov 2014 13:51:52 -0500
Message-Id: <1415904712-12521-1-git-send-email-lszubowi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pcc-cpufreq driver is not automatically loaded on systems where
the platform's power management setting requires this driver.
Instead, on those systems no CPU frequency driver is registered and
active.

Make the autoloading matching criteria for loading the pcc-cpufreq
driver the same as done in acpi-cpufreq by commit c655affbd524d01
("ACPI / cpufreq: Add ACPI processor device IDs to acpi-cpufreq").

x86 CPU frequency drivers are now typically autoloaded by specifying
MODULE_DEVICE_TABLE entries and x86cpu model specific matching.
But pcc-cpufreq was omitted when acpi-cpufreq and other drivers were
changed to use this approach.

Both acpi-cpufreq and pcc-cpufreq depend on a distinct and mutually
exclusive set of ACPI methods which are not directly tied to specific
processor model numbers. Both of these drivers have init routines
which look for their required ACPI methods. As a result, only the
appropriate driver registers as the cpu frequency driver and the other
one ends up being unloaded.

Tested on various systems where acpi-cpufreq, intel_pstate, and
pcc-cpufreq are the expected cpu frequency drivers.

Signed-off-by: Lenny Szubowicz <lszubowi@redhat.com>
Signed-off-by: Joseph Szczypek <joseph.szczypek@hp.com>
Reported-by: Trinh Dao <trinh.dao@hp.com>
---
 drivers/cpufreq/pcc-cpufreq.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/cpufreq/pcc-cpufreq.c b/drivers/cpufreq/pcc-cpufreq.c
index 4d2c8e8..2a0d589 100644
--- a/drivers/cpufreq/pcc-cpufreq.c
+++ b/drivers/cpufreq/pcc-cpufreq.c
@@ -603,6 +603,13 @@ static void __exit pcc_cpufreq_exit(void)
 	free_percpu(pcc_cpu_info);
 }
 
+static const struct acpi_device_id processor_device_ids[] = {
+	{ACPI_PROCESSOR_OBJECT_HID, },
+	{ACPI_PROCESSOR_DEVICE_HID, },
+	{},
+};
+MODULE_DEVICE_TABLE(acpi, processor_device_ids);
+
 MODULE_AUTHOR("Matthew Garrett, Naga Chumbalkar");
 MODULE_VERSION(PCC_VERSION);
 MODULE_DESCRIPTION("Processor Clocking Control interface driver");
-- 
1.8.3.1

