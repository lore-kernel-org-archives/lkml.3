Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab3LEWi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 17:38:26 -0500
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:53108
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877Ab3LEWiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 17:38:25 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(z579ehz98dI936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097h186068hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
Message-ID: <1386283095.7375.63.camel@snotra.buserror.net>
Subject: Re: [REPOST][PATCH 1/2] driver core: Add new device_driver flag to
 allow binding via sysfs only
From: Scott Wood <scottwood@freescale.com>
To: Kim Phillips <kim.phillips@linaro.org>
CC: <jan.kiszka@siemens.com>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <kvm@vger.kernel.org>,
        <R65777@freescale.com>, <B07421@freescale.com>, <B08248@freescale.com>,
        <christoffer.dall@linaro.org>, <alex.williamson@redhat.com>,
        <a.motakis@virtualopensystems.com>, <agraf@suse.de>,
        <B16395@freescale.com>
Date: Thu, 5 Dec 2013 16:38:15 -0600
In-Reply-To: <20131205174530.a1d6e763e423d3baaa5992ad@linaro.org>
References: <20131203123446.42fbff34a8ebd7afd38159a5@linaro.org>
	 <529DFA09.1030707@siemens.com>
	 <20131205174530.a1d6e763e423d3baaa5992ad@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-05 at 17:45 +0000, Kim Phillips wrote:
> On Tue, 03 Dec 2013 16:34:33 +0100
> Jan Kiszka <jan.kiszka@siemens.com> wrote:
> 
> > On 2013-12-03 13:34, Kim Phillips wrote:
> > > VFIO supports pass-through of devices to user space - for sake
> > > of illustration, say a PCI e1000 device:
> > > 
> > > - the e1000 is first unbound from the PCI e1000 driver via sysfs
> > > - the vfio-pci driver is told via new_id that it now handles e1000 devices
> > > - the e1000 is explicitly bound to vfio-pci through sysfs
> > > 
> > > However, now we have two drivers in the system that both handle e1000
> > > devices.  A hotplug event could then occur and it is ambiguous as to which
> > > driver will claim the device.  The desired semantics is that vfio-pci is
> > > only bound to devices by explicit request in sysfs.  This patch makes this
> > > possible by introducing a sysfs_bind_only flag in struct device_driver.
> > > 
> > > Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
> > > Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
> > > ---
> > > rebased onto 3.13-rc2, and reposted from first submission which
> > > recieved no comments:
> > > 
> > > https://lkml.org/lkml/2013/10/11/53
> > > 
> > >  drivers/base/dd.c      | 5 ++++-
> > >  include/linux/device.h | 2 ++
> > >  2 files changed, 6 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> > > index 0605176..b83b16d 100644
> > > --- a/drivers/base/dd.c
> > > +++ b/drivers/base/dd.c
> > > @@ -389,7 +389,7 @@ static int __device_attach(struct device_driver *drv, void *data)
> > >  {
> > >  	struct device *dev = data;
> > >  
> > > -	if (!driver_match_device(drv, dev))
> > > +	if (drv->sysfs_bind_only || !driver_match_device(drv, dev))
> > >  		return 0;
> > >  
> > >  	return driver_probe_device(drv, dev);
> > > @@ -476,6 +476,9 @@ static int __driver_attach(struct device *dev, void *data)
> > >   */
> > >  int driver_attach(struct device_driver *drv)
> > >  {
> > > +	if (drv->sysfs_bind_only)
> > > +		return 0;
> > > +
> > >  	return bus_for_each_dev(drv->bus, NULL, drv, __driver_attach);
> > >  }
> > >  EXPORT_SYMBOL_GPL(driver_attach);
> > > diff --git a/include/linux/device.h b/include/linux/device.h
> > > index 952b010..ed441d1 100644
> > > --- a/include/linux/device.h
> > > +++ b/include/linux/device.h
> > > @@ -200,6 +200,7 @@ extern struct klist *bus_get_device_klist(struct bus_type *bus);
> > >   * @owner:	The module owner.
> > >   * @mod_name:	Used for built-in modules.
> > >   * @suppress_bind_attrs: Disables bind/unbind via sysfs.
> > > + * @sysfs_bind_only: Only allow bind/unbind via sysfs.
> > >   * @of_match_table: The open firmware table.
> > >   * @acpi_match_table: The ACPI match table.
> > >   * @probe:	Called to query the existence of a specific device,
> > > @@ -233,6 +234,7 @@ struct device_driver {
> > >  	const char		*mod_name;	/* used for built-in modules */
> > >  
> > >  	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
> > > +	bool sysfs_bind_only;		/* only allow bind/unbind via sysfs */
> > >  
> > >  	const struct of_device_id	*of_match_table;
> > >  	const struct acpi_device_id	*acpi_match_table;
> > 
> > I think I only discussed this with Stuart in person at the KVM Forum:
> > Why not deriving the property "sysfs bind only" from the fact that a
> > device does wild-card binding? Are there use cases that benefit from
> > decoupling both features?
> 
> you mean merge the two new flags sysfs_bind_only and platform driver's
> match_any_dev into one new single driver flag, right?  good question.

What would combining them solve, other than making it more likely that
Greg complains about the wildcard because it would no longer be handled
at the bus level where all the other matching goes on?

They are logically separate things.  That doesn't change just because we
currently plan to use them together.

-Scott



