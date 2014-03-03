Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbaCCOLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 09:11:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:51725 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441AbaCCOLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 09:11:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,577,1389772800"; 
   d="scan'208";a="465510305"
Message-ID: <1393855908.2193.16.camel@rzhang1-mobl4>
Subject: Re: [RFC PATCH 6/8] ACPI: use platform bus as the default bus for
 _HID enumeration
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Date: Mon, 03 Mar 2014 22:11:48 +0800
In-Reply-To: <22144944.rXupLb1rjo@vostro.rjw.lan>
References: <1393405874-3266-1-git-send-email-rui.zhang@intel.com>
	 <1393405874-3266-7-git-send-email-rui.zhang@intel.com>
	 <22144944.rXupLb1rjo@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-03 at 00:51 +0100, Rafael J. Wysocki wrote:
> On Wednesday, February 26, 2014 05:11:12 PM Zhang Rui wrote:
> > Because of the growing demand for enumerating ACPI devices to platform bus,
> > this patch changes the code to enumerate ACPI devices with _HID/_CID to
> > platform bus by default, unless the device already has a scan handler attached.
> > 
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > ---
> >  drivers/acpi/acpi_platform.c |   28 ----------------------------
> >  drivers/acpi/scan.c          |   12 ++++++------
> >  2 files changed, 6 insertions(+), 34 deletions(-)
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
> > -
> > -	/* Intel Smart Sound Technology */
> > -	{ "INT33C8" },
> > -	{ "80860F28" },
> > -
> > -	{ }
> > -};
> > -
> >  /**
> >   * acpi_create_platform_device - Create platform device for ACPI device node
> >   * @adev: ACPI device node to create a platform device for.
> > @@ -125,13 +107,3 @@ int acpi_create_platform_device(struct acpi_device *adev,
> >  	kfree(resources);
> >  	return 1;
> >  }
> > -
> > -static struct acpi_scan_handler platform_handler = {
> > -	.ids = acpi_platform_device_ids,
> > -	.attach = acpi_create_platform_device,
> > -};
> > -
> > -void __init acpi_platform_init(void)
> > -{
> > -	acpi_scan_add_handler(&platform_handler);
> > -}
> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > index 5967338..61af32e 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -2022,14 +2022,15 @@ static int acpi_scan_attach_handler(struct acpi_device *device)
> >  		handler = acpi_scan_match_handler(hwid->id, &devid);
> >  		if (handler) {
> >  			ret = handler->attach(device, devid);
> > -			if (ret > 0) {
> > +			if (ret > 0)
> >  				device->handler = handler;
> > -				break;
> > -			} else if (ret < 0) {
> > -				break;
> > -			}
> > +			if (ret)
> > +				goto end;
> >  		}
> >  	}
> > +end:
> > +	if (!list_empty(&device->pnp.ids) && !device->handler)
> 
> I'm a bit concerned that this check will create platform devices for too many
> ACPI device objects.

agreed. there are some devices created unexpected by this patch, e.g. on
my test machine, I can see
 
/sys/bus/platform/devices/LNXSYSTM:00 (ACPI system bus/root node)
/sys/bus/platform/devices/PNP0000:00  (PIC)
/sys/bus/platform/devices/PNP0100:00  (system timer?)

>   Shouldn't we require that _HID or at least _CID is
> present for that?
> 
I do not think so.
only devices that invoke acpi_add_ids() may have pnp.ids but no
_HID/_CID, right?
I did a check in the code, those devices include:
ACPI root node
ACPI video
ACPI bay
ACPI dock
IBM SMBus
ACPI Power resource
ACPI processor
ACPI thermal
ACPI fixed power/sleep button

IMO, only the ACPI root node, ACPI power resource, possibly ACPI
processor are the ones that we do not want to see in platform bus.

Thus IMO, we can have an exclude list for those devices.

thanks,
rui
> > +		acpi_create_platform_device(device, NULL);
> >  	return ret;
> >  }
> >  
> > @@ -2185,7 +2186,6 @@ int __init acpi_scan_init(void)
> >  	acpi_pci_root_init();
> >  	acpi_pci_link_init();
> >  	acpi_processor_init();
> > -	acpi_platform_init();
> >  	acpi_lpss_init();
> >  	acpi_cmos_rtc_init();
> >  	acpi_container_init();
> > 
> 


