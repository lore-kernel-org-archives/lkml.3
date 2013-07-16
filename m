Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab3GPO2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 10:28:39 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:59526 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444Ab3GPO2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 10:28:37 -0400
Message-ID: <51E557C0.2060602@linux.vnet.ibm.com>
Date: Tue, 16 Jul 2013 19:55:04 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: mod_timer: list_add corruption: WARNING: CPU: 1 PID: 0 at lib/list_debug.c:33
 __list_add+0xbe/0xd0()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071614-8878-0000-0000-000007F98E68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I happened to hit these warnings on an idle system shortly after
boot. And the machine locked up and sent NMIs to all CPUs, some of
which have been captured below.

Kernel version: v3.11-rc1 + 3 unrelated local cpufreq patches.
Options set in .config (which are of interest here):

CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_NO_HZ_FULL_ALL=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_ALL=y

 
Regards,
Srivatsa S. Bhat


------------[ cut here ]------------
WARNING: CPU: 1 PID: 0 at lib/list_debug.c:33 __list_add+0xbe/0xd0()
list_add corruption. prev->next should be next (ffff8810396b5568), but was           (null). (prev=ffff88102c1344c0).
Modules linked in: ebtable_nat ebtables nfs fscache nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables nfsd lockd nfs_acl exportfs auth_rpcgss autofs4 sunrpc 8021q garp bridge stp llc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 vfat fat vhost_net macvtap macvlan vhost tun kvm_intel kvm uinput iTCO_wdt iTCO_vendor_support cdc_ether usbnet mii microcode i2c_i801 i2c_core lpc_ich mfd_core shpchp mlx4_core ioatdma dca be2net wmi acpi_cpufreq mperf ext4 jbd2 mbcache dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
 0000000000000021 ffff88103fc43948 ffffffff8161a919 ffffffff81a13dcd
 ffff88103fc43998 ffff88103fc43988 ffffffff8104e6ac 0000000000000000
 ffff88102c1344c0 ffff8810396b5568 ffff88102c1344c0 ffff8810396b4000
Call Trace:
 <IRQ>  [<ffffffff8161a919>] dump_stack+0x59/0x80
 [<ffffffff8104e6ac>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff8104e796>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff81092923>] ? get_nohz_timer_target+0x103/0x250
 [<ffffffff812b64ee>] __list_add+0xbe/0xd0
 [<ffffffff81060843>] __internal_add_timer+0xf3/0x110
 [<ffffffff81060881>] internal_add_timer+0x21/0x50
 [<ffffffff81062840>] mod_timer+0x110/0x260
 [<ffffffffa0425ee4>] br_ip4_multicast_query+0x174/0x380 [bridge]
 [<ffffffffa0427eef>] br_multicast_ipv4_rcv+0x2cf/0x3d0 [bridge]
 [<ffffffff8162090b>] ? _raw_spin_unlock+0x2b/0x50
 [<ffffffffa0419a9b>] ? br_fdb_update+0x1db/0x2b0 [bridge]
 [<ffffffffa04284b5>] br_multicast_rcv+0x45/0x60 [bridge]
 [<ffffffffa041bdfe>] br_handle_frame_finish+0x16e/0x3c0 [bridge]
 [<ffffffffa041bac8>] br_handle_frame+0x238/0x400 [bridge]
 [<ffffffffa041b890>] ? br_del_bridge+0x80/0x80 [bridge]
 [<ffffffff81539247>] __netif_receive_skb_core+0x237/0x960
 [<ffffffff8153907e>] ? __netif_receive_skb_core+0x6e/0x960
 [<ffffffff81539997>] __netif_receive_skb+0x27/0x70
 [<ffffffff8153bc9d>] netif_receive_skb+0x2d/0x210
 [<ffffffff81527405>] ? __netdev_alloc_skb+0xa5/0x110
 [<ffffffffa0129a0f>] be_rx_compl_process+0xef/0x140 [be2net]
 [<ffffffffa0129dc2>] be_process_rx+0xe2/0x1a0 [be2net]
 [<ffffffffa0129fbd>] be_poll+0x13d/0x1d0 [be2net]
 [<ffffffff8153d058>] net_rx_action+0xd8/0x2a0
 [<ffffffff81058e09>] __do_softirq+0x149/0x400
 [<ffffffff81059235>] irq_exit+0x105/0x110
 [<ffffffff8162c706>] do_IRQ+0x66/0xe0
 [<ffffffff81620d2f>] common_interrupt+0x6f/0x6f
 <EOI>  [<ffffffff814f0a6b>] ? cpuidle_enter_state+0x5b/0xe0
 [<ffffffff814f0a67>] ? cpuidle_enter_state+0x57/0xe0
 [<ffffffff816251d0>] ? notifier_call_chain+0x120/0x120
 [<ffffffff814f0f5f>] cpuidle_idle_call+0xcf/0x160
 [<ffffffff8100cf0e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b0c91>] cpu_idle_loop+0x81/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff810334ec>] start_secondary+0xdc/0xe0
---[ end trace 83d72267b8b1d03a ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 0 at lib/list_debug.c:36 __list_add+0x9c/0xd0()
list_add double add: new=ffff88102c1344c0, prev=ffff88102c1344c0, next=ffff8810396b5568.
Modules linked in: ebtable_nat ebtables nfs fscache nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables nfsd lockd nfs_acl exportfs auth_rpcgss autofs4 sunrpc 8021q garp bridge stp llc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 vfat fat vhost_net macvtap macvlan vhost tun kvm_intel kvm uinput iTCO_wdt iTCO_vendor_support cdc_ether usbnet mii microcode i2c_i801 i2c_core lpc_ich mfd_core shpchp mlx4_core ioatdma dca be2net wmi acpi_cpufreq mperf ext4 jbd2 mbcache dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
 0000000000000024 ffff88103fc43948 ffffffff8161a919 ffffffff81a13dcd
 ffff88103fc43998 ffff88103fc43988 ffffffff8104e6ac 0000000000000000
 ffff88102c1344c0 ffff8810396b5568 ffff88102c1344c0 ffff8810396b4000
Call Trace:
 <IRQ>  [<ffffffff8161a919>] dump_stack+0x59/0x80
 [<ffffffff8104e6ac>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff8104e796>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff81092923>] ? get_nohz_timer_target+0x103/0x250
 [<ffffffff812b64cc>] __list_add+0x9c/0xd0
 [<ffffffff81060843>] __internal_add_timer+0xf3/0x110
 [<ffffffff81060881>] internal_add_timer+0x21/0x50
 [<ffffffff81062840>] mod_timer+0x110/0x260
 [<ffffffffa0425ee4>] br_ip4_multicast_query+0x174/0x380 [bridge]
 [<ffffffffa0427eef>] br_multicast_ipv4_rcv+0x2cf/0x3d0 [bridge]
 [<ffffffff8162090b>] ? _raw_spin_unlock+0x2b/0x50
 [<ffffffffa0419a9b>] ? br_fdb_update+0x1db/0x2b0 [bridge]
 [<ffffffffa04284b5>] br_multicast_rcv+0x45/0x60 [bridge]
 [<ffffffffa041bdfe>] br_handle_frame_finish+0x16e/0x3c0 [bridge]
 [<ffffffffa041bac8>] br_handle_frame+0x238/0x400 [bridge]
 [<ffffffffa041b890>] ? br_del_bridge+0x80/0x80 [bridge]
 [<ffffffff81539247>] __netif_receive_skb_core+0x237/0x960
 [<ffffffff8153907e>] ? __netif_receive_skb_core+0x6e/0x960
 [<ffffffff81539997>] __netif_receive_skb+0x27/0x70
 [<ffffffff8153bc9d>] netif_receive_skb+0x2d/0x210
 [<ffffffff81527405>] ? __netdev_alloc_skb+0xa5/0x110
 [<ffffffffa0129a0f>] be_rx_compl_process+0xef/0x140 [be2net]
 [<ffffffffa0129dc2>] be_process_rx+0xe2/0x1a0 [be2net]
 [<ffffffffa0129fbd>] be_poll+0x13d/0x1d0 [be2net]
 [<ffffffff8153d058>] net_rx_action+0xd8/0x2a0
 [<ffffffff81058e09>] __do_softirq+0x149/0x400
 [<ffffffff81059235>] irq_exit+0x105/0x110
 [<ffffffff8162c706>] do_IRQ+0x66/0xe0
 [<ffffffff81620d2f>] common_interrupt+0x6f/0x6f
 <EOI>  [<ffffffff814f0a6b>] ? cpuidle_enter_state+0x5b/0xe0
 [<ffffffff814f0a67>] ? cpuidle_enter_state+0x57/0xe0
 [<ffffffff816251d0>] ? notifier_call_chain+0x120/0x120
 [<ffffffff814f0f5f>] cpuidle_idle_call+0xcf/0x160
 [<ffffffff8100cf0e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b0c91>] cpu_idle_loop+0x81/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff810334ec>] start_secondary+0xdc/0xe0
