Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaIYIaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:30:13 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:56331 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaIYIaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:30:09 -0400
Message-ID: <1411633803.15810.12.camel@marge.simpson.net>
Subject: Re: [PATCH 00/11] nested sleeps, fixes and debug infrastructure
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, ilya.dryomov@inktank.com,
        linux-kernel@vger.kernel.org
Date: Thu, 25 Sep 2014 10:30:03 +0200
In-Reply-To: <20140924081845.572814794@infradead.org>
References: <20140924081845.572814794@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-24 at 10:18 +0200, Peter Zijlstra wrote: 
> Hi,
> 
> This is a refresh of the nested sleep debug stuff which I posted as an RFC a
> while back: lkml.kernel.org/r/20140804103025.478913141@infradead.org
> 
> Since then a number of issues identified by these patches have allready made
> their way upstream:
> 
>     de713b57947a ("atm/svc: Fix blocking in wait loop")
>     7c3af9752573 ("nfs: don't sleep with inode lock in lock_and_join_requests")
> 
> And I finally got some time to finish up these patches so we could merge them.
> So please have a look and if nobody holllers we'll merge this 'soon'.

My DL980 hollered itself to death while booting.

[   39.587224] do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff811021d0>] kauditd_thread+0x130/0x1e0
[   39.706325] Modules linked in: iTCO_wdt(E) gpio_ich(E) iTCO_vendor_support(E) joydev(E) i7core_edac(E) lpc_ich(E) hid_generic(E) hpwdt(E) mfd_core(E) edac_core(E) bnx2(E) shpchp(E) sr_mod(E) ehci_pci(E) hpilo(E) netxen_nic(E) ipmi_si(E) cdrom(E) pcspkr(E) sg(E) acpi_power_meter(E) ipmi_msghandler(E) button(E) ext4(E) jbd2(E) mbcache(E) crc16(E) usbhid(E) radeon(E) ttm(E) drm_kms_helper(E) drm(E) i2c_algo_bit(E) uhci_hcd(E) ehci_hcd(E) usbcore(E) sd_mod(E) thermal(E) usb_common(E) processor(E) scsi_dh_hp_sw(E) scsi_dh_emc(E) scsi_dh_rdac(E) scsi_dh_alua(E) scsi_dh(E) ata_generic(E) ata_piix(E) libata(E) hpsa(E) cciss(E) scsi_mod(E)
[   40.373599] CPU: 9 PID: 1974 Comm: kauditd Tainted: G            E  3.17.0-default #2
[   40.506928] Hardware name: Hewlett-Packard ProLiant DL980 G7, BIOS P66 07/07/2010
[   40.613753]  0000000000001bd9 ffff88026f3d3d78 ffffffff815b2fc2 ffff88026f3d3db8
[   40.728720]  ffffffff8106613c ffff88026f3d3da8 ffff88026b4fa110 0000000000000000
[   40.816116]  0000000000000038 ffffffff8180ff47 ffff88026f3d3e58 ffff88026f3d3e18
[   40.905088] Call Trace:
[   40.938325]  [<ffffffff815b2fc2>] dump_stack+0x72/0x88
[   41.000143]  [<ffffffff8106613c>] warn_slowpath_common+0x8c/0xc0
[   41.067996]  [<ffffffff81066226>] warn_slowpath_fmt+0x46/0x50
[   41.132669]  [<ffffffff811021d0>] ? kauditd_thread+0x130/0x1e0
[   41.204105]  [<ffffffff811021d0>] ? kauditd_thread+0x130/0x1e0
[   41.270699]  [<ffffffff8108d214>] __might_sleep+0x84/0xa0
[   41.333979]  [<ffffffff8110224b>] kauditd_thread+0x1ab/0x1e0
[   41.398612]  [<ffffffff810940c0>] ? try_to_wake_up+0x210/0x210
[   41.465435]  [<ffffffff811020a0>] ? audit_printk_skb+0x70/0x70
[   41.534628]  [<ffffffff810859db>] kthread+0xeb/0x100
[   41.596562]  [<ffffffff810858f0>] ? kthread_freezable_should_stop+0x80/0x80
[   41.678973]  [<ffffffff815b85bc>] ret_from_fork+0x7c/0xb0
[   41.742073]  [<ffffffff810858f0>] ? kthread_freezable_should_stop+0x80/0x80

Then printk() went gaga printing eg ** 54502 printk messages dropped **
plus snippets of above endlessly, so I had to power reset.

Without your patches, but CONFIG_DEBUG_ATOMIC_SLEEP still enabled, there
was a reboot time gripe.  My other boxen seems to be gripe free.

