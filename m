Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab3KFBgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 20:36:35 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:17506 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab3KFBge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 20:36:34 -0500
Message-ID: <1383701533.1847.20.camel@misato.fc.hp.com>
Subject: Re: [fixup][PATCH 2/6] ACPI / hotplug: Refuse to hot-remove all
 objects with disabled hotplug
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Date: Tue, 05 Nov 2013 18:32:13 -0700
In-Reply-To: <3139278.S6Gt6Dta9o@vostro.rjw.lan>
References: <5839747.7HXXGHmMBd@vostro.rjw.lan>
	 <5195965.AgE9G8aXP3@vostro.rjw.lan>
	 <1383698367.1847.18.camel@misato.fc.hp.com>
	 <3139278.S6Gt6Dta9o@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-06 at 02:35 +0100, Rafael J. Wysocki wrote:
> On Tuesday, November 05, 2013 05:39:27 PM Toshi Kani wrote:
> > On Wed, 2013-11-06 at 00:27 +0100, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > In theory, an ACPI device object may be the parent of another
> > > device object whose hotplug is disabled by user space through its
> > > scan handler.  In that case, the eject operation targeting the
> > > parent should fail as though the parent's own hotplug was disabled,
> > > but currently this is not the case, because acpi_scan_hot_remove()
> > > doesn't check the disable/enable hotplug status of the children
> > > of the top-most object passed to it.
> > > 
> > > To fix this, modify acpi_bus_offline_companions() to return an
> > > error code if hotplug is disabled for the given device object.
> > > [Also change the name of the function to acpi_bus_offline(),
> > > because it is not only about companions any more, and change
> > > the name of acpi_bus_online_companions() accordingly.]  Make
> > > acpi_scan_hot_remove() propagate that error to its callers.
> > > 
> >  :
> > > +static acpi_status acpi_bus_online(acpi_handle handle, u32 lvl, void *data,
> > > +				   void **ret_p)
> > >  {
> > >  	struct acpi_device *device = NULL;
> > >  	struct acpi_device_physical_node *pn;
> > > @@ -214,26 +220,32 @@ static int acpi_scan_hot_remove(struct a
> > >  	 * If the first pass is successful, the second one isn't needed, though.
> > >  	 */
> > >  	errdev = NULL;
> > > -	acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> > > -			    NULL, acpi_bus_offline_companions,
> > > -			    (void *)false, (void **)&errdev);
> > > -	acpi_bus_offline_companions(handle, 0, (void *)false, (void **)&errdev);
> > > +	status = acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> > > +				     NULL, acpi_bus_offline, (void *)false,
> > > +				     (void **)&errdev);
> > > +	if (status == AE_SUPPORT) {
> > > +		dev_warn(errdev, "Offline disabled.\n");
> > > +		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> > > +				    acpi_bus_online, NULL, NULL, NULL);
> > > +		put_device(&device->dev);
> > > +		return -EPERM;
> > > +	}
> > > +	acpi_bus_offline(handle, 0, (void *)false, (void **)&errdev);
> > >  	if (errdev) {
> > 
> > If the target object failed with AE_SUPPORT, shouldn't we skip the 2nd
> > pass and return with -EPERM after rollback?
> 
> We've checked the target object already in acpi_hotplug_notify_cb() or in
> acpi_eject_store().

Oh, I see.  Thanks for the clarification.

> 
> Which is telling me that the previous version of the patch was better after
> all, because the hotplug.enabled thing takes precedence over
> acpi_force_hot_remove in the other places.  So this:
> 
> https://patchwork.kernel.org/patch/3135841/
> 
> is the right version.  Sorry for the confusion.

Agreed.

Acked-by: Toshi Kani <toshi.kani@hp.com>

-Toshi