---[ end trace 83d72267b8b1d03b ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 0 at lib/list_debug.c:33 __list_add+0xbe/0xd0()
list_add corruption. prev->next should be next (ffff8810396b5568), but was ffff88102c1344c0. (prev=ffff88102c1344c0).
Modules linked in: ebtable_nat ebtables nfs fscache nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables nfsd lockd nfs_acl exportfs auth_rpcgss autofs4 sunrpc 8021q garp bridge stp llc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 vfat fat vhost_net macvtap macvlan vhost tun kvm_intel kvm uinput iTCO_wdt iTCO_vendor_support cdc_ether usbnet mii microcode i2c_i801 i2c_core lpc_ich mfd_core shpchp mlx4_core ioatdma dca be2net wmi acpi_cpufreq mperf ext4 jbd2 mbcache dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
 0000000000000021 ffff88103fc43928 ffffffff8161a919 ffffffff81a13dcd
 ffff88103fc43978 ffff88103fc43968 ffffffff8104e6ac 0000000000000000
 ffff88102c0ab4f8 ffff8810396b5568 ffff88102c1344c0 ffff8810396b4000
Call Trace:
 <IRQ>  [<ffffffff8161a919>] dump_stack+0x59/0x80
 [<ffffffff8104e6ac>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff8104e796>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff812b64ee>] __list_add+0xbe/0xd0
 [<ffffffff8106099c>] ? lock_timer_base+0x3c/0x70
 [<ffffffff81060843>] __internal_add_timer+0xf3/0x110
 [<ffffffff81060881>] internal_add_timer+0x21/0x50
 [<ffffffff81062840>] mod_timer+0x110/0x260
 [<ffffffffa0424d62>] br_multicast_query_received+0x52/0x170 [bridge]
 [<ffffffffa0425e2f>] br_ip4_multicast_query+0xbf/0x380 [bridge]
 [<ffffffffa0427eef>] br_multicast_ipv4_rcv+0x2cf/0x3d0 [bridge]
 [<ffffffff8156cece>] ? nf_hook_slow+0x16e/0x2a0
 [<ffffffffa0419a07>] ? br_fdb_update+0x147/0x2b0 [bridge]
 [<ffffffffa04284b5>] br_multicast_rcv+0x45/0x60 [bridge]
 [<ffffffffa041bdfe>] br_handle_frame_finish+0x16e/0x3c0 [bridge]
 [<ffffffffa041bac8>] br_handle_frame+0x238/0x400 [bridge]
 [<ffffffffa041b890>] ? br_del_bridge+0x80/0x80 [bridge]
 [<ffffffff81539247>] __netif_receive_skb_core+0x237/0x960
 [<ffffffff8153907e>] ? __netif_receive_skb_core+0x6e/0x960
 [<ffffffff810c305d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81539997>] __netif_receive_skb+0x27/0x70
 [<ffffffff8153bc9d>] netif_receive_skb+0x2d/0x210
 [<ffffffff81527405>] ? __netdev_alloc_skb+0xa5/0x110
 [<ffffffffa0129a0f>] be_rx_compl_process+0xef/0x140 [be2net]
 [<ffffffffa0129dc2>] be_process_rx+0xe2/0x1a0 [be2net]
 [<ffffffffa0129fbd>] be_poll+0x13d/0x1d0 [be2net]
 [<ffffffff8153d058>] net_rx_action+0xd8/0x2a0
 [<ffffffff81058e09>] __do_softirq+0x149/0x400
 [<ffffffff81059235>] irq_exit+0x105/0x110
 [<ffffffff8162c706>] do_IRQ+0x66/0xe0
 [<ffffffff81620d2f>] common_interrupt+0x6f/0x6f
 <EOI>  [<ffffffff814f0a6b>] ? cpuidle_enter_state+0x5b/0xe0
 [<ffffffff814f0a67>] ? cpuidle_enter_state+0x57/0xe0
 [<ffffffff816251d0>] ? notifier_call_chain+0x120/0x120
 [<ffffffff814f0f5f>] cpuidle_idle_call+0xcf/0x160
 [<ffffffff8100cf0e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b0c91>] cpu_idle_loop+0x81/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff810334ec>] start_secondary+0xdc/0xe0
