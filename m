Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab3JNWr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 18:47:59 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:61091 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255Ab3JNWr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 18:47:58 -0400
MIME-Version: 1.0
From: Andreas Noever <andreas.noever@gmail.com>
Date: Tue, 15 Oct 2013 00:47:36 +0200
Message-ID: <CAMxnaaUim-MCDpaTiLmBqN3wfxjn9V6XE_n4SMfuO=vqeT6rVA@mail.gmail.com>
Subject: [3.11.4] Thunderbolt/PCI unplug oops in pci_pme_list_scan
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I unplug the Thunderbolt ethernet adapter on my MacBookPro Linux
crashes a few seconds later. Using
echo 1 > /sys/bus/pci/devices/0000:08:00.0/remove
to remove a bridge two levels above the device triggers the fault immediately:

pciehp 0000:09:00.0:pcie24: unloading service driver pciehp
pci_bus 0000:0a: busn_res: [bus 0a] is released
pci_bus 0000:09: busn_res: [bus 09-0a] is released
general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
....
Workqueue: events pci_pme_list_scan
task: ffff88044b0b8000 ti: ffff88044ac62000 task.ti: ffff88044ac62000
RIP: 0010:[<ffffffff812bdc8c>]  [<ffffffff812bdc8c>] pci_pme_list_scan+0x3c/0xe0
RSP: 0018:ffff88044ac63e10  EFLAGS: 00010202
RAX: ffff88045601e7b0 RBX: ffffffff8187b070 RCX: 0000000000000000
RDX: 6b6b6b6b6b6b6b6b RSI: ffff88044ac63da0 RDI: ffff880453250ca8
RBP: ffff88044ac63e20 R08: ffff88044ac63da0 R09: 0001f9e0c287afc0
R10: 0001f9e0c287afc0 R11: 0000000000000000 R12: ffff880453250ca8
R13: ffff88046d053d00 R14: ffff88046d058200 R15: ffffffff8187afc8
FS:  0000000000000000(0000) GS:ffff88046d040000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd301d57000 CR3: 000000000280d000 CR4: 00000000001407e0
Stack:
 ffffffff8187afc0 ffff88044a920e40 ffff88044ac63e68 ffffffff8107ddd6
 000000006d053d00 0000000000000000 ffff88046d053d00 ffff88046d053d18
 ffff88044a920e70 ffff88044b0b8000 ffff88044a920e40 ffff88044ac63ec8
Call Trace:
 [<ffffffff8107ddd6>] process_one_work+0x176/0x470
 [<ffffffff8107e79b>] worker_thread+0x11b/0x3a0
 [<ffffffff8107e680>] ? manage_workers.isra.21+0x2b0/0x2b0
 [<ffffffff810855e0>] kthread+0xc0/0xd0
 [<ffffffff81085520>] ? kthread_create_on_node+0x110/0x110
 [<ffffffff814f4c2c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81085520>] ? kthread_create_on_node+0x110/0x110
Code: 54 53 e8 f8 c6 22 00 4c 8b 25 01 d4 5b 00 49 81 fc 70 b0 87 81
0f 84 98 00 00 00 49 8b 1c 24 4c 89 e7 eb 36 0f 1f 00 48 8b 50 10 <48>
8b 52 38 48 85 d2 74 07 8b 4a 78 85 c9 75 0a 31 f6 48 89 c7
RIP  [<ffffffff812bdc8c>] pci_pme_list_scan+0x3c/0xe0
 RSP <ffff88044ac63e10>
---[ end trace 3905f90a7dacf7b3 ]---

The offending line is:
(gdb) list *(pci_pme_list_scan+0x3c)
0xffffffff812bdc8c is in pci_pme_list_scan (drivers/pci/pci.c:1551).
1546            if (!list_empty(&pci_pme_list)) {
1547                    list_for_each_entry_safe(pme_dev, n,
&pci_pme_list, list) {
1548                            if (pme_dev->dev->pme_poll) {
1549                                    struct pci_dev *bridge;
1550
1551                                    bridge = pme_dev->dev->bus->self;
1552                                    /*
1553                                     * If bridge is in low power state, the
1554                                     * configuration space of
subordinate devices
1555                                     * may be not accessible
If I read the disassembly correctly then the deref of bus seems to
cause the oops.

An almost identical bug was reported (and fixed) some time ago:
http://lkml.indiana.edu/hypermail/linux/kernel/1302.1/01165.html

Andreas
