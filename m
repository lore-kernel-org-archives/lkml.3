Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab3BLCTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 21:19:01 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:45124 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3BLCS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 21:18:58 -0500
MIME-Version: 1.0
X-Originating-IP: [121.6.200.219]
In-Reply-To: <1843565.7Y1sC8j6FG@vostro.rjw.lan>
References: <CAMVG2svG21yiM1wkH4_2pen2n+cr2-Zv7TbH3Gj+8MwevZjDbw@mail.gmail.com>
	<CAErSpo6rGYLQeP8Myu=octSPY_0R+B7ptBLhLawd_A2E3NRsAw@mail.gmail.com>
	<6086479.ycKj2j8yeP@vostro.rjw.lan>
	<1843565.7Y1sC8j6FG@vostro.rjw.lan>
Date: Tue, 12 Feb 2013 10:18:57 +0800
Message-ID: <CAMVG2suQiG7viSFE3aTas4QEbyq+LBDxT_8C-n3J9BdX21BfkQ@mail.gmail.com>
Subject: Re: [3.8-rc7] PCI hotplug wakeup oops
From: Daniel J Blueman <daniel@quora.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 February 2013 03:49, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, February 11, 2013 08:27:49 PM Rafael J. Wysocki wrote:
>> On Monday, February 11, 2013 12:01:37 PM Bjorn Helgaas wrote:
>> > [+cc Rafael]
>> >
>> > On Mon, Feb 11, 2013 at 10:08 AM, Daniel J Blueman <daniel@quora.org> wrote:
>> > > On 11 February 2013 21:03, Daniel J Blueman <daniel@quora.org> wrote:
>> > >> With 3.8-rc7, when unplugging the Thunderbolt ethernet adapter (bus 0a
>> > >> [1]) on a Macbook Pro 10,1, we see the PCIe port correctly released:
>> > >>
>> > >> pciehp 0000:06:03.0:pcie24: Card not present on Slot(3)
>> > >> tg3 0000:0a:00.0: tg3_abort_hw timed out, TX_MODE_ENABLE will not
>> > >> clear MAC_TX_MODE=ffffffff
>> > >> tg3 0000:0a:00.0 eth0: No firmware running
>> > >> tg3 0000:0a:00.0 eth0: Link is down
>> > >> [sched_delayed] sched: RT throttling activated
>> > >> pcieport 0000:00:01.1: System wakeup enabled by ACPI
>> > >> pciehp 0000:09:00.0:pcie24: unloading service driver pciehp
>> > >> pci_bus 0000:0a: busn_res: [bus 0a] is released
>> > >> pci_bus 0000:09: busn_res: [bus 09-0a] is released
>> > >>
>> > >> After some activity later (eg I can reproduce this by switching to a
>> > >> text console and back), often we'll see an oops:
>> > >>
>> > >> Unable to handle kernel paging request at 0000000000001070
>> > >> pci_pme_list_scan+0x3d/0xe0
>> > >> Call Trace:
>> > >> process_one_work+0x193
>> > >> ? process_one_work+0x131
>> > >> ? pci_pme_wakeup+0x60
>> > >> worker_thread+0x15d
>> > >>
>> > >> (gdb) list *(pci_pme_list_scan+0x3d)
>> > >> 0xffffffff8123f6dd is in pci_pme_list_scan (drivers/pci/pci.c:1556).
>> > >> 1551                                    /*
>> > >> 1552                                     * If bridge is in low power state, the
>> > >> 1553                                     * configuration space of subordinate devices
>> > >> 1554                                     * may be not accessible
>> > >> 1555                                     */
>> > >> 1556                                    if (bridge && bridge->current_state != PCI_D0)
>> > >> 1557                                            continue;
>> > >> 1558                                    pci_pme_wakeup(pme_dev->dev, NULL);
>> > >> 1559                            } else {
>> > >> 1560                                    list_del(&pme_dev->list);
>> > >>
>> > >> Since a panic in vsnprintf happens after the oops (hence I can't catch
>> > >> it with EFI pstore), it is almost certainly significant heap
>> > >> corruption; this would explain why pme_dev became null (the load has
>> > >> been ordered ahead).
>> > >>
>> > >> I'll see what I can find out with memory poisoning and list debugging.
>> > >
>> > > Enabling a bunch of related debugging, we see pme_dev is non-null and:
>> > >
>> > > BUG: Unable to handle NULL pointer dereference at
>> > > pci_bus_read_config_word+0x6c
>> > > PGD 26314c067 PUD 2633f9067 PMD 0
>> > > Oops: 0000 [#1] SMP
>> > > pci_check_pme_status+0x4f
>> > > pci_pme_wakeup+0x21
>> > > pci_pme_list_scan+0xd5
>> > > process_one_work+0x1ca
>> > > ? process_one_work+0x160
>> > > ? pci_pme_wakeup+0x60
>> > > worker_thread+0x14e
>> > >
>> > > Anyway, it looks like the device being unplugged wasn't removed from
>> > > pci_pme_list as pci_pme_active(dev, false) wasn't called.
>> > >
>> > > From a quick review, I wasn't able to find the right place in the
>> > > call-chain which I only see releases the child busses and PCIe port
>> > > drivers. Anyone?
>> >
>> > It looks like drivers *add* devices to pci_pme_list when they use
>> > pci_enable_wake() or pci_wake_from_d3().  But many drivers never
>> > remove their devices, and I don't see any place where the core does it
>> > either.  My guess is we need to remove it in pci_stop_dev() (we
>> > already do pcie_aspm_exit_link_state() there) or somewhere similar.
>>
>> Yes, we should call pci_pme_active(dev, false) somewhere in there I think.
>> It's fine to call that even if PME was not "active" before.
>
> Daniel, I wonder if the patch below helps?

I had tried with the pci_pme_active call inside the is_added condition
(it'll always hold here); it resolves the issue, though it introduces
a new lockdep warning [1].

All said, I don't see any other way except for a patch to abstract the
list entry removal to avoid the unnecessary reads and writes (as it is
called for four devices here), though I don't see how that would alter
the locking behaviour and why we didn't see this lockdep warning
before.

What do you think?

Dan

--- [1]

kworker/0:0/4 is trying to acquire lock:
 (name){++++.+}, at: [<ffffffff8105ac70>] flush_workqueue+0x0/0x4d0

but task is already holding lock:
 (name){++++.+}, at: [<ffffffff8105c7e0>] process_one_work+0x160/0x4e0

other info that might help us debug this:
 Possible unsafe locking scenario:

    CPU0
    ----
 lock(name);
 lock(name);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by kworker/0:0/4:
 #0: (name){++++.+}, at: [<ffffffff8105c7e0>] process_one_work+0x160/0x4e0
 #1: ((&info->work)#2){+.+.+.}, at: [<ffffffff8105c7e0>]
process_one_work+0x160/0x4e0
 #2: (&__lockdep_no_validate__){......}, at: [<ffffffff813022a1>]
device_release_driver+0x21/0x40
 #3: (&__lockdep_no_validate__){......}, at: [<ffffffff813022a1>]
device_release_driver+0x21/0x40

stack backtrace:
Pid: 4, comm: kworker/0:0 Not tainted 3.8.0-rc7-ninja+ #21
Call Trace:
 [<ffffffff81090213>] validate_chain.isra.33+0xda3/0x1240
 [<ffffffff8108ea90>] ? print_shortest_lock_dependencies+0x1c0/0x1c0
 [<ffffffff810909d5>] ? mark_lock+0x215/0x5d0
 [<ffffffff8109284f>] ? debug_check_no_locks_freed+0x8f/0x160
 [<ffffffff8109113c>] __lock_acquire+0x3ac/0xb30
 [<ffffffff810927bd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8108dc0c>] ? lockdep_init_map+0x9c/0x4d0
 [<ffffffff81091d8a>] lock_acquire+0x5a/0x70
 [<ffffffff8105ac70>] ? flush_workqueue_prep_cwqs+0x200/0x200
 [<ffffffff8105ad58>] flush_workqueue+0xe8/0x4d0
 [<ffffffff8105ac70>] ? flush_workqueue_prep_cwqs+0x200/0x200
 [<ffffffff8105b1c8>] drain_workqueue+0x68/0x1f0
 [<ffffffff8105b363>] destroy_workqueue+0x13/0x160
 [<ffffffff8125ad0a>] pciehp_release_ctrl+0x3a/0x90
 [<ffffffff81257ca5>] pciehp_remove+0x25/0x30
 [<ffffffff81251f72>] pcie_port_remove_service+0x52/0x70
 [<ffffffff81302217>] __device_release_driver+0x77/0xe0
 [<ffffffff813022a9>] device_release_driver+0x29/0x40
 [<ffffffff81301cb1>] bus_remove_device+0xf1/0x140
 [<ffffffff812ff847>] device_del+0x127/0x1c0
 [<ffffffff812520f0>] ? resume_iter+0x40/0x40
 [<ffffffff812ff8f1>] device_unregister+0x11/0x20
 [<ffffffff81252125>] remove_iter+0x35/0x40
 [<ffffffff812fe716>] device_for_each_child+0x36/0x70
 [<ffffffff812526c1>] pcie_port_device_remove+0x21/0x40
 [<ffffffff81252908>] pcie_portdrv_remove+0x28/0x50
 [<ffffffff81246cb1>] pci_device_remove+0x41/0xc0
 [<ffffffff81302217>] __device_release_driver+0x77/0xe0
 [<ffffffff813022a9>] device_release_driver+0x29/0x40
 [<ffffffff81301cb1>] bus_remove_device+0xf1/0x140
 [<ffffffff812ff847>] device_del+0x127/0x1c0
 [<ffffffff812ff8f1>] device_unregister+0x11/0x20
 [<ffffffff81241b74>] pci_stop_bus_device+0xb4/0xc0
 [<ffffffff81241af5>] pci_stop_bus_device+0x35/0xc0
 [<ffffffff81241cd1>] pci_stop_and_remove_bus_device+0x11/0x20
 [<ffffffff81259021>] pciehp_unconfigure_device+0x91/0x190
 [<ffffffff81258921>] pciehp_disable_slot+0x71/0x220
 [<ffffffff81258bb6>] pciehp_power_thread+0xe6/0x110
 [<ffffffff8105c84a>] process_one_work+0x1ca/0x4e0
 [<ffffffff8105c7e0>] ? process_one_work+0x160/0x4e0
 [<ffffffff81258ad0>] ? pciehp_disable_slot+0x220/0x220
 [<ffffffff8105cefe>] worker_thread+0x14e/0x3f0
 [<ffffffff810927bd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8105cdb0>] ? rescuer_thread+0x210/0x210
 [<ffffffff81063086>] kthread+0xd6/0xe0
 [<ffffffff8154cf2b>] ? _raw_spin_unlock_irq+0x2b/0x50
 [<ffffffff81062fb0>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff8154dc2c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81062fb0>] ? __init_kthread_worker+0x70/0x70
-- 
Daniel J Blueman
