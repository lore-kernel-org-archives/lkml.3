Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab3CHFyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:54:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab3CHFym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 00:54:42 -0500
Message-ID: <51397D1D.5030602@redhat.com>
Date: Fri, 08 Mar 2013 13:54:37 +0800
From: WANG Chao <chaowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: CAI Qian <caiqian@redhat.com>
Subject: 3.9-rc1: crash kernel panic - not syncing: Can not allocate SWIOTLB
 buffer earlier and can't now provide you with the DMA bounce buffer
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All

On 3.9-rc1, I load crash kernel with latest kexec-tools(up to 28d413a), but
2nd kernel panic at early time:
[    2.948076] Kernel panic - not syncing: Can not allocate SWIOTLB buffer earlier and can't now provide you with the DMA bounce buffer
[    2.959958] Pid: 53, comm: khubd Not tainted 3.9.0-rc1+ #1
[    2.965426] Call Trace:
[    2.967866]  [<ffffffff81619acd>] panic+0xc1/0x1d0
[    2.972644]  [<ffffffff8131e50c>] swiotlb_tbl_map_single+0x27c/0x280
[    2.978991]  [<ffffffff8131ed59>] map_single+0x19/0x20
[    2.984115]  [<ffffffff8131ef1e>] swiotlb_map_page+0x6e/0x160
[    2.989845]  [<ffffffff81447e40>] usb_hcd_map_urb_for_dma+0x230/0x4a0
[    2.996268]  [<ffffffff81448345>] usb_hcd_submit_urb+0x295/0x8e0
[    3.002258]  [<ffffffff8109b90f>] ? __dequeue_entity+0x2f/0x50
[    3.008076]  [<ffffffff8101358e>] ? __switch_to+0x13e/0x4a0
[    3.013632]  [<ffffffff81449a2f>] usb_submit_urb+0xff/0x3d0
[    3.019186]  [<ffffffff816241be>] ? __schedule+0x3de/0x7e0
[    3.024657]  [<ffffffff8144ab6a>] usb_start_wait_urb+0x6a/0x160
[    3.030560]  [<ffffffff81189d15>] ? __kmalloc+0x55/0x210
[    3.035856]  [<ffffffff8144977e>] ? usb_alloc_urb+0x1e/0x50
[    3.041411]  [<ffffffff8144aece>] usb_control_msg+0xde/0x140
[    3.047056]  [<ffffffff81440680>] ? hub_port_init+0x310/0xaf0
[    3.052785]  [<ffffffff8144065b>] ? hub_port_init+0x2eb/0xaf0
[    3.058515]  [<ffffffff814406a8>] hub_port_init+0x338/0xaf0
[    3.064071]  [<ffffffff81407679>] ? update_autosuspend+0x39/0x60
[    3.070062]  [<ffffffff81407759>] ? pm_runtime_set_autosuspend_delay+0x49/0x70
[    3.077264]  [<ffffffff814438ba>] hub_port_connect_change+0x24a/0xaa0
[    3.083684]  [<ffffffff814443fa>] hub_events+0x2ea/0x910
[    3.088981]  [<ffffffff816241be>] ? __schedule+0x3de/0x7e0
[    3.094451]  [<ffffffff81444a55>] hub_thread+0x35/0x1e0
[    3.099661]  [<ffffffff81087480>] ? wake_up_bit+0x40/0x40
[    3.105045]  [<ffffffff81444a20>] ? hub_events+0x910/0x910
[    3.110514]  [<ffffffff81086a70>] kthread+0xc0/0xd0
[    3.115378]  [<ffffffff810869b0>] ? kthread_create_on_node+0x120/0x120
[    3.121887]  [<ffffffff8162e86c>] ret_from_fork+0x7c/0xb0
[    3.127271]  [<ffffffff810869b0>] ? kthread_create_on_node+0x120/0x120


Here's the full log:
# grep 'Crash' /proc/iomem
  146000000-14dffffff : Crash kernel

# dmesg | grep -i reserving
[    0.000000] Reserving 128MB of memory at 5216MB for crashkernel (System RAM: 3977MB)

# kexec -p /boot/vmlinuz-3.9.0-rc1+ --command-line='console=ttyS0,115200n81'
# echo c > /proc/sysrq-trigger

