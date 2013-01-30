Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab3A3V6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 16:58:04 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34410 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855Ab3A3V57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:57:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 2/2] ACPI / scan: Clean up acpi_bus_get_parent()
Date: Wed, 30 Jan 2013 23:04:03 +0100
Message-ID: <7667918.svVNymu9rt@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1451967.YMyGeCCNtu@vostro.rjw.lan>
References: <1451967.YMyGeCCNtu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make acpi_bus_get_parent() more straightforward and remove an
unnecessary local variable ret from it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

Index: test/drivers/acpi/scan.c
===================================================================
--- test.orig/drivers/acpi/scan.c
+++ test/drivers/acpi/scan.c
@@ -871,29 +871,23 @@ EXPORT_SYMBOL(acpi_bus_unregister_driver
    -------------------------------------------------------------------------- */
 static struct acpi_device *acpi_bus_get_parent(acpi_handle handle)
 {
+	struct acpi_device *device = NULL;
 	acpi_status status;
-	int ret;
-	struct acpi_device *device;
 
 	/*
 	 * Fixed hardware devices do not appear in the namespace and do not
 	 * have handles, but we fabricate acpi_devices for them, so we have
 	 * to deal with them specially.
 	 */
-	if (handle == NULL)
+	if (!handle)
 		return acpi_root;
 
 	do {
 		status = acpi_get_parent(handle, &handle);
-		if (status == AE_NULL_ENTRY)
-			return NULL;
 		if (ACPI_FAILURE(status))
-			return acpi_root;
-
-		ret = acpi_bus_get_device(handle, &device);
-		if (ret == 0)
-			return device;
-	} while (1);
+			return status == AE_NULL_ENTRY ? NULL : acpi_root;
+	} while (acpi_bus_get_device(handle, &device));
+	return device;
 }
 
 acpi_status

