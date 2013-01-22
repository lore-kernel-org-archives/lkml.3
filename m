Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3AVCH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 21:07:56 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48961 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab3AVCHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 21:07:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lv Zheng <lv.zheng@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 1/4] ACPI / PM: Make acpi_bus_init_power() more robust
Date: Tue, 22 Jan 2013 03:09:01 +0100
Message-ID: <24285515.9Jp3KUo9Px@vostro.rjw.lan>
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

The ACPI specification requires the _PSC method to be present under
a device object if its power state cannot be inferred from the states
of power resources used by it (ACPI 5, Section 7.6.2).  However, it
also requires that (for power states D0-D2 and D3hot) if the _PSn
(n = 0, 1, 2, 3) method is present under the device object, it also
must be executed after the power resources have been set
appropriately for the device to go into power state Dn (D3 means
D3hot in this case).  Thus it is not clear from the specification
whether or not the _PSn method should be executed if the initial
configuraion of power resources used by the device indicates power
state Dn and the _PSC method is not present.

The current implementation of acpi_bus_init_power() is based on the
assumption that it should not be necessary to execute _PSn in the
above situation, but experience shows that in fact that assumption
need not be satisfied.  For this reason, make acpi_bus_init_power()
always execute _PSn if the initial configuration of device power
resources indicates power state Dn.

Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -330,13 +330,23 @@ int acpi_bus_init_power(struct acpi_devi
 	if (result)
 		return result;
 
-	if (device->power.flags.power_resources)
+	if (state < ACPI_STATE_D3_COLD && device->power.flags.power_resources) {
 		result = acpi_power_on_resources(device, state);
+		if (result)
+			return result;
 
-	if (!result)
-		device->power.state = state;
+		if (device->power.states[state].flags.explicit_set) {
+			char method[5] = { '_', 'P', 'S', '0' + state, '\0' };
+			acpi_status status;
 
-	return result;
+			status = acpi_evaluate_object(device->handle, method,
+						      NULL, NULL);
+			if (ACPI_FAILURE(status))
+				return -ENODEV;
+		}
+	}
+	device->power.state = state;
+	return 0;
 }
 
 int acpi_bus_update_power(acpi_handle handle, int *state_p)

