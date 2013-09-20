Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab3ITRoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 13:44:19 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30136 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab3ITRoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 13:44:15 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2] cpufreq: fix racing between acpi_cpufreq_loading
Date: Fri, 20 Sep 2013 10:44:03 -0700
Message-Id: <1379699043-7414-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is racing in
	__acpi_processor_start
		 ==> acpi_processor_load_module
			 ==> request_module_nowait/requested = 1
before first pr path to have requested set, second cpu would request again.
that will cause acpi_cpufreq_early_init to be called in parallel,
that will cause data curruption in acpi_cpufreq_early_init...
and intermittent crash.

So add mutex to protect it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/acpi/processor_perflib.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/acpi/processor_perflib.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_perflib.c
+++ linux-2.6/drivers/acpi/processor_perflib.c
@@ -235,6 +235,7 @@ void acpi_processor_ppc_exit(void)
 	acpi_processor_ppc_status &= ~PPC_REGISTERED;
 }
 
+static DEFINE_MUTEX(acpi_cpufreq_load_lock);
 /*
  * Do a quick check if the systems looks like it should use ACPI
  * cpufreq. We look at a _PCT method being available, but don't
@@ -246,8 +247,12 @@ void acpi_processor_load_module(struct a
 	acpi_status status = 0;
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 
-	if (!arch_has_acpi_pdc() || requested)
+	mutex_lock(&acpi_cpufreq_load_lock);
+	if (!arch_has_acpi_pdc() || requested) {
+		mutex_unlock(&acpi_cpufreq_load_lock);
 		return;
+	}
+
 	status = acpi_evaluate_object(pr->handle, "_PCT", NULL, &buffer);
 	if (!ACPI_FAILURE(status)) {
 		printk(KERN_INFO PREFIX "Requesting acpi_cpufreq\n");
@@ -255,6 +260,7 @@ void acpi_processor_load_module(struct a
 		requested = 1;
 	}
 	kfree(buffer.pointer);
+	mutex_unlock(&acpi_cpufreq_load_lock);
 }
 
 static int acpi_processor_get_performance_control(struct acpi_processor *pr)
