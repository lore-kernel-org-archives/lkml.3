Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3GHAAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 20:00:32 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:33739 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab3GHAAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 20:00:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] ACPI / scan: Always call acpi_bus_scan() for bus check notifications
Date: Mon, 08 Jul 2013 02:10:13 +0200
Message-ID: <2230821.QbNohsyO0O@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

An ACPI_NOTIFY_BUS_CHECK notification means that we should scan the
entire namespace starting from the given handle even if the device
represented by that handle is present (other devices below it may
just have been added).

For this reason, modify acpi_scan_bus_device_check() to always run
acpi_bus_scan() if the notification being handled is of type
ACPI_NOTIFY_BUS_CHECK.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 3.10+ <stable@vger.kernel.org>
---
 drivers/acpi/scan.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -353,10 +353,12 @@ static void acpi_scan_bus_device_check(a
 	mutex_lock(&acpi_scan_lock);
 	lock_device_hotplug();
 
-	acpi_bus_get_device(handle, &device);
-	if (device) {
-		dev_warn(&device->dev, "Attempt to re-insert\n");
-		goto out;
+	if (ost_source != ACPI_NOTIFY_BUS_CHECK) {
+		acpi_bus_get_device(handle, &device);
+		if (device) {
+			dev_warn(&device->dev, "Attempt to re-insert\n");
+			goto out;
+		}
 	}
 	acpi_evaluate_hotplug_ost(handle, ost_source,
 				  ACPI_OST_SC_INSERT_IN_PROGRESS, NULL);

