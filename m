Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab3LSCk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 21:40:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab3LSCkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 21:40:24 -0500
Date: Wed, 18 Dec 2013 17:04:10 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kim Phillips <kim.phillips@linaro.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, scottwood@freescale.com, R65777@freescale.com,
        B07421@freescale.com, B08248@freescale.com,
        christoffer.dall@linaro.org, alex.williamson@redhat.com,
        a.motakis@virtualopensystems.com, agraf@suse.de, B16395@freescale.com
Subject: Re: [REPOST][PATCH 1/2] driver core: Add new device_driver flag to
 allow binding via sysfs only
Message-ID: <20131219010410.GB23055@kroah.com>
References: <20131203123446.42fbff34a8ebd7afd38159a5@linaro.org>
 <529DFA09.1030707@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529DFA09.1030707@siemens.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 04:34:33PM +0100, Jan Kiszka wrote:
> On 2013-12-03 13:34, Kim Phillips wrote:
> > VFIO supports pass-through of devices to user space - for sake
> > of illustration, say a PCI e1000 device:
> > 
> > - the e1000 is first unbound from the PCI e1000 driver via sysfs
> > - the vfio-pci driver is told via new_id that it now handles e1000 devices
> > - the e1000 is explicitly bound to vfio-pci through sysfs
> > 
> > However, now we have two drivers in the system that both handle e1000
> > devices.  A hotplug event could then occur and it is ambiguous as to which
> > driver will claim the device.  The desired semantics is that vfio-pci is
> > only bound to devices by explicit request in sysfs.  This patch makes this
> > possible by introducing a sysfs_bind_only flag in struct device_driver.
> > 
> > Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
> > Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
> > ---
> > rebased onto 3.13-rc2, and reposted from first submission which
> > recieved no comments:
> > 
> > https://lkml.org/lkml/2013/10/11/53
> > 
> >  drivers/base/dd.c      | 5 ++++-
> >  include/linux/device.h | 2 ++
> >  2 files changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> > index 0605176..b83b16d 100644
> > --- a/drivers/base/dd.c
> > +++ b/drivers/base/dd.c
> > @@ -389,7 +389,7 @@ static int __device_attach(struct device_driver *drv, void *data)
> >  {
> >  	struct device *dev = data;
> >  
> > -	if (!driver_match_device(drv, dev))
> > +	if (drv->sysfs_bind_only || !driver_match_device(drv, dev))
> >  		return 0;
> >  
> >  	return driver_probe_device(drv, dev);
> > @@ -476,6 +476,9 @@ static int __driver_attach(struct device *dev, void *data)
> >   */
> >  int driver_attach(struct device_driver *drv)
> >  {
> > +	if (drv->sysfs_bind_only)
> > +		return 0;
> > +
> >  	return bus_for_each_dev(drv->bus, NULL, drv, __driver_attach);
> >  }
> >  EXPORT_SYMBOL_GPL(driver_attach);
> > diff --git a/include/linux/device.h b/include/linux/device.h
> > index 952b010..ed441d1 100644
> > --- a/include/linux/device.h
> > +++ b/include/linux/device.h
> > @@ -200,6 +200,7 @@ extern struct klist *bus_get_device_klist(struct bus_type *bus);
> >   * @owner:	The module owner.
> >   * @mod_name:	Used for built-in modules.
> >   * @suppress_bind_attrs: Disables bind/unbind via sysfs.
> > + * @sysfs_bind_only: Only allow bind/unbind via sysfs.
> >   * @of_match_table: The open firmware table.
> >   * @acpi_match_table: The ACPI match table.
> >   * @probe:	Called to query the existence of a specific device,
> > @@ -233,6 +234,7 @@ struct device_driver {
> >  	const char		*mod_name;	/* used for built-in modules */
> >  
> >  	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
> > +	bool sysfs_bind_only;		/* only allow bind/unbind via sysfs */
> >  
> >  	const struct of_device_id	*of_match_table;
> >  	const struct acpi_device_id	*acpi_match_table;
> > 
> 
> I think I only discussed this with Stuart in person at the KVM Forum:
> Why not deriving the property "sysfs bind only" from the fact that a
> device does wild-card binding? Are there use cases that benefit from
> decoupling both features?

The driver core does not know if a bus, or a device, handles "wild card"
binding, so you can't do it at this level, sorry.

greg k-h
