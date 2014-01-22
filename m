Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbaAVXuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 18:50:00 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:40322 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbaAVXt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 18:49:57 -0500
MIME-Version: 1.0
Date: Wed, 22 Jan 2014 15:49:56 -0800
Message-ID: <CAADnVQKeOZNBFdyfLdfmZ5+wqBoV9JVU98sKzWvqRM7r1PNMFA@mail.gmail.com>
Subject: Re: might_sleep warning in filemap_fault()
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

still see the following lockdep trace on 3.10.27
looks like false positive?

[ 2247.964877] ------------[ cut here ]------------
[ 2247.964882] WARNING: at kernel/lockdep.c:2740 lockdep_trace_alloc+0xdd/0xe0()
[ 2247.964883] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
[ 2247.964884] Modules linked in: ...
[ 2247.964936] CPU: 0 PID: 27902 Comm: llc_lockdep Tainted: GF
 O 3.10.27+ #39
[ 2247.964937] Hardware name: System manufacturer System Product
Name/P8Z77 WS, BIOS 3007 07/26/2012
[ 2247.964938]  0000000000000009 ffff88077332f308 ffffffff81717565
ffff88077332f348
[ 2247.964940]  ffffffff81058530 0000000000022010 0000000000000096
0000000000000000
[ 2247.964942]  0000000000000000 0000000000000003 0000000000000002
ffff88077332f3a8
[ 2247.964945] Call Trace:
[ 2247.964948]  [<ffffffff81717565>] dump_stack+0x19/0x1b
[ 2247.964951]  [<ffffffff81058530>] warn_slowpath_common+0x70/0xa0
[ 2247.964952]  [<ffffffff81058616>] warn_slowpath_fmt+0x46/0x50
[ 2247.964954]  [<ffffffff810c115d>] lockdep_trace_alloc+0xdd/0xe0
[ 2247.964956]  [<ffffffff8114c53c>] __alloc_pages_nodemask+0x7c/0x920
[ 2247.964959]  [<ffffffff81013061>] ? math_state_restore+0x41/0x150
[ 2247.964962]  [<ffffffff8101b910>] ? __kernel_fpu_end+0x10/0x30
[ 2247.964966]  [<ffffffffa04fa85f>] ? cbc_decrypt+0x9f/0xe0 [aesni_intel]
[ 2247.964967]  [<ffffffff810bb34d>] ? trace_hardirqs_off+0xd/0x10
[ 2247.964969]  [<ffffffff810c0c97>] ? debug_check_no_locks_freed+0xe7/0x180
[ 2247.964971]  [<ffffffff8115e411>] ? kzfree+0x31/0x40
[ 2247.964974]  [<ffffffff811435c5>] ? find_get_page+0x5/0xf0
[ 2247.964976]  [<ffffffff811880d8>] alloc_pages_current+0xb8/0x180
[ 2247.964978]  [<ffffffff8114356f>] __page_cache_alloc+0xaf/0xd0
[ 2247.964980]  [<ffffffff81143eef>] grab_cache_page_write_begin+0x7f/0xf0
[ 2247.964983]  [<ffffffff8124faf4>] ext4_da_write_begin+0x104/0x2b0
[ 2247.964984]  [<ffffffff811435c5>] ? find_get_page+0x5/0xf0
[ 2247.964987]  [<ffffffff81142c5e>] generic_file_buffered_write+0x11e/0x280
[ 2247.964989]  [<ffffffff81144b2d>] __generic_file_aio_write+0x1cd/0x3d0
[ 2247.964991]  [<ffffffff8171bb6c>] ? mutex_lock_nested+0x27c/0x370
[ 2247.964993]  [<ffffffff81144d87>] ? generic_file_aio_write+0x57/0xd0
[ 2247.964995]  [<ffffffff81144d9a>] generic_file_aio_write+0x6a/0xd0
[ 2247.964997]  [<ffffffff81247009>] ext4_file_write+0xa9/0x440
[ 2247.965000]  [<ffffffff8137ac2d>] ? do_raw_spin_unlock+0x5d/0xb0
[ 2247.965002]  [<ffffffff8171f05b>] ? _raw_spin_unlock+0x2b/0x40
[ 2247.965004]  [<ffffffff8116b1e8>] ? follow_page_mask+0x218/0x580
[ 2247.965007]  [<ffffffff81168139>] ? spin_unlock+0x9/0x10
[ 2247.965008]  [<ffffffff8116b4a5>] ? follow_page_mask+0x4d5/0x580
[ 2247.965011]  [<ffffffff811aacf0>] do_sync_write+0x80/0xb0
[ 2247.965014]  [<ffffffff812084a9>] dump_write+0x59/0x70
[ 2247.965016]  [<ffffffff81200fcb>] elf_core_dump+0x149b/0x1660
[ 2247.965017]  [<ffffffff81200537>] ? elf_core_dump+0xa07/0x1660
[ 2247.965020]  [<ffffffff81209329>] do_coredump+0xb39/0xfb0
[ 2247.965022]  [<ffffffff8106ce47>] ? __send_signal+0x187/0x420
[ 2247.965025]  [<ffffffff8106f1f7>] get_signal_to_deliver+0x267/0x650
[ 2247.965027]  [<ffffffff810123a7>] do_signal+0x57/0x970
[ 2247.965028]  [<ffffffff810bb34d>] ? trace_hardirqs_off+0xd/0x10
[ 2247.965031]  [<ffffffff811065d9>] ? __acct_update_integrals+0x99/0x110
[ 2247.965033]  [<ffffffff817121e0>] ? printk+0x61/0x63
[ 2247.965035]  [<ffffffff811423a6>] ? user_exit+0x56/0xb0
[ 2247.965037]  [<ffffffff810c0add>] ? trace_hardirqs_on_caller+0x10d/0x1d0
[ 2247.965039]  [<ffffffff81012d48>] do_notify_resume+0x88/0xb0
[ 2247.965041]  [<ffffffff8171f6fb>] retint_signal+0x4d/0x92
[ 2247.965042] ---[ end trace 6709608ef3de895e ]---


