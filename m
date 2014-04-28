Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaD1CH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 22:07:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:63000 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbaD1CHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 22:07:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,940,1389772800"; 
   d="scan'208";a="502018377"
Message-ID: <1398650870.2443.22.camel@rzhang1-mobl4>
Subject: Re: [PATCH V5 12/12] ACPI: introduce .handle_children flag for acpi
 scan handler
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Date: Mon, 28 Apr 2014 10:07:50 +0800
In-Reply-To: <3580601.ADWiqFXU1h@vostro.rjw.lan>
References: <1396886819-2637-1-git-send-email-rui.zhang@intel.com>
	 <1396886819-2637-13-git-send-email-rui.zhang@intel.com>
	 <3580601.ADWiqFXU1h@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 00:26 +0200, Rafael J. Wysocki wrote:
> On Tuesday, April 08, 2014 12:06:59 AM Zhang Rui wrote:
> > For some devices with scan handler attached, their children devices
> > are enumerated by the scan handler, indirectly.
> 
> This isn't the case really.  They are enumerated by bus controller drivers
> for the buses they are on.
> 
that's what I mean by saying "indirectly". :)

> > In this case, we do not want to enumerate the children devices in
> > acpi scan code explicitly.
> > 
> > Thus a new flag .handle_children is introduced in this patch.
> > 
> > For scan handlers with this flag set, we will do default enumeration neither
> > for the attached devices nor for the children of the attached devices.
> 
> I'm not sure if that is the right approach.  I would prefer that to be
> handled in a more fine-graind manner, like a flag per device ID or something
> similar?
> 
hmmm, how about this,
first, keep the device->flags.no_child_enumeration flag introduced in
this patch
second, set the flag explicitly, for specified devices, in the scan
handler .attach() function.

thanks,
rui
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > ---
> >  drivers/acpi/acpi_lpss.c |    2 ++
> >  drivers/acpi/scan.c      |   28 ++++++++++++++++++++++++++--
> >  include/acpi/acpi_bus.h  |    4 +++-
> >  3 files changed, 31 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> > index 965428f..da0a3d4 100644
> > --- a/drivers/acpi/acpi_lpss.c
> > +++ b/drivers/acpi/acpi_lpss.c
> > @@ -521,6 +521,7 @@ static struct acpi_scan_handler lpss_handler = {
> >  	.attach = acpi_lpss_create_device,
> >  	.bind = acpi_lpss_bind,
> >  	.unbind = acpi_lpss_unbind,
> > +	.handle_children = true,
> >  };
> >  
> >  #endif /* CONFIG_X86_INTEL_LPSS */
> > @@ -534,6 +535,7 @@ static int acpi_lpss_dummy_attach(struct acpi_device *adev,
> >  static struct acpi_scan_handler lpss_dummy_handler = {
> >  	.ids = acpi_lpss_device_ids,
> >  	.attach = acpi_lpss_dummy_attach,
> > +	.handle_children = true,
> >  };
> >  
> >  void __init acpi_lpss_init(void)
> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > index 44c4668..4ea867e 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -2073,6 +2073,31 @@ static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
> >  	return AE_OK;
> >  }
> >  
> > +static void acpi_do_default_enumeration(struct acpi_device *device)
> > +{
> > +	/*
> > +	 * Do not do enumeration for device object that
> > +	 * its parent doesn't want to
> > +	 */
> > +	if (device->parent && device->parent->flags.no_child_enumeration) {
> > +		device->flags.no_child_enumeration = 1;
> > +		return;
> > +	}
> > +
> > +	/* Do not do enumeration for device object with scan handler attached */
> > +	if (device->handler) {
> > +		if (device->handler->handle_children)
> > +			device->flags.no_child_enumeration = 1;
> > +		return;
> > +	}
> > +
> > +	/* Do not do enumeration for device object w/o platform_id */
> > +	if (!device->pnp.type.platform_id)
> > +		return;
> > +
> > +	acpi_create_platform_device(device, NULL);
> > +}
> > +
> >  static int acpi_scan_attach_handler(struct acpi_device *device)
> >  {
> >  	struct acpi_hardware_id *hwid;
> > @@ -2095,8 +2120,7 @@ static int acpi_scan_attach_handler(struct acpi_device *device)
> >  		}
> >  	}
> >  
> > -	if (device->pnp.type.platform_id && !device->handler)
> > -		acpi_create_platform_device(device, NULL);
> > +	acpi_do_default_enumeration(device);
> >  
> >  	return ret;
> >  }
> > diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> > index ec92ad3..4724fe5 100644
> > --- a/include/acpi/acpi_bus.h
> > +++ b/include/acpi/acpi_bus.h
> > @@ -137,6 +137,7 @@ struct acpi_scan_handler {
> >  	void (*bind)(struct device *phys_dev);
> >  	void (*unbind)(struct device *phys_dev);
> >  	struct acpi_hotplug_profile hotplug;
> > +	bool handle_children;
> >  };
> >  
> >  /*
> > @@ -207,7 +208,8 @@ struct acpi_device_flags {
> >  	u32 no_hotplug:1;
> >  	u32 hotplug_notify:1;
> >  	u32 is_dock_station:1;
> > -	u32 reserved:22;
> > +	u32 no_child_enumeration:1;
> > +	u32 reserved:21;
> >  };
> >  
> >  /* File System */
> > 
> 


