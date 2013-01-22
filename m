Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab3AVCIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 21:08:18 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48958 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab3AVCHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 21:07:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lv Zheng <lv.zheng@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 2/4] ACPI / PM: Introduce helper for executing _PSn methods
Date: Tue, 22 Jan 2013 03:09:46 +0100
Message-ID: <1467956.knoMQ0FPoi@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1792467.qHBR6KraFh@vostro.rjw.lan>
References: <1792467.qHBR6KraFh@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

To reduce code duplication between acpi_device_set_power() and
acpi_bus_init_power(), introduce a new helper function for executing
ACPI devices' _PSn (n = 0..3) methods, acpi_dev_pm_explicit_set().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |   51 +++++++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 28 deletions(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -186,6 +186,19 @@ int acpi_device_get_power(struct acpi_de
 	return 0;
 }
 
+static int acpi_dev_pm_explicit_set(struct acpi_device *adev, int state)
+{
+	if (adev->power.states[state].flags.explicit_set) {
+		char method[5] = { '_', 'P', 'S', '0' + state, '\0' };
+		acpi_status status;
+
+		status = acpi_evaluate_object(adev->handle, method, NULL, NULL);
+		if (ACPI_FAILURE(status))
+			return -ENODEV;
+	}
+	return 0;
+}
+
 /**
  * acpi_device_set_power - Set power state of an ACPI device.
  * @device: Device to set the power state of.
@@ -197,8 +210,6 @@ int acpi_device_get_power(struct acpi_de
 int acpi_device_set_power(struct acpi_device *device, int state)
 {
 	int result = 0;
-	acpi_status status = AE_OK;
-	char object_name[5] = { '_', 'P', 'S', '0' + state, '\0' };
 	bool cut_power = false;
 
 	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
@@ -228,7 +239,6 @@ int acpi_device_set_power(struct acpi_de
 	if (state == ACPI_STATE_D3_COLD
 	    && device->power.states[ACPI_STATE_D3_COLD].flags.os_accessible) {
 		state = ACPI_STATE_D3_HOT;
-		object_name[3] = '3';
 		cut_power = true;
 	}
 
@@ -251,23 +261,14 @@ int acpi_device_set_power(struct acpi_de
 			if (result)
 				goto end;
 		}
-		if (device->power.states[state].flags.explicit_set) {
-			status = acpi_evaluate_object(device->handle,
-						      object_name, NULL, NULL);
-			if (ACPI_FAILURE(status)) {
-				result = -ENODEV;
-				goto end;
-			}
-		}
+		result = acpi_dev_pm_explicit_set(device, state);
+		if (result)
+			goto end;
 	} else {
-		if (device->power.states[state].flags.explicit_set) {
-			status = acpi_evaluate_object(device->handle,
-						      object_name, NULL, NULL);
-			if (ACPI_FAILURE(status)) {
-				result = -ENODEV;
-				goto end;
-			}
-		}
+		result = acpi_dev_pm_explicit_set(device, state);
+		if (result)
+			goto end;
+
 		if (device->power.flags.power_resources) {
 			result = acpi_power_transition(device, state);
 			if (result)
@@ -335,15 +336,9 @@ int acpi_bus_init_power(struct acpi_devi
 		if (result)
 			return result;
 
-		if (device->power.states[state].flags.explicit_set) {
-			char method[5] = { '_', 'P', 'S', '0' + state, '\0' };
-			acpi_status status;
-
-			status = acpi_evaluate_object(device->handle, method,
-						      NULL, NULL);
-			if (ACPI_FAILURE(status))
-				return -ENODEV;
-		}
+		result = acpi_dev_pm_explicit_set(device, state);
+		if (result)
+			return result;
 	}
 	device->power.state = state;
 	return 0;

