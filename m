Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab3AVX6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:58:53 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60706 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3AVX6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:58:49 -0500
Date: Tue, 22 Jan 2013 15:58:45 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 1/4] ACPI / PM: Expose power states of ACPI devices to
 user space
Message-ID: <20130122235845.GA1223@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan>
 <4706454.hY2fLkUfhN@vostro.rjw.lan>
 <20130122234718.GC694@kroah.com>
 <10095480.LFKcHvtS1j@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10095480.LFKcHvtS1j@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 01:01:17AM +0100, Rafael J. Wysocki wrote:
> On Tuesday, January 22, 2013 03:47:18 PM Greg Kroah-Hartman wrote:
> > On Tue, Jan 22, 2013 at 03:25:15AM +0100, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > Make it possible to retrieve the current power state of a device with
> > > ACPI power management from user space via sysfs by adding two new
> > > attributes, power_state and real_power_state, to the sysfs directory
> > > associated with the struct acpi_device object representing the
> > > device's ACPI node.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > ---
> > >  Documentation/ABI/testing/sysfs-devices-power_state      |   20 ++++++
> > >  Documentation/ABI/testing/sysfs-devices-real_power_state |   23 +++++++
> > >  drivers/acpi/scan.c                                      |   49 ++++++++++++++-
> > >  3 files changed, 91 insertions(+), 1 deletion(-)
> > > 
> > > Index: linux-pm/drivers/acpi/scan.c
> > > ===================================================================
> > > --- linux-pm.orig/drivers/acpi/scan.c
> > > +++ linux-pm/drivers/acpi/scan.c
> > > @@ -178,6 +178,32 @@ err_out:
> > >  }
> > >  EXPORT_SYMBOL(acpi_bus_hot_remove_device);
> > >  
> > > +static ssize_t real_power_state_show(struct device *dev,
> > > +				     struct device_attribute *attr, char *buf)
> > > +{
> > > +	struct acpi_device *adev = to_acpi_device(dev);
> > > +	int state;
> > > +	int ret;
> > > +
> > > +	ret = acpi_device_get_power(adev, &state);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	return sprintf(buf, "%s\n", acpi_power_state_string(state));
> > > +}
> > > +
> > > +static DEVICE_ATTR(real_power_state, 0444, real_power_state_show, NULL);
> > > +
> > > +static ssize_t power_state_show(struct device *dev,
> > > +				struct device_attribute *attr, char *buf)
> > > +{
> > > +	struct acpi_device *adev = to_acpi_device(dev);
> > > +
> > > +	return sprintf(buf, "%s\n", acpi_power_state_string(adev->power.state));
> > > +}
> > > +
> > > +static DEVICE_ATTR(power_state, 0444, power_state_show, NULL);
> > > +
> > >  static ssize_t
> > >  acpi_eject_store(struct device *d, struct device_attribute *attr,
> > >  		const char *buf, size_t count)
> > > @@ -369,8 +395,22 @@ static int acpi_device_setup_files(struc
> > >           * hot-removal function from userland.
> > >           */
> > >  	status = acpi_get_handle(dev->handle, "_EJ0", &temp);
> > > -	if (ACPI_SUCCESS(status))
> > > +	if (ACPI_SUCCESS(status)) {
> > >  		result = device_create_file(&dev->dev, &dev_attr_eject);
> > > +		if (result)
> > > +			return result;
> > > +	}
> > > +
> > > +	if (dev->flags.power_manageable) {
> > > +		result = device_create_file(&dev->dev, &dev_attr_power_state);
> > > +		if (result)
> > > +			return result;
> > > +
> > > +		if (dev->power.flags.power_resources)
> > > +			result = device_create_file(&dev->dev,
> > > +						    &dev_attr_real_power_state);
> > > +	}
> > > +
> > 
> > It isn't your fault, but I just noticed this when reading patch 2/4, but
> > I think you are racing userspace here.  The device is registered,
> > userspace is notified that the device is present, and _then_ the acpi
> > core creates the sysfs files for the device.
> > 
> > That's not good, and needs to be fixed, especially now that you are
> > adding more and more sysfs files for these ACPI devices.
> > 
> > To do that, you need to set up "default" files for ACPI devices, they
> > can be enabled or not by the driver core, and will be created before the
> > event that the device is created is sent to userspace.
> > 
> > Care to fix that all up in a follow-on patchset before some tools start
> > to get confused?
> 
> I will.
> 
> That's kind of has been happening for quite a long time, though, as far as
> I can say, so confusion would have ensued already before.  Not that I think
> it's not worth fixing, to be sure. :-)

Odds are, not many people have been paying attention to acpi devices,
but now that you are adding "useful" information in their sysfs files,
tools will be written to access that information, so they are the ones
that will start getting confused.

> So acpi_device_setup_files() is called too late already, right?

Yes.  But see my email for the 4/4 patch, at the end, there is a
"simple" fix for this that you can do that is much easier than reworking
all of this.

thanks,

greg k-h
