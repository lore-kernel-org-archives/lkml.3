Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965362Ab3GSFWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:22:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965263Ab3GSFWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:22:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 21/38] ACPI / PM: Fix corner case in acpi_bus_update_power()
Date: Thu, 18 Jul 2013 22:21:37 -0700
Message-Id: <20130719052049.332662825@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052047.858393825@linuxfoundation.org>
References: <20130719052047.858393825@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 91bdad0b6237c25a7bf8fd4604d0cc64a2005a23 upstream.

The role of acpi_bus_update_power() is to update the given ACPI
device object's power.state field to reflect the current physical
state of the device (as inferred from the configuration of power
resources and _PSC, if available).  For this purpose it calls
acpi_device_set_power() that should update the power resources'
reference counters and set power.state as appropriate.  However,
that doesn't work if the "new" state is D1, D2 or D3hot and the
the current value of power.state means D3cold, because in that
case acpi_device_set_power() will refuse to transition the device
from D3cold to non-D0.

To address this problem, make acpi_bus_update_power() call
acpi_power_transition() directly to update the power resources'
reference counters and only use acpi_device_set_power() to put
the device into D0 if the current physical state of it cannot
be determined.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/device_pm.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -295,14 +295,27 @@ int acpi_bus_update_power(acpi_handle ha
 	if (result)
 		return result;
 
-	if (state == ACPI_STATE_UNKNOWN)
+	if (state == ACPI_STATE_UNKNOWN) {
 		state = ACPI_STATE_D0;
-
-	result = acpi_device_set_power(device, state);
-	if (!result && state_p)
+		result = acpi_device_set_power(device, state);
+		if (result)
+			return result;
+	} else {
+		if (device->power.flags.power_resources) {
+			/*
+			 * We don't need to really switch the state, bu we need
+			 * to update the power resources' reference counters.
+			 */
+			result = acpi_power_transition(device, state);
+			if (result)
+				return result;
+		}
+		device->power.state = state;
+	}
+	if (state_p)
 		*state_p = state;
 
-	return result;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(acpi_bus_update_power);
 


