Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab3J3TPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:15:36 -0400
Received: from mout.gmx.net ([212.227.15.15]:64782 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab3J3TPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:15:34 -0400
Message-ID: <52715AD1.7000703@gmx.de>
Date: Wed, 30 Oct 2013 20:15:29 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        UML devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [uml-devel] fuzz tested 32 bit user mode linux image hangs in
 radix_tree_next_chunk()
References: <526696BF.6050909@gmx.de> <CAFLxGvy3NeRKu+KQCCm0j4LS60PYhH0bC8WWjfiPvpstPBjAkA@mail.gmail.com> <5266A698.10400@gmx.de> <5266B60A.1000005@nod.at>
In-Reply-To: <5266B60A.1000005@nod.at>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:2Opse0X9UHaac0PHrMcjJSiy23wvelBBYpVtuJ2RaC06Zm1UIkh
 Y2tIE5nu7zYZIdLmdMMMc7WHTG/bklZ0+KmGFt0R4WMB4ysGXckrOEyvv+ehEKtFzY5cIeN
 PrLRCPpleTGspkq+KILqQfoEe2aH46YMSE17jES3LMykouDPF3rWfJEcY0bYgK7lNfpvYl6
 8gtGu8855EnKQ0dlPTSiw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 07:29 PM, Richard Weinberger wrote:
> Am 22.10.2013 18:23, schrieb Toralf Förster:
>> On 10/22/2013 06:12 PM, Richard Weinberger wrote:
>>> On Tue, Oct 22, 2013 at 5:16 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>>>>
>>>> When I fuzz testing a 32 bit UML at a 32 bit host (guest 3.12.-rc6-x, host 3.11.6) with trinity
>>>> and use hostfs for the victom files for trinity. then trintiy often hangs while trying to finish.
>>>>
>>>> At the host I do have 1 process eating 100% CPU power of 1 core. A back trace of thet linux process at the hosts gives :
>>>>
>>>> tfoerste@n22 ~ $ sudo gdb /usr/local/bin/linux-v3.12-rc6-57-g69c88dc 16749 -n -batch -ex bt
>>>> radix_tree_next_chunk (root=0x21, iter=0x47647c60, flags=12) at lib/radix-tree.c:769
>>>> 769                                     while (++offset < RADIX_TREE_MAP_SIZE) {
>>>> #0  radix_tree_next_chunk (root=0x21, iter=0x47647c60, flags=12) at lib/radix-tree.c:769
>>>> #1  0x080cc13e in find_get_pages (mapping=0x483ed240, start=0, nr_pages=14, pages=0xc) at mm/filemap.c:844
>>>> #2  0x080d5caa in pagevec_lookup (pvec=0x47647cc4, mapping=0x21, start=33, nr_pages=33) at mm/swap.c:914
>>>> #3  0x080d609a in truncate_inode_pages_range (mapping=0x483ed240, lstart=0, lend=-1) at mm/truncate.c:241
>>>> #4  0x080d643f in truncate_inode_pages (mapping=0x21, lstart=51539607585) at mm/truncate.c:358
>>>> #5  0x08260838 in hostfs_evict_inode (inode=0x483ed188) at fs/hostfs/hostfs_kern.c:242
>>>> #6  0x0811a8cf in evict (inode=0x483ed188) at fs/inode.c:549
>>>> #7  0x0811b2ad in iput_final (inode=<optimized out>) at fs/inode.c:1391
>>>> #8  iput (inode=0x483ed188) at fs/inode.c:1409
>>>> #9  0x08117648 in dentry_iput (dentry=<optimized out>) at fs/dcache.c:331
>>>> #10 d_kill (dentry=0x47d6d580, parent=0x47d95d10) at fs/dcache.c:477
>>>> #11 0x08118068 in dentry_kill (dentry=<optimized out>, unlock_on_failure=<optimized out>) at fs/dcache.c:586
>>>> #12 dput (dentry=0x47d6d580) at fs/dcache.c:641
>>>> #13 0x08104903 in __fput (file=0x47471840) at fs/file_table.c:264
>>>> #14 0x0810496b in ____fput (work=0x47471840) at fs/file_table.c:282
>>>> #15 0x08094496 in task_work_run () at kernel/task_work.c:123
>>>> #16 0x0807efd2 in exit_task_work (task=<optimized out>) at include/linux/task_work.h:21
>>>> #17 do_exit (code=1196535808) at kernel/exit.c:787
>>>> #18 0x0807f5dd in do_group_exit (exit_code=0) at kernel/exit.c:920
>>>> #19 0x0807f649 in SYSC_exit_group (error_code=<optimized out>) at kernel/exit.c:931
>>>> #20 SyS_exit_group (error_code=0) at kernel/exit.c:929
>>>> #21 0x08062984 in handle_syscall (r=0x4763b1d4) at arch/um/kernel/skas/syscall.c:35
>>>> #22 0x08074fb5 in handle_trap (local_using_sysemu=<optimized out>, regs=<optimized out>, pid=<optimized out>) at arch/um/os-Linux/skas/process.c:198
>>>> #23 userspace (regs=0x4763b1d4) at arch/um/os-Linux/skas/process.c:431
>>>> #24 0x0805f750 in fork_handler () at arch/um/kernel/process.c:160
>>>> #25 0x00000000 in ?? ()
>>>>
>>>
>>> That trace is identical to the one you reported yesterday.
>>> But this time no nfs is in the game, right?
>>>
>>
>> Right - I could narrow down it in the meanwhile to hostfs only. First I
>> argued if NFS sometimes might force the issue to happen later but in the
>> mean while I don't think so.
> 
> It looks like we never find a way out of the while(1) in
> radix_tree_next_chunk().
> 

FWIW here's a slightly different and much shorter gdb back trace 

tfoerste@n22 ~/devel/linux $ sudo gdb /usr/local/bin/linux-v3.12-rc7 3105 -n -batch -ex bt
0x08298f16 in radix_tree_next_chunk (root=0x0, iter=0x46c2fcec, flags=18) at lib/radix-tree.c:756
756                     if ((flags & RADIX_TREE_ITER_TAGGED) ?
#0  0x08298f16 in radix_tree_next_chunk (root=0x0, iter=0x46c2fcec, flags=18) at lib/radix-tree.c:756
#1  0x080cc20e in find_get_pages (mapping=0x26c35130, start=0, nr_pages=14, pages=0x12) at mm/filemap.c:844
#2  0x080d5d7a in pagevec_lookup (pvec=0x46c2fd50, mapping=0x0, start=0, nr_pages=0) at mm/swap.c:914
#3  0x080d616a in truncate_inode_pages_range (mapping=0x26c35130, lstart=0, lend=-1) at mm/truncate.c:241
#4  0x080d650f in truncate_inode_pages (mapping=0x0, lstart=77309411328) at mm/truncate.c:358
#5  0x0818d7e2 in ext4_evict_inode (inode=0x26c35078) at fs/ext4/inode.c:228
#6  0x0811a99f in evict (inode=0x26c35078) at fs/inode.c:549
#7  0x0811b37d in iput_final (inode=<optimized out>) at fs/inode.c:1391
#8  iput (inode=0x26c35078) at fs/inode.c:1409
#9  0x08111717 in do_unlinkat (dfd=5, pathname=0x80686c4 <create_proc_mconsole+4> "_\b\205\322tJU\211\345\203\354\024\307D$\020") at fs/namei.c:3730
#10 0x08111835 in SYSC_unlinkat (flag=<optimized out>, pathname=<optimized out>, dfd=<optimized out>) at fs/namei.c:3756
#11 SyS_unlinkat (dfd=5, pathname=134645444, flag=0) at fs/namei.c:3748
#12 0x08062984 in handle_syscall (r=0x48408dd4) at arch/um/kernel/skas/syscall.c:35
#13 0x08074fb5 in handle_trap (local_using_sysemu=<optimized out>, regs=<optimized out>, pid=<optimized out>) at arch/um/os-Linux/skas/process.c:198
#14 userspace (regs=0x48408dd4) at arch/um/os-Linux/skas/process.c:431
#15 0x0805f750 in fork_handler () at arch/um/kernel/process.c:160
#16 0x5a5a5a5a in ?? ()

> Thanks,
> //richard
> 


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
