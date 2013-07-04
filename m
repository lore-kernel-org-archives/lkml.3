Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab3GDNoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:44:18 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58307 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab3GDNoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:44:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
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
Subject: Re: [PATCH v2 6/8] PCI: acpiphp: workaround for Thunderbolt on Acer Aspire S5
Date: Thu, 04 Jul 2013 15:53:55 +0200
Message-ID: <1656567.0oqS7xVYJ8@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130704133314.GO4898@intel.com>
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com> <5332719.huZ9ItKWz0@vostro.rjw.lan> <20130704133314.GO4898@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 04, 2013 04:33:14 PM Mika Westerberg wrote:
> On Thu, Jul 04, 2013 at 03:14:58PM +0200, Rafael J. Wysocki wrote:
> > On Thursday, July 04, 2013 03:53:38 PM Mika Westerberg wrote:
> > > On Thu, Jul 04, 2013 at 02:36:00PM +0200, Rafael J. Wysocki wrote:
> > > > On Thursday, July 04, 2013 11:58:44 AM Mika Westerberg wrote:
> > > > > On Wed, Jul 03, 2013 at 11:40:42PM +0200, Rafael J. Wysocki wrote:
> > > > > > On Wednesday, July 03, 2013 05:04:53 PM Mika Westerberg wrote:
> > > > > > > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > > > > > > 
> > > > > > > Correct ACPI PCI hotplug imeplementation should have _RMV method in a
> > > > > > > PCI slot (device under pci bridge). In Acer Aspire S5 case we have it
> > > > > > > deeper in hierarchy:
> > > > > > > 
> > > > > > > Device (RP05)
> > > > > > > {
> > > > > > >    // ...
> > > > > > >    Device (HRUP)
> > > > > > >    {
> > > > > > >        // ...
> > > > > > >        Device (HRDN)
> > > > > > >        {
> > > > > > >            // ...
> > > > > > >            Device (EPUP)
> > > > > > >            {
> > > > > > >                // ...
> > > > > > >                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
> > > > > > >                {
> > > > > > >                    Return (One)
> > > > > > >                }
> > > > > > >            }
> > > > > > >        }
> > > > > > >    }
> > > > > > > }
> > > > > > > 
> > > > > > > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > > > > > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > > > > > ---
> > > > > > >  drivers/pci/hotplug/acpi_pcihp.c | 13 +++++++++++++
> > > > > > >  1 file changed, 13 insertions(+)
> > > > > > > 
> > > > > > > diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
> > > > > > > index 2a47e82..d92ebfb 100644
> > > > > > > --- a/drivers/pci/hotplug/acpi_pcihp.c
> > > > > > > +++ b/drivers/pci/hotplug/acpi_pcihp.c
> > > > > > > @@ -422,6 +422,19 @@ static int pcihp_is_ejectable(acpi_handle handle)
> > > > > > >  	status = acpi_evaluate_integer(handle, "_RMV", NULL, &removable);
> > > > > > >  	if (ACPI_SUCCESS(status) && removable)
> > > > > > >  		return 1;
> > > > > > > +
> > > > > > > +	/*
> > > > > > > +	 * Workaround for Thunderbolt implementation on Acer Aspire S5.
> > > > > > > +	 *
> > > > > > > +	 * Correct ACPI PCI hotplug imeplementation has _RMV method in a PCI
> > > > > > > +	 * slot (device under pci bridge). In Acer Aspire S5 case we have it
> > > > > > > +	 * deeper in hierarchy.
> > > > > > > +	 */
> > > > > > > +	status = acpi_evaluate_integer(handle, "HRDN.EPUP._RMV", NULL,
> > > > > > > +			&removable);
> > > > > > 
> > > > > > Well, calling stuff like this directly from a general function is kind of ugly.
> > > > > > 
> > > > > > Can we use something like a quirk instead?  A DMI check or something?
> > > > > 
> > > > > Sure we can. How about something like the patch below?
> > > > 
> > > > Well, it goes into the right (to me) direction. :-)
> > > > 
> > > > Some comments below.
> > > > 
> > > > > From: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > > > Subject: [PATCH] PCI: acpiphp: workaround for Thunderbolt on Acer Aspire S5
> > > > > 
> > > > > The acpiphp driver finds out whether the device is removable by checking
> > > > > whether it has _RMV method directly behind it (and if it returns 1).
> > > > > However, at least on Acer Aspire S5 with Thunderbolt host router has this
> > > > > method placed behind a device called EPUP (endpoint upstream port?) and not
> > > > > in the usual place expected by the acpiphp driver. The ASL code below shows
> > > > > how this is done on that machine:
> > > > > 
> > > > > Device (RP05)
> > > > > {
> > > > > 	...
> > > > > 	Device (HRUP)
> > > > > 	{
> > > > > 		Name (_ADR, Zero)
> > > > > 		Name (_PRW, Package (0x02)
> > > > > 		{
> > > > > 			0x09,
> > > > > 			0x04
> > > > > 		})
> > > > > 		Device (HRDN)
> > > > > 		{
> > > > > 			Name (_ADR, 0x00040000)
> > > > > 			Name (_PRW, Package (0x02)
> > > > > 			{
> > > > > 				0x09,
> > > > > 				0x04
> > > > > 			})
> > > > > 			Device (EPUP)
> > > > > 			{
> > > > > 				Name (_ADR, Zero)
> > > > > 				Method (_RMV, 0, NotSerialized)
> > > > > 				{
> > > > > 					Return (One)
> > > > > 				}
> > > > > 			}
> > > > > 		}
> > > > > 	}
> > > > > 	...
> > > > > 
> > > > > Fix this by adding a DMI quirk for the Acer Aspire S5 machine that gives an
> > > > > alternative path to the _RMV method.
> > > > > 
> > > > > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > > > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > > > ---
> > > > >  drivers/pci/hotplug/acpi_pcihp.c | 57 ++++++++++++++++++++++++++++++++++++----
> > > > >  1 file changed, 52 insertions(+), 5 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
> > > > > index 2a47e82..99fccf3 100644
> > > > > --- a/drivers/pci/hotplug/acpi_pcihp.c
> > > > > +++ b/drivers/pci/hotplug/acpi_pcihp.c
> > > > > @@ -33,6 +33,7 @@
> > > > >  #include <linux/acpi.h>
> > > > >  #include <linux/pci-acpi.h>
> > > > >  #include <linux/slab.h>
> > > > > +#include <linux/dmi.h>
> > > > >  
> > > > >  #define MY_NAME	"acpi_pcihp"
> > > > >  
> > > > > @@ -408,21 +409,67 @@ got_one:
> > > > >  }
> > > > >  EXPORT_SYMBOL(acpi_get_hp_hw_control_from_firmware);
> > > > >  
> > > > > +/**
> > > > > + * pcihp_is_removable - is the given ACPI device removable
> > > > > + * @handle: ACPI handle of the device
> > > > > + *
> > > > > + * Try to find out whether the given ACPI device is removable by evaluating
> > > > > + * its _RMV and returning the result. If we can't find the _RMV directly
> > > > > + * under the device use system specific quirks to locate it.
> > > > > + */
> > > > > +static bool pcihp_is_removable(acpi_handle handle)
> > > > > +{
> > > > 
> > > > People are generally used to seeing DMI lists outside of functions.
> > > 
> > > OK.
> > > 
> > > > > +	static const struct dmi_system_id rmv_paths[] = {
> > > > > +		{
> > > > > +			/*
> > > > > +			 * On Acer Aspire S5 the _RMV method for the
> > > > > +			 * Thunderbolt host router upstream port is not
> > > > > +			 * located directly under the device but it is
> > > > > +			 * instead placed a bit deeper in the hierarchy.
> > > > > +			 */
> > > > > +			.ident = "Acer Aspire S5",
> > > > > +			.matches = {
> > > > > +				DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
> > > > > +				DMI_MATCH(DMI_PRODUCT_NAME, "Aspire S5-391"),
> > > > > +			},
> > > > > +			.driver_data = "HRDN.EPUP._RMV",
> > > > 
> > > > Use .callback instead? ->
> > > > 
> > > > > +		},
> > > > > +		{ }
> > > > > +	};
> > > > > +	const struct dmi_system_id *id;
> > > > > +	unsigned long long removable;
> > > > > +	acpi_status status;
> > > > > +
> > > > > +	status = acpi_evaluate_integer(handle, "_RMV", NULL, &removable);
> > > > > +	if (ACPI_SUCCESS(status))
> > > > > +		return !!removable;
> > > > > +
> > > > > +	/* Try system specific quirks */
> > > > > +	id = dmi_first_match(rmv_paths);
> > > > > +	if (id && id->driver_data) {
> > > > 
> > > > -> And here do
> > > > 
> > > > 	if (id && id->callback)
> > > > 		return id->callback(id);
> > > 
> > > There is a problem with the above that we can't pass an ACPI handle to the
> > > callback function.
> > 
> > Ah, right.
> > 
> > Well, you can do
> > 
> > 	if (id && id->driver_data) {
> > 		bool (*callback)(acpi_handle) = id->driver_data;
> > 
> > 		return callback(handle);
> > 	}
> > 
> > although it's a bit hackish.
> 
> I'm thinking that passing just the path from driver_data might be simpler
> in this case ;-) But I'm fine with changing it to be a callback as well.

No, it probably isn't worth the effort for just one system.

> > > > 
> > > > > +		char path[64];
> > > > > +
> > > > > +		strlcpy(path, id->driver_data, sizeof(path));
> > 
> > BTW, why didn't you want to pass id->driver_data directly here?
> 
> acpi_evaluate_integer() takes acpi_string as parameter which is 'char *',
> not 'const char *'.
> 
> Doing:
> 
> 	.driver_data = "HRDN.EPUP._RMV",
> 
> might place that string to a read-only area (as it is constant), if I
> understand C correctly. So even though I know that acpi_evaluate_interger()
> doesn't change the parameter, there's no guarantee that it doesn't do that
> in the future.

I think you can safely assume that acpi_evaluate_integer() won't try to modify
path (there are too many places where string literals are passed to it).

IOW, please just pass id->driver_data to it.

> 
> > 
> > > > > +		status = acpi_evaluate_integer(handle, path, NULL, &removable);
> > > > > +		if (ACPI_SUCCESS(status))
> > > > > +			return !!removable;
> > > > > +	}
> > > > > +
> > > > > +	return false;
> > > > > +}
> > > > > +

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
