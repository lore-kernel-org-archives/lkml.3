Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab3KVPoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:44:19 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:64335 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab3KVPoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:44:16 -0500
MIME-Version: 1.0
In-Reply-To: <20131120061830.GA16081@mtj.dyndns.org>
References: <1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com>
 <20131120061830.GA16081@mtj.dyndns.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 22 Nov 2013 08:43:55 -0700
Message-ID: <CAErSpo5s9chjgSaA2kqE_72f=+2Lq9HQLM3xstw8Avg+Nx63xA@mail.gmail.com>
Subject: Re: [PATCH] sysfs: handle duplicate removal attempts in sysfs_remove_group()
To: Tejun Heo <tj@kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rafael, James]

On Tue, Nov 19, 2013 at 11:18 PM, Tejun Heo <tj@kernel.org> wrote:
> (cc'ing Bjorn)
>
> Hello,
>
> On Tue, Nov 19, 2013 at 03:09:58PM +0200, Mika Westerberg wrote:
>> Commit bcdde7e221a8 (sysfs: make __sysfs_remove_dir() recursive) changed
>> the behavior so that directory removals will be done recursively. This
>> means that the sysfs group might already be removed if its parent directory
>> has been removed.
>>
>> The current code outputs warnings similar to following log snippet when it
>> detects that there is no group for the given kobject:
>>
>>  WARNING: CPU: 0 PID: 4 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
>>  sysfs group ffffffff81c6f1e0 not found for kobject 'host7'
>>  Modules linked in:
>>  CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted 3.12.0+ #13
>>  Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
>>  Workqueue: kacpi_hotplug acpi_hotplug_work_fn
>>   0000000000000009 ffff8801002459b0 ffffffff817daab1 ffff8801002459f8
>>   ffff8801002459e8 ffffffff810436b8 0000000000000000 ffffffff81c6f1e0
>>   ffff88006d440358 ffff88006d440188 ffff88006e8b4c28 ffff880100245a48
>>  Call Trace:
>>   [<ffffffff817daab1>] dump_stack+0x45/0x56
>>   [<ffffffff810436b8>] warn_slowpath_common+0x78/0xa0
>>   [<ffffffff81043727>] warn_slowpath_fmt+0x47/0x50
>>   [<ffffffff811ae526>] sysfs_remove_group+0xc6/0xd0
>>   [<ffffffff81432f7e>] dpm_sysfs_remove+0x3e/0x50
>>   [<ffffffff8142a0d0>] device_del+0x40/0x1b0
>>   [<ffffffff8142a24d>] device_unregister+0xd/0x20
>>   [<ffffffff8144131a>] scsi_remove_host+0xba/0x110
>>   [<ffffffff8145f526>] ata_host_detach+0xc6/0x100
>>   [<ffffffff8145f578>] ata_pci_remove_one+0x18/0x20
>>   [<ffffffff812e8f48>] pci_device_remove+0x28/0x60
>>   [<ffffffff8142d854>] __device_release_driver+0x64/0xd0
>>   [<ffffffff8142d8de>] device_release_driver+0x1e/0x30
>>   [<ffffffff8142d257>] bus_remove_device+0xf7/0x140
>>   [<ffffffff8142a1b1>] device_del+0x121/0x1b0
>>   [<ffffffff812e43d4>] pci_stop_bus_device+0x94/0xa0
>>   [<ffffffff812e437b>] pci_stop_bus_device+0x3b/0xa0
>>   [<ffffffff812e437b>] pci_stop_bus_device+0x3b/0xa0
>>   [<ffffffff812e44dd>] pci_stop_and_remove_bus_device+0xd/0x20
>>   [<ffffffff812fc743>] trim_stale_devices+0x73/0xe0
>>   [<ffffffff812fc78b>] trim_stale_devices+0xbb/0xe0
>>   [<ffffffff812fc78b>] trim_stale_devices+0xbb/0xe0
>>   [<ffffffff812fcb6e>] acpiphp_check_bridge+0x7e/0xd0
>>   [<ffffffff812fd90d>] hotplug_event+0xcd/0x160
>>   [<ffffffff812fd9c5>] hotplug_event_work+0x25/0x60
>>   [<ffffffff81316749>] acpi_hotplug_work_fn+0x17/0x22
>>   [<ffffffff8105cf3a>] process_one_work+0x17a/0x430
>>   [<ffffffff8105db29>] worker_thread+0x119/0x390
>>   [<ffffffff81063a5d>] kthread+0xcd/0xf0
>>   [<ffffffff817eb33c>] ret_from_fork+0x7c/0xb0
>
> So, we do have cases where the parent is removed before the child.  I
> suppose the parent pci bridge is removed already?  AFAICS this
> shouldn't break anything but people did seem to expect the removals to
> be ordered from child to parent.  Bjorn, is this something you expect
> to happened?

I do not expect a PCI bridge to be removed before the devices below
it.  We should be removing all the children before removing the parent
bridge.

But is this related to PCI?  I don't see the connection yet.  I tried
to look into this a bit (my notes are at
https://bugzilla.kernel.org/show_bug.cgi?id=65281), but I haven't
figured out the big-picture problem yet.

I don't have warm fuzzies that adding a "have we already removed this"
check is the best resolution, but maybe that's just because I don't
understand the problem.

Bjorn

>> I'm not 100% sure that this is the correct solution. It seem to fix my case
>> but I might be missing something as I'm not that familiar with sysfs.
>
> Yeah, looks okay to me for now.  One nit at the end tho.
>
> I find requiring removal of each sysfs attribute when the whole node
> is going away rather weird.  It forced us to have extra code which
> does whole bunch of hash table lookups and deletion operations and the
> only thing that achieved was either triggering warning if somebody did
> it in the wrong order or spuriously, or leaking memory if somebody
> forgot some without any way to find out about them.
>
> Now, all those are harmlessly unnecessary and we're adding more logic
> to suppress warnings on specific cases.  In the longer term, we
> probably just wanna drop all the unnecessary removal logics and
> warnings.
>
>> +     /*
>> +      * Sysfs directories are now removed recursively by
>> +      * sysfs_remove_dir(). This means that this function can be called
>> +      * multiple times on the same group. If the parent directory is
>> +      * already removed we don't do anything here.
>> +      */
>
> The function won't be called multiple times but may be called on a
> group whose kobj whose sysfs entry is already removed in which case
> all its groups are guaranteed to be already removed.
>
> Can you please update the comment to reflect the above?
>
> With that,
>
>  Acked-by: Tejun Heo <tj@kernel.org>
>
> Thanks.
>
> --
> tejun
