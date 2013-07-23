Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3GWGtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 02:49:49 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:36042 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab3GWGtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 02:49:46 -0400
MIME-Version: 1.0
In-Reply-To: <2366394.4EoP1MXmG2@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan>
	<3718119.FLASu5DBx8@vostro.rjw.lan>
	<2366394.4EoP1MXmG2@vostro.rjw.lan>
Date: Mon, 22 Jul 2013 23:49:45 -0700
X-Google-Sender-Auth: fOSt97RSaJ16LSgEjz8hhmHM6r0
Message-ID: <CAE9FiQVq3O45SOr9h6c5dBiAZs2Ry6z6L_irW8AE-fZ_1NmMXQ@mail.gmail.com>
Subject: Re: [PATCH 0/30] ACPI / hotplug / PCI: Major rework + Thunderbolt workarounds
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 4:05 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi All,
>
> Now the series has been rebased on top of current linux-pm.git/linux-next
> and tested on two systems with Thunderbolt.  Some changes have been made too. ->
>
> On Friday, July 12, 2013 01:34:20 AM Rafael J. Wysocki wrote:
>> Hi,
>>
>> I've made some progress with my ACPIPHP rework since I posted the series last
>> time and here goes an update.
>>
>> First off, the previous series was somewhat racy, which should be fixed now.
>> Apart from this there's quite some new material on top of the patches I posted
>> last time (or rather on top of their new versions) and I integrated the
>> Thunderbolt series from Mika with that.  As a result,
>>
>> https://patchwork.kernel.org/patch/2817341/
>>
>> is required to be applied.
>>
>> Still untested, still based on 3.10 with ACPI+PM 3.11 material merged on top,
>> but this time I don't have any plans to add more patches to the series for the
>> time being.  Also 3.11-rc1 should be out in a couple of days, so I'll be able
>> to integrate this work with the previous cleanups series from Gerry and myself
>> on top of it.
>>
>> I did my best not to change too much at a time and some steps add stuff that
>> is removed by the subsequent ones, so hopefully it is bisectable.
>>
>> If anyone finds something questionable or outright bogus in these patches,
>> please let me know before it's too late. ;-)
>>
>> [ 1/30] Make bus registration and unregistration symmetric.  [Resend]
>> [ 2/30] Consolidate acpiphp_enumerate_slots().  [Resend]
>> [ 3/30] Fix error code path in register_slot().  [Resend]
>> [ 4/30] Introduce hotplug context objects for ACPI device objects corresponding
>>         to PCI hotplug devices.  [Update]
>> [ 5/30] Unified notify handler for hotplug events.  [Update]
>> [ 6/30] Drop acpiphp_handle_to_bridge() and use context objects instead of it.  [Update]
>> [ 7/30] Pass entire hotplug context objects (instead of their fields
>>         individually) to event handling work functions.  [Update]
>> [ 8/30] Merge hotplug event handling functions.  [Update]
>> [ 9/30] Drop func field from struct acpiphp_bridge.
>> [10/30] Refactor slot allocation code in register_slot().
>> [11/30] Make acpiphp_enumerate_slots() to register all devices on the given bus
>>         and install the notification handler for all of them.
>> [12/30] Drop sun field from struct acpiphp_slot.
>> [13/30] Use common slot count variable in register_slot().
>
> -> The one above has been dropped, because it might cause regressions to appear
> on some systems, but that's not a big deal.
>
> The numbering of the patches below has changed as a result, so the next one is
> [13/30] now and so on.
>
>> [14/30] Drop flags field from struct acpiphp_bridge.
>> [15/30] Embed function structure into struct acpiphp_context.
>> [16/30] Drop handle field from struct acpiphp_func.
>> [17/30] Drop handle field from struct acpiphp_bridge.
>> [18/30] Store parent bridge pointer in function objects and bus pointer in slot
>>         objects.
>> [19/30] Rework ACPI namespace scanning and trimming routines.
>> [20/30] Drop redundant checks from check_hotplug_bridge().
>> [21/30] Consolidate slot disabling and ejecting
>> [22/30] Do not queue up event handling work items for non-hotplug events.
>> [23/30] Do not execute _PS0 and _PS3 directly.
>
> This one was fixed after Mika had reported a problem with it.
>
>> [24/30] Do not check SLOT_ENABLED in enable_device().  [Thunderbolt series]
>> [25/30] Allow slots without new devices to be rescanned.  [Thunderbolt series]
>> [26/30] Check for new devices on enabled slots.  [Thunderbolt series, TBD]
>
> This one was reworked to use acpi_bus_trim() on ACPI device objects
> corresponding to PCI devices being removed (it also uses _STA to check the
> status of those devices if available).
>
>> [27/30] Get rid of unused constands in acpiphp.h.  [Thunderbolt series]
>> [28/30] Sanitize acpiphp_get_(latch)|(adapter)_status().  [Thunderbolt series]
>> [29/30] Redefine enable_device() and disable_device() (rename and change to void).
>> [30/30] Clean up the usage of bridge_mutex.
>
> The one above is [29/30] now and we have added one more patch:
>
> [30/30] Drop check_sub_bridges() which isn't necessary any more.
>
> The updated patches follow.
>
> If you don't hate this stuff, I'll put it into linux-next over the weekend for
> further testing.

