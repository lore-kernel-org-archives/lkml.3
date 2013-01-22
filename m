Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3AVCHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 21:07:18 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48953 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458Ab3AVCHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 21:07:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lv Zheng <lv.zheng@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 3/4] ACPI / PM: Always evaluate _PSn after setting power resources
Date: Tue, 22 Jan 2013 03:10:39 +0100
Message-ID: <4535217.QpyVGrlvov@vostro.rjw.lan>
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

The ACPI specitication (ACPI 5, Sections 7.2.8 - 7.2.11) requires
that the _PSn (n = 0..3) method, if present, be executed after the
power resources for the given device power state have been set
appropriately.  However, acpi_device_set_power() does that only
if the new power state is going to be higher-power (lower-number)
than the power state the device is in already.  Otherwise, the
ordering is reverse to protect against situations in which _PSn
might access device registers unavailable after configuring the
power resources for power state Dn (D3 meaning D3hot).

Such situations are very unlikely to happen, though, and _PSn may
actually be implemented with the assumption that power resources
have been configured for power state Dn in advance, so change the
code to follow the specification literally.

This change was previously porposed in a different form by Lv Zheng.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |   46 +++++++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 29 deletions(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -242,50 +242,38 @@ int acpi_device_set_power(struct acpi_de
 		cut_power = true;
 	}
 
+	if (state < device->power.state && state != ACPI_STATE_D0
+	    && device->power.state >= ACPI_STATE_D3_HOT) {
+		printk(KERN_WARNING PREFIX
+			"Cannot transition to non-D0 state from D3\n");
+		return -ENODEV;
+	}
+
 	/*
 	 * Transition Power
 	 * ----------------
-	 * On transitions to a high-powered state we first apply power (via
-	 * power resources) then evalute _PSx.  Conversly for transitions to
-	 * a lower-powered state.
+	 * In accordance with the ACPI specification first apply power (via
+	 * power resources) and then evalute _PSx.
 	 */
-	if (state < device->power.state) {
-		if (device->power.state >= ACPI_STATE_D3_HOT &&
-		    state != ACPI_STATE_D0) {
-			printk(KERN_WARNING PREFIX
-			      "Cannot transition to non-D0 state from D3\n");
-			return -ENODEV;
-		}
-		if (device->power.flags.power_resources) {
-			result = acpi_power_transition(device, state);
-			if (result)
-				goto end;
-		}
-		result = acpi_dev_pm_explicit_set(device, state);
-		if (result)
-			goto end;
-	} else {
-		result = acpi_dev_pm_explicit_set(device, state);
+	if (device->power.flags.power_resources) {
+		result = acpi_power_transition(device, state);
 		if (result)
 			goto end;
-
-		if (device->power.flags.power_resources) {
-			result = acpi_power_transition(device, state);
-			if (result)
-				goto end;
-		}
 	}
+	result = acpi_dev_pm_explicit_set(device, state);
+	if (result)
+		goto end;
 
 	if (cut_power)
 		result = acpi_power_transition(device, ACPI_STATE_D3_COLD);
 
-      end:
-	if (result)
+ end:
+	if (result) {
 		printk(KERN_WARNING PREFIX
 			      "Device [%s] failed to transition to %s\n",
 			      device->pnp.bus_id,
 			      acpi_power_state_string(state));
-	else {
+	} else {
 		device->power.state = state;
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "Device [%s] transitioned to %s\n",