[ 1031.427792] BUG: sleeping function called from invalid context at include/linux/netdevice.h:476
[ 1031.522628] in_atomic(): 1, irqs_disabled(): 0, pid: 23854, name: ip
[ 1031.591809] CPU: 61 PID: 23854 Comm: ip Tainted: G            E  3.17.0-default #1
[ 1031.673757] Hardware name: Hewlett-Packard ProLiant DL980 G7, BIOS P66 07/07/2010
[ 1031.756990]  ffff88026b486800 ffff8800792ab568 ffffffff815b2462 ffff8800792ab578
[ 1031.836756]  ffffffff8108cf46 ffff8800792ab5a8 ffffffffa02e4df4 ffff880272595200
[ 1031.915786]  0000000000000001 ffff880272595280 ffff880274527000 ffff8800792ab5f8
[ 1032.021354] Call Trace:
[ 1032.049208]  [<ffffffff815b2462>] dump_stack+0x72/0x88
[ 1032.107115]  [<ffffffff8108cf46>] __might_sleep+0xd6/0x110
[ 1032.168179]  [<ffffffffa02e4df4>] netxen_napi_disable+0x94/0xf0 [netxen_nic]
[ 1032.245813]  [<ffffffffa02e79f0>] __netxen_nic_down+0x160/0x1d0 [netxen_nic]
[ 1032.327204]  [<ffffffffa02e7d1b>] netxen_nic_close+0x1b/0x20 [netxen_nic]
[ 1032.407045]  [<ffffffff814bafed>] __dev_close_many+0x9d/0xf0
[ 1032.472971]  [<ffffffff814bb076>] __dev_close+0x36/0x50
[ 1032.531286]  [<ffffffff814bc36c>] __dev_change_flags+0xac/0x180
[ 1032.596742]  [<ffffffff814bc477>] dev_change_flags+0x37/0x80
[ 1032.658692]  [<ffffffff814cf214>] do_setlink+0x244/0x7e0
[ 1032.718090]  [<ffffffff814d0cb0>] rtnl_newlink+0x5a0/0x7d0
[ 1032.778735]  [<ffffffff814d085a>] ? rtnl_newlink+0x14a/0x7d0
[ 1032.840688]  [<ffffffff814d0321>] rtnetlink_rcv_msg+0xa1/0x240
[ 1032.905125]  [<ffffffff813084a6>] ? rhashtable_lookup_compare+0x46/0x70
[ 1032.981889]  [<ffffffff814d0280>] ? __rtnl_unlock+0x20/0x20
[ 1033.043229]  [<ffffffff814ef619>] netlink_rcv_skb+0x89/0xb0
[ 1033.103637]  [<ffffffff814d051c>] rtnetlink_rcv+0x2c/0x40
[ 1033.163646]  [<ffffffff814ef019>] netlink_unicast+0x119/0x180
[ 1033.227938]  [<ffffffff81305f4c>] ? memcpy_fromiovec+0x6c/0x90
[ 1033.293557]  [<ffffffff814efa1a>] netlink_sendmsg+0x3da/0x470
[ 1033.355779]  [<ffffffff814a4dfc>] sock_sendmsg+0x9c/0xd0
[ 1033.417217]  [<ffffffff810a8583>] ? __wake_up+0x53/0x70
[ 1033.480884]  [<ffffffff81164e15>] ? unlock_page+0x65/0x70
[ 1033.541126]  [<ffffffff81192053>] ? might_fault+0x43/0x50
[ 1033.599727]  [<ffffffff814b2a6e>] ? verify_iovec+0x5e/0xf0
[ 1033.659925]  [<ffffffff814a5756>] ___sys_sendmsg+0x436/0x440
[ 1033.723060]  [<ffffffff81198283>] ? handle_pte_fault+0x213/0x260
[ 1033.789348]  [<ffffffff814a289f>] ? copy_to_user+0x2f/0x40
[ 1033.849237]  [<ffffffff81198429>] ? __handle_mm_fault+0x159/0x330
[ 1033.915082]  [<ffffffff811986ff>] ? handle_mm_fault+0xff/0x1b0
[ 1033.979227]  [<ffffffff81051d5c>] ? __do_page_fault+0x2dc/0x4c0
[ 1034.065054]  [<ffffffff8119c3c1>] ? __vma_link_rb+0x101/0x120
[ 1034.135430]  [<ffffffff8119dc38>] ? do_brk+0x1c8/0x340
[ 1034.193893]  [<ffffffff814a2e52>] ? SyS_getsockname+0xb2/0xc0
[ 1034.257707]  [<ffffffff814a5939>] __sys_sendmsg+0x49/0x80
[ 1034.317279]  [<ffffffff814a5989>] SyS_sendmsg+0x19/0x20
[ 1034.376290]  [<ffffffff815b7969>] system_call_fastpath+0x16/0x1b


