Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab3KWXGZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 18:06:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3KWXGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 18:06:23 -0500
Date: Sat, 23 Nov 2013 15:07:01 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Tejun Heo <tj@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [PATCH] sysfs: handle duplicate removal attempts in
 sysfs_remove_group()
Message-ID: <20131123230701.GA6183@kroah.com>
References: <1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com>
 <346316422.RJFnQfZPnq@vostro.rjw.lan>
 <20131123225358.GB5402@kroah.com>
 <4668705.kv8hgxjqAc@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4668705.kv8hgxjqAc@vostro.rjw.lan>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 12:12:59AM +0100, Rafael J. Wysocki wrote:
> On Saturday, November 23, 2013 02:53:58 PM Greg Kroah-Hartman wrote:
> > On Sat, Nov 23, 2013 at 11:56:48PM +0100, Rafael J. Wysocki wrote:
> > > On Friday, November 22, 2013 08:43:55 AM Bjorn Helgaas wrote:
> > > > [+cc Rafael, James]
> > > > 
> > > > On Tue, Nov 19, 2013 at 11:18 PM, Tejun Heo <tj@kernel.org> wrote:
> > > > > (cc'ing Bjorn)
> > > > >
> > > > > Hello,
> > > > >
> > > > > On Tue, Nov 19, 2013 at 03:09:58PM +0200, Mika Westerberg wrote:
> > > > >> Commit bcdde7e221a8 (sysfs: make __sysfs_remove_dir() recursive) changed
> > > > >> the behavior so that directory removals will be done recursively. This
> > > > >> means that the sysfs group might already be removed if its parent directory
> > > > >> has been removed.
> > > > >>
> > > > >> The current code outputs warnings similar to following log snippet when it
> > > > >> detects that there is no group for the given kobject:
> > > > >>
> > > > >>  WARNING: CPU: 0 PID: 4 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
> > > > >>  sysfs group ffffffff81c6f1e0 not found for kobject 'host7'
> > > > >>  Modules linked in:
> > > > >>  CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted 3.12.0+ #13
> > > > >>  Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
> > > > >>  Workqueue: kacpi_hotplug acpi_hotplug_work_fn
> > > > >>   0000000000000009 ffff8801002459b0 ffffffff817daab1 ffff8801002459f8
> > > > >>   ffff8801002459e8 ffffffff810436b8 0000000000000000 ffffffff81c6f1e0
> > > > >>   ffff88006d440358 ffff88006d440188 ffff88006e8b4c28 ffff880100245a48
> > > > >>  Call Trace:
> > > > >>   [<ffffffff817daab1>] dump_stack+0x45/0x56
> > > > >>   [<ffffffff810436b8>] warn_slowpath_common+0x78/0xa0
> > > > >>   [<ffffffff81043727>] warn_slowpath_fmt+0x47/0x50
> > > > >>   [<ffffffff811ae526>] sysfs_remove_group+0xc6/0xd0
> > > > >>   [<ffffffff81432f7e>] dpm_sysfs_remove+0x3e/0x50
> > > > >>   [<ffffffff8142a0d0>] device_del+0x40/0x1b0
> > > > >>   [<ffffffff8142a24d>] device_unregister+0xd/0x20
> > > > >>   [<ffffffff8144131a>] scsi_remove_host+0xba/0x110
> > > > >>   [<ffffffff8145f526>] ata_host_detach+0xc6/0x100
> > > > >>   [<ffffffff8145f578>] ata_pci_remove_one+0x18/0x20
> > > > >>   [<ffffffff812e8f48>] pci_device_remove+0x28/0x60
> > > > >>   [<ffffffff8142d854>] __device_release_driver+0x64/0xd0
> > > > >>   [<ffffffff8142d8de>] device_release_driver+0x1e/0x30
> > > > >>   [<ffffffff8142d257>] bus_remove_device+0xf7/0x140
> > > > >>   [<ffffffff8142a1b1>] device_del+0x121/0x1b0
> > > > >>   [<ffffffff812e43d4>] pci_stop_bus_device+0x94/0xa0
> > > > >>   [<ffffffff812e437b>] pci_stop_bus_device+0x3b/0xa0
> > > > >>   [<ffffffff812e437b>] pci_stop_bus_device+0x3b/0xa0
> > > > >>   [<ffffffff812e44dd>] pci_stop_and_remove_bus_device+0xd/0x20
> > > > >>   [<ffffffff812fc743>] trim_stale_devices+0x73/0xe0
> > > > >>   [<ffffffff812fc78b>] trim_stale_devices+0xbb/0xe0
> > > > >>   [<ffffffff812fc78b>] trim_stale_devices+0xbb/0xe0
> > > > >>   [<ffffffff812fcb6e>] acpiphp_check_bridge+0x7e/0xd0
> > > > >>   [<ffffffff812fd90d>] hotplug_event+0xcd/0x160
> > > > >>   [<ffffffff812fd9c5>] hotplug_event_work+0x25/0x60
> > > > >>   [<ffffffff81316749>] acpi_hotplug_work_fn+0x17/0x22
> > > > >>   [<ffffffff8105cf3a>] process_one_work+0x17a/0x430
> > > > >>   [<ffffffff8105db29>] worker_thread+0x119/0x390
> > > > >>   [<ffffffff81063a5d>] kthread+0xcd/0xf0
> > > > >>   [<ffffffff817eb33c>] ret_from_fork+0x7c/0xb0
> > > > >
> > > > > So, we do have cases where the parent is removed before the child.  I
> > > > > suppose the parent pci bridge is removed already?  AFAICS this
> > > > > shouldn't break anything but people did seem to expect the removals to
> > > > > be ordered from child to parent.  Bjorn, is this something you expect
> > > > > to happened?
> > > > 
> > > > I do not expect a PCI bridge to be removed before the devices below
> > > > it.  We should be removing all the children before removing the parent
> > > > bridge.
> > > > 
> > > > But is this related to PCI?  I don't see the connection yet.  I tried
> > > > to look into this a bit (my notes are at
> > > > https://bugzilla.kernel.org/show_bug.cgi?id=65281), but I haven't
> > > > figured out the big-picture problem yet.
> > > 
> > > OK, so I think I've figured this out.
> > > 
> > > As I wrote in the above BZ entry, after the Tejun's patch the
> > > device_del() in pci_stop_dev() removes the subordinate bus object's
> > > "power" directory among other things and because of that the warning
> > > triggers when we do the pci_remove_bus() in pci_remove_bus_device()
> > > for the same device.
> > > 
> > > The appended patch fixes it for me, but Greg has already taken the
> > > Mika's one, so this one isn't really necessary.  In case you think it
> > > would be useful to apply it anyway, please let me know and I submit it
> > > properly with a changelog etc.
> > 
> > I can revert Mika's patch, as it would be good to catch these kinds of
> > errors.
> 
> Then we'll need to untangle the SATA/SCSI mess triggered by Bjorn in
> https://bugzilla.kernel.org/show_bug.cgi?id=65281. ;-)

I have no objection to fixing that, the scsi sysfs handling is "odd" to
say the least...

If someone can unwind it, that would be great to see happen...

thanks,

greg k-h