[  217.879315] SysRq : Trigger a crash
[  217.882836] BUG: unable to handle kernel NULL pointer dereference at           (null)
[  217.890674] IP: [<ffffffff813c19a6>] sysrq_handle_crash+0x16/0x20
[  217.896773] PGD 13df22067 PUD 139726067 PMD 0
[  217.901244] Oops: 0002 [#1] SMP
[  217.904491] Modules linked in: lockd sunrpc nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ip
v4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg coretemp kvm_inte
l kvm e1000e iTCO_wdt crc32c_intel iTCO_vendor_support ptp ghash_clmulni_intel pps_core mei microcode pcspkr i2c_i801 lpc_ich mfd_core xfs libcrc32c sr_mod sd_mod cdrom crc_t10dif i915 i2c_al
go_bit drm_kms_helper drm ahci libahci libata i2c_core video dm_mirror dm_region_hash dm_log dm_mod
[  217.963690] CPU 0
[  217.965526] Pid: 1206, comm: bash Not tainted 3.9.0-rc1+ #1 Intel Corporation 2012 Client Platform/Emerald Lake 2
[  217.975948] RIP: 0010:[<ffffffff813c19a6>]  [<ffffffff813c19a6>] sysrq_handle_crash+0x16/0x20
[  217.984468] RSP: 0018:ffff8801367e9e38  EFLAGS: 00010092
[  217.989765] RAX: 000000000000000f RBX: ffffffff819b67c0 RCX: ffff88014e20ffe8
[  217.996881] RDX: 0000000000000000 RSI: ffff88014e20e3b8 RDI: 0000000000000063
[  218.003998] RBP: ffff8801367e9e38 R08: ffffffff81c06280 R09: 0000000000000419
[  218.011113] R10: 0000000000000002 R11: 0000000000000418 R12: 0000000000000063
[  218.018230] R13: 0000000000000286 R14: 0000000000000000 R15: 0000000000000007
[  218.025346] FS:  00007fdd48ace740(0000) GS:ffff88014e200000(0000) knlGS:0000000000000000
[  218.033416] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  218.039147] CR2: 0000000000000000 CR3: 000000013a67c000 CR4: 00000000001407f0
[  218.046263] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  218.053379] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  218.060496] Process bash (pid: 1206, threadinfo ffff8801367e8000, task ffff88013e8ae5c0)
[  218.068564] Stack:
[  218.070570]  ffff8801367e9e78 ffffffff813c2147 ffff88013e8ae5c0 0000000000000002
[  218.078001]  ffff88013c4f9200 00007fdd48ad1000 0000000000000002 ffff8801367e9f50
[  218.085427]  ffff8801367e9ea8 ffffffff813c21fa ffff88013c4f9200 00007fdd48ad1000
[  218.092854] Call Trace:
[  218.095298]  [<ffffffff813c2147>] __handle_sysrq+0x127/0x190
[  218.100947]  [<ffffffff813c21fa>] write_sysrq_trigger+0x4a/0x50
[  218.106854]  [<ffffffff812064d5>] proc_reg_write+0x75/0xb0
[  218.112329]  [<ffffffff811a1d2c>] vfs_write+0xac/0x180
[  218.117456]  [<ffffffff811a2072>] sys_write+0x52/0xa0
[  218.122499]  [<ffffffff8162a23e>] ? do_page_fault+0xe/0x10
[  218.127977]  [<ffffffff8162e919>] system_call_fastpath+0x16/0x1b
[  218.133970] Code: 89 ef e8 ee f7 ff ff eb c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 0f 1f 44 00 00 55 c7 05 64 44 84 00 01 00 00 00 48 89 e5 0f ae f8 <c6> 04 25 00 00 00 00 01 5d c3 0f 1f 44 
00 00 55 48 89 e5 53 48
[  218.153653] RIP  [<ffffffff813c19a6>] sysrq_handle_crash+0x16/0x20
[  218.159834]  RSP <ffff8801367e9e38>
[  218.163311] CR2: 0000000000000000
I'm in purgatory
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.9.0-rc1+ (root@localhost) (gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC) ) #1 SMP Wed Mar 6 23:38:21 EST 2013
[    0.000000] Command line: console=ttyS0,115200n81 memmap=exactmap memmap=615K@4K memmap=130432K@5341184K elfcorehdr=5471616K memmap=2560K#2799016K memmap=84K#2801576K
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009abff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009ac00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000a8aaefff] usable
[    0.000000] BIOS-e820: [mem 0x00000000a8aaf000-0x00000000a8af1fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000a8af2000-0x00000000aa5c3fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000aa5c4000-0x00000000aad69fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000aad6a000-0x00000000aafe9fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000aafea000-0x00000000aaffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000aafff000-0x00000000aaffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ab000000-0x00000000af9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff900000-0x00000000ffbfffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffd00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000014e5fffff] usable
[    0.000000] e820: last_pfn = 0x14e600 max_arch_pfn = 0x400000000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: user-defined physical RAM map:
[    0.000000] user: [mem 0x0000000000001000-0x000000000009abff] usable
[    0.000000] user: [mem 0x00000000aad6a000-0x00000000aaffefff] ACPI data
[    0.000000] user: [mem 0x0000000146000000-0x000000014df5ffff] usable
[    0.000000] SMBIOS 2.6 present.
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x14df60 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] total RAM covered: 3990M
[    0.000000]  gran_size: 64K  chunk_size: 64K         num_reg: 10     lose cover RAM: 2M
[    0.000000]  gran_size: 64K  chunk_size: 128K        num_reg: 10     lose cover RAM: 2M
[    0.000000]  gran_size: 64K  chunk_size: 256K        num_reg: 10     lose cover RAM: 2M
[    0.000000]  gran_size: 64K  chunk_size: 512K        num_reg: 10     lose cover RAM: 2M
[    0.000000]  gran_size: 64K  chunk_size: 1M  num_reg: 10     lose cover RAM: 2M
[    0.000000]  gran_size: 64K  chunk_size: 2M  num_reg: 10     lose cover RAM: 2M
[    0.000000] *BAD*gran_size: 64K      chunk_size: 4M  num_reg: 10     lose cover RAM: -2M
[    0.000000] *BAD*gran_size: 64K      chunk_size: 8M  num_reg: 10     lose cover RAM: -2M
[    0.000000] *BAD*gran_size: 64K      chunk_size: 16M         num_reg: 10     lose cover RAM: -10M
[    0.000000]  gran_size: 64K  chunk_size: 32M         num_reg: 10     lose cover RAM: 0G
[    0.000000]  gran_size: 64K  chunk_size: 64M         num_reg: 10     lose cover RAM: 0G
[    0.000000]  gran_size: 64K  chunk_size: 128M        num_reg: 10     lose cover RAM: 0G
[    0.000000]  gran_size: 64K  chunk_size: 256M        num_reg: 10     lose cover RAM: 0G
[    0.000000] *BAD*gran_size: 64K      chunk_size: 512M        num_reg: 10     lose cover RAM: -256M
[    0.000000] *BAD*gran_size: 64K      chunk_size: 1G  num_reg: 10     lose cover RAM: -512M
[    0.000000] *BAD*gran_size: 64K      chunk_size: 2G  num_reg: 10     lose cover RAM: -512M
[    0.000000]  gran_size: 128K         chunk_size: 128K        num_reg: 10     lose cover RAM: 2M
[    0.000000]  gran_size: 128K         chunk_size: 256K        num_reg: 10     lose cover RAM: 2M
[    0.000000]  gran_size: 128K         chunk_size: 512K        num_reg: 10     lose cover RAM: 2M
[    0.000000]  gran_size: 128K         chunk_size: 1M  num_reg: 10     lose cover RAM: 2M
[    0.000000]  gran_size: 128K         chunk_size: 2M  num_reg: 10     lose cover RAM: 2M
[    0.000000] *BAD*gran_size: 128K     chunk_size: 4M  num_reg: 10     lose cover RAM: -2M
[    0.000000] *BAD*gran_size: 128K     chunk_size: 8M  num_reg: 10     lose cover RAM: -2M
[    0.000000] *BAD*gran_size: 128K     chunk_size: 16M         num_reg: 10     lose cover RAM: -10M
[    0.000000]  gran_size: 128K         chunk_size: 32M         num_reg: 10     lose cover RAM: 0G
[    0.000000]  gran_size: 128K         chunk_size: 64M         num_reg: 10     lose cover RAM: 0G
[    0.000000]  gran_size: 128K         chunk_size: 128M        num_reg: 10     lose cover RAM: 0G
[    0.000000]  gran_size: 128K         chunk_size: 256M        num_reg: 10     lose cover RAM: 0G
[    0.000000] *BAD*gran_size: 128K     chunk_size: 512M        num_reg: 10     lose cover RAM: -256M
[    0.000000] *BAD*gran_size: 128K     chunk_size: 1G  num_reg: 10     lose cover RAM: -512M
[    0.000000] *BAD*gran_size: 128K     chunk_size: 2G  num_reg: 10     lose cover RAM: -512M
[    0.000000]  gran_size: 256K         chunk_size: 256K        num_reg: 10     lose cover RAM: 2M
[    0.000000]  gran_size: 256K         chunk_size: 512K        num_reg: 10     lose cover RAM: 2M
[    0.000000]  gran_size: 256K         chunk_size: 1M  num_reg: 10     lose cover RAM: 2M
[    0.000000]  gran_size: 256K         chunk_size: 2M  num_reg: 10     lose cover RAM: 2M
[    0.000000] *BAD*gran_size: 256K     chunk_size: 4M  num_reg: 10     lose cover RAM: -2M
[    0.000000] *BAD*gran_size: 256K     chunk_size: 8M  num_reg: 10     lose cover RAM: -2M
[    0.000000] *BAD*gran_size: 256K     chunk_size: 16M         num_reg: 10     lose cover RAM: -10M
[    0.000000]  gran_size: 256K         chunk_size: 32M         num_reg: 10     lose cover RAM: 0G
[    0.000000]  gran_size: 256K         chunk_size: 64M         num_reg: 10     lose cover RAM: 0G
[    0.000000]  gran_size: 256K         chunk_size: 128M        num_reg: 10     lose cover RAM: 0G
[    0.000000]  gran_size: 256K         chunk_size: 256M        num_reg: 10     lose cover RAM: 0G
[    0.000000] *BAD*gran_size: 256K     chunk_size: 512M        num_reg: 10     lose cover RAM: -256M
[    0.000000] *BAD*gran_size: 256K     chunk_size: 1G  num_reg: 10     lose cover RAM: -512M
[    0.000000] *BAD*gran_size: 256K     chunk_size: 2G  num_reg: 10     lose cover RAM: -512M
[    0.000000]  gran_size: 512K         chunk_size: 512K        num_reg: 10     lose cover RAM: 2M
[    0.000000]  gran_size: 512K         chunk_size: 1M  num_reg: 10     lose cover RAM: 2M
[    0.000000]  gran_size: 512K         chunk_size: 2M  num_reg: 10     lose cover RAM: 2M
[    0.000000] *BAD*gran_size: 512K     chunk_size: 4M  num_reg: 10     lose cover RAM: -2M
[    0.000000] *BAD*gran_size: 512K     chunk_size: 8M  num_reg: 10     lose cover RAM: -2M
[    0.000000] *BAD*gran_size: 512K     chunk_size: 16M         num_reg: 10     lose cover RAM: -10M
[    0.000000]  gran_size: 512K         chunk_size: 32M         num_reg: 10     lose cover RAM: 0G
[    0.000000]  gran_size: 512K         chunk_size: 64M         num_reg: 10     lose cover RAM: 0G
[    0.000000]  gran_size: 512K         chunk_size: 128M        num_reg: 10     lose cover RAM: 0G
[    0.000000]  gran_size: 512K         chunk_size: 256M        num_reg: 10     lose cover RAM: 0G
[    0.000000] *BAD*gran_size: 512K     chunk_size: 512M        num_reg: 10     lose cover RAM: -256M
[    0.000000] *BAD*gran_size: 512K     chunk_size: 1G  num_reg: 10     lose cover RAM: -512M
[    0.000000] *BAD*gran_size: 512K     chunk_size: 2G  num_reg: 10     lose cover RAM: -512M
[    0.000000]  gran_size: 1M   chunk_size: 1M  num_reg: 10     lose cover RAM: 2M
[    0.000000]  gran_size: 1M   chunk_size: 2M  num_reg: 10     lose cover RAM: 2M
[    0.000000] *BAD*gran_size: 1M       chunk_size: 4M  num_reg: 10     lose cover RAM: -2M
[    0.000000] *BAD*gran_size: 1M       chunk_size: 8M  num_reg: 10     lose cover RAM: -2M
[    0.000000] *BAD*gran_size: 1M       chunk_size: 16M         num_reg: 10     lose cover RAM: -10M
[    0.000000]  gran_size: 1M   chunk_size: 32M         num_reg: 10     lose cover RAM: 0G
[    0.000000]  gran_size: 1M   chunk_size: 64M         num_reg: 10     lose cover RAM: 0G
[    0.000000]  gran_size: 1M   chunk_size: 128M        num_reg: 10     lose cover RAM: 0G
[    0.000000]  gran_size: 1M   chunk_size: 256M        num_reg: 10     lose cover RAM: 0G
[    0.000000] *BAD*gran_size: 1M       chunk_size: 512M        num_reg: 10     lose cover RAM: -256M
[    0.000000] *BAD*gran_size: 1M       chunk_size: 1G  num_reg: 10     lose cover RAM: -512M
[    0.000000] *BAD*gran_size: 1M       chunk_size: 2G  num_reg: 10     lose cover RAM: -512M
[    0.000000]  gran_size: 2M   chunk_size: 2M  num_reg: 10     lose cover RAM: 2M
[    0.000000] *BAD*gran_size: 2M       chunk_size: 4M  num_reg: 10     lose cover RAM: -2M
[    0.000000] *BAD*gran_size: 2M       chunk_size: 8M  num_reg: 10     lose cover RAM: -2M
[    0.000000] *BAD*gran_size: 2M       chunk_size: 16M         num_reg: 10     lose cover RAM: -10M
[    0.000000]  gran_size: 2M   chunk_size: 32M         num_reg: 10     lose cover RAM: 0G
[    0.000000]  gran_size: 2M   chunk_size: 64M         num_reg: 10     lose cover RAM: 0G
[    0.000000]  gran_size: 2M   chunk_size: 128M        num_reg: 10     lose cover RAM: 0G
[    0.000000]  gran_size: 2M   chunk_size: 256M        num_reg: 10     lose cover RAM: 0G
[    0.000000] *BAD*gran_size: 2M       chunk_size: 512M        num_reg: 10     lose cover RAM: -256M
[    0.000000] *BAD*gran_size: 2M       chunk_size: 1G  num_reg: 10     lose cover RAM: -512M
[    0.000000] *BAD*gran_size: 2M       chunk_size: 2G  num_reg: 10     lose cover RAM: -512M
[    0.000000]  gran_size: 4M   chunk_size: 4M  num_reg: 10     lose cover RAM: 2M
[    0.000000] *BAD*gran_size: 4M       chunk_size: 8M  num_reg: 10     lose cover RAM: -2M
[    0.000000] *BAD*gran_size: 4M       chunk_size: 16M         num_reg: 10     lose cover RAM: -10M
[    0.000000]  gran_size: 4M   chunk_size: 32M         num_reg: 10     lose cover RAM: 2M
[    0.000000]  gran_size: 4M   chunk_size: 64M         num_reg: 10     lose cover RAM: 2M
[    0.000000]  gran_size: 4M   chunk_size: 128M        num_reg: 10     lose cover RAM: 2M
[    0.000000]  gran_size: 4M   chunk_size: 256M        num_reg: 10     lose cover RAM: 2M
[    0.000000] *BAD*gran_size: 4M       chunk_size: 512M        num_reg: 10     lose cover RAM: -254M
[    0.000000] *BAD*gran_size: 4M       chunk_size: 1G  num_reg: 10     lose cover RAM: -510M
[    0.000000] *BAD*gran_size: 4M       chunk_size: 2G  num_reg: 10     lose cover RAM: -510M
[    0.000000]  gran_size: 8M   chunk_size: 8M  num_reg: 9      lose cover RAM: 6M
[    0.000000]  gran_size: 8M   chunk_size: 16M         num_reg: 9      lose cover RAM: 6M
[    0.000000]  gran_size: 8M   chunk_size: 32M         num_reg: 9      lose cover RAM: 6M
[    0.000000]  gran_size: 8M   chunk_size: 64M         num_reg: 8      lose cover RAM: 6M
[    0.000000]  gran_size: 8M   chunk_size: 128M        num_reg: 8      lose cover RAM: 6M
[    0.000000]  gran_size: 8M   chunk_size: 256M        num_reg: 8      lose cover RAM: 6M
[    0.000000]  gran_size: 8M   chunk_size: 512M        num_reg: 9      lose cover RAM: 6M
[    0.000000]  gran_size: 8M   chunk_size: 1G  num_reg: 9      lose cover RAM: 6M
[    0.000000]  gran_size: 8M   chunk_size: 2G  num_reg: 9      lose cover RAM: 6M
[    0.000000]  gran_size: 16M  chunk_size: 16M         num_reg: 9      lose cover RAM: 6M
[    0.000000]  gran_size: 16M  chunk_size: 32M         num_reg: 9      lose cover RAM: 6M
[    0.000000]  gran_size: 16M  chunk_size: 64M         num_reg: 8      lose cover RAM: 6M
[    0.000000]  gran_size: 16M  chunk_size: 128M        num_reg: 8      lose cover RAM: 6M
[    0.000000]  gran_size: 16M  chunk_size: 256M        num_reg: 8      lose cover RAM: 6M
[    0.000000]  gran_size: 16M  chunk_size: 512M        num_reg: 9      lose cover RAM: 6M
[    0.000000]  gran_size: 16M  chunk_size: 1G  num_reg: 9      lose cover RAM: 6M
[    0.000000]  gran_size: 16M  chunk_size: 2G  num_reg: 9      lose cover RAM: 6M
[    0.000000]  gran_size: 32M  chunk_size: 32M         num_reg: 8      lose cover RAM: 22M
[    0.000000]  gran_size: 32M  chunk_size: 64M         num_reg: 8      lose cover RAM: 22M
[    0.000000]  gran_size: 32M  chunk_size: 128M        num_reg: 8      lose cover RAM: 22M
[    0.000000]  gran_size: 32M  chunk_size: 256M        num_reg: 8      lose cover RAM: 22M
[    0.000000]  gran_size: 32M  chunk_size: 512M        num_reg: 9      lose cover RAM: 22M
[    0.000000]  gran_size: 32M  chunk_size: 1G  num_reg: 9      lose cover RAM: 22M
[    0.000000]  gran_size: 32M  chunk_size: 2G  num_reg: 9      lose cover RAM: 22M
[    0.000000]  gran_size: 64M  chunk_size: 64M         num_reg: 6      lose cover RAM: 86M
[    0.000000]  gran_size: 64M  chunk_size: 128M        num_reg: 6      lose cover RAM: 86M
[    0.000000]  gran_size: 64M  chunk_size: 256M        num_reg: 7      lose cover RAM: 86M
[    0.000000]  gran_size: 64M  chunk_size: 512M        num_reg: 8      lose cover RAM: 86M
[    0.000000]  gran_size: 64M  chunk_size: 1G  num_reg: 8      lose cover RAM: 86M
[    0.000000]  gran_size: 64M  chunk_size: 2G  num_reg: 8      lose cover RAM: 86M
[    0.000000]  gran_size: 128M         chunk_size: 128M        num_reg: 5      lose cover RAM: 150M
[    0.000000]  gran_size: 128M         chunk_size: 256M        num_reg: 7      lose cover RAM: 150M
[    0.000000]  gran_size: 128M         chunk_size: 512M        num_reg: 8      lose cover RAM: 150M
[    0.000000]  gran_size: 128M         chunk_size: 1G  num_reg: 8      lose cover RAM: 150M
[    0.000000]  gran_size: 128M         chunk_size: 2G  num_reg: 8      lose cover RAM: 150M
[    0.000000]  gran_size: 256M         chunk_size: 256M        num_reg: 3      lose cover RAM: 406M
[    0.000000]  gran_size: 256M         chunk_size: 512M        num_reg: 3      lose cover RAM: 406M
[    0.000000]  gran_size: 256M         chunk_size: 1G  num_reg: 4      lose cover RAM: 406M
[    0.000000]  gran_size: 256M         chunk_size: 2G  num_reg: 4      lose cover RAM: 406M
[    0.000000]  gran_size: 512M         chunk_size: 512M        num_reg: 3      lose cover RAM: 406M
[    0.000000]  gran_size: 512M         chunk_size: 1G  num_reg: 4      lose cover RAM: 406M
[    0.000000]  gran_size: 512M         chunk_size: 2G  num_reg: 4      lose cover RAM: 406M
[    0.000000]  gran_size: 1G   chunk_size: 1G  num_reg: 2      lose cover RAM: 918M
[    0.000000]  gran_size: 1G   chunk_size: 2G  num_reg: 2      lose cover RAM: 918M
[    0.000000]  gran_size: 2G   chunk_size: 2G  num_reg: 1      lose cover RAM: 1942M
[    0.000000] mtrr_cleanup: can not find optimal value
[    0.000000] please specify mtrr_gran_size/mtrr_chunk_size
[    0.000000] x2apic enabled by BIOS, switching to x2apic ops
[    0.000000] e820: last_pfn = 0x9a max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fc9f0-0x000fc9ff] mapped at [ffff8800000fc9f0]
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0x14de00000-0x14df5ffff]
[    0.000000] init_memory_mapping: [mem 0x14c000000-0x14ddfffff]
[    0.000000] init_memory_mapping: [mem 0x146000000-0x14bffffff]
[    0.000000] ACPI: RSDP 00000000000f0410 00024 (v02  INTEL)
[    0.000000] ACPI: XSDT 00000000aaffde18 00074 (v01  INTEL  IVB-PPT 06222004 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000aafe3d98 000F4 (v04  INTEL  IVB-PPT 06222004 MSFT 00010013)
[    0.000000] ACPI: DSDT 00000000aafbe018 0FD25 (v02  INTEL  IVB-PPT 00000000 INTL 20110623)
[    0.000000] ACPI: FACS 00000000aafe9e40 00040
[    0.000000] ACPI: APIC 00000000aaffcf18 000CC (v02  INTEL  IVB-PPT 06222004 MSFT 00010013)
[    0.000000] ACPI: HPET 00000000aafe8f18 00038 (v01 A M I   PCHHPET 06222004 AMI. 00000003)
[    0.000000] ACPI: SSDT 00000000aafe5018 010A8 (v01 TrmRef PtidDevc 00001000 INTL 20110623)
[    0.000000] ACPI: SSDT 00000000aafe4a18 00461 (v01    AMI PerfTune 00001000 INTL 20110623)
[    0.000000] ACPI: MCFG 00000000aafe8e98 0003C (v01 INTEL  SNDYBRDG 06222004 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000aafd2018 009AA (v01  PmRef  Cpu0Ist 00003000 INTL 20110623)
[    0.000000] ACPI: SSDT 00000000aafd1018 00A92 (v01  PmRef    CpuPm 00003000 INTL 20110623)
[    0.000000] ACPI: DMAR 00000000aafe4f18 000B8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: FPDT 00000000aaff4018 00064 (v01  INTEL  IVB-CPT 00010000 INTL 20111107)
[    0.000000] Setting APIC routing to cluster x2apic.
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000014df5ffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x14df5ffff]
[    0.000000]   NODE_DATA [mem 0x14df39000-0x14df5ffff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x14df5ffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00099fff]
[    0.000000]   node   0: [mem 0x146000000-0x14df5ffff]
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 16 CPUs, 8 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009a000 - 00000000aad6a000
[    0.000000] PM: Registered nosave memory: 00000000aad6a000 - 00000000aafff000
[    0.000000] PM: Registered nosave memory: 00000000aafff000 - 0000000146000000
[    0.000000] e820: [mem 0x0009ac00-0xaad69fff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:16 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88014dc00000 s86272 r8192 d24320 u131072
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32227
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: console=ttyS0,115200n81 memmap=exactmap memmap=615K@4K memmap=130432K@5341184K elfcorehdr=5471616K memmap=2560K#2799016K memmap=84K#2801576K
[    0.000000] PID hash table entries: 512 (order: 0, 4096 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Cannot allocate SWIOTLB buffer
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 108184k/5471616k available (6346k kernel code, 5340572k absent, 22860k reserved, 3983k data, 1484k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU restricting CPUs from NR_CPUS=4096 to nr_cpu_ids=16.
[    0.000000] NR_IRQS:262400 nr_irqs:808 16
[    0.000000] Spurious LAPIC timer interrupt on cpu 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 1572864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.001000] tsc: Fast TSC calibration using PIT
[    0.002000] tsc: Detected 2593.881 MHz processor
[    0.000005] Calibrating delay loop (skipped), value calculated using timer frequency.. 5187.76 BogoMIPS (lpj=2593881)
[    0.010628] pid_max: default: 32768 minimum: 301
[    0.015311] Security Framework initialized
[    0.019418] SELinux:  Initializing.
[    0.023012] Dentry cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.030043] Inode-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.036777] Mount-cache hash table entries: 256
[    0.041629] Initializing cgroup subsys cpuacct
[    0.046079] Initializing cgroup subsys memory
[    0.050447] Initializing cgroup subsys devices
[    0.054891] Initializing cgroup subsys freezer
[    0.059335] Initializing cgroup subsys net_cls
[    0.063777] Initializing cgroup subsys blkio
[    0.068045] Initializing cgroup subsys perf_event
[    0.072794] CPU: Physical Processor ID: 0
[    0.076806] CPU: Processor Core ID: 0
[    0.081210] mce: CPU supports 9 MCE banks
[    0.085254] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.085254] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.085254] tlb_flushall_shift: 1
[    0.099844] Freeing SMP alternatives: 24k freed
[    0.106487] ACPI: Core revision 20130117
[    0.122586] ACPI: All ACPI Tables successfully acquired
[    0.127868] ftrace: allocating 23601 entries in 93 pages
[    0.154031] dmar: Host address width 36
[    0.157876] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.163194] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.171277] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.176590] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f010da
[    0.184672] dmar: RMRR base: 0x000000aac95000 end: 0x000000aacb2fff
[    0.190934] dmar: RMRR base: 0x000000ab800000 end: 0x000000af9fffff
[    0.197268] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.202825] HPET id 0 under DRHD base 0xfed91000
[    0.207714] Enabled IRQ remapping in x2apic mode
[    0.212866] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.228870] smpboot: CPU0: Intel(R) Core(TM) i7-3720QM CPU @ 2.60GHz (fam: 06, model: 3a, stepping: 09)
[    0.238319] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, Broken BIOS detected, complain to your hardware vendor.
[    0.250098] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 38d is b0)
[    0.257739] Intel PMU driver.
[    0.260701] ... version:                3
[    0.264704] ... bit width:              48
[    0.268790] ... generic registers:      4
[    0.272791] ... value mask:             0000ffffffffffff
[    0.278092] ... max period:             000000007fffffff
[    0.283391] ... fixed-purpose events:   3
[    0.287391] ... event mask:             000000070000000f
[    0.294917] smpboot: Booting Node   0, Processors  #1[    0.314489] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
 #2 #3 #4 #5 #6 #7
