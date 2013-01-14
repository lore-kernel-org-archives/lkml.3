Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903Ab3ANVdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 16:33:36 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40729 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757852Ab3ANVdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 16:33:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>
Subject: [PATCH 4/5] ACPI / scan: Change the implementation of acpi_bus_trim()
Date: Mon, 14 Jan 2013 22:38:22 +0100
Message-ID: <1531179.4mnjUS2kC7@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3885603.ydrrB7OEKf@vostro.rjw.lan>
References: <3885603.ydrrB7OEKf@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The current acpi_bus_trim() implementation is not really
straightforward and may be simplified significantly by using
acpi_walk_namespace() with acpi_bus_remove() as a post-order
callback.

Observe that acpi_bus_remove(), as called by acpi_bus_trim(), cannot
actually fail, because its first argument is guaranteed not to be
NULL thanks to the acpi_bus_get_device() check in acpi_bus_trim(),
so simply move the acpi_bus_get_device() check to acpi_bus_remove()
and use acpi_walk_namespace() to execute it for every device under
start->handle as a post-order callback.  The, run it directly for
start->handle itself.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |   60 +++++++++-------------------------------------------
 1 file changed, 11 insertions(+), 49 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -1425,17 +1425,20 @@ static void acpi_device_set_id(struct ac
 	}
 }
 
-static int acpi_bus_remove(struct acpi_device *dev)
+static acpi_status acpi_bus_remove(acpi_handle handle, u32 lvl_not_used,
+				   void *not_used, void **ret_not_used)
 {
-	if (!dev)
-		return -EINVAL;
+	struct acpi_device *dev = NULL;
+
+	if (acpi_bus_get_device(handle, &dev))
+		return AE_OK;
 
 	dev->removal_type = ACPI_BUS_REMOVAL_EJECT;
 	device_release_driver(&dev->dev);
 
 	acpi_device_unregister(dev);
 
-	return 0;
+	return AE_OK;
 }
 
 void acpi_init_device_object(struct acpi_device *device, acpi_handle handle,
@@ -1646,51 +1649,10 @@ EXPORT_SYMBOL(acpi_bus_add);
 
 int acpi_bus_trim(struct acpi_device *start)
 {
-	acpi_status status;
-	struct acpi_device *parent, *child;
-	acpi_handle phandle, chandle;
-	acpi_object_type type;
-	u32 level = 1;
-	int err = 0;
-
-	parent = start;
-	phandle = start->handle;
-	child = chandle = NULL;
-
-	while ((level > 0) && parent && (!err)) {
-		status = acpi_get_next_object(ACPI_TYPE_ANY, phandle,
-					      chandle, &chandle);
-
-		/*
-		 * If this scope is exhausted then move our way back up.
-		 */
-		if (ACPI_FAILURE(status)) {
-			level--;
-			chandle = phandle;
-			acpi_get_parent(phandle, &phandle);
-			child = parent;
-			parent = parent->parent;
-			err = acpi_bus_remove(child);
-			continue;
-		}
-
-		status = acpi_get_type(chandle, &type);
-		if (ACPI_FAILURE(status)) {
-			continue;
-		}
-		/*
-		 * If there is a device corresponding to chandle then
-		 * parse it (depth-first).
-		 */
-		if (acpi_bus_get_device(chandle, &child) == 0) {
-			level++;
-			phandle = chandle;
-			chandle = NULL;
-			parent = child;
-		}
-		continue;
-	}
-	return err;
+	acpi_walk_namespace(ACPI_TYPE_ANY, start->handle, ACPI_UINT32_MAX, NULL,
+			    acpi_bus_remove, NULL, NULL);
+	acpi_bus_remove(start->handle, 0, NULL, NULL);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(acpi_bus_trim);
 

