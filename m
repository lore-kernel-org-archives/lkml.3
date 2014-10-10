Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbaJJUwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 16:52:45 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:39820 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbaJJUwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 16:52:41 -0400
Date: Fri, 10 Oct 2014 23:52:34 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rabin Vincent <rabin@rab.in>, Rik van Riel <riel@redhat.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        josh@joshtriplett.org, Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RCU bug with v3.17-rc3 ?
Message-ID: <20141010205234.GA15738@drone.musicnaut.iki.fi>
References: <20140904200403.GL13421@saruman.home>
 <20140905213216.GD5001@linux.vnet.ibm.com>
 <20141008171322.GH22688@saruman>
 <20141008175707.GI22688@saruman>
 <20141008212938.GP22688@saruman>
 <20141009160138.GA2396@cmpxchg.org>
 <20141009162656.GE16002@saruman>
 <20141009204101.GA25955@debian>
 <20141009214706.GC4606@drone.musicnaut.iki.fi>
 <20141010161835.GK12379@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010161835.GK12379@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 05:18:35PM +0100, Russell King - ARM Linux wrote:
> On Fri, Oct 10, 2014 at 12:47:06AM +0300, Aaro Koskinen wrote:
> > On Thu, Oct 09, 2014 at 10:41:01PM +0200, Rabin Vincent wrote:
> > >   What GCC version are you using?
> > >   
> > >   4.8.1 and 4.8.2 are known to miscompile the ARM kernel and these
> > >   find_get_entry() crashes with 0xffffffff involved smell a lot like the
> > >   earlier reports from kernels build with those compilers:
> > >   
> > >   https://lkml.org/lkml/2014/6/25/456
> > >   https://lkml.org/lkml/2014/6/30/375
> > >   https://lkml.org/lkml/2014/6/30/660
> > >   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58854
> > >   https://lkml.org/lkml/2014/5/9/330
> > 
> > Is it possible to blacklist those GCC versions on ARM somehow as it
> > seems people are still using them?
> > 
> > This bug also ruined a file system on one of my boxes last year
> > (see e.g. http://marc.info/?l=linux-arm-kernel&m=139033442527244&w=2).
> 
> Given that, why the fsck (pun intended) did you not shout a little louder
> about getting it blacklisted.  Looking at your marc.info URL, there's
> very little information there which hints at filesystem corruption, and
> it's a thread of only *one* message according to marc.info.
> 
> Even _if_ I did read the message you point to above, that on its own did
> not hint at filesystem corruption.
> 
> So, would you please mind passing on further details about this,
> specifically which function in the ext4 code is affected, so it can
> be properly written up.

I have not done any proper deeper analysis. After I first mailed about
the issue I just downgraded GCC and pretty much forgot about it until
an engineer from some commercial Linux vendor replied privately months
later and kindly pointed me the needed GCC fix (which I then shared
in the reply). Then I just moved on using a newer GCC with no issues.
Obviously this was not a widespread problem since no one else
reported the same.

Today I again booted a kernel compiled with GCC 4.8.2 and still was able
reproduce the issue, and I think below shows that at least ext3 can
easily end up in inconsistent state using these compiler versions:

0) Run the bad kernel:

~ # dmesg|grep GCC
[    0.000000] Linux version 3.17.0-mvebu-los_9755+ (aaro@cooljazz) (gcc version 4.8.2 (GCC) ) #1 Fri Oct 10 21:05:20 EEST 2014

1) Start with small ext3 (writeback) fs with gcc tarball:

/mnt/test # ls -l
total 84092
-rw-r--r--    1 root     root      85999682 Apr 24 21:52 gcc-4.8.2.tar.bz2
drwx------    2 root     root         16384 Oct 10 10:33 lost+found
/mnt/test # df -h .
Filesystem                Size      Used Available Use% Mounted on
/dev/sdc1                 3.8G     90.2M      3.5G   2% /mnt/test

2) Extract, delete & crash:

