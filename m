Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab3KGAXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 19:23:00 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56958 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752797Ab3KGAW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 19:22:58 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [Update][PATCH 4/6] ACPI / hotplug: Simplify device ejection routines
Date: Thu, 07 Nov 2013 01:35:18 +0100
Message-ID: <1857488.d8ScZB2yjC@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1383783425.1847.52.camel@misato.fc.hp.com>
References: <5839747.7HXXGHmMBd@vostro.rjw.lan> <1642586.5aH3MlB2GZ@vostro.rjw.lan> <1383783425.1847.52.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 06, 2013 05:17:05 PM Toshi Kani wrote:
> On Thu, 2013-11-07 at 01:14 +0100, Rafael J. Wysocki wrote:
> > On Wednesday, November 06, 2013 04:27:01 PM Toshi Kani wrote:
> > > On Mon, 2013-11-04 at 14:36 +0100, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > 
> > > > Simplify handle_root_bridge_removal() and acpi_eject_store() by
> > > > getting rid of struct acpi_eject_event and passing device objects
> > > > directly to async routines executed via acpi_os_hotplug_execute().
> > >  :
> > > >  static ssize_t
> > > >  acpi_eject_store(struct device *d, struct device_attribute *attr,
> > > >  		const char *buf, size_t count)
> > > >  {
> > > >  	struct acpi_device *acpi_device = to_acpi_device(d);
> > > > -	struct acpi_eject_event *ej_event;
> > > >  	acpi_object_type not_used;
> > > >  	acpi_status status;
> > > > -	int ret;
> > > >  
> > > >  	if (!count || buf[0] != '1')
> > > >  		return -EINVAL;
> > > > @@ -518,28 +519,17 @@ acpi_eject_store(struct device *d, struc
> > > >  	if (ACPI_FAILURE(status) || !acpi_device->flags.ejectable)
> > > >  		return -ENODEV;
> > > >  
> > > > -	ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
> > > > -	if (!ej_event) {
> > > > -		ret = -ENOMEM;
> > > > -		goto err_out;
> > > > -	}
> > > >  	acpi_evaluate_hotplug_ost(acpi_device->handle, ACPI_OST_EC_OSPM_EJECT,
> > > >  				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
> > > > -	ej_event->device = acpi_device;
> > > > -	ej_event->event = ACPI_OST_EC_OSPM_EJECT;
> > > >  	get_device(&acpi_device->dev);
> > > > -	status = acpi_os_hotplug_execute(acpi_bus_hot_remove_device, ej_event);
> > > > +	status = acpi_os_hotplug_execute(acpi_eject_store_work, acpi_device);
> > > >  	if (ACPI_SUCCESS(status))
> > > >  		return count;
> > > >  
> > > >  	put_device(&acpi_device->dev);
> > > > -	kfree(ej_event);
> > > > -	ret = status == AE_NO_MEMORY ? -ENOMEM : -EAGAIN;
> > > 
> > > Why are you deleting the above line as part of this change?
> > 
> > Ah, because I forgot that acpi_os_hotplug_execute() can also return AE_NO_MEMORY. :-)
> > 
> > Good catch, updated pach follows.
> 
> Looks good.  The rest of the patches also look good.  For patch 4-6:
> 
> Acked-by: Toshi Kani <toshi.kani@hp.com>

Awesome, thanks! :-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
