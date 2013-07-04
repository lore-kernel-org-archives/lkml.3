Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab3GDMsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:48:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:22939 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab3GDMsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:48:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,995,1363158000"; 
   d="scan'208";a="264079557"
Date: Thu, 4 Jul 2013 15:53:38 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, john.ronciak@intel.com,
        miles.j.penner@intel.com, bruce.w.allan@intel.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 6/8] PCI: acpiphp: workaround for Thunderbolt on Acer
 Aspire S5
Message-ID: <20130704125337.GN4898@intel.com>
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
 <1444243.g9GbxN3NM0@vostro.rjw.lan>
 <20130704085844.GF4898@intel.com>
 <6828518.UobQ5xLxzT@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6828518.UobQ5xLxzT@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 02:36:00PM +0200, Rafael J. Wysocki wrote:
> On Thursday, July 04, 2013 11:58:44 AM Mika Westerberg wrote:
> > On Wed, Jul 03, 2013 at 11:40:42PM +0200, Rafael J. Wysocki wrote:
> > > On Wednesday, July 03, 2013 05:04:53 PM Mika Westerberg wrote:
> > > > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > > > 
> > > > Correct ACPI PCI hotplug imeplementation should have _RMV method in a
> > > > PCI slot (device under pci bridge). In Acer Aspire S5 case we have it
> > > > deeper in hierarchy:
> > > > 
> > > > Device (RP05)
> > > > {
> > > >    // ...
> > > >    Device (HRUP)
> > > >    {
> > > >        // ...
> > > >        Device (HRDN)
> > > >        {
> > > >            // ...
> > > >            Device (EPUP)
> > > >            {
> > > >                // ...
> > > >                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
> > > >                {
> > > >                    Return (One)
> > > >                }
> > > >            }
> > > >        }
> > > >    }
> > > > }
> > > > 
> > > > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > > ---
> > > >  drivers/pci/hotplug/acpi_pcihp.c | 13 +++++++++++++
> > > >  1 file changed, 13 insertions(+)
> > > > 
> > > > diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
> > > > index 2a47e82..d92ebfb 100644
> > > > --- a/drivers/pci/hotplug/acpi_pcihp.c
> > > > +++ b/drivers/pci/hotplug/acpi_pcihp.c
> > > > @@ -422,6 +422,19 @@ static int pcihp_is_ejectable(acpi_handle handle)
> > > >  	status = acpi_evaluate_integer(handle, "_RMV", NULL, &removable);
> > > >  	if (ACPI_SUCCESS(status) && removable)
> > > >  		return 1;
> > > > +
> > > > +	/*
> > > > +	 * Workaround for Thunderbolt implementation on Acer Aspire S5.
> > > > +	 *
> > > > +	 * Correct ACPI PCI hotplug imeplementation has _RMV method in a PCI
> > > > +	 * slot (device under pci bridge). In Acer Aspire S5 case we have it
> > > > +	 * deeper in hierarchy.
> > > > +	 */
> > > > +	status = acpi_evaluate_integer(handle, "HRDN.EPUP._RMV", NULL,
> > > > +			&removable);
> > > 
> > > Well, calling stuff like this directly from a general function is kind of ugly.
> > > 
> > > Can we use something like a quirk instead?  A DMI check or something?
> > 
> > Sure we can. How about something like the patch below?
> 
> Well, it goes into the right (to me) direction. :-)
> 
> Some comments below.
> 
> > From: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Subject: [PATCH] PCI: acpiphp: workaround for Thunderbolt on Acer Aspire S5
> > 
> > The acpiphp driver finds out whether the device is removable by checking
> > whether it has _RMV method directly behind it (and if it returns 1).
> > However, at least on Acer Aspire S5 with Thunderbolt host router has this
> > method placed behind a device called EPUP (endpoint upstream port?) and not
> > in the usual place expected by the acpiphp driver. The ASL code below shows
> > how this is done on that machine:
> > 
> > Device (RP05)
> > {
> > 	...
> > 	Device (HRUP)
> > 	{
> > 		Name (_ADR, Zero)
> > 		Name (_PRW, Package (0x02)
> > 		{
> > 			0x09,
> > 			0x04
> > 		})
> > 		Device (HRDN)
> > 		{
> > 			Name (_ADR, 0x00040000)
> > 			Name (_PRW, Package (0x02)
> > 			{
> > 				0x09,
> > 				0x04
> > 			})
> > 			Device (EPUP)
> > 			{
> > 				Name (_ADR, Zero)
> > 				Method (_RMV, 0, NotSerialized)
> > 				{
> > 					Return (One)
> > 				}
> > 			}
> > 		}
> > 	}
> > 	...
> > 
> > Fix this by adding a DMI quirk for the Acer Aspire S5 machine that gives an
> > alternative path to the _RMV method.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> >  drivers/pci/hotplug/acpi_pcihp.c | 57 ++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 52 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
> > index 2a47e82..99fccf3 100644
> > --- a/drivers/pci/hotplug/acpi_pcihp.c
> > +++ b/drivers/pci/hotplug/acpi_pcihp.c
> > @@ -33,6 +33,7 @@
> >  #include <linux/acpi.h>
> >  #include <linux/pci-acpi.h>
> >  #include <linux/slab.h>
> > +#include <linux/dmi.h>
> >  
> >  #define MY_NAME	"acpi_pcihp"
> >  
> > @@ -408,21 +409,67 @@ got_one:
> >  }
> >  EXPORT_SYMBOL(acpi_get_hp_hw_control_from_firmware);
> >  
> > +/**
> > + * pcihp_is_removable - is the given ACPI device removable
> > + * @handle: ACPI handle of the device
> > + *
> > + * Try to find out whether the given ACPI device is removable by evaluating
> > + * its _RMV and returning the result. If we can't find the _RMV directly
> > + * under the device use system specific quirks to locate it.
> > + */
> > +static bool pcihp_is_removable(acpi_handle handle)
> > +{
> 
> People are generally used to seeing DMI lists outside of functions.

OK.

> > +	static const struct dmi_system_id rmv_paths[] = {
> > +		{
> > +			/*
> > +			 * On Acer Aspire S5 the _RMV method for the
> > +			 * Thunderbolt host router upstream port is not
> > +			 * located directly under the device but it is
> > +			 * instead placed a bit deeper in the hierarchy.
> > +			 */
> > +			.ident = "Acer Aspire S5",
> > +			.matches = {
> > +				DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
> > +				DMI_MATCH(DMI_PRODUCT_NAME, "Aspire S5-391"),
> > +			},
> > +			.driver_data = "HRDN.EPUP._RMV",
> 
> Use .callback instead? ->
> 
> > +		},
> > +		{ }
> > +	};
> > +	const struct dmi_system_id *id;
> > +	unsigned long long removable;
> > +	acpi_status status;
> > +
> > +	status = acpi_evaluate_integer(handle, "_RMV", NULL, &removable);
> > +	if (ACPI_SUCCESS(status))
> > +		return !!removable;
> > +
> > +	/* Try system specific quirks */
> > +	id = dmi_first_match(rmv_paths);
> > +	if (id && id->driver_data) {
> 
> -> And here do
> 
> 	if (id && id->callback)
> 		return id->callback(id);

There is a problem with the above that we can't pass an ACPI handle to the
callback function.

> 
> > +		char path[64];
> > +
> > +		strlcpy(path, id->driver_data, sizeof(path));
> > +		status = acpi_evaluate_integer(handle, path, NULL, &removable);
> > +		if (ACPI_SUCCESS(status))
> > +			return !!removable;
> > +	}
> > +
> > +	return false;
> > +}
> > +
> >  static int pcihp_is_ejectable(acpi_handle handle)
> >  {
> >  	acpi_status status;
> >  	acpi_handle tmp;
> > -	unsigned long long removable;
> > +
> >  	status = acpi_get_handle(handle, "_ADR", &tmp);
> >  	if (ACPI_FAILURE(status))
> >  		return 0;
> >  	status = acpi_get_handle(handle, "_EJ0", &tmp);
> >  	if (ACPI_SUCCESS(status))
> >  		return 1;
> > -	status = acpi_evaluate_integer(handle, "_RMV", NULL, &removable);
> > -	if (ACPI_SUCCESS(status) && removable)
> > -		return 1;
> 
> I'd keep the above unchanged and simply add a "platform check" function.

OK, thanks.