---[ end trace 83d72267b8b1d03c ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 0 at lib/list_debug.c:33 __list_add+0xbe/0xd0()
list_add corruption. prev->next should be next (ffff8810396b5568), but was           (null). (prev=ffff88102c1344c0).
Modules linked in: ebtable_nat ebtables nfs fscache nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables nfsd lockd nfs_acl exportfs auth_rpcgss autofs4 sunrpc 8021q garp bridge stp llc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 vfat fat vhost_net macvtap macvlan vhost tun kvm_intel kvm uinput iTCO_wdt iTCO_vendor_support cdc_ether usbnet mii microcode i2c_i801 i2c_core lpc_ich mfd_core shpchp mlx4_core ioatdma dca be2net wmi acpi_cpufreq mperf ext4 jbd2 mbcache dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
 0000000000000021 ffff88103fc43948 ffffffff8161a919 ffffffff81a13dcd
 ffff88103fc43998 ffff88103fc43988 ffffffff8104e6ac 0000000000000000
 ffff88102c1344c0 ffff8810396b5568 ffff88102c1344c0 ffff8810396b4000
Call Trace:
 <IRQ>  [<ffffffff8161a919>] dump_stack+0x59/0x80
 [<ffffffff8104e6ac>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff8104e796>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff81092923>] ? get_nohz_timer_target+0x103/0x250
 [<ffffffff812b64ee>] __list_add+0xbe/0xd0
 [<ffffffff81060843>] __internal_add_timer+0xf3/0x110
 [<ffffffff81060881>] internal_add_timer+0x21/0x50
 [<ffffffff81062840>] mod_timer+0x110/0x260
 [<ffffffffa0425ee4>] br_ip4_multicast_query+0x174/0x380 [bridge]
 [<ffffffffa0427eef>] br_multicast_ipv4_rcv+0x2cf/0x3d0 [bridge]
 [<ffffffff8156cece>] ? nf_hook_slow+0x16e/0x2a0
 [<ffffffffa04199a4>] ? br_fdb_update+0xe4/0x2b0 [bridge]
 [<ffffffffa04284b5>] br_multicast_rcv+0x45/0x60 [bridge]
 [<ffffffffa041bdfe>] br_handle_frame_finish+0x16e/0x3c0 [bridge]
 [<ffffffffa041bac8>] br_handle_frame+0x238/0x400 [bridge]
 [<ffffffffa041b890>] ? br_del_bridge+0x80/0x80 [bridge]
 [<ffffffff81539247>] __netif_receive_skb_core+0x237/0x960
 [<ffffffff8153907e>] ? __netif_receive_skb_core+0x6e/0x960
 [<ffffffff81539997>] __netif_receive_skb+0x27/0x70
 [<ffffffff8153bc9d>] netif_receive_skb+0x2d/0x210
 [<ffffffff81527405>] ? __netdev_alloc_skb+0xa5/0x110
 [<ffffffffa0129a0f>] be_rx_compl_process+0xef/0x140 [be2net]
 [<ffffffffa0129dc2>] be_process_rx+0xe2/0x1a0 [be2net]
 [<ffffffffa0129fbd>] be_poll+0x13d/0x1d0 [be2net]
 [<ffffffff8153d058>] net_rx_action+0xd8/0x2a0
 [<ffffffff81058e09>] __do_softirq+0x149/0x400
 [<ffffffff81059235>] irq_exit+0x105/0x110
 [<ffffffff8162c706>] do_IRQ+0x66/0xe0
 [<ffffffff81620d2f>] common_interrupt+0x6f/0x6f
 <EOI>  [<ffffffff814f0a6b>] ? cpuidle_enter_state+0x5b/0xe0
 [<ffffffff814f0a67>] ? cpuidle_enter_state+0x57/0xe0
 [<ffffffff816251d0>] ? notifier_call_chain+0x120/0x120
 [<ffffffff814f0f5f>] cpuidle_idle_call+0xcf/0x160
 [<ffffffff8100cf0e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b0c91>] cpu_idle_loop+0x81/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff810334ec>] start_secondary+0xdc/0xe0
---[ end trace 83d72267b8b1d03d ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 0 at lib/list_debug.c:36 __list_add+0x9c/0xd0()
list_add double add: new=ffff88102c1344c0, prev=ffff88102c1344c0, next=ffff8810396b5568.
Modules linked in: ebtable_nat ebtables nfs fscache nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables nfsd lockd nfs_acl exportfs auth_rpcgss autofs4 sunrpc 8021q garp bridge stp llc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 vfat fat vhost_net macvtap macvlan vhost tun kvm_intel kvm uinput iTCO_wdt iTCO_vendor_support cdc_ether usbnet mii microcode i2c_i801 i2c_core lpc_ich mfd_core shpchp mlx4_core ioatdma dca be2net wmi acpi_cpufreq mperf ext4 jbd2 mbcache dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
 0000000000000024 ffff88103fc43948 ffffffff8161a919 ffffffff81a13dcd
 ffff88103fc43998 ffff88103fc43988 ffffffff8104e6ac 0000000000000000
 ffff88102c1344c0 ffff8810396b5568 ffff88102c1344c0 ffff8810396b4000
Call Trace:
 <IRQ>  [<ffffffff8161a919>] dump_stack+0x59/0x80
 [<ffffffff8104e6ac>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff8104e796>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff81092923>] ? get_nohz_timer_target+0x103/0x250
 [<ffffffff812b64cc>] __list_add+0x9c/0xd0
 [<ffffffff81060843>] __internal_add_timer+0xf3/0x110
 [<ffffffff81060881>] internal_add_timer+0x21/0x50
 [<ffffffff81062840>] mod_timer+0x110/0x260
 [<ffffffffa0425ee4>] br_ip4_multicast_query+0x174/0x380 [bridge]
 [<ffffffffa0427eef>] br_multicast_ipv4_rcv+0x2cf/0x3d0 [bridge]
 [<ffffffff8156cece>] ? nf_hook_slow+0x16e/0x2a0
 [<ffffffffa04199a4>] ? br_fdb_update+0xe4/0x2b0 [bridge]
 [<ffffffffa04284b5>] br_multicast_rcv+0x45/0x60 [bridge]
 [<ffffffffa041bdfe>] br_handle_frame_finish+0x16e/0x3c0 [bridge]
 [<ffffffffa041bac8>] br_handle_frame+0x238/0x400 [bridge]
 [<ffffffffa041b890>] ? br_del_bridge+0x80/0x80 [bridge]
 [<ffffffff81539247>] __netif_receive_skb_core+0x237/0x960
 [<ffffffff8153907e>] ? __netif_receive_skb_core+0x6e/0x960
 [<ffffffff81539997>] __netif_receive_skb+0x27/0x70
 [<ffffffff8153bc9d>] netif_receive_skb+0x2d/0x210
 [<ffffffff81527405>] ? __netdev_alloc_skb+0xa5/0x110
 [<ffffffffa0129a0f>] be_rx_compl_process+0xef/0x140 [be2net]
 [<ffffffffa0129dc2>] be_process_rx+0xe2/0x1a0 [be2net]
 [<ffffffffa0129fbd>] be_poll+0x13d/0x1d0 [be2net]
 [<ffffffff8153d058>] net_rx_action+0xd8/0x2a0
 [<ffffffff81058e09>] __do_softirq+0x149/0x400
 [<ffffffff81059235>] irq_exit+0x105/0x110
 [<ffffffff8162c706>] do_IRQ+0x66/0xe0
 [<ffffffff81620d2f>] common_interrupt+0x6f/0x6f
 <EOI>  [<ffffffff814f0a6b>] ? cpuidle_enter_state+0x5b/0xe0
 [<ffffffff814f0a67>] ? cpuidle_enter_state+0x57/0xe0
 [<ffffffff816251d0>] ? notifier_call_chain+0x120/0x120
 [<ffffffff814f0f5f>] cpuidle_idle_call+0xcf/0x160
 [<ffffffff8100cf0e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b0c91>] cpu_idle_loop+0x81/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff810334ec>] start_secondary+0xdc/0xe0