/mnt/test # tar xjf gcc-4.8.2.tar.bz2
/mnt/test # rm -rf gcc-4.8.2
rm: can't remove 'gcc-4.8.2/libgfortran/generated': Directory not empty
rm: can't remove 'gcc-4.8.2/libgfortran': Directory not empty
rm: can't remove 'gcc-4.8.2/gcc/testsuite/gcc.dg/compat/struct-by-value-18a_y.c': No such file or directory
rm: can't remove 'gcc-4.8.2/gcc/testsuite/gcc.dg/compat': Directory not empty
rm: can't remove 'gcc-4.8.2/gcc/testsuite/gcc.dg/tree-ssa': Directory not empty
rm: can't remove 'gcc-4.8.2/gcc/testsuite/gcc.dg': Directory not empty
rm: can't remove 'gcc-4.8.2/gcc/testsuite/gfortran.dg/result_default_init_1.f90': No such file or directory
rm: can't remove 'gcc-4.8.2/gcc/testsuite/gfortran.dg': Directory not empty
[  960.864433] Unable to handle kernel paging request at virtual address ffffffff
[  960.930597] pgd = df6e0000
[  960.990849] [ffffffff] *pgd=1fffd831, *pte=00000000, *ppte=00000000
[  961.056512] Internal error: Oops: 1 [#1] ARM
[  961.120063] Modules linked in:
[  961.180974] CPU: 0 PID: 684 Comm: rm Not tainted 3.17.0-mvebu-los_9755+ #1
[  961.247146] task: df447b00 ti: df4de000 task.ti: df4de000
[  961.311524] PC is at find_get_entry+0x28/0x84
[  961.375037] LR is at radix_tree_lookup_slot+0x1c/0x2c
[  961.439061] pc : [<c006e418>]    lr : [<c018392c>]    psr: a0000013
[  961.439061] sp : df4dfc68  ip : 00000000  fp : df4dfc7c
[  961.570018] r10: 00000001  r9 : c04e3253  r8 : df020b60
[  961.634596] r7 : 0009001a  r6 : 00000000  r5 : 0009001a  r4 : df020c90
[  961.700070] r3 : ffffffff  r2 : 00000000  r1 : 0009001a  r0 : ffffffff
[  961.764437] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  961.830518] Control: 0005317f  Table: 1f6e0000  DAC: 00000015
[  961.895866] Process rm (pid: 684, stack limit = 0xdf4de1c0)
[  961.960597] Stack: (0xdf4dfc68 to 0xdf4e0000)
[  962.022968] fc60:                   00000001 df020c8c df4dfcb4 df4dfc80 c006eef68 c006e400
[  962.091214] fc80: c00d4e80 c00d4764 00001000 0009001a 00000000 00000000 df0200b60 df020b60
[  962.159490] fca0: df020bd8 df04e4d8 df4dfd04 df4dfcb8 c00d34c0 c006ef44 000000000 df4dfcc8
[  962.226940] fcc0: c00d4e80 c00d4764 00001000 00000001 df4dfd84 dd1c73f0 000900306 00000000
[  962.295558] fce0: 00090068 00000000 00000000 df020b60 df04e4d8 00000181 df4dffd4c df4dfd08
[  962.364710] fd00: c00d4828 c00d347c 00000000 00000001 df4dfdc4 dd1c73f0 000000000 00000000
[  962.433394] fd20: 00000000 00000000 df4dfd84 00090002 00001000 dbaa2200 df0200b60 df04e4d8
[  962.501810] fd40: df4dfdbc df4dfd50 c00d4e80 c00d4764 00001000 df4dfd60 c01411284 c0148708
[  962.569685] fd60: 0009001a 00000000 c0ebc7c0 df041180 00000002 00000000 df4dffd9c df4dfd88
[  962.639143] fd80: c003813c c0038084 df041180 df0b7320 df4dfdac 00090002 000000000 dbaa2200
[  962.708562] fda0: df4dfe4c df04e4d8 00000181 df04e4d8 df4dfe24 df4dfdc0 c010887c0 c00d4e6c
[  962.778108] fdc0: 00001000 c038caf8 0000128f 00000000 00000000 00011000 000000001 c9c59740
[  962.846670] fde0: 0009001a 00000000 00000a26 c824f240 00000010 00000000 df4dffe1c df04e4d8
[  962.913956] fe00: df04e4d8 df4dfe4c de53cf40 de53cf40 00000000 df04e4d8 df4dffe44 df4dfe28
[  962.980679] fe20: c010c5a8 c01086c4 df04e4d8 dee12000 dbaa2200 df04e4b4 df4dffe84 df4dfe48
[  963.046696] fe40: c0115dc4 c010c584 dd1c73f0 00000000 00000100 00000012 000000000 c0fbfe00
[  963.112648] fe60: df04e4d8 dd1c73f0 de53cf40 00000000 df4dff04 df04e4d8 df4dffecc df4dfe88
[  963.178402] fe80: c0116b24 c0115ce0 00000000 c00b3b24 df4dfeac c067b174 5437dd0a4 22921900
[  963.244947] fea0: df4dfecc df4dfeb0 c00b7a50 c19ca440 df04e4d8 df04e534 dd1c773f0 000b6650
[  963.311517] fec0: df4dfefc df4dfed0 c00b7e4c c01168d8 df4dfefc df4dfee0 c19caa440 00000000
[  963.377319] fee0: df4e6000 00000000 000b6650 ffffff9c df4dff94 df4dff00 c00b880b0 c00b7d94
[  963.443083] ff00: 5437d035 00000000 dba4a8d0 d899f6e8 78ae7ba4 0000000d df4e6603c 0000000c
[  963.509416] ff20: 00000000 c0009624 dd1c73f0 00000000 00000004 00000038 000000000 00000000
[  963.575556] ff40: 00024182 00000000 00800021 c04c81b4 00000001 000003e8 0000003e8 00000000
[  963.641281] ff60: 0000024d 00000000 4bfad53f 000b6650 00000008 0000000c 00000000a c0009624
[  963.707194] ff80: df4de000 00000000 df4dffa4 df4dff98 c00b8e20 c00b7ed0 000000000 df4dffa8
[  963.773584] ffa0: c00094c0 c00b8e18 000b6650 00000008 000b6650 bed03990 bed033990 00008000
[  963.841022] ffc0: 000b6650 00000008 0000000c 0000000a 000b6650 00000000 b6fccc000 00000000
[  963.907530] ffe0: 00093224 bed0398c 00071284 b6efa39c 60000010 000b6650 0000fffff 0000ffff
[  963.973653] Backtrace: [  964.032680] [<c006e3f0>] (find_get_entry) from [<c006ef68>] (pagecache_get_page+0x34/0x1fc)
[  964.100751]  r5:df020c8c r4:00000001
[  964.162591] [<c006ef34>] (pagecache_get_page) from [<c00d34c0>] (__find_get_b
block_slow+0x54/0x16c)
[  964.291505]  r10:df04e4d8 r9:df020bd8 r8:df020b60 r7:df020b60 r6:00000000 r5:
:00000000
[  964.361857]  r4:0009001a
[  964.425342] [<c00d346c>] (__find_get_block_slow) from [<c00d4828>] (__find_ge
et_block+0xd4/0x1e4)
[  964.498345]  r9:00000181 r8:df04e4d8 r7:df020b60 r6:00000000 r5:00000000 r4:0
00090068
[  964.570979] [<c00d4754>] (__find_get_block) from [<c00d4e80>] (__getblk+0x24/
/0x358)
[  964.643833]  r8:df04e4d8 r7:df020b60 r6:dbaa2200 r5:00001000 r4:00090002
[  964.716031] [<c00d4e5c>] (__getblk) from [<c01087c0>] (__ext4_get_inode_loc+0
0x10c/0x454)
[  964.790734]  r10:df04e4d8 r9:00000181 r8:df04e4d8 r7:df4dfe4c r6:dbaa2200 r5:
:00000000
[  964.865945]  r4:00090002
[  964.934187] [<c01086b4>] (__ext4_get_inode_loc) from [<c010c5a8>] (ext4_reser
rve_inode_write+0x34/0x9c)
[  965.080216]  r10:df04e4d8 r9:00000000 r8:de53cf40 r7:de53cf40 r6:df4dfe4c r5:
:df04e4d8
[  965.159656]  r4:df04e4d8
[  965.232230] [<c010c574>] (ext4_reserve_inode_write) from [<c0115dc4>] (ext4_o
orphan_add+0xf4/0x218)
[  965.385687]  r7:df04e4b4 r6:dbaa2200 r5:dee12000 r4:df04e4d8
[  965.464523] [<c0115cd0>] (ext4_orphan_add) from [<c0116b24>] (ext4_unlink+0x2
25c/0x26c)
[  965.547430]  r10:df04e4d8 r9:df4dff04 r8:00000000 r7:de53cf40 r6:dd1c73f0 r5:
:df04e4d8
[  965.631429]  r4:c0fbfe00
[  965.708445] [<c01168c8>] (ext4_unlink) from [<c00b7e4c>] (vfs_unlink+0xc8/0x1
13c)
[  965.792677]  r8:000b6650 r7:dd1c73f0 r6:df04e534 r5:df04e4d8 r4:c19ca440
[  965.877297] [<c00b7d84>] (vfs_unlink) from [<c00b80b0>] (do_unlinkat+0x1f0/0x
x210)
[  965.963851]  r9:ffffff9c r8:000b6650 r7:00000000 r6:df4e6000 r5:00000000 r4:c
c19ca440
[  966.051666] [<c00b7ec0>] (do_unlinkat) from [<c00b8e20>] (SyS_unlink+0x18/0x1
1c)
[  966.139262]  r10:00000000 r9:df4de000 r8:c0009624 r7:0000000a r6:0000000c r5:
:00000008
[  966.228970]  r4:000b6650
[  966.311776] [<c00b8e08>] (SyS_unlink) from [<c00094c0>] (ret_fast_syscall+0x0
0/0x2c)
[  966.401452] Code: e1a01005 eb04553f e2503000 0a00000f (e5930000) 
[  966.608250] ---[ end trace a1b54af48fda09ed ]---
[  966.693854] Kernel panic - not syncing: Fatal exception
[  966.781707] ---[ end Kernel panic - not syncing: Fatal exception

3) Boot a good kernel:

