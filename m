Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaHEKkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:40:49 -0400
Received: from domine.madduck.net ([77.109.139.90]:47410 "EHLO
	domine.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaHEKkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:40:47 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Aug 2014 06:40:46 EDT
Date: Tue, 5 Aug 2014 12:34:36 +0200
From: martin f krafft <madduck@madduck.net>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: EXT4-fs error, kernel BUG
Message-ID: <20140805103436.GA7531@fishbowl.rw.madduck.net>
Mail-Followup-To: linux kernel mailing list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux jessie/sid kernel 3.14-1-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dear kernel people,

Yesterday, I encountered something weird on one of our NAS machines:

  Aug  4 20:09:40 julia kernel: [342873.007709] EXT4-fs error (device dm-6)=
: ext4_ext_check_inode:481: inode #30414321: comm du: pblk 0 bad header/ext=
ent: invalid extent entries - magic f30a, entries 1, max 4(4), depth 0(0)

but a fsck -f of the filesystem revealed no problems.

So I set up another filesystem and tried to copy over the data from
/dev/dm-6, using tar.

Shortly afterwards, there a wall message like

  BUG: soft lockup - CPU#0 stuck for 23s! [kswapd0:28]

associated with the kernel oops/errors/tracebacks shown below. Then
the machine became unresponsive and had to be cold-reset.

Meanwhile, I've tried to reproduce this problem, doing exactly the
same things as before (using tar to shift the data off the
filesystem on /dev/dm-6, after seeing the aforementioned EXT4-fs
error), but there have been no problems.

My first guess is that there's some sort of memory corruption, which
is weird (the machine is brand new) but not impossible. The reason
I cannot reproduce the problem might be that the system's memory is
not all used yet, shortly after a cold boot.

Is there anything in the following back traces that would help me
identify the source of the problem with greater confidence?

Thanks,

INFO: rcu_sched self-detected stall on CPU { 0}  (t=3D5250 jiffies g=3D9985=
66 c=3D998565 q=3D33366)
sending NMI to all CPUs:
NMI backtrace for cpu 0
CPU: 0 PID: 28 Comm: kswapd0 Not tainted 3.14-0.bpo.1-amd64 #1 Debian 3.14.=
12-1~bpo70+1
Hardware name: HP ProLiant MicroServer, BIOS O41     10/01/2013
task: ffff880225711430 ti: ffff880225712000 task.ti: ffff880225712000
RIP: 0010:[<ffffffff812a3fd9>]  [<ffffffff812a3fd9>] __const_udelay+0x9/0x30
RSP: 0018:ffff88022fc03e10  EFLAGS: 00000046
RAX: 0000000000000000 RBX: 0000000000002710 RCX: 0000000000000008
RDX: 0000000000860d44 RSI: 0000000000000200 RDI: 0000000000418958
RBP: ffffffff8183f300 R08: 000000000000000a R09: 0000000000000000
R10: 000000000000036e R11: 000000000000036d R12: 0000000000000000
R13: ffffffff8183f300 R14: ffffffff818a6a40 R15: ffffffff818a6a40
FS:  00007f904513a700(0000) GS:ffff88022fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffff600400 CR3: 00000001057c1000 CR4: 00000000000007f0
Stack:
ffffffff81048392 ffff88022fc0e800 ffffffff810c32ab ffff88022fc14340
0000000000008256 0000000000014340 0000000000000000 ffff880225711430
ffff880225711430 0000000000000000 0000000000000000 ffff88022fc0e180
Call Trace:
<IRQ>=20
[<ffffffff81048392>] ? arch_trigger_all_cpu_backtrace+0xb2/0xd0
[<ffffffff810c32ab>] ? rcu_check_callbacks+0x41b/0x680
[<ffffffff81072daf>] ? update_process_times+0x3f/0x80
[<ffffffff810cd9fa>] ? tick_sched_handle.isra.11+0x2a/0x70
[<ffffffff810cdb25>] ? tick_sched_timer+0x45/0x70
[<ffffffff8108994b>] ? __run_hrtimer+0x6b/0x210
[<ffffffff8101d295>] ? read_tsc+0x5/0x20
[<ffffffff810cdae0>] ? tick_nohz_handler+0xa0/0xa0
[<ffffffff8108a169>] ? hrtimer_interrupt+0xf9/0x250
[<ffffffff81046696>] ? smp_apic_timer_interrupt+0x36/0x50
[<ffffffff814fbb5d>] ? apic_timer_interrupt+0x6d/0x80
<EOI>=20
[<ffffffff814f2909>] ? _raw_spin_lock+0x9/0x30
[<ffffffff811ae49a>] ? shrink_dentry_list+0x1a/0xd0
[<ffffffff811af66a>] ? prune_dcache_sb+0x4a/0x60
[<ffffffff8119b998>] ? super_cache_scan+0x108/0x170
[<ffffffff8113e406>] ? shrink_slab_node+0x126/0x290
[<ffffffff811923e6>] ? vmpressure+0x56/0xa0
[<ffffffff81140862>] ? shrink_slab+0x82/0x130
[<ffffffff811441e9>] ? balance_pgdat+0x3c9/0x5c0
[<ffffffff810145af>] ? __switch_to+0x12f/0x4e0
[<ffffffff81144547>] ? kswapd+0x167/0x460
[<ffffffff810a67d0>] ? __wake_up_sync+0x10/0x10
[<ffffffff811443e0>] ? balance_pgdat+0x5c0/0x5c0
[<ffffffff81086d6c>] ? kthread+0xbc/0xe0
[<ffffffff81086cb0>] ? flush_kthread_worker+0xa0/0xa0
[<ffffffff814faecc>] ? ret_from_fork+0x7c/0xb0
[<ffffffff81086cb0>] ? flush_kthread_worker+0xa0/0xa0
Code: 00 00 48 ff c8 75 fb 48 ff c8 c3 0f 1f 80 00 00 00 00 48 8b 05 31 78 =
5c 00 ff e0 0f 1f 80 00 00 00 00 65 48 8b 14 25 60 3b 01 00 <48> 8d 0c 12 4=
8 c1 e2 06 48 8d 04 bd 00 00 00 00 48 29 ca f7 e2=20
NMI backtrace for cpu 1
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14-0.bpo.1-amd64 #1 Debian 3.14=
=2E12-1~bpo70+1
Hardware name: HP ProLiant MicroServer, BIOS O41     10/01/2013
task: ffff88022711e9a0 ti: ffff880227122000 task.ti: ffff880227122000
RIP: 0010:[<ffffffff810512d2>]  [<ffffffff810512d2>] native_safe_halt+0x2/0=
x10
RSP: 0018:ffff880227123e90  EFLAGS: 00000292
RAX: 0000000000000000 RBX: ffff880227123ed4 RCX: 0000000000000020
RDX: 0000000000000000 RSI: 0000000000000092 RDI: 0000000000000092
RBP: ffffffff818a6a00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 00000001051d743d R12: 0000000000000001
R13: ffff880227123fd8 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f904513a700(0000) GS:ffff88022fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffff600400 CR3: 00000001057c1000 CR4: 00000000000007e0
Stack:
ffffffff8101e7fd 0000000000014340 ffff880227123ed4 ffffffff818a6a00
ffff880227123fd8 ffff880227123fd8 ffffffff8101e94e ffff880227123fd8
0000000100000000 0000000000000000 ffff880227123fd8 ffffffff818a6a00
Call Trace:
[<ffffffff8101e7fd>] ? default_idle+0x1d/0xf0
[<ffffffff8101e94e>] ? amd_e400_idle+0x7e/0x110
[<ffffffff810b7f23>] ? cpu_startup_entry+0x93/0x270
Code: 2e 0f 1f 84 00 00 00 00 00 fa c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 =
00 00 fb c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 fb f4 <c3> 66 66 66 6=
6 2e 0f 1f 84 00 00 00 00 00 f4 c3 66 66 66 66 66=20
BUG: soft lockup - CPU#0 stuck for 22s! [kswapd0:28]
Modules linked in: nfnetlink_log nfnetlink joydev st sr_mod cdrom parport_p=
c ppdev lp parport ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_rt ip6=
table_filter ip6table_mangle ip6_tables xt_tcpudp ipt_REJECT xt_conntrack i=
ptable_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_n=
at iptable_mangle ip_tables x_tables nf_conntrack_sane nf_conntrack radeon =
kvm_amd ttm drm_kms_helper evdev kvm drm pcspkr acpi_cpufreq i2c_algo_bit e=
dac_mce_amd k10temp sp5100_tco tpm_infineon tpm_tis tpm edac_core i2c_piix4=
 i2c_core shpchp processor button thermal_sys ext4 crc16 mbcache jbd2 dm_mo=
d raid10 md_mod usbhid hid uhci_hcd sg sd_mod crc_t10dif crct10dif_common a=
hci libahci ehci_pci ohci_pci ohci_hcd ehci_hcd tg3 ptp pps_core libphy lib=
ata scsi_mod usbcore usb_common
CPU: 0 PID: 28 Comm: kswapd0 Not tainted 3.14-0.bpo.1-amd64 #1 Debian 3.14.=
12-1~bpo70+1
Hardware name: HP ProLiant MicroServer, BIOS O41     10/01/2013
task: ffff880225711430 ti: ffff880225712000 task.ti: ffff880225712000
RIP: 0010:[<ffffffff811ae4fa>]  [<ffffffff811ae4fa>] shrink_dentry_list+0x7=
a/0xd0
RSP: 0018:ffff880225713b58  EFLAGS: 00000286
RAX: ffff88016ef9d390 RBX: ffff880225713ba8 RCX: ffff880225713ba8
RDX: 0000000000330003 RSI: 0000000000000000 RDI: ffff88016efe4ce0
RBP: ffff88016ef9d390 R08: dead000000100100 R09: dead000000200200
R10: 0000000000000000 R11: 0000000000000002 R12: dead000000100100
R13: dead000000200200 R14: 0000000000000000 R15: 0000000000000002
FS:  00007f904513a700(0000) GS:ffff88022fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffff600400 CR3: 00000001057c1000 CR4: 00000000000007f0
Stack:
cccccccccccccccd ffff88016ef9d410 ffff8802250e9358 ffff880225713ba8
000000000000032b ffff8802250e9000 000000000000bc99 ffffffff811af66a
000000000000021e 0000000000000000 ffff88016ef9d350 ffff88016ef9d1d0
Call Trace:
[<ffffffff811af66a>] ? prune_dcache_sb+0x4a/0x60
[<ffffffff8119b998>] ? super_cache_scan+0x108/0x170
[<ffffffff8113e406>] ? shrink_slab_node+0x126/0x290
[<ffffffff811923e6>] ? vmpressure+0x56/0xa0
[<ffffffff81140862>] ? shrink_slab+0x82/0x130
[<ffffffff811441e9>] ? balance_pgdat+0x3c9/0x5c0
[<ffffffff810145af>] ? __switch_to+0x12f/0x4e0
[<ffffffff81144547>] ? kswapd+0x167/0x460
[<ffffffff810a67d0>] ? __wake_up_sync+0x10/0x10
[<ffffffff811443e0>] ? balance_pgdat+0x5c0/0x5c0
[<ffffffff81086d6c>] ? kthread+0xbc/0xe0
[<ffffffff81086cb0>] ? flush_kthread_worker+0xa0/0xa0
[<ffffffff814faecc>] ? ret_from_fork+0x7c/0xb0
[<ffffffff81086cb0>] ? flush_kthread_worker+0xa0/0xa0
Code: 5d c3 0f 1f 80 00 00 00 00 48 89 ef e8 00 ea ff ff 45 8b 54 24 dc 45 =
85 d2 75 bd 31 f6 48 89 ef e8 2c fd ff ff 48 85 c0 49 89 c4 <74> 2f 48 39 c=
5 75 1c eb 2a 0f 1f 44 00 00 4c 89 e7 be 01 00 00=20
BUG: soft lockup - CPU#0 stuck for 22s! [kswapd0:28]
Modules linked in: nfnetlink_log nfnetlink joydev st sr_mod cdrom parport_p=
c ppdev lp parport ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_rt ip6=
table_filter ip6table_mangle ip6_tables xt_tcpudp ipt_REJECT xt_conntrack i=
ptable_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_n=
at iptable_mangle ip_tables x_tables nf_conntrack_sane nf_conntrack radeon =
kvm_amd ttm drm_kms_helper evdev kvm drm pcspkr acpi_cpufreq i2c_algo_bit e=
dac_mce_amd k10temp sp5100_tco tpm_infineon tpm_tis tpm edac_core i2c_piix4=
 i2c_core shpchp processor button thermal_sys ext4 crc16 mbcache jbd2 dm_mo=
d raid10 md_mod usbhid hid uhci_hcd sg sd_mod crc_t10dif crct10dif_common a=
hci libahci ehci_pci ohci_pci ohci_hcd ehci_hcd tg3 ptp pps_core libphy lib=
ata scsi_mod usbcore usb_common
CPU: 0 PID: 28 Comm: kswapd0 Not tainted 3.14-0.bpo.1-amd64 #1 Debian 3.14.=
12-1~bpo70+1
Hardware name: HP ProLiant MicroServer, BIOS O41     10/01/2013
task: ffff880225711430 ti: ffff880225712000 task.ti: ffff880225712000
RIP: 0010:[<ffffffff811acf1b>]  [<ffffffff811acf1b>] d_shrink_del+0x3b/0x70
RSP: 0018:ffff880225713b48  EFLAGS: 00000202
RAX: ffff88016ef9d350 RBX: 0000000000000000 RCX: ffff880225713ba8
RDX: ffff88016ef9d410 RSI: ffff880225713ba8 RDI: ffff88016ef9d2d0
RBP: ffff88016ef9d2d0 R08: dead000000100100 R09: dead000000200200
R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000000
R13: ffff88016ef9d390 R14: ffff88022fff9d80 R15: ffff88016ef9d390
FS:  00007f904513a700(0000) GS:ffff88022fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffff600400 CR3: 00000001057c1000 CR4: 00000000000007f0
Stack:
ffff880225713ba8 ffffffff811ae4e0 cccccccccccccccd ffff88016ef9d350
ffff8802250e9358 ffff880225713ba8 000000000000032b ffff8802250e9000
000000000000bc99 ffffffff811af66a 000000000000021e 0000000000000000
Call Trace:
[<ffffffff811ae4e0>] ? shrink_dentry_list+0x60/0xd0
[<ffffffff811af66a>] ? prune_dcache_sb+0x4a/0x60
[<ffffffff8119b998>] ? super_cache_scan+0x108/0x170
[<ffffffff8113e406>] ? shrink_slab_node+0x126/0x290
[<ffffffff811923e6>] ? vmpressure+0x56/0xa0
[<ffffffff81140862>] ? shrink_slab+0x82/0x130
[<ffffffff811441e9>] ? balance_pgdat+0x3c9/0x5c0
[<ffffffff810145af>] ? __switch_to+0x12f/0x4e0
[<ffffffff81144547>] ? kswapd+0x167/0x460
[<ffffffff810a67d0>] ? __wake_up_sync+0x10/0x10
[<ffffffff811443e0>] ? balance_pgdat+0x5c0/0x5c0
[<ffffffff81086d6c>] ? kthread+0xbc/0xe0
[<ffffffff81086cb0>] ? flush_kthread_worker+0xa0/0xa0
[<ffffffff814faecc>] ? ret_from_fork+0x7c/0xb0
[<ffffffff81086cb0>] ? flush_kthread_worker+0xa0/0xa0
Code: 75 3b 48 8b 8b 80 00 00 00 48 8b 93 88 00 00 00 48 8d 83 80 00 00 00 =
48 89 51 08 48 89 0a 48 89 83 80 00 00 00 81 23 ff fb f7 ff <48> 89 83 88 0=
0 00 00 65 48 ff 0c 25 68 08 01 00 5b c3 80 3d b5=20
INFO: rcu_sched self-detected stall on CPU { 0}  (t=3D21004 jiffies g=3D998=
566 c=3D998565 q=3D37302)
sending NMI to all CPUs:
NMI backtrace for cpu 0
CPU: 0 PID: 28 Comm: kswapd0 Not tainted 3.14-0.bpo.1-amd64 #1 Debian 3.14.=
12-1~bpo70+1
Hardware name: HP ProLiant MicroServer, BIOS O41     10/01/2013
task: ffff880225711430 ti: ffff880225712000 task.ti: ffff880225712000
RIP: 0010:[<ffffffff812a3fd9>]  [<ffffffff812a3fd9>] __const_udelay+0x9/0x30
RSP: 0018:ffff88022fc03e10  EFLAGS: 00000046
RAX: 0000000000000000 RBX: 0000000000002710 RCX: 0000000000000008
RDX: 0000000000860d44 RSI: 0000000000000200 RDI: 0000000000418958
RBP: ffffffff8183f300 R08: 000000000000000a R09: 0000000000000000
R10: 0000000000000401 R11: 0000000000000400 R12: 0000000000000000
R13: ffffffff8183f300 R14: ffffffff818a6a40 R15: ffffffff818a6a40
FS:  00007f904513a700(0000) GS:ffff88022fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffff600400 CR3: 00000001057c1000 CR4: 00000000000007f0
Stack:
ffffffff81048392 ffff88022fc0e800 ffffffff810c32ab ffff88022fc14340
00000000000091b6 0000000000014340 0000000000000000 ffff880225711430
ffff880225711430 0000000000000000 0000000000000000 ffff88022fc0e180
Call Trace:
<IRQ>=20
[<ffffffff81048392>] ? arch_trigger_all_cpu_backtrace+0xb2/0xd0
[<ffffffff810c32ab>] ? rcu_check_callbacks+0x41b/0x680
[<ffffffff81072daf>] ? update_process_times+0x3f/0x80
[<ffffffff810cd9fa>] ? tick_sched_handle.isra.11+0x2a/0x70
[<ffffffff810cdb25>] ? tick_sched_timer+0x45/0x70
[<ffffffff8108994b>] ? __run_hrtimer+0x6b/0x210
[<ffffffff8101d295>] ? read_tsc+0x5/0x20
[<ffffffff810cdae0>] ? tick_nohz_handler+0xa0/0xa0
[<ffffffff8108a169>] ? hrtimer_interrupt+0xf9/0x250
[<ffffffff81046696>] ? smp_apic_timer_interrupt+0x36/0x50
[<ffffffff814fbb5d>] ? apic_timer_interrupt+0x6d/0x80
<EOI>=20
[<ffffffff811ae501>] ? shrink_dentry_list+0x81/0xd0
[<ffffffff811ae4f4>] ? shrink_dentry_list+0x74/0xd0
[<ffffffff811af66a>] ? prune_dcache_sb+0x4a/0x60
[<ffffffff8119b998>] ? super_cache_scan+0x108/0x170
[<ffffffff8113e406>] ? shrink_slab_node+0x126/0x290
[<ffffffff811923e6>] ? vmpressure+0x56/0xa0
[<ffffffff81140862>] ? shrink_slab+0x82/0x130
[<ffffffff811441e9>] ? balance_pgdat+0x3c9/0x5c0
[<ffffffff810145af>] ? __switch_to+0x12f/0x4e0
[<ffffffff81144547>] ? kswapd+0x167/0x460
[<ffffffff810a67d0>] ? __wake_up_sync+0x10/0x10
[<ffffffff811443e0>] ? balance_pgdat+0x5c0/0x5c0
[<ffffffff81086d6c>] ? kthread+0xbc/0xe0
[<ffffffff81086cb0>] ? flush_kthread_worker+0xa0/0xa0
[<ffffffff814faecc>] ? ret_from_fork+0x7c/0xb0
[<ffffffff81086cb0>] ? flush_kthread_worker+0xa0/0xa0
Code: 00 00 48 ff c8 75 fb 48 ff c8 c3 0f 1f 80 00 00 00 00 48 8b 05 31 78 =
5c 00 ff e0 0f 1f 80 00 00 00 00 65 48 8b 14 25 60 3b 01 00 <48> 8d 0c 12 4=
8 c1 e2 06 48 8d 04 bd 00 00 00 00 48 29 ca f7 e2=20
NMI backtrace for cpu 1
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14-0.bpo.1-amd64 #1 Debian 3.14=
=2E12-1~bpo70+1
Hardware name: HP ProLiant MicroServer, BIOS O41     10/01/2013
task: ffff88022711e9a0 ti: ffff880227122000 task.ti: ffff880227122000
RIP: 0010:[<ffffffff810cbb13>]  [<ffffffff810cbb13>] clockevents_set_mode+0=
x43/0x70
RSP: 0018:ffff88022fc83f38  EFLAGS: 00000046
RAX: 000000000331d4e4 RBX: ffff88022fc8dd40 RCX: 00000000000024c5
RDX: 0000000000000001 RSI: 0000000000000003 RDI: 0000000000000046
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 00000001051db1c7 R12: 0000000000000001
R13: ffff880227123fd8 R14: ffff880227123de8 R15: 0000000000000000
FS:  00007f889f4ae700(0000) GS:ffff88022fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f889f4b7000 CR3: 00000002206fc000 CR4: 00000000000007e0
Stack:
0000000000000092 000000000000ec80 0000000000000030 ffffffff810ce49a
0000000000000000 0000000000000000 0000000000000030 ffffffff81069ee1
0000000000000081 ffffffff810171ec ffff880227123ed4 ffffffff818a6a00
Call Trace:
<IRQ>=20
[<ffffffff810ce49a>] ? tick_irq_enter+0x1a/0xd0
[<ffffffff81069ee1>] ? irq_enter+0x51/0x60
[<ffffffff810171ec>] ? do_IRQ+0x3c/0x110
[<ffffffff814f2e2d>] ? common_interrupt+0x6d/0x6d
<EOI>=20
[<ffffffff810c50de>] ? ktime_get+0x4e/0xe0
[<ffffffff810512d2>] ? native_safe_halt+0x2/0x10
[<ffffffff8101e7fd>] ? default_idle+0x1d/0xf0
[<ffffffff8101e94e>] ? amd_e400_idle+0x7e/0x110
[<ffffffff810b7f23>] ? cpu_startup_entry+0x93/0x270
Code: 48 89 fe 89 ef ff 53 50 83 fd 03 89 6b 38 74 18 48 8b 5c 24 08 48 8b =
6c 24 10 48 83 c4 18 c3 66 0f 1f 84 00 00 00 00 00 8b 43 30 <85> c0 75 e1 c=
7 43 30 01 00 00 00 48 8b 6c 24 10 be 76 00 00 00=20
oot) CMD (if [ -x /etc/munin/plugins/apt_all ]; then /etc/munin/plugins/apt=
_all update 7200 12 >/dev/null; elif [ -x /etc/munin/plugins/apt ]; then /e=
tc/munin/plugins/apt update 7200 12 >/dev/null; fi)
BUG: soft lockup - CPU#0 stuck for 23s! [kswapd0:28]
Modules linked in: nfnetlink_log nfnetlink joydev st sr_mod cdrom parport_p=
c ppdev lp parport ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_rt ip6=
table_filter ip6table_mangle ip6_tables xt_tcpudp ipt_REJECT xt_conntrack i=
ptable_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_n=
at iptable_mangle ip_tables x_tables nf_conntrack_sane nf_conntrack radeon =
kvm_amd ttm drm_kms_helper evdev kvm drm pcspkr acpi_cpufreq i2c_algo_bit e=
dac_mce_amd k10temp sp5100_tco tpm_infineon tpm_tis tpm edac_core i2c_piix4=
 i2c_core shpchp processor button thermal_sys ext4 crc16 mbcache jbd2 dm_mo=
