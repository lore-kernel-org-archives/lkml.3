Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669Ab3B1Vq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:46:56 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47923 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab3B1Vqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:46:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-usb@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/2] ACPI / glue: Drop .find_bridge() callback from struct acpi_bus_type
Date: Thu, 28 Feb 2013 22:53:31 +0100
Message-ID: <1995794.TENtrAZA5Q@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1504144.f1SBuDyFqp@vostro.rjw.lan>
References: <2612891.I2roH54cPk@vostro.rjw.lan> <20130228023313.GC4042@kroah.com> <1504144.f1SBuDyFqp@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

After PCI and USB have stopped using the .find_bridge() callback in
struct acpi_bus_type, the only remaining user of it is SATA, but SATA
only pretends to be a user, because it points that callback to a stub
always returning -ENODEV.

For this reason, drop the SATA's dummy .find_bridge() callback and
remove .find_bridge(), which is not used any more, from struct
acpi_bus_type entirely.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/glue.c       |   26 +-------------------------
 drivers/ata/libata-acpi.c |    6 ------
 include/acpi/acpi_bus.h   |    3 ---
 3 files changed, 1 insertion(+), 34 deletions(-)

Index: linux-pm/drivers/ata/libata-acpi.c
===================================================================
--- linux-pm.orig/drivers/ata/libata-acpi.c
+++ linux-pm/drivers/ata/libata-acpi.c
@@ -1144,14 +1144,8 @@ static int ata_acpi_find_device(struct d
 		return -ENODEV;
 }
 
-static int ata_acpi_find_dummy(struct device *dev, acpi_handle *handle)
-{
-	return -ENODEV;
-}
-
 static struct acpi_bus_type ata_acpi_bus = {
 	.name = "ATA",
-	.find_bridge = ata_acpi_find_dummy,
 	.find_device = ata_acpi_find_device,
 };
 
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -439,10 +439,7 @@ struct acpi_bus_type {
 	struct list_head list;
 	const char *name;
 	bool (*match)(struct device *dev);
-	/* For general devices under the bus */
 	int (*find_device) (struct device *, acpi_handle *);
-	/* For bridges, such as PCI root bridge, IDE controller */
-	int (*find_bridge) (struct device *, acpi_handle *);
 	void (*setup)(struct device *);
 	void (*cleanup)(struct device *);
 };
Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -78,22 +78,6 @@ static struct acpi_bus_type *acpi_get_bu
 	return ret;
 }
 
-static int acpi_find_bridge_device(struct device *dev, acpi_handle * handle)
-{
-	struct acpi_bus_type *tmp;
-	int ret = -ENODEV;
-
-	down_read(&bus_type_sem);
-	list_for_each_entry(tmp, &bus_type_list, list) {
-		if (tmp->find_bridge && !tmp->find_bridge(dev, handle)) {
-			ret = 0;
-			break;
-		}
-	}
-	up_read(&bus_type_sem);
-	return ret;
-}
-
 static acpi_status do_acpi_find_child(acpi_handle handle, u32 lvl_not_used,
 				      void *addr_p, void **ret_p)
 {
@@ -262,15 +246,7 @@ static int acpi_platform_notify(struct d
 	int ret;
 
 	ret = acpi_bind_one(dev, NULL);
-	if (ret) {
-		if (!type) {
-			ret = acpi_find_bridge_device(dev, &handle);
-			if (!ret)
-				ret = acpi_bind_one(dev, handle);
-
-			goto out;
-		}
-
+	if (ret && type) {
 		ret = type->find_device(dev, &handle);
 		if (ret) {
 			DBG("Unable to get handle for %s\n", dev_name(dev));
