Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaJ0IzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:55:09 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:57472 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaJ0IzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:55:07 -0400
Date: Mon, 27 Oct 2014 10:54:36 +0200
From: Mike Rapoport <mike.rapoport@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Muli Ben-Yehuda <muli@stratoscale.com>, Abel Gordon <abel@stratoscale.com>
Subject: Kernel crashes when updating cgroups cfs_{period,quota} of qemu-kvm
 process group
Message-ID: <20141027085436.GA19738@poluect>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm running CentOS 7 with kernel 3.10.0-123.8.1.el7.x86_64 on a machine with 12 Xeon cores with 128G RAM.

When running in parallel a loop that starts/stops several VMs using virsh and
another loop that modifies cfs_period_us and cfs_quota_us of the machine cgroup,
a kernel crash happens:

[ 5427.286505] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[ 5427.286513] IP: [<ffffffff812be7d1>] rb_next+0x1/0x50
[ 5427.286514] PGD 0 
[ 5427.286515] Oops: 0000 [#1] SMP 
[ 5427.286545] Modules linked in: vhost_net macvtap macvlan tun ipt_MASQUERADE xt_CHECKSUM ip6t_rpfilter ip6t_REJECT ipt_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iptable_filter ip_tables sg dm_mirror dm_region_hash dm_log dm_mod iTCO_wdt iTCO_vendor_support mlx4_en coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel igb ghash_clmulni_intel ptp mlx4_core aesni_intel pps_core lrw gf128mul glue_helper lpc_ich sb_edac ablk_helper mei_me ioatdma cryptd pcspkr edac_core i2c_i801 mfd_core mei shpchp
[ 5427.286554]  dca wmi mperf nfsd auth_rpcgss nfs_acl lockd sunrpc xfs libcrc32c sd_mod crc_t10dif crct10dif_common mgag200 syscopyarea isci sysfillrect sysimgblt i2c_algo_bit drm_kms_helper libsas ahci ttm libahci scsi_transport_sas drm libata i2c_core
[ 5427.286557] CPU: 9 PID: 84162 Comm: qemu-kvm Not tainted 3.10.0-123.el7.x86_64 #1
[ 5427.286558] Hardware name: Intel Corporation S2600WP/S2600WP, BIOS SE5C600.86B.02.01.0002.082220131453 08/22/2013
[ 5427.286559] task: ffff880fcafde660 ti: ffff880fc681c000 task.ti: ffff880fc681c000
[ 5427.286561] RIP: 0010:[<ffffffff812be7d1>]  [<ffffffff812be7d1>] rb_next+0x1/0x50
[ 5427.286562] RSP: 0018:ffff880fc681d988  EFLAGS: 00010046
[ 5427.286563] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 5427.286564] RDX: 0000000000000001 RSI: ffff881ffe674628 RDI: 0000000000000010
[ 5427.286564] RBP: ffff880fc681d9d0 R08: 0000000000000000 R09: 0000000000000001
[ 5427.286565] R10: 0000000000000001 R11: 0000000000000001 R12: ffff881fd9d02200
[ 5427.286565] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 5427.286566] FS:  00007f6b27950a40(0000) GS:ffff881ffe660000(0000) knlGS:0000000000000000
[ 5427.286567] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5427.286568] CR2: 0000000000000010 CR3: 0000000fd2649000 CR4: 00000000001427e0
[ 5427.286568] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5427.286569] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5427.286570] Stack:
[ 5427.286573]  ffff880fc681d9d0 ffffffff8109cc29 00000001c681d9c0 ffff881ffe674580
[ 5427.286575]  ffff880fcafdec40 ffff881ffe674580 0000000000000009 0000000000000000
[ 5427.286577]  ffff880fc681dbcc ffff880fc681da30 ffffffff815e6b22 ffff880fc681dfd8
[ 5427.286577] Call Trace:
[ 5427.286586]  [<ffffffff8109cc29>] ? pick_next_task_fair+0x129/0x1d0
[ 5427.286592]  [<ffffffff815e6b22>] __schedule+0x122/0x790
[ 5427.286594]  [<ffffffff815e71b9>] schedule+0x29/0x70
[ 5427.286597]  [<ffffffff815e64fc>] schedule_hrtimeout_range_clock+0x12c/0x170
[ 5427.286601]  [<ffffffff81089750>] ? hrtimer_get_res+0x50/0x50
[ 5427.286604]  [<ffffffff815e647c>] ? schedule_hrtimeout_range_clock+0xac/0x170
[ 5427.286606]  [<ffffffff815e6553>] schedule_hrtimeout_range+0x13/0x20
[ 5427.286611]  [<ffffffff811c3bf0>] poll_schedule_timeout+0x60/0xc0
[ 5427.286613]  [<ffffffff811c517d>] do_sys_poll+0x4cd/0x580
[ 5427.286619]  [<ffffffff814b807f>] ? sock_recvmsg+0xbf/0x100
[ 5427.286623]  [<ffffffff81090a7f>] ? __wake_up_sync_key+0x4f/0x60
[ 5427.286625]  [<ffffffff811c3b00>] ? poll_select_copy_remaining+0x150/0x150
[ 5427.286626]  [<ffffffff811c3b00>] ? poll_select_copy_remaining+0x150/0x150
[ 5427.286628]  [<ffffffff811c3b00>] ? poll_select_copy_remaining+0x150/0x150
[ 5427.286630]  [<ffffffff811c3b00>] ? poll_select_copy_remaining+0x150/0x150
[ 5427.286631]  [<ffffffff811c3b00>] ? poll_select_copy_remaining+0x150/0x150
[ 5427.286633]  [<ffffffff811c3b00>] ? poll_select_copy_remaining+0x150/0x150
[ 5427.286638]  [<ffffffff811fb517>] ? eventfd_ctx_read+0x67/0x260
[ 5427.286643]  [<ffffffff8101a0d9>] ? read_tsc+0x9/0x20
[ 5427.286648]  [<ffffffff810b68f8>] ? ktime_get_ts+0x48/0xe0
[ 5427.286650]  [<ffffffff811c5334>] SyS_poll+0x74/0x110
[ 5427.286653]  [<ffffffff815f2119>] system_call_fastpath+0x16/0x1b
[ 5427.286666] Code: 89 06 48 8b 47 08 48 89 46 08 48 8b 47 10 48 89 46 10 c3 0f 1f 80 00 00 00 00 48 89 32 eb b2 0f 1f 00 48 89 70 10 eb a9 66 90 55 <48> 8b 17 48 89 e5 48 39 d7 74 3b 48 8b 47 08 48 85 c0 75 0e eb 
[ 5427.286667] RIP  [<ffffffff812be7d1>] rb_next+0x1/0x50
[ 5427.286668]  RSP <ffff880fc681d988>
[ 5427.286668] CR2: 0000000000000010

-- 
Sincerely yours,
Mike.
