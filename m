Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab3LFBI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 20:08:56 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58666 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751753Ab3LFBIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 20:08:51 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Myron Stowe <myron.stowe@gmail.com>
Subject: Re: [PATCH v2 04/10] PCI: Destroy pci dev only once
Date: Fri, 06 Dec 2013 02:21:50 +0100
Message-ID: <1992931.Zv6xBcN8V4@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAErSpo6edmz5nkSYogbYk1FFYsCCwNV_-rir2jGP2JBnvOx+iw@mail.gmail.com>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org> <33026900.FbCAopDPFz@vostro.rjw.lan> <CAErSpo6edmz5nkSYogbYk1FFYsCCwNV_-rir2jGP2JBnvOx+iw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 05, 2013 03:40:39 PM Bjorn Helgaas wrote:
> On Mon, Dec 2, 2013 at 7:49 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > ...
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: PCI / hotplug / ACPI: Fix concurrency problems related to device removal
> >
> > The following are concurrency problems related to the PCI device
> > removal code in pci-sysfs.c and in ACPIPHP present in the current
> > mainline kernel:
> 
> You've found a bunch of issues.  I don't think there's anything to
> gain by fixing them all in a single patch, and I think it would be
> useful to split them out to help us think about them and find other
> places that have similar problems.

The problem is that they are all related.  Whatever we decide to do with
one of them will likely affect how we deal with the others.

> > Scenario 1: pci_stop_and_remove_bus_device() run concurrently for
> >   the same top device from remove_callback() in pci-sysfs.c and
> >   from trim_stale_devices() in acpiphp_glue.c.
> >
> >   In this scenario the second code path is executed without
> >   pci_remove_rescan_mutex locked, so the &bus->devices list
> >   walks in either trim_stale_devices() itself or in
> >   acpiphp_check_bridge() can suffer from list corruption while the
> >   first code path is executing pci_destroy_dev() for one of the
> >   devices on those lists.
> 
> Protecting &bus->devices is a generic problem, isn't it?

Yes, it is.

In fact, there are two sides of it.  One is with read-only users (that is,
walking the list without modifying it) which should be done under read-locked
pci_bus_sem and that's quite obvious.  It looks like the majority of users of
that list are readers and they fall under this case.  That case is addressed
by write-locking pci_bus_sem around the dev->bus_list deletion in pci_destroy_dev()
(it will wait for all readers to complete their walks as long as they use
pci_bus_sem correcty, but we may as well replace that with SRCU).

