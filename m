Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503AbaLKBdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:33:54 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50589 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933440AbaLKBdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:33:53 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lv Zheng <lv.zheng@intel.com>,
        Venkat Raghavulu <venkat.raghavulu@intel.com>
Subject: [PATCH] ACPI / PM: Do not disable wakeup GPEs that have not been enabled
Date: Thu, 11 Dec 2014 02:55:26 +0100
Message-ID: <1890951.o2PAmqguxi@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

In some cases acpi_device_wakeup() may be called to ensure wakeup
power to be off for a given device even though that device's wakeup
GPE has not been enabled so far.  It calls acpi_disable_gpe() on a
GPE that's not enabled and this causes ACPICA to return the AE_LIMIT
status code from that call which then is reported as an error by the
ACPICA's debug facilities (if enabled).  This may lead to a fair
amount of confusion, so introduce a new ACPI device wakeup flag
to store the wakeup GPE status and avoid disabling wakeup GPEs
that have not been enabled.

Reported-and-tested-by: Venkat Raghavulu <venkat.raghavulu@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |   12 ++++++++++--
 include/acpi/acpi_bus.h  |    1 +
 2 files changed, 11 insertions(+), 2 deletions(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -313,6 +313,7 @@ struct acpi_device_wakeup_flags {
 	u8 valid:1;		/* Can successfully enable wakeup? */
 	u8 run_wake:1;		/* Run-Wake GPE devices */
 	u8 notifier_present:1;  /* Wake-up notify handler has been installed */
+	u8 enabled:1;		/* Enabled for wakeup */
 };
 
 struct acpi_device_wakeup_context {
Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -680,13 +680,21 @@ static int acpi_device_wakeup(struct acp
 		if (error)
 			return error;
 
+		if (adev->wakeup.flags.enabled)
+			return 0;
+
 		res = acpi_enable_gpe(wakeup->gpe_device, wakeup->gpe_number);
-		if (ACPI_FAILURE(res)) {
+		if (ACPI_SUCCESS(res)) {
+			adev->wakeup.flags.enabled = 1;
+		} else {
 			acpi_disable_wakeup_device_power(adev);
 			return -EIO;
 		}
 	} else {
-		acpi_disable_gpe(wakeup->gpe_device, wakeup->gpe_number);
+		if (adev->wakeup.flags.enabled) {
+			acpi_disable_gpe(wakeup->gpe_device, wakeup->gpe_number);
+			adev->wakeup.flags.enabled = 0;
+		}
 		acpi_disable_wakeup_device_power(adev);
 	}
 	return 0;

