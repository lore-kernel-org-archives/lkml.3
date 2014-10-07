Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaJGMAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:00:35 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:15393 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbaJGMAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:00:33 -0400
From: Andrey Vagin <avagin@openvz.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH] mnt: don't allow to detach the namespace root
Date: Tue,  7 Oct 2014 16:00:12 +0400
Message-Id: <1412683212-28077-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug, which is triggered by following code:
while (1) {
        if (umount2("/", MNT_DETACH) ||
	    setns(fd, CLONE_NEWNS))
                return break;
}

[  260.548301] ------------[ cut here ]------------
[  260.550941] kernel BUG at /build/buildd/linux-3.13.0/fs/pnode.c:372!
[  260.552068] invalid opcode: 0000 [#1] SMP
[  260.552068] Modules linked in: xt_CHECKSUM iptable_mangle xt_tcpudp xt_addrtype xt_conntrack ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack bridge stp llc dm_thin_pool dm_persistent_data dm_bufio dm_bio_prison iptable_filter ip_tables x_tables crct10dif_pclmul crc32_pclmul ghash_clmulni_intel binfmt_misc nfsd auth_rpcgss nfs_acl aesni_intel nfs lockd aes_x86_64 sunrpc fscache lrw gf128mul glue_helper ablk_helper cryptd serio_raw ppdev parport_pc lp parport btrfs xor raid6_pq libcrc32c psmouse floppy
[  260.552068] CPU: 0 PID: 1723 Comm: nsenter Not tainted 3.13.0-30-generic #55-Ubuntu
[  260.552068] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  260.552068] task: ffff8800376097f0 ti: ffff880074824000 task.ti: ffff880074824000
[  260.552068] RIP: 0010:[<ffffffff811e9483>]  [<ffffffff811e9483>] propagate_umount+0x123/0x130
[  260.552068] RSP: 0018:ffff880074825e98  EFLAGS: 00010246
[  260.552068] RAX: ffff88007c741140 RBX: 0000000000000002 RCX: ffff88007c741190
[  260.552068] RDX: ffff88007c741190 RSI: ffff880074825ec0 RDI: ffff880074825ec0
[  260.552068] RBP: ffff880074825eb0 R08: 00000000000172e0 R09: ffff88007fc172e0
[  260.552068] R10: ffffffff811cc642 R11: ffffea0001d59000 R12: ffff88007c741140
[  260.552068] R13: ffff88007c741140 R14: ffff88007c741140 R15: 0000000000000000
[  260.552068] FS:  00007fd5c7e41740(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[  260.552068] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  260.552068] CR2: 00007fd5c7968050 CR3: 0000000070124000 CR4: 00000000000406f0
[  260.552068] Stack:
[  260.552068]  0000000000000002 0000000000000002 ffff88007c631000 ffff880074825ed8
[  260.552068]  ffffffff811dcfac ffff88007c741140 0000000000000002 ffff88007c741160
[  260.552068]  ffff880074825f38 ffffffff811dd12b ffffffff811cc642 0000000075640000
[  260.552068] Call Trace:
[  260.552068]  [<ffffffff811dcfac>] umount_tree+0x20c/0x260
[  260.552068]  [<ffffffff811dd12b>] do_umount+0x12b/0x300
[  260.552068]  [<ffffffff811cc642>] ? final_putname+0x22/0x50
[  260.552068]  [<ffffffff811cc849>] ? putname+0x29/0x40
[  260.552068]  [<ffffffff811dd88c>] SyS_umount+0xdc/0x100
[  260.552068]  [<ffffffff8172aeff>] tracesys+0xe1/0xe6
[  260.552068] Code: 89 50 08 48 8b 50 08 48 89 02 49 89 45 08 e9 72 ff ff ff 0f 1f 44 00 00 4c 89 e6 4c 89 e7 e8 f5 f6 ff ff 48 89 c3 e9 39 ff ff ff <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 90 66 66 66 66 90 55 b8 01
[  260.552068] RIP  [<ffffffff811e9483>] propagate_umount+0x123/0x130
[  260.552068]  RSP <ffff880074825e98>
[  260.611451] ---[ end trace 11c33d85f1d4c652 ]--

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/namespace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index f50a848..a63e0a9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1363,6 +1363,9 @@ static int do_umount(struct mount *mnt, int flags)
 		return retval;
 	}
 
+	if (!mnt_has_parent(mnt))
+		return -EINVAL;
+
 	namespace_lock();
 	lock_mount_hash();
 	event++;
-- 
1.9.3

