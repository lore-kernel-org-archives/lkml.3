Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaHIO0t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 10:26:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaHIO0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 10:26:46 -0400
Date: Sat, 9 Aug 2014 16:24:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: fault injection caused oops in proc_flush_task
Message-ID: <20140809142452.GA16457@redhat.com>
References: <20140808032344.GA22783@redhat.com> <87y4uzoai4.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y4uzoai4.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07, Eric W. Biederman wrote:
>
> Dave Jones <davej@redhat.com> writes:
>
> > Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> > CPU: 2 PID: 8506 Comm: trinity-c124 Not tainted 3.16.0+ #41
> > task: ffff880227fc95e0 ti: ffff8800929a0000 task.ti: ffff8800929a0000
> > RIP: 0010:[<ffffffff8624a8f9>]  [<ffffffff8624a8f9>] proc_flush_task+0x99/0x1b0
> > RSP: 0018:ffff8800929a3d40  EFLAGS: 00010246
> > RAX: 0000000000000001 RBX: ffff8800929a3d6b RCX: 0000000000000000
> > RDX: ffff8800929a3d6c RSI: ffff8800929a3d58 RDI: 0000000000000000
> > RBP: ffff8800929a3da8 R08: 000000000000000a R09: 000000000000fffb
> > R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
> > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000002
> > FS:  00007f019c95d700(0000) GS:ffff88024d100000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000000 CR3: 00000000959e7000 CR4: 00000000001407e0
> > DR0: 000000000249e000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> > Stack:
> >  ffff88022ad836c0 00000002929a3d58 ffff88022ad836c0 0000000132313068
> >  ffff8800929a3d6b 373231003277b6b0 ffff88022377b600 00000000898577d0
> >  ffff88022377b6b0 000000000000278f 0000000000000010 0000000000000000
> > Call Trace:
> >  [<ffffffff8607738c>] release_task+0x4c/0x4a0
> >  [<ffffffff86078aca>] wait_consider_task+0x70a/0xbe0
> >  [<ffffffff860790e4>] do_wait+0x144/0x2d0
> >  [<ffffffff8607967b>] SyS_wait4+0x7b/0x100
> >  [<ffffffff86077110>] ? task_stopped_code+0x60/0x60
> >  [<ffffffff8676371f>] tracesys+0xdd/0xe2
> > Code: d4 e0 a9 86 48 03 45 a8 89 4d a4 44 8b 78 30 48 8b 40 38 44 89 f9 4c 8b a8 40 08 00 00 31 c0 e8 6e 21 0f 00 48 8d 75 b0 89 45 b4 <49> 8b 7d 00 e8 4e 8b fa ff 48 85 c0 49 89 c6 74 18 48 89 c7 e8 
> > RIP  [<ffffffff8624a8f9>] proc_flush_task+0x99/0x1b0
> >
> >
> > Right before the oops, the last thing fault injection logged wrt that pid was..
> >
> > FAULT_INJECTION: forcing a failure
> > CPU: 0 PID: 8506 Comm: trinity-c124 Not tainted 3.16.0+ #41
> >  0000000000000032 00000000898577d0 ffff8800929a3b08 ffffffff86759797
> >  ffffffff86c6a300 ffff8800929a3b28 ffffffff86358c30 0000000000008020
> >  0000000000008020 ffff8800929a3b38 ffffffff861c6850 ffff8800929a3b88
> > Call Trace:
> >  [<ffffffff86759797>] dump_stack+0x4e/0x7a
> >  [<ffffffff86358c30>] should_fail+0x100/0x110
> >  [<ffffffff861c6850>] should_failslab+0x40/0x50
> >  [<ffffffff861c32de>] kmem_cache_alloc+0x5e/0x270
> >  [<ffffffff86331e99>] ida_pre_get+0x69/0xf0
> >  [<ffffffff86245c80>] ? proc_fill_super+0xa0/0xa0
> >  [<ffffffff861da749>] get_anon_bdev+0x39/0x120
> >  [<ffffffff86245c80>] ? proc_fill_super+0xa0/0xa0
> >  [<ffffffff861da846>] set_anon_super+0x16/0x30
> >  [<ffffffff8624605d>] proc_set_super+0x1d/0x80
> >  [<ffffffff861db64a>] sget+0x33a/0x400
> >  [<ffffffff86246040>] ? proc_root_lookup+0x40/0x40
> >  [<ffffffff86245ed7>] proc_mount+0xa7/0x150
> >  [<ffffffff861dc338>] mount_fs+0x38/0x1c0
> >  [<ffffffff861f9574>] vfs_kern_mount+0x64/0x120
> >  [<ffffffff861f9649>] kern_mount_data+0x19/0x30
> >  [<ffffffff8624611c>] pid_ns_prepare_proc+0x1c/0x30
>
>
> So what we can reconstruct from your data is:
>
> 8506 probably unshared a pid namespace.
> 8506 called fork/clone creating the first process in a pid namespace and


or it simply did clone(NEWPID),

>      alloc_pid fails.
> 8506 calls wait and the task it finds to be waited for is defective
>      and proc_flush_task oopses.
>
> *scratches head*

Yes, strange. Looks like, ns->proc_mnt == NULL but I can't see how the
error code from get_anon_bdev() can be lost. copy_process() should fail.

> So I don't think the last fault had anything to do with this failure.
>
> My dissassembly puts the code at the call of shrink_dcache_parent

To me it looks as if d_hash_and_lookup(mnt->mnt_root) fails because
mnt == NULL, but again, I can't see how it is possible. ns->proc_mnt
is initialized by pid_ns_prepare_proc(), and kern_mount_data() simply
can't return NULL instead of IS_ERR().

> but I
> don't think my dissambly matches your kernel.  Can you disassemble
> proc_flush_task so we can at least see what is failing?

Yes, my disassembly can be wrong too.

Oleg.

