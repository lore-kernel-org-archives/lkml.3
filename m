Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaA1D5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 22:57:42 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:57564 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbaA1D5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 22:57:41 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH] acpi-cpufreq: De-register cpu notifier and free struct msr on error.
Date: Mon, 27 Jan 2014 22:58:11 -0500
Message-Id: <1390881491-18998-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If cpufreq_register_driver() fails we would free the acpi driver
related structures but not free the ones allocated
by acpi_cpufreq_boost_init() function. This meant that as
the driver error-ed out and a CPU online/offline event came
we would crash and burn as one of the CPU notifiers would point
to garbage.

This fixes a regression that commit cfc9c8ed03e4d908f2388af8815f44c87b503aaf
"acpi-cpufreq: Adjust the code to use the common boost attribute"
introduced.

CC: Lukasz Majewski <l.majewski@samsung.com>
CC: Myungjoo Ham <myungjoo.ham@samsung.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>
CC: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/cpufreq/acpi-cpufreq.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 79e5608..3e856d6 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -969,9 +969,10 @@ static int __init acpi_cpufreq_init(void)
 	acpi_cpufreq_boost_init();
 
 	ret = cpufreq_register_driver(&acpi_cpufreq_driver);
-	if (ret)
+	if (ret) {
 		free_acpi_perf_data();
-
+		acpi_cpufreq_boost_exit();
+	}
 	return ret;
 }
 
-- 
1.7.7.6

