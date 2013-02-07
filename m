Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945965Ab3BGXBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 18:01:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383Ab3BGXBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 18:01:47 -0500
Message-ID: <1360277398.8412.16.camel@ul30vt.home>
Subject: Re: DMAR faults from unrelated device when vfio is used
From: Alex Williamson <alex.williamson@redhat.com>
To: Richard Weinberger <richard@sigma-star.at>
Cc: David Gstir <david@sigma-star.at>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 07 Feb 2013 15:49:58 -0700
In-Reply-To: <20130207232311.27a5600a@spider.haslach.nod.at>
References: <1359972630.2498.21.camel@riven-lux.site>
	 <1359992968.11144.414.camel@bling.home>
	 <1360071110.6200.19.camel@riven-lux.site>
	 <1360078648.11144.558.camel@bling.home>
	 <1360096613.11144.612.camel@bling.home>
	 <20130206190908.79073124@spider.haslach.nod.at>
	 <1360176440.11144.676.camel@bling.home>
	 <20130206212553.667e6d8b@spider.haslach.nod.at>
	 <1360190737.11144.731.camel@bling.home>
	 <20130207232311.27a5600a@spider.haslach.nod.at>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 23:23 +0100, Richard Weinberger wrote:
> Hi,
> 
> Am Wed, 06 Feb 2013 15:45:37 -0700
> schrieb Alex Williamson <alex.williamson@redhat.com>:
> 
> > On Wed, 2013-02-06 at 21:25 +0100, Richard Weinberger wrote:
> > > Hi,
> > > 
> > > Am Wed, 06 Feb 2013 11:47:20 -0700
> > > schrieb Alex Williamson <alex.williamson@redhat.com>: 
> > > > Does the card work with pci-assign or are both broken?
> > > 
> > > It works with pci-assign. :-\
> > 
> > When you tested this, did you detach the group from vfio or use it as
> > is?  In your previous message I see this:
> 
> I've detached it.
> 
> > 03:00.0 USB controller [0c03]: NEC Corporation uPD720200 USB 3.0 Host
> > Controller [1033:0194] (rev ff)
> > 
> > /sys/kernel/iommu_groups/7/devices:
> > total 0
> > lrwxrwxrwx 1 root root 0 Feb  4 10:29 0000:00:1c.0
> > -> ../../../../devices/pci0000:00/0000:00:1c.0 lrwxrwxrwx 1 root root
> > 0 Feb  4 10:29 0000:00:1c.6
> > -> ../../../../devices/pci0000:00/0000:00:1c.6 lrwxrwxrwx 1 root root
> > 0 Feb  4 10:29 0000:03:00.0
> > -> ../../../../devices/pci0000:00/0000:00:1c.6/0000:03:00.0
> > 
> > This seemed like a good card to have in my test cache, so I went and
> > got one and it works fine for me... but I've been playing with
> > pcieport because I don't think we're handling them correctly in vfio.
> > 
> > Can you provide lspci -vvv -s 1c.6 while the guest is running?  I'm
> > going to bet that
> > 
> > Control: I/O+ Mem+ BusMaster+
> 
> Do you want "lspci -vvv -s 1c.6" after attaching 1c.6 to vfio and not
> using pci-assign?

Was looking for while attached to vfio with the guest running after xhci
has failed to attach to it, but it's not really necessary, I'm pretty
sure of the result given that it work when the root port is left alone.


> > is not set, which it would have been if pci-assign was tested without
> > the group bound to vfio.  I think the solution is going to be
> > something around white-listing pcieport, which you can easily test
> > with a kernel patch like this:
> > 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index 12c264d..48a97fb 100644
> > --- a/drivers/vfio/vfio.c
> > +++ b/drivers/vfio/vfio.c
> > @@ -442,7 +442,7 @@ static struct vfio_device
> > *vfio_group_get_device(struct vfio
> >   * a device.  It's not always practical to leave a device within a
> > group
> >   * driverless as it could get re-bound to something unsafe.
> >   */
> > -static const char * const vfio_driver_whitelist[] = { "pci-stub" };
> > +static const char * const vfio_driver_whitelist[] = { "pci-stub",
> > "pcieport" }; 
> >  static bool vfio_whitelisted_driver(struct device_driver *drv)
> >  {
> 
> If I whitelist pcieport USB3 works within the guests. :-)
> Binding 1c.0 and 1c.6 is no longer needed.
> Next week I'll run some more tests with USB3 devices.

Great!  Thanks for the test.  I assume you didn't need to do anything
with unbinding pciehp?

Alex

