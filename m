Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab3JVQMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:12:54 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:58812 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab3JVQMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:12:52 -0400
MIME-Version: 1.0
In-Reply-To: <526696BF.6050909@gmx.de>
References: <526696BF.6050909@gmx.de>
Date: Tue, 22 Oct 2013 18:12:51 +0200
Message-ID: <CAFLxGvy3NeRKu+KQCCm0j4LS60PYhH0bC8WWjfiPvpstPBjAkA@mail.gmail.com>
Subject: Re: [uml-devel] fuzz tested 32 bit user mode linux image hangs at in histfs
From: Richard Weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        UML devel <user-mode-linux-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 5:16 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>
> When I fuzz testing a 32 bit UML at a 32 bit host (guest 3.12.-rc6-x, host 3.11.6) with trinity
> and use hostfs for the victom files for trinity. then trintiy often hangs while trying to finish.
>
> At the host I do have 1 process eating 100% CPU power of 1 core. A back trace of thet linux process at the hosts gives :
>
> tfoerste@n22 ~ $ sudo gdb /usr/local/bin/linux-v3.12-rc6-57-g69c88dc 16749 -n -batch -ex bt
> radix_tree_next_chunk (root=0x21, iter=0x47647c60, flags=12) at lib/radix-tree.c:769
> 769                                     while (++offset < RADIX_TREE_MAP_SIZE) {
> #0  radix_tree_next_chunk (root=0x21, iter=0x47647c60, flags=12) at lib/radix-tree.c:769
> #1  0x080cc13e in find_get_pages (mapping=0x483ed240, start=0, nr_pages=14, pages=0xc) at mm/filemap.c:844
> #2  0x080d5caa in pagevec_lookup (pvec=0x47647cc4, mapping=0x21, start=33, nr_pages=33) at mm/swap.c:914
> #3  0x080d609a in truncate_inode_pages_range (mapping=0x483ed240, lstart=0, lend=-1) at mm/truncate.c:241
> #4  0x080d643f in truncate_inode_pages (mapping=0x21, lstart=51539607585) at mm/truncate.c:358
> #5  0x08260838 in hostfs_evict_inode (inode=0x483ed188) at fs/hostfs/hostfs_kern.c:242
> #6  0x0811a8cf in evict (inode=0x483ed188) at fs/inode.c:549
> #7  0x0811b2ad in iput_final (inode=<optimized out>) at fs/inode.c:1391
> #8  iput (inode=0x483ed188) at fs/inode.c:1409
> #9  0x08117648 in dentry_iput (dentry=<optimized out>) at fs/dcache.c:331
> #10 d_kill (dentry=0x47d6d580, parent=0x47d95d10) at fs/dcache.c:477
> #11 0x08118068 in dentry_kill (dentry=<optimized out>, unlock_on_failure=<optimized out>) at fs/dcache.c:586
> #12 dput (dentry=0x47d6d580) at fs/dcache.c:641
> #13 0x08104903 in __fput (file=0x47471840) at fs/file_table.c:264
> #14 0x0810496b in ____fput (work=0x47471840) at fs/file_table.c:282
> #15 0x08094496 in task_work_run () at kernel/task_work.c:123
> #16 0x0807efd2 in exit_task_work (task=<optimized out>) at include/linux/task_work.h:21
> #17 do_exit (code=1196535808) at kernel/exit.c:787
> #18 0x0807f5dd in do_group_exit (exit_code=0) at kernel/exit.c:920
> #19 0x0807f649 in SYSC_exit_group (error_code=<optimized out>) at kernel/exit.c:931
> #20 SyS_exit_group (error_code=0) at kernel/exit.c:929
> #21 0x08062984 in handle_syscall (r=0x4763b1d4) at arch/um/kernel/skas/syscall.c:35
> #22 0x08074fb5 in handle_trap (local_using_sysemu=<optimized out>, regs=<optimized out>, pid=<optimized out>) at arch/um/os-Linux/skas/process.c:198
> #23 userspace (regs=0x4763b1d4) at arch/um/os-Linux/skas/process.c:431
> #24 0x0805f750 in fork_handler () at arch/um/kernel/process.c:160
> #25 0x00000000 in ?? ()
>

That trace is identical to the one you reported yesterday.
But this time no nfs is in the game, right?

> Last message of trinity's watchdog are :
>
> ...
> [watchdog] exit_reason=2, but 2 children still running.
> Bailing main loop. Exit reason: Reached maximum syscall count.
> [watchdog] Reached limit 10001. Telling children to exit.
> [watchdog] [1516] Watchdog exiting
>
>
> I'm unsure if this is only UML specific, interesting for the fs people or mm or ... ?
>
>
> --
> MfG/Sincerely
> Toralf Förster
> pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
>
> ------------------------------------------------------------------------------
> October Webinars: Code for Performance
> Free Intel webinars can help you accelerate application performance.
> Explore tips for MPI, OpenMP, advanced profiling, and more. Get the most from
> the latest Intel processors and coprocessors. See abstracts and register >
> http://pubads.g.doubleclick.net/gampad/clk?id=60135991&iu=/4140/ostg.clktrk
> _______________________________________________
> User-mode-linux-devel mailing list
> User-mode-linux-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel



-- 
Thanks,
//richard
