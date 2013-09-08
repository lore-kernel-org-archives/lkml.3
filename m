Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab3IHIqR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 04:46:17 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17234 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab3IHIqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 04:46:14 -0400
Date: Sun, 8 Sep 2013 01:46:06 -0700
From: Jerry Snitselaar <jerry.snitselaar@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org
Subject: suspicious RCU usage with unlazy_walk()
Message-ID: <20130908084606.GA3938@cantor.Home>
Reply-To: Jerry Snitselaar <jerry.snitselaar@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running 3.11.0-07547-g44598f9 I hit the following last night. I have
not had it reproduce since then. Should there be some lock cleanup in
the error path prior to the dput() call like unlock_rcu_walk()?


[ 1705.083706] ===============================
[ 1705.083709] [ INFO: suspicious RCU usage. ]
[ 1705.083713] 3.11.0-07547-g44598f9 #1 Not tainted
[ 1705.083715] -------------------------------
[ 1705.083719] /home/snits/dev/linux/include/linux/rcupdate.h:471 Illegal context switch in RCU read-side critical section!
[ 1705.083721]
               other info that might help us debug this:

[ 1705.083726]
               rcu_scheduler_active = 1, debug_locks = 1
[ 1705.083730] 3 locks held by systemd-journal/384:
[ 1705.083733]  #0:  (&vfsmount_lock){++++..}, at: [<ffffffff811b7056>] path_init+0x196/0x5e0
[ 1705.083748]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff811b704a>] path_init+0x18a/0x5e0
[ 1705.083759]  #2:  (&(&fs->lock)->rlock){+.+...}, at: [<ffffffff811b6002>] unlazy_walk+0x62/0x2a0
[ 1705.083769]
               stack backtrace:
