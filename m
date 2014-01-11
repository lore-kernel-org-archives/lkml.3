Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaAKNcs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 08:32:48 -0500
Received: from www62.your-server.de ([213.133.104.62]:57413 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaAKNcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 08:32:43 -0500
Message-ID: <52D147F1.3040803@iogearbox.net>
Date: Sat, 11 Jan 2014 14:32:33 +0100
From: Daniel Borkmann <borkmann@iogearbox.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [BUG] at include/linux/page-flags.h:415 (PageTransHuge)
References: <52D03A9E.2030309@iogearbox.net> <20140110222248.4e8419ca.akpm@linux-foundation.org>
In-Reply-To: <20140110222248.4e8419ca.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: borkmann@iogearbox.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2014 07:22 AM, Andrew Morton wrote:
> On Fri, 10 Jan 2014 19:23:26 +0100 Daniel Borkmann <borkmann@iogearbox.net> wrote:
>
>> This is being reliably triggered for each mmaped() packet(7)
>> socket from user space, basically during unmapping resp.
>> closing the TX socket.
>>
>> I believe due to some change in transparent hugepages code ?
>>
>> When I disable transparent hugepages, everything works fine,
>> no BUG triggered.
>>
>> I'd be happy to test patches.
>
> Did the inclusion of c424be1cbbf852e46acc8 ("mm: munlock: fix a bug
> where THP tail page is encountered") in current mainline fix this?

Thanks for your answer Andrew!

Hm, I just cherry-picked that onto current net-next as I have some work
there, and this time I got ...

(User space uses packet mmap() and mlockall(MCL_CURRENT | MCL_FUTURE)
  and on shutdown munlockall() ...)

[   63.863672] ------------[ cut here ]------------
[   63.863702] kernel BUG at mm/mlock.c:507!
[   63.863721] invalid opcode: 0000 [#1] SMP
[   63.863743] Modules linked in: fuse ebtable_nat xt_CHECKSUM nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack bridge ebtable_filter ebtables stp llc ip6table_filter ip6_tables rfcomm bnep snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec iwlwifi cfg80211 snd_hwdep btusb snd_seq bluetooth sdhci_pci snd_seq_device e1000e tpm_tis snd_pcm thinkpad_acpi sdhci ptp tpm uvcvideo pps_core snd_page_alloc snd_timer snd rfkill mmc_core iTCO_wdt iTCO_vendor_support lpc_ich mfd_core soundcore joydev wmi videobuf2_vmalloc videobuf2_memops videobuf2_core i2c_i801 pcspkr videodev media uinput i915
[   63.864152]  i2c_algo_bit drm_kms_helper drm i2c_core video
[   63.864181] CPU: 1 PID: 1617 Comm: trafgen Not tainted 3.13.0-rc6+ #15
[   63.864209] Hardware name: LENOVO 2429BP3/2429BP3, BIOS G4ET37WW (1.12 ) 05/29/2012
[   63.864242] task: ffff8801ee060000 ti: ffff8800b5954000 task.ti: ffff8800b5954000
[   63.864274] RIP: 0010:[<ffffffff8116fa9a>]  [<ffffffff8116fa9a>] munlock_vma_pages_range+0x2ea/0x2f0
[   63.864318] RSP: 0018:ffff8800b5955e08  EFLAGS: 00010202
[   63.864341] RAX: 00000000000001ff RBX: ffff8800b58f7508 RCX: 0000000000000034
[   63.864372] RDX: 00000007f0708992 RSI: ffffea0002c3e700 RDI: ffffea0002c3e700
[   63.864402] RBP: ffff8800b5955ee0 R08: 3800000000000000 R09: a8000b0f9c000000
[   63.864432] R10: 57ffdef066c3e700 R11: ffffff5cfb00c14a R12: ffffea0002c3e700
[   63.864462] R13: ffff8800b5955f48 R14: 00007f0708992000 R15: 00007f0708992000
[   63.864492] FS:  00007f0708b92740(0000) GS:ffff88021e240000(0000) knlGS:0000000000000000
[   63.864526] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   63.864551] CR2: 00007f33bb373000 CR3: 00000000b2a2c000 CR4: 00000000001407e0
[   63.864581] Stack:
[   63.864593]  ffff8800b5955ed0 00007f0708b91fff 00007f0708b92000 ffff8800b5955e48
[   63.864632]  000001ff810c864b ffff8801ee060000 0000000000000000 0000000000000000
[   63.864669]  ffff8800b5955e58 ffff8801ee060000 0000000700000086 ffff8801ee060000
[   63.864708] Call Trace:
[   63.864724]  [<ffffffff816956bc>] ? _raw_spin_unlock_irq+0x2c/0x30
[   63.864754]  [<ffffffff81171b52>] ? vma_merge+0xc2/0x330
[   63.864786]  [<ffffffff8116fb9c>] mlock_fixup+0xfc/0x190
[   63.864812]  [<ffffffff8116fde7>] do_mlockall+0x87/0xc0
[   63.864836]  [<ffffffff811702df>] sys_munlockall+0x2f/0x50
[   63.864873]  [<ffffffff8169e192>] system_call_fastpath+0x16/0x1b
[   63.864898] Code: d7 48 89 95 28 ff ff ff e8 a4 04 fe ff 84 c0 48 8b 95 28 ff ff ff 0f 85 5a ff ff ff e9 46 ff ff ff e8 3f ac 51 00 e8 34 ac 51 00 <0f> 0b 0f 1f 40 00 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55
[   63.865114] RIP  [<ffffffff8116fa9a>] munlock_vma_pages_range+0x2ea/0x2f0
[   63.865148]  RSP <ffff8800b5955e08>
[   63.874968] ------------[ cut here ]------------

... when I find some time, I'll try with normal torvalds' tree, maybe some
other patches are missing as well, not sure right now.

Thanks anyway!

>> With using default kernel config:
>>
>> [   63.887947] kernel BUG at include/linux/page-flags.h:415!
>> [   63.889296] invalid opcode: 0000 [#4] SMP
>> [   63.890637] Modules linked in: fuse ebtable_nat xt_CHECKSUM bridge stp llc rfcomm bnep nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm iwlwifi snd_page_alloc btusb snd_timer bluetooth cfg80211 wmi joydev thinkpad_acpi snd iTCO_wdt iTCO_vendor_support pcspkr e1000e tpm_tis tpm uvcvideo i2c_i801 soundcore sdhci_pci sdhci lpc_ich rfkill videobuf2_vmalloc videobuf2_memops videobuf2_core mmc_core mfd_core ptp videodev pps_core media uinput i915
>> [   63.895055]  i2c_algo_bit drm_kms_helper drm i2c_core video
>> [   63.896529] CPU: 2 PID: 1598 Comm: trafgen Tainted: G      D      3.13.0-rc6+ #12
>> [   63.898010] Hardware name: LENOVO 2429BP3/2429BP3, BIOS G4ET37WW (1.12 ) 05/29/2012
>> [   63.899494] task: ffff8801eca6c1a0 ti: ffff88020e694000 task.ti: ffff88020e694000
>> [   63.900988] RIP: 0010:[<ffffffff8168a492>]  [<ffffffff8168a492>] PageTransHuge.part.11+0x4/0x6
>> [   63.902498] RSP: 0018:ffff88020e695df8  EFLAGS: 00010282
>> [   63.903996] RAX: 005fffc000008004 RBX: ffff88020254cac8 RCX: 00000000078ed340
>> [   63.905492] RDX: ffffffff8116b3c6 RSI: 0000000000000001 RDI: ffff88020cf80640
>> [   63.906992] RBP: ffff88020e695df8 R08: 0000000000000000 R09: 0000000000000000
>> [   63.908485] R10: ffff8801eca6c1a0 R11: 00000000100000fb R12: ffffea00078ed340
>> [   63.909970] R13: ffff88020e695f48 R14: 00007f274a5f3000 R15: 00007f274a5f4000
>> [   63.911456] FS:  00007f274e5f3740(0000) GS:ffff88021e280000(0000) knlGS:0000000000000000
>> [   63.912946] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   63.914430] CR2: 0000003724a35a90 CR3: 00000001eabb6000 CR4: 00000000001407e0
>> [   63.915919] Stack:
>> [   63.917404]  ffff88020e695ee0 ffffffff8116fa7a 0000000ed78ec480 00007f274e5f2fff
>> [   63.918913]  0000000000000001 00007f274e5f3000 00000000810c864b ffff8801fb16aca8
>> [   63.920430]  0000000000000000 0000000000000000 ffff88020e695e58 0000000000000046
>> [   63.921938] Call Trace:
>> [   63.923451]  [<ffffffff8116fa7a>] munlock_vma_pages_range+0x2ea/0x2f0
>> [   63.924978]  [<ffffffff810a07bd>] ? trace_hardirqs_off+0xd/0x10
>> [   63.926454]  [<ffffffff81171b32>] ? vma_merge+0xc2/0x330
>> [   63.927870]  [<ffffffff8116fb7c>] mlock_fixup+0xfc/0x190
>> [   63.929288]  [<ffffffff8116fdc7>] do_mlockall+0x87/0xc0
>> [   63.930702]  [<ffffffff811702bf>] sys_munlockall+0x2f/0x50
>> [   63.932117]  [<ffffffff8169df52>] system_call_fastpath+0x16/0x1b
>> [   63.933531] Code: c1 e0 06 48 29 d8 eb 02 31 c0 5b 41 5c 5d c3 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55 48 89 e5 <0f> 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55 48 8b 07 31 c9 48
>> [   63.935103] RIP  [<ffffffff8168a492>] PageTransHuge.part.11+0x4/0x6
>> [   63.936580]  RSP <ffff88020e695df8>
>> [   63.938021] ---[ end trace 67b7aa3fba09186d ]---
>

