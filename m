Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab3JVPQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:16:19 -0400
Received: from mout.gmx.net ([212.227.15.18]:62666 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab3JVPQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:16:18 -0400
Message-ID: <526696BF.6050909@gmx.de>
Date: Tue, 22 Oct 2013 17:16:15 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: UML devel <user-mode-linux-devel@lists.sourceforge.net>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org
Subject: fuzz tested 32 bit user mode linux image hangs at in histfs
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:pmtbmWB+8JQ1l1kb74HSVwsbG0Ah7QNrOzMHISAbbWQbcIShYi7
 Nhl2MeB1pe/B5D9c1DW3z8CJB5ZHIasTh+VvGWJwijpZDRwJotd6KqpAT0Z8RmdS/ePIl3C
 PwcWFtR2g75FEz/C1AXDJ9y6du4BS1VyuAWau0Dk7qzrRvOHK/foGP+gb5cDPO2rG3F3kXG
 U3mdm+wL300mntmvZVkYg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When I fuzz testing a 32 bit UML at a 32 bit host (guest 3.12.-rc6-x, host 3.11.6) with trinity
and use hostfs for the victom files for trinity. then trintiy often hangs while trying to finish.

At the host I do have 1 process eating 100% CPU power of 1 core. A back trace of thet linux process at the hosts gives :

tfoerste@n22 ~ $ sudo gdb /usr/local/bin/linux-v3.12-rc6-57-g69c88dc 16749 -n -batch -ex bt
radix_tree_next_chunk (root=0x21, iter=0x47647c60, flags=12) at lib/radix-tree.c:769
769                                     while (++offset < RADIX_TREE_MAP_SIZE) {
#0  radix_tree_next_chunk (root=0x21, iter=0x47647c60, flags=12) at lib/radix-tree.c:769
#1  0x080cc13e in find_get_pages (mapping=0x483ed240, start=0, nr_pages=14, pages=0xc) at mm/filemap.c:844
#2  0x080d5caa in pagevec_lookup (pvec=0x47647cc4, mapping=0x21, start=33, nr_pages=33) at mm/swap.c:914
#3  0x080d609a in truncate_inode_pages_range (mapping=0x483ed240, lstart=0, lend=-1) at mm/truncate.c:241
#4  0x080d643f in truncate_inode_pages (mapping=0x21, lstart=51539607585) at mm/truncate.c:358
#5  0x08260838 in hostfs_evict_inode (inode=0x483ed188) at fs/hostfs/hostfs_kern.c:242
#6  0x0811a8cf in evict (inode=0x483ed188) at fs/inode.c:549
#7  0x0811b2ad in iput_final (inode=<optimized out>) at fs/inode.c:1391
#8  iput (inode=0x483ed188) at fs/inode.c:1409
#9  0x08117648 in dentry_iput (dentry=<optimized out>) at fs/dcache.c:331
#10 d_kill (dentry=0x47d6d580, parent=0x47d95d10) at fs/dcache.c:477
#11 0x08118068 in dentry_kill (dentry=<optimized out>, unlock_on_failure=<optimized out>) at fs/dcache.c:586
#12 dput (dentry=0x47d6d580) at fs/dcache.c:641
#13 0x08104903 in __fput (file=0x47471840) at fs/file_table.c:264
#14 0x0810496b in ____fput (work=0x47471840) at fs/file_table.c:282
#15 0x08094496 in task_work_run () at kernel/task_work.c:123
#16 0x0807efd2 in exit_task_work (task=<optimized out>) at include/linux/task_work.h:21
#17 do_exit (code=1196535808) at kernel/exit.c:787
#18 0x0807f5dd in do_group_exit (exit_code=0) at kernel/exit.c:920
#19 0x0807f649 in SYSC_exit_group (error_code=<optimized out>) at kernel/exit.c:931
#20 SyS_exit_group (error_code=0) at kernel/exit.c:929
#21 0x08062984 in handle_syscall (r=0x4763b1d4) at arch/um/kernel/skas/syscall.c:35
#22 0x08074fb5 in handle_trap (local_using_sysemu=<optimized out>, regs=<optimized out>, pid=<optimized out>) at arch/um/os-Linux/skas/process.c:198
#23 userspace (regs=0x4763b1d4) at arch/um/os-Linux/skas/process.c:431
#24 0x0805f750 in fork_handler () at arch/um/kernel/process.c:160
#25 0x00000000 in ?? ()


Last message of trinity's watchdog are :

...
[watchdog] exit_reason=2, but 2 children still running.
Bailing main loop. Exit reason: Reached maximum syscall count.
[watchdog] Reached limit 10001. Telling children to exit.
[watchdog] [1516] Watchdog exiting


I'm unsure if this is only UML specific, interesting for the fs people or mm or ... ?


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