---[ end trace 83d72267b8b1d03e ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 0 at lib/list_debug.c:33 __list_add+0xbe/0xd0()
list_add corruption. prev->next should be next (ffff8810396b5568), but was           (null). (prev=ffff88102c1344c0).
Modules linked in: ebtable_nat ebtables nfs fscache nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables nfsd lockd nfs_acl exportfs auth_rpcgss autofs4 sunrpc 8021q garp bridge stp llc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 vfat fat vhost_net macvtap macvlan vhost tun kvm_intel kvm uinput iTCO_wdt iTCO_vendor_support cdc_ether usbnet mii microcode i2c_i801 i2c_core lpc_ich mfd_core shpchp mlx4_core ioatdma dca be2net wmi acpi_cpufreq mperf ext4 jbd2 mbcache dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
 0000000000000021 ffff88103fc43948 ffffffff8161a919 ffffffff81a13dcd
 ffff88103fc43998 ffff88103fc43988 ffffffff8104e6ac 0000000000000000
 ffff88102c1344c0 ffff8810396b5568 ffff88102c1344c0 ffff8810396b4000
Call Trace:
 <IRQ>  [<ffffffff8161a919>] dump_stack+0x59/0x80
 [<ffffffff8104e6ac>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff8104e796>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff812b64ee>] __list_add+0xbe/0xd0
 [<ffffffff8106099c>] ? lock_timer_base+0x3c/0x70
 [<ffffffff81060843>] __internal_add_timer+0xf3/0x110
 [<ffffffff81060881>] internal_add_timer+0x21/0x50
 [<ffffffff81062840>] mod_timer+0x110/0x260
 [<ffffffffa0425ee4>] br_ip4_multicast_query+0x174/0x380 [bridge]
 [<ffffffffa0427eef>] br_multicast_ipv4_rcv+0x2cf/0x3d0 [bridge]
 [<ffffffff8156cece>] ? nf_hook_slow+0x16e/0x2a0
 [<ffffffffa04199a4>] ? br_fdb_update+0xe4/0x2b0 [bridge]
 [<ffffffffa04284b5>] br_multicast_rcv+0x45/0x60 [bridge]
 [<ffffffffa041bdfe>] br_handle_frame_finish+0x16e/0x3c0 [bridge]
 [<ffffffffa041bac8>] br_handle_frame+0x238/0x400 [bridge]
 [<ffffffffa041b890>] ? br_del_bridge+0x80/0x80 [bridge]
 [<ffffffff81539247>] __netif_receive_skb_core+0x237/0x960
 [<ffffffff8153907e>] ? __netif_receive_skb_core+0x6e/0x960
 [<ffffffff810c305d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81539997>] __netif_receive_skb+0x27/0x70
 [<ffffffff8153bc9d>] netif_receive_skb+0x2d/0x210
 [<ffffffff81527405>] ? __netdev_alloc_skb+0xa5/0x110
 [<ffffffffa0129a0f>] be_rx_compl_process+0xef/0x140 [be2net]
 [<ffffffffa0129dc2>] be_process_rx+0xe2/0x1a0 [be2net]
 [<ffffffffa0129fbd>] be_poll+0x13d/0x1d0 [be2net]
 [<ffffffff8153d058>] net_rx_action+0xd8/0x2a0
 [<ffffffff81058e09>] __do_softirq+0x149/0x400
 [<ffffffff81059235>] irq_exit+0x105/0x110
 [<ffffffff8162c706>] do_IRQ+0x66/0xe0
 [<ffffffff81620d2f>] common_interrupt+0x6f/0x6f
 <EOI>  [<ffffffff814f0a6b>] ? cpuidle_enter_state+0x5b/0xe0
 [<ffffffff814f0a67>] ? cpuidle_enter_state+0x57/0xe0
 [<ffffffff816251d0>] ? notifier_call_chain+0x120/0x120
 [<ffffffff814f0f5f>] cpuidle_idle_call+0xcf/0x160
 [<ffffffff8100cf0e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b0c91>] cpu_idle_loop+0x81/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff810334ec>] start_secondary+0xdc/0xe0
---[ end trace 83d72267b8b1d03f ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 0 at lib/list_debug.c:36 __list_add+0x9c/0xd0()
list_add double add: new=ffff88102c1344c0, prev=ffff88102c1344c0, next=ffff8810396b5568.
Modules linked in: ebtable_nat ebtables nfs fscache nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables nfsd lockd nfs_acl exportfs auth_rpcgss autofs4 sunrpc 8021q garp bridge stp llc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 vfat fat vhost_net macvtap macvlan vhost tun kvm_intel kvm uinput iTCO_wdt iTCO_vendor_support cdc_ether usbnet mii microcode i2c_i801 i2c_core lpc_ich mfd_core shpchp mlx4_core ioatdma dca be2net wmi acpi_cpufreq mperf ext4 jbd2 mbcache dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
 0000000000000024 ffff88103fc43948 ffffffff8161a919 ffffffff81a13dcd
 ffff88103fc43998 ffff88103fc43988 ffffffff8104e6ac 0000000000000000
 ffff88102c1344c0 ffff8810396b5568 ffff88102c1344c0 ffff8810396b4000
Call Trace:
 <IRQ>  [<ffffffff8161a919>] dump_stack+0x59/0x80
 [<ffffffff8104e6ac>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff8104e796>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff812b64cc>] __list_add+0x9c/0xd0
 [<ffffffff8106099c>] ? lock_timer_base+0x3c/0x70
 [<ffffffff81060843>] __internal_add_timer+0xf3/0x110
 [<ffffffff81060881>] internal_add_timer+0x21/0x50
 [<ffffffff81062840>] mod_timer+0x110/0x260
 [<ffffffffa0425ee4>] br_ip4_multicast_query+0x174/0x380 [bridge]
 [<ffffffffa0427eef>] br_multicast_ipv4_rcv+0x2cf/0x3d0 [bridge]
 [<ffffffff8156cece>] ? nf_hook_slow+0x16e/0x2a0
 [<ffffffffa04199a4>] ? br_fdb_update+0xe4/0x2b0 [bridge]
 [<ffffffffa04284b5>] br_multicast_rcv+0x45/0x60 [bridge]
 [<ffffffffa041bdfe>] br_handle_frame_finish+0x16e/0x3c0 [bridge]
 [<ffffffffa041bac8>] br_handle_frame+0x238/0x400 [bridge]
 [<ffffffffa041b890>] ? br_del_bridge+0x80/0x80 [bridge]
 [<ffffffff81539247>] __netif_receive_skb_core+0x237/0x960
 [<ffffffff8153907e>] ? __netif_receive_skb_core+0x6e/0x960
 [<ffffffff810c305d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81539997>] __netif_receive_skb+0x27/0x70
 [<ffffffff8153bc9d>] netif_receive_skb+0x2d/0x210
 [<ffffffff81527405>] ? __netdev_alloc_skb+0xa5/0x110
 [<ffffffffa0129a0f>] be_rx_compl_process+0xef/0x140 [be2net]
 [<ffffffffa0129dc2>] be_process_rx+0xe2/0x1a0 [be2net]
 [<ffffffffa0129fbd>] be_poll+0x13d/0x1d0 [be2net]
 [<ffffffff8153d058>] net_rx_action+0xd8/0x2a0
 [<ffffffff81058e09>] __do_softirq+0x149/0x400
 [<ffffffff81059235>] irq_exit+0x105/0x110
 [<ffffffff8162c706>] do_IRQ+0x66/0xe0
 [<ffffffff81620d2f>] common_interrupt+0x6f/0x6f
 <EOI>  [<ffffffff814f0a6b>] ? cpuidle_enter_state+0x5b/0xe0
 [<ffffffff814f0a67>] ? cpuidle_enter_state+0x57/0xe0
 [<ffffffff816251d0>] ? notifier_call_chain+0x120/0x120
 [<ffffffff814f0f5f>] cpuidle_idle_call+0xcf/0x160
 [<ffffffff8100cf0e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b0c91>] cpu_idle_loop+0x81/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff810334ec>] start_secondary+0xdc/0xe0
---[ end trace 83d72267b8b1d040 ]---
INFO: rcu_sched detected stalls on CPUs/tasks:
        1: (1 GPs behind) idle=8d7/140000000000000/0 softirq=6930/6930 last_accelerate: 0000/0a08, nonlazy_posted: 0, L.
        (detected by 8, t=26184 jiffies, g=13142, c=13141, q=0)
