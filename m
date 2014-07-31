Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbaGaHZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:25:08 -0400
Received: from plane.gmane.org ([80.91.229.3]:54481 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbaGaHZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:25:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Aleksei Besogonov <alex.besogonov@gmail.com>
Subject: Soft lockups during reading /proc/PID/smaps
Date: Thu, 31 Jul 2014 07:22:01 +0000 (UTC)
Message-ID: <loom.20140731T091947-310@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 50.184.243.33 (Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Firefox/31.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting weird soft lockups while reading smaps on loaded systems with
some background cgroups usage. This issue can be reproduced with the most
recent kernel.

Here's the stack trace:
[ 1748.312052] BUG: soft lockup - CPU#6 stuck for 23s! [python2.7:1857]
[ 1748.312052] Modules linked in: xfs xt_addrtype xt_conntrack
iptable_filter ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables bridge stp llc
dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c nfsd
auth_rpcgss nfs_acl nfs lockd sunrpc fscache dm_crypt psmouse serio_raw
ppdev parport_pc i2c_piix4 parport xen_fbfront fb_sys_fops syscopyarea
sysfillrect sysimgblt mac_hid isofs raid10 raid456 async_memcpy
async_raid6_recov async_pq async_xor async_tx xor raid6_pq raid1 raid0
multipath linear crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd floppy
[ 1748.312052] CPU: 6 PID: 1857 Comm: python2.7 Not tainted
3.15.5-031505-generic #201407091543
[ 1748.312052] Hardware name: Xen HVM domU, BIOS 4.2.amazon 01/24/2014
[ 1748.312052] task: ffff8800eab41930 ti: ffff8803b9a94000 task.ti:
ffff8803b9a94000
[ 1748.312052] RIP: 0010:[<ffffffff81013111>]  [<ffffffff81013111>]
KSTK_ESP+0x11/0x40
[ 1748.312052] RSP: 0018:ffff8803b9a97c68  EFLAGS: 00000287
[ 1748.312052] RAX: 0000000000000000 RBX: ffff8803b60de3aa RCX: 00007f49ec000000
[ 1748.312052] RDX: 0000000000000001 RSI: ffff8800eba1c730 RDI: ffff880399434b90
[ 1748.312052] RBP: ffff8803b9a97c68 R08: 000000000000000a R09: 000000000000fffe
[ 1748.312052] R10: 0000000000000000 R11: 0000000000000007 R12: 0000000000000001
[ 1748.312052] R13: ffff8803b7a74108 R14: 00007f49ec021000 R15: ffff8803b9a9ffff
[ 1748.312052] FS:  00007fcc9562b740(0000) GS:ffff8803cfcc0000(0000)
knlGS:0000000000000000
[ 1748.312052] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1748.312052] CR2: 00007fcc955ed180 CR3: 00000003b97a5000 CR4: 00000000001406e0
[ 1748.312052] Stack:
[ 1748.312052]  ffff8803b9a97ca8 ffffffff8117bcc9 ffff8803b9a97df8
ffff880399435030
[ 1748.312052]  ffff88003684d000 ffff8800eba1c730 0000000000000000
ffff8803b5dfc980
[ 1748.312052]  ffff8803b9a97d38 ffffffff81236612 ffff88030000002d
00007f4900000070
[ 1748.312052] Call Trace:
[ 1748.312052]  [<ffffffff8117bcc9>] vm_is_stack+0x59/0xe0
[ 1748.312052]  [<ffffffff81236612>] show_map_vma+0x212/0x280
[ 1748.312052]  [<ffffffff81236805>] show_smap+0x85/0x250
[ 1748.312052]  [<ffffffff81237bc0>] ? smaps_pte_entry.isra.21+0x220/0x220
[ 1748.312052]  [<ffffffff81236a03>] show_pid_smap+0x13/0x20
[ 1748.312052]  [<ffffffff811f6016>] seq_read+0x256/0x3e0
[ 1748.312052]  [<ffffffff811d30e1>] vfs_read+0xb1/0x180
[ 1748.312052]  [<ffffffff811d335f>] SyS_read+0x4f/0xb0
[ 1748.312052]  [<ffffffff8178527f>] tracesys+0xe1/0xe6
[ 1748.312052] Code: 89 f8 48 89 f2 89 c6 48 89 e5 65 48 8b 3c 25 c0 c7 00
00 e8 b2 f9 ff ff 5d c3 0f 1f 44 00 00 48 8b 47 08 55 48 89 e5 48 8b 40 10
<a9> 00 00 02 00 75 10 48 8b 87 10 06 00 00 5d c3 0f 1f 80 00 00


