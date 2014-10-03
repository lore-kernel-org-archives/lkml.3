Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513AbaJDAWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:22:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbaJCVnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:43:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.16 198/357] ACPI / hotplug: Generate online uevents for ACPI containers
Date: Fri,  3 Oct 2014 14:29:44 -0700
Message-Id: <20141003212939.429838300@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 8ab17fc92e49bc2b8fff9d220c19bf50ec9c1158 upstream.

Commit 46394fd01 (ACPI / hotplug: Move container-specific code out of
the core) removed the generation of "online" uevents for containers,
because "add" uevents are now generated for them automatically when
container system devices are registered.  However, there are user
space tools that need to be notified when the container and all of
its children have been enumerated, which doesn't happen any more.

For this reason, add a mechanism allowing "online" uevents to be
generated for ACPI containers after enumerating the container along
with all of its children.

Fixes: 46394fd01 (ACPI / hotplug: Move container-specific code out of the core)
Reported-and-tested-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/container.c |    8 ++++++++
 drivers/acpi/scan.c      |    3 +++
 include/acpi/acpi_bus.h  |    1 +
 3 files changed, 12 insertions(+)

--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -99,6 +99,13 @@ static void container_device_detach(stru
 		device_unregister(dev);
 }
 
+static void container_device_online(struct acpi_device *adev)
+{
+	struct device *dev = acpi_driver_data(adev);
+
+	kobject_uevent(&dev->kobj, KOBJ_ONLINE);
+}
+
 static struct acpi_scan_handler container_handler = {
 	.ids = container_device_ids,
 	.attach = container_device_attach,
@@ -106,6 +113,7 @@ static struct acpi_scan_handler containe
 	.hotplug = {
 		.enabled = true,
 		.demand_offline = true,
+		.notify_online = container_device_online,
 	},
 };
 
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -2184,6 +2184,9 @@ static void acpi_bus_attach(struct acpi_
  ok:
 	list_for_each_entry(child, &device->children, node)
 		acpi_bus_attach(child);
+
+	if (device->handler && device->handler->hotplug.notify_online)
+		device->handler->hotplug.notify_online(device);
 }
 
 /**
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -118,6 +118,7 @@ struct acpi_device;
 struct acpi_hotplug_profile {
 	struct kobject kobj;
 	int (*scan_dependent)(struct acpi_device *adev);
+	void (*notify_online)(struct acpi_device *adev);
 	bool enabled:1;
 	bool demand_offline:1;
 };


