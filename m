Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbaAJSXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 13:23:38 -0500
Received: from www62.your-server.de ([213.133.104.62]:52129 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaAJSXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 13:23:34 -0500
Message-ID: <52D03A9E.2030309@iogearbox.net>
Date: Fri, 10 Jan 2014 19:23:26 +0100
From: Daniel Borkmann <borkmann@iogearbox.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [BUG] at include/linux/page-flags.h:415 (PageTransHuge)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: borkmann@iogearbox.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is being reliably triggered for each mmaped() packet(7)
socket from user space, basically during unmapping resp.
closing the TX socket.

I believe due to some change in transparent hugepages code ?

When I disable transparent hugepages, everything works fine,
no BUG triggered.

I'd be happy to test patches.

With using default kernel config:

[   63.887947] kernel BUG at include/linux/page-flags.h:415!
[   63.889296] invalid opcode: 0000 [#4] SMP
[   63.890637] Modules linked in: fuse ebtable_nat xt_CHECKSUM bridge stp llc rfcomm bnep nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm iwlwifi snd_page_alloc btusb snd_timer bluetooth cfg80211 wmi joydev thinkpad_acpi snd iTCO_wdt iTCO_vendor_support pcspkr e1000e tpm_tis tpm uvcvideo i2c_i801 soundcore sdhci_pci sdhci lpc_ich rfkill videobuf2_vmalloc videobuf2_memops videobuf2_core mmc_core mfd_core ptp videodev pps_core media uinput i915
[   63.895055]  i2c_algo_bit drm_kms_helper drm i2c_core video
[   63.896529] CPU: 2 PID: 1598 Comm: trafgen Tainted: G      D      3.13.0-rc6+ #12
[   63.898010] Hardware name: LENOVO 2429BP3/2429BP3, BIOS G4ET37WW (1.12 ) 05/29/2012
[   63.899494] task: ffff8801eca6c1a0 ti: ffff88020e694000 task.ti: ffff88020e694000
[   63.900988] RIP: 0010:[<ffffffff8168a492>]  [<ffffffff8168a492>] PageTransHuge.part.11+0x4/0x6
[   63.902498] RSP: 0018:ffff88020e695df8  EFLAGS: 00010282
[   63.903996] RAX: 005fffc000008004 RBX: ffff88020254cac8 RCX: 00000000078ed340
[   63.905492] RDX: ffffffff8116b3c6 RSI: 0000000000000001 RDI: ffff88020cf80640
[   63.906992] RBP: ffff88020e695df8 R08: 0000000000000000 R09: 0000000000000000
[   63.908485] R10: ffff8801eca6c1a0 R11: 00000000100000fb R12: ffffea00078ed340
[   63.909970] R13: ffff88020e695f48 R14: 00007f274a5f3000 R15: 00007f274a5f4000
[   63.911456] FS:  00007f274e5f3740(0000) GS:ffff88021e280000(0000) knlGS:0000000000000000
[   63.912946] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   63.914430] CR2: 0000003724a35a90 CR3: 00000001eabb6000 CR4: 00000000001407e0
[   63.915919] Stack:
[   63.917404]  ffff88020e695ee0 ffffffff8116fa7a 0000000ed78ec480 00007f274e5f2fff
[   63.918913]  0000000000000001 00007f274e5f3000 00000000810c864b ffff8801fb16aca8
[   63.920430]  0000000000000000 0000000000000000 ffff88020e695e58 0000000000000046
[   63.921938] Call Trace:
[   63.923451]  [<ffffffff8116fa7a>] munlock_vma_pages_range+0x2ea/0x2f0
[   63.924978]  [<ffffffff810a07bd>] ? trace_hardirqs_off+0xd/0x10
[   63.926454]  [<ffffffff81171b32>] ? vma_merge+0xc2/0x330
[   63.927870]  [<ffffffff8116fb7c>] mlock_fixup+0xfc/0x190
[   63.929288]  [<ffffffff8116fdc7>] do_mlockall+0x87/0xc0
[   63.930702]  [<ffffffff811702bf>] sys_munlockall+0x2f/0x50
[   63.932117]  [<ffffffff8169df52>] system_call_fastpath+0x16/0x1b
[   63.933531] Code: c1 e0 06 48 29 d8 eb 02 31 c0 5b 41 5c 5d c3 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55 48 89 e5 <0f> 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55 48 8b 07 31 c9 48
[   63.935103] RIP  [<ffffffff8168a492>] PageTransHuge.part.11+0x4/0x6
[   63.936580]  RSP <ffff88020e695df8>
[   63.938021] ---[ end trace 67b7aa3fba09186d ]---
