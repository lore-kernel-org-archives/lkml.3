Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab3KLOnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:43:09 -0500
Received: from hosting.visp.net.lb ([194.146.153.11]:36498 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826Ab3KLOnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:43:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 12 Nov 2013 16:34:07 +0200
From: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 3.12 BUG() on ext4, kernel crash on nbd-client when nbd server
 rebooting
Message-ID: <8bf7c5db475eefcf17976a36f892200d@visp.net.lb>
User-Agent: VISP Webmail/0.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I just did some fault testing for test nbd setup, and found that if i 
reboot nbd server i will get immediately BUG() message on nbd client and 
filesystem that i cannot unmount, and any operations on it will freeze 
and lock processes trying to access it.

Kernel 3.12, x86_64

Please let me know if you need more information

Here is dmesg contents i got:
[  102.269270] block nbd1: Receive control failed (result -32)
[  102.269443] block nbd1: shutting down socket
[  102.269461] block nbd1: queue cleared
[  102.269859] block nbd2: Receive control failed (result -32)
[  102.269873] block nbd2: shutting down socket
[  102.269883] block nbd2: queue cleared
[  102.271353] block nbd0: Receive control failed (result -32)
[  102.271518] block nbd0: shutting down socket
[  102.271536] block nbd0: queue cleared
[  106.297217] block nbd0: Attempted send on closed socket
[  106.297219] end_request: I/O error, dev nbd0, sector 73992
[  106.297226] EXT4-fs warning (device nbd0): __ext4_read_dirblock:908: 
error reading directory block (ino 2, block 0)
[  106.297233] block nbd0: Attempted send on closed socket
[  106.297235] end_request: I/O error, dev nbd0, sector 8456
[  106.297245] ------------[ cut here ]------------
[  106.297343] kernel BUG at fs/buffer.c:3015!
[  106.297438] invalid opcode: 0000 [#1] SMP
[  106.297716] Modules linked in: nbd act_mirred cls_u32 sch_ingress 
sch_htb iptable_filter i2c_i801
[  106.298568] CPU: 0 PID: 2587 Comm: ls Not tainted 3.12.0noc-02 #1
[  106.298665] Hardware name:                  /DH55TC, BIOS 
TCIBX10H.86A.0037.2010.0614.1712 06/14/2010
[  106.298772] task: ffff880231da9770 ti: ffff880231cd4000 task.ti: 
ffff880231cd4000
[  106.298879] RIP: 0010:[<ffffffff811253e0>]  [<ffffffff811253e0>] 
_submit_bh+0x26/0x1d3
[  106.299078] RSP: 0018:ffff880231cd5b48  EFLAGS: 00010246
[  106.299182] RAX: 0000000000000005 RBX: ffff8800b7456b60 RCX: 
0000000000000008
[  106.299285] RDX: 0000000000000000 RSI: ffff8800b7456b60 RDI: 
0000000000000411
[  106.299388] RBP: ffff880231cd5b68 R08: 0000000000000040 R09: 
ffffffff81a9a370
[  106.299487] R10: ffffffff810c0d61 R11: 0000000000000000 R12: 
0000000000000411
[  106.299590] R13: ffff880231b21400 R14: 0000000000000000 R15: 
000000000aea9ff5
[  106.299697] FS:  00007f4f0d755700(0000) GS:ffff88023fc00000(0000) 
knlGS:0000000000000000
[  106.299800] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  106.300114] CR2: 00000000022275c8 CR3: 0000000235538000 CR4: 
00000000000007f0
[  106.300438] Stack:
[  106.300750]  ffff8800b7456b60 0000000000000411 ffff880231b21400 
0000000000000001
[  106.301652]  ffff880231cd5b78 ffffffff81125598 ffff880231cd5ba8 
ffffffff8112761a
[  106.307886]  ffff880231cd5bb8 ffffffff81293a72 ffff8800b7456b60 
ffff8802358d4800
[  106.308794] Call Trace:
[  106.309105]  [<ffffffff81125598>] submit_bh+0xb/0xd
[  106.309419]  [<ffffffff8112761a>] __sync_dirty_buffer+0x53/0x86
[  106.309736]  [<ffffffff81293a72>] ? __percpu_counter_sum+0x4d/0x63
[  106.310058]  [<ffffffff8112765b>] sync_dirty_buffer+0xe/0x10
[  106.310368]  [<ffffffff81191327>] ext4_commit_super+0x19e/0x1e7
[  106.310687]  [<ffffffff8119230f>] save_error_info+0x1e/0x22
[  106.311002]  [<ffffffff811925a4>] __ext4_error_inode+0x52/0x10b
[  106.311326]  [<ffffffff81060bbd>] ? __cond_resched+0x25/0x30
[  106.311634]  [<ffffffff8117b4ee>] __ext4_get_inode_loc+0x310/0x336
[  106.311954]  [<ffffffff8117cc0f>] ? ext4_dirty_inode+0x3b/0x54
[  106.312277]  [<ffffffff8117b60a>] ext4_get_inode_loc+0x17/0x19
[  106.312596]  [<ffffffff8117b62d>] ext4_reserve_inode_write+0x21/0x7e
[  106.312916]  [<ffffffff811b3288>] ? jbd2__journal_start+0xe0/0x199
[  106.313229]  [<ffffffff8117ca57>] ext4_mark_inode_dirty+0x67/0x1e4
[  106.313549]  [<ffffffff8117cbf9>] ? ext4_dirty_inode+0x25/0x54
[  106.313861]  [<ffffffff8117cc0f>] ext4_dirty_inode+0x3b/0x54
[  106.314177]  [<ffffffff81121010>] __mark_inode_dirty+0x60/0x224
[  106.314493]  [<ffffffff811130be>] update_time+0x99/0xa2
[  106.314807]  [<ffffffff81113381>] touch_atime+0xf1/0x126
[  106.315117]  [<ffffffff8110db84>] iterate_dir+0x87/0xaa
[  106.315439]  [<ffffffff8110dd01>] SyS_getdents+0x85/0xd0
[  106.315757]  [<ffffffff8110da28>] ? SyS_ioctl+0x80/0x80
[  106.316081]  [<ffffffff815a2f62>] system_call_fastpath+0x16/0x1b
[  106.316399] Code: 00 5f 5b c9 c3 55 48 89 e5 41 56 49 89 d6 41 55 41 
54 41 89 fc 53 48 89 f3 48 8b 06 a8 04 75 04 0f 0b eb fe 48 8b 06 a8 20 
75 04 <0f> 0b eb fe 48 83 7e 38 00 75 04 0f 0b eb fe 48 8b 06 f6 c4 02
[  106.323170] RIP  [<ffffffff811253e0>] _submit_bh+0x26/0x1d3
[  106.323579]  RSP <ffff880231cd5b48>
[  106.323983] ---[ end trace 205f692f3e0cfed7 ]---
[  111.834648] ------------[ cut here ]------------
[  111.834975] kernel BUG at fs/buffer.c:3015!
[  111.835283] invalid opcode: 0000 [#2] SMP
[  111.835837] Modules linked in: nbd act_mirred cls_u32 sch_ingress 
sch_htb iptable_filter i2c_i801
[  111.837121] CPU: 3 PID: 2578 Comm: jbd2/nbd0-8 Tainted: G      D      
3.12.0noc-02 #1
[  111.837656] Hardware name:                  /DH55TC, BIOS 
TCIBX10H.86A.0037.2010.0614.1712 06/14/2010
[  111.838193] task: ffff88023574f530 ti: ffff8800b727a000 task.ti: 
ffff8800b727a000
[  111.838741] RIP: 0010:[<ffffffff811253e0>]  [<ffffffff811253e0>] 
_submit_bh+0x26/0x1d3
[  111.839372] RSP: 0018:ffff8800b727bbb8  EFLAGS: 00010246
[  111.839688] RAX: 0000000004000005 RBX: ffff8800b7452750 RCX: 
0000000000000411
[  111.840005] RDX: 0000000000000000 RSI: ffff8800b7452750 RDI: 
0000000000000411
[  111.840325] RBP: ffff8800b727bbd8 R08: ffff8800b727a000 R09: 
ffffffff81a58ea0
[  111.840634] R10: ffff88023fc6d500 R11: ffff8802360dfed8 R12: 
0000000000000411
[  111.840954] R13: 0000000000000411 R14: 0000000000000000 R15: 
ffff88023574f530
[  111.841271] FS:  0000000000000000(0000) GS:ffff88023fc60000(0000) 
knlGS:0000000000000000
[  111.841816] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  111.842130] CR2: 00007ff5bae1b0c0 CR3: 0000000001a0b000 CR4: 
00000000000007e0
[  111.842441] Stack:
[  111.842768]  ffff8800b7452750 ffff8802358d5800 0000000000000411 
ffff8800b4c1b000
[  111.843684]  ffff8800b727bbe8 ffffffff81125598 ffff8800b727bc28 
ffffffff811bb44a
[  111.844594]  ffff880237004a60 ffff8802358d5800 ffff8800b4c1b000 
ffff8800b727be58
[  111.845540] Call Trace:
[  111.845860]  [<ffffffff81125598>] submit_bh+0xb/0xd
[  111.846171]  [<ffffffff811bb44a>] jbd2_write_superblock+0xac/0xfa
[  111.846487]  [<ffffffff811bbc0b>] 
jbd2_journal_update_sb_log_tail+0x31/0x64
[  111.846811]  [<ffffffff811b4a56>] 
jbd2_journal_commit_transaction+0xa2/0x14d0
[  111.847129]  [<ffffffff81064f92>] ? idle_balance+0xdc/0x109
[  111.847453]  [<ffffffff8159b5b7>] ? __schedule+0x55f/0x591
[  111.847834]  [<ffffffff81043162>] ? lock_timer_base+0x27/0x4d
[  111.848145]  [<ffffffff811ba10e>] kjournald2+0xc8/0x23a
[  111.848469]  [<ffffffff8105493e>] ? wake_up_bit+0x25/0x25
[  111.848775]  [<ffffffff811ba046>] ? commit_timeout+0xb/0xb
[  111.849155]  [<ffffffff81054395>] kthread+0xb0/0xb8
[  111.849473]  [<ffffffff810542e5>] ? 
kthread_freezable_should_stop+0x60/0x60
[  111.849780]  [<ffffffff815a2ebc>] ret_from_fork+0x7c/0xb0
[  111.850099]  [<ffffffff810542e5>] ? 
kthread_freezable_should_stop+0x60/0x60
[  111.850418] Code: 00 5f 5b c9 c3 55 48 89 e5 41 56 49 89 d6 41 55 41 
54 41 89 fc 53 48 89 f3 48 8b 06 a8 04 75 04 0f 0b eb fe 48 8b 06 a8 20 
75 04 <0f> 0b eb fe 48 83 7e 38 00 75 04 0f 0b eb fe 48 8b 06 f6 c4 02
[  111.857588] RIP  [<ffffffff811253e0>] _submit_bh+0x26/0x1d3
[  111.858064]  RSP <ffff8800b727bbb8>
[  111.858448] ---[ end trace 205f692f3e0cfed8 ]---

