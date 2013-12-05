Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab3LERpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:45:39 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:53792 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266Ab3LERpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:45:34 -0500
Date: Thu, 5 Dec 2013 17:45:30 +0000
From: Kim Phillips <kim.phillips@linaro.org>
To: jan.kiszka@siemens.com
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kvm@vger.kernel.org, scottwood@freescale.com, R65777@freescale.com,
        B07421@freescale.com, B08248@freescale.com,
        christoffer.dall@linaro.org, alex.williamson@redhat.com,
        a.motakis@virtualopensystems.com, agraf@suse.de, B16395@freescale.com
Subject: Re: [REPOST][PATCH 1/2] driver core: Add new device_driver flag to
 allow binding via sysfs only
Message-Id: <20131205174530.a1d6e763e423d3baaa5992ad@linaro.org>
In-Reply-To: <529DFA09.1030707@siemens.com>
References: <20131203123446.42fbff34a8ebd7afd38159a5@linaro.org>
	<529DFA09.1030707@siemens.com>
X-Mailer: Sylpheed 3.4.0beta5 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Dec 2013 16:34:33 +0100
Jan Kiszka <jan.kiszka@siemens.com> wrote:

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
> 
> I think I only discussed this with Stuart in person at the KVM Forum:
> Why not deriving the property "sysfs bind only" from the fact that a
> device does wild-card binding? Are there use cases that benefit from
> decoupling both features?

you mean merge the two new flags sysfs_bind_only and platform driver's
match_any_dev into one new single driver flag, right?  good question.

I can't think of any, given none of the built-in PCI drivers set ANY_ID
across the {sub}vendor/{sub}device/class{_mask} board for boot-time (or
hotplug) binding.  Technically it's possible with the pci_stub driver
by setting its 'ids' module parameter in the kernel command line, but
looking at the commit that adds 'ids', it was only meant to be used to
"prevent built-in drivers from attaching to specific devices," so it's
unlikely anyone would have it set to ANY_ID.

I'll look at what changes are necessary, barring anyone else coming up
with a valid use-case.

Kim
