Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab3AUWxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:53:16 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48588 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab3AUWxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:53:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC][Update 2][PATCH 1/4] ACPI / PM: Export power states of ACPI devices via sysfs
Date: Mon, 21 Jan 2013 23:59:12 +0100
Message-ID: <1534168.00CkYCbeHv@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130121222647.GA19759@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <1549553.6X3t4kPb9k@vostro.rjw.lan> <20130121222647.GA19759@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 21, 2013 02:26:47 PM Greg Kroah-Hartman wrote:
> On Mon, Jan 21, 2013 at 11:27:32PM +0100, Rafael J. Wysocki wrote:
> > On Monday, January 21, 2013 12:53:05 PM Greg Kroah-Hartman wrote:
> > > On Mon, Jan 21, 2013 at 02:04:32PM +0100, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > 
> > > > Make it possible to retrieve the current power state of a device with
> > > > ACPI power management from user space via sysfs by adding a new
> > > > attribute power_state to the sysfs directory associated with the
> > > > struct acpi_device object representing the device's ACPI node.
> > > > 
> > > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > ---
> > > >  Documentation/ABI/testing/sysfs-devices-power_state |   21 ++++++++++++++
> > > >  drivers/acpi/scan.c                                 |   29 +++++++++++++++++++-
> > > >  2 files changed, 49 insertions(+), 1 deletion(-)
> > > > 
> > > > Index: linux-pm/drivers/acpi/scan.c
> > > > ===================================================================
> > > > --- linux-pm.orig/drivers/acpi/scan.c
> > > > +++ linux-pm/drivers/acpi/scan.c
> > > > @@ -178,6 +178,23 @@ err_out:
> > > >  }
> > > >  EXPORT_SYMBOL(acpi_bus_hot_remove_device);
> > > >  
> > > > +static ssize_t power_state_show(struct device *dev,
> > > > +				struct device_attribute *attr, char *buf)
> > > > +{
> > > > +	struct acpi_device *adev = to_acpi_device(dev);
> > > > +	int state;
> > > > +	int ret;
> > > > +
> > > > +	ret = acpi_device_get_power(adev, &state);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	return sprintf(buf, "%s %s\n", acpi_power_state_string(state),
> > > > +		       acpi_power_state_string(adev->power.state));
> > > > +}
> > > 
> > > You are showing 2 different things here in a single sysfs file, which is
> > > really frowned apon.  Any chance to split this up into two different
> > > sysfs files instead?
> > 
> > Well, I can, but I'm not sure how to call the other one.  "sw_power_state"
> > perhaps?
> 
> I don't know, as I'm not quite sure what it is supposed to represent :)

The first one is power state as read using _PSC or inferred from power
resources on/off configuration.  That's easy.

Now, if power resources are shared between two or more devices, it is possible
that one device will be in, say, D3hot from the software point of view, but its
real ("physical") power state will be different, because the other devices
still keep the shared resource "on".  In that case, if the "software" power
state of a device is lower-power (higher-number) than its real power state,
we know that that particular device doesn't prevent the shared resource from
being turned off.  This is good to know, I think. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
