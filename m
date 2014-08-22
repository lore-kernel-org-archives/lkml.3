Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbaHVGU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 02:20:26 -0400
Received: from orion.efm.de ([195.190.148.230]:36100 "EHLO orion.efm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbaHVGUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 02:20:24 -0400
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Aug 2014 02:20:24 EDT
Date: Fri, 22 Aug 2014 08:12:16 +0200 (CEST)
From: Thomas Klaube <thomas@klaube.net>
To: linux-kernel@vger.kernel.org
Message-ID: <300853116.4453628.1408687936240.JavaMail.zimbra@klaube.net>
In-Reply-To: <311901944.4452855.1408687605482.JavaMail.zimbra@klaube.net>
Subject: bcache bug / fs freeze on heavy IO
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - GC27 (Linux)/8.0.5_GA_5839)
Thread-Topic: bcache bug / fs freeze on heavy IO
Thread-Index: vdHmD3Rf2/uanJpiteEsTYSrb/Grqg==
X-GBUdb-Analysis: Unknown
X-MessageSniffer-Scan-Result: 0
X-MessageSniffer-Rules: 0-0-0-28608-c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

while testing/benchmarking with fio on a bcache backed ext4 fs I see
this dmesg output. System is ubuntu 14.04.1 but with vanilla Kernel 3.16.1:

