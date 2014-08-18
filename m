Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaHRLJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:09:27 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:60783 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaHRLJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:09:24 -0400
MIME-Version: 1.0
Date: Mon, 18 Aug 2014 13:09:24 +0200
Message-ID: <CACmBeS1kB4+=CZAtkDkM7F48m3SDgutGWGDHgPWVYDRmsDXBJw@mail.gmail.com>
Subject: fs: panic in mnt_set_mountpoint
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've run into a kernel panic [1] in next-20140818 you might find interesting.

It surprised me because there was never an error in next-20140815, I
did a search for related panics but it came up empty.

The board boots fine after applying the following:

diff --git a/fs/namespace.c b/fs/namespace.c
index 1a2bbef..b408a9d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -746,7 +746,7 @@ static void put_mountpoint(struct mountpoint *mp)
 {
        if (!--mp->m_count) {
                struct dentry *dentry = mp->m_dentry;
-               BUG_ON(!hlist_empty(&mp->m_list));
+/*             BUG_ON(!hlist_empty(&mp->m_list));*/
                spin_lock(&dentry->d_lock);
                dentry->d_flags &= ~DCACHE_MOUNTED;
                spin_unlock(&dentry->d_lock);
@@ -810,7 +810,7 @@ void mnt_set_mountpoint(struct mount *mnt,
        child_mnt->mnt_mountpoint = dget(mp->m_dentry);
        child_mnt->mnt_parent = mnt;
        child_mnt->mnt_mp = mp;
-       hlist_add_head(&child_mnt->mnt_mp_list, &mp->m_list);
+/*     hlist_add_head(&child_mnt->mnt_mp_list, &mp->m_list);*/
 }


[1]
Uncompressing Linux... done, booting the kernel.
[ 0.000000] Booting Linux on physical CPU 0x0
[ 0.000000] Linux version 3.17.0-rc1-next-20140818+ (i@Ildjarn) (gcc
version 4.9.0 (crosstool-NG 1.19.0) ) #2691 PREEMPT Mon Aug 18
10:58:16 CEST 2014
[ 0.000000] CPU: FA526 [66015261] revision 1 (ARMv4), cr=0000397f
[ 0.000000] CPU: VIVT data cache, VIVT instruction cache
[ 0.000000] Machine model: MOXA UC-7112-LX
[ 0.000000] bootconsole [earlycon0] enabled
[ 0.000000] Memory policy: Data cache writeback
[ 0.000000] On node 0 totalpages: 8192
[ 0.000000] free_area_init_node: node 0, pgdat c035cfb4, node_mem_map c1fba000
[ 0.000000] Normal zone: 64 pages used for memmap
[ 0.000000] Normal zone: 0 pages reserved
[ 0.000000] Normal zone: 8192 pages, LIFO batch:0
[ 0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[ 0.000000] pcpu-alloc: [0] 0
[ 0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 8128
[ 0.000000] Kernel command line: console=ttyS0,115200n8 earlyprintk
root=/dev/mmcblk0p1 rw rootwait debug
[ 0.000000] PID hash table entries: 128 (order: -3, 512 bytes)
[ 0.000000] Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
[ 0.000000] Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
[ 0.000000] Memory: 28852K/32768K available (2718K kernel code, 93K
rwdata, 484K rodata, 115K init, 126K bss, 3916K reserved)
[ 0.000000] Virtual kernel memory layout:
[ 0.000000] vector : 0xffff0000 - 0xffff1000 ( 4 kB)
[ 0.000000] fixmap : 0xffc00000 - 0xffe00000 (2048 kB)
[ 0.000000] vmalloc : 0xc2800000 - 0xff000000 ( 968 MB)
[ 0.000000] lowmem : 0xc0000000 - 0xc2000000 ( 32 MB)
[ 0.000000] .text : 0xc0008000 - 0xc0328aec (3203 kB)
[ 0.000000] .init : 0xc0329000 - 0xc0345ddc ( 116 kB)
[ 0.000000] .data : 0xc0346000 - 0xc035d700 ( 94 kB)
[ 0.000000] .bss : 0xc035d700 - 0xc037cf24 ( 127 kB)
[ 0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[ 0.000000] Preemptible hierarchical RCU implementation.
[ 0.000000] NR_IRQS:16 nr_irqs:16 16
[ 0.000000] sched_clock: 32 bits at 100 Hz, resolution 10000000ns,
wraps every 21474836480000000ns
[ 0.010000] Calibrating delay loop... 147.86 BogoMIPS (lpj=739328)
[ 0.090000] pid_max: default: 4096 minimum: 301
[ 0.090000] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[ 0.100000] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
[ 0.110000] CPU: Testing write buffer coherency: ok
[ 0.120000] Setting up static identity map for 0x296938 - 0x296980
[ 0.140000] Unhandled fault: alignment exception (0x801) at 0x00000003
[ 0.140000] Internal error: : 801 [#1] PREEMPT ARM
[ 0.140000] CPU: 0 PID: 11 Comm: kdevtmpfs Not tainted
3.17.0-rc1-next-20140818+ #2691
[ 0.140000] task: c184a360 ti: c1850000 task.ti: c1850000
[ 0.140000] PC is at mnt_set_mountpoint+0x8c/0x9c
[ 0.140000] LR is at mnt_set_mountpoint+0x70/0x9c
[ 0.140000] pc : [<c00a8978>] lr : [<c00a895c>] psr: a0000053
[ 0.140000] sp : c1851e18 ip : 00000001 fp : 00000000
[ 0.140000] r10: c1802ae0 r9 : c1802ba0 r8 : 00000000
[ 0.140000] r7 : c1402000 r6 : c1842240 r5 : c1842300 r4 : c1802ba0
[ 0.140000] r3 : ffffffff r2 : c184237c r1 : c1802ba0 r0 : c1402054
[ 0.140000] Flags: NzCv IRQs on FIQs off Mode SVC_32 ISA ARM Segment kernel
[ 0.140000] Control: 0000397f Table: 00004000 DAC: 00000017
[ 0.140000] Process kdevtmpfs (pid: 11, stack limit = 0xc18501c0)
[ 0.140000] Stack: (0xc1851e18 to 0xc1852000)
[ 0.140000] 1e00: 0000000dc1842300
[ 0.140000] 1e20:
c1842300c1802ba0c1842240c00a9464c184230000000000c1802ba0c1842300
[ 0.140000] 1e40:
00000020c1802ba0c1851e70c1802b00c1852000c00a96a400000000c0354690
[ 0.140000] 1e60:
00000020c1842310c034db48c00aad54c1842250c1402000c1851ec400000000
[ 0.140000] 1e80:
00000000000000000000000000000000c181100000008000c02fdfb900000000
[ 0.140000] 1ea0:
000000000000000000000000c00aafccc1852000c1802aa000020200c1802ae0
[ 0.140000] 1ec0:
c1802b00c185200000000000c182bf5cc1851f06c182bf5cc0172950c017299c
[ 0.140000] 1ee0:
c1851f06ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
[ 0.140000] 1f00:
ffffffff6f6da000303d65640035353700000000c0029ac40000000000000002
[ 0.140000] 1f20:
c182a000c182a01cc184a3600000001700000000c184a360c1850000c1828000
[ 0.140000] 1f40:
c1851f6cc029363c00000000c1802aa000000000c182bf5cc017295000000000
[ 0.140000] 1f60:
000000000000000000000000c0028becffffffff00000000ffffffffc182bf5c
[ 0.140000] 1f80:
00000000c1851f84c1851f8400000000c1851f90c1851f90c1851facc1802aa0
[ 0.140000] 1fa0:
c0028b280000000000000000c000925000000000000000000000000000000000
[ 0.140000] 1fc0:
0000000000000000000000000000000000000000000000000000000000000000
[ 0.140000] 1fe0:
000000000000000000000000000000000000001300000000ffffffffffffffff
[ 0.140000] [<c00a8978>] (mnt_set_mountpoint) from [<c00a9464>]
(attach_recursive_mnt+0x114/0x22c)
[ 0.140000] [<c00a9464>] (attach_recursive_mnt) from [<c00a96a4>]
(do_add_mount+0xb8/0xd4)
[ 0.140000] [<c00a96a4>] (do_add_mount) from [<c00aad54>] (do_mount+0xa08/0xa48)
[ 0.140000] [<c00aad54>] (do_mount) from [<c00aafcc>] (SyS_mount+0x84/0xb8)
[ 0.140000] [<c00aafcc>] (SyS_mount) from [<c017299c>] (devtmpfsd+0x4c/0x2fc)
[ 0.140000] [<c017299c>] (devtmpfsd) from [<c0028bec>] (kthread+0xc4/0xd8)
[ 0.140000] [<c0028bec>] (kthread) from [<c0009250>] (ret_from_fork+0x14/0x24)
[ 0.140000] Code: e594300ce285207ce3530000e585307c (15832004)
[ 0.140000] ---[ end trace 1298010f773134bc ]---
[ 0.140000] Kernel panic - not syncing: Fatal exception
[ 0.140000] Rebooting in 10 seconds..Reboot failed -- System halted



    Jonas