sending NMI to all CPUs:
NMI backtrace for cpu 0
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
task: ffffffff81c10420 ti: ffffffff81c00000 task.ti: ffffffff81c00000
RIP: 0010:[<ffffffff812ad3c7>]  [<ffffffff812ad3c7>] delay_tsc+0x57/0x90
RSP: 0018:ffff88103fc03cd8  EFLAGS: 00000002
RAX: 0000000036b5fadf RBX: ffff8810396b4000 RCX: ffffffff81c00000
RDX: 000000000000e705 RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff88103fc03cd8 R08: 0000000036b5fa88 R09: 0000000000000000
R10: 0000000000000000 R11: dead000000200200 R12: 000000001617bb68
R13: 00000000ad28df68 R14: ffff8810396b4000 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff88103fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f29f8861000 CR3: 0000002022624000 CR4: 00000000000407f0
Stack:
 ffff88103fc03ce8 ffffffff812ad32f ffff88103fc03d18 ffffffff812b5f4e
 ffff8810396b4000 ffff8810396b4000 ffff8810396b4000 000000010023af04
 ffff88103fc03d48 ffffffff8161ff69 ffffffff81062823 ffffffff8162090b
Call Trace:
 <IRQ> 
 [<ffffffff812ad32f>] __delay+0xf/0x20
 [<ffffffff812b5f4e>] do_raw_spin_lock+0x7e/0x150
 [<ffffffff8161ff69>] _raw_spin_lock+0x49/0x50
 [<ffffffff81062823>] ? mod_timer+0xf3/0x260
 [<ffffffff8162090b>] ? _raw_spin_unlock+0x2b/0x50
 [<ffffffff81062823>] mod_timer+0xf3/0x260
 [<ffffffffa0152396>] __cleanup+0x2b6/0x3f0 [ioatdma]
 [<ffffffffa0152a34>] ioat3_cleanup+0xa4/0xb0 [ioatdma]
 [<ffffffffa0152a56>] ioat3_cleanup_event+0x16/0x30 [ioatdma]
 [<ffffffff8105858a>] tasklet_action+0xca/0xe0
 [<ffffffff81058e09>] __do_softirq+0x149/0x400
 [<ffffffff81059235>] irq_exit+0x105/0x110
 [<ffffffff8162c7ca>] smp_apic_timer_interrupt+0x4a/0x60
 [<ffffffff8162b42f>] apic_timer_interrupt+0x6f/0x80
 <EOI> 
 [<ffffffff81620ddc>] ? retint_restore_args+0xe/0xe
 [<ffffffff814f09a4>] ? poll_idle+0x24/0x90
 [<ffffffff814f09c5>] ? poll_idle+0x45/0x90
 [<ffffffff814f09a4>] ? poll_idle+0x24/0x90
 [<ffffffff814f251d>] ? menu_select+0x2ad/0x510
 [<ffffffff810b3964>] ? ktime_get+0x54/0xe0
 [<ffffffff814f0a57>] cpuidle_enter_state+0x47/0xe0
 [<ffffffff816251d0>] ? notifier_call_chain+0x120/0x120
 [<ffffffff814f0f5f>] cpuidle_idle_call+0xcf/0x160
 [<ffffffff8100cf0e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b0c91>] cpu_idle_loop+0x81/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff81613474>] rest_init+0x104/0x180
 [<ffffffff81613370>] ? csum_partial_copy_generic+0x170/0x170
 [<ffffffff81d441ce>] start_kernel+0x411/0x41e
 [<ffffffff81d43bdb>] ? repair_env_string+0x5b/0x5b
 [<ffffffff81d435a1>] x86_64_start_reservations+0x2a/0x2c
 [<ffffffff81d436dd>] x86_64_start_kernel+0x13a/0x141
Code: 0f 31 41 89 c0 eb 1c 0f 1f 44 00 00 83 69 1c 01 f3 90 83 41 1c 01 65 8b 34 25 20 b0 00 00 44 39 ce 75 23 66 66 90 0f ae e8 0f 31 <89> c2 44 29 c2 39 fa 72 d8 65 48 8b 04 25 88 b9 00 00 83 a8 44 
NMI backtrace for cpu 1
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 290.198 msecs
CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
task: ffff881039658ac0 ti: ffff88103965a000 task.ti: ffff88103965a000
RIP: 0010:[<ffffffff81060c0c>]  [<ffffffff81060c0c>] get_next_timer_interrupt+0x16c/0x240
RSP: 0018:ffff88103965bd88  EFLAGS: 00000046
RAX: ffff88102c1344c0 RBX: 0000000100208002 RCX: ffff8810396b5568
RDX: 0000000000000001 RSI: 0000000000000011 RDI: ffff8810396b5458
RBP: ffff88103965bde8 R08: 000000000000000f R09: 000000000004008f
R10: ffff88103965bda8 R11: ffff88103965bdb8 R12: 0000000140238ccb
R13: 0000000100238ccc R14: 0000000000000040 R15: ffff8810396b4000
FS:  0000000000000000(0000) GS:ffff88103fc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 0000000001c0b000 CR4: 00000000000407e0
Stack:
 ffff88103965bdc8 0000000000000046 ffff8810396b5058 ffff8810396b5458
 ffff8810396b5858 ffff8810396b5c58 ffff88103965bdc8 ffff88103fc4dae0
 0000000000502058 0000000100238ccc 0000000000000000 ffff88103fc4cf00
Call Trace:
 [<ffffffff810bc91d>] tick_nohz_stop_sched_tick+0x1dd/0x420
 [<ffffffff8109e086>] ? set_cpu_sd_state_idle+0xc6/0x1d0
 [<ffffffff810bcc24>] __tick_nohz_idle_enter+0xc4/0x160
 [<ffffffff810bccf7>] tick_nohz_idle_enter+0x37/0x70
 [<ffffffff810b0c49>] cpu_idle_loop+0x39/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff810334ec>] start_secondary+0xdc/0xe0
Code: 48 89 45 c8 45 89 c8 41 83 e0 3f 44 89 c6 90 48 63 ce 48 c1 e1 04 48 8b 04 39 48 8d 0c 0f 48 39 c8 74 22 0f 1f 40 00 f6 40 18 01 <75> 10 48 8b 50 10 48 39 da 48 0f 48 da ba 01 00 00 00 48 8b 00 
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 468.629 msecs
NMI backtrace for cpu 2
CPU: 2 PID: 0 Comm: swapper/2 Tainted: G        W    3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
task: ffff88103965cb00 ti: ffff88103965e000 task.ti: ffff88103965e000
RIP: 0010:[<ffffffff8130a079>]  [<ffffffff8130a079>] intel_idle+0x99/0xe0
RSP: 0018:ffff88103965fde8  EFLAGS: 00000046
RAX: 0000000000000030 RBX: 0000000000000010 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff88103965ffd8 RDI: 0000000000000002
RBP: ffff88103965fe18 R08: ffffe8efcfc80000 R09: 000000000000006d
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000005
R13: 0000000000000030 R14: 0000000000000005 R15: ffff88103965e000
FS:  0000000000000000(0000) GS:ffff88103fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 0000000001c0b000 CR4: 00000000000407e0
Stack:
 ffff88103965fe18 00000002810b3964 0000000000000002 ffffe8efcfc80000
 ffffffff81cbec20 000002696b591f8d ffff88103965fe68 ffffffff814f0a57
 0000000000000030 0000000035b6f34a ffffffff816251d0 ffffe8efcfc80000
