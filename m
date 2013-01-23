Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab3AWWIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 17:08:44 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:52470 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab3AWWIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 17:08:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] ACPI / PM: Fix consistency check for power resources during resume
Date: Wed, 23 Jan 2013 23:14:38 +0100
Message-ID: <3166070.HQQnvg38gp@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

During system resume we check if there are power resources that have
been turned off by the BIOS, but our reference counters for them
are nonzero (they need to be turned on then).  It turns out, however,
that we also need to check the opposite, i.e. if there are power
resources that have been turned on by the BIOS, but our reference
counters for them are zero (which means that no devices are going
to need them any time soon) and we should turn them off.

Make the power resources resume code do the additional check and
turn off the unused power resources as appropriate.

This change has been tested on HP nx6325.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

On top of linux-pm.git/linux-next.

Thanks,
Rafael

---
 drivers/acpi/power.c |   37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

Index: linux-pm/drivers/acpi/power.c
===================================================================
--- linux-pm.orig/drivers/acpi/power.c
+++ linux-pm/drivers/acpi/power.c
@@ -299,9 +299,22 @@ static int acpi_power_on(struct acpi_pow
 	return result;
 }
 
+static int __acpi_power_off(struct acpi_power_resource *resource)
+{
+	acpi_status status;
+
+	status = acpi_evaluate_object(resource->device.handle, "_OFF",
+				      NULL, NULL);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Power resource [%s] turned off\n",
+			  resource->name));
+	return 0;
+}
+
 static int acpi_power_off(struct acpi_power_resource *resource)
 {
-	acpi_status status = AE_OK;
 	int result = 0;
 
 	mutex_lock(&resource->resource_lock);
@@ -317,17 +330,12 @@ static int acpi_power_off(struct acpi_po
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "Power resource [%s] still in use\n",
 				  resource->name));
-		goto unlock;
+	} else {
+		result = __acpi_power_off(resource);
+		if (result)
+			resource->ref_count++;
 	}
 
-	status = acpi_evaluate_object(resource->device.handle, "_OFF", NULL, NULL);
-	if (ACPI_FAILURE(status))
-		result = -ENODEV;
-	else
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "Power resource [%s] turned off\n",
-				  resource->name));
-
  unlock:
 	mutex_unlock(&resource->resource_lock);
 
@@ -849,10 +857,17 @@ void acpi_resume_power_resources(void)
 		mutex_lock(&resource->resource_lock);
 
 		result = acpi_power_get_state(resource->device.handle, &state);
-		if (!result && state == ACPI_POWER_RESOURCE_STATE_OFF
+		if (result)
+			continue;
+
+		if (state == ACPI_POWER_RESOURCE_STATE_OFF
 		    && resource->ref_count) {
 			dev_info(&resource->device.dev, "Turning ON\n");
 			__acpi_power_on(resource);
+		} else if (state == ACPI_POWER_RESOURCE_STATE_ON
+		    && !resource->ref_count) {
+			dev_info(&resource->device.dev, "Turning OFF\n");
+			__acpi_power_off(resource);
 		}
 
 		mutex_unlock(&resource->resource_lock);