d raid10 md_mod usbhid hid uhci_hcd sg sd_mod crc_t10dif crct10dif_common a=
hci libahci ehci_pci ohci_pci ohci_hcd ehci_hcd tg3 ptp pps_core libphy lib=
ata scsi_mod usbcore usb_common
CPU: 0 PID: 28 Comm: kswapd0 Not tainted 3.14-0.bpo.1-amd64 #1 Debian 3.14.=
12-1~bpo70+1
Hardware name: HP ProLiant MicroServer, BIOS O41     10/01/2013
task: ffff880225711430 ti: ffff880225712000 task.ti: ffff880225712000
RIP: 0010:[<ffffffff814f2909>]  [<ffffffff814f2909>] _raw_spin_lock+0x9/0x30
RSP: 0018:ffff880225713b50  EFLAGS: 00000282
RAX: 00000000c84ac84a RBX: 0000000000000000 RCX: ffff880225713ba8
RDX: ffff88016ef9d350 RSI: ffff880225713ba8 RDI: ffff88016ef9d1a8
RBP: ffff88016ef9d390 R08: dead000000100100 R09: dead000000200200
R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000000
R13: ffff88016ef9d150 R14: 0000000000000000 R15: ffff880225713ba8
FS:  00007f904513a700(0000) GS:ffff88022fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffff600400 CR3: 00000001057c1000 CR4: 00000000000007f0
Stack:
ffffffff811ae49a cccccccccccccccd ffff88016ef9d1d0 ffff8802250e9358
ffff880225713ba8 000000000000032b ffff8802250e9000 000000000000bc99
ffffffff811af66a 000000000000021e 0000000000000000 ffff88016ef9d410
Call Trace:
[<ffffffff811ae49a>] ? shrink_dentry_list+0x1a/0xd0
[<ffffffff811af66a>] ? prune_dcache_sb+0x4a/0x60
[<ffffffff8119b998>] ? super_cache_scan+0x108/0x170
[<ffffffff8113e406>] ? shrink_slab_node+0x126/0x290
[<ffffffff811923e6>] ? vmpressure+0x56/0xa0
[<ffffffff81140862>] ? shrink_slab+0x82/0x130
[<ffffffff811441e9>] ? balance_pgdat+0x3c9/0x5c0
[<ffffffff810145af>] ? __switch_to+0x12f/0x4e0
[<ffffffff81144547>] ? kswapd+0x167/0x460
[<ffffffff810a67d0>] ? __wake_up_sync+0x10/0x10
[<ffffffff811443e0>] ? balance_pgdat+0x5c0/0x5c0
[<ffffffff81086d6c>] ? kthread+0xbc/0xe0
[<ffffffff81086cb0>] ? flush_kthread_worker+0xa0/0xa0
[<ffffffff814faecc>] ? ret_from_fork+0x7c/0xb0
[<ffffffff81086cb0>] ? flush_kthread_worker+0xa0/0xa0
Code: 00 00 9c 58 66 66 90 66 90 48 89 c2 fa 66 66 90 66 66 90 f0 ff 0f 79 =
05 e8 95 2a db ff 48 89 d0 c3 90 b8 00 00 01 00 f0 0f c1 07 <89> c2 c1 ea 1=
0 66 39 c2 75 03 c3 f3 90 0f b7 07 66 39 d0 75 f6

