Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3KVWbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 17:31:05 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52250 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753277Ab3KVWbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 17:31:00 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tejun Heo <tj@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [PATCH] sysfs: handle duplicate removal attempts in sysfs_remove_group()
Date: Fri, 22 Nov 2013 23:43:42 +0100
Message-ID: <1885021.E6XxJipFub@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAErSpo5s9chjgSaA2kqE_72f=+2Lq9HQLM3xstw8Avg+Nx63xA@mail.gmail.com>
References: <1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com> <20131120061830.GA16081@mtj.dyndns.org> <CAErSpo5s9chjgSaA2kqE_72f=+2Lq9HQLM3xstw8Avg+Nx63xA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 22, 2013 08:43:55 AM Bjorn Helgaas wrote:
> [+cc Rafael, James]
> 
> On Tue, Nov 19, 2013 at 11:18 PM, Tejun Heo <tj@kernel.org> wrote:
> > (cc'ing Bjorn)
> >
> > Hello,
> >
> > On Tue, Nov 19, 2013 at 03:09:58PM +0200, Mika Westerberg wrote:
> >> Commit bcdde7e221a8 (sysfs: make __sysfs_remove_dir() recursive) changed
> >> the behavior so that directory removals will be done recursively. This
> >> means that the sysfs group might already be removed if its parent directory
> >> has been removed.
> >>
> >> The current code outputs warnings similar to following log snippet when it
> >> detects that there is no group for the given kobject:
> >>
> >>  WARNING: CPU: 0 PID: 4 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
> >>  sysfs group ffffffff81c6f1e0 not found for kobject 'host7'
> >>  Modules linked in:
> >>  CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted 3.12.0+ #13
> >>  Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
> >>  Workqueue: kacpi_hotplug acpi_hotplug_work_fn
> >>   0000000000000009 ffff8801002459b0 ffffffff817daab1 ffff8801002459f8
> >>   ffff8801002459e8 ffffffff810436b8 0000000000000000 ffffffff81c6f1e0
> >>   ffff88006d440358 ffff88006d440188 ffff88006e8b4c28 ffff880100245a48
> >>  Call Trace:
> >>   [<ffffffff817daab1>] dump_stack+0x45/0x56
> >>   [<ffffffff810436b8>] warn_slowpath_common+0x78/0xa0
> >>   [<ffffffff81043727>] warn_slowpath_fmt+0x47/0x50
> >>   [<ffffffff811ae526>] sysfs_remove_group+0xc6/0xd0
> >>   [<ffffffff81432f7e>] dpm_sysfs_remove+0x3e/0x50
> >>   [<ffffffff8142a0d0>] device_del+0x40/0x1b0
> >>   [<ffffffff8142a24d>] device_unregister+0xd/0x20
> >>   [<ffffffff8144131a>] scsi_remove_host+0xba/0x110
> >>   [<ffffffff8145f526>] ata_host_detach+0xc6/0x100
> >>   [<ffffffff8145f578>] ata_pci_remove_one+0x18/0x20
> >>   [<ffffffff812e8f48>] pci_device_remove+0x28/0x60
> >>   [<ffffffff8142d854>] __device_release_driver+0x64/0xd0
> >>   [<ffffffff8142d8de>] device_release_driver+0x1e/0x30
> >>   [<ffffffff8142d257>] bus_remove_device+0xf7/0x140
> >>   [<ffffffff8142a1b1>] device_del+0x121/0x1b0
> >>   [<ffffffff812e43d4>] pci_stop_bus_device+0x94/0xa0
> >>   [<ffffffff812e437b>] pci_stop_bus_device+0x3b/0xa0
> >>   [<ffffffff812e437b>] pci_stop_bus_device+0x3b/0xa0
> >>   [<ffffffff812e44dd>] pci_stop_and_remove_bus_device+0xd/0x20
> >>   [<ffffffff812fc743>] trim_stale_devices+0x73/0xe0
> >>   [<ffffffff812fc78b>] trim_stale_devices+0xbb/0xe0
> >>   [<ffffffff812fc78b>] trim_stale_devices+0xbb/0xe0
> >>   [<ffffffff812fcb6e>] acpiphp_check_bridge+0x7e/0xd0
> >>   [<ffffffff812fd90d>] hotplug_event+0xcd/0x160
> >>   [<ffffffff812fd9c5>] hotplug_event_work+0x25/0x60
> >>   [<ffffffff81316749>] acpi_hotplug_work_fn+0x17/0x22
> >>   [<ffffffff8105cf3a>] process_one_work+0x17a/0x430
> >>   [<ffffffff8105db29>] worker_thread+0x119/0x390
> >>   [<ffffffff81063a5d>] kthread+0xcd/0xf0
> >>   [<ffffffff817eb33c>] ret_from_fork+0x7c/0xb0
> >
> > So, we do have cases where the parent is removed before the child.  I
> > suppose the parent pci bridge is removed already?  AFAICS this
> > shouldn't break anything but people did seem to expect the removals to
> > be ordered from child to parent.  Bjorn, is this something you expect
> > to happened?
> 
> I do not expect a PCI bridge to be removed before the devices below
> it.  We should be removing all the children before removing the parent
> bridge.

Precisely.

> But is this related to PCI?  I don't see the connection yet.  I tried
> to look into this a bit (my notes are at
> https://bugzilla.kernel.org/show_bug.cgi?id=65281), but I haven't
> figured out the big-picture problem yet.
> 
> I don't have warm fuzzies that adding a "have we already removed this"
> check is the best resolution, but maybe that's just because I don't
> understand the problem.

I don't think this is related to removing the parent before the child.
It complains about the 'power' directory of all devices being removed
it seems.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