The second one is where someone is walking the list and *deleting* entires from
it in the process, which has to be synchronized with other writers and the
write-locking of pci_bus_sem in pci_destroy_dev() is not sufficient for that,
because pci_bus_sem can't be read-locked around a bus->devices walk deleting
entries from that list (exactly because pci_bus_sem is write-locked during
device deletion).  So this is a special case and to fix races between different
code paths that walk bus->devices *and* delete entries from there we need a
separate lock to be held around the entire list walk.  Incidentally,
pci_remove_rescan_mutex is already used in that context by the code in
pci-sysfs.c, so it can be used for this purpose by all of the other code
paths doing this thing, like for example acpiphp_check_bridge() and
trim_stale_devices() (there's more).

> There are about a zillion uses of it.  Many are in the pcibios_fixup_bus() path.
>  I think we can get rid of most of those by integrating the work into
> the pci_scan_device() path instead of doing it as a post-discovery
> fixup, but there will be several other cases left.  If using
> pci_remove_rescan_mutex to protect &bus->devices is the right generic
> answer, we should document that and audit every place that uses the
> list.

No, we don't have to do that as explained above.  We only need it around
code that walks the list in order to (possibly) delete entries from it
and there are not too many of such places, so they can be audited quite easily.
[Basically, wherever pci_stop_and_remove_bus_device() is called during a list
walk over bus->devices.]

And *if* we use pci_remove_rescan_mutex for that, it will *also* address some
other synchronization problems.

> >   Moreover, if any of the device objects in question is freed
> >   after pci_destroy_dev() executed by the first code path, the
> >   second code path may suffer a use-after-free problem while
> >   trying to access that device object.
> >
> >   Conversely, the second code path may execute pci_destroy_dev()
> >   for one of the devices in question such that one of the
> >   &bus->devices list walks in pci_stop_bus_device()
> >   or pci_remove_bus_device() executed by the first code path will
> >   suffer from a list corruption.
> >
> >   Moreover, use-after-free is also possible if one of the device
> >   objects in question is freed as a result of calling
> >   pci_destroy_dev() by the second code path and then the first
> >   code path tries to access it (the first code path only holds
> >   an extra reference to the device it has been run for, but not
> >   for its child devices).
> 
> The use-after-free problems *sound* like a reference counting issue.
> Yinghai's patch [1] should fix some of this; how much is left after
> that?
> 
> [1] http://lkml.kernel.org/r/1385851238-21085-4-git-send-email-yinghai@kernel.org

Hmm, no.  Do you mean https://patchwork.kernel.org/patch/3261171/ ?

This patch doesn't fix the problem either, however, because in only fixes
the one case described in Scenario 5 below.

Suppose that (1) trim_stale_devices() calls pci_stop_amd_remove_bus_devices(X)
and (2) remove_callback() calls pci_stop_and_remove_bus_devices(X) (i.e. for
the same device) at the same time.

Suppose that X is a leaf device for simplicity and say that code path (2)
is executed first.  We run pci_stop_dev(X) and pci_destroy_dev(X), which
does put_device(&X->dev) and then sysfs_schedule_callback_work() executes
kobject_put() for the X's kobject.  The device pointed to by X is gone at this
point.

Now, code path (1) runs and and crashes with a great bang trying to access
X->subordinate in pci_stop_bus_device().  This happens regardless of whether or
not the Yinghai's patch has been applied.  QED

Of course, you can argue that this is because code path (1) should have done
a pci_dev_get(X) before running pci_stop_amd_remove_bus_devices(X) which
would have avoided the crash.  I can agree with that, but *if* code path (1)
had held pci_remove_rescan_mutex around the whole trim_stale_devices(), then
it wouldn't have had to do that pci_dev_get(X), because the entire race
above wouldn't have been possible (code path (2) already holds that mutex
around pci_stop_and_remove_bus_devices(X)).

OK, you can ask, but why the heck does code path (1) need to hold
pci_remove_rescan_mutex around trim_stale_devices()?  Well, because it needs
to synchronize the list walks in acpiphp_check_bridge() and trim_stale_devices()
with the list_del() in pci_destroy_dev() executed by code path (2).

That's why I'm proposing to acquire pci_remove_rescan_mutex in
hotplug_event_work() and hold it around the whole hotplug_event().

Of course, analogous races are possible for acpiphp_enable_slot() and
acpiphp_disable_and_eject_slot() and they may be addressed analogously -
by holding pci_remove_rescan_mutex around possible modifications of the PCI
device hierarchy.

> > Scenario 2: ACPI hotplug event occurs for a device under a bridge
> >   being removed by pci_stop_and_remove_bus_device() run from
> >   remove_callback() in pci-sysfs.c.
> >
> >   In that case it doesn't make sense to handle the hotplug event,
> >   because the device in question will be removed anyway along with
> >   its parent bridge and that will cause the context objects needed
> >   for hotplug handling to be freed as well.
> >
> >   Moreover, if the event is handled regardless, it may cause one
> >   or more devices already removed by pci_stop_and_remove_bus_device()
> >   to be added again by the code handling the event, which will
> >   conflict with the bridge removal.
> 
> We definitely need to serialize hotplug events from ACPI and sysfs
> (and other sources, like other hotplug drivers).  Would that be
> enough?  Adding the is_going_away flag is ACPI-specific and seems like
> sort of a point workaround.

Well, we basically need to prevent hotplug_event() from being run in that
case, and since that function is ACPI-specific and the data structures
hotplug_event_work() operates on are ACPI-specific, I'm using an ACPI-specific
flag to achieve that goal.  If you can suggest any approach that would not
be ACPI-specific to address this particular case, I'll be happy to use it. :-)

> > Scenario 3: pci_stop_and_remove_bus_device() is run from
> >   trim_stale_devices() (as a result of an ACPI hotplug event) in
> >   parallel with dev_bus_rescan_store() or bus_rescan_store(),
> >   or dev_rescan_store().
> >
> >   In that scenario the second code path may attempt to operate
> >   on device objects being removed by the first code path which
> >   may lead to many interesting types of breakage.
> >
> > Scenario 4: acpi_pci_root_remove() run (as a result of an ACPI PCI
> >   host bridge removal event) in  parallel with bus_rescan_store(),
> >   dev_bus_rescan_store(), dev_rescan_store(), or remove_callback()
> >   for any devices under the host bridge in question.
> >
> >   In that case the same symptoms as in Scenarios 1 and 3 may occur
> >   depending on which code path wins the races involved.
> 
> Scenarios 3 and 4 sound like more cases of hotplug operations needing
> to be serialized, right?  If we serialized them sufficiently, would
> there still be a problem?