On Mon, Dec 9, 2013 at 6:38 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> Hi,
>
> seeing the following trace on 3.10.xx kernels, including 3.10.23.
> 3.12.4 and 3.13rc2 are fine.
> Is there a patch waiting to be backported?
>
> [   96.393807] llc[2903]: segfault at 8 ip 0000000000692da7 sp
> 00007fff1a6baf30 error 4 in llc[400000+7f8000]
> [   96.394304] BUG: sleeping function called from invalid context at
> include/linux/pagemap.h:375
> [   96.394306] in_atomic(): 0, irqs_disabled(): 1, pid: 2903, name: llc
> [   96.394307] 1 lock held by llc/2903:
> [   96.394308]  #0:  (sb_writers#8){.+.+.+}, at: [<ffffffff81205033>]
> do_coredump+0xf83/0x1110
> [   96.394314] irq event stamp: 68216
> [   96.394315] hardirqs last  enabled at (68215): [<ffffffff816864a1>]
> __mutex_unlock_slowpath+0xd1/0x180
> [   96.394318] hardirqs last disabled at (68216): [<ffffffff81002b55>]
> math_state_restore+0x35/0x150
> [   96.394320] softirqs last  enabled at (65780): [<ffffffff8104f663>]
> __do_softirq+0x183/0x3f0
> [   96.394322] softirqs last disabled at (65761): [<ffffffff8104fa85>]
> irq_exit+0xb5/0xc0
> [   96.394325] CPU: 1 PID: 2903 Comm: llc Not tainted 3.10.1 #31
> [   96.394326] Hardware name: System manufacturer System Product
> Name/P8Z77 WS, BIOS 3007 07/26/2012
> [   96.394327]  ffffffff819fcac9 ffff8807f5ec96e8 ffffffff81682103
> ffff8807f5ec9718
> [   96.394329]  ffffffff81081e60 00000000000007fa 00000000000007fa
> ffff8807f5fe6f00
> [   96.394331]  ffff880809bc81e0 ffff8807f5ec9788 ffffffff8114149e
> 0000000000000006
> [   96.394333] Call Trace:
> [   96.394335]  [<ffffffff81682103>] dump_stack+0x19/0x1b
> [   96.394338]  [<ffffffff81081e60>] __might_sleep+0x180/0x230
> [   96.394340]  [<ffffffff8114149e>] filemap_fault+0xce/0x470
> [   96.394342]  [<ffffffff81165dbe>] __do_fault+0x6e/0x470
> [   96.394344]  [<ffffffff81168a9f>] handle_pte_fault+0x8f/0x8b0
> [   96.394346]  [<ffffffff81169ac0>] handle_mm_fault+0x210/0x300
> [   96.394348]  [<ffffffff81169e1e>] __get_user_pages+0x19e/0x5c0
> [   96.394349]  [<ffffffff8116a285>] get_dump_page+0x45/0x60
> [   96.394351]  [<ffffffff811fe371>] elf_core_dump+0x16b1/0x1930
> [   96.394353]  [<ffffffff811fd6cc>] ? elf_core_dump+0xa0c/0x1930
> [   96.394356]  [<ffffffff811a2f0f>] ? __sb_start_write+0xef/0x1c0
> [   96.394358]  [<ffffffff81205033>] ? do_coredump+0xf83/0x1110
> [   96.394359]  [<ffffffff81205033>] ? do_coredump+0xf83/0x1110
> [   96.394361]  [<ffffffff81204ce9>] do_coredump+0xc39/0x1110
> [   96.394364]  [<ffffffff8105fc02>] get_signal_to_deliver+0x2b2/0x930
> [   96.394366]  [<ffffffff81002387>] do_signal+0x57/0x5a0
> [   96.394368]  [<ffffffff8168df6b>] ? __do_page_fault+0x50b/0x570
> [   96.394370]  [<ffffffff81060434>] ? __set_current_blocked+0x34/0x60
> [   96.394372]  [<ffffffff8167d1f9>] ? printk+0x61/0x63
> [   96.394374]  [<ffffffff810b9495>] ? trace_hardirqs_on_caller+0x105/0x1d0
> [   96.394376]  [<ffffffff810b956d>] ? trace_hardirqs_on+0xd/0x10
> [   96.394378]  [<ffffffff8168a10d>] ? retint_signal+0x11/0x84
> [   96.394380]  [<ffffffff81002935>] do_notify_resume+0x65/0x80
> [   96.394382]  [<ffffffff813349de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   96.394384]  [<ffffffff8168a142>] retint_signal+0x46/0x84
> [   96.394386] ------------[ cut here ]------------
> [   96.394388] WARNING: at kernel/lockdep.c:2740 lockdep_trace_alloc+0xc5/0xd0()
> [   96.394389] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
> [   96.394390] Modules linked in: bridge stp llc vhost_net macvtap
> macvlan dm_crypt iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi
> kvm_intel kvm ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw
> gf128mul glue_helper aes_x86_64 hid_generic eeepc_wmi asus_wmi
> sparse_keymap mxm_wmi led_class dm_multipath microcode usbhid hid
> parport_pc ppdev psmouse e1000e lpc_ich firewire_ohci mfd_core igb
> firewire_core crc_itu_t dca ptp pps_core binfmt_misc wmi lp parport
> video
> [   96.394411] CPU: 1 PID: 2903 Comm: llc Not tainted 3.10.1 #31
> [   96.394412] Hardware name: System manufacturer System Product
> Name/P8Z77 WS, BIOS 3007 07/26/2012
> [   96.394413]  0000000000000009 ffff8807f5ec9328 ffffffff81682103
> ffff8807f5ec9368
> [   96.394415]  ffffffff81045d80 0000000000000082 0000000000000096
> 0000000000000000
> [   96.394416]  0000000000000000 0000000000000003 0000000000000002
> ffff8807f5ec93c8
> [   96.394418] Call Trace:
> [   96.394420]  [<ffffffff81682103>] dump_stack+0x19/0x1b
> [   96.394422]  [<ffffffff81045d80>] warn_slowpath_common+0x70/0xa0
> [   96.394424]  [<ffffffff81045e66>] warn_slowpath_fmt+0x46/0x50
> [   96.394426]  [<ffffffff810b9ac5>] lockdep_trace_alloc+0xc5/0xd0
> [   96.394428]  [<ffffffff81148a7c>] __alloc_pages_nodemask+0x7c/0xa80
> [   96.394430]  [<ffffffff8168a142>] ? retint_signal+0x46/0x84
> [   96.394432]  [<ffffffff810b47e4>] ? __lock_is_held+0x54/0x80
> [   96.394434]  [<ffffffff8132c0cb>] ? radix_tree_lookup_element+0xeb/0x190
> [   96.394437]  [<ffffffff81185098>] alloc_pages_current+0xb8/0x180
> [   96.394439]  [<ffffffff8113ecff>] __page_cache_alloc+0xaf/0xd0
> [   96.394441]  [<ffffffff8113fb6f>] grab_cache_page_write_begin+0x7f/0xf0
> [   96.394443]  [<ffffffff8124fd82>] ext4_da_write_begin+0x92/0x3a0
> [   96.394445]  [<ffffffff8113e32e>] generic_file_buffered_write+0x11e/0x2a0
> [   96.394447]  [<ffffffff811407bd>] __generic_file_aio_write+0x1cd/0x3d0
> [   96.394449]  [<ffffffff816862cf>] ? mutex_lock_nested+0x27f/0x380
> [   96.394451]  [<ffffffff81140a2a>] generic_file_aio_write+0x6a/0xd0
> [   96.394453]  [<ffffffff81245cf9>] ext4_file_write+0xa9/0x450
> [   96.394455]  [<ffffffff81689bdb>] ? _raw_spin_unlock+0x2b/0x50
> [   96.394456]  [<ffffffff81168681>] ? follow_page_mask+0x261/0x4e0
> [   96.394458]  [<ffffffff81165809>] ? spin_unlock+0x9/0x10
> [   96.394459]  [<ffffffff81168866>] ? follow_page_mask+0x446/0x4e0
> [   96.394461]  [<ffffffff8119fcb0>] do_sync_write+0x80/0xb0
> [   96.394463]  [<ffffffff81203d09>] dump_write+0x59/0x70
> [   96.394465]  [<ffffffff811fe3e4>] elf_core_dump+0x1724/0x1930
> [   96.394467]  [<ffffffff811fd6cc>] ? elf_core_dump+0xa0c/0x1930
> [   96.394469]  [<ffffffff811a2f0f>] ? __sb_start_write+0xef/0x1c0
> [   96.394471]  [<ffffffff81205033>] ? do_coredump+0xf83/0x1110
> [   96.394472]  [<ffffffff81205033>] ? do_coredump+0xf83/0x1110
> [   96.394474]  [<ffffffff81204ce9>] do_coredump+0xc39/0x1110
> [   96.394476]  [<ffffffff8105fc02>] get_signal_to_deliver+0x2b2/0x930
> [   96.394479]  [<ffffffff81002387>] do_signal+0x57/0x5a0
> [   96.394480]  [<ffffffff8168df6b>] ? __do_page_fault+0x50b/0x570
> [   96.394482]  [<ffffffff81060434>] ? __set_current_blocked+0x34/0x60
> [   96.394483]  [<ffffffff8167d1f9>] ? printk+0x61/0x63
> [   96.394485]  [<ffffffff810b9495>] ? trace_hardirqs_on_caller+0x105/0x1d0
> [   96.394487]  [<ffffffff810b956d>] ? trace_hardirqs_on+0xd/0x10
> [   96.394488]  [<ffffffff8168a10d>] ? retint_signal+0x11/0x84
> [   96.394490]  [<ffffffff81002935>] do_notify_resume+0x65/0x80
> [   96.394492]  [<ffffffff813349de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   96.394493]  [<ffffffff8168a142>] retint_signal+0x46/0x84
> [   96.394495] ---[ end trace 254c0cab3bbaa900 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
