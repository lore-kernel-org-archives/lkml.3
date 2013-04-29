Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab3D2SVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:21:49 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:62283 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758503Ab3D2SVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:21:45 -0400
Date: Mon, 29 Apr 2013 11:21:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH] PCI: Fix racing for pci device removing via sysfs
Message-ID: <20130429182142.GA3385@kroah.com>
References: <1366940841-15370-1-git-send-email-yinghai@kernel.org>
 <CAErSpo5zfHR-agNBdgqfVjCU+-KcTZV+1bvML5Uw-+icDqzzEA@mail.gmail.com>
 <CAE9FiQVEQO-dLJRjn9Z7JgwGWAn1M8S1Tn2_V0Fq+6kB0rG=Bg@mail.gmail.com>
 <CAErSpo7DUDQ_XgVKAfWxqYJA=q85ps46bffV-4a7b0vOzAP5DA@mail.gmail.com>
 <CAE9FiQWv-bN2XzHiQ0WU+Y678zcqs_Owua6vXXijdMO6=0OWpg@mail.gmail.com>
 <517E45C8.4060407@cn.fujitsu.com>
 <CAE9FiQUXxCH0xjFPk1S7e_JRsBPosqQ=N5Kpcrjp3RNWDh9yZQ@mail.gmail.com>
 <20130429181550.GA17343@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429181550.GA17343@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 11:15:50AM -0700, Bjorn Helgaas wrote:
> On Mon, Apr 29, 2013 at 08:19:10AM -0700, Yinghai Lu wrote:
> > On Mon, Apr 29, 2013 at 3:04 AM, Gu Zheng <guz.fnst@cn.fujitsu.com> wrote:
> > > On 04/27/2013 05:01 AM, Yinghai Lu wrote:
> > >> On Fri, Apr 26, 2013 at 1:53 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > >>>
> > >>> You can't be serious.  This is a disgusting mess.  Checking a list
> > >>> pointer for LIST_POISON1?  As far as I'm concerned, this is a waste of
> > >>> my time.
> > 
> > looks like xhci is using that LIST_POISON1 ...
> > 
> > >> Well, then need to hold the bus ref, and check bus->devices list instead.
> > >
> > > @@ -341,6 +352,7 @@ remove_store(struct device *dev, struct
> > >  {
> > >         int err;
> > >         unsigned long val;
> > > +       struct pci_dev *pdev;
> > >
> > >         if (strict_strtoul(buf, 0, &val) < 0)
> > >                 return -EINVAL;
> > > @@ -351,9 +363,14 @@ remove_store(struct device *dev, struct
> > >         /* An attribute cannot be unregistered by one of its own methods,
> > >          * so we have to use this roundabout approach.
> > >          */
> > > +       pdev = pci_dev_get(to_pci_dev(dev));
> > >
> > > There is no need to increase pci_dev's ref here, because we'll increase it
> > > in sysfs_schedule_callback.
> > 
> > ok, i missed that. if we can use LIST_POISON, then could be more simple.
> > like -v4.
> 
> I inlined your v4 patch below for convenience.
> 
> Maybe my allergic reaction to your use of LIST_POISON1 is unjustified,
> but I am dubious about the idea that xhci was the only place that needed
> it before now, and we just happened to find one more place in PCI that
> needs it.  That doesn't make sense because good design patterns are used
> many times, not just once or twice.
> 
> I thought the whole point of the get/put scheme was that if we had a
> pointer to a correctly reference-counted object, we didn't need to check
> whether the object was still valid because the object remains valid until
> all the references are released.

You are correct, you shouldn't have to worry about that.  If you have to
do something like the LIST_POISON test, something is really wrong.

> Gu's "[v2 2/2] PCI: Convert alloc_pci_dev(void) to pci_alloc_dev(bus)"
> patch essentially did this:
> 
>     pci_destroy_dev(struct pci_dev *dev) {
>       ...
> +     pci_bus_put(dev->bus)
>       pci_free_resources(dev)
>       put_device(&dev->dev)
>     }
> 
> I think this is the wrong place to do the pci_bus_put() because the
> pci_dev is reference-counted, and there may be other users that still
> have valid references to it.

It should happen in the release function for the pci device, which will
handle other users of the device.

> In this case, 10:00.0 is a bridge leading to [bus 11-1e], and 1a:01.0 is
> part of that subtree.  The user removed both 10:00.0 and 1a:01.0 almost
> simultaneously via sysfs and we scheduled a callback for each.
> 
> Each callback acquires a pci_dev reference, and removal of 10:00.0 and the
> subtree below it, including pci_destroy_dev(1a:01.0), is done first.  The
> callback to remove 1a:01.0 is still pending and has a valid reference to
> the 1a:01.0 pci_dev.
> 
> Since the 1a:01.0 callback is still pending, the put_device in that first
> pci_destroy_dev(1a:01.0) call decrements the ref count but doesn't release
> the pci_dev.
> 
> I think the 1a:01.0 pci_dev should retain its reference to the pci_bus
> for as long as the pci_dev exists, so the pci_bus_put() should go in
> pci_release_dev() instead.

I agree, that should be the correct fix for this.

greg k-h
