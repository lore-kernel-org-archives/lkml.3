Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbaHHEtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 00:49:08 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33960 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaHHEtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 00:49:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>
References: <20140808032344.GA22783@redhat.com>
Date: Thu, 07 Aug 2014 21:45:07 -0700
In-Reply-To: <20140808032344.GA22783@redhat.com> (Dave Jones's message of
	"Thu, 7 Aug 2014 23:23:44 -0400")
Message-ID: <87y4uzoai4.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/lGEWW0FdCGpjtN1Se4T3hDoEWa710w0M=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Dave Jones <davej@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: fault injection caused oops in proc_flush_task
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> Because I don't have enough oopses in my life, I decided to play
> with the fault injection code today. It's not something I hear about
> people trying too often, so I wondered what horrors lurk..
>
> So I ran this..
>
> #!/bin/bash
>
> for FAILTYPE in failslab fail_page_alloc
> do
>  echo N > /sys/kernel/debug/$FAILTYPE/task-filter
>  echo 50 > /sys/kernel/debug/$FAILTYPE/probability
>  echo 500 > /sys/kernel/debug/$FAILTYPE/interval
>  echo -1 > /sys/kernel/debug/$FAILTYPE/times
>  echo 0 > /sys/kernel/debug/$FAILTYPE/space
>  echo 0 > /sys/kernel/debug/$FAILTYPE/verbose
>  echo 2 > /sys/kernel/debug/$FAILTYPE/ignore-gfp-wait
> done
>
> And then ran my usual fuzzing session, and saw this ..
>
> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> CPU: 2 PID: 8506 Comm: trinity-c124 Not tainted 3.16.0+ #41
> task: ffff880227fc95e0 ti: ffff8800929a0000 task.ti: ffff8800929a0000
> RIP: 0010:[<ffffffff8624a8f9>]  [<ffffffff8624a8f9>] proc_flush_task+0x99/0x1b0
> RSP: 0018:ffff8800929a3d40  EFLAGS: 00010246
> RAX: 0000000000000001 RBX: ffff8800929a3d6b RCX: 0000000000000000
> RDX: ffff8800929a3d6c RSI: ffff8800929a3d58 RDI: 0000000000000000
> RBP: ffff8800929a3da8 R08: 000000000000000a R09: 000000000000fffb
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000002
> FS:  00007f019c95d700(0000) GS:ffff88024d100000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 00000000959e7000 CR4: 00000000001407e0
> DR0: 000000000249e000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Stack:
>  ffff88022ad836c0 00000002929a3d58 ffff88022ad836c0 0000000132313068
>  ffff8800929a3d6b 373231003277b6b0 ffff88022377b600 00000000898577d0
>  ffff88022377b6b0 000000000000278f 0000000000000010 0000000000000000
> Call Trace:
>  [<ffffffff8607738c>] release_task+0x4c/0x4a0
>  [<ffffffff86078aca>] wait_consider_task+0x70a/0xbe0
>  [<ffffffff860790e4>] do_wait+0x144/0x2d0
>  [<ffffffff8607967b>] SyS_wait4+0x7b/0x100
>  [<ffffffff86077110>] ? task_stopped_code+0x60/0x60
>  [<ffffffff8676371f>] tracesys+0xdd/0xe2
> Code: d4 e0 a9 86 48 03 45 a8 89 4d a4 44 8b 78 30 48 8b 40 38 44 89 f9 4c 8b a8 40 08 00 00 31 c0 e8 6e 21 0f 00 48 8d 75 b0 89 45 b4 <49> 8b 7d 00 e8 4e 8b fa ff 48 85 c0 49 89 c6 74 18 48 89 c7 e8 
> RIP  [<ffffffff8624a8f9>] proc_flush_task+0x99/0x1b0
>
>
> Right before the oops, the last thing fault injection logged wrt that pid was..
>
> FAULT_INJECTION: forcing a failure
> CPU: 0 PID: 8506 Comm: trinity-c124 Not tainted 3.16.0+ #41
>  0000000000000032 00000000898577d0 ffff8800929a3b08 ffffffff86759797
>  ffffffff86c6a300 ffff8800929a3b28 ffffffff86358c30 0000000000008020
>  0000000000008020 ffff8800929a3b38 ffffffff861c6850 ffff8800929a3b88
> Call Trace:
>  [<ffffffff86759797>] dump_stack+0x4e/0x7a
>  [<ffffffff86358c30>] should_fail+0x100/0x110
>  [<ffffffff861c6850>] should_failslab+0x40/0x50
>  [<ffffffff861c32de>] kmem_cache_alloc+0x5e/0x270
>  [<ffffffff86331e99>] ida_pre_get+0x69/0xf0
>  [<ffffffff86245c80>] ? proc_fill_super+0xa0/0xa0
>  [<ffffffff861da749>] get_anon_bdev+0x39/0x120
>  [<ffffffff86245c80>] ? proc_fill_super+0xa0/0xa0
>  [<ffffffff861da846>] set_anon_super+0x16/0x30
>  [<ffffffff8624605d>] proc_set_super+0x1d/0x80
>  [<ffffffff861db64a>] sget+0x33a/0x400
>  [<ffffffff86246040>] ? proc_root_lookup+0x40/0x40
>  [<ffffffff86245ed7>] proc_mount+0xa7/0x150
>  [<ffffffff861dc338>] mount_fs+0x38/0x1c0
>  [<ffffffff861f9574>] vfs_kern_mount+0x64/0x120
>  [<ffffffff861f9649>] kern_mount_data+0x19/0x30
>  [<ffffffff8624611c>] pid_ns_prepare_proc+0x1c/0x30
>  [<ffffffff86094334>] alloc_pid+0x474/0x4c0
>  [<ffffffff86047e10>] ? flush_tlb_mm_range+0x80/0x200
>  [<ffffffff8600207d>] ? copy_thread+0x11d/0x2c0
>  [<ffffffff86074140>] copy_process.part.29+0xab0/0x1be0
>  [<ffffffff8607542d>] do_fork+0xdd/0x400
>  [<ffffffff860a258b>] ? preempt_count_sub+0xab/0x100
>  [<ffffffff8634b563>] ? __this_cpu_preempt_check+0x13/0x20
>  [<ffffffff860757d6>] SyS_clone+0x16/0x20
>  [<ffffffff86763869>] stub_clone+0x69/0x90
>  [<ffffffff8676371f>] ? tracesys+0xdd/0xe2
>
> Should proc_flush_task just be checking for a NULL upid->ns ?
> Or is there something in the pid_ns_prepare_proc failure path
> that we're failing to undo ?
>
> thoughts?
>
> I don't know how feasible it would be to hit that in real life
> without the fault injection stuff, but an oops can't be the right
> thing to do in any case.

Hmm.

So what we can reconstruct from your data is:

8506 probably unshared a pid namespace.
8506 called fork/clone creating the first process in a pid namespace and
     alloc_pid fails.
8506 calls wait and the task it finds to be waited for is defective
     and proc_flush_task oopses.

*scratches head*

So I don't think the last fault had anything to do with this failure.

My dissassembly puts the code at the call of shrink_dcache_parent but I
don't think my dissambly matches your kernel.  Can you disassemble
proc_flush_task so we can at least see what is failing?


Eric
