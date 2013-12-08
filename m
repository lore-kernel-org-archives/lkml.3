Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3LHDtU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 22:49:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab3LHDtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 22:49:18 -0500
Date: Sat, 7 Dec 2013 19:50:47 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Myron Stowe <myron.stowe@gmail.com>
Subject: Re: [PATCH v2 04/10] PCI: Destroy pci dev only once
Message-ID: <20131208035047.GB17629@kroah.com>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
 <33026900.FbCAopDPFz@vostro.rjw.lan>
 <CAE9FiQV1KvpzfTmzbERS8heAE1z5zf=CjXnnjS9ZMBqmhY7rkw@mail.gmail.com>
 <1519414.GDlGZFCTSR@vostro.rjw.lan>
 <CAE9FiQX0zvtfAW-0-aPjXyVuFzxg6PMtY9O_7csqEzyW2pr5Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQX0zvtfAW-0-aPjXyVuFzxg6PMtY9O_7csqEzyW2pr5Kw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 07, 2013 at 07:31:21PM -0800, Yinghai Lu wrote:
> [+ GregKH]
> 
> On Fri, Dec 6, 2013 at 5:27 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Thursday, December 05, 2013 10:52:36 PM Yinghai Lu wrote:
> >> On Mon, Dec 2, 2013 at 6:49 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >> >
> >> > Scenario 5: pci_stop_and_remove_bus_device() is run concurrently
> >> >   for a device and its parent bridge via remove_callback().
> >> >
> >> >   In that case both code paths attempt to acquire
> >> >   pci_remove_rescan_mutex.  If the child device removal acquires
> >> >   it first, there will be no problems.  However, if the parent
> >> >   bridge removal acquires it first, it will eventually execute
> >> >   pci_destroy_dev() for the child device, but that device will
> >> >   not be freed yet due to the reference held by the concurrent
> >> >   child removal.  Consequently, both pci_stop_bus_device() and
> >> >   pci_remove_bus_device() will be executed for that device
> >> >   unnecessarily and pci_destroy_dev() will see a corrupted list
> >> >   head in that object.  Moreover, an excess put_device() will
> >> >   be executed for that device in that case which may lead to a
> >> >   use-after-free in the final kobject_put() done by
> >> >   sysfs_schedule_callback_work().
> >> >
> >> > Index: linux-pm/include/linux/pci.h
> >> > ===================================================================
> >> > --- linux-pm.orig/include/linux/pci.h
> >> > +++ linux-pm/include/linux/pci.h
> >> > @@ -321,6 +321,7 @@ struct pci_dev {
> >> >         unsigned int    multifunction:1;/* Part of multi-function device */
> >> >         /* keep track of device state */
> >> >         unsigned int    is_added:1;
> >> > +       unsigned int    is_gone:1;
> >> >         unsigned int    is_busmaster:1; /* device is busmaster */
> >> >         unsigned int    no_msi:1;       /* device may not use msi */
> >> >         unsigned int    block_cfg_access:1;     /* config space access is blocked */
> >> > Index: linux-pm/drivers/pci/remove.c
> >> > ===================================================================
> >> > --- linux-pm.orig/drivers/pci/remove.c
> >> > +++ linux-pm/drivers/pci/remove.c
> >> > @@ -34,6 +34,7 @@ static void pci_stop_dev(struct pci_dev
> >> >
> >> >  static void pci_destroy_dev(struct pci_dev *dev)
> >> >  {
> >> > +       dev->is_gone = 1;
> >> >         device_del(&dev->dev);
> >> >
> >> >         down_write(&pci_bus_sem);
> >> > @@ -109,8 +110,10 @@ static void pci_remove_bus_device(struct
> >> >   */
> >> >  void pci_stop_and_remove_bus_device(struct pci_dev *dev)
> >> >  {
> >> > -       pci_stop_bus_device(dev);
> >> > -       pci_remove_bus_device(dev);
> >> > +       if (!dev->is_gone) {
> >> > +               pci_stop_bus_device(dev);
> >> > +               pci_remove_bus_device(dev);
> >> > +       }
> >> >  }
> >> >  EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
> >> >
> >>
> >> Yes, above change should address sys double remove problem.
> >
> > I've just realized that we don't need a new flag for that, though.
> >
> > It looks like we only need to check dev->dev.kobj.parent and return if that is
> > NULL, because that means pci_destroy_dev() has run for that device already
> > (I'm wondering why device_del() doesn't clear dev->parent, BTW, it looks like
> > it should do that?).
> >
> > Of course, that still is going to be racy if we don't hold
> > pci_remove_rescan_mutex around pci_stop_and_remove_bus_device() in every code
> > path using it (or use another similar synchronization mechanism).
> 
> Wonder if we can have safe way to check if device_del() is called already.

Nope.

> And those access_after_free should be addressed by driver core instead
> of pci code?

Nope, it's up to the bus to handle this.  It shouldn't be hard, you
shouldn't actually care about this, if you do, something is wrong.

How is this PCI code so hard to get right?  Look at USB for devices that
disappear from anywhere at anytime as an example for how to handle
this.  PCI should be doing the same thing, no need for this "is_gone"
stuff.

greg k-h
