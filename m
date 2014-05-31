Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaEaG3a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 02:29:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:47556 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaEaG33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 02:29:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,945,1392192000"; 
   d="scan'208";a="547614815"
Message-ID: <1401517763.6021.17.camel@rzhang1-toshiba>
Subject: Re: [Update][PATCH 10/10] ACPI / scan: use platform bus type by
 default for _HID enumeration
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matthew.garrett@nebula.com, mika.westerberg@linux.intel.com
Date: Sat, 31 May 2014 14:29:23 +0800
In-Reply-To: <1401515816.6021.15.camel@rzhang1-toshiba>
References: <1400781753-2682-1-git-send-email-rui.zhang@intel.com>
	 <35042328.kk6ZUUdfyN@vostro.rjw.lan> <6979141.yBBhMfGMhk@vostro.rjw.lan>
	 <7971916.hcjclMBqJX@vostro.rjw.lan>
	 <1401515816.6021.15.camel@rzhang1-toshiba>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-31 at 13:56 +0800, Zhang Rui wrote:
> On Fri, 2014-05-30 at 14:35 +0200, Rafael J. Wysocki wrote:
> > From: Zhang Rui <rui.zhang@intel.com>
> > 
> > Because of the growing demand for enumerating ACPI devices to
> > platform bus, change the code to enumerate ACPI device objects to
> > platform bus by default.  Namely, create platform devices for the
> > ACPI device objects that
> >  1. Have pnp.type.platform_id set (device objects with _HID currently).
> >  2. Do not have a scan handler attached.
> >  3. Are not SPI/I2C slave devices (that should be enumerated to the
> >     appropriate buses bus by their parent).
> > 
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > [rjw: Subject and changelog, rebase and code cleanup]
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> > 
> > Changelog rework and minor cleanups.
> > 
> > Thanks!
> > 
> > ---
> >  drivers/acpi/acpi_platform.c |   40 ++++++++--------------------------------
> >  drivers/acpi/scan.c          |   42 +++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 49 insertions(+), 33 deletions(-)
> > 
> > Index: linux-pm/drivers/acpi/acpi_platform.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/acpi_platform.c
> > +++ linux-pm/drivers/acpi/acpi_platform.c
> > @@ -22,21 +22,11 @@
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
> > -	{ "VPC2004" },
> > -	{ "BCM4752" },
> > -
> > -	/* Intel Smart Sound Technology */
> > -	{ "INT33C8" },
> > -	{ "80860F28" },
> > -
> > -	{ }
> > +static const struct acpi_device_id forbidden_id_list[] = {
> > +	{"PNP0000", 0},	/* PIC */
> > +	{"PNP0100", 0},	/* Timer */
> > +	{"PNP0200", 0},	/* AT DMA Controller */
> > +	{"", 0},
> >  };
> >  
> >  /**
> > @@ -63,6 +53,9 @@ struct platform_device *acpi_create_plat
> >  	if (adev->physical_node_count)
> >  		return NULL;
> >  
> > +	if (!acpi_match_device_ids(adev, forbidden_id_list))
> > +		return ERR_PTR(-EINVAL);
> > +
> >  	INIT_LIST_HEAD(&resource_list);
> >  	count = acpi_dev_get_resources(adev, &resource_list, NULL, NULL);
> >  	if (count < 0) {
> > @@ -120,20 +113,3 @@ struct platform_device *acpi_create_plat
> >  	kfree(resources);
> >  	return pdev;
> >  }
> > -
> > -static int acpi_platform_attach(struct acpi_device *adev,
> > -				const struct acpi_device_id *id)
> > -{
> > -	acpi_create_platform_device(adev);
> > -	return 1;
> > -}
> > -
> this patch does not apply.
> we do not have the above code in drivers/acpi/acpi_platform.c.

I see. this patch is made based on the drivers/acpi/acpi_platform.c
changes in your linux-next branch. Sorry for the noise.

thanks,
rui
> 
> thanks,
> rui
> > -static struct acpi_scan_handler platform_handler = {
> > -	.ids = acpi_platform_device_ids,
> > -	.attach = acpi_platform_attach,
> > -};
> > -
> > -void __init acpi_platform_init(void)
> > -{
> > -	acpi_scan_add_handler(&platform_handler);
> > -}
> > Index: linux-pm/drivers/acpi/scan.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/scan.c
> > +++ linux-pm/drivers/acpi/scan.c
> > @@ -2070,6 +2070,44 @@ static acpi_status acpi_bus_check_add(ac
> >  	return AE_OK;
> >  }
> >  
> > +static int acpi_check_spi_i2c_slave(struct acpi_resource *ares, void *data)
> > +{
> > +	bool *is_spi_i2c_slave_p = data;
> > +
> > +	if (ares->type != ACPI_RESOURCE_TYPE_SERIAL_BUS)
> > +		return 1;
> > +
> > +	/*
> > +	 * devices that are connected to UART still need to be enumerated to
> > +	 * platform bus
> > +	 */
> > +	if (ares->data.common_serial_bus.type != ACPI_RESOURCE_SERIAL_TYPE_UART)
> > +		*is_spi_i2c_slave_p = true;
> > +
> > +	 /* no need to do more checking */
> > +	return -1;
> > +}
> > +
> > +static void acpi_default_enumeration(struct acpi_device *device)
> > +{
> > +	struct list_head resource_list;
> > +	bool is_spi_i2c_slave = false;
> > +
> > +	if (!device->pnp.type.platform_id || device->handler)
> > +		return;
> > +
> > +	/*
> > +	 * Do not enemerate SPI/I2C slaves as they will be enuerated by their
> > +	 * respective parents.
> > +	 */
> > +	INIT_LIST_HEAD(&resource_list);
> > +	acpi_dev_get_resources(device, &resource_list, acpi_check_spi_i2c_slave,
> > +			       &is_spi_i2c_slave);
> > +	acpi_dev_free_resource_list(&resource_list);
> > +	if (!is_spi_i2c_slave)
> > +		acpi_create_platform_device(device);
> > +}
> > +
> >  static int acpi_scan_attach_handler(struct acpi_device *device)
> >  {
> >  	struct acpi_hardware_id *hwid;
> > @@ -2095,6 +2133,9 @@ static int acpi_scan_attach_handler(stru
> >  				break;
> >  		}
> >  	}
> > +	if (!ret)
> > +		acpi_default_enumeration(device);
> > +
> >  	return ret;
> >  }
> >  
> > @@ -2254,7 +2295,6 @@ int __init acpi_scan_init(void)
> >  	acpi_pci_root_init();
> >  	acpi_pci_link_init();
> >  	acpi_processor_init();
> > -	acpi_platform_init();
> >  	acpi_lpss_init();
> >  	acpi_cmos_rtc_init();
> >  	acpi_container_init();
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


