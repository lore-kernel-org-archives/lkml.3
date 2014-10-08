Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbaJHMTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 08:19:18 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:45579 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbaJHMTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 08:19:15 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:f1a8:15e8:7d5b:8344]
In-Reply-To: <20140926153751.GW5182@n2100.arm.linux.org.uk>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
 <1411483586-29304-8-git-send-email-a.motakis@virtualopensystems.com> <20140926153751.GW5182@n2100.arm.linux.org.uk>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Wed, 8 Oct 2014 14:18:54 +0200
Message-ID: <CAG8rG2wbhJZiLw+hh_ZhRnMmpNxKWxUaXoU0Tzkpk7ooiUs6mw@mail.gmail.com>
Subject: Re: [PATCHv7 07/26] driver core: amba: add device binding path 'driver_override'
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        KVM devel mailing list <kvm@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Kim Phillips <kim.phillips@freescale.com>,
        Eric Auger <eric.auger@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 5:37 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
>
> On Tue, Sep 23, 2014 at 04:46:06PM +0200, Antonios Motakis wrote:
> > As already demonstrated with PCI [1] and the platform bus [2], a
> > driver_override property in sysfs can be used to bypass the id matching
> > of a device to a AMBA driver. This can be used by VFIO to bind to any AMBA
> > device requested by the user.
> >
> > [1] http://lists-archives.com/linux-kernel/28030441-pci-introduce-new-device-binding-path-using-pci_dev-driver_override.html
> > [2] https://www.redhat.com/archives/libvir-list/2014-April/msg00382.html
> >
> > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>
> I have to ask why this is even needed in the first place.  To take the
> example in [2], what's wrong with:
>
> echo fff51000.ethernet > /sys/bus/platform/devices/fff51000.ethernet/driver/unbind
> echo fff51000.ethernet > /sys/bus/platform/drivers/vfio-platform/bind
>
> and similar for AMBA.
>
> All we would need to do is to introduce a way of having a driver accept
> explicit bind requests.
>
> In any case:
>
> > +static ssize_t driver_override_store(struct device *_dev,
> > +                                  struct device_attribute *attr,
> > +                                  const char *buf, size_t count)
> > +{
> > +     struct amba_device *dev = to_amba_device(_dev);
> > +     char *driver_override, *old = dev->driver_override, *cp;
> > +
> > +     if (count > PATH_MAX)
> > +             return -EINVAL;
> > +
> > +     driver_override = kstrndup(buf, count, GFP_KERNEL);
> > +     if (!driver_override)
> > +             return -ENOMEM;
> > +
> > +     cp = strchr(driver_override, '\n');
> > +     if (cp)
> > +             *cp = '\0';
>
> I hope that is not replicated everywhere.  This allows up to a page to be
> allocated, even when the first byte may be a newline.  This is wasteful.
>
> How about:
>
>         if (count > PATH_MAX)
>                 return -EINVAL;
>
>         cp = strnchr(buf, count, '\n');
>         if (cp)
>                 count = cp - buf - 1;
>
>         if (count) {
>                 driver_override = kstrndup(buf, count, GFP_KERNEL);
>                 if (!driver_override)
>                         return -ENOMEM;
>         } else {
>                 driver_override = NULL;
>         }
>
>         kfree(dev->driver_override);
>         dev->driver_override = driver_override;

I implemented something along this lines and tested it a bit. The
kernel already splits the input by newlines, and the function is being
called for each one separately; so this change doesn't save any
memory.

>
> Also:
>
> > +static ssize_t driver_override_show(struct device *_dev,
> > +                                 struct device_attribute *attr, char *buf)
> > +{
> > +     struct amba_device *dev = to_amba_device(_dev);
> > +
> > +     return sprintf(buf, "%s\n", dev->driver_override);
> > +}
>
> Do we really want to do a NULL pointer dereference here?
>
> --
> FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
> according to speedtest.net.




-- 
Antonios Motakis
Virtual Open Systems