~ # dmesg | grep GCC
[    0.000000] Linux version 3.17.0-mvebu-los_1b42 (aaro@cooljazz) (gcc version 4.9.1 (GCC) ) #1 Thu Oct 9 06:46:07 EEST 2014

4) Use the beforementioned file system and try to clean the mess:

/mnt/test # df -h .
Filesystem                Size      Used Available Use% Mounted on
/dev/sdc1                 3.8G    796.2M      2.8G  22% /mnt/test
/mnt/test # rm -rf gcc-4.8.2
rm: can't remove 'gcc-4.8.2/gcc/testsuite/gcc.dg/tree-ssa': Directory not empty
rm: can't remove 'gcc-4.8.2/gcc/testsuite/gcc.dg': Directory not empty
rm: can't remove 'gcc-4.8.2/gcc/testsuite/gfortran.dg': Directory not empty
rm: can't remove 'gcc-4.8.2/gcc/testsuite': Directory not empty
rm: can't remove 'gcc-4.8.2/gcc': Directory not empty
rm: can't remove 'gcc-4.8.2': Directory not empty
/mnt/test # rm -rf gcc-4.8.2
rm: can't remove 'gcc-4.8.2/gcc/testsuite/gcc.dg/tree-ssa': Directory not empty
rm: can't remove 'gcc-4.8.2/gcc/testsuite/gcc.dg': Directory not empty
rm: can't remove 'gcc-4.8.2/gcc/testsuite/gfortran.dg': Directory not empty
rm: can't remove 'gcc-4.8.2/gcc/testsuite': Directory not empty
rm: can't remove 'gcc-4.8.2/gcc': Directory not empty
rm: can't remove 'gcc-4.8.2': Directory not empty
/mnt/test # df -h .
Filesystem                Size      Used Available Use% Mounted on
/dev/sdc1                 3.8G     90.5M      3.5G   2% /mnt/test
/mnt/test # find gcc-4.8.2
gcc-4.8.2
gcc-4.8.2/gcc
gcc-4.8.2/gcc/testsuite
gcc-4.8.2/gcc/testsuite/gcc.dg
gcc-4.8.2/gcc/testsuite/gcc.dg/tree-ssa
find: gcc-4.8.2/gcc/testsuite/gcc.dg/tree-ssa/forwprop-8.c: No such file or directory
gcc-4.8.2/gcc/testsuite/gfortran.dg
find: gcc-4.8.2/gcc/testsuite/gfortran.dg/result_default_init_1.f90: No such file or directory

