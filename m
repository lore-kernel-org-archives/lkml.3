Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbaE1HQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:16:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:35046 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbaE1HQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:16:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,926,1392192000"; 
   d="scan'208";a="437906348"
Message-ID: <1401261386.2169.0.camel@rzhang1-toshiba>
Subject: Re: [PATCH V7 10/11] ACPI: use platform bus as the default bus for
 _HID enumeration
From: Zhang Rui <rui.zhang@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Heikki Krogerus <heikki.krogerus@intel.com>
Date: Wed, 28 May 2014 15:16:26 +0800
In-Reply-To: <20140526102145.GB1765@lahna.fi.intel.com>
References: <1400781753-2682-1-git-send-email-rui.zhang@intel.com>
	 <1400781753-2682-11-git-send-email-rui.zhang@intel.com>
	 <20140526102145.GB1765@lahna.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-26 at 13:21 +0300, Mika Westerberg wrote:
> On Fri, May 23, 2014 at 02:02:32AM +0800, Zhang Rui wrote:
> > Because of the growing demand for enumerating ACPI devices to
> > platform bus, this patch changes the code to enumerate ACPI
> > devices to platform bus by default, if the device
> > 1. has _HID.
> > 2. does not have a scan handler attached.
> > 3. is not SPB slave device, which should be enumerated by its parent.
> > 
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > ---
> >  drivers/acpi/acpi_platform.c | 28 ----------------------------
> >  drivers/acpi/scan.c          | 43 ++++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 42 insertions(+), 29 deletions(-)
> > 
> > diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
> > index dbfe49e..33376a9 100644
> > --- a/drivers/acpi/acpi_platform.c
> > +++ b/drivers/acpi/acpi_platform.c
> > @@ -22,24 +22,6 @@
> >  
> >  ACPI_MODULE_NAME("platform");
> >  
> > -/*
> > - * The following ACPI IDs are known to be suitable for representing as
> > - * platform devices.
> > - */
> > -static const struct acpi_device_id acpi_platform_device_ids[] = {
> > -
> > -	{ "PNP0D40" },
> > -	{ "ACPI0003" },
> > -	{ "VPC2004" },
> > -	{ "BCM4752" },
> 
> You can't remove this one as it is bluetooth connected to HS-UART and
> thus has UARTSerialBus() connector.

refreshed patch attached.

>From 50f67c33fc686c8dc86507e478a5e7d6f01805c9 Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Thu, 22 May 2014 21:30:37 +0800
Subject: [PATCH 10/11] ACPI: use platform bus as the default bus for _HID
 enumeration

Because of the growing demand for enumerating ACPI devices to
platform bus, this patch changes the code to enumerate ACPI
devices to platform bus by default, if the device
1. has _HID.
2. does not have a scan handler attached.
3. is not SPI/I2C slave device, which should be enumerated
   to SPI/I2C bus by its parent.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/acpi_platform.c | 28 ------------------------
 drivers/acpi/scan.c          | 51 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 29 deletions(-)

diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
index dbfe49e..33376a9 100644
--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -22,24 +22,6 @@
 
 ACPI_MODULE_NAME("platform");
 
-/*
- * The following ACPI IDs are known to be suitable for representing as
- * platform devices.
- */
-static const struct acpi_device_id acpi_platform_device_ids[] = {
-
-	{ "PNP0D40" },
-	{ "ACPI0003" },
-	{ "VPC2004" },
-	{ "BCM4752" },
-
-	/* Intel Smart Sound Technology */
-	{ "INT33C8" },
-	{ "80860F28" },
-
-	{ }
-};
-
 /**
  * acpi_create_platform_device - Create platform device for ACPI device node
  * @adev: ACPI device node to create a platform device for.
@@ -125,13 +107,3 @@ int acpi_create_platform_device(struct acpi_device *adev,
 	kfree(resources);
 	return 1;
 }
-
-static struct acpi_scan_handler platform_handler = {
-	.ids = acpi_platform_device_ids,
-	.attach = acpi_create_platform_device,
-};
-
-void __init acpi_platform_init(void)
-{
-	acpi_scan_add_handler(&platform_handler);
-}
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 6d50916..73417d6 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -2079,6 +2079,53 @@ static int acpi_scan_handler_dummy_attach(struct acpi_device *device,
 	return 1;
 }
 
+static int acpi_check_spi_i2c_slave(struct acpi_resource *ares, void *data)
+{
+	struct acpi_resource_common_serialbus *res;
+	int *is_spi_i2c_slave = data;
+
+	if (ares->type == ACPI_RESOURCE_TYPE_SERIAL_BUS) {
+		res = &ares->data.common_serial_bus;
+
+		/*
+		 * devices that are connected to UART still need to
+		 * be enumerated to platform bus
+		 */
+		if (res->type != ACPI_RESOURCE_SERIAL_TYPE_UART)
+			*is_spi_i2c_slave = 1;
+		 /* no need to do more checking */
+		return -1;
+	}
+	return 1;
+}
+
+static void acpi_do_default_enumeration(struct acpi_device *device)
+{
+	struct list_head resource_list;
+	int is_spi_i2c_slave = 0;
+
+	/* Do not do enumeration for device object w/o platform_id */
+	if (!device->pnp.type.platform_id)
+		return;
+
+	/* Do not do enumeration for device object with scan handler attached */
+	if (device->handler)
+		return;
+
+	/*
+	 * Do not do enemeration for SPI/I2C slaves
+	 * as they will be enuerated to SPI/I2C bus by their parents
+	 */
+	INIT_LIST_HEAD(&resource_list);
+	acpi_dev_get_resources(device, &resource_list,
+				acpi_check_spi_i2c_slave, &is_spi_i2c_slave);
+	acpi_dev_free_resource_list(&resource_list);
+	if (is_spi_i2c_slave)
+		return;
+
+	acpi_create_platform_device(device, NULL);
+}
+
 static int acpi_scan_attach_handler(struct acpi_device *device)
 {
 	struct acpi_hardware_id *hwid;
@@ -2103,6 +2150,9 @@ static int acpi_scan_attach_handler(struct acpi_device *device)
 				break;
 		}
 	}
+
+	acpi_do_default_enumeration(device);
+
 	return ret;
 }
 
@@ -2262,7 +2312,6 @@ int __init acpi_scan_init(void)
 	acpi_pci_root_init();
 	acpi_pci_link_init();
 	acpi_processor_init();
-	acpi_platform_init();
 	acpi_lpss_init();
 	acpi_cmos_rtc_init();
 	acpi_container_init();
-- 
1.8.3.2




