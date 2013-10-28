Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab3J1BI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 21:08:56 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54181 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754139Ab3J1BIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 21:08:55 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] ACPI / processor: Do not request ACPI cpufreq module directly
Date: Mon, 28 Oct 2013 02:21 +0100
Message-ID: <2252332.6pcuA4s7xa@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Function acpi_processor_load_module() used by the ACPI processor
driver can only really work if the acpi-cpufreq module is available
when acpi_processor_start() is executed which usually is not the case
for systems loading the processor driver module from an initramfs.

Moreover, that used to be a hackish workaround for module autoloading
issues, but udev loads acpi-cpufreq just fine nowadays, so that
function isn't really necessary any more.  For this reason, drop
acpi_processor_load_module() entirely.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/processor_driver.c  |    1 -
 drivers/acpi/processor_perflib.c |   22 ----------------------
 include/acpi/processor.h         |    1 -
 3 files changed, 24 deletions(-)

Index: linux-pm/drivers/acpi/processor_driver.c
===================================================================
--- linux-pm.orig/drivers/acpi/processor_driver.c
+++ linux-pm/drivers/acpi/processor_driver.c
@@ -171,7 +171,6 @@ static int __acpi_processor_start(struct
 
 #ifdef CONFIG_CPU_FREQ
 	acpi_processor_ppc_has_changed(pr, 0);
-	acpi_processor_load_module(pr);
 #endif
 	acpi_processor_get_throttling_info(pr);
 
Index: linux-pm/drivers/acpi/processor_perflib.c
===================================================================
--- linux-pm.orig/drivers/acpi/processor_perflib.c
+++ linux-pm/drivers/acpi/processor_perflib.c
@@ -235,28 +235,6 @@ void acpi_processor_ppc_exit(void)
 	acpi_processor_ppc_status &= ~PPC_REGISTERED;
 }
 
-/*
- * Do a quick check if the systems looks like it should use ACPI
- * cpufreq. We look at a _PCT method being available, but don't
- * do a whole lot of sanity checks.
- */
-void acpi_processor_load_module(struct acpi_processor *pr)
-{
-	static int requested;
-	acpi_status status = 0;
-	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
-
-	if (!arch_has_acpi_pdc() || requested)
-		return;
-	status = acpi_evaluate_object(pr->handle, "_PCT", NULL, &buffer);
-	if (!ACPI_FAILURE(status)) {
-		printk(KERN_INFO PREFIX "Requesting acpi_cpufreq\n");
-		request_module_nowait("acpi_cpufreq");
-		requested = 1;
-	}
-	kfree(buffer.pointer);
-}
-
 static int acpi_processor_get_performance_control(struct acpi_processor *pr)
 {
 	int result = 0;
Index: linux-pm/include/acpi/processor.h
===================================================================
--- linux-pm.orig/include/acpi/processor.h
+++ linux-pm/include/acpi/processor.h
@@ -225,7 +225,6 @@ struct acpi_processor_errata {
 	} piix4;
 };
 
-extern void acpi_processor_load_module(struct acpi_processor *pr);
 extern int acpi_processor_preregister_performance(struct
 						  acpi_processor_performance
 						  __percpu *performance);

