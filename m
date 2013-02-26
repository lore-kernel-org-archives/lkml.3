Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab3BZWol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:44:41 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:45656 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758967Ab3BZWoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:44:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v2, 1/7] ACPI / scan: Introduce acpi_scan_match_handler()
Date: Tue, 26 Feb 2013 23:44:51 +0100
Message-ID: <6768610.yrda235LWI@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3171747.TOMjvVkWL1@vostro.rjw.lan>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan> <3171747.TOMjvVkWL1@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Introduce helper routine acpi_scan_match_handler() that will find the
ACPI scan handler matching a given device ID, if there is one, and
rework acpi_scan_attach_handler() to use the new routine (that
routine will also be useful for other purposes going forward).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 drivers/acpi/scan.c |   53 +++++++++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

Index: test/drivers/acpi/scan.c
===================================================================
--- test.orig/drivers/acpi/scan.c
+++ test/drivers/acpi/scan.c
@@ -1536,6 +1536,25 @@ static int acpi_bus_type_and_status(acpi
 	return 0;
 }
 
+static struct acpi_scan_handler *acpi_scan_match_handler(char *idstr,
+					const struct acpi_device_id **matchid)
+{
+	struct acpi_scan_handler *handler;
+
+	list_for_each_entry(handler, &acpi_scan_handlers_list, list_node) {
+		const struct acpi_device_id *devid;
+
+		for (devid = handler->ids; devid->id[0]; devid++)
+			if (!strcmp((char *)devid->id, idstr)) {
+				if (matchid)
+					*matchid = devid;
+
+				return handler;
+			}
+	}
+	return NULL;
+}
+
 static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
 				      void *not_used, void **return_value)
 {
@@ -1583,42 +1602,26 @@ static acpi_status acpi_bus_check_add(ac
 	return AE_OK;
 }
 
-static int acpi_scan_do_attach_handler(struct acpi_device *device, char *id)
+static int acpi_scan_attach_handler(struct acpi_device *device)
 {
-	struct acpi_scan_handler *handler;
+	struct acpi_hardware_id *hwid;
+	int ret = 0;
 
-	list_for_each_entry(handler, &acpi_scan_handlers_list, list_node) {
+	list_for_each_entry(hwid, &device->pnp.ids, list) {
 		const struct acpi_device_id *devid;
+		struct acpi_scan_handler *handler;
 
-		for (devid = handler->ids; devid->id[0]; devid++) {
-			int ret;
-
-			if (strcmp((char *)devid->id, id))
-				continue;
-
+		handler = acpi_scan_match_handler(hwid->id, &devid);
+		if (handler) {
 			ret = handler->attach(device, devid);
 			if (ret > 0) {
 				device->handler = handler;
-				return ret;
+				break;
 			} else if (ret < 0) {
-				return ret;
+				break;
 			}
 		}
 	}
-	return 0;
-}
-
-static int acpi_scan_attach_handler(struct acpi_device *device)
-{
-	struct acpi_hardware_id *hwid;
-	int ret = 0;
-
-	list_for_each_entry(hwid, &device->pnp.ids, list) {
-		ret = acpi_scan_do_attach_handler(device, hwid->id);
-		if (ret)
-			break;
-
-	}
 	return ret;
 }
 

