Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712Ab3BIOYw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 09:24:52 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36254 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757574Ab3BIOYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 09:24:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: [PATCH 2/2] ACPI / scan: Full transition to D3cold in acpi_device_unregister()
Date: Sat, 09 Feb 2013 15:31:07 +0100
Message-ID: <4046675.Lno9M3IXL1@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2074190.mMzUc3TOxk@vostro.rjw.lan>
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <1468930.acVuhKfKYv@vostro.rjw.lan> <2074190.mMzUc3TOxk@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

In order to drop reference counts of all power resources used by an
ACPI device node being removed, acpi_device_unregister() calls
acpi_power_transition(device, ACPI_STATE_D3_COLD), which effectively
transitions the device node into D3cold if it uses any power
resources.  However, for some device nodes it may not be appropriate
to remove power from them entirely before putting them into D3hot 
before.  On the other hand, executing _PS3 for devices that don't
use power resources before removing them shouldn't really hurt.
In fact, that is done by acpi_bus_hot_remove_device(), but this is
not the right place to do it, because the bus trimming may have
caused power to be removed from the device node in question already
before.

For these reasons, make acpi_device_unregister() carry out full
power-off transition for all device nodes supporting that and remove
the direct evaluation of _PS3 from acpi_bus_hot_remove_device().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

Index: test/drivers/acpi/scan.c
===================================================================
--- test.orig/drivers/acpi/scan.c
+++ test/drivers/acpi/scan.c
@@ -125,12 +125,6 @@ void acpi_bus_hot_remove_device(void *co
 	/* Device node has been released. */
 	device = NULL;
 
-	/* power off device */
-	status = acpi_evaluate_object(handle, "_PS3", NULL, NULL);
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND)
-		printk(KERN_WARNING PREFIX
-				"Power-off device failed\n");
-
 	if (ACPI_SUCCESS(acpi_get_handle(handle, "_LCK", &temp))) {
 		arg_list.count = 1;
 		arg_list.pointer = &arg;
@@ -780,10 +774,11 @@ static void acpi_device_unregister(struc
 
 	device_del(&device->dev);
 	/*
-	 * Drop the reference counts of all power resources the device depends
-	 * on and turn off the ones that have no more references.
+	 * Transition the device to D3cold to drop the reference counts of all
+	 * power resources the device depends on and turn off the ones that have
+	 * no more references.
 	 */
-	acpi_power_transition(device, ACPI_STATE_D3_COLD);
+	acpi_device_set_power(device, ACPI_STATE_D3_COLD);
 	put_device(&device->dev);
 }
 

