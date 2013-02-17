Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab3BQPVv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:21:51 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39053 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934Ab3BQPV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:21:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 1/7] ACPI / scan: Introduce acpi_scan_match_handler()
Date: Sun, 17 Feb 2013 16:20:10 +0100
Message-ID: <1836700.AtGyOWmaVR@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3260206.bhaAobGhpZ@vostro.rjw.lan>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan>
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
---
 drivers/acpi/scan.c |   53 +++++++++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

Index: test/drivers/acpi/scan.c
===================================================================
--- test.orig/drivers/acpi/scan.c
+++ test/drivers/acpi/scan.c
@@ -1529,6 +1529,25 @@ static int acpi_bus_type_and_status(acpi
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
@@ -1576,42 +1595,26 @@ static acpi_status acpi_bus_check_add(ac
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
 

