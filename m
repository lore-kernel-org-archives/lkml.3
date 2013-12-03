Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3LCOXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:23:20 -0500
Received: from bacon.sh.bytemark.co.uk ([212.110.161.169]:35886 "EHLO
	bacon.sh.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3LCOXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:23:16 -0500
X-Greylist: delayed 1289 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2013 09:23:15 EST
Message-ID: <1386079283.30786.14.camel@eboracum.office.bytemark.co.uk>
Subject: Possible kernel bug - general protection fault allocating memory /
 in tracepoint?
From: Nicholas Thomas <nick@bytemark.co.uk>
To: linux-kernel@vger.kernel.org
Date: Tue, 03 Dec 2013 14:01:23 +0000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Organization: Bytemark Computer Consulting Ltd. Unit 2, Novus Business Park, Opus Avenue, York, YO26 6BL. Company registered in England and Wales no. 4484629. VAT registration no. GB 135 6159 13.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have a number of 64-core, 768GB machines used as KVM VM hosts, and
running linux 3.10. Last night, one of them lost most network
connectivity (ping worked, SSH failed) with the output seen at the
bottom of this message.

The time period between backtrace and reboot is around seven hours. 

The workload triggering this behaviour was approx. 200 customer virtual
machines, totalling around 380GB of RAM. VM discs are held remotely,
with access over (user-mode) IPv6 NBD sessions.

This feels very much like a kernel bug to me, although I'm happy to be
told otherwise :). I'm also happy to help with tracking it down in any
way I can; although I'm something of a novice in this area, and I don't
have a reliable way to replicate this.

I'm not subscribed to the list, so please CC me in any replies.