Aug 22 00:57:01 ubuntu kernel: [19115.694955] ------------[ cut here ]------------
Aug 22 00:57:01 ubuntu kernel: [19115.695519] kernel BUG at drivers/md/bcache/btree.c:2053!
Aug 22 00:57:01 ubuntu kernel: [19115.696066] invalid opcode: 0000 [#1] SMP 
Aug 22 00:57:01 ubuntu kernel: [19115.696619] Modules linked in: xfs libcrc32c usb_storage x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul ast ghash_clmulni_intel aesni_intel aes_x86_64 syscopyarea sysfillrect sysimgblt glue_helper mei_me mei drm_kms_helper bonding ttm lpc_ich lrw gf128mul ipmi_si ablk_helper drm video shpchp cryptd acpi_pad hid_generic usbhid hid btrfs xor raid6_pq bcache ses enclosure megaraid_sas e1000e igb i2c_algo_bit dca ptp pps_core [last unloaded: usb_storage]
Aug 22 00:57:01 ubuntu kernel: [19115.699123] CPU: 3 PID: 274 Comm: bcache_gc Not tainted 3.16.1 #4
Aug 22 00:57:01 ubuntu kernel: [19115.699756] Hardware name: Supermicro X10SLM-F/X10SLM-F, BIOS 2.0 04/24/2014
Aug 22 00:57:01 ubuntu kernel: [19115.700387] task: ffff880404d59920 ti: ffff8803cd320000 task.ti: ffff8803cd320000
Aug 22 00:57:01 ubuntu kernel: [19115.701022] RIP: 0010:[<ffffffffa01be195>]  [<ffffffffa01be195>] btree_split+0x4d5/0x6c0 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.701670] RSP: 0018:ffff8803cd3238d8  EFLAGS: 00010283
Aug 22 00:57:01 ubuntu kernel: [19115.702305] RAX: ffff8803cd323970 RBX: ffff88030e82e400 RCX: ffffffffa01d6660
Aug 22 00:57:01 ubuntu kernel: [19115.702942] RDX: 0000000000000000 RSI: 0000000000000200 RDI: ffff8803cd323870
Aug 22 00:57:01 ubuntu kernel: [19115.703577] RBP: ffff8803cd3239e8 R08: 0000000000000000 R09: 0000000000000003
Aug 22 00:57:01 ubuntu kernel: [19115.704205] R10: 0000000000000004 R11: 0000000000000005 R12: ffff8800d7584400
Aug 22 00:57:01 ubuntu kernel: [19115.704829] R13: 0000000000000000 R14: ffff88030e82e4d0 R15: ffff8803cd323e28
Aug 22 00:57:01 ubuntu kernel: [19115.705469] FS:  0000000000000000(0000) GS:ffff88041fd80000(0000) knlGS:0000000000000000
Aug 22 00:57:01 ubuntu kernel: [19115.706085] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Aug 22 00:57:01 ubuntu kernel: [19115.706697] CR2: 00007f3b3938c000 CR3: 0000000001c13000 CR4: 00000000001407e0
Aug 22 00:57:01 ubuntu kernel: [19115.707310] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug 22 00:57:01 ubuntu kernel: [19115.707915] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Aug 22 00:57:01 ubuntu kernel: [19115.708510] Stack:
Aug 22 00:57:01 ubuntu kernel: [19115.709107]  ffff8803cd3238f0 ffff8800d7584498 0000000000000000 ffff8803cd323b20
Aug 22 00:57:01 ubuntu kernel: [19115.709705]  00001162b81ec3bd 0000000000000000 ffff880404d59920 0000000000000000
Aug 22 00:57:01 ubuntu kernel: [19115.710303]  0000000000000000 0000000000000000 00000000a0000001 ffff8803cd323940
Aug 22 00:57:01 ubuntu kernel: [19115.710894] Call Trace:
Aug 22 00:57:01 ubuntu kernel: [19115.711474]  [<ffffffff810a3a94>] ? arch_vtime_task_switch+0x94/0xa0
Aug 22 00:57:01 ubuntu kernel: [19115.712061]  [<ffffffff810a3add>] ? vtime_common_task_switch+0x3d/0x40
Aug 22 00:57:01 ubuntu kernel: [19115.712643]  [<ffffffff8109c528>] ? finish_task_switch+0x128/0x180
Aug 22 00:57:01 ubuntu kernel: [19115.713217]  [<ffffffffa01be62a>] bch_btree_insert_node+0x2aa/0x3b0 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.713791]  [<ffffffffa01bee14>] btree_gc_coalesce.isra.28+0x6e4/0x870 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.714363]  [<ffffffffa01bf2b1>] btree_gc_recurse+0x1b1/0x300 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.714927]  [<ffffffffa01bf19e>] btree_gc_recurse+0x9e/0x300 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.715516]  [<ffffffffa01bf9fb>] bch_btree_gc+0x42b/0x5b0 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.716063]  [<ffffffff810b34e0>] ? prepare_to_wait_event+0x100/0x100
Aug 22 00:57:01 ubuntu kernel: [19115.716605]  [<ffffffffa01bfbb8>] bch_gc_thread+0x38/0x120 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.717155]  [<ffffffffa01bfb80>] ? bch_btree_gc+0x5b0/0x5b0 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.717706]  [<ffffffff8108fb92>] kthread+0xd2/0xf0
Aug 22 00:57:01 ubuntu kernel: [19115.718257]  [<ffffffff8108fac0>] ? kthread_create_on_node+0x180/0x180
Aug 22 00:57:01 ubuntu kernel: [19115.718818]  [<ffffffff8168c7fc>] ret_from_fork+0x7c/0xb0
Aug 22 00:57:01 ubuntu kernel: [19115.719383]  [<ffffffff8108fac0>] ? kthread_create_on_node+0x180/0x180
Aug 22 00:57:01 ubuntu kernel: [19115.719952] Code: 8d 44 c2 10 48 8d 95 48 ff ff ff 48 89 85 50 ff ff ff e8 ff 01 00 00 48 8b 85 50 ff ff ff 48 39 85 48 ff ff ff 0f 84 6c fd ff ff <0f> 0b 66 0f 1f 84 00 00 00 00 00 4c 8b 35 e9 0e 02 00 4d 85 f6 
Aug 22 00:57:01 ubuntu kernel: [19115.721195] RIP  [<ffffffffa01be195>] btree_split+0x4d5/0x6c0 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.721815]  RSP <ffff8803cd3238d8>
Aug 22 00:57:01 ubuntu kernel: [19115.724499] ------------[ cut here ]------------
Aug 22 00:57:01 ubuntu kernel: [19115.725160] kernel BUG at arch/x86/mm/pageattr.c:216!
Aug 22 00:57:01 ubuntu kernel: [19115.725819] invalid opcode: 0000 [#2] SMP 
Aug 22 00:57:01 ubuntu kernel: [19115.726475] Modules linked in: xfs libcrc32c usb_storage x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul ast ghash_clmulni_intel aesni_intel aes_x86_64 syscopyarea sysfillrect sysimgblt glue_helper mei_me mei drm_kms_helper bonding ttm lpc_ich lrw gf128mul ipmi_si ablk_helper drm video shpchp cryptd acpi_pad hid_generic usbhid hid btrfs xor raid6_pq bcache ses enclosure megaraid_sas e1000e igb i2c_algo_bit dca ptp pps_core [last unloaded: usb_storage]
Aug 22 00:57:01 ubuntu kernel: [19115.729293] CPU: 3 PID: 274 Comm: bcache_gc Not tainted 3.16.1 #4
Aug 22 00:57:01 ubuntu kernel: [19115.729962] Hardware name: Supermicro X10SLM-F/X10SLM-F, BIOS 2.0 04/24/2014
Aug 22 00:57:01 ubuntu kernel: [19115.730628] task: ffff880404d59920 ti: ffff8803cd320000 task.ti: ffff8803cd320000
Aug 22 00:57:01 ubuntu kernel: [19115.731292] RIP: 0010:[<ffffffff8105db53>]  [<ffffffff8105db53>] change_page_attr_set_clr+0x433/0x440
Aug 22 00:57:01 ubuntu kernel: [19115.731968] RSP: 0018:ffff8803cd322cc8  EFLAGS: 00010046
Aug 22 00:57:01 ubuntu kernel: [19115.732631] RAX: 0000000000000046 RBX: 0000000000000000 RCX: 0000000000000010
Aug 22 00:57:01 ubuntu kernel: [19115.733292] RDX: 0000000000002000 RSI: 0000000000000000 RDI: 0000000080000000
Aug 22 00:57:01 ubuntu kernel: [19115.733943] RBP: ffff8803cd322d58 R08: 0000000000000001 R09: 0000000000000004
Aug 22 00:57:01 ubuntu kernel: [19115.734591] R10: ffff88041fd94e48 R11: 0000000000000000 R12: 0000000000000000
Aug 22 00:57:01 ubuntu kernel: [19115.735233] R13: 0000000000000010 R14: 0000000000000004 R15: 0000000000000005
Aug 22 00:57:01 ubuntu kernel: [19115.735872] FS:  0000000000000000(0000) GS:ffff88041fd80000(0000) knlGS:0000000000000000
Aug 22 00:57:01 ubuntu kernel: [19115.736518] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Aug 22 00:57:01 ubuntu kernel: [19115.737159] CR2: 00007f3b3938c000 CR3: 0000000001c13000 CR4: 00000000001407e0
Aug 22 00:57:01 ubuntu kernel: [19115.737803] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug 22 00:57:01 ubuntu kernel: [19115.738441] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Aug 22 00:57:01 ubuntu kernel: [19115.739075] Stack:
Aug 22 00:57:01 ubuntu kernel: [19115.739708]  ffff8803cd322d08 0000000000000000 0000000000000000 0000000000000200
Aug 22 00:57:01 ubuntu kernel: [19115.740360]  0000000000000008 0000000000000000 0000000000000000 0000000000000010
Aug 22 00:57:01 ubuntu kernel: [19115.741000]  0000000000000000 0000000500000001 00000000000ccb18 0000020000000000
Aug 22 00:57:01 ubuntu kernel: [19115.741631] Call Trace:
Aug 22 00:57:01 ubuntu kernel: [19115.742253]  [<ffffffff8105dea6>] _set_pages_array+0xe6/0x130
Aug 22 00:57:01 ubuntu kernel: [19115.742879]  [<ffffffff8105df23>] set_pages_array_wc+0x13/0x20
Aug 22 00:57:01 ubuntu kernel: [19115.743501]  [<ffffffffa017627f>] ttm_set_pages_caching+0x2f/0x70 [ttm]
Aug 22 00:57:01 ubuntu kernel: [19115.744125]  [<ffffffffa017637c>] ttm_alloc_new_pages.isra.6+0xbc/0x190 [ttm]
Aug 22 00:57:01 ubuntu kernel: [19115.744757]  [<ffffffffa0176c73>] ttm_pool_populate+0x3c3/0x4d0 [ttm]
Aug 22 00:57:01 ubuntu kernel: [19115.745379]  [<ffffffffa035bcbe>] ast_ttm_tt_populate+0xe/0x10 [ast]
Aug 22 00:57:01 ubuntu kernel: [19115.746000]  [<ffffffffa0173781>] ttm_bo_move_memcpy+0x5d1/0x680 [ttm]
Aug 22 00:57:01 ubuntu kernel: [19115.746585]  [<ffffffffa035bc68>] ast_bo_move+0x18/0x20 [ast]
Aug 22 00:57:01 ubuntu kernel: [19115.747173]  [<ffffffffa0170e75>] ttm_bo_handle_move_mem+0x265/0x5b0 [ttm]
Aug 22 00:57:01 ubuntu kernel: [19115.747762]  [<ffffffffa0171836>] ? ttm_bo_mem_space+0x116/0x340 [ttm]
Aug 22 00:57:01 ubuntu kernel: [19115.748353]  [<ffffffffa0171f2f>] ttm_bo_validate+0x21f/0x230 [ttm]
Aug 22 00:57:01 ubuntu kernel: [19115.748940]  [<ffffffffa035c4a2>] ast_bo_push_sysram+0x82/0xe0 [ast]
Aug 22 00:57:01 ubuntu kernel: [19115.749527]  [<ffffffffa0359f25>] ast_crtc_do_set_base.isra.14.constprop.24+0x75/0x350 [ast]
Aug 22 00:57:01 ubuntu kernel: [19115.750134]  [<ffffffffa035acf4>] ast_crtc_mode_set+0xaf4/0xc50 [ast]
Aug 22 00:57:01 ubuntu kernel: [19115.750728]  [<ffffffffa03288c9>] drm_crtc_helper_set_mode+0x2b9/0x4f0 [drm_kms_helper]
Aug 22 00:57:01 ubuntu kernel: [19115.751328]  [<ffffffffa032964f>] drm_crtc_helper_set_config+0x87f/0xaa0 [drm_kms_helper]
Aug 22 00:57:01 ubuntu kernel: [19115.751929]  [<ffffffff8168a31b>] ? __ww_mutex_lock+0x1b/0x97
Aug 22 00:57:01 ubuntu kernel: [19115.752521]  [<ffffffffa01143b1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
Aug 22 00:57:01 ubuntu kernel: [19115.753100]  [<ffffffffa032c354>] drm_fb_helper_pan_display+0x94/0xf0 [drm_kms_helper]
Aug 22 00:57:01 ubuntu kernel: [19115.753675]  [<ffffffff813d87f9>] fb_pan_display+0xc9/0x190
Aug 22 00:57:01 ubuntu kernel: [19115.754245]  [<ffffffff813d2950>] bit_update_start+0x20/0x50
Aug 22 00:57:01 ubuntu kernel: [19115.754815]  [<ffffffff813d2402>] fbcon_switch+0x3a2/0x550
Aug 22 00:57:01 ubuntu kernel: [19115.755382]  [<ffffffff8145fcf9>] redraw_screen+0x189/0x240
Aug 22 00:57:01 ubuntu kernel: [19115.755987]  [<ffffffff813d89ee>] ? fb_blank+0x9e/0xc0
Aug 22 00:57:01 ubuntu kernel: [19115.756551]  [<ffffffff813cf99a>] fbcon_blank+0x20a/0x2d0
Aug 22 00:57:01 ubuntu kernel: [19115.757097]  [<ffffffff810c6af4>] ? wake_up_klogd+0x34/0x50
Aug 22 00:57:01 ubuntu kernel: [19115.757625]  [<ffffffff810c6d08>] ? console_unlock+0x1f8/0x440
Aug 22 00:57:01 ubuntu kernel: [19115.758140]  [<ffffffff8107902b>] ? lock_timer_base.isra.34+0x2b/0x50
Aug 22 00:57:01 ubuntu kernel: [19115.758637]  [<ffffffff810787ff>] ? internal_add_timer+0x2f/0x70
Aug 22 00:57:01 ubuntu kernel: [19115.759128]  [<ffffffff8107acea>] ? mod_timer+0x12a/0x1e0
Aug 22 00:57:01 ubuntu kernel: [19115.759610]  [<ffffffff81460818>] do_unblank_screen+0xb8/0x1f0
Aug 22 00:57:01 ubuntu kernel: [19115.760082]  [<ffffffff81460960>] unblank_screen+0x10/0x20
Aug 22 00:57:01 ubuntu kernel: [19115.760544]  [<ffffffff813798d9>] bust_spinlocks+0x19/0x40
Aug 22 00:57:01 ubuntu kernel: [19115.761000]  [<ffffffff81016918>] oops_end+0x38/0x150
Aug 22 00:57:01 ubuntu kernel: [19115.761462]  [<ffffffff81016d3b>] die+0x4b/0x70
Aug 22 00:57:01 ubuntu kernel: [19115.761917]  [<ffffffff81013300>] do_trap+0xb0/0x150
Aug 22 00:57:01 ubuntu kernel: [19115.762374]  [<ffffffff81013967>] do_error_trap+0x97/0x150
Aug 22 00:57:01 ubuntu kernel: [19115.762835]  [<ffffffffa01be195>] ? btree_split+0x4d5/0x6c0 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.763299]  [<ffffffff8101c1a5>] ? native_sched_clock+0x35/0x90
Aug 22 00:57:01 ubuntu kernel: [19115.763755]  [<ffffffff8101c209>] ? sched_clock+0x9/0x10
Aug 22 00:57:01 ubuntu kernel: [19115.764200]  [<ffffffff810a2ec5>] ? sched_clock_cpu+0x85/0xc0
Aug 22 00:57:01 ubuntu kernel: [19115.764645]  [<ffffffffa01bb312>] ? bch_btree_insert_keys+0x72/0x200 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.765098]  [<ffffffff81013fe0>] do_invalid_op+0x20/0x30
Aug 22 00:57:01 ubuntu kernel: [19115.765552]  [<ffffffff8168e35e>] invalid_op+0x1e/0x30
Aug 22 00:57:01 ubuntu kernel: [19115.766023]  [<ffffffffa01be195>] ? btree_split+0x4d5/0x6c0 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.766475]  [<ffffffffa01be181>] ? btree_split+0x4c1/0x6c0 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.766919]  [<ffffffff810a3a94>] ? arch_vtime_task_switch+0x94/0xa0
Aug 22 00:57:01 ubuntu kernel: [19115.767384]  [<ffffffff810a3add>] ? vtime_common_task_switch+0x3d/0x40
Aug 22 00:57:01 ubuntu kernel: [19115.767870]  [<ffffffff8109c528>] ? finish_task_switch+0x128/0x180
Aug 22 00:57:01 ubuntu kernel: [19115.768342]  [<ffffffffa01be62a>] bch_btree_insert_node+0x2aa/0x3b0 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.768771]  [<ffffffffa01bee14>] btree_gc_coalesce.isra.28+0x6e4/0x870 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.769212]  [<ffffffffa01bf2b1>] btree_gc_recurse+0x1b1/0x300 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.769659]  [<ffffffffa01bf19e>] btree_gc_recurse+0x9e/0x300 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.770099]  [<ffffffffa01bf9fb>] bch_btree_gc+0x42b/0x5b0 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.770533]  [<ffffffff810b34e0>] ? prepare_to_wait_event+0x100/0x100
Aug 22 00:57:01 ubuntu kernel: [19115.770971]  [<ffffffffa01bfbb8>] bch_gc_thread+0x38/0x120 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.771441]  [<ffffffffa01bfb80>] ? bch_btree_gc+0x5b0/0x5b0 [bcache]
Aug 22 00:57:01 ubuntu kernel: [19115.771919]  [<ffffffff8108fb92>] kthread+0xd2/0xf0
Aug 22 00:57:01 ubuntu kernel: [19115.772380]  [<ffffffff8108fac0>] ? kthread_create_on_node+0x180/0x180
Aug 22 00:57:01 ubuntu kernel: [19115.772806]  [<ffffffff8168c7fc>] ret_from_fork+0x7c/0xb0
Aug 22 00:57:01 ubuntu kernel: [19115.773225]  [<ffffffff8108fac0>] ? kthread_create_on_node+0x180/0x180
Aug 22 00:57:01 ubuntu kernel: [19115.773645] Code: ff ff 48 8b 4d 80 e9 9f fc ff ff 0f 0b 0f 0b be ba 00 00 00 48 c7 c7 09 99 a2 81 89 4d 80 e8 95 ed 00 00 8b 4d 80 e9 04 ff ff ff <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 
Aug 22 00:57:01 ubuntu kernel: [19115.774598] RIP  [<ffffffff8105db53>] change_page_attr_set_clr+0x433/0x440
Aug 22 00:57:01 ubuntu kernel: [19115.775044]  RSP <ffff8803cd322cc8>
Aug 22 00:57:01 ubuntu kernel: [19115.775494] ---[ end trace 658339f61e40f6ce ]---

Is bcache considered stable in 3.16 kernel? Is there anything I
could do to debug? I had also problems with xfs on top of bcache. 


Thanx and Regards
Thomas Klaube
