Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab3LABLm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 20:11:42 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56704 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751425Ab3LABLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 20:11:40 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v2 04/10] PCI: Destroy pci dev only once
Date: Sun, 01 Dec 2013 02:24:33 +0100
Message-ID: <3611889.9a0SszCTpv@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAE9FiQUG-WV26o5MtM=QPfN1kEDGs4Li2wdGB88T==yrxGum_w@mail.gmail.com>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org> <1574386.HU3xxHAoDX@vostro.rjw.lan> <CAE9FiQUG-WV26o5MtM=QPfN1kEDGs4Li2wdGB88T==yrxGum_w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 30, 2013 02:27:15 PM Yinghai Lu wrote:
> On Sat, Nov 30, 2013 at 1:37 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Saturday, November 30, 2013 01:31:33 AM Rafael J. Wysocki wrote:
> >> On Saturday, November 30, 2013 12:45:55 AM Rafael J. Wysocki wrote:
> >> > On Saturday, November 30, 2013 12:38:26 AM Rafael J. Wysocki wrote:
> >> > > On Tuesday, November 26, 2013 06:26:54 PM Yinghai Lu wrote:
> >> > > > On Tue, Nov 26, 2013 at 5:24 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >> > > > >
> >> > > > > So assume pci_destroy_dev() is called twice in parallel for the same dev
> >> > > > > by two different threads.  Thread 1 does the atomic_inc_and_test() and
> >> > > > > finds that it is OK to do the device_del() and put_device() which causes
> >> > > > > the device object to be freed.  Then thread 2 does the atomic_inc_and_test()
> >> > > > > on the already freed device object and crashes the kernel.
> >> > > > >
> >> > > > thread2 should still hold one extra reference.
> >> > > > that is in
> >> > > >   device_schedule_callback
> >> > > >      ==> sysfs_schedule_callback
> >> > > >          ==> kobject_get(kobj)
> >> > > >
> >> > > > pci_destroy_dev for thread2 is called at this point.
> >> > > >
> >> > > > and that reference will be released from
> >> > > >         sysfs_schedule_callback
> >> > > >         ==> kobject_put()...
> >> > >
> >> > > Well, that would be the case if thread 2 was started by device_schedule_callback(),
> >> > > but again, for example, it may be trim_stale_devices() started by acpiphp_check_bridge()
> >> > > that doesn't hold extra references to the pci_dev.  [Well, that piece of code
> >> > > is racy anyway, because it walks bus->devices without locking.  Which is my
> >> > > fault too, because I overlooked that.  Shame, shame.]
> >> > >
> 
> can you add extra reference to that path?

hotplug_event_work()
	hotplug_event()
		acpiphp_check_bridge()
			trim_stale_devices()
				pci_stop_and_remove_bus_device()

Yes, it should hold a reference to dev, but adding it there doesn't really help,
because there are list walks over &bus->devices in acpiphp_check_bridge() and
trim_stale_devices() that are racy with respect to pci_stop_and_remove_bus_device()
run from device_schedule_callback().

> >> > > Perhaps we can do something like the (untested) patch below (in addition to the
> >> > > $subject patch).  Do you see any immediate problems with it?
> >> >
> >> > Ah, I see one.  It will break pci_stop_bus_device() and pci_remove_bus_device().
> >> > So much for being clever.
> >> >
> >> > Moreover, it looks like those two routines above are racy too for the same
> >> > reason?
> >>
> >> The (still untested) patch below is what I have come up with for now.  The
> >> is_gone flag is now only operated under pci_remove_rescan_mutex, so it need
> >> not be atomic.  Of course, whoever calls pci_stop_and_remove_bus_device()
> >> (the "locked" one) should hold a ref to the device being removed to avoid
> >> use-after-free (the callers need to be audited for that).
> 
> if you can use device_schedule_...,

No, I can't.  I need to hold acpi_scan_lock taken in hotplug_event_work()
throughout all bus trimming/scanning and I need to protect list walks over
&bus->devices too.

> should have hold reference may be
> atomic would be better than lock/unlock everywhere?

The locking is necessary not only for the device removal itself, but also for
the safety of the &bus->devices list walks.

Besides, remove_callback() in remove.c already holds pci_remove_rescan_mutex
around pci_stop_and_remove_bus_device() and I don't see how it would be safe
to run pci_stop_and_remove_bus_device() without holding that mutex from
anywhere else.

For one example, pci_stop_and_remove_bus_device() that is not run under
pci_remove_rescan_mutex can race with the stuff called under that mutex
in dev_bus_rescan_store() (and elsewhere in pci-sysfs.c).

So either pci_remove_rescan_mutex is useless and should be dropped, or
it is there for a purpose, in which case it needs to be used around
pci_stop_and_remove_bus_device() everywhere.  There's no other possibility
and to my eyes that mutex is necessary.

Thanks,
Rafael