Call Trace:
 [<ffffffff814f0a57>] cpuidle_enter_state+0x47/0xe0
 [<ffffffff816251d0>] ? notifier_call_chain+0x120/0x120
 [<ffffffff814f0f5f>] cpuidle_idle_call+0xcf/0x160
 [<ffffffff8100cf0e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b0c91>] cpu_idle_loop+0x81/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff810334ec>] start_secondary+0xdc/0xe0
Code: ff 48 8d 86 38 e0 ff ff 83 e2 08 75 1e 31 d2 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <85> 1d 59 4f 9b 00 75 0e 48 8d 75 dc bf 05 00 00 00 e8 81 fc da 
NMI backtrace for cpu 3
CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W    3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
task: ffff881039660b40 ti: ffff881039662000 task.ti: ffff881039662000
RIP: 0010:[<ffffffff8130a079>]  [<ffffffff8130a079>] intel_idle+0x99/0xe0
RSP: 0018:ffff881039663de8  EFLAGS: 00000046
RAX: 0000000000000030 RBX: 0000000000000010 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff881039663fd8 RDI: 0000000000000003
RBP: ffff881039663e18 R08: ffffe8efcfcc0000 R09: 000000000000006d
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000005
R13: 0000000000000030 R14: 0000000000000005 R15: ffff881039662000
FS:  0000000000000000(0000) GS:ffff88103fcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 0000000001c0b000 CR4: 00000000000407e0
Stack:
 ffff881039663e18 00000003810b3964 0000000000000003 ffffe8efcfcc0000
 ffffffff81cbec20 000002645de351e3 ffff881039663e68 ffffffff814f0a57
 0000000000000025 00000000166334de ffffffff816251d0 ffffe8efcfcc0000
Call Trace:
 [<ffffffff814f0a57>] cpuidle_enter_state+0x47/0xe0
 [<ffffffff816251d0>] ? notifier_call_chain+0x120/0x120
 [<ffffffff814f0f5f>] cpuidle_idle_call+0xcf/0x160
 [<ffffffff8100cf0e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b0c91>] cpu_idle_loop+0x81/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff810334ec>] start_secondary+0xdc/0xe0
Code: ff 48 8d 86 38 e0 ff ff 83 e2 08 75 1e 31 d2 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <85> 1d 59 4f 9b 00 75 0e 48 8d 75 dc bf 05 00 00 00 e8 81 fc da 
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 468.651 msecs
NMI backtrace for cpu 4
CPU: 4 PID: 0 Comm: swapper/4 Tainted: G        W    3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
task: ffff881039666b80 ti: ffff881039668000 task.ti: ffff881039668000
RIP: 0010:[<ffffffff8130a079>]  [<ffffffff8130a079>] intel_idle+0x99/0xe0
RSP: 0018:ffff881039669de8  EFLAGS: 00000046
RAX: 0000000000000030 RBX: 0000000000000010 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff881039669fd8 RDI: 0000000000000004
RBP: ffff881039669e18 R08: ffffe8efcfd00000 R09: 000000000000006d
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000005
R13: 0000000000000030 R14: 0000000000000005 R15: ffff881039668000
FS:  0000000000000000(0000) GS:ffff88103fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f64a0879000 CR3: 0000000001c0b000 CR4: 00000000000407e0
Stack:
 ffff881039669e18 00000004810b3964 0000000000000004 ffffe8efcfd00000
 ffffffff81cbec20 0000026b9eecf00f ffff881039669e68 ffffffff814f0a57
 0000000000000002 00000000003bdf5f ffffffff816251d0 ffffe8efcfd00000
Call Trace:
 [<ffffffff814f0a57>] cpuidle_enter_state+0x47/0xe0
 [<ffffffff816251d0>] ? notifier_call_chain+0x120/0x120
 [<ffffffff814f0f5f>] cpuidle_idle_call+0xcf/0x160
 [<ffffffff8100cf0e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b0c91>] cpu_idle_loop+0x81/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff810334ec>] start_secondary+0xdc/0xe0
Code: ff 48 8d 86 38 e0 ff ff 83 e2 08 75 1e 31 d2 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <85> 1d 59 4f 9b 00 75 0e 48 8d 75 dc bf 05 00 00 00 e8 81 fc da 
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 468.677 msecs
NMI backtrace for cpu 5
CPU: 5 PID: 0 Comm: swapper/5 Tainted: G        W    3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
task: ffff88103966abc0 ti: ffff88103966c000 task.ti: ffff88103966c000
RIP: 0010:[<ffffffff8130a079>]  [<ffffffff8130a079>] intel_idle+0x99/0xe0
RSP: 0018:ffff88103966dde8  EFLAGS: 00000046
RAX: 0000000000000030 RBX: 0000000000000010 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff88103966dfd8 RDI: 0000000000000005
RBP: ffff88103966de18 R08: ffffe8efcfd40000 R09: 0000000000000147
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000005
R13: 0000000000000030 R14: 0000000000000005 R15: ffff88103966c000
FS:  0000000000000000(0000) GS:ffff88103fd40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001f7c000 CR3: 0000000001c0b000 CR4: 00000000000407e0
Stack:
 ffff88103966de18 00000005810b3964 0000000000000005 ffffe8efcfd40000
 ffffffff81cbec20 000002696b7dfc4d ffff88103966de68 ffffffff814f0a57
 0000000000000030 000000003508c3d3 ffffffff816251d0 ffffe8efcfd40000
Call Trace:
 [<ffffffff814f0a57>] cpuidle_enter_state+0x47/0xe0
 [<ffffffff816251d0>] ? notifier_call_chain+0x120/0x120
 [<ffffffff814f0f5f>] cpuidle_idle_call+0xcf/0x160
 [<ffffffff8100cf0e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b0c91>] cpu_idle_loop+0x81/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff810334ec>] start_secondary+0xdc/0xe0
Code: ff 48 8d 86 38 e0 ff ff 83 e2 08 75 1e 31 d2 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <85> 1d 59 4f 9b 00 75 0e 48 8d 75 dc bf 05 00 00 00 e8 81 fc da 
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 468.709 msecs
NMI backtrace for cpu 6
CPU: 6 PID: 0 Comm: swapper/6 Tainted: G        W    3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
task: ffff88103966ec00 ti: ffff881039670000 task.ti: ffff881039670000
RIP: 0010:[<ffffffff8130a079>]  [<ffffffff8130a079>] intel_idle+0x99/0xe0
RSP: 0018:ffff881039671de8  EFLAGS: 00000046
RAX: 0000000000000030 RBX: 0000000000000010 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff881039671fd8 RDI: 0000000000000006
RBP: ffff881039671e18 R08: ffffe8efcfd80000 R09: 000000000000006d
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000005
R13: 0000000000000030 R14: 0000000000000005 R15: ffff881039670000
FS:  0000000000000000(0000) GS:ffff88103fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fad94084000 CR3: 0000000001c0b000 CR4: 00000000000407e0
Stack:
 ffff881039671e18 00000006810b3964 0000000000000006 ffffe8efcfd80000
 ffffffff81cbec20 0000026977581a55 ffff881039671e68 ffffffff814f0a57
 000000000000000a 000000002b7534d2 ffffffff816251d0 ffffe8efcfd80000
