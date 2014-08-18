Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaHRVA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 17:00:28 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:48382 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaHRVAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 17:00:25 -0400
Date: Mon, 18 Aug 2014 13:58:26 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Felipe Balbi <balbi@ti.com>
cc: "Eric W. Biederman" <ebiederman@twitter.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: Lock Directory failure
In-Reply-To: <20140818163209.GJ9662@saruman.home>
Message-ID: <alpine.LSU.2.11.1408181350260.1127@eggly.anvils>
References: <20140818163209.GJ9662@saruman.home>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2014, Felipe Balbi wrote:
> Hi folks,
> 
> with today's Linux next I keep getting below kernel error rather
> frequently with my beagle bone black (ARM Cortex A8):
> 
> [    5.096203] systemd[1]: Mounting User Runtime Directory...
>          Mounting User Runtime Directory...
> [    5.135060] systemd[1]: Mounting Lock Directory...
>          Mounting Lock Directory...
> [    5.183453] systemd[1]: Started Various fixups to make systemd work better on Debian.
> [    5.248340] systemd[1]: Starting Load Random Seed...
> [    5.295601] Unable to handle kernel paging request at virtual address 6c617578
> [    5.303340] pgd = de5c0000
> [    5.306169] [6c617578] *pgd=00000000
> [    5.309969] Internal error: Oops: 805 [#1] SMP ARM
> [    5.314972] Modules linked in:
> [    5.318170] CPU: 0 PID: 1092 Comm: mount Not tainted 3.17.0-rc1-next-20140818-00002-gd236526 #636
> [    5.327433] task: de6d0dc0 ti: de350000 task.ti: de350000
> [    5.333082] PC is at mnt_set_mountpoint+0x80/0x94
> [    5.337996] LR is at _raw_spin_unlock+0x20/0x24
> [    5.342723] pc : [<c0148114>]    lr : [<c0564f84>]    psr: 20000013
> [    5.342723] sp : de351eb8  ip : 00000000  fp : 00000000
> [    5.354705] r10: de024dc0  r9 : de250740  r8 : c01487ac
> [    5.360157] r7 : de024dc0  r6 : ddd44468  r5 : de1ecc40  r4 : de250740
> [    5.366969] r3 : 6c617574  r2 : de1eccb8  r1 : de6d0dc0  r0 : ddd444c8
> [    5.373783] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [    5.381230] Control: 10c5387d  Table: 9e5c0019  DAC: 00000015
> [    5.387226] Process mount (pid: 1092, stack limit = 0xde350248)
> [    5.393405] Stack: (0xde351eb8 to 0xde352000)
> [    5.397952] 1ea0:                                                       de1ecc68 de1ecc40
> [    5.406490] 1ec0: de1ecc40 00000000 c0824380 c0148690 00000001 00000000 c01487ac 00000000
> [    5.415028] 1ee0: ddd44468 00000000 de022000 de1ecc40 de250740 de351f38 00000027 de6a7180
> [    5.423567] 1f00: de151740 00000000 00000000 c01487ac 00000008 00000027 c087c3c0 de1ecc50
> [    5.432105] 1f20: c0874cc0 c0149864 de6ae000 de6ae000 000250d8 c0080d4c de024dd0 ddd44468
> [    5.440644] 1f40: de6aefff 00000000 21977150 00001000 de351f8c 00000000 de1e1000 000250b8
> [    5.449182] 1f60: c0ed000e c000e604 de350000 00000000 000250d8 c014a52c de6ae000 00000006
> [    5.457720] 1f80: c000e604 de151740 de6a7180 de6ae000 c0ed000e 00025150 00023548 c0ed000e
> [    5.466259] 1fa0: 00000015 c000e440 00025150 00023548 000250b8 000250c8 000250d8 c0ed000e
> [    5.474797] 1fc0: 00025150 00023548 c0ed000e 00000015 be8deb7c 00000000 00025150 000250d8
> [    5.483335] 1fe0: b6e125f0 be8deaf8 0000c708 b6e12600 60000010 000250b8 00000000 00000000
> [    5.491887] [<c0148114>] (mnt_set_mountpoint) from [<c0148690>] (attach_recursive_mnt+0x278/0x294)
> [    5.501244] [<c0148690>] (attach_recursive_mnt) from [<c01487ac>] (do_add_mount+0x90/0xd8)
> [    5.509875] [<c01487ac>] (do_add_mount) from [<c0149864>] (do_mount+0x234/0xb78)
> [    5.517599] [<c0149864>] (do_mount) from [<c014a52c>] (SyS_mount+0x84/0xb8)
> [    5.524877] [<c014a52c>] (SyS_mount) from [<c000e440>] (ret_fast_syscall+0x0/0x48)
> [    5.532783] Code: e594300c e2852078 e3530000 e5853078 (15832004) 
> [    5.539224] ---[ end trace 29fe002647800da6 ]---
> 
> since that's mounted as tmpfs, adding Hugh

[PATCH next] vfs: initialize m_list to fix crash in mnt_set_mountpoint

Fix mnt_set_mountpoint() crash: new_mountpoint() must initialize m_list.

Reported-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
---

 fs/namespace.c |    1 +
 1 file changed, 1 insertion(+)

--- 3.17-rc1-next/fs/namespace.c	2014-08-18 12:26:26.619992661 -0700
+++ linux/fs/namespace.c	2014-08-18 13:02:42.948389147 -0700
@@ -738,6 +738,7 @@ static struct mountpoint *new_mountpoint
 
 	mp->m_dentry = dentry;
 	mp->m_count = 1;
+	INIT_HLIST_HEAD(&mp->m_list);
 	hlist_add_head(&mp->m_hash, chain);
 	return mp;
 }
