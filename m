Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3AZWhy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 17:37:54 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:56736 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab3AZWhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 17:37:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 1/2] ACPI / scan: Make namespace scanning and trimming mutually exclusive
Date: Sat, 26 Jan 2013 23:41:10 +0100
Message-ID: <3032117.IcK9I7rYQT@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1581701.fnbebHrKch@vostro.rjw.lan>
References: <1581701.fnbebHrKch@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

There is no guarantee that acpi_bus_scan() and acpi_bus_trim() will
not be run in parallel for the same scope of the ACPI namespace,
which may lead to a great deal of confusion, so introduce a new mutex
to prevent that from happening.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -52,6 +52,7 @@ static const struct acpi_device_id acpi_
 
 static LIST_HEAD(acpi_device_list);
 static LIST_HEAD(acpi_bus_id_list);
+static DEFINE_MUTEX(acpi_scan_lock);
 DEFINE_MUTEX(acpi_device_lock);
 LIST_HEAD(acpi_wakeup_device_list);
 
@@ -1612,19 +1613,22 @@ static acpi_status acpi_bus_device_attac
 int acpi_bus_scan(acpi_handle handle)
 {
 	void *device = NULL;
+	int error = 0;
+
+	mutex_lock(&acpi_scan_lock);
 
 	if (ACPI_SUCCESS(acpi_bus_check_add(handle, 0, NULL, &device)))
 		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
 				    acpi_bus_check_add, NULL, NULL, &device);
 
 	if (!device)
-		return -ENODEV;
-
-	if (ACPI_SUCCESS(acpi_bus_device_attach(handle, 0, NULL, NULL)))
+		error = -ENODEV;
+	else if (ACPI_SUCCESS(acpi_bus_device_attach(handle, 0, NULL, NULL)))
 		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
 				    acpi_bus_device_attach, NULL, NULL, NULL);
 
-	return 0;
+	mutex_unlock(&acpi_scan_lock);
+	return error;
 }
 EXPORT_SYMBOL(acpi_bus_scan);
 
@@ -1653,6 +1657,8 @@ static acpi_status acpi_bus_remove(acpi_
 
 void acpi_bus_trim(struct acpi_device *start)
 {
+	mutex_lock(&acpi_scan_lock);
+
 	/*
 	 * Execute acpi_bus_device_detach() as a post-order callback to detach
 	 * all ACPI drivers from the device nodes being removed.
@@ -1667,6 +1673,8 @@ void acpi_bus_trim(struct acpi_device *s
 	acpi_walk_namespace(ACPI_TYPE_ANY, start->handle, ACPI_UINT32_MAX, NULL,
 			    acpi_bus_remove, NULL, NULL);
 	acpi_bus_remove(start->handle, 0, NULL, NULL);
+
+	mutex_unlock(&acpi_scan_lock);
 }
 EXPORT_SYMBOL_GPL(acpi_bus_trim);
 

