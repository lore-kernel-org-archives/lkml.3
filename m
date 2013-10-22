Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab3JVR34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:29:56 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754330Ab3JVR3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:29:51 -0400
Message-ID: <5266B60A.1000005@nod.at>
Date: Tue, 22 Oct 2013 19:29:46 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        UML devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [uml-devel] fuzz tested 32 bit user mode linux image hangs at
 in histfs
References: <526696BF.6050909@gmx.de> <CAFLxGvy3NeRKu+KQCCm0j4LS60PYhH0bC8WWjfiPvpstPBjAkA@mail.gmail.com> <5266A698.10400@gmx.de>
In-Reply-To: <5266A698.10400@gmx.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.10.2013 18:23, schrieb Toralf Förster:
> On 10/22/2013 06:12 PM, Richard Weinberger wrote:
>> On Tue, Oct 22, 2013 at 5:16 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>>>
>>> When I fuzz testing a 32 bit UML at a 32 bit host (guest 3.12.-rc6-x, host 3.11.6) with trinity
>>> and use hostfs for the victom files for trinity. then trintiy often hangs while trying to finish.
>>>
>>> At the host I do have 1 process eating 100% CPU power of 1 core. A back trace of thet linux process at the hosts gives :
>>>
>>> tfoerste@n22 ~ $ sudo gdb /usr/local/bin/linux-v3.12-rc6-57-g69c88dc 16749 -n -batch -ex bt
>>> radix_tree_next_chunk (root=0x21, iter=0x47647c60, flags=12) at lib/radix-tree.c:769
>>> 769                                     while (++offset < RADIX_TREE_MAP_SIZE) {
>>> #0  radix_tree_next_chunk (root=0x21, iter=0x47647c60, flags=12) at lib/radix-tree.c:769
>>> #1  0x080cc13e in find_get_pages (mapping=0x483ed240, start=0, nr_pages=14, pages=0xc) at mm/filemap.c:844
>>> #2  0x080d5caa in pagevec_lookup (pvec=0x47647cc4, mapping=0x21, start=33, nr_pages=33) at mm/swap.c:914
>>> #3  0x080d609a in truncate_inode_pages_range (mapping=0x483ed240, lstart=0, lend=-1) at mm/truncate.c:241
>>> #4  0x080d643f in truncate_inode_pages (mapping=0x21, lstart=51539607585) at mm/truncate.c:358
>>> #5  0x08260838 in hostfs_evict_inode (inode=0x483ed188) at fs/hostfs/hostfs_kern.c:242
>>> #6  0x0811a8cf in evict (inode=0x483ed188) at fs/inode.c:549
>>> #7  0x0811b2ad in iput_final (inode=<optimized out>) at fs/inode.c:1391
>>> #8  iput (inode=0x483ed188) at fs/inode.c:1409
>>> #9  0x08117648 in dentry_iput (dentry=<optimized out>) at fs/dcache.c:331
>>> #10 d_kill (dentry=0x47d6d580, parent=0x47d95d10) at fs/dcache.c:477
>>> #11 0x08118068 in dentry_kill (dentry=<optimized out>, unlock_on_failure=<optimized out>) at fs/dcache.c:586
>>> #12 dput (dentry=0x47d6d580) at fs/dcache.c:641
>>> #13 0x08104903 in __fput (file=0x47471840) at fs/file_table.c:264
>>> #14 0x0810496b in ____fput (work=0x47471840) at fs/file_table.c:282
>>> #15 0x08094496 in task_work_run () at kernel/task_work.c:123
>>> #16 0x0807efd2 in exit_task_work (task=<optimized out>) at include/linux/task_work.h:21
>>> #17 do_exit (code=1196535808) at kernel/exit.c:787
>>> #18 0x0807f5dd in do_group_exit (exit_code=0) at kernel/exit.c:920
>>> #19 0x0807f649 in SYSC_exit_group (error_code=<optimized out>) at kernel/exit.c:931
>>> #20 SyS_exit_group (error_code=0) at kernel/exit.c:929
>>> #21 0x08062984 in handle_syscall (r=0x4763b1d4) at arch/um/kernel/skas/syscall.c:35
>>> #22 0x08074fb5 in handle_trap (local_using_sysemu=<optimized out>, regs=<optimized out>, pid=<optimized out>) at arch/um/os-Linux/skas/process.c:198
>>> #23 userspace (regs=0x4763b1d4) at arch/um/os-Linux/skas/process.c:431
>>> #24 0x0805f750 in fork_handler () at arch/um/kernel/process.c:160
>>> #25 0x00000000 in ?? ()
>>>
>>
>> That trace is identical to the one you reported yesterday.
>> But this time no nfs is in the game, right?
>>
> 
> Right - I could narrow down it in the meanwhile to hostfs only. First I
> argued if NFS sometimes might force the issue to happen later but in the
> mean while I don't think so.

It looks like we never find a way out of the while(1) in
radix_tree_next_chunk().

Thanks,
//richard
