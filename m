Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab3B1OsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:48:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42158 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758217Ab3B1OsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:48:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: fanchaoting <fanchaoting@cn.fujitsu.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 059/139] umount oops when remove blocklayoutdriver first
Date: Thu, 28 Feb 2013 14:43:29 +0000
Message-Id: <1362062689-2567-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: fanchaoting <fanchaoting@cn.fujitsu.com>

commit 5a12cca697aca5dfba42a7d4c3356acc0445a2b0 upstream.

now pnfs client uses block layout, maybe we can remove
blocklayoutdriver first. if we umount later,
it can cause oops in unset_pnfs_layoutdriver.
because nfss->pnfs_curr_ld->clear_layoutdriver is invalid.

reproduce it:
 modprobe  blocklayoutdriver
 mount -t nfs4 -o minorversion=1 pnfsip:/ /mnt/
 rmmod blocklayoutdriver
 umount /mnt

then you can see following

CPU 0
Pid: 17023, comm: umount.nfs4 Tainted: GF          O 3.7.0-rc6-pnfs #1 VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform
RIP: 0010:[<ffffffffa04cfe6d>]  [<ffffffffa04cfe6d>] unset_pnfs_layoutdriver+0x1d/0x70 [nfsv4]
RSP: 0018:ffff8800022d9e48  EFLAGS: 00010286
RAX: ffffffffa04a1b00 RBX: ffff88000b013800 RCX: 0000000000000001
RDX: ffffffff81ae8ee0 RSI: ffff880001ee94b8 RDI: ffff88000b013800
RBP: ffff8800022d9e58 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff880001ee9400
R13: ffff8800105978c0 R14: 00007fff25846c08 R15: 0000000001bba550
FS:  00007f45ae7f0700(0000) GS:ffff880012c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffa04a1b38 CR3: 0000000002c0c000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process umount.nfs4 (pid: 17023, threadinfo ffff8800022d8000, task ffff880006e48aa0)
Stack:
ffff8800105978c0 ffff88000b013800 ffff8800022d9e78 ffffffffa04cd0ce
ffff8800022d9e78 ffff88000b013800 ffff8800022d9ea8 ffffffffa04755a7
ffff8800022d9ea8 ffff880002f96400 ffff88000b013800 ffff880002f96400
Call Trace:
[<ffffffffa04cd0ce>] nfs4_destroy_server+0x1e/0x30 [nfsv4]
[<ffffffffa04755a7>] nfs_free_server+0xb7/0x150 [nfs]
[<ffffffffa047d4d5>] nfs_kill_super+0x35/0x40 [nfs]
[<ffffffff81178d35>] deactivate_locked_super+0x45/0x70
[<ffffffff8117986a>] deactivate_super+0x4a/0x70
[<ffffffff81193ee2>] mntput_no_expire+0xd2/0x130
[<ffffffff81194d62>] sys_umount+0x72/0xe0
[<ffffffff8154af59>] system_call_fastpath+0x16/0x1b
Code: 06 e1 b8 ea ff ff ff eb 9e 0f 1f 44 00 00 55 48 89 e5 53 48 83 ec 08 66 66 66 66 90 48 8b 87 80 03 00 00 48 89 fb 48 85 c0 74 29 <48> 8b 40 38 48 85 c0 74 02 ff d0 48 8b 03 3e ff 48 04 0f 94 c2
RIP  [<ffffffffa04cfe6d>] unset_pnfs_layoutdriver+0x1d/0x70 [nfsv4]
RSP <ffff8800022d9e48>
CR2: ffffffffa04a1b38
---[ end trace 29f75aaedda058bf ]---

Signed-off-by: fanchaoting<fanchaoting@cn.fujitsu.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/blocklayout/blocklayout.c | 1 +
 fs/nfs/objlayout/objio_osd.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 1093968..62f18f7 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -1240,6 +1240,7 @@ static const struct nfs_pageio_ops bl_pg_write_ops = {
 static struct pnfs_layoutdriver_type blocklayout_type = {
 	.id				= LAYOUT_BLOCK_VOLUME,
 	.name				= "LAYOUT_BLOCK_VOLUME",
+	.owner				= THIS_MODULE,
 	.read_pagelist			= bl_read_pagelist,
 	.write_pagelist			= bl_write_pagelist,
 	.alloc_layout_hdr		= bl_alloc_layout_hdr,
diff --git a/fs/nfs/objlayout/objio_osd.c b/fs/nfs/objlayout/objio_osd.c
index f50d3e8..2f45c4f 100644
--- a/fs/nfs/objlayout/objio_osd.c
+++ b/fs/nfs/objlayout/objio_osd.c
@@ -591,6 +591,7 @@ static struct pnfs_layoutdriver_type objlayout_type = {
 	.flags                   = PNFS_LAYOUTRET_ON_SETATTR |
 				   PNFS_LAYOUTRET_ON_ERROR,
 
+	.owner		       	 = THIS_MODULE,
 	.alloc_layout_hdr        = objlayout_alloc_layout_hdr,
 	.free_layout_hdr         = objlayout_free_layout_hdr,
 
-- 
1.8.1.2

