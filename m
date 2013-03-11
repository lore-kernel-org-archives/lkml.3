Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab3CKT2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:28:36 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:45399 "EHLO mail.ku-gbr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab3CKT2d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:28:33 -0400
X-Greylist: delayed 681 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Mar 2013 15:28:33 EDT
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: BUG: when I/O happens on separate /var (ext4), __do_lookup_rcu always involved
Date: Mon, 11 Mar 2013 20:17:08 +0100
Message-ID: <7x8v5thhl7.fsf@dell-01.ku-gbr.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a problem with a new consumer CPU/RAM/Motherboard combination
bought in early 2013. I realized that the kernel bails out after a
couple of days uptime with a null pointer derference and CPUx stuck
after xx seconds. 

The machine is a home server doing some mail and news with a 45GB /var
partition on a debian 7.0 formatted with ext4 (debian installation
"news" option chosen).

With the linux-image 3.2.0 package it looked like this:

Feb  4 08:03:27 zappa kernel: [    0.000000] Linux version 3.2.0-4-amd64 (debian-kernel@lists.debian.org) (gcc version 4.6.3 (Debian 4.6.3-14) ) #1 SMP Debian 3.2.35-2

...

Feb  5 02:19:09 zappa kernel: [65572.119986] BUG: unable to handle kernel paging request at 0000000400000018
Feb  5 02:19:09 zappa kernel: [65572.120050] IP: [<ffffffff8110aaa0>] __d_lookup_rcu+0xde/0xfe
Feb  5 02:19:09 zappa kernel: [65572.120100] PGD 0 
Feb  5 02:19:09 zappa kernel: [65572.120119] Oops: 0000 [#1] SMP 
Feb  5 02:19:09 zappa kernel: [65572.120149] CPU 0 
Feb  5 02:19:09 zappa kernel: [65572.120165] Modules linked in: ppdev lp tun cpufreq_stats cpufreq_userspace cpufreq_
conservative cpufreq_powersave ip6table_filter ip6_tables xt_multiport iptable_filter ipt_MASQUERADE iptable_nat nf_n
at nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc xt_TCPMSS xt_tcpms
s xt_tcpudp iptable_mangle ip_tables x_tables pppoe pppox ppp_generic slhc bridge stp ext2 loop snd_hda_codec_hdmi sn
d_hda_codec_via i915 drm_kms_helper drm snd_hda_intel snd_hda_codec eeepc_wmi i2c_algo_bit i2c_i801 snd_hwdep snd_pcs
p i2c_core asus_wmi snd_pcm acpi_cpufreq coretemp crc32c_intel ghash_clmulni_intel sparse_keymap iTCO_wdt parport_pc 
snd_page_alloc iTCO_vendor_support psmouse mperf rfkill cryptd video evdev snd_timer parport serio_raw snd processor 
button wmi soundcore ext4 crc16 jbd2 mbcache dm_mod sg sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod r8169 
mii xhci_hcd thermal usbcore fan thermal_sys usb_common [last unloaded: scsi_wait_scan]
Feb  5 02:19:09 zappa kernel: [65572.121019] 
Feb  5 02:19:09 zappa kernel: [65572.121034] Pid: 28590, comm: exim4 Not tainted 3.2.0-4-amd64 #1 Debian 3.2.35-2 Sys
tem manufacturer System Product Name/P8B75-M LE
Feb  5 02:19:09 zappa kernel: [65572.121126] RIP: 0010:[<ffffffff8110aaa0>]  [<ffffffff8110aaa0>] __d_lookup_rcu+0xde
/0xfe
Feb  5 02:19:09 zappa kernel: [65572.121190] RSP: 0018:ffff8801c34a3c98  EFLAGS: 00010206
Feb  5 02:19:09 zappa kernel: [65572.121230] RAX: ffffc900003a8998 RBX: 0000000400000000 RCX: ffffc90000002000
Feb  5 02:19:09 zappa kernel: [65572.121282] RDX: ffff8801c34a3d34 RSI: 00000000f56e8466 RDI: 018721e0ecf6bc03
Feb  5 02:19:09 zappa kernel: [65572.121334] RBP: ffff88021df1e740 R08: 0000000000000001 R09: ffff8801c34a3d68
Feb  5 02:19:09 zappa kernel: [65572.121386] R10: ffff8802132d14c0 R11: ffff8802132d14c0 R12: ffff8801c34a3e78
Feb  5 02:19:09 zappa kernel: [65572.121439] R13: ffff8801c34a3d28 R14: 0000000000000012 R15: 00000000f56e8466
Feb  5 02:19:09 zappa kernel: [65572.121492] FS:  00007f971e9a1700(0000) GS:ffff88021ea00000(0000) knlGS:000000000000
0000
Feb  5 02:19:09 zappa kernel: [65572.121551] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Feb  5 02:19:09 zappa kernel: [65572.121593] CR2: 0000000400000018 CR3: 00000002146b3000 CR4: 00000000001406f0
Feb  5 02:19:09 zappa kernel: [65572.121645] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb  5 02:19:09 zappa kernel: [65572.121698] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  5 02:19:09 zappa kernel: [65572.121750] Process exim4 (pid: 28590, threadinfo ffff8801c34a2000, task ffff8802139989f0)
Feb  5 02:19:09 zappa kernel: [65572.121809] Stack:
Feb  5 02:19:09 zappa kernel: [65572.121826]  0000000000000000 ffff8801c34a3e68 ffff8801c34a3d68 ffff880213b79018
Feb  5 02:19:09 zappa kernel: [65572.121888]  ffff8801c34a3d34 0000000000000012 ffff8801c34a3d68 ffff8801c34a3e68
Feb  5 02:19:09 zappa kernel: [65572.121951]  ffff8801c34a3e00 ffff8801c34a3e78 ffff88021df1e740 ffff8802161c46c0
Feb  5 02:19:09 zappa kernel: [65572.122013] Call Trace:
Feb  5 02:19:09 zappa kernel: [65572.122036]  [<ffffffff81102574>] ? walk_component+0x88/0x406
Feb  5 02:19:09 zappa kernel: [65572.122081]  [<ffffffff8110453a>] ? do_last+0x108/0x58d
Feb  5 02:19:09 zappa kernel: [65572.122121]  [<ffffffff81104fb7>] ? path_openat+0xce/0x33a
Feb  5 02:19:09 zappa kernel: [65572.122164]  [<ffffffff810ce6a8>] ? tlb_flush_mmu+0x37/0x50
Feb  5 02:19:09 zappa kernel: [65572.122207]  [<ffffffff811052e5>] ? do_filp_open+0x2a/0x6e
Feb  5 02:19:09 zappa kernel: [65572.122252]  [<ffffffff8134bd27>] ? _cond_resched+0x7/0x1c
Feb  5 02:19:09 zappa kernel: [65572.122295]  [<ffffffff811b3479>] ? __strncpy_from_user+0x18/0x48
Feb  5 02:19:09 zappa kernel: [65572.122342]  [<ffffffff8110e03b>] ? alloc_fd+0x64/0x109
Feb  5 02:19:09 zappa kernel: [65572.122383]  [<ffffffff810f92da>] ? do_sys_open+0x5e/0xe5
Feb  5 02:19:09 zappa kernel: [65572.122426]  [<ffffffff81352012>] ? system_call_fastpath+0x16/0x1b
Feb  5 02:19:09 zappa kernel: [65572.122471] Code: 44 24 28 75 1e 31 c0 48 8b 54 24 18 8a 14 02 41 38 14 01 75 0e 48 ff c0 49 39 c0 75 ea 4d 89 55 00 eb 16 48 8b 1b 48 85 db 74 0b <44> 39 7b 18 75 f2 e9 5c ff ff ff 45 31 f6 48 83 c4 38 4c 89 f0 
Feb  5 02:19:09 zappa kernel: [65572.126775] RIP  [<ffffffff8110aaa0>] __d_lookup_rcu+0xde/0xfe
Feb  5 02:19:09 zappa kernel: [65572.128903]  RSP <ffff8801c34a3c98>
Feb  5 02:19:09 zappa kernel: [65572.130988] CR2: 0000000400000018
Feb  5 02:19:09 zappa kernel: [65572.140308] ---[ end trace cb29f316b5bda580 ]---
Feb  5 02:19:33 zappa kernel: [65596.282707] BUG: soft lockup - CPU#0 stuck for 22s! [exim4:28590]
Feb  5 02:19:33 zappa kernel: [65596.284809] Modules linked in: ppdev lp tun cpufreq_stats cpufreq_userspace cpufreq_conservative cpufreq_powersave ip6table_filter ip6_tables xt_multiport iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc xt_TCPMSS xt_tcpmss xt_tcpudp iptable_mangle ip_tables x_tables pppoe pppox ppp_generic slhc bridge stp ext2 loop snd_hda_codec_hdmi snd_hda_codec_via i915 drm_kms_helper drm snd_hda_intel snd_hda_codec eeepc_wmi i2c_algo_bit i2c_i801 snd_hwdep snd_pcsp i2c_core asus_wmi snd_pcm acpi_cpufreq coretemp crc32c_intel ghash_clmulni_intel sparse_keymap iTCO_wdt parport_pc snd_page_alloc iTCO_vendor_support psmouse mperf rfkill cryptd video evdev snd_timer parport serio_raw snd processor button wmi soundcore ext4 crc16 jbd2 mbcache dm_mod sg sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod r8169 mii xhci_hcd thermal usbcore fan thermal_sys usb_common [last unloaded: scsi_wait_scan]
Feb  5 02:19:33 zappa kernel: [65596.302693] CPU 0 
Feb  5 02:19:33 zappa kernel: [65596.302710] Modules linked in: ppdev lp tun cpufreq_stats cpufreq_userspace cpufreq_conservative cpufreq_powersave ip6table_filter ip6_tables xt_multiport iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc xt_TCPMSS xt_tcpmss xt_tcpudp iptable_mangle ip_tables x_tables pppoe pppox ppp_generic slhc bridge stp ext2 loop snd_hda_codec_hdmi snd_hda_codec_via i915 drm_kms_helper drm snd_hda_intel snd_hda_codec eeepc_wmi i2c_algo_bit i2c_i801 snd_hwdep snd_pcsp i2c_core asus_wmi snd_pcm acpi_cpufreq coretemp crc32c_intel ghash_clmulni_intel sparse_keymap iTCO_wdt parport_pc snd_page_alloc iTCO_vendor_support psmouse mperf rfkill cryptd video evdev snd_timer parport serio_raw snd processor button wmi soundcore ext4 crc16 jbd2 mbcache dm_mod sg sd_mod crc_t10dif ehci_hcd ahci libahci libata scsi_mod r8169 mii xhci_hcd thermal usbcore fan thermal_sys usb_common [last unloaded: scsi_wait_scan]
Feb  5 02:19:33 zappa kernel: [65596.323083] 
Feb  5 02:19:33 zappa kernel: [65596.325402] Pid: 28590, comm: exim4 Tainted: G      D      3.2.0-4-amd64 #1 Debian 3.2.35-2 System manufacturer System Product Name/P8B75-M LE
Feb  5 02:19:33 zappa kernel: [65596.330200] RIP: 0010:[<ffffffff8110e5c6>]  [<ffffffff8110e5c6>] vfsmount_lock_local_lock+0x28/0x2b
Feb  5 02:19:33 zappa kernel: [65596.332648] RSP: 0018:ffff8801c34a38c0  EFLAGS: 00000297
Feb  5 02:19:33 zappa kernel: [65596.335084] RAX: ffff88021ea10a40 RBX: 0000000000000000 RCX: 000000000000fc2a
Feb  5 02:19:33 zappa kernel: [65596.337538] RDX: 00000000fc2afc29 RSI: 0000000000000000 RDI: ffff880213085b80
Feb  5 02:19:33 zappa kernel: [65596.340005] RBP: ffff8802136d4348 R08: 0000000000000000 R09: 0000000000000000
Feb  5 02:19:33 zappa kernel: [65596.342445] R10: ffff8801c34a3908 R11: ffff88021522eb80 R12: ffffea0006b7f728
Feb  5 02:19:33 zappa kernel: [65596.344875] R13: ffffea0007407220 R14: ffffea0006b7bbe0 R15: 0000000100000010
Feb  5 02:19:33 zappa kernel: [65596.347296] FS:  0000000000000000(0000) GS:ffff88021ea00000(0000) knlGS:0000000000000000
Feb  5 02:19:33 zappa kernel: [65596.349735] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb  5 02:19:33 zappa kernel: [65596.352179] CR2: 0000000400000018 CR3: 0000000001605000 CR4: 00000000001406f0
Feb  5 02:19:33 zappa kernel: [65596.354629] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb  5 02:19:33 zappa kernel: [65596.357064] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  5 02:19:33 zappa kernel: [65596.359498] Process exim4 (pid: 28590, threadinfo ffff8801c34a2000, task ffff8802139989f0)
Feb  5 02:19:33 zappa kernel: [65596.361966] Stack:
Feb  5 02:19:33 zappa kernel: [65596.364420]  ffffffff8110f938 0000000000000003 ffff880212e43ce8 ffff8802136d4348
Feb  5 02:19:33 zappa kernel: [65596.366951]  ffffffff810d3b68 ffff88021462b440 ffff8802136d4348 ffff88021462b440
Feb  5 02:19:33 zappa kernel: [65596.369482]  ffffffff810d4f68 ffff88021462b440 000000018106ec6c ffff8801c34a3920
Feb  5 02:19:33 zappa kernel: [65596.372016] Call Trace:
Feb  5 02:19:33 zappa kernel: [65596.374521]  [<ffffffff8110f938>] ? mntput_no_expire+0xb/0xc9
Feb  5 02:19:33 zappa kernel: [65596.377058]  [<ffffffff810d3b68>] ? remove_vma+0x3a/0x6b
Feb  5 02:19:33 zappa kernel: [65596.379597]  [<ffffffff810d4f68>] ? exit_mmap+0xc4/0xe1
Feb  5 02:19:33 zappa kernel: [65596.382070]  [<ffffffff810448aa>] ? mmput+0x56/0xf8
Feb  5 02:19:33 zappa kernel: [65596.384477]  [<ffffffff81049a74>] ? exit_mm+0x117/0x122
Feb  5 02:19:33 zappa kernel: [65596.386852]  [<ffffffff8134d062>] ? _raw_spin_lock_irq+0xa/0x14
Feb  5 02:19:33 zappa kernel: [65596.389220]  [<ffffffff81049cc4>] ? do_exit+0x245/0x713
Feb  5 02:19:33 zappa kernel: [65596.391590]  [<ffffffff8134d03c>] ? _raw_spin_lock_irqsave+0x9/0x25
Feb  5 02:19:33 zappa kernel: [65596.393963]  [<ffffffff81048025>] ? kmsg_dump+0x40/0xcb
Feb  5 02:19:33 zappa kernel: [65596.396328]  [<ffffffff8134de8e>] ? oops_end+0xb1/0xb6
Feb  5 02:19:33 zappa kernel: [65596.398636]  [<ffffffff81346108>] ? no_context+0x1ff/0x20e
Feb  5 02:19:33 zappa kernel: [65596.400898]  [<ffffffffa0082e13>] ? __jbd2_journal_file_buffer+0xc0/0x158 [jbd2]
Feb  5 02:19:33 zappa kernel: [65596.403136]  [<ffffffff8134fefb>] ? do_page_fault+0x210/0x337
Feb  5 02:19:33 zappa kernel: [65596.405316]  [<ffffffff810ca635>] ? zone_statistics+0x41/0x74
Feb  5 02:19:33 zappa kernel: [65596.407453]  [<ffffffff810ba954>] ? get_page_from_freelist+0x57a/0x665
Feb  5 02:19:33 zappa kernel: [65596.409540]  [<ffffffff8134d5f5>] ? page_fault+0x25/0x30
Feb  5 02:19:33 zappa kernel: [65596.411580]  [<ffffffff8110aaa0>] ? __d_lookup_rcu+0xde/0xfe
Feb  5 02:19:33 zappa kernel: [65596.413566]  [<ffffffff8110a9f6>] ? __d_lookup_rcu+0x34/0xfe
Feb  5 02:19:33 zappa kernel: [65596.415511]  [<ffffffff81102574>] ? walk_component+0x88/0x406
Feb  5 02:19:33 zappa kernel: [65596.417407]  [<ffffffff8110453a>] ? do_last+0x108/0x58d
Feb  5 02:19:33 zappa kernel: [65596.419257]  [<ffffffff81104fb7>] ? path_openat+0xce/0x33a
Feb  5 02:19:33 zappa kernel: [65596.421045]  [<ffffffff810ce6a8>] ? tlb_flush_mmu+0x37/0x50
Feb  5 02:19:33 zappa kernel: [65596.422785]  [<ffffffff811052e5>] ? do_filp_open+0x2a/0x6e
Feb  5 02:19:33 zappa kernel: [65596.424468]  [<ffffffff8134bd27>] ? _cond_resched+0x7/0x1c
Feb  5 02:19:33 zappa kernel: [65596.426098]  [<ffffffff811b3479>] ? __strncpy_from_user+0x18/0x48
Feb  5 02:19:33 zappa kernel: [65596.427686]  [<ffffffff8110e03b>] ? alloc_fd+0x64/0x109
Feb  5 02:19:33 zappa kernel: [65596.429216]  [<ffffffff810f92da>] ? do_sys_open+0x5e/0xe5
Feb  5 02:19:33 zappa kernel: [65596.430718]  [<ffffffff81352012>] ? system_call_fastpath+0x16/0x1b
Feb  5 02:19:33 zappa kernel: [65596.432179] Code: ff 07 c3 48 c7 c0 40 0a 01 00 65 48 03 04 25 00 dc 00 00 ba 00 00 01 00 f0 0f c1 10 89 d1 c1 e9 10 66 39 ca 74 07 f3 90 66 8b 10 <eb> f4 c3 48 c7 c0 40 0a 01 00 65 48 03 04 25 00 dc 00 00 66 ff 
Feb  5 02:19:33 zappa kernel: [65596.435434] Call Trace:
Feb  5 02:19:33 zappa kernel: [65596.436909]  [<ffffffff8110f938>] ? mntput_no_expire+0xb/0xc9
Feb  5 02:19:33 zappa kernel: [65596.438409]  [<ffffffff810d3b68>] ? remove_vma+0x3a/0x6b
Feb  5 02:19:33 zappa kernel: [65596.439895]  [<ffffffff810d4f68>] ? exit_mmap+0xc4/0xe1
Feb  5 02:19:33 zappa kernel: [65596.441370]  [<ffffffff810448aa>] ? mmput+0x56/0xf8
Feb  5 02:19:33 zappa kernel: [65596.442835]  [<ffffffff81049a74>] ? exit_mm+0x117/0x122
Feb  5 02:19:33 zappa kernel: [65596.444285]  [<ffffffff8134d062>] ? _raw_spin_lock_irq+0xa/0x14
Feb  5 02:19:33 zappa kernel: [65596.445717]  [<ffffffff81049cc4>] ? do_exit+0x245/0x713
Feb  5 02:19:33 zappa kernel: [65596.447130]  [<ffffffff8134d03c>] ? _raw_spin_lock_irqsave+0x9/0x25
Feb  5 02:19:33 zappa kernel: [65596.448534]  [<ffffffff81048025>] ? kmsg_dump+0x40/0xcb
Feb  5 02:19:33 zappa kernel: [65596.449937]  [<ffffffff8134de8e>] ? oops_end+0xb1/0xb6
Feb  5 02:19:33 zappa kernel: [65596.451349]  [<ffffffff81346108>] ? no_context+0x1ff/0x20e
Feb  5 02:19:33 zappa kernel: [65596.452736]  [<ffffffffa0082e13>] ? __jbd2_journal_file_buffer+0xc0/0x158 [jbd2]
Feb  5 02:19:33 zappa kernel: [65596.454119]  [<ffffffff8134fefb>] ? do_page_fault+0x210/0x337
Feb  5 02:19:33 zappa kernel: [65596.455490]  [<ffffffff810ca635>] ? zone_statistics+0x41/0x74
Feb  5 02:19:33 zappa kernel: [65596.456847]  [<ffffffff810ba954>] ? get_page_from_freelist+0x57a/0x665
Feb  5 02:19:33 zappa kernel: [65596.458224]  [<ffffffff8134d5f5>] ? page_fault+0x25/0x30
Feb  5 02:19:33 zappa kernel: [65596.459573]  [<ffffffff8110aaa0>] ? __d_lookup_rcu+0xde/0xfe
Feb  5 02:19:33 zappa kernel: [65596.460914]  [<ffffffff8110a9f6>] ? __d_lookup_rcu+0x34/0xfe
Feb  5 02:19:33 zappa kernel: [65596.462246]  [<ffffffff81102574>] ? walk_component+0x88/0x406
Feb  5 02:19:33 zappa kernel: [65596.463572]  [<ffffffff8110453a>] ? do_last+0x108/0x58d
Feb  5 02:19:33 zappa kernel: [65596.464899]  [<ffffffff81104fb7>] ? path_openat+0xce/0x33a
Feb  5 02:19:33 zappa kernel: [65596.466237]  [<ffffffff810ce6a8>] ? tlb_flush_mmu+0x37/0x50
Feb  5 02:19:33 zappa kernel: [65596.467566]  [<ffffffff811052e5>] ? do_filp_open+0x2a/0x6e
Feb  5 02:19:33 zappa kernel: [65596.468888]  [<ffffffff8134bd27>] ? _cond_resched+0x7/0x1c
Feb  5 02:19:33 zappa kernel: [65596.470212]  [<ffffffff811b3479>] ? __strncpy_from_user+0x18/0x48
Feb  5 02:19:33 zappa kernel: [65596.471533]  [<ffffffff8110e03b>] ? alloc_fd+0x64/0x109
Feb  5 02:19:33 zappa kernel: [65596.472850]  [<ffffffff810f92da>] ? do_sys_open+0x5e/0xe5
Feb  5 02:19:33 zappa kernel: [65596.474177]  [<ffffffff81352012>] ? system_call_fastpath+0x16/0x1b
Feb  5 02:20:01 zappa kernel: [65624.192559] BUG: soft lockup - CPU#0 stuck for 22s! [exim4:28590]

This got repeated until 

Feb  5 02:24:05 zappa kernel: [65867.447731] RSP: 0018:ffff8801c34a38c0  EFLAGS: 00000297
Feb  5 02:24:05 zappa kernel: [65867.449915] RAX: ffff88021ea10a40 RBX: 0000000000000000 RCX: 000000000000fc2a
Feb  5 02:24:05 zappa kernel: [65867.452140] RDX: 00000000fc2afc29 RSI: 00000000000Feb  5 08:16:53 zappa kernel: imklog 5.8.11, log source = /proc/kmsg started.

I found up the machine locked up in the morning and pressed the reset
button. Since now I am entirely not sure if the hardware is not to
blame. Meanwhile I changed the kernel and what makes me suspicious the
hardware is not to blame is that I can trigger the bug by simply
starting the texpire process (news server leafnode cleanup/management
program deleting expired news, operating on thousands of small news
article files with 50% of these being symlinks. I updated the kernel to
the debian linux-rt branch to narrow this down in any matter. Now the
oops starts always the same way in a predictible manner:

Mar 11 15:04:24 zappa kernel: [    0.000000] Linux version 3.7-trunk-amd64 (debian-kernel@lists.debian.org) (gcc version 4.7.2 (Debian 4.7.2-5) ) #1 SMP Debian 3.7.3-1~experimental.1  

...

Mar 11 15:08:20 zappa kernel: [  278.819954] BUG: unable to handle kernel paging request at 00000003fffffffc
Mar 11 15:08:20 zappa kernel: [  278.820024] IP: [<ffffffff81118be6>] __d_lookup_rcu+0x42/0xc0
Mar 11 15:08:20 zappa kernel: [  278.820078] PGD 0 
Mar 11 15:08:20 zappa kernel: [  278.820101] Oops: 0000 [#1] SMP 
Mar 11 15:08:20 zappa kernel: [  278.820137] Modules linked in: ppdev lp tun cpufreq_stats cpufreq_userspace cpufreq_conservative cpufreq_powersave ip6table_filter ip6_tables xt_multiport iptable_filter ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack nfsd auth_rpcgss nfs_acl nfs lockd dns_resolver fscache sunrpc xt_TCPMSS xt_tcpmss xt_tcpudp iptable_mangle ip_tables x_tables pppoe pppox ppp_generic slhc bridge stp llc ext2 loop snd_hda_codec_hdmi snd_hda_codec_via snd_hda_intel snd_hda_codec parport_pc parport snd_hwdep coretemp kvm_intel kvm i915 snd_pcsp snd_pcm snd_page_alloc acpi_cpufreq drm_kms_helper drm i2c_algo_bit i2c_i801 iTCO_wdt iTCO_vendor_support lpc_ich i2c_core mfd_core mei eeepc_wmi asus_wmi snd_timer mperf evdev sparse_keymap usb_storage snd rfkill crc32c_intel soundcore ghash_clmulni_intel cryptd wmi processor psmouse serio_raw video button ext4 crc16 jbd2 mbcache dm_mod sg sd_mod crc_t10dif ehci_hcd fan thermal thermal_sys ahci libahci libata xhci_
Mar 11 15:08:20 zappa kernel: hcd scsi_mod microcode r8169 mii usbcore usb_common
Mar 11 15:08:20 zappa kernel: [  278.821193] CPU 1 
Mar 11 15:08:20 zappa kernel: [  278.821213] Pid: 4846, comm: texpire Not tainted 3.7-trunk-amd64 #1 Debian 3.7.3-1~experimental.1 System manufacturer System Product Name/P8B75-M LE
Mar 11 15:08:20 zappa kernel: [  278.821316] RIP: 0010:[<ffffffff81118be6>]  [<ffffffff81118be6>] __d_lookup_rcu+0x42/0xc0
Mar 11 15:08:20 zappa kernel: [  278.821383] RSP: 0018:ffff880215799c28  EFLAGS: 00010206
Mar 11 15:08:20 zappa kernel: [  278.821425] RAX: 0000000000000036 RBX: 000000368572f559 RCX: 0000000000000014
Mar 11 15:08:20 zappa kernel: [  278.821478] RDX: ffff880215799ca4 RSI: 000000008572f559 RDI: 0000000000074d33
Mar 11 15:08:20 zappa kernel: [  278.821532] RBP: ffff8801ed13c200 R08: 0000000000000001 R09: 0000000000000fb0
Mar 11 15:08:20 zappa kernel: [  278.821585] R10: c9d82c5b8572f559 R11: f7ffc192909cd18c R12: 00000003fffffff8
Mar 11 15:08:20 zappa kernel: [  278.821639] R13: ffff880215799e18 R14: ffff880215799ca4 R15: 0000000400000000
Mar 11 15:08:20 zappa kernel: [  278.821693] FS:  00002b9ca590ae00(0000) GS:ffff88021ea80000(0000) knlGS:0000000000000000
Mar 11 15:08:20 zappa kernel: [  278.821754] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar 11 15:08:20 zappa kernel: [  278.821798] CR2: 00000003fffffffc CR3: 0000000215023000 CR4: 00000000001407e0
Mar 11 15:08:20 zappa kernel: [  278.821851] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 11 15:08:20 zappa kernel: [  278.821905] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 11 15:08:20 zappa kernel: [  278.821959] Process texpire (pid: 4846, threadinfo ffff880215798000, task ffff8802122c78c0)
Mar 11 15:08:20 zappa kernel: [  278.822020] Stack:
Mar 11 15:08:20 zappa kernel: [  278.822038]  ffff880000000036 0000000001c89d66 ffff8800b8239020 ffff8801ed13f598
Mar 11 15:08:20 zappa kernel: [  278.822109]  ffff8801ed13c200 ffff880215799e08 ffff880215799d58 ffff880215799d58
Mar 11 15:08:20 zappa kernel: [  278.822179]  ffff8801ed13c200 ffff880215799d00 ffff8802161b15e0 ffffffff811102c4
Mar 11 15:08:20 zappa kernel: [  278.822249] Call Trace:
Mar 11 15:08:20 zappa kernel: [  278.822273]  [<ffffffff811102c4>] ? lookup_fast+0x39/0x233
Mar 11 15:08:20 zappa kernel: [  278.822317]  [<ffffffff81110c61>] ? link_path_walk+0xba/0x482
Mar 11 15:08:20 zappa kernel: [  278.822363]  [<ffffffff811104f6>] ? walk_component+0x38/0x1aa
Mar 11 15:08:20 zappa kernel: [  278.822408]  [<ffffffff81111401>] ? path_lookupat+0x8b/0x2b1
Mar 11 15:08:20 zappa kernel: [  278.822454]  [<ffffffff81111648>] ? filename_lookup+0x21/0x79
Mar 11 15:08:20 zappa kernel: [  278.822499]  [<ffffffff81110a33>] ? getname_flags.part.23+0xb8/0x10a
Mar 11 15:08:20 zappa kernel: [  278.822549]  [<ffffffff8111355d>] ? user_path_at_empty+0x6f/0xa8
Mar 11 15:08:20 zappa kernel: [  278.822599]  [<ffffffff813778f2>] ? _cond_resched+0x6/0x1b
Mar 11 15:08:20 zappa kernel: [  278.822644]  [<ffffffff8110bc9c>] ? cp_new_stat+0x11d/0x130
Mar 11 15:08:20 zappa kernel: [  278.822689]  [<ffffffff8110ba31>] ? vfs_fstatat+0x2d/0x63
Mar 11 15:08:20 zappa kernel: [  278.822732]  [<ffffffff8110bd46>] ? sys_newstat+0x12/0x2d
Mar 11 15:08:20 zappa kernel: [  278.824689]  [<ffffffff8137d6e9>] ? system_call_fastpath+0x16/0x1b
Mar 11 15:08:20 zappa kernel: [  278.826655] Code: 48 8b 1e 48 8b 46 08 48 89 4c 24 18 89 de 48 89 44 24 10 e8 ad e0 ff ff 4c 8b 38 48 89 d8 48 c1 e8 20 89 04 24 49 83 e7 fe eb 5e <41> 8b 4f fc 49 39 6f 10 75 51 49 83 7f 08 00 74 4a 83 e1 fe 41 
Mar 11 15:08:20 zappa kernel: [  278.831012] RIP  [<ffffffff81118be6>] __d_lookup_rcu+0x42/0xc0
Mar 11 15:08:20 zappa kernel: [  278.833072]  RSP <ffff880215799c28>
Mar 11 15:08:20 zappa kernel: [  278.835108] CR2: 00000003fffffffc
Mar 11 15:08:20 zappa kernel: [  278.837160] ---[ end trace 227c343fa475cc7e ]---
Mar 11 15:08:45 zappa kernel: [  304.166843] BUG: soft lockup - CPU#1 stuck for 23s! [texpire:4846]
Mar 11 15:08:45 zappa kernel: [  304.167837] Modules linked in: ppdev lp tun cpufreq_stats cpufreq_userspace cpufreq_conservative cpufreq_powersave ip6table_filter ip6_tables xt_multiport iptable_filter ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack nfsd auth_rpcgss nfs_acl nfs lockd dns_resolver fscache sunrpc xt_TCPMSS xt_tcpmss xt_tcpudp iptable_mangle ip_tables x_tables pppoe pppox ppp_generic slhc bridge stp llc ext2 loop snd_hda_codec_hdmi snd_hda_codec_via snd_hda_intel snd_hda_codec parport_pc parport snd_hwdep coretemp kvm_intel kvm i915 snd_pcsp snd_pcm snd_page_alloc acpi_cpufreq drm_kms_helper drm i2c_algo_bit i2c_i801 iTCO_wdt iTCO_vendor_support lpc_ich i2c_core mfd_core mei eeepc_wmi asus_wmi snd_timer mperf evdev sparse_keymap usb_storage snd rfkill crc32c_intel soundcore ghash_clmulni_intel cryptd wmi processor psmouse serio_raw video button ext4 crc16 jbd2 mbcache dm_mod sg sd_mod crc_t10dif ehci_hcd fan thermal thermal_sys ahci libahci libata xhci_
Mar 11 15:08:45 zappa kernel: hcd scsi_mod microcode r8169 mii usbcore usb_common
Mar 11 15:08:45 zappa kernel: [  304.177088] CPU 1 
Mar 11 15:08:45 zappa kernel: [  304.177098] Pid: 4846, comm: texpire Tainted: G      D      3.7-trunk-amd64 #1 Debian 3.7.3-1~experimental.1 System manufacturer System Product Name/P8B75-M LE
Mar 11 15:08:45 zappa kernel: [  304.180071] RIP: 0010:[<ffffffff8105d248>]  [<ffffffff8105d248>] lg_local_lock+0x24/0x27
Mar 11 15:08:45 zappa kernel: [  304.181096] RSP: 0018:ffff880215799950  EFLAGS: 00000297
Mar 11 15:08:45 zappa kernel: [  304.182118] RAX: ffff88021ea90a50 RBX: ffffffff811367ac RCX: 0000000000002afb
Mar 11 15:08:45 zappa kernel: [  304.183164] RDX: 000000002afb2afa RSI: ffff88021323ef40 RDI: ffffffff81635c10
Mar 11 15:08:45 zappa kernel: [  304.184203] RBP: ffff880213072be0 R08: 0000000000000030 R09: 0000000000000030
Mar 11 15:08:45 zappa kernel: [  304.185244] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801ed13f620
Mar 11 15:08:45 zappa kernel: [  304.186279] R13: 0000000000000030 R14: ffffffff8113673e R15: ffff8802157998b0
Mar 11 15:08:45 zappa kernel: [  304.187306] FS:  00002b9ca590ae00(0000) GS:ffff88021ea80000(0000) knlGS:0000000000000000
Mar 11 15:08:45 zappa kernel: [  304.188338] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar 11 15:08:45 zappa kernel: [  304.189372] CR2: 00000003fffffffc CR3: 000000000160b000 CR4: 00000000001407e0
Mar 11 15:08:45 zappa kernel: [  304.190423] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 11 15:08:45 zappa kernel: [  304.191471] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 11 15:08:45 zappa kernel: [  304.192499] Process texpire (pid: 4846, threadinfo ffff880215798000, task ffff8802122c78c0)
Mar 11 15:08:45 zappa kernel: [  304.193533] Stack:
Mar 11 15:08:45 zappa kernel: [  304.194558]  ffffffff8111e004 ffff8802133944c0 0000000000000009 0000000000000001
Mar 11 15:08:45 zappa kernel: [  304.195621]  ffffffff8112b185 ffff8802122c78c0 ffffffff81041739 00000000ffffffff
Mar 11 15:08:45 zappa kernel: [  304.196678]  ffff8802122c7de4 ffff8802157999e8 ffff8802157999a8 0000000023ab23ab
Mar 11 15:08:45 zappa kernel: [  304.197734] Call Trace:
Mar 11 15:08:45 zappa kernel: [  304.198782]  [<ffffffff8111e004>] ? mntput_no_expire+0x17/0x137
Mar 11 15:08:45 zappa kernel: [  304.199848]  [<ffffffff8112b185>] ? free_fs_struct+0xd/0x26
Mar 11 15:08:45 zappa kernel: [  304.200913]  [<ffffffff81041739>] ? do_exit+0x278/0x7b1
Mar 11 15:08:45 zappa kernel: [  304.201977]  [<ffffffff81379304>] ? oops_end+0xa4/0xa9
Mar 11 15:08:45 zappa kernel: [  304.203053]  [<ffffffff81372029>] ? no_context+0x241/0x26c
Mar 11 15:08:45 zappa kernel: [  304.204115]  [<ffffffff8137b3ef>] ? __do_page_fault+0x1f5/0x376
Mar 11 15:08:45 zappa kernel: [  304.205185]  [<ffffffffa018d458>] ? ext4_dx_find_entry+0x13d/0x1c8 [ext4]
Mar 11 15:08:45 zappa kernel: [  304.206257]  [<ffffffff81378918>] ? page_fault+0x28/0x30
Mar 11 15:08:45 zappa kernel: [  304.207331]  [<ffffffff81118be6>] ? __d_lookup_rcu+0x42/0xc0
Mar 11 15:08:45 zappa kernel: [  304.208409]  [<ffffffff81118bd3>] ? __d_lookup_rcu+0x2f/0xc0
Mar 11 15:08:45 zappa kernel: [  304.209478]  [<ffffffff811102c4>] ? lookup_fast+0x39/0x233
Mar 11 15:08:45 zappa kernel: [  304.210520]  [<ffffffff81110c61>] ? link_path_walk+0xba/0x482
Mar 11 15:08:45 zappa kernel: [  304.211529]  [<ffffffff811104f6>] ? walk_component+0x38/0x1aa
Mar 11 15:08:45 zappa kernel: [  304.212521]  [<ffffffff81111401>] ? path_lookupat+0x8b/0x2b1
Mar 11 15:08:45 zappa kernel: [  304.213510]  [<ffffffff81111648>] ? filename_lookup+0x21/0x79
Mar 11 15:08:45 zappa kernel: [  304.214498]  [<ffffffff81110a33>] ? getname_flags.part.23+0xb8/0x10a
Mar 11 15:08:45 zappa kernel: [  304.215501]  [<ffffffff8111355d>] ? user_path_at_empty+0x6f/0xa8
Mar 11 15:08:45 zappa kernel: [  304.216485]  [<ffffffff813778f2>] ? _cond_resched+0x6/0x1b
Mar 11 15:08:45 zappa kernel: [  304.217446]  [<ffffffff8110bc9c>] ? cp_new_stat+0x11d/0x130
Mar 11 15:08:45 zappa kernel: [  304.218381]  [<ffffffff8110ba31>] ? vfs_fstatat+0x2d/0x63
Mar 11 15:08:45 zappa kernel: [  304.219288]  [<ffffffff8110bd46>] ? sys_newstat+0x12/0x2d
Mar 11 15:08:45 zappa kernel: [  304.220171]  [<ffffffff8137d6e9>] ? system_call_fastpath+0x16/0x1b
Mar 11 15:08:45 zappa kernel: [  304.221031] Code: fa 62 00 7c d0 5b c3 48 8b 07 65 48 03 04 25 28 dc 00 00 ba 00 00 01 00 f0 0f c1 10 89 d1 c1 e9 10 66 39 ca 74 07 f3 90 66 8b 10 <eb> f4 c3 48 63 f6 48 8b 07 ba 00 00 01 00 48 03 04 f5 c0 a5 68 
Mar 11 15:09:13 zappa kernel: [  332.166722] BUG: soft lockup - CPU#1 stuck for 22s! [texpire:4846]
Mar 11 15:09:13 zappa kernel: [  332.167590] Modules linked in: ppdev lp tun cpufreq_stats cpufreq_userspace cpufreq_conservative cpufreq_powersave ip6table_filter ip6_tables xt_multiport iptable_filter ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack nfsd auth_rpcgss nfs_acl nfs lockd dns_resolver fscache sunrpc xt_TCPMSS xt_tcpmss xt_tcpudp iptable_mangle ip_tables x_tables pppoe pppox ppp_generic slhc bridge stp llc ext2 loop snd_hda_codec_hdmi snd_hda_codec_via snd_hda_intel snd_hda_codec parport_pc parport snd_hwdep coretemp kvm_intel kvm i915 snd_pcsp snd_pcm snd_page_alloc acpi_cpufreq drm_kms_helper drm i2c_algo_bit i2c_i801 iTCO_wdt iTCO_vendor_support lpc_ich i2c_core mfd_core mei eeepc_wmi asus_wmi snd_timer mperf evdev sparse_keymap usb_storage snd rfkill crc32c_intel soundcore ghash_clmulni_intel cryptd wmi processor psmouse serio_raw video button ext4 crc16 jbd2 mbcache dm_mod sg sd_mod crc_t10dif ehci_hcd fan thermal thermal_sys ahci libahci libata xhci_
Mar 11 15:09:13 zappa kernel: hcd scsi_mod microcode r8169 mii usbcore usb_common

Again the trace is much longer, I wonder is this beast from interest at
a whole pasted somewhere to investigate? I have couple of them, looking
fairly the same. This ends with:

Mar 11 15:13:49 zappa kernel: [  608.174905] CPU 1 
Mar 11 15:13:49 zappa kernel: [  608.174916] Pid: 4846, comm: texpire Tainted: G      D      3.7-trunk-amd64 #1 Debian 3.7.3-1~experimental.1 System manufacturer System Product Name/P8B75-M LE
Mar 11 15:13:49 zappa kernel: [  608.177824] RIP: 0010:[<ffffffff8105d248>]  [<ffffffff8105d248>] lg_local_lock+0x24/0x27
Mar 11 15:13:49 zappa kernel: [  608.178826] RSP: 0018:ffff880215799950  EFLAGS: 00000297
Mar 11 15:13:49 zappa kernel: [  608.179819] RAX: ffff88021ea90a50 RBX: ffffffff811367ac RCX: 0000000000002afb
Mar 11 15:13:49 zappa kernel: [  608.180822] RDX: 000000002afb2afa RSI: ffff88021323ef40 RDI: ffffffff81635c10
Mar 11 15:13:49 zappa kernel: [  608.181843] RBP: ffff880213072be0 R08: 0000000000000030 R09: 0000000000000030
Mar 11 15:13:49 zappa kernel: [  608.182846] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801ed13f620
Mar 11 15:13:49 zappa kernel: [  608.183841] R13: 0000000000000030 R14: ffffffff8113673e R15: ffff8802157998b0
Mar 11 15:13:49 zappa kernel: [  608.184828] FS:  00002b9ca590ae00(0000) GS:ffff88021ea80000(0000) knlGS:0000000000000000
Mar 11 15:13:49 zappa kernel: [  608.185828] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar 11 15:13:49 zappa kernel: [  608.186826] CR2: 00000003fffffffc CR3: 000000000160b000 CR4: 00000000001407e0
Mar 11 15:13:49 zappa kernel: [  608.187828] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 11 15:13:49 zappa kernel: [  608.188827] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 11 15:13:49 zappa kernel: [  608.189831] Process texpire (pid: 4846, threadinfo ffff880215798000, task ffff8802122c78c0)
Mar 11 15:13:49 zappa kernel: [  608.190843] Stack:
Mar 11 15:13:49 zappa kernel: [  608.191849]  ffffffff8111e004 ffff8802133944c0 0000000000000009 0000000000000001
Mar 11 15:13:49 zappa kernel: [  608.192891]  ffffffff8112b185 ffff8802122c78c0 ffffffff81041739 00000000ffffffff
Mar 11 15:13:49 zappa kernel: [  608.193934]  ffff8802122c7de4 ffff8802157999e8 ffff8802157999a8 0000000023ab23ab
Mar 11 15:13:49 zappa kernel: [  608.194976] Call Trace:
Mar 11 15:13:49 zappa kernel: [  608.196002]  [<ffffffff8111e004>] ? mntput_no_expire+0x17/0x137
Mar 11 15:13:49 zappa kernel: [  608.197045]  [<ffffffff8112b185>] ? free_fs_struct+0xd/0x26
Mar 11 15:13:49 zappa kernel: [  608.198095]  [<ffffffff81041739>] ? do_exit+0x278/0x7b1
Mar 11 15:13:49 zappa kernel: [  608.199144]  [<ffffffff81379304>] ? oops_end+0xa4/0xa9
Mar 11 15:13:49 zappa kernel: [  608.200192]  [<ffffffff81372029>] ? no_context+0x241/0x26c
Mar 11 15:13:49 zappa kernel: [  608.201241]  [<ffffffff8137b3ef>] ? __do_page_fault+0x1f5/0x376
Mar 11 15:13:49 zappa kernel: [  608.202308]  [<ffffffffa018d458>] ? ext4_dx_find_entry+0x13d/0x1c8 [ext4]
Mar 11 15:13:49 zappa kernel: [  608.203366]  [<ffffffff81378918>] ? page_fault+0x28/0x30
Mar 11 15:13:49 zappa kernel: [  608.204421]  [<ffffffff81118be6>] ? __d_lookup_rcu+0x42/0xc0
Mar 11 15:13:49 zappa kernel: [  608.205476]  [<ffffffff81118bd3>] ? __d_lookup_rcu+0x2f/0xc0
Mar 11 15:13:49 zappa kernel: [  608.206523]  [<ffffffff811102c4>] ? lookup_fast+0x39/0x233
Mar 11 15:13:49 zappa kernel: [  608.207569]  [<ffffffff81110c61>] ? link_path_walk+0xba/0x482
Mar 11 15:13:49 zappa kernel: [  608.208619]  [<ffffffff811104f6>] ? walk_component+0x38/0x1aa
Mar 11 15:13:49 zappa kernel: [  608.209667]  [<ffffffff81111401>] ? path_lookupat+0x8b/0x2b1
Mar 11 15:13:49 zappa kernel: [  608.210717]  [<ffffffff81111648>] ? filename_lookup+0x21/0x79
Mar 11 15:13:49 zappa kernel: [  608.211737]  [<ffffffff81110a33>] ? getname_flags.part.23+0xb8/0x10a
Mar 11 15:13:49 zappa kernel: [  608.212732]  [<ffffffff8111355d>] ? user_path_at_empty+0x6f/0xa8
Mar 11 15:13:49 zappa kernel: [  608.213721]  [<ffffffff813778f2>] ? _cond_resched+0x6/0x1b
Mar 11 15:13:49 zappa kernel: [  608.214681]  [<ffffffff8110bc9c>] ? cp_new_stat+0x11d/0x130
Mar 11 15:13:49 zappa kernel: [  608.215613]  [<ffffffff8110ba31>] ? vfs_fstatat+0x2d/0x63
Mar 11 15:13:49 zappa kernel: [  608.216518]  [<ffffffff8110bd46>] ? sys_newstat+0x12/0x2d
Mar 11 15:13:49 zappa kernel: [  608.217398]  [<ffffffff8137d6e9>] ? system_call_fastpath+0x16/0x1b
Mar 11 15:13:49 zappa kernel: [  608.218256] Code: fa 62 00 7c d0 5b c3 48 8b 07 65 48 03 04 25 28 dc 00 00 ba 00 00 01 00 f0 0f c1 10 89 d1 c1 e9 10 66 39 ca 74 07 f3 90 66 8b 10 <eb> f4 c3 48 63 f6 48 8b 07 ba 00 00 01 00 48 03 04 f5 c0 a5 68

Then I powered off to get a usable state again.

Can I narrow this thing down to blame either hardware or software? What
I realize is, the starting is involved with __d_lookup_rcu always, can I
compile a kernel (I _am_ able to do this well) with an option turned off
or on to narrow this down? 

Today I installed an external usb disk, moved (rsync'ed) /var to it with
a vanilla mkfs.ext4 /dev/sdb, the "texpire" bug was also triggered and
looked really the same!

The CPU used is this one:

Intel(R) Core(TM) i3-3225 CPU @ 3.30GHz

IIRC this is a dual core with hyperthreading on. cpuinfo shows 3 CPUs.

Kind regards
Konstantin Kletschke
