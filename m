Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750760Ab3HSDcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 23:32:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35355 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3HSDcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 23:32:47 -0400
MIME-Version: 1.0
Date: Mon, 19 Aug 2013 11:32:44 +0800
Message-ID: <CACVXFVMV-A5FUU4VuXX0QvWP6jHDqu70QwRL53tJwVfxR589Pw@mail.gmail.com>
Subject: cgroup/next tree: reference to uninitialized percpu ref
From: Ming Lei <ming.lei@canonical.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The kernel oops[1] is triggered during kernel boot with the latest next
tree(3.11.0-rc5-next-20130816), looks it is caused by reference to uninitialized
percpu ref of root cgroup, and below patch can fix the problem:

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 723194f..0e8954b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4485,7 +4485,8 @@ static long cgroup_create(struct cgroup *parent,
struct dentry *dentry,
  struct cgroup_subsys_state *css = css_ar[ss->subsys_id];

  dget(dentry);
- percpu_ref_get(&css->parent->refcnt);
+ if (!(css->parent->flags & CSS_ROOT))
+ percpu_ref_get(&css->parent->refcnt);
  }

  /* hold a ref to the parent's dentry */



[1], oops log:
[    3.155985] Unable to handle kernel paging request at virtual
address 011bb000
[    3.163083] pgd = ee864000
[    3.165715] [011bb000] *pgd=00000000
[    3.169219] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[    3.174428] Modules linked in: ipv6
[    3.177844] CPU: 1 PID: 1 Comm: systemd Not tainted
3.11.0-rc5-next-20130816+ #237
[    3.185280] task: ef00e400 ti: ef09c000 task.ti: ef09c000
[    3.190573] PC is at cgroup_mkdir+0x324/0x5a0
[    3.194841] LR is at cgroup_mkdir+0x314/0x5a0
[    3.199114] pc : [<c00742c8>]    lr : [<c00742b8>]    psr: 40010013
[    3.199114] sp : ef09def8  ip : 00000000  fp : ee8e0000
[    3.210393] r10: c064b4e4  r9 : ef09c000  r8 : c064b528
[    3.215511] r7 : c064b4dc  r6 : ee8e0018  r5 : eed1f880  r4 : eebf2c00
[    3.221918] r3 : 011bb000  r2 : ef09de78  r1 : 60010013  r0 : 00000030
[    3.228326] Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[    3.235329] Control: 10c5387d  Table: 6e86406a  DAC: 00000015
[    3.240964] Process systemd (pid: 1, stack limit = 0xef09c238)
[    3.246687] Stack: (0xef09def8 to 0xef09e000)
[    3.250956] dee0:
    000000d0 eef837f8
[    3.258993] df00: 180fb270 00000000 eeb75023 ee8e000c eed1f8d4
ee8e0130 00000000 00000000
[    3.267020] df20: eea1fa80 ef0de880 00000000 00000000 00000000
00000000 00000003 00000000
[    3.275049] df40: eefe2d70 eed1f880 000001ed ffffff9c ef09c000
0011be80 be9814ac c00ec0bc
[    3.283077] df60: eefe2d70 eed1f880 000001ed eed1f880 00000002
000001ed 00000027 c00efb74
[    3.291106] df80: ef2ebc10 eef837f8 000001ed 0011be80 000001ed
000cc730 00000027 c000e048
[    3.299135] dfa0: 00000000 c000dea0 0011be80 000001ed 0011be80
000001ed 00000001 00000000
[    3.307164] dfc0: 0011be80 000001ed 000cc730 00000027 000d7202
ffffffef 0011be80 be9814ac
[    3.315192] dfe0: 000cc03c be9813bc 00055280 b6d6769c 60010010
0011be80 fffdffff ffffffff
[    3.323225] [<c00742c8>] (cgroup_mkdir+0x324/0x5a0) from
[<c00ec0bc>] (vfs_mkdir+0x88/0xc8)
[    3.331424] [<c00ec0bc>] (vfs_mkdir+0x88/0xc8) from [<c00efb74>]
(SyS_mkdirat+0x6c/0xa0)
[    3.339369] [<c00efb74>] (SyS_mkdirat+0x6c/0xa0) from [<c000dea0>]
(ret_fast_syscall+0x0/0x30)
[    3.347821] Code: e59dc00c e31c0003 1a000004 ee1d3f90 (e793200c)
[    3.353817] ---[ end trace ea0a2516971df41f ]---

Thanks,
--
Ming Lei