Call Trace:
 [<ffffffff814f0a57>] cpuidle_enter_state+0x47/0xe0
 [<ffffffff816251d0>] ? notifier_call_chain+0x120/0x120
 [<ffffffff814f0f5f>] cpuidle_idle_call+0xcf/0x160
 [<ffffffff8100cf0e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b0c91>] cpu_idle_loop+0x81/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff810334ec>] start_secondary+0xdc/0xe0
Code: ff 48 8d 86 38 e0 ff ff 83 e2 08 75 1e 31 d2 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <85> 1d 59 4f 9b 00 75 0e 48 8d 75 dc bf 05 00 00 00 e8 81 fc da 
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 468.734 msecs
NMI backtrace for cpu 7
CPU: 7 PID: 0 Comm: swapper/7 Tainted: G        W    3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
task: ffff881039672c40 ti: ffff881039674000 task.ti: ffff881039674000
RIP: 0010:[<ffffffff8130a079>]  [<ffffffff8130a079>] intel_idle+0x99/0xe0
RSP: 0018:ffff881039675de8  EFLAGS: 00000046
RAX: 0000000000000030 RBX: 0000000000000010 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff881039675fd8 RDI: 0000000000000007
RBP: ffff881039675e18 R08: ffffe8efcfdc0000 R09: 000000000000006d
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000005
R13: 0000000000000030 R14: 0000000000000005 R15: ffff881039674000
FS:  0000000000000000(0000) GS:ffff88103fdc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 0000000001c0b000 CR4: 00000000000407e0
Stack:
 ffff881039675e18 00000007810b3964 0000000000000007 ffffe8efcfdc0000
 ffffffff81cbec20 000002696dc37757 ffff881039675e68 ffffffff814f0a57
 0000000000000030 000000003267c377 ffffffff816251d0 ffffe8efcfdc0000
Call Trace:
 [<ffffffff814f0a57>] cpuidle_enter_state+0x47/0xe0
 [<ffffffff816251d0>] ? notifier_call_chain+0x120/0x120
 [<ffffffff814f0f5f>] cpuidle_idle_call+0xcf/0x160
 [<ffffffff8100cf0e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b0c91>] cpu_idle_loop+0x81/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff810334ec>] start_secondary+0xdc/0xe0
Code: ff 48 8d 86 38 e0 ff ff 83 e2 08 75 1e 31 d2 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <85> 1d 59 4f 9b 00 75 0e 48 8d 75 dc bf 05 00 00 00 e8 81 fc da 
NMI backtrace for cpu 8
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 468.758 msecs
CPU: 8 PID: 0 Comm: swapper/8 Tainted: G        W    3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
task: ffff881039676c80 ti: ffff881039678000 task.ti: ffff881039678000
RIP: 0010:[<ffffffff812ad3c7>]  [<ffffffff812ad3c7>] delay_tsc+0x57/0x90
RSP: 0018:ffff88206fc03c98  EFLAGS: 00000046
RAX: 0000000036d98869 RBX: 0000000000000000 RCX: ffff881039678000
RDX: 000000000000e705 RSI: 0000000000000008 RDI: 0000000000046ed4
RBP: ffff88206fc03c98 R08: 0000000036d9878c R09: 0000000000000008
R10: 0000000000000a1f R11: 0000000000000a1f R12: 0000000000001000
R13: ffffffff81d24920 R14: 0000000000000400 R15: 0000000000000096
FS:  0000000000000000(0000) GS:ffff88206fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001f9a000 CR3: 0000000001c0b000 CR4: 00000000000407e0
Stack:
 ffff88206fc03ca8 ffffffff812ad368 ffff88206fc03cc8 ffffffff81034f52
 0000000000000002 000000000000b024 ffff88206fc03d18 ffffffff81035bdc
 ffffffff00000022 0000000000000009 ffff88206fc03cf8 0000000000000000
Call Trace:
 <IRQ> 
 [<ffffffff812ad368>] __const_udelay+0x28/0x30
 [<ffffffff81034f52>] native_safe_apic_wait_icr_idle+0x22/0x60
 [<ffffffff81035bdc>] default_send_IPI_mask_sequence_phys+0xfc/0x110
 [<ffffffff81039137>] physflat_send_IPI_all+0x17/0x20
 [<ffffffff81035c7c>] arch_trigger_all_cpu_backtrace+0x6c/0xb0
 [<ffffffff81104581>] print_other_cpu_stall+0x221/0x240
 [<ffffffff81081694>] ? hrtimer_get_next_event+0xe4/0x100
 [<ffffffff81104714>] __rcu_pending+0x174/0x1d0
 [<ffffffff81105aed>] rcu_check_callbacks+0x12d/0x320
 [<ffffffff81060a68>] update_process_times+0x48/0x80
 [<ffffffff81081faf>] ? __run_hrtimer+0x6f/0x2e0
 [<ffffffff810bbbe9>] tick_sched_handle+0x39/0x80
 [<ffffffff810bbe35>] tick_sched_timer+0x45/0x70
 [<ffffffff81081fc3>] __run_hrtimer+0x83/0x2e0
 [<ffffffff810bbdf0>] ? tick_nohz_handler+0xa0/0xa0
 [<ffffffff81082506>] hrtimer_interrupt+0x116/0x2a0
 [<ffffffff810bed2d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8103466b>] local_apic_timer_interrupt+0x3b/0x60
 [<ffffffff8162c7c5>] smp_apic_timer_interrupt+0x45/0x60
 [<ffffffff8162b42f>] apic_timer_interrupt+0x6f/0x80
 <EOI> 
 [<ffffffff814f0a6b>] ? cpuidle_enter_state+0x5b/0xe0
 [<ffffffff814f0a67>] ? cpuidle_enter_state+0x57/0xe0
 [<ffffffff816251d0>] ? notifier_call_chain+0x120/0x120
 [<ffffffff814f0f5f>] cpuidle_idle_call+0xcf/0x160
 [<ffffffff8100cf0e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b0c91>] cpu_idle_loop+0x81/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff810334ec>] start_secondary+0xdc/0xe0
Code: 0f 31 41 89 c0 eb 1c 0f 1f 44 00 00 83 69 1c 01 f3 90 83 41 1c 01 65 8b 34 25 20 b0 00 00 44 39 ce 75 23 66 66 90 0f ae e8 0f 31 <89> c2 44 29 c2 39 fa 72 d8 65 48 8b 04 25 88 b9 00 00 83 a8 44 
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 468.933 msecs
NMI backtrace for cpu 9
CPU: 9 PID: 0 Comm: swapper/9 Tainted: G        W    3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
task: ffff88103967a040 ti: ffff88103967c000 task.ti: ffff88103967c000
RIP: 0010:[<ffffffff8130a079>]  [<ffffffff8130a079>] intel_idle+0x99/0xe0
RSP: 0018:ffff88103967dde8  EFLAGS: 00000046
RAX: 0000000000000030 RBX: 0000000000000010 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff88103967dfd8 RDI: 0000000000000009
RBP: ffff88103967de18 R08: ffffe8ffffc40000 R09: 000000000000006d
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000005
R13: 0000000000000030 R14: 0000000000000005 R15: ffff88103967c000
FS:  0000000000000000(0000) GS:ffff88206fc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000329fb53fe3 CR3: 0000000001c0b000 CR4: 00000000000407e0
Stack:
 ffff88103967de18 00000009810b3964 0000000000000009 ffffe8ffffc40000
 ffffffff81cbec20 0000026bb86fd1fe ffff88103967de68 ffffffff814f0a57
 0000000000000000 000000003b998037 ffffffff816251d0 ffffe8ffffc40000
