Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab3FQW23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:28:29 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40683 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab3FQW20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:28:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] ACPI / PM: Fix error code path for power resources initialization
Date: Tue, 18 Jun 2013 00:37:45 +0200
Message-ID: <8547354.D2OPcUytEB@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Commit 781d737 (ACPI: Drop power resources driver) introduced a
bug in the power resources initialization error code path causing
a NULL pointer to be referenced in acpi_release_power_resource()
if there's an error triggering a jump to the 'err' label in
acpi_add_power_resource().  This happens because the list_node
field of struct acpi_power_resource has not been initialized yet
at this point and doing a list_del() on it is a bad idea.

To prevent this problem from occuring, initialize the list_node
field of struct acpi_power_resource upfront.

Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 3.9+ <stable@vger.kernel.org>
---
 drivers/acpi/power.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-pm/drivers/acpi/power.c
===================================================================
--- linux-pm.orig/drivers/acpi/power.c
+++ linux-pm/drivers/acpi/power.c
@@ -882,6 +882,7 @@ int acpi_add_power_resource(acpi_handle
 				ACPI_STA_DEFAULT);
 	mutex_init(&resource->resource_lock);
 	INIT_LIST_HEAD(&resource->dependent);
+	INIT_LIST_HEAD(&resource->list_node);
 	resource->name = device->pnp.bus_id;
 	strcpy(acpi_device_name(device), ACPI_POWER_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_POWER_CLASS);

