Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab3BQPWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:22:45 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39040 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab3BQPVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:21:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 4/7] ACPI / scan: Introduce acpi_scan_handler_matching()
Date: Sun, 17 Feb 2013 16:23:28 +0100
Message-ID: <18167652.ZolVinXqGN@vostro.rjw.lan>
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

Introduce new helper routine acpi_scan_handler_matching() for
checking if the given ACPI scan handler matches a given device ID
and rework acpi_scan_match_handler() to use the new routine (that
routine will also be useful for other purposes in the future).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

Index: test/drivers/acpi/scan.c
===================================================================
--- test.orig/drivers/acpi/scan.c
+++ test/drivers/acpi/scan.c
@@ -1658,22 +1658,32 @@ static int acpi_bus_type_and_status(acpi
 	return 0;
 }
 
+static bool acpi_scan_handler_matching(struct acpi_scan_handler *handler,
+				       char *idstr,
+				       const struct acpi_device_id **matchid)
+{
+	const struct acpi_device_id *devid;
+
+	for (devid = handler->ids; devid->id[0]; devid++)
+		if (!strcmp((char *)devid->id, idstr)) {
+			if (matchid)
+				*matchid = devid;
+
+			return true;
+		}
+
+	return false;
+}
+
 static struct acpi_scan_handler *acpi_scan_match_handler(char *idstr,
 					const struct acpi_device_id **matchid)
 {
 	struct acpi_scan_handler *handler;
 
-	list_for_each_entry(handler, &acpi_scan_handlers_list, list_node) {
-		const struct acpi_device_id *devid;
+	list_for_each_entry(handler, &acpi_scan_handlers_list, list_node)
+		if (acpi_scan_handler_matching(handler, idstr, matchid))
+			return handler;
 
-		for (devid = handler->ids; devid->id[0]; devid++)
-			if (!strcmp((char *)devid->id, idstr)) {
-				if (matchid)
-					*matchid = devid;
-
-				return handler;
-			}
-	}
 	return NULL;
 }
 