That depends on what exactly you mean by "sufficiently".  That is, what's
the goal?  Different approaches may be sufficient to achieve specific goals,
but not necessarily more than one of them.

> Using pci_remove_rescan_mutex would
> serialize *all* PCI hotplug operations, which is more than strictly
> necessary, but maybe there's no reason to do anything finer-grained.

My answer to this is yes, using pci_remove_rescan_mutex *will* serialize all
PCI hotplug operations, which will be a very good first step.  Having done that,
we can see how much we can relax things and how far we *want* to go with that.

> > Scenario 5: pci_stop_and_remove_bus_device() is run concurrently
> >   for a device and its parent bridge via remove_callback().
> >
> >   In that case both code paths attempt to acquire
> >   pci_remove_rescan_mutex.  If the child device removal acquires
> >   it first, there will be no problems.  However, if the parent
> >   bridge removal acquires it first, it will eventually execute
> >   pci_destroy_dev() for the child device, but that device will
> >   not be freed yet due to the reference held by the concurrent
> >   child removal.  Consequently, both pci_stop_bus_device() and
> >   pci_remove_bus_device() will be executed for that device
> >   unnecessarily and pci_destroy_dev() will see a corrupted list
> >   head in that object.  Moreover, an excess put_device() will
> >   be executed for that device in that case which may lead to a
> >   use-after-free in the final kobject_put() done by
> >   sysfs_schedule_callback_work().
> 
> The corrupted list head should be fixed by Yinghai's patch [1].

I think you really mean https://patchwork.kernel.org/patch/3261171/ :-)

Generally, patches in that series would mitigate that problem somewhat.

I actually stole the Yinghai's idea with the new PCI device flag (sorry,
Yinghai), but I think it's better to check that flag to start with in
pci_stop_and_remove_bus_device(), because then we avoid calling
pci_stop_bus_device() unnecessarily as well (surely, the device was stopped
before it has gone, wasn't it?).

> Where is the extra put_device()?  I see the
> kobject_get()/kobject_put() pair in sysfs_schedule_callback() and
> sysfs_schedule_callback_work().  Oh, I see -- the remove_store() ->
> remove_callback() path acquires no references, but it calls
> pci_stop_and_remove_bus_device(), which ultimately does the
> put_device() in pci_destroy_dev().
> 
> So if both the parent and the child removal manage to get to
> remove_callback() and the parent acquires pci_remove_rescan_mutex
> first, the child removal will do the extra put_device().
> 
> There are only six callers of device_schedule_callback(), and I think
> five of them are susceptible to this same problem: they are sysfs
> store methods, and they use device_schedule_callback() with a callback
> that does a put_device() on the device:
> 
>   drivers/pci/pci-sysfs.c: remove_store()
>   drivers/scsi/scsi_sysfs.c: sdev_store_delete()
>   arch/s390/pci/pci_sysfs.c: store_recover()
>   drivers/s390/block/dcssblk.c: dcssblk_shared_store()
>   drivers/s390/cio/ccwgroup.c: ccwgroup_ungroup_store()
> 
> I don't know what the right fix is, but adding "is_gone" to struct
> pci_dev only addresses one of the five places, of course.

That's correct.

I'm not sure if there *is* a generic solution to this problem, because
sysfs_schedule_callback_work() doesn't know what the callback function is
going to do.  In principle it can look at ss->kobj->parent and skip the
execution of ss->func if that is NULL (which means that the kobject has
been deleted and it is likely the last thing holding a reference to that
kobject), but that still will be racy without extra synchronization in the
users of device_schedule_callback().

Which probably means that device_schedule_callback() is ill concieved in the
first place, because it can't really do the work it is designed for in general.
So perhaps it's better to use something simpler and PCI-specific for PCI and
analogously in the other cases you mentioned.

OK

To be a bit more constructive, as the next step I'd try to use
pci_remove_rescan_mutex to serialize all PCI hotplug operations (as I said
above) without making the other changes made by my patch.  Does that sound
reasonable?

Rafael

