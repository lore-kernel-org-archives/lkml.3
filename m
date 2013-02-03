Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab3BCAqo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 19:46:44 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:50520 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab3BCAqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 19:46:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI / scan: Follow priorities of IDs when matching scan handlers
Date: Sun, 03 Feb 2013 01:52:56 +0100
Message-ID: <2566718.DLPxb38Yi2@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <25678789.biaFkG0HMW@vostro.rjw.lan>
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <1359502048.15120.75.camel@misato.fc.hp.com> <25678789.biaFkG0HMW@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The IDs of ACPI device nodes stored in their pnp.ids member arrays
are sorted by decreasing priority (i.e. the highest-priority ID is
the first entry).  This means that when matching scan handlers to
device nodes, the namespace scanning code should walk the list of
scan handlers for each device node ID instead of walking the list
of device node IDs for each handler (the latter causes the first
handler matching any of the device node IDs to be chosen, although
there may be another handler matching an ID of a higher priority
which should be preferred).  Make the code follow this observation.

This change has been suggested and justified by Toshi Kani.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |   42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

Index: test/drivers/acpi/scan.c
===================================================================
--- test.orig/drivers/acpi/scan.c
+++ test/drivers/acpi/scan.c
@@ -1556,26 +1556,42 @@ static acpi_status acpi_bus_check_add(ac
 	return AE_OK;
 }
 
-static int acpi_scan_attach_handler(struct acpi_device *device)
+static int acpi_scan_do_attach_handler(struct acpi_device *device, char *id)
 {
 	struct acpi_scan_handler *handler;
-	int ret = 0;
 
 	list_for_each_entry(handler, &acpi_scan_handlers_list, list_node) {
-		const struct acpi_device_id *id;
+		const struct acpi_device_id *devid;
 
-		id = __acpi_match_device(device, handler->ids);
-		if (!id)
-			continue;
-
-		ret = handler->attach(device, id);
-		if (ret > 0) {
-			device->handler = handler;
-			break;
-		} else if (ret < 0) {
-			break;
+		for (devid = handler->ids; devid->id[0]; devid++) {
+			int ret;
+
+			if (strcmp((char *)devid->id, id))
+				continue;
+
+			ret = handler->attach(device, devid);
+			if (ret > 0) {
+				device->handler = handler;
+				return ret;
+			} else if (ret < 0) {
+				return ret;
+			}
 		}
 	}
+	return 0;
+}
+
+static int acpi_scan_attach_handler(struct acpi_device *device)
+{
+	struct acpi_hardware_id *hwid;
+	int ret = 0;
+
+	list_for_each_entry(hwid, &device->pnp.ids, list) {
+		ret = acpi_scan_do_attach_handler(device, hwid->id);
+		if (ret)
+			break;
+
+	}
 	return ret;
 }
 

