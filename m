Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780Ab3FCTsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:48:09 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54055 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759756Ab3FCTsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:48:04 -0400
Message-ID: <51ACF2F1.1050600@semaphore.gr>
Date: Mon, 03 Jun 2013 22:48:01 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] cpufreq: Remove unused function __cpufreq_driver_getavg
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calculation of frequency target in ondemand governor changed and it is
independent from measured average frequency.

Remove unused__cpufreq_driver_getavg function and getavg member from
cpufreq_driver struct. Also, remove the callback getavg in
acpi_cpufreq_driver.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/Makefile       |  2 +-
 drivers/cpufreq/acpi-cpufreq.c |  5 -----
 drivers/cpufreq/cpufreq.c      | 12 ------------
 include/linux/cpufreq.h        |  6 ------
 4 files changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 6ad0b91..aebd4ef 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -23,7 +23,7 @@ obj-$(CONFIG_GENERIC_CPUFREQ_CPU0)	+= cpufreq-cpu0.o
 # powernow-k8 can load then. ACPI is preferred to all other hardware-specific drivers.
 # speedstep-* is preferred over p4-clockmod.
 
-obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o mperf.o
+obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o
 obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o
 obj-$(CONFIG_X86_PCC_CPUFREQ)		+= pcc-cpufreq.o
 obj-$(CONFIG_X86_POWERNOW_K6)		+= powernow-k6.o
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 17e3496..d3a5f35 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -45,7 +45,6 @@
 #include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/cpufeature.h>
-#include "mperf.h"
 
 MODULE_AUTHOR("Paul Diefenbaugh, Dominik Brodowski");
 MODULE_DESCRIPTION("ACPI Processor P-States Driver");
@@ -842,10 +841,6 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	/* notify BIOS that we exist */
 	acpi_processor_notify_smm(THIS_MODULE);
 
-	/* Check for APERF/MPERF support in hardware */
-	if (boot_cpu_has(X86_FEATURE_APERFMPERF))
-		acpi_cpufreq_driver.getavg = cpufreq_get_measured_perf;
-
 	pr_debug("CPU%u - ACPI performance management activated.\n", cpu);
 	for (i = 0; i < perf->state_count; i++)
 		pr_debug("     %cP%d: %d MHz, %d mW, %d uS\n",
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index f8c2860..a61aacb 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1584,18 +1584,6 @@ fail:
 }
 EXPORT_SYMBOL_GPL(cpufreq_driver_target);
 
-int __cpufreq_driver_getavg(struct cpufreq_policy *policy, unsigned int cpu)
-{
-	if (cpufreq_disabled())
-		return 0;
-
-	if (!cpufreq_driver->getavg)
-		return 0;
-
-	return cpufreq_driver->getavg(policy, cpu);
-}
-EXPORT_SYMBOL_GPL(__cpufreq_driver_getavg);
-
 /*
  * when "event" is CPUFREQ_GOV_LIMITS
  */
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index d939056..50f19ad 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -215,10 +215,6 @@ extern int __cpufreq_driver_target(struct cpufreq_policy *policy,
 				   unsigned int target_freq,
 				   unsigned int relation);
 
-
-extern int __cpufreq_driver_getavg(struct cpufreq_policy *policy,
-				   unsigned int cpu);
-
 int cpufreq_register_governor(struct cpufreq_governor *governor);
 void cpufreq_unregister_governor(struct cpufreq_governor *governor);
 
@@ -258,8 +254,6 @@ struct cpufreq_driver {
 	unsigned int	(*get)	(unsigned int cpu);
 
 	/* optional */
-	unsigned int (*getavg)	(struct cpufreq_policy *policy,
-				 unsigned int cpu);
 	int	(*bios_limit)	(int cpu, unsigned int *limit);
 
 	int	(*exit)		(struct cpufreq_policy *policy);
-- 
1.8.1.4

