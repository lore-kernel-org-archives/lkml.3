Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab3LJHnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:43:42 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:49841 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3LJHnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:43:39 -0500
MIME-Version: 1.0
In-Reply-To: <20131209190807.GA23877@kroah.com>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
	<33026900.FbCAopDPFz@vostro.rjw.lan>
	<CAE9FiQV1KvpzfTmzbERS8heAE1z5zf=CjXnnjS9ZMBqmhY7rkw@mail.gmail.com>
	<1519414.GDlGZFCTSR@vostro.rjw.lan>
	<CAE9FiQX0zvtfAW-0-aPjXyVuFzxg6PMtY9O_7csqEzyW2pr5Kw@mail.gmail.com>
	<20131208035047.GB17629@kroah.com>
	<CABawtvO91R0wBL5XZf6xM8Rmray50Fjc74=iA9Y+XdeD7FsNwg@mail.gmail.com>
	<20131209190807.GA23877@kroah.com>
Date: Tue, 10 Dec 2013 15:43:38 +0800
Message-ID: <CABawtvMvkgQdL+eyFrCsC6GRyx6VDOG=Oh2cY7y=bdtNkmu2Vw@mail.gmail.com>
Subject: Re: [PATCH v2 04/10] PCI: Destroy pci dev only once
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Myron Stowe <myron.stowe@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 3:08 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Dec 09, 2013 at 11:24:04PM +0800, Ethan Zhao wrote:
>> On Sun, Dec 8, 2013 at 11:50 AM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Sat, Dec 07, 2013 at 07:31:21PM -0800, Yinghai Lu wrote:
>> >> [+ GregKH]
>> >>
>> >> On Fri, Dec 6, 2013 at 5:27 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> >> > On Thursday, December 05, 2013 10:52:36 PM Yinghai Lu wrote:
>> >> >> On Mon, Dec 2, 2013 at 6:49 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> >> >> >
>> >> >> > Scenario 5: pci_stop_and_remove_bus_device() is run concurrently
>> >> >> >   for a device and its parent bridge via remove_callback().
>> >> >> >
>> >> >> >   In that case both code paths attempt to acquire
>> >> >> >   pci_remove_rescan_mutex.  If the child device removal acquires
>> >> >> >   it first, there will be no problems.  However, if the parent
>> >> >> >   bridge removal acquires it first, it will eventually execute
>> >> >> >   pci_destroy_dev() for the child device, but that device will
>> >> >> >   not be freed yet due to the reference held by the concurrent
>> >> >> >   child removal.  Consequently, both pci_stop_bus_device() and
>> >> >> >   pci_remove_bus_device() will be executed for that device
>> >> >> >   unnecessarily and pci_destroy_dev() will see a corrupted list
>> >> >> >   head in that object.  Moreover, an excess put_device() will
>> >> >> >   be executed for that device in that case which may lead to a
>> >> >> >   use-after-free in the final kobject_put() done by
>> >> >> >   sysfs_schedule_callback_work().
>> >> >> >
>> >> >> > Index: linux-pm/include/linux/pci.h
>> >> >> > ===================================================================
>> >> >> > --- linux-pm.orig/include/linux/pci.h
>> >> >> > +++ linux-pm/include/linux/pci.h
>> >> >> > @@ -321,6 +321,7 @@ struct pci_dev {
>> >> >> >         unsigned int    multifunction:1;/* Part of multi-function device */
>> >> >> >         /* keep track of device state */
>> >> >> >         unsigned int    is_added:1;
>> >> >> > +       unsigned int    is_gone:1;
>> >> >> >         unsigned int    is_busmaster:1; /* device is busmaster */
>> >> >> >         unsigned int    no_msi:1;       /* device may not use msi */
>> >> >> >         unsigned int    block_cfg_access:1;     /* config space access is blocked */
>> >> >> > Index: linux-pm/drivers/pci/remove.c
>> >> >> > ===================================================================
>> >> >> > --- linux-pm.orig/drivers/pci/remove.c
>> >> >> > +++ linux-pm/drivers/pci/remove.c
>> >> >> > @@ -34,6 +34,7 @@ static void pci_stop_dev(struct pci_dev
>> >> >> >
>> >> >> >  static void pci_destroy_dev(struct pci_dev *dev)
>> >> >> >  {
>> >> >> > +       dev->is_gone = 1;
>> >> >> >         device_del(&dev->dev);
>> >> >> >
>> >> >> >         down_write(&pci_bus_sem);
>> >> >> > @@ -109,8 +110,10 @@ static void pci_remove_bus_device(struct
>> >> >> >   */
>> >> >> >  void pci_stop_and_remove_bus_device(struct pci_dev *dev)
>> >> >> >  {
>> >> >> > -       pci_stop_bus_device(dev);
>> >> >> > -       pci_remove_bus_device(dev);
>> >> >> > +       if (!dev->is_gone) {
>> >> >> > +               pci_stop_bus_device(dev);
>> >> >> > +               pci_remove_bus_device(dev);
>> >> >> > +       }
>> >> >> >  }
>> >> >> >  EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
>> >> >> >
>> >> >>
>> >> >> Yes, above change should address sys double remove problem.
>> >> >
>> >> > I've just realized that we don't need a new flag for that, though.
>> >> >
>> >> > It looks like we only need to check dev->dev.kobj.parent and return if that is
>> >> > NULL, because that means pci_destroy_dev() has run for that device already
>> >> > (I'm wondering why device_del() doesn't clear dev->parent, BTW, it looks like
>> >> > it should do that?).
>> >> >
>> >> > Of course, that still is going to be racy if we don't hold
>> >> > pci_remove_rescan_mutex around pci_stop_and_remove_bus_device() in every code
>> >> > path using it (or use another similar synchronization mechanism).
>> >>
>> >> Wonder if we can have safe way to check if device_del() is called already.
>> >
>> > Nope.
>> >
>> >> And those access_after_free should be addressed by driver core instead
>> >> of pci code?
>> >
>> > Nope, it's up to the bus to handle this.  It shouldn't be hard, you
>> > shouldn't actually care about this, if you do, something is wrong.
>> >
>> > How is this PCI code so hard to get right?  Look at USB for devices that
>> > disappear from anywhere at anytime as an example for how to handle
>> > this.  PCI should be doing the same thing, no need for this "is_gone"
>> > stuff.
>> Greg,
>>
>>   Don't agree USB is a good example to follow, do you never hit panic
>> when you pull out USB device from anywhere at anytime without unmount
>> or stop it via command ?
>
> You shouldn't.  If you do, it's a bug, let us know and we will fix it.

Of coz, next time hit, bore you with a calltrace.

>
>> that is not truth.  the truth is none regards it as enterprise level
>> interface to attach devices.
>
> Huh?

USB 3.0 still not fast enough for enterprise level.
>
>>   Is there a feature for an USB disk to tell the host you want to pull
>> out it and should sync all the data in cache and unmount the files
>> system then power it off ?
>
> Nope, neither is there one for when I yank out my PCI storage device
> without telling the OS about it either.  Everything better "just work",
> with the exception of any lost data that might be in flight.

To a desktop, you do have option to issue 'sync, umount' and pull out
the device and it 'just work',
To a server, someone wouldn't stand for any data lost in flight.  USB
need additional feature added
for you to tell udev sync data etc without a console in hand.

>
>>   What USB could drive for us ? 40GB nic ? infiniband ? High end graphic card ?
>
> I don't understand what that means at all.

Don't be sleepy, man, you know USB is not powerful enough today, just
as you said, someday,
all the outdated thing will go away, just like those ISA, VESA, we
don't care the low level data link layer anymore. but today, PCIe is
still a little more complex/out than USB to handle.

Thanks,
Ethan
>
> We have USB network ethernet devices, I have a USB 3.0 one here that
> works really well.  Infiniband is merely a transport, with some "verbs"
> on top of it, that has nothing to do with PCI other than you can have a
> IB PCI controller in the system.  And I have a USB graphics adapter here
> that works just fine as well (people chain lots of them on one system.)
>
> So how does this apply to PCI at all?  It's the same thing, you have to
> be able to handle a PCI device going away at any point in time, with or
> without telling the OS ahead of time that you are going to remove it.
>
> greg k-h