5) fsck to rescue:

/mnt/test # cd /
~ # umount /mnt/test
~ # fsck /dev/sdc1
fsck 1.42.9 (28-Dec-2013)
e2fsck 1.42.9 (28-Dec-2013)
/dev/sdc1: clean, 21/262144 files, 72408/1048576 blocks
~ # fsck -f /dev/sdc1
fsck 1.42.9 (28-Dec-2013)
e2fsck 1.42.9 (28-Dec-2013)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Problem in HTREE directory inode 118267: block #4 has bad min hash
Problem in HTREE directory inode 118267: block #26 has bad max hash
Invalid HTREE directory inode 118267 (/gcc-4.8.2/gcc/testsuite/gfortran.dg).  Clear HTree index<y>? yes
Problem in HTREE directory inode 174218: block #8 has bad min hash
Invalid HTREE directory inode 174218 (/gcc-4.8.2/gcc/testsuite/gcc.dg/tree-ssa).  Clear HTree index<y>? yes
Pass 3: Checking directory connectivity
Pass 3A: Optimizing directories
Pass 4: Checking reference counts
Pass 5: Checking group summary information

/dev/sdc1: ***** FILE SYSTEM WAS MODIFIED *****
/dev/sdc1: 21/262144 files (19.0% non-contiguous), 72368/1048576 blocks
~ # mount /dev/sdc1 /mnt/
~ # rm -rf /mnt/gcc-4.8.2
~ # 

So in this case fsck was able to fix it.

A.