Call Trace:
 [<ffffffff814f0a57>] cpuidle_enter_state+0x47/0xe0
 [<ffffffff816251d0>] ? notifier_call_chain+0x120/0x120
 [<ffffffff814f0f5f>] cpuidle_idle_call+0xcf/0x160
 [<ffffffff8100cf0e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b0c91>] cpu_idle_loop+0x81/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff810334ec>] start_secondary+0xdc/0xe0
Code: ff 48 8d 86 38 e0 ff ff 83 e2 08 75 1e 31 d2 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <85> 1d 59 4f 9b 00 75 0e 48 8d 75 dc bf 05 00 00 00 e8 81 fc da 
NMI backtrace for cpu 10
CPU: 10 PID: 0 Comm: swapper/10 Tainted: G        W    3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
task: ffff881039680080 ti: ffff881039682000 task.ti: ffff881039682000
RIP: 0010:[<ffffffff8130a079>]  [<ffffffff8130a079>] intel_idle+0x99/0xe0
RSP: 0018:ffff881039683de8  EFLAGS: 00000046
RAX: 0000000000000030 RBX: 0000000000000010 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff881039683fd8 RDI: 000000000000000a
RBP: ffff881039683e18 R08: ffffe8ffffc80000 R09: 000000000000006d
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000005
R13: 0000000000000030 R14: 0000000000000005 R15: ffff881039682000
FS:  0000000000000000(0000) GS:ffff88206fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 0000000001c0b000 CR4: 00000000000407e0
Stack:
 ffff881039683e18 0000000a810b3964 000000000000000a ffffe8ffffc80000
 ffffffff81cbec20 00000269af4ee3a5 ffff881039683e68 ffffffff814f0a57
 0000000000000009 000000003b8b985d ffffffff816251d0 ffffe8ffffc80000
Call Trace:
 [<ffffffff814f0a57>] cpuidle_enter_state+0x47/0xe0
 [<ffffffff816251d0>] ? notifier_call_chain+0x120/0x120
 [<ffffffff814f0f5f>] cpuidle_idle_call+0xcf/0x160
 [<ffffffff8100cf0e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b0c91>] cpu_idle_loop+0x81/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff810334ec>] start_secondary+0xdc/0xe0
Code: ff 48 8d 86 38 e0 ff ff 83 e2 08 75 1e 31 d2 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <85> 1d 59 4f 9b 00 75 0e 48 8d 75 dc bf 05 00 00 00 e8 81 fc da 
NMI backtrace for cpu 11
CPU: 11 PID: 0 Comm: swapper/11 Tainted: G        W    3.11.0-rc1-lockdep-fix-a #6
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
task: ffff8810396880c0 ti: ffff88103968a000 task.ti: ffff88103968a000
RIP: 0010:[<ffffffff812ad3c7>]  [<ffffffff812ad3c7>] delay_tsc+0x57/0x90
RSP: 0018:ffff88206fcc3a48  EFLAGS: 00000006
RAX: 0000000087f77112 RBX: ffff8810396b4000 RCX: ffff88103968a000
RDX: 000000000000e705 RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff88206fcc3a48 R08: 0000000087f770bb R09: 000000000000000b
R10: 0000000000000000 R11: 0000000000000001 R12: 000000001741512a
R13: 00000000ad28df68 R14: ffff8810396b4000 R15: 000000010024190f
FS:  0000000000000000(0000) GS:ffff88206fcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000329faabc30 CR3: 0000000001c0b000 CR4: 00000000000407e0
Stack:
 ffff88206fcc3a58 ffffffff812ad32f ffff88206fcc3a88 ffffffff812b5f4e
 ffff8810396b4000 ffff8810396b4000 ffff8810396b4000 0000000000000001
 ffff88206fcc3ab8 ffffffff8161ff69 ffffffff8106264b ffffffff8162090b
Call Trace:
 <IRQ> 
 [<ffffffff812ad32f>] __delay+0xf/0x20
 [<ffffffff812b5f4e>] do_raw_spin_lock+0x7e/0x150
 [<ffffffff8161ff69>] _raw_spin_lock+0x49/0x50
 [<ffffffff8106264b>] ? mod_timer_pending+0xeb/0x1d0
 [<ffffffff8162090b>] ? _raw_spin_unlock+0x2b/0x50
 [<ffffffff8106264b>] mod_timer_pending+0xeb/0x1d0
 [<ffffffffa03c0bb1>] __nf_ct_refresh_acct+0xb1/0xc0 [nf_conntrack]
 [<ffffffffa0568e6f>] icmp_packet+0x1f/0x28 [nf_conntrack_ipv4]
 [<ffffffffa03c3aa4>] nf_conntrack_in+0x384/0x5f0 [nf_conntrack]
 [<ffffffffa0568881>] ipv4_conntrack_in+0x21/0x30 [nf_conntrack_ipv4]
 [<ffffffff8156cb67>] nf_iterate+0xd7/0x120
 [<ffffffff8160242a>] ? run_filter+0xaa/0x1b0
 [<ffffffff815797d0>] ? ip_local_deliver_finish+0x4c0/0x4c0
 [<ffffffff8156ce45>] nf_hook_slow+0xe5/0x2a0
 [<ffffffff815797d0>] ? ip_local_deliver_finish+0x4c0/0x4c0
 [<ffffffff815791a3>] ip_rcv+0x243/0x320
 [<ffffffff815395d4>] __netif_receive_skb_core+0x5c4/0x960
 [<ffffffff8153907e>] ? __netif_receive_skb_core+0x6e/0x960
 [<ffffffff81539997>] __netif_receive_skb+0x27/0x70
 [<ffffffff81539aa5>] process_backlog+0xc5/0x1b0
 [<ffffffff8153d058>] net_rx_action+0xd8/0x2a0
 [<ffffffff81058e09>] __do_softirq+0x149/0x400
 [<ffffffff81059235>] irq_exit+0x105/0x110
 [<ffffffff8162c706>] do_IRQ+0x66/0xe0
 [<ffffffff81620d2f>] common_interrupt+0x6f/0x6f
 <EOI> 
 [<ffffffff814f0a6b>] ? cpuidle_enter_state+0x5b/0xe0
 [<ffffffff814f0a67>] ? cpuidle_enter_state+0x57/0xe0
 [<ffffffff816251d0>] ? notifier_call_chain+0x120/0x120
 [<ffffffff814f0f5f>] cpuidle_idle_call+0xcf/0x160
 [<ffffffff8100cf0e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810b0c91>] cpu_idle_loop+0x81/0x3a0
 [<ffffffff810b1020>] cpu_startup_entry+0x70/0x80
 [<ffffffff810334ec>] start_secondary+0xdc/0xe0
Code: 0f 31 41 89 c0 eb 1c 0f 1f 44 00 00 83 69 1c 01 f3 90 83 41 1c 01 65 8b 34 25 20 b0 00 00 44 39 ce 75 23 66 66 90 0f ae e8 0f 31 <89> c2 44 29 c2 39 fa 72 d8 65 48 8b 04 25 88 b9 00 00 83 a8 44 

