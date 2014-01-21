Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaAUXL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 18:11:29 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61340 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753055AbaAUXLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 18:11:24 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [RFC/RFT][PATCH 4-1/5] ACPI / scan: Add bind/unbind callbacks to struct acpi_scan_handler
Date: Wed, 22 Jan 2014 00:24:19 +0100
Message-ID: <3008927.otxYIj8S9K@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0-rc8+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <5380624.AVmYnxjkQF@vostro.rjw.lan>
References: <5434847.aCyiWHNRe7@vostro.rjw.lan> <1623216.7y3zYLQxqp@vostro.rjw.lan> <5380624.AVmYnxjkQF@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

In some cases it may be necessary to perform certain setup/cleanup
operations on a device object representing a physical device after
it has been associated with an ACPI companion by acpi_bind_one() or
before disassociating it from that companion by acpi_unbind_one(),
respectively.  If there is a struct acpi_bus_type object for the
given device's bus type, the .setup()/.cleanup() callbacks from there
are executed for these purposes.  However, an analogous mechanism will
be necessary for devices whose bus types don't have corresponding
struct acpi_bus_type objects and that have specific ACPI scan handlers.

For those devices, add new .bind() and .unbind() callbacks to struct
acpi_scan_handler that will be executed by acpi_platform_notify()
right after the given device has been associated with an ACPI
comapnion and by acpi_platform_notify_remove() right before calling
acpi_unbind_one() for that device, respectively.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/glue.c     |   12 ++++++++++++
 include/acpi/acpi_bus.h |    2 ++
 2 files changed, 14 insertions(+)

Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -287,6 +287,7 @@ EXPORT_SYMBOL_GPL(acpi_unbind_one);
 static int acpi_platform_notify(struct device *dev)
 {
 	struct acpi_bus_type *type = acpi_get_bus_type(dev);
+	struct acpi_device *adev;
 	int ret;
 
 	ret = acpi_bind_one(dev, NULL);
@@ -303,9 +304,14 @@ static int acpi_platform_notify(struct d
 		if (ret)
 			goto out;
 	}
+	adev = ACPI_COMPANION(dev);
+	if (!adev)
+		goto out;
 
 	if (type && type->setup)
 		type->setup(dev);
+	else if (adev->handler && adev->handler->bind)
+		adev->handler->bind(dev);
 
  out:
 #if ACPI_GLUE_DEBUG
@@ -324,11 +330,17 @@ static int acpi_platform_notify(struct d
 
 static int acpi_platform_notify_remove(struct device *dev)
 {
+	struct acpi_device *adev = ACPI_COMPANION(dev);
 	struct acpi_bus_type *type;
 
+	if (!adev)
+		return 0;
+
 	type = acpi_get_bus_type(dev);
 	if (type && type->cleanup)
 		type->cleanup(dev);
+	else if (adev->handler && adev->handler->unbind)
+		adev->handler->unbind(dev);
 
 	acpi_unbind_one(dev);
 	return 0;
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -133,6 +133,8 @@ struct acpi_scan_handler {
 	struct list_head list_node;
 	int (*attach)(struct acpi_device *dev, const struct acpi_device_id *id);
 	void (*detach)(struct acpi_device *dev);
+	void (*bind)(struct device *phys_dev);
+	void (*unbind)(struct device *phys_dev);
 	struct acpi_hotplug_profile hotplug;
 };
 

