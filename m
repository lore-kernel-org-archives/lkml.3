Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab3GKQPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:15:49 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42570 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab3GKQPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:15:47 -0400
Message-ID: <1373559305.24916.14.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI / scan: Always call acpi_bus_scan() for bus check
 notifications
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Date: Thu, 11 Jul 2013 10:15:05 -0600
In-Reply-To: <8128042.hqqjriutNl@vostro.rjw.lan>
References: <2230821.QbNohsyO0O@vostro.rjw.lan>
	 <6189099.QeK4PsCIFb@vostro.rjw.lan>
	 <1373500106.24916.13.camel@misato.fc.hp.com>
	 <8128042.hqqjriutNl@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 02:39 +0200, Rafael J. Wysocki wrote:
> On Wednesday, July 10, 2013 05:48:26 PM Toshi Kani wrote:
> > On Thu, 2013-07-11 at 00:45 +0200, Rafael J. Wysocki wrote:
> > > On Wednesday, July 10, 2013 02:11:05 AM Rafael J. Wysocki wrote:
> > > > On Tuesday, July 09, 2013 01:32:42 PM Toshi Kani wrote:
> > > > > On Mon, 2013-07-08 at 02:10 +0200, Rafael J. Wysocki wrote:
> > > > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > > 
> > > > > > An ACPI_NOTIFY_BUS_CHECK notification means that we should scan the
> > > > > > entire namespace starting from the given handle even if the device
> > > > > > represented by that handle is present (other devices below it may
> > > > > > just have been added).
> > > > > > 
> > > > > > For this reason, modify acpi_scan_bus_device_check() to always run
> > > > > > acpi_bus_scan() if the notification being handled is of type
> > > > > > ACPI_NOTIFY_BUS_CHECK.
> > > > > > 
> > > > > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > > Cc: 3.10+ <stable@vger.kernel.org>
> > > > > 
> > > > > Acked-by: Toshi Kani <toshi.kani@hp.com>
> > > > > 
> > > > > But, I think we need the additional patch below.
> > > > 
> > > > Yes, I think you're right.
> > > 
> > > That said I'd prefer to put the check into acpi_bus_device_attach() like in
> > > the appended patch.
> > 
> > That's fine by me.  
> > 
> > Acked-by: Toshi Kani <toshi.kani@hp.com>
> > 
> > Just a minor point, though.  Isn't it a bit inconsistent with
> > device_attach(), which checks dev->driver inside the function?
> 
> Well, device_attach() may be called from different places while this is
> the only place where acpi_scan_attach_handler() is called.
> 
> The check in acpi_bus_device_attach() is easier to follow to me, because
> it clearly means "we don't need to do anything more if there's a handler",
> while the check in acpi_scan_attach_handler() makes you wonder "why do we
> need to return 1 in that case?" and then you need to go to the caller and
> look at the check of the return value to see "ah, because we don't want
> that device_attach() to be called then!".

Sounds good to me.

Thanks,
-Toshi


> 
> > That said, I am OK with either way.
> 
> Cool. :-)
> 
> Thanks,
> Rafael
> 
> 
> > > ---
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > Subject: ACPI / scan: Do not try to attach scan handlers to devices having them
> > > 
> > > In acpi_bus_device_attach(), if there is an ACPI device object
> > > for the given handle and that device object has a scan handler
> > > attached to it already, there's nothing more to do for that handle
> > > and the function should just return success immediately.  Make
> > > that happen.
> > > 
> > > Reported-by: Toshi Kani <toshi.kani@hp.com>
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > ---
> > >  drivers/acpi/scan.c |    3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > Index: linux-pm/drivers/acpi/scan.c
> > > ===================================================================
> > > --- linux-pm.orig/drivers/acpi/scan.c
> > > +++ linux-pm/drivers/acpi/scan.c
> > > @@ -1984,6 +1984,9 @@ static acpi_status acpi_bus_device_attac
> > >  	if (acpi_bus_get_device(handle, &device))
> > >  		return AE_CTRL_DEPTH;
> > >  
> > > +	if (device->handler)
> > > +		return AE_OK;
> > > +
> > >  	ret = acpi_scan_attach_handler(device);
> > >  	if (ret)
> > >  		return ret > 0 ? AE_OK : AE_CTRL_DEPTH;
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


