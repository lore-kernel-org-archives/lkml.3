Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaKYUUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:20:42 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41875 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaKYUUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:20:40 -0500
Message-ID: <5474E537.7010707@oracle.com>
Date: Tue, 25 Nov 2014 15:23:19 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: xen-devel <xen-devel@lists.xenproject.org>
CC: Ian Campbell <ian.campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, davem@davemloft.net,
        programme110@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Regression in netfilter code under Xen
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a regression due to (5195c14c8: netfilter: conntrack: fix race 
in __nf_conntrack_confirm against get_next_corpse). I have not been able 
to reproduce this on baremetal but dom0 crashes reliably after a few 
seconds of idle time. This doesn't appear to be dependent on Xen version 
--- I saw it on at least a 4.2 and unstable).

I don't know much about networking (and will be out for most of the rest 
of the week) so I wonder whether anyone has any ideas. The stack is below.


Thanks.
-boris

# 
[ 
54.901368] general protection fault: 0000 [#1] SMP
[   54.919324] Modules linked in: dm_multipath dm_mod xen_evtchn 
iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport 
libcrc32c crc32c_generic crc32c_intel sg sr_mod cdrom sd_mod i915 fbcon 
tileblit font bitblit softcursor tpm_tis ahci libahci libata 
drm_kms_helper video scsi_mod e1000e wmi xen_blkfront xen_netfront 
fb_sys_fops sysimgblt sysfillrect syscopyarea xenfs xen_privcmd
[   54.996767] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 
3.18.0-rc5upstream-00179-g8a84e01 #1
[   55.016730] Hardware name: LENOVO ThinkServer TS130/        , BIOS 
9HKT47AUS 01/10/2012
[   55.036873] task: ffff880037e48a10 ti: ffff880037e54000 task.ti: 
ffff880037e54000
[   55.057338] RIP: e030:[<ffffffff815ea29e>] [<ffffffff815ea29e>] 
nf_ct_del_from_dying_or_unconfirmed_list+0x3e/0x70
[   55.[   55.099069] RAX: dead000000200200 RBX: ffffe8ffffc89108 RCX: 
ffffffff81cc5820
[   55.119918] RDX: 0000000080000001 RSI: 0000000000000011 RDI: 
ffffe8ffffc89108
[   55.140768] RBP: ffff88003e283908 R08: 00000000c5f889ff R09: 
00000000a1a10f28
[   55.161785] R10: ffff880037e5f1b8 R11: 0000000000000001 R12: 
ffff880037e5f148
[   55.183005] R13: ffffffff815e6a6b R14: ffff88002bed8400 R15: 
ffff88002bb30000
[   55.204214] FS:  00007f668f694700(0000) GS[   55.225733] CS: e033 
DS: 002b ES: 002b CR0: 0000000080050033
[   55.247220] CR2: 00007f66c0a598eb CR3: 000000002bc39000 CR4: 
0000000000042660
[   55.268863] Stack:
[   55.290200]  ffff880037e5f148 ffffffff81c98080 ffff88003e283928 
ffffffff815eb59d
[   55.312068]  ffff88002bed8400 ffff88002bed8400 ffff88003e283938 
ffffffff815e689a
[   55.333849]  ffff88003e283958 ffffffff815a37a5 ffff88003e283968 
ffff88002bed8400
[   55.355449] Call Trace:
[   55.376552]  <IRQ>
[   55.376728]  [<ffffffff815eb59d>] destroy_conntrack+0x5d/0xc0
[   55.418187]  [<ffffffff815e689a>] nf_conntrack_destroy+0x1a/0x40
[   55.439349]  [<ffffffff815a37a5>] skb_release_head_state+0x85/0xd0
[   55.460468]  [<ffffffff815a5d61>] skb_release_all+0x11/0x30
[   55.481440]  [<ffffffff815a5dd1>] __kfree_skb+0x11/0xc0
[   55.502239]  [<ffffffff815a5f78>] kfree_skb+0x38/0xa0
[   55.522661]  [<ffffffff816044b0>] ? ip_rcv+0x3a0/0x3a0
[   55.542811]  [<ffffffff816044b0>] ? ip_rcv+0x3a0/0x3a0
[   55.562543]  [<ffffffff815e6a6b>] nf_hook_slow+0x10b/0x120
[   55.582100]  [<ffffffff816044b0>] ? ip_rcv+0x3a0/0x3a0
[   55.601470]  [<ffffffff8170a02b>] ? _raw_spin_unlock_irqrestore+0[   
55.620900] [<ffffffff81604713>] ip_local_deliver+0x73/0x80
[   55.640154]  [<ffffffff81603dc9>] ip_rcv_finish+0x109/0x310
[   55.659244]  [<ffffffff8160439c>] ip_rcv+0x28c/0x3a0
[   55.678287]  [<ffffffff815b69ae>] 
__netif_receive_skb_core+0x58e/0x[   55.697287] [<ffffffff815b6b4d>] 
__netif_receive_skb+0x1d/0x70
[   55.715820]  [<ffffffff815b6d9e>] netif_receive_skb_internal+0x1e/0xb0
[   55.734442]  [<ffffffff815b6e47>] netif_receive_skb+0x17/0x70
[   55.752898]  [<ffffffff816c17e2>] br_handle_frame_finish+0x192/0x360
[   55.771709]  [<ffffffff816c156d>] br_handle_frame+0
[   55.790274]  [<ffffffff816c13f0>] ? br_handle_local_finish+0x40/0x40
[   55.808760]  [<ffffffff815b65f7>] __netif_receive_skb_core+0x1d7/0x710
[   55.827302]  [<ffffffff815b6b4d>] __netif_receive_skb+0x1d/0x70
[   55.845594]  [<ffffffff815b6d9e>] netif_receive_skb_internal+0x1e/0xb0
[   55.863836]  [<ffffffff815b7a38>] napi_gro_receive+0x118/0x1a0
[   55.881549]  [<ffffffff814c430f>] tg3_poll_work+0xe1f/0x1[   
55.898629]  [<ffffffff814d75c9>] tg3_poll+0x69/0x3c0
[   55.915010]  [<ffffffff815b7523>] net_rx_action+0x103/0x290
[   55.930840]  [<ffffffff810a7713>] __do_softirq+0xf3/0x2e0
[   55.946310]  [<ffffffff810a7a2d>] irq_exit+0xcd/0xe0
[   55.961399]  [<ffffffff8140d4c7>] xen_evtchn_do_upcall+0x37/0x50
766]  [<ffffffff8170c1fe>] xen_do_hypervisor_callback+0x1e/0x30
[   55.990802]  <EOI>
[   55.990977]  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
[   56.018897]  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
[   56.032815]  [<ffffffff810454b0>] ? xen_safe_halt+0x10/0x20
[   56.046583]  [<ffffffff81059e3a>] ? default_idle+0x1a/0xd0
[   56.060307]  [<ffffffff8105950a>] ? arch_cpu_idle+0xa/0x10
[   56.073920]  [<ffffffff810de483>] ? cpu_startup_entry+0x2d3/0[   
56.100421]  [<ffffffff8104c355>] ? cpu_bringup_and_idle+0x25/0x40
[   56.113427] Code: 98 08 08 00 00 0f b7 47 08 48 03 1c c5 a0 42 cc 81 
48 89 df e8 94 fc 11 00 49 8b 44 24 18 48 85 c0 74 2d 49[   
56.141507] RIP  [<ffffffff815ea29e>] 
nf_ct_del_from_dying_or_unconfirmed_list+0x3e/0x70
[   56.155425]  RSP <ffff88003e2838f8>
[   56.169234] ---[ end trace 4c64578e4c629cc4 ]---
[   56.182913] Kernel panic - not syncing: Fatal exception in interrupt
[   56.197026] Kernel Offset: 0x0 from 0xffffffff81000k  text console
(XEN) [2014-11-23 06:05:48] Domain 0 crashed: rebooting machine in 5 
seconds.
(XEN) [2014-11-23 06:05:53] Resetting with ACPI MEMORY or I/O RESET_REG.