[501324.100452] general protection fault: 0000 [#1] SMP 
[501324.110854] Modules linked in: ebt_arp ebt_ip6 ebt_ip ebtable_filter ebtables x_tables bonding 8021q garp bridge stp llc virtio_balloon virtio_console virtio_rng ghash_clmulni_intel aesni_intel aes_x86_64 ablk_helper radeon snd_pcm cryptd snd_page_alloc lrw snd_timer ttm gf128mul snd drm_kms_helper glue_helper joydev drm psmouse soundcore sp5100_tco amd64_edac_mod i2c_piix4 microcode edac_core pcspkr hpilo tpm_tis hpwdt serio_raw i2c_algo_bit hid_generic edac_mce_amd k10temp fam15h_power acpi_power_meter mac_hid raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid0 multipath linear sata_nv raid1 usbhid hid pata_atiixp ahci netxen_nic libahci
[501324.216938] CPU: 8 PID: 65331 Comm: dropbear Not tainted 3.10.20-bigv-11 #1
[501324.232149] Hardware name: HP ProLiant DL585 G7, BIOS A16 12/09/2012
[501324.246961] task: ffff881145565c40 ti: ffff88156cb8c000 task.ti: ffff88156cb8c000
[501324.263188] RIP: 0010:[<ffffffff811b1060>]  [<ffffffff811b1060>] kmem_cache_alloc_trace+0x70/0x140
[501324.281330] RSP: 0018:ffff88156cb8de48  EFLAGS: 00010282
[501324.295541] RAX: 0000000000000000 RBX: ffff8815eb3a8b40 RCX: 000000000014c30b
[501324.312020] RDX: 000000000014c30a RSI: 00000000000080d0 RDI: ffffffff811c92d4
[501324.328905] RBP: ffff88156cb8de88 R08: 0000000000015f80 R09: 000000000041c6cd
[501324.328907] R10: 0000000000000000 R11: 0000000000000246 R12: 0808060808000108
[501324.328908] R13: 00000000000080d0 R14: 0000000000000088 R15: ffff8817df803800
[501324.328910] FS:  00007f0be7d5b700(0000) GS:ffff8817dfc80000(0000) knlGS:0000000000000000
[501324.328911] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[501324.328912] CR2: 00007fff4ccdbfb8 CR3: 00000011c23ba000 CR4: 00000000000406e0
[501324.328913] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[501324.328914] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[501324.328915] Stack:
[501324.328956]  ffffffff811c92d4 ffff8815eb3a8b40 ffff888fd3958000 ffff8815eb3a8b40
[501324.328973]  ffff88156cb8df48 ffff88156cb8df48 0000000000000000 00007fff4ccdc170
[501324.329009]  ffff88156cb8dea8 ffffffff811c92d4 0000000000000000 ffff8815eb3a8b40
[501324.329010] Call Trace:
[501324.329026]  [<ffffffff811c92d4>] ? alloc_pipe_info+0x24/0xb0
[501324.329035]  [<ffffffff811c92d4>] alloc_pipe_info+0x24/0xb0
[501324.329042]  [<ffffffff811c9826>] create_pipe_files+0x46/0x200
[501324.329057]  [<ffffffff811c9a21>] __do_pipe_flags+0x41/0xe0
[501324.329065]  [<ffffffff811c9b30>] SyS_pipe2+0x20/0xa0
[501324.329077]  [<ffffffff8177312e>] ? do_page_fault+0xe/0x10
[501324.329088]  [<ffffffff8176f972>] ? page_fault+0x22/0x30
[501324.329098]  [<ffffffff811c9bc0>] SyS_pipe+0x10/0x20
[501324.329108]  [<ffffffff81777982>] system_call_fastpath+0x16/0x1b
[501324.329130] Code: ce 00 00 49 8b 50 08 4d 8b 20 49 8b 40 10 4d 85 e4 0f 84 9c 00 00 00 48 85 c0 0f 84 93 00 00 00 49 63 47 20 4d 8b 07 48 8d 4a 01 <49> 8b 1c 04 4c 89 e0 65 49 0f c7 08 0f 94 c0 84 c0 74 b9 49 63 
[501324.329134] RIP  [<ffffffff811b1060>] kmem_cache_alloc_trace+0x70/0x140
[501324.329135]  RSP <ffff88156cb8de48>
[501324.329164] general protection fault: 0000 [#2] SMP 
[501324.329188] Modules linked in: ebt_arp ebt_ip6 ebt_ip ebtable_filter ebtables x_tables bonding 8021q garp bridge stp llc virtio_balloon virtio_console virtio_rng ghash_clmulni_intel aesni_intel aes_x86_64 ablk_helper radeon snd_pcm cryptd snd_page_alloc lrw snd_timer ttm gf128mul snd drm_kms_helper glue_helper joydev drm psmouse soundcore sp5100_tco amd64_edac_mod i2c_piix4 microcode edac_core pcspkr hpilo tpm_tis hpwdt serio_raw i2c_algo_bit hid_generic edac_mce_amd k10temp fam15h_power acpi_power_meter mac_hid raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid0 multipath linear sata_nv raid1 usbhid hid pata_atiixp ahci netxen_nic libahci
[501324.329190] CPU: 8 PID: 65331 Comm: dropbear Not tainted 3.10.20-bigv-11 #1
[501324.329191] Hardware name: HP ProLiant DL585 G7, BIOS A16 12/09/2012
[501324.329192] task: ffff881145565c40 ti: ffff88156cb8c000 task.ti: ffff88156cb8c000
[501324.329194] RIP: 0010:[<ffffffff811b13fd>]  [<ffffffff811b13fd>] __kmalloc+0x8d/0x180
[501324.329195] RSP: 0018:ffff88156cb8d8d8  EFLAGS: 00010082
[501324.329196] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000014c30b
[501324.329197] RDX: 000000000014c30a RSI: 0000000000000000 RDI: 0000000000015f80
[501324.329198] RBP: ffff88156cb8d918 R08: ffff8817dfc95f80 R09: ffffffffa035acc1
[501324.329198] R10: 0000000000000300 R11: 0000000000000300 R12: 0808060808000108
[501324.329199] R13: 00000000000080d0 R14: 00000000000000a0 R15: ffff8817df803800
[501324.329201] FS:  00007f0be7d5b700(0000) GS:ffff8817dfc80000(0000) knlGS:0000000000000000
[501324.329201] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[501324.329202] CR2: 00007fff4ccdbfb8 CR3: 00000011c23ba000 CR4: 00000000000406e0
[501324.329203] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[501324.329204] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[501324.329204] Stack:
[501324.329231]  ffffffffa035acc1 ffffffffa035ac9b ffff885fd37ff800 0000000000000000
[501324.329252]  ffff8877ce9d9e80 ffff885fcf5e9000 ffff885fcf152a00 ffff885fcf153238
[501324.329272]  ffff88156cb8d9d8 ffffffffa035acc1 0000000000000001 ffffffff00000000
[501324.329272] Call Trace:
[501324.329286]  [<ffffffffa035acc1>] ? drm_crtc_helper_set_config+0x111/0xb60 [drm_kms_helper]
[501324.329294]  [<ffffffffa035ac9b>] ? drm_crtc_helper_set_config+0xeb/0xb60 [drm_kms_helper]
[501324.329304]  [<ffffffffa035acc1>] drm_crtc_helper_set_config+0x111/0xb60 [drm_kms_helper]
[501324.329312]  [<ffffffff810f4ae8>] ? __sprint_symbol+0xc8/0xf0
[501324.329348]  [<ffffffffa056a77e>] drm_mode_set_config_internal+0x2e/0x60 [drm]
[501324.329357]  [<ffffffffa0357ed4>] drm_fb_helper_pan_display+0x94/0xf0 [drm_kms_helper]
[501324.329365]  [<ffffffff813c3f41>] fb_pan_display+0xc1/0x180
[501324.329372]  [<ffffffff813d4569>] bit_update_start+0x29/0x60
[501324.329378]  [<ffffffff813d3fec>] fbcon_switch+0x3ac/0x570
[501324.329386]  [<ffffffff8143ca49>] redraw_screen+0x179/0x240
[501324.329392]  [<ffffffff813d276a>] fbcon_blank+0x21a/0x2e0
[501324.329399]  [<ffffffff810b76a6>] ? down_trylock+0x36/0x50
[501324.329406]  [<ffffffff8108d54c>] ? console_trylock+0x1c/0x70
[501324.329414]  [<ffffffff8109c708>] ? lock_timer_base.isra.35+0x38/0x70
[501324.329419]  [<ffffffff8109c500>] ? internal_add_timer+0x20/0x50
[501324.329425]  [<ffffffff8109dab0>] ? mod_timer+0x160/0x200
[501324.329431]  [<ffffffff8143d104>] do_unblank_screen+0xb4/0x1e0
[501324.329436]  [<ffffffff8143d240>] unblank_screen+0x10/0x20
[501324.329443]  [<ffffffff813783c9>] bust_spinlocks+0x19/0x40
[501324.329451]  [<ffffffff8177042f>] oops_end+0x3f/0xe0
[501324.329458]  [<ffffffff8104e868>] die+0x58/0x90
[501324.329466]  [<ffffffff8176ff42>] do_general_protection+0xd2/0x160
[501324.329473]  [<ffffffff8176f942>] general_protection+0x22/0x30
[501324.329479]  [<ffffffff811c92d4>] ? alloc_pipe_info+0x24/0xb0
[501324.329485]  [<ffffffff811b1060>] ? kmem_cache_alloc_trace+0x70/0x140
[501324.329491]  [<ffffffff811b1028>] ? kmem_cache_alloc_trace+0x38/0x140
[501324.329497]  [<ffffffff811c92d4>] ? alloc_pipe_info+0x24/0xb0
[501324.329504]  [<ffffffff811c92d4>] alloc_pipe_info+0x24/0xb0
[501324.329509]  [<ffffffff811c9826>] create_pipe_files+0x46/0x200
[501324.329514]  [<ffffffff811c9a21>] __do_pipe_flags+0x41/0xe0
[501324.329519]  [<ffffffff811c9b30>] SyS_pipe2+0x20/0xa0
[501324.329524]  [<ffffffff8177312e>] ? do_page_fault+0xe/0x10
[501324.329530]  [<ffffffff8176f972>] ? page_fault+0x22/0x30
[501324.329535]  [<ffffffff811c9bc0>] SyS_pipe+0x10/0x20
[501324.329541]  [<ffffffff81777982>] system_call_fastpath+0x16/0x1b
[501324.329558] Code: ce 00 00 49 8b 50 08 4d 8b 20 49 8b 40 10 4d 85 e4 0f 84 a7 00 00 00 48 85 c0 0f 84 9e 00 00 00 49 63 47 20 49 8b 3f 48 8d 4a 01 <49> 8b 1c 04 4c 89 e0 65 48 0f c7 0f 0f 94 c0 84 c0 74 b9 49 63 
[501324.329560] RIP  [<ffffffff811b13fd>] __kmalloc+0x8d/0x180
[501324.329561]  RSP <ffff88156cb8d8d8>
[501324.329562] ---[ end trace f2185f66256b183e ]---
[501384.292941] INFO: rcu_sched detected stalls on CPUs/tasks: {} (detected by 4, t=15003 jiffies, g=2354954, c=2354953, q=234698)
[501384.322592] INFO: Stall ended before state dump start
[...]
[506060.971568] INFO: rcu_sched detected stalls on CPUs/tasks: {} (detected by 54, t=1185133 jiffies, g=2354954, c=2354953, q=7095138)
[506061.016422] INFO: Stall ended before state dump start
[506230.139397] [sched_delayed] sched: RT throttling activated
[506240.842515] INFO: rcu_sched detected stalls on CPUs/tasks: {} (detected by 48, t=1230138 jiffies, g=2354954, c=2354953, q=7249459)
[506240.887184] INFO: Stall ended before state dump start
[...]
[526566.374161] INFO: rcu_sched detected stalls on CPUs/tasks: {} (detected by 12, t=6315703 jiffies, g=2354954, c=2354953, q=16000085)
[526566.418847] INFO: Stall ended before state dump start
[rebooted]