pm/linux-next with those patches breaks acpi root bus hotplug.
it is kvm guest:

10:~ # echo "PCI0 3" > /sys/kernel/debug/acpi/sci_notify
[   92.549508] ACPI: ACPI device name is <PCI0>, event code is <3>
[   92.552433] ACPI: Notify event is queued
10:~ # [   92.554279] ACPI: \_SB_.PCI0: Device eject notify on
_handle_hotplug_event_root
[   92.677696] ACPI: Device 0000:00:03.0 -x-> \_SB_.PCI0.S03_
[   92.679229] ACPI: Device 0000:00:02.0 -x-> \_SB_.PCI0.VGA_
[   92.680684] ACPI: Device 0000:00:01.3 -x-> \_SB_.PCI0.PX13
[   92.682235] ata1.00: disabled
[   92.689000] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   92.690399] sd 0:0:0:0: [sda]
[   92.691133] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[   92.693151] sd 0:0:0:0: [sda] Stopping disk
[   92.694682] sd 0:0:0:0: [sda] START_STOP FAILED
[   92.696749] sd 0:0:0:0: [sda]
[   92.698157] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[   92.702852] ata2.00: disabled
[   92.711550] ACPI: Device 0000:00:01.0 -x-> \_SB_.PCI0.ISA_
[   92.713208] ACPI: Device pci0000:00 -x-> \_SB_.PCI0
[   92.713226]   acpi_pci_iommu_remove is called for \_SB_.PCI0 ffff88007ab3f1e0
[   92.713274]   acpi_pci_ioapic_remove is called for \_SB_.PCI0
ffff88007ab3f1e0
[   92.713345] pci 0000:00:00.0: freeing pci_dev info
[   92.713363] pci 0000:00:01.0: freeing pci_dev info
[   92.713366] pci 0000:00:01.1: freeing pci_dev info
[   92.713376] pci 0000:00:01.3: freeing pci_dev info
[   92.713380] pci 0000:00:02.0: freeing pci_dev info
[   92.713384] pci 0000:00:03.0: freeing pci_dev info
[   92.713396] pci_bus 0000:00: busn_res: [bus 00-ff] is released
[   92.713441] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[   92.713446] IP: [<ffffffff81557910>]
acpiphp_unregister_hotplug_slot+0x20/0x60
[   92.713448] PGD 0
[   92.713449] Oops: 0000 [#1] SMP
[   92.713451] Modules linked in:
[   92.713453] CPU: 0 PID: 1042 Comm: kworker/0:1 Not tainted
3.11.0-rc2-yh-00277-gaaf9c19-dirty #1818
[   92.713454] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   92.713458] Workqueue: kacpi_hotplug acpi_os_execute_deferred
[   92.713459] task: ffff88007a0ecb40 ti: ffff88007a72a000 task.ti:
ffff88007a72a000
[   92.713461] RIP: 0010:[<ffffffff81557910>]  [<ffffffff81557910>]
acpiphp_unregister_hotplug_slot+0x20/0x60
[   92.713462] RSP: 0018:ffff88007a72bb28  EFLAGS: 00010296
[   92.713463] RAX: ffff88007a774e18 RBX: 0000000000000000 RCX: 0000000000000004
[   92.713463] RDX: ffffffff822ab080 RSI: ffffffff8284eaef RDI: ffffffff8284eb13
[   92.713464] RBP: ffff88007a72bb38 R08: 0000000000000000 R09: 0000000000000000
[   92.713465] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88007a774e18
[   92.713465] R13: ffff88007a774e00 R14: ffff88007a148f70 R15: ffff88007a774e08
[   92.713466] FS:  0000000000000000(0000) GS:ffff88007b800000(0000)
knlGS:0000000000000000
[   92.713467] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   92.713470] CR2: 0000000000000000 CR3: 00000000794fc000 CR4: 00000000000006f0
[   92.713474] Stack:
[   92.713476]  ffff88007a148f70 ffff88007ab43cd0 ffff88007a72bb88
ffffffff81557ae0
[   92.713478]  ffff88007a72bb78 ffff88007a148f60 ffffffff8153574e
ffff88007a148f60
[   92.713479]  ffff88007a07d000 ffff88007a07d028 ffff88007a07d800
ffff88007a325298
[   92.713480] Call Trace:
[   92.713482]  [<ffffffff81557ae0>] cleanup_bridge+0x80/0xf0
[   92.713485]  [<ffffffff8153574e>] ? pci_remove_bus+0x3e/0x60
[   92.713487]  [<ffffffff81558b1d>] acpiphp_remove_slots+0x5d/0xa0
[   92.713489]  [<ffffffff8155d48a>] acpi_pci_remove_bus+0x2a/0x40
[   92.713493]  [<ffffffff81f7bf9e>] pcibios_remove_bus+0xe/0x10
[   92.713494]  [<ffffffff81535756>] pci_remove_bus+0x46/0x60
[   92.713496]  [<ffffffff81535900>] pci_remove_root_bus+0x50/0xa0
[   92.713499]  [<ffffffff81595596>] acpi_pci_root_remove+0x52/0x5f
[   92.713501]  [<ffffffff81590a0f>] acpi_bus_device_detach+0x3d/0x5e
[   92.713503]  [<ffffffff81590a72>] acpi_bus_trim+0x42/0x7a
[   92.713505]  [<ffffffff8159104e>] acpi_scan_hot_remove+0x194/0x23b
[   92.713507]  [<ffffffff815911f4>] acpi_bus_hot_remove_device+0x2f/0x66
[   92.713509]  [<ffffffff8158b60b>] acpi_os_execute_deferred+0x25/0x32
[   92.713513]  [<ffffffff810b7ffb>] process_one_work+0x28b/0x490
[   92.713515]  [<ffffffff810b7f72>] ? process_one_work+0x202/0x490
[   92.713517]  [<ffffffff810b94ce>] worker_thread+0x21e/0x370
[   92.713521]  [<ffffffff810fdafd>] ? trace_hardirqs_on+0xd/0x10
[   92.713523]  [<ffffffff810b92b0>] ? manage_workers.isra.18+0x330/0x330
[   92.713526]  [<ffffffff810c0aa8>] kthread+0xe8/0xf0
[   92.713528]  [<ffffffff810c09c0>] ? __init_kthread_worker+0x70/0x70
[   92.713531]  [<ffffffff820d991c>] ret_from_fork+0x7c/0xb0
[   92.713533]  [<ffffffff810c09c0>] ? __init_kthread_worker+0x70/0x70
[   92.713549] Code: 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
55 48 c7 c6 ef ea 84 82 48 89 e5 53 48 83 ec 08 48 8b 5f 28 48 c7 c7
13 eb 84 82 <48> 8b 03 48 8b 40 30 48 8b 50 28 31 c0 e8 f7 dd b5 00 48
8b 3b
[   92.713551] RIP  [<ffffffff81557910>]
acpiphp_unregister_hotplug_slot+0x20/0x60
[   92.713552]  RSP <ffff88007a72bb28>
[   92.713552] CR2: 0000000000000000
[   92.713554] ---[ end trace 9e3bba504fb5e5d4 ]---
[   92.713589] BUG: unable to handle kernel paging request at ffffffffffffff98
[   92.713591] IP: [<ffffffff810c0e30>] kthread_data+0x10/0x20
[   92.713593] PGD 2a15067 PUD 2a17067 PMD 0
[   92.713594] Oops: 0000 [#2] SMP
[   92.713595] Modules linked in:
[   92.713596] CPU: 0 PID: 1042 Comm: kworker/0:1 Tainted: G      D
  3.11.0-rc2-yh-00277-gaaf9c19-dirty #1818
[   92.713597] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   92.713604] task: ffff88007a0ecb40 ti: ffff88007a72a000 task.ti:
ffff88007a72a000
[   92.713606] RIP: 0010:[<ffffffff810c0e30>]  [<ffffffff810c0e30>]
kthread_data+0x10/0x20
[   92.713607] RSP: 0018:ffff88007a72b648  EFLAGS: 00010092
[   92.713607] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000008
[   92.713608] RDX: 0000000000000006 RSI: 0000000000000000 RDI: ffff88007a0ecb40
[   92.713608] RBP: ffff88007a72b648 R08: ffff88007a0ecbb0 R09: 0000000000000000
[   92.713609] R10: 0000000000000000 R11: 000000159620c258 R12: ffff88007b9d3e80
[   92.713610] R13: 0000000000000000 R14: 0000000000000001 R15: ffff88007a0ecb40
[   92.713611] FS:  0000000000000000(0000) GS:ffff88007b800000(0000)
knlGS:0000000000000000
[   92.713612] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   92.713615] CR2: 0000000000000028 CR3: 00000000794fc000 CR4: 00000000000006f0
[   92.713618] Stack:
[   92.713620]  ffff88007a72b668 ffffffff810b9a15 ffff88007a72b668
ffff88007a0ed168
[   92.713621]  ffff88007a72b788 ffffffff820ce2f4 ffff88007a72b6c8
ffff88007a72bfd8
[   92.713623]  ffff88007a72bfd8 0000000000004000 ffff88007a0ecb40
ffff88007a0ecb40
[   92.713623] Call Trace:
[   92.713625]  [<ffffffff810b9a15>] wq_worker_sleeping+0x15/0xa0
[   92.713627]  [<ffffffff820ce2f4>] __schedule+0x154/0xa60
[   92.713629]  [<ffffffff810fdafd>] ? trace_hardirqs_on+0xd/0x10
[   92.713632]  [<ffffffff814e540a>] ? put_io_context+0x9a/0xb0
[   92.713633]  [<ffffffff814e547b>] ? put_io_context_active+0x5b/0xd0
[   92.713635]  [<ffffffff820cecfd>] schedule+0x5d/0x60
[   92.713638]  [<ffffffff8109def5>] do_exit+0x935/0x990
[   92.713640]  [<ffffffff820d20e8>] oops_end+0xc8/0xe0
[   92.713643]  [<ffffffff820b4fbc>] no_context+0x261/0x28c
[   92.713645]  [<ffffffff820b51ac>] __bad_area_nosemaphore+0x1c5/0x1e4
[   92.713646]  [<ffffffff820b51de>] bad_area_nosemaphore+0x13/0x15
[   92.713649]  [<ffffffff820d505e>] __do_page_fault+0x4be/0x550
[   92.713651]  [<ffffffff810d41e5>] ? sched_clock_local+0x25/0xa0
[   92.713653]  [<ffffffff810f9fc8>] ? trace_hardirqs_off_caller+0x28/0x160
[   92.713655]  [<ffffffff810fd876>] ? mark_held_locks+0x136/0x150
[   92.713657]  [<ffffffff810c673b>] ? up+0x4b/0x60
[   92.713659]  [<ffffffff820d5127>] do_page_fault+0x37/0x60
[   92.713660]  [<ffffffff820d128c>] ? restore_args+0x30/0x30
[   92.713662]  [<ffffffff820d1462>] page_fault+0x22/0x30
[   92.713664]  [<ffffffff81557910>] ? acpiphp_unregister_hotplug_slot+0x20/0x60
[   92.713667]  [<ffffffff81557ae0>] cleanup_bridge+0x80/0xf0
[   92.713669]  [<ffffffff8153574e>] ? pci_remove_bus+0x3e/0x60
[   92.713671]  [<ffffffff81558b1d>] acpiphp_remove_slots+0x5d/0xa0
[   92.713673]  [<ffffffff8155d48a>] acpi_pci_remove_bus+0x2a/0x40
[   92.713676]  [<ffffffff81f7bf9e>] pcibios_remove_bus+0xe/0x10
[   92.713678]  [<ffffffff81535756>] pci_remove_bus+0x46/0x60
[   92.713681]  [<ffffffff81535900>] pci_remove_root_bus+0x50/0xa0
[   92.713683]  [<ffffffff81595596>] acpi_pci_root_remove+0x52/0x5f
[   92.713685]  [<ffffffff81590a0f>] acpi_bus_device_detach+0x3d/0x5e
[   92.713687]  [<ffffffff81590a72>] acpi_bus_trim+0x42/0x7a
[   92.713690]  [<ffffffff8159104e>] acpi_scan_hot_remove+0x194/0x23b
[   92.713692]  [<ffffffff815911f4>] acpi_bus_hot_remove_device+0x2f/0x66
[   92.713695]  [<ffffffff8158b60b>] acpi_os_execute_deferred+0x25/0x32
[   92.713697]  [<ffffffff810b7ffb>] process_one_work+0x28b/0x490
[   92.713699]  [<ffffffff810b7f72>] ? process_one_work+0x202/0x490
[   92.713701]  [<ffffffff810b94ce>] worker_thread+0x21e/0x370
[   92.713704]  [<ffffffff810fdafd>] ? trace_hardirqs_on+0xd/0x10
[   92.713706]  [<ffffffff810b92b0>] ? manage_workers.isra.18+0x330/0x330
[   92.713708]  [<ffffffff810c0aa8>] kthread+0xe8/0xf0
[   92.713710]  [<ffffffff810c09c0>] ? __init_kthread_worker+0x70/0x70
[   92.713712]  [<ffffffff820d991c>] ret_from_fork+0x7c/0xb0
[   92.713713]  [<ffffffff810c09c0>] ? __init_kthread_worker+0x70/0x70
[   92.713728] Code: 00 48 89 e5 5d 48 8b 40 88 48 c1 e8 02 83 e0 01
c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 70 05 00 00
55 48 89 e5 <48> 8b 40 98 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44
00 00
[   92.713730] RIP  [<ffffffff810c0e30>] kthread_data+0x10/0x20
[   92.713730]  RSP <ffff88007a72b648>
[   92.713731] CR2: ffffffffffffff98
[   92.713732] ---[ end trace 9e3bba504fb5e5d5 ]---
[   92.713732] Fixing recursive fault but reboot is needed!
