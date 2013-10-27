Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab3J0Ajy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 20:39:54 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56428 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3J0Ajw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 20:39:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4qv2x1MjB=cW6QNevcQcq7dYtk-wC-HRTq8XEz2Xac-g@mail.gmail.com>
References: <CAMxnaaUim-MCDpaTiLmBqN3wfxjn9V6XE_n4SMfuO=vqeT6rVA@mail.gmail.com>
 <CAErSpo4KU9VAC=SnKuYH3EPz8NuozixAhUQBKv+=Y=76wywdTg@mail.gmail.com>
 <20131015024452.GA31951@srcf.ucam.org> <20131016202123.GA17866@google.com>
 <CAMxnaaV1DhaxKo6h85Upa8sPQz2jSYSaW1OJ7+JtvR5F9sAYZw@mail.gmail.com>
 <CAErSpo4q0rcvkHX3_L2rcJrwT-Ofu4My8JXxtxH8gyULLxTDEw@mail.gmail.com>
 <CAE9FiQUMKSak4tWiyZ-N1_50M5ytUp-JAhb7GTG29Y1aRBPuSQ@mail.gmail.com>
 <CAErSpo5yhg1EgJmmOtJeh0myd50tJuu6qVMdVnwR276WTxL8kg@mail.gmail.com>
 <CAE9FiQUPgHtQ-p6R3MR+j=gKiQPcW5F2nqB=FwJdEovFLsuXjA@mail.gmail.com> <CAErSpo4qv2x1MjB=cW6QNevcQcq7dYtk-wC-HRTq8XEz2Xac-g@mail.gmail.com>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Sun, 27 Oct 2013 02:39:30 +0200
Message-ID: <CAMxnaaUdN7k7wjUKW53zELb9wRwBRU_arNXNwrJTSSMRH=rQZQ@mail.gmail.com>
Subject: Re: [3.11.4] Thunderbolt/PCI unplug oops in pci_pme_list_scan
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry, I didn't understand this.  Is this supposed to be an
> explanation of how 928bea fixes the oops that Andreas saw?  If so, can
> you be a little more explicit about when the pci_dev got freed and
> when pci_pme_list_scan() walked the list and accessed the freed area?

I did some more debugging and it seems that 928bea is innocent after
all. I added some debugging statements to pci_pme_active. The
additional delay seems to make the oops easier to trigger and I can
now replicate it up to
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=5137a2ee2007d9cbbbeebd14abe08357a079b607
which makes much more sense.

Here is what's going on (in 3.11). First of all pci_pme_activate is
only ever called with false as the second paramter during boot. Now
when I unplug the adapter, the first call is:
 [<ffffffff814b1cc7>] dump_stack+0x54/0x8d
 [<ffffffff812ae970>] pci_pme_active+0x30/0x210
 [<ffffffff813bf2bc>] ? pci_read+0x2c/0x30 (this should be pci_stop_dev imho)
 [<ffffffff812ac8ae>] pci_stop_bus_device+0x4e/0xa0
 [<ffffffff812ac89b>] pci_stop_bus_device+0x3b/0xa0
 [<ffffffff812ac89b>] pci_stop_bus_device+0x3b/0xa0
 [<ffffffff812aca02>] pci_stop_and_remove_bus_device+0x12/0x20
 [<ffffffff812c4698>] pciehp_unconfigure_device+0xa8/0x1b0
 [<ffffffff812c3ff8>] pciehp_disable_slot+0x68/0x200
 [<ffffffff812c4213>] pciehp_power_thread+0x83/0xf0
 [<ffffffff8107b5b8>] process_one_work+0x178/0x470
 [<ffffffff8107bf81>] worker_thread+0x121/0x3a0
 [<ffffffff8107be60>] ? manage_workers.isra.21+0x2b0/0x2b0
 [<ffffffff81082d80>] kthread+0xc0/0xd0
 [<ffffffff81060000>] ? SyS_unshare+0x220/0x280
 [<ffffffff81082cc0>] ? kthread_create_on_node+0x120/0x120
 [<ffffffff814c07ec>] ret_from_fork+0x7c/0xb0
 [<ffffffff81082cc0>] ? kthread_create_on_node+0x120/0x120
tg3 0000:0a:00.0: PME# disabled

This is still fine. But then it gets interesting. The next call is:
 [<ffffffff814b1cc7>] dump_stack+0x54/0x8d
 [<ffffffff812ae970>] pci_pme_active+0x30/0x210
 [<ffffffff812aebb5>] __pci_enable_wake+0x65/0x160
 [<ffffffff812aecd5>] pci_wake_from_d3+0x25/0x40
 [<ffffffffa0511c29>] tg3_power_down+0x29/0x40 [tg3]
 [<ffffffffa0511d4c>] tg3_close+0x10c/0x1d0 [tg3]
 [<ffffffff813d67b5>] __dev_close_many+0x85/0xd0
 [<ffffffff813d68cb>] dev_close_many+0x8b/0x100
 [<ffffffff813d8dd8>] rollback_registered_many+0xd8/0x250
 [<ffffffff813d8f7d>] rollback_registered+0x2d/0x40
 [<ffffffff813da828>] unregister_netdevice_queue+0x58/0xb0
 [<ffffffff813da89c>] unregister_netdev+0x1c/0x30
 [<ffffffffa050104b>] tg3_remove_one+0x6b/0x120 [tg3]
 [<ffffffff812b1b0b>] pci_device_remove+0x3b/0xb0
 [<ffffffff81371c1f>] __device_release_driver+0x7f/0xf0
 [<ffffffff81371cb3>] device_release_driver+0x23/0x30
 [<ffffffff81371484>] bus_remove_device+0xf4/0x170
 [<ffffffff8136df45>] device_del+0x135/0x1d0
 [<ffffffff812ac8f4>] pci_stop_bus_device+0x94/0xa0
 [<ffffffff812ac89b>] pci_stop_bus_device+0x3b/0xa0
 [<ffffffff812ac89b>] pci_stop_bus_device+0x3b/0xa0
 [<ffffffff812aca02>] pci_stop_and_remove_bus_device+0x12/0x20
 [<ffffffff812c4698>] pciehp_unconfigure_device+0xa8/0x1b0
 [<ffffffff812c3ff8>] pciehp_disable_slot+0x68/0x200
 [<ffffffff812c4213>] pciehp_power_thread+0x83/0xf0
 [<ffffffff8107b5b8>] process_one_work+0x178/0x470
 [<ffffffff8107bf81>] worker_thread+0x121/0x3a0
 [<ffffffff8107be60>] ? manage_workers.isra.21+0x2b0/0x2b0
 [<ffffffff81082d80>] kthread+0xc0/0xd0
 [<ffffffff81060000>] ? SyS_unshare+0x220/0x280
 [<ffffffff81082cc0>] ? kthread_create_on_node+0x120/0x120
 [<ffffffff814c07ec>] ret_from_fork+0x7c/0xb0
 [<ffffffff81082cc0>] ? kthread_create_on_node+0x120/0x120
tg3 0000:0a:00.0: PME# enabled

On removal tg3 calls pci_wake_from_d3 to enable/disable wake-on-lan.
This then calls pci_pme_activate(dev, true) for a device which is
about to be deleted. The linked commit does no longer call
pci_wake_from_d3, which "fixes" the problem.

Andreas