[ 1705.083775] CPU: 0 PID: 384 Comm: systemd-journal Not tainted 3.11.0-07547-g44598f9 #1
[ 1705.083778] Hardware name: Dell Inc. Studio XPS 8100/0G3HR7, BIOS A05 07/08/2010
[ 1705.083781]  0000000000000001 ffff880424c07c00 ffffffff817fd6ae ffff88042577c0e0
[ 1705.083791]  ffff880424c07c30 ffffffff810bd613 0000000000000000 ffffffff81c8a470
[ 1705.083799]  0000000000000205 ffff8803f5a3f838 ffff880424c07c58 ffffffff81084f17
[ 1705.083878] Call Trace:
[ 1705.083895]  [<ffffffff817fd6ae>] dump_stack+0x54/0x74
[ 1705.083907]  [<ffffffff810bd613>] lockdep_rcu_suspicious+0x103/0x110
[ 1705.083918]  [<ffffffff81084f17>] __might_sleep+0x57/0x210
[ 1705.083926]  [<ffffffff811c302d>] dput+0x3d/0x290
[ 1705.083932]  [<ffffffff811b6224>] unlazy_walk+0x284/0x2a0
[ 1705.083938]  [<ffffffff811b63c3>] lookup_fast+0x183/0x2a0
[ 1705.083945]  [<ffffffff811b76c5>] link_path_walk+0x225/0x8f0
[ 1705.083952]  [<ffffffff811bb567>] path_openat+0x237/0x640
[ 1705.083958]  [<ffffffff811bc17a>] do_filp_open+0x3a/0x90
[ 1705.083966]  [<ffffffff811cabaf>] ? __alloc_fd+0x1df/0x200
[ 1705.083973]  [<ffffffff811a9f9c>] do_sys_open+0x16c/0x200
[ 1705.083979]  [<ffffffff8100fe4d>] ? syscall_trace_enter+0x1fd/0x2c0
[ 1705.083985]  [<ffffffff811aa04e>] SyS_open+0x1e/0x20
[ 1705.083992]  [<ffffffff81810d54>] tracesys+0xdd/0xe2
[ 1705.083997] BUG: sleeping function called from invalid context at /home/snits/dev/linux/fs/dcache.c:517
[ 1705.084000] in_atomic(): 1, irqs_disabled(): 0, pid: 384, name: systemd-journal
[ 1705.084003] 3 locks held by systemd-journal/384:
[ 1705.084006]  #0:  (&vfsmount_lock){++++..}, at: [<ffffffff811b7056>] path_init+0x196/0x5e0
[ 1705.084018]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff811b704a>] path_init+0x18a/0x5e0
[ 1705.084028]  #2:  (&(&fs->lock)->rlock){+.+...}, at: [<ffffffff811b6002>] unlazy_walk+0x62/0x2a0
[ 1705.084041] CPU: 0 PID: 384 Comm: systemd-journal Not tainted 3.11.0-07547-g44598f9 #1
[ 1705.084044] Hardware name: Dell Inc. Studio XPS 8100/0G3HR7, BIOS A05 07/08/2010
[ 1705.084047]  ffffffff81c8a470 ffff880424c07c30 ffffffff817fd6ae 0000000000000000
[ 1705.084055]  ffff880424c07c58 ffffffff810850ba ffff8803f5a3f838 ffff88042ec042e8
[ 1705.084063]  0000000000000001 ffff880424c07c88 ffffffff811c302d ffff880424c07e60
[ 1705.084071] Call Trace:
[ 1705.084078]  [<ffffffff817fd6ae>] dump_stack+0x54/0x74
[ 1705.084084]  [<ffffffff810850ba>] __might_sleep+0x1fa/0x210
[ 1705.084090]  [<ffffffff811c302d>] dput+0x3d/0x290
[ 1705.084096]  [<ffffffff811b6224>] unlazy_walk+0x284/0x2a0
[ 1705.084102]  [<ffffffff811b63c3>] lookup_fast+0x183/0x2a0
[ 1705.084108]  [<ffffffff811b76c5>] link_path_walk+0x225/0x8f0
[ 1705.084114]  [<ffffffff811bb567>] path_openat+0x237/0x640
[ 1705.084120]  [<ffffffff811bc17a>] do_filp_open+0x3a/0x90
[ 1705.084126]  [<ffffffff811cabaf>] ? __alloc_fd+0x1df/0x200
[ 1705.084133]  [<ffffffff811a9f9c>] do_sys_open+0x16c/0x200
[ 1705.084138]  [<ffffffff8100fe4d>] ? syscall_trace_enter+0x1fd/0x2c0
[ 1705.084144]  [<ffffffff811aa04e>] SyS_open+0x1e/0x20
[ 1705.084149]  [<ffffffff81810d54>] tracesys+0xdd/0xe2
[ 1705.084154] BUG: scheduling while atomic: systemd-journal/384/0x10000004
[ 1705.084157] 3 locks held by systemd-journal/384:
[ 1705.084159]  #0:  (&vfsmount_lock){++++..}, at: [<ffffffff811b7056>] path_init+0x196/0x5e0
[ 1705.084170]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff811b704a>] path_init+0x18a/0x5e0
[ 1705.084181]  #2:  (&(&fs->lock)->rlock){+.+...}, at: [<ffffffff811b6002>] unlazy_walk+0x62/0x2a0
[ 1705.084192] Modules linked in: fuse ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_CHECKSUM iptable_mangle b\
ridge stp llc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ip6table_filter \
ip6_tables tun it87 hwmon_vid coretemp snd_hda_codec_hdmi uvcvideo snd_hda_codec_realtek videobuf2_vmalloc videobuf2_memops snd_hda_in\
tel snd_hda_codec snd_hwdep videobuf2_core snd_seq snd_seq_device snd_pcm videodev snd_page_alloc snd_timer snd broadcom tg3 ptp pcspk\
r lpc_ich mfd_core nfsd i7core_edac soundcore serio_raw pps_core i2c_i801 edac_core auth_rpcgss oid_registry nfs_acl lockd sunrpc binf\
mt_misc uinput autofs4 firewire_ohci firewire_core radeon drm_kms_helper ttm usb_storage kvm_intel kvm
[ 1705.084318] CPU: 0 PID: 384 Comm: systemd-journal Not tainted 3.11.0-07547-g44598f9 #1
[ 1705.084322] Hardware name: Dell Inc. Studio XPS 8100/0G3HR7, BIOS A05 07/08/2010
[ 1705.084325]  ffff88043fc13dc0 ffff880424c07bb8 ffffffff817fd6ae ffff88042577c0e0
[ 1705.084334]  ffff880424c07bd0 ffffffff817f569c ffff880424c06000 ffff880424c07c30
[ 1705.084343]  ffffffff81804357 0000000000013dc0 ffff880424c07fd8 ffff880424c07fd8
[ 1705.084351] Call Trace:
[ 1705.084358]  [<ffffffff817fd6ae>] dump_stack+0x54/0x74
[ 1705.084365]  [<ffffffff817f569c>] __schedule_bug+0x61/0x70
[ 1705.084376]  [<ffffffff81804357>] __schedule+0x97/0x9f0
[ 1705.084388]  [<ffffffff810884a6>] __cond_resched+0x26/0x30
[ 1705.084398]  [<ffffffff818050b7>] _cond_resched+0x37/0x50
[ 1705.084408]  [<ffffffff811c3032>] dput+0x42/0x290
[ 1705.084418]  [<ffffffff811b6224>] unlazy_walk+0x284/0x2a0
[ 1705.084427]  [<ffffffff811b63c3>] lookup_fast+0x183/0x2a0
[ 1705.084437]  [<ffffffff811b76c5>] link_path_walk+0x225/0x8f0
[ 1705.084447]  [<ffffffff811bb567>] path_openat+0x237/0x640
[ 1705.084458]  [<ffffffff811bc17a>] do_filp_open+0x3a/0x90
[ 1705.084469]  [<ffffffff811cabaf>] ? __alloc_fd+0x1df/0x200
[ 1705.084479]  [<ffffffff811a9f9c>] do_sys_open+0x16c/0x200
[ 1705.084488]  [<ffffffff8100fe4d>] ? syscall_trace_enter+0x1fd/0x2c0
[ 1705.084496]  [<ffffffff811aa04e>] SyS_open+0x1e/0x20
[ 1705.084501]  [<ffffffff81810d54>] tracesys+0xdd/0xe2
[ 1705.085038] BUG: scheduling while atomic: systemd-journal/384/0x10000004
[ 1705.085045] 3 locks held by systemd-journal/384:
[ 1705.085048]  #0:  (&vfsmount_lock){++++..}, at: [<ffffffff811b7056>] path_init+0x196/0x5e0
[ 1705.085065]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff811b704a>] path_init+0x18a/0x5e0
[ 1705.085078]  #2:  (&(&fs->lock)->rlock){+.+...}, at: [<ffffffff811b6002>] unlazy_walk+0x62/0x2a0
[ 1705.085090] Modules linked in: fuse ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_CHECKSUM iptable_mangle b\
ridge stp llc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ip6table_filter \
ip6_tables tun it87 hwmon_vid coretemp snd_hda_codec_hdmi uvcvideo snd_hda_codec_realtek videobuf2_vmalloc videobuf2_memops snd_hda_in\
tel snd_hda_codec snd_hwdep videobuf2_core snd_seq snd_seq_device snd_pcm videodev snd_page_alloc snd_timer snd broadcom tg3 ptp pcspk\
r lpc_ich mfd_core nfsd i7core_edac soundcore serio_raw pps_core i2c_i801 edac_core auth_rpcgss oid_registry nfs_acl lockd sunrpc binf\
mt_misc uinput autofs4 firewire_ohci firewire_core radeon drm_kms_helper ttm usb_storage kvm_intel kvm
[ 1705.085234] CPU: 3 PID: 384 Comm: systemd-journal Tainted: G        W    3.11.0-07547-g44598f9 #1
[ 1705.085239] Hardware name: Dell Inc. Studio XPS 8100/0G3HR7, BIOS A05 07/08/2010
[ 1705.085243]  ffff88043fcd3dc0 ffff880424c07b28 ffffffff817fd6ae ffff88042577c0e0
[ 1705.085255]  ffff880424c07b40 ffffffff817f569c ffff880424c06000 ffff880424c07ba0
[ 1705.085265]  ffffffff81804357 0000000000013dc0 ffff880424c07fd8 ffff880424c07fd8
[ 1705.085277] Call Trace:
[ 1705.085286]  [<ffffffff817fd6ae>] dump_stack+0x54/0x74
[ 1705.085293]  [<ffffffff817f569c>] __schedule_bug+0x61/0x70
[ 1705.085300]  [<ffffffff81804357>] __schedule+0x97/0x9f0
[ 1705.085309]  [<ffffffff810884a6>] __cond_resched+0x26/0x30
[ 1705.085316]  [<ffffffff818050b7>] _cond_resched+0x37/0x50
[ 1705.085324]  [<ffffffff811c623e>] clear_inode+0x2e/0x90
[ 1705.085333]  [<ffffffff81217603>] proc_evict_inode+0x23/0x70
[ 1705.085340]  [<ffffffff811c7039>] evict+0xa9/0x170
[ 1705.085347]  [<ffffffff811c7967>] iput+0x167/0x170
[ 1705.085355]  [<ffffffff811c3248>] dput+0x258/0x290
[ 1705.085362]  [<ffffffff811b6224>] unlazy_walk+0x284/0x2a0
[ 1705.085369]  [<ffffffff811b63c3>] lookup_fast+0x183/0x2a0
[ 1705.085377]  [<ffffffff811b76c5>] link_path_walk+0x225/0x8f0
[ 1705.085385]  [<ffffffff811bb567>] path_openat+0x237/0x640
[ 1705.085393]  [<ffffffff811bc17a>] do_filp_open+0x3a/0x90
[ 1705.085401]  [<ffffffff811cabaf>] ? __alloc_fd+0x1df/0x200
[ 1705.085409]  [<ffffffff811a9f9c>] do_sys_open+0x16c/0x200
[ 1705.085416]  [<ffffffff8100fe4d>] ? syscall_trace_enter+0x1fd/0x2c0
[ 1705.085423]  [<ffffffff811aa04e>] SyS_open+0x1e/0x20
[ 1705.085431]  [<ffffffff81810d54>] tracesys+0xdd/0xe2
[ 1705.085844] BUG: spinlock wrong CPU on CPU#3, systemd-journal/384
[ 1705.085847] irq event stamp: 7395
[ 1705.085854] hardirqs last  enabled at (7395): [<ffffffff81807195>] _raw_spin_unlock_irqrestore+0x45/0x60
[ 1705.085858] hardirqs last disabled at (7394): [<ffffffff81806fac>] _raw_spin_lock_irqsave+0x1c/0x60
[ 1705.085866]  lock: 0xffff880423859c88, .magic: dead4ead, .owner: systemd-journal/384, .owner_cpu: 0
[ 1705.085869] CPU: 3 PID: 384 Comm: systemd-journal Tainted: G        W    3.11.0-07547-g44598f9 #1
[ 1705.085871] Hardware name: Dell Inc. Studio XPS 8100/0G3HR7, BIOS A05 07/08/2010
[ 1705.085873]  ffff880423859c88 ffff880424c07c18
[ 1705.085876] softirqs last  enabled at (806):
[ 1705.085880] [<ffffffff81054908>] __do_softirq+0x358/0x460
[ 1705.085882] softirqs last disabled at (793):
[ 1705.085885] [<ffffffff81054b87>] irq_exit+0x67/0x120
[ 1705.085889]  ffffffff817fd6ae
[ 1705.085897]  ffff88042577c0e0
[ 1705.085907]  ffff880424c07c38 ffffffff817fd75a ffff880423859c88 ffffffff81cb85b2
[ 1705.085928]  ffff880424c07c58 ffffffff817fd780 ffff880423859c88 ffff88042ec042e8
[ 1705.085949] Call Trace:
[ 1705.085960]  [<ffffffff817fd6ae>] dump_stack+0x54/0x74
[ 1705.085964]  [<ffffffff817fd75a>] spin_dump+0x8c/0x91
[ 1705.085968]  [<ffffffff817fd780>] spin_bug+0x21/0x26
[ 1705.085973]  [<ffffffff813ffb9c>] do_raw_spin_unlock+0x7c/0xa0
[ 1705.085977]  [<ffffffff818070e7>] _raw_spin_unlock+0x27/0x40
[ 1705.085981]  [<ffffffff811b61c0>] unlazy_walk+0x220/0x2a0
[ 1705.085985]  [<ffffffff811b63c3>] lookup_fast+0x183/0x2a0
[ 1705.085989]  [<ffffffff811b76c5>] link_path_walk+0x225/0x8f0
[ 1705.085993]  [<ffffffff811bb567>] path_openat+0x237/0x640
[ 1705.085997]  [<ffffffff811bc17a>] do_filp_open+0x3a/0x90
[ 1705.086002]  [<ffffffff811cabaf>] ? __alloc_fd+0x1df/0x200
[ 1705.086006]  [<ffffffff811a9f9c>] do_sys_open+0x16c/0x200
[ 1705.086010]  [<ffffffff8100fe4d>] ? syscall_trace_enter+0x1fd/0x2c0
[ 1705.086013]  [<ffffffff811aa04e>] SyS_open+0x1e/0x20
[ 1705.086017]  [<ffffffff81810d54>] tracesys+0xdd/0xe2