--=20
@martinkrafft | http://madduck.net/ | http://two.sentenc.es/
=20
"lessing was a heretics' heretic"
                                                    -- walter kaufmann
=20
spamtraps: madduck.bogus@madduck.net

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQLvBAEBCgDZBQJT4LM8wBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xM6N
D/9tJ+Wk7mvR7MkGlF4YWNGjiJhVHUDw98+cBpPKC8jt/wUyHEPyyMG+9X7RSfaR
lb2vrfLOi1zVqYmKxDUMI/epIL60ZNEJox1obAWlQINP/tQfdwBKbgTZ7yZsCTOJ
kWUlhv4QHxQydnfPbbLxn8CyOei1otWpHHdKDrM+fiCRPdnHStBOwOcds+2BWlmq
3kginVYpAPs2gVQVadnN3uA2RrWJCLWd0A5vcnjfKCi9BsNXwOnfuqou23K0CIFs
L7uDIEYiwnmjX6z08GKINSdCS7lJUsOM32DdeuRonFxMpxWobZ10zk57K7hmVdpD
hv1xh6pmOswk2de3wJ4SpfOw8oRVrJkG72Vi2GY20McaIWGY8ajied9e1aiIVvbM
pktB56qNJ30xW+0XTdvNAdCHDv9da1E+ZfD8PkzauMSzqfzUl1gP9pw/KyhJKBy5
ZqW/n240baAf4OM55UgQ3eW5Y64jCDAKC57bab3aGZnQLYX/HVsXsQRKdDkLHNjO
fVT+zx9+D/H+4A/68Mz1VUcdq3VUIscxZFQiHpSzSKvZBpSZGll2XvBisXMqbbwU
6XZswpkNU3vjQB8jqhgasDFg1PUxUtHAnkhm9KLZRyIeugv4FFHRbHs9iWNQTj2e
LkUTrRMde0aemk7otL2k4IH89fOzNmLbyHPgKdjMs65H1A==
=iB6r
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--