[    0.408750] Brought up 8 CPUs
[    0.411901] smpboot: Total of 8 processors activated (41502.09 BogoMIPS)
[    0.432134] devtmpfs: initialized
[    0.437882] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.444833] NET: Registered protocol family 16
[    0.449455] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.457010] ACPI: bus type pci registered
[    0.461122] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.470411] PCI: not using MMCONFIG
[    0.473897] PCI: Using configuration type 1 for base access
[    0.480792] bio: create slab <bio-0> at 0
[    0.484937] ACPI: Added _OSI(Module Device)
[    0.489116] ACPI: Added _OSI(Processor Device)
[    0.493554] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.498254] ACPI: Added _OSI(Processor Aggregator Device)
[    0.509686] ACPI: Executed 1 blocks of module-level executable AML code
[    0.529844] ACPI: SSDT 00000000aaccd018 00A4F (v01  PmRef  Cpu0Cst 00003001 INTL 20110623)
[    0.538912] ACPI: Dynamic OEM Table Load:
[    0.542947] ACPI: SSDT           (null) 00A4F (v01  PmRef  Cpu0Cst 00003001 INTL 20110623)
[    0.556403] ACPI: SSDT 00000000aaccea98 00303 (v01  PmRef    ApIst 00003000 INTL 20110623)
[    0.565515] ACPI: Dynamic OEM Table Load:
[    0.569549] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20110623)
[    0.582778] ACPI: SSDT 00000000aacccd98 00119 (v01  PmRef    ApCst 00003000 INTL 20110623)
[    0.591819] ACPI: Dynamic OEM Table Load:
[    0.595855] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20110623)
[    1.418743] ACPI: Interpreter enabled
[    1.422408] ACPI: (supports S0 S1ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\\_S2_] (20130117/hwxface-568)
[    1.433515]  S3 S4 S5)
[    1.435935] ACPI: Using IOAPIC for interrupt routing
[    1.440920] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    1.451100] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
[    1.464742] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.488550] ACPI: Power Resource [FN00] (off)
[    1.493020] ACPI: Power Resource [FN01] (off)
[    1.497481] ACPI: Power Resource [FN02] (on)
[    1.502241] ACPI: Power Resource [FN03] (on)
[    1.506935] ACPI: Power Resource [FN04] (on)
[    1.512503] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.519005] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    1.526995] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    1.535557] PCI host bridge to bus 0000:00
[    1.539653] pci_bus 0000:00: root bus resource [bus 00-3e]
[    1.545132] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.551304] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.557474] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.564338] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    1.571201] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    1.578064] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    1.584923] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    1.591784] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    1.598644] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    1.605503] pci_bus 0000:00: root bus resource [mem 0xafa00000-0xfeafffff]
[    1.613008] pci 0000:00:14.0: System wakeup disabled by ACPI
[    1.619582] pci 0000:00:19.0: System wakeup disabled by ACPI
[    1.625584] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    1.631518] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    1.637463] pci 0000:00:1c.6: System wakeup disabled by ACPI
[    1.643459] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    1.650069] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.655146] pci 0000:00:1c.6: PCI bridge to [bus 02-09]
[    1.660411] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.668220] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    1.676298] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.684560] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    1.692628] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
[    1.700698] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15), disabled.
[    1.708765] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.717023] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.725280] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
[    1.733756] ACPI: Enabled 5 GPEs in block 00 to 3F
[    1.738777] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    1.746393] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    1.752307] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.760387] vgaarb: loaded
[    1.763093] vgaarb: bridge control possible 0000:00:02.0
[    1.768498] SCSI subsystem initialized
[    1.772270] ACPI: bus type usb registered
[    1.776297] usbcore: registered new interface driver usbfs
[    1.781783] usbcore: registered new interface driver hub
[    1.787122] usbcore: registered new device driver usb
[    1.792242] PCI: Using ACPI for IRQ routing
[    1.800410] NetLabel: Initializing
[    1.803809] NetLabel:  domain hash size = 128
[    1.808159] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.813125] NetLabel:  unlabeled traffic allowed by default
[    1.818736] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.825032] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.832871] Switching to clocksource hpet
[    1.845000] pnp: PnP ACPI init
[    1.848089] ACPI: bus type pnp registered
[    1.852490] system 00:00: [io  0x06a4] has been reserved
[    1.857802] system 00:00: [io  0x06a0] has been reserved
[    1.863449] system 00:05: [io  0x0680-0x069f] has been reserved
[    1.869370] system 00:05: [io  0x1004-0x1013] has been reserved
[    1.875291] system 00:05: [io  0xffff] has been reserved
[    1.880604] system 00:05: [io  0xffff] has been reserved
[    1.885918] system 00:05: [io  0x0400-0x0453] has been reserved
[    1.891836] system 00:05: [io  0x0458-0x047f] has been reserved
[    1.897754] system 00:05: [io  0x0500-0x057f] has been reserved
[    1.903673] system 00:05: [io  0x164e-0x164f] has been reserved
[    1.909718] system 00:07: [io  0x0454-0x0457] has been reserved
[    1.916807] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.923425] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
[    1.930043] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.936656] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.943267] system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
[    1.949879] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.956492] system 00:0b: [mem 0xfed90000-0xfed93fff] could not be reserved
[    1.963449] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.970062] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
[    1.976677] system 00:0b: [mem 0xfee00000-0xfeefffff] has been reserved
[    1.983292] system 00:0b: [mem 0xafa00000-0xafa00fff] has been reserved
[    1.990474] system 00:0c: [mem 0x00000000-0x0009cfff] could not be reserved
[    1.997547] system 00:0d: [mem 0x20000000-0x201fffff] has been reserved
[    2.004160] system 00:0d: [mem 0x40004000-0x40004fff] has been reserved
[    2.010844] pnp: PnP ACPI: found 14 devices
[    2.015025] ACPI: ACPI bus type pnp unregistered
[    2.027290] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    2.032277] pci 0000:00:1c.6: PCI bridge to [bus 02-09]
[    2.037501] pci 0000:00:1c.6:   bridge window [io  0x2000-0x5fff]
[    2.043599] pci 0000:00:1c.6:   bridge window [mem 0xb0000000-0xb10fffff]
[    2.050391] pci 0000:00:1c.6:   bridge window [mem 0xd0000000-0xd10fffff 64bit pref]
[    2.058446] NET: Registered protocol family 2
[    2.063068] TCP established hash table entries: 1024 (order: 2, 16384 bytes)
[    2.070133] TCP bind hash table entries: 1024 (order: 2, 16384 bytes)
[    2.076578] TCP: Hash tables configured (established 1024 bind 1024)
[    2.082996] TCP: reno registered
[    2.086255] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    2.092092] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    2.098509] NET: Registered protocol family 1
[    2.103710] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.110160] software IO TLB: No low mem
[    2.116187] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    2.123111] Initialise module verification
[    2.127274] audit: initializing netlink socket (disabled)
[    2.132684] type=2000 audit(1362698281.479:1): initialized
[    2.185575] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.193943] VFS: Disk quotas dquot_6.5.2
[    2.197950] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.205330] msgmni has been set to 211
[    2.210287] alg: No test for stdrng (krng)
[    2.214402] NET: Registered protocol family 38
[    2.218851] Key type asymmetric registered
[    2.222951] Asymmetric key parser 'x509' registered
[    2.227888] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    2.235322] io scheduler noop registered
[    2.239247] io scheduler deadline registered (default)
[    2.244403] io scheduler cfq registered
[    2.248531] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.254132] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.260741] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    2.267305] acpiphp_glue: can't evaluate _ADR (0x5)
[    2.272577] ACPI: AC Adapter [ADP1] (on-line)
[    2.277080] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    2.285391] ACPI: Lid Switch [LID0]
[    2.288954] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    2.297299] ACPI: Power Button [PWRB]
[    2.301017] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    2.308410] ACPI: Power Button [PWRF]
[    2.312155] ACPI: Fan [FAN0] (off)
[    2.315615] ACPI: Fan [FAN1] (off)
[    2.319067] ACPI: Fan [FAN2] (on)
[    2.322435] ACPI: Fan [FAN3] (on)
[    2.325793] ACPI: Fan [FAN4] (on)
[    2.329202] ACPI: Requesting acpi_cpufreq
[    2.340021] thermal LNXTHERM:00: registered as thermal_zone0
[    2.345688] ACPI: Thermal Zone [TZ00] (32 C)
[    2.351008] thermal LNXTHERM:01: registered as thermal_zone1
[    2.356672] ACPI: Thermal Zone [TZ01] (33 C)
[    2.364912] GHES: HEST is not enabled!
[    2.365203] ACPI: Battery Slot [BAT0] (battery present)
[    2.365238] ACPI: Battery Slot [BAT1] (battery absent)
[    2.365350] ACPI: Battery Slot [BAT2] (battery absent)
[    2.384217] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.411446] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.438082] serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
[    2.464897] 0000:00:16.3: ttyS1 at I/O 0x60e0 (irq = 19) is a 16550A
[    2.471729] Non-volatile memory driver v1.3
[    2.475917] Linux agpgart interface v0.103
[    2.481169] loop: module loaded
[    2.484342] rdac: device handler registered
[    2.488599] hp_sw: device handler registered
[    2.492869] emc: device handler registered
[    2.496970] alua: device handler registered
[    2.501205] libphy: Fixed MDIO Bus: probed
[    2.505370] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.511893] ehci-pci: EHCI PCI platform driver
[    2.516470] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    2.521763] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.529178] ehci-pci 0000:00:1a.0: debug port 2
[    2.537665] ehci-pci 0000:00:1a.0: irq 16, io mem 0xb1160000
[    2.548387] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.554157] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.560941] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.568161] usb usb1: Product: EHCI Host Controller
[    2.573041] usb usb1: Manufacturer: Linux 3.9.0-rc1+ ehci_hcd
[    2.578784] usb usb1: SerialNumber: 0000:00:1a.0
[    2.583547] hub 1-0:1.0: USB hub found
[    2.587305] hub 1-0:1.0: 3 ports detected
[    2.591639] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    2.596930] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.604343] ehci-pci 0000:00:1d.0: debug port 2
[    2.612811] ehci-pci 0000:00:1d.0: irq 23, io mem 0xb1150000
[    2.624437] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.630204] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.636987] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.644206] usb usb2: Product: EHCI Host Controller
[    2.649084] usb usb2: Manufacturer: Linux 3.9.0-rc1+ ehci_hcd
[    2.654830] usb usb2: SerialNumber: 0000:00:1d.0
[    2.659586] hub 2-0:1.0: USB hub found
[    2.663345] hub 2-0:1.0: 3 ports detected
[    2.667593] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.673792] uhci_hcd: USB Universal Host Controller Interface driver
[    2.680291] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.685578] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    2.693119] xhci_hcd 0000:00:14.0: irq 16, io mem 0xb11a0000
[    2.698942] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    2.705729] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.712948] usb usb3: Product: xHCI Host Controller
[    2.717823] usb usb3: Manufacturer: Linux 3.9.0-rc1+ xhci_hcd
[    2.723564] usb usb3: SerialNumber: 0000:00:14.0
[    2.728328] hub 3-0:1.0: USB hub found
[    2.732094] hub 3-0:1.0: 4 ports detected
[    2.736783] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.742078] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    2.749514] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    2.756299] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.763516] usb usb4: Product: xHCI Host Controller
[    2.768400] usb usb4: Manufacturer: Linux 3.9.0-rc1+ xhci_hcd
[    2.774148] usb usb4: SerialNumber: 0000:00:14.0
[    2.778964] hub 4-0:1.0: USB hub found
[    2.782737] hub 4-0:1.0: 4 ports detected
[    2.791587] usbcore: registered new interface driver usbserial
[    2.797430] usbcore: registered new interface driver usbserial_generic
[    2.803956] usbserial: USB Serial support registered for generic
[    2.810001] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    2.816782] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    2.827473] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.832534] mousedev: PS/2 mouse device common for all mice
[    2.838423] rtc_cmos 00:06: RTC can wake from S4
[    2.843292] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    2.849434] rtc_cmos 00:06: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    2.857324] cpuidle: using governor ladder
[    2.861761] cpuidle: using governor menu
[    2.866158] EFI Variables Facility v0.08 2004-May-17
[    2.871140] hidraw: raw HID events driver (C) Jiri Kosina
[    2.873905] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    2.885248] usbcore: registered new interface driver usbhid
[    2.890818] usbhid: USB HID core driver
[    2.894647] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    2.894695] drop_monitor: Initializing network drop monitor service
[    2.894813] TCP: cubic registered
[    2.894815] Initializing XFRM netlink socket
[    2.894988] NET: Registered protocol family 10
[    2.895269] NET: Registered protocol family 17
[    2.895770] Loading module verification certificates
[    2.897372] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: b14fa6fba81316fe0bb193bbf458deba6d430978'
[    2.897384] registered taskstats version 1
[    2.897388] IMA: No TPM chip found, activating TPM-bypass!
[    2.948076] Kernel panic - not syncing: Can not allocate SWIOTLB buffer earlier and can't now provide you with the DMA bounce buffer
[    2.959958] Pid: 53, comm: khubd Not tainted 3.9.0-rc1+ #1
[    2.965426] Call Trace:
[    2.967866]  [<ffffffff81619acd>] panic+0xc1/0x1d0
[    2.972644]  [<ffffffff8131e50c>] swiotlb_tbl_map_single+0x27c/0x280
[    2.978991]  [<ffffffff8131ed59>] map_single+0x19/0x20
[    2.984115]  [<ffffffff8131ef1e>] swiotlb_map_page+0x6e/0x160
[    2.989845]  [<ffffffff81447e40>] usb_hcd_map_urb_for_dma+0x230/0x4a0
[    2.996268]  [<ffffffff81448345>] usb_hcd_submit_urb+0x295/0x8e0
[    3.002258]  [<ffffffff8109b90f>] ? __dequeue_entity+0x2f/0x50
[    3.008076]  [<ffffffff8101358e>] ? __switch_to+0x13e/0x4a0
[    3.013632]  [<ffffffff81449a2f>] usb_submit_urb+0xff/0x3d0
[    3.019186]  [<ffffffff816241be>] ? __schedule+0x3de/0x7e0
[    3.024657]  [<ffffffff8144ab6a>] usb_start_wait_urb+0x6a/0x160
[    3.030560]  [<ffffffff81189d15>] ? __kmalloc+0x55/0x210
[    3.035856]  [<ffffffff8144977e>] ? usb_alloc_urb+0x1e/0x50
[    3.041411]  [<ffffffff8144aece>] usb_control_msg+0xde/0x140
[    3.047056]  [<ffffffff81440680>] ? hub_port_init+0x310/0xaf0
[    3.052785]  [<ffffffff8144065b>] ? hub_port_init+0x2eb/0xaf0
[    3.058515]  [<ffffffff814406a8>] hub_port_init+0x338/0xaf0
[    3.064071]  [<ffffffff81407679>] ? update_autosuspend+0x39/0x60
[    3.070062]  [<ffffffff81407759>] ? pm_runtime_set_autosuspend_delay+0x49/0x70
[    3.077264]  [<ffffffff814438ba>] hub_port_connect_change+0x24a/0xaa0
[    3.083684]  [<ffffffff814443fa>] hub_events+0x2ea/0x910
[    3.088981]  [<ffffffff816241be>] ? __schedule+0x3de/0x7e0
[    3.094451]  [<ffffffff81444a55>] hub_thread+0x35/0x1e0
[    3.099661]  [<ffffffff81087480>] ? wake_up_bit+0x40/0x40
[    3.105045]  [<ffffffff81444a20>] ? hub_events+0x910/0x910
[    3.110514]  [<ffffffff81086a70>] kthread+0xc0/0xd0
[    3.115378]  [<ffffffff810869b0>] ? kthread_create_on_node+0x120/0x120
[    3.121887]  [<ffffffff8162e86c>] ret_from_fork+0x7c/0xb0
[    3.127271]  [<ffffffff810869b0>] ? kthread_create_on_node+0x120/0x120

-- 
Thanks,
WANG Chao
