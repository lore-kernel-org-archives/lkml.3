Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaCaFYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 01:24:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:40262 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbaCaFYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 01:24:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,762,1389772800"; 
   d="scan'208";a="510731305"
Message-ID: <1396243459.2437.3.camel@rzhang1-mobl4>
Subject: Re: [PATCH V4 07/11] ACPI: use platform bus as the default bus for
 _HID enumeration
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Date: Mon, 31 Mar 2014 13:24:19 +0800
In-Reply-To: <1395633969.2206.36.camel@rzhang1-mobl4>
References: <1395042580-3344-1-git-send-email-rui.zhang@intel.com>
	 <1395042580-3344-8-git-send-email-rui.zhang@intel.com>
	 <28494711.6ccuzjUcKA@vostro.rjw.lan>
	 <1395633969.2206.36.camel@rzhang1-mobl4>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-24 at 12:06 +0800, Zhang Rui wrote:
> On Mon, 2014-03-24 at 03:00 +0100, Rafael J. Wysocki wrote:
> > On Monday, March 17, 2014 03:49:36 PM Zhang Rui wrote:
> > > Because of the growing demand for enumerating ACPI devices to platform bus,
> > > this patch changes the code to enumerate ACPI devices with _HID to
> > > platform bus by default, unless the device already has a scan handler attached.
> > 
> > I think we need to be more careful here still.
> > 
> > For example, we shouldn't create platform devices for ACPI device objects that
> > correspond to I2C devices (or any other "simple peripheral bus" devices for that
> > matter).
> > 
> agreed. Then how about the patch below?
> Note that I've just finished with build test.
> 
updated one attached.
I faked a LPSS device and its child device in DSDT, test result shows
that only the LPSS device is enumerated to platform bus via the LPSS
scan handler.

>From 9ac1537b52e5882e13fd60cb435af56ed04456ac Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Mon, 24 Mar 2014 11:48:05 +0800
Subject: [PATCH] ACPI: introduce .handle_children flag for acpi scan handler

For some devices with scan handler attached, their children devices
are enumerated by the scan handler, indirectly, as well.

In this case, we do not want to enumerate the children devices in
acpi scan code explicitly.

Thus a new flag .handle_children is introduced in this patch.

For scan handlers with this flag set, we will do default enumeration neither
for the attached devices nor for the children of the attached devices.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/acpi_lpss.c |    2 ++
 drivers/acpi/scan.c      |   28 ++++++++++++++++++++++++++--
 include/acpi/acpi_bus.h  |    4 +++-
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index cfbf2c0..6c3e7a8 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -440,6 +440,7 @@ static struct notifier_block acpi_lpss_nb = {
 static struct acpi_scan_handler lpss_handler = {
 	.ids = acpi_lpss_device_ids,
 	.attach = acpi_lpss_create_device,
+	.handle_children = true,
 };
 
 #endif /* CONFIG_X86_INTEL_LPSS */
@@ -453,6 +454,7 @@ static int acpi_lpss_dummy_attach(struct acpi_device *adev,
 static struct acpi_scan_handler lpss_dummy_handler = {
 	.ids = acpi_lpss_device_ids,
 	.attach = acpi_lpss_dummy_attach,
+	.handle_children = true,
 };
 
 void __init acpi_lpss_init(void)
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index c0456e7..cd833f4 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -2016,6 +2016,31 @@ static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
 	return AE_OK;
 }
 
+static void acpi_do_default_enumeration(struct acpi_device *device)
+{
+	/*
+	 * Do not do enumeration for device object that
+	 * its parent doesn't want to
+	 */
+	if (device->parent && device->parent->flags.no_child_enumeration) {
+		device->flags.no_child_enumeration = 1;
+		return;
+	}
+
+	/* Do not do enumeration for device object with scan handler attached */
+	if (device->handler) {
+		if (device->handler->handle_children)
+			device->flags.no_child_enumeration = 1;
+		return;
+	}
+
+	/* Do not do enumeration for device object w/o platform_id */
+	if (!device->pnp.type.platform_id)
+		return;
+
+	acpi_create_platform_device(device, NULL);
+}
+
 static int acpi_scan_attach_handler(struct acpi_device *device)
 {
 	struct acpi_hardware_id *hwid;
@@ -2035,8 +2060,7 @@ static int acpi_scan_attach_handler(struct acpi_device *device)
 		}
 	}
 end:
-	if (device->pnp.type.platform_id && !device->handler)
-		acpi_create_platform_device(device, NULL);
+	acpi_do_default_enumeration(device);
 	return ret;
 }
 
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index f998746..bc7235f 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -135,6 +135,7 @@ struct acpi_scan_handler {
 	int (*attach)(struct acpi_device *dev, const struct acpi_device_id *id);
 	void (*detach)(struct acpi_device *dev);
 	struct acpi_hotplug_profile hotplug;
+	bool handle_children;
 };
 
 /*
@@ -191,7 +192,8 @@ struct acpi_device_flags {
 	u32 initialized:1;
 	u32 visited:1;
 	u32 no_hotplug:1;
-	u32 reserved:24;
+	u32 no_child_enumeration:1;
+	u32 reserved:23;
 };
 
 /* File System */
-- 
1.7.9.5



