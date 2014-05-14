Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaENBKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 21:10:37 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:50946 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaENBKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 21:10:33 -0400
MIME-Version: 1.0
Date: Tue, 13 May 2014 18:10:31 -0700
Message-ID: <CA+HUmGixw4HMDb9xT2hGBna8TGa-WWsZ_HXumB4Np-W2DQOAXA@mail.gmail.com>
Subject: kernel crash in bus_find_device
From: Francesco Ruggeri <fruggeri@arista.com>
To: linux-kernel@vger.kernel.org
Cc: Francesco Ruggeri <fruggeri@arista.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While scanning devices on pci_bus_type I ran into the crash below.
The immediate cause of the crash is that bus_find_device is trying to resume
a scan starting from a device that has been unregistered (and whose knode_bus
has already been klist_del' ed).
The main issue seems to be that when resuming a scan the caller should
be holding a
reference to the klist_node, but instead it relies on holding a
reference to the device.
I played with a couple of narrow fixes, but a clean solution would
affect quite a bit of code.

Has anybody run into this before?

Thanks,
Francesco Ruggeri


------------[ cut here ]------------
WARNING: at /bld/EosKernel/Artools-rpmbuild/linux-3.4/include/linux/kref.h:41
klist_iter_init_node+0x30/0x38()
Modules linked in: pci_scan(O) sch_prio sand_dma(PO) arista_bde(PO)
macvlan ip6table_mangle iptable_mangle msr nf_conntrack_ipv6
nf_defrag_ipv6 ip6t_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_LOG
xt_limit ipt_REJECT xt_hl xt_state xt_multiport xt_tcpudp kbfd(O)
8021q garp stp llc tun scd_em_driver(O) nf_conntrack_tftp iptable_raw
iptable_filter ip_tables xt_NOTRACK nf_conntrack xt_mark ip6table_raw
ip6table_filter ip6_tables x_tables scd(O) k8temp amd64_edac_mod hwmon
kvm_amd kvm
Pid: 6861, comm: pci_scan_0 Tainted: P           O
3.4.43.Ar-1797671.flbocafruggeri #1
Call Trace:
 [<ffffffff81029dc4>] warn_slowpath_common+0x80/0x98
 [<ffffffff811b57f1>] ? pci_do_find_bus+0x49/0x49
 [<ffffffff81029df1>] warn_slowpath_null+0x15/0x17
 [<ffffffff813a43ce>] klist_iter_init_node+0x30/0x38
 [<ffffffff8120e57e>] bus_find_device+0x48/0x90
 [<ffffffff811b5908>] pci_get_dev_by_id+0x5e/0x81
 [<ffffffff811b5a6a>] pci_get_subsys+0x5c/0x7f
 [<ffffffff811b5a9e>] pci_get_device+0x11/0x13
 [<ffffffffa00b2087>] pci_scan+0x39/0x8a [pci_scan]
 [<ffffffffa00b204e>] ? init_module+0x3c/0x3c [pci_scan]
 [<ffffffff81040e6e>] kthread+0x84/0x8c
 [<ffffffff813c8b14>] kernel_thread_helper+0x4/0x10
 [<ffffffff81040dea>] ? __init_kthread_worker+0x37/0x37
 [<ffffffff813c8b10>] ? gs_change+0xb/0xb
---[ end trace 79cea1ec476672fe ]---
------------[ cut here ]------------
WARNING: at /bld/EosKernel/Artools-rpmbuild/linux-3.4/lib/klist.c:189
klist_release+0x2b/0xeb()
Modules linked in: pci_scan(O) sch_prio sand_dma(PO) arista_bde(PO)
macvlan ip6table_mangle iptable_mangle msr nf_conntrack_ipv6
nf_defrag_ipv6 ip6t_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_LOG
xt_limit ipt_REJECT xt_hl xt_state xt_multiport xt_tcpudp kbfd(O)
8021q garp stp llc tun scd_em_driver(O) nf_conntrack_tftp iptable_raw
iptable_filter ip_tables xt_NOTRACK nf_conntrack xt_mark ip6table_raw
ip6table_filter ip6_tables x_tables scd(O) k8temp amd64_edac_mod hwmon
kvm_amd kvm
Pid: 6861, comm: pci_scan_0 Tainted: P        W  O
3.4.43.Ar-1797671.flbocafruggeri #1
Call Trace:
 [<ffffffff81029dc4>] warn_slowpath_common+0x80/0x98
 [<ffffffff8120de13>] ? bus_get_device_klist+0x10/0x10
 [<ffffffff81029df1>] warn_slowpath_null+0x15/0x17
 [<ffffffff813a440e>] klist_release+0x2b/0xeb
 [<ffffffff813a44ec>] klist_dec_and_del+0x1e/0x25
 [<ffffffff813a4528>] klist_next+0x35/0xc9
 [<ffffffff811b57f1>] ? pci_do_find_bus+0x49/0x49
 [<ffffffff8120deb3>] next_device+0x9/0x19
 [<ffffffff8120e5a2>] bus_find_device+0x6c/0x90
 [<ffffffff811b5908>] pci_get_dev_by_id+0x5e/0x81
 [<ffffffff811b5a6a>] pci_get_subsys+0x5c/0x7f
 [<ffffffff811b5a9e>] pci_get_device+0x11/0x13
 [<ffffffffa00b2087>] pci_scan+0x39/0x8a [pci_scan]
 [<ffffffffa00b204e>] ? init_module+0x3c/0x3c [pci_scan]
 [<ffffffff81040e6e>] kthread+0x84/0x8c
 [<ffffffff813c8b14>] kernel_thread_helper+0x4/0x10
 [<ffffffff81040dea>] ? __init_kthread_worker+0x37/0x37
 [<ffffffff813c8b10>] ? gs_change+0xb/0xb
---[ end trace 79cea1ec476672ff ]---
general protection fault: 0000 [#1] PREEMPT SMP
CPU 1
Modules linked in: pci_scan(O) sch_prio sand_dma(PO) arista_bde(PO)
macvlan ip6table_mangle iptable_mangle msr nf_conntrack_ipv6
nf_defrag_ipv6 ip6t_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_LOG
xt_limit ipt_REJECT xt_hl xt_state xt_multiport xt_tcpudp kbfd(O)
8021q garp stp llc tun scd_em_driver(O) nf_conntrack_tftp iptable_raw
iptable_filter ip_tables xt_NOTRACK nf_conntrack xt_mark ip6table_raw
ip6table_filter ip6_tables x_tables scd(O) k8temp amd64_edac_mod hwmon
kvm_amd kvm

Pid: 6861, comm: pci_scan_0 Tainted: P        W  O
3.4.43.Ar-1797671.flbocafruggeri #1
RIP: 0010:[<ffffffff813a442c>]  [<ffffffff813a442c>] klist_release+0x49/0xeb
RSP: 0018:ffff88001c55bd50  EFLAGS: 00010293
RAX: dead000000200200 RBX: ffff880030949e78 RCX: ffff880000000010
RDX: dead000000100100 RSI: 0000000000000000 RDI: dead000000200200
RBP: ffff88001c55bd70 R08: dead000000100100 R09: 000000000000000a
R10: 0000000000000000 R11: ffffffff81619920 R12: ffff880030949e90
R13: ffff880030949e78 R14: ffffffff8120de13 R15: ffff880027e717e0
FS:  0000000000000000(0000) GS:ffff88013fb00000(0000) knlGS:00000000f73bc6d0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000009012644 CR3: 0000000069f9e000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process pci_scan_0 (pid: 6861, threadinfo ffff88001c55a000, task
ffff880032ffd340)
Stack:
 ffff880030949e78 ffff88001c55bde0 dead000000100100 ffff880030949e78
 ffff88001c55bd80 ffffffff813a44ec ffff88001c55bdc0 ffffffff813a4528
 ffff88001c55bde0 ffff880027e717e0 ffffffff811b57f1 ffff88001c55bde0
Call Trace:
 [<ffffffff813a44ec>] klist_dec_and_del+0x1e/0x25
 [<ffffffff813a4528>] klist_next+0x35/0xc9
 [<ffffffff811b57f1>] ? pci_do_find_bus+0x49/0x49
 [<ffffffff8120deb3>] next_device+0x9/0x19
 [<ffffffff8120e5a2>] bus_find_device+0x6c/0x90
 [<ffffffff811b5908>] pci_get_dev_by_id+0x5e/0x81
 [<ffffffff811b5a6a>] pci_get_subsys+0x5c/0x7f
 [<ffffffff811b5a9e>] pci_get_device+0x11/0x13
 [<ffffffffa00b2087>] pci_scan+0x39/0x8a [pci_scan]
 [<ffffffffa00b204e>] ? init_module+0x3c/0x3c [pci_scan]
 [<ffffffff81040e6e>] kthread+0x84/0x8c
 [<ffffffff813c8b14>] kernel_thread_helper+0x4/0x10
 [<ffffffff81040dea>] ? __init_kthread_worker+0x37/0x37
 [<ffffffff813c8b10>] ? gs_change+0xb/0xb
Code: 00 48 c7 c7 a1 01 51 81 e8 ce 59 c8 ff 49 8b 54 24 f0 49 8b 44
24 f8 49 b8 00 01 10 00 00 00 ad de 48 bf 00 02 20 00 00 00 ad de <48>
89 42 08 48 89 10 49 89 7c 24 f8 4d 89 44 24 f0 48 c7 c7 30
RIP  [<ffffffff813a442c>] klist_release+0x49/0xeb
 RSP <ffff88001c55bd50>
