Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab3DORf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:35:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935006Ab3DORf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:35:27 -0400
Date: Mon, 15 Apr 2013 13:34:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: 3.9-rc5: Encountedred INFO: rcu_sched self-detected stall on CPU
 due to 09a9f1d27
Message-ID: <20130415173424.GB31868@redhat.com>
References: <20130412181348.GA2253@redhat.com>
 <CANN689GKfxM3R96wgY8-+FftpVT76zMFcHdgKccNKnjHGfYq1Q@mail.gmail.com>
 <20130415163552.GA31868@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130415163552.GA31868@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 12:35:52PM -0400, Vivek Goyal wrote:

[..]
> > My first guess would be that mmap_sem is held during exec, so you
> > can't have __mm_populate() try holding it recursively.
> 
> I think it is not mmap_sem as even with VM_LOCKED, we take mmap_sem
> and things are fine. 
> 
> So things work till 3.8 and break in 3.8-rc1 (with both VM_LOCKED and
> VM_POPULATE specifed). I will do git bisect and try to figure out which
> is first commit which has the issue.

Ok, following seems to be first bad commit.

commit bebeb3d68b24bb4132d452c5707fe321208bcbcd
Author: Michel Lespinasse <walken@google.com>
Date:   Fri Feb 22 16:32:37 2013 -0800

    mm: introduce mm_populate() for populating new vmas

I have locked down /sbin/kexec. And I get following traceback after a while.

Thanks
Vivek

[   93.130001] INFO: rcu_sched self-detected stall on CPU[   93.131007]
INFO: rcu_sched detected stalls on CPUs/tasks: { 2} (detected by 3,
t=60002 jiffies, g=2786, c=2785, q=10480)
[   93.131016] Task dump for CPU 2:
[   93.131018] kexec           R  running task        0  4861   2982
0x00000088
[   93.131022]  ffff88013252bc68 ffffffff8109ab12 00000000ffffffff
0000000000000000
[   93.131026]  ffff88013252bc58 ffff88013a43c180 ffffffff81881edc
00007feed583221a
[   93.131028]  00007feed5832000 0000000000000000 ffff88013a43c828
ffff88013a43c180
[   93.131032] Call Trace:
[   93.131032]  [<ffffffff8109ab12>] ? mark_held_locks+0x82/0x130
[   93.131040]  [<ffffffff81881edc>] ? retint_restore_args+0xe/0xe
[   93.131045]  [<ffffffff8109ab12>] ? mark_held_locks+0x82/0x130
[   93.131047]  [<ffffffff81881edc>] ? retint_restore_args+0xe/0xe
[   93.131049]  [<ffffffff8109acc5>] ?
trace_hardirqs_on_caller+0x105/0x190
[   93.131051]  [<ffffffff8132913e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   93.131055]  [<ffffffff81881edc>] ? retint_restore_args+0xe/0xe
[   93.131058]  [<ffffffff81127898>] ? __get_user_pages+0x1d8/0x540
[   93.131061]  [<ffffffff81129fb7>] ? __mlock_vma_pages_range+0x67/0x70
[   93.131064]  [<ffffffff8112a721>] ? __mm_populate+0x71/0x150
[   93.131066]  [<ffffffff8111d01f>] ? vm_mmap_pgoff+0xdf/0xf0
[   93.131071]  [<ffffffff8112c839>] ? sys_mmap_pgoff+0xa9/0x180
[   93.131073]  [<ffffffff8109acc5>] ?
trace_hardirqs_on_caller+0x105/0x190
[   93.131076]  [<ffffffff8132913e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   93.131078]  [<ffffffff81006972>] ? sys_mmap+0x22/0x30
[   93.131081]  [<ffffffff8188a342>] ? system_call_fastpath+0x16/0x1b

[   93.130001]  { 2}  (t=60153 jiffies g=2786 c=2785 q=10480)
[   93.130001] Pid: 4861, comm: kexec Not tainted 3.8.0+ #270
[   93.130001] Call Trace:
[   93.130001]  <IRQ>  [<ffffffff810ce69a>]
rcu_check_callbacks+0x21a/0x760
[   93.130001]  [<ffffffff810d22ec>] ? acct_account_cputime+0x1c/0x20
[   93.130001]  [<ffffffff81077570>] ? account_system_time+0x160/0x230
[   93.130001]  [<ffffffff8104f388>] update_process_times+0x48/0x80
[   93.130001]  [<ffffffff810934ad>] tick_sched_handle+0x3d/0x50
[   93.130001]  [<ffffffff810936b5>] tick_sched_timer+0x45/0x70
[   93.130001]  [<ffffffff81067661>] __run_hrtimer+0x81/0x220
[   93.130001]  [<ffffffff81093670>] ? tick_nohz_handler+0xa0/0xa0
[   93.130001]  [<ffffffff8108ce7c>] ? ktime_get_update_offsets+0x4c/0xd0
[   93.130001]  [<ffffffff81067fb7>] hrtimer_interrupt+0xf7/0x250
[   93.130001]  [<ffffffff8188bdb9>] smp_apic_timer_interrupt+0x69/0x99
[   93.130001]  [<ffffffff8188af6f>] apic_timer_interrupt+0x6f/0x80
[   93.130001]  <EOI>  [<ffffffff81881edc>] ? retint_restore_args+0xe/0xe
[   93.130001]  [<ffffffff81127898>] ? __get_user_pages+0x1d8/0x540
[   93.130001]  [<ffffffff81129fb7>] __mlock_vma_pages_range+0x67/0x70
[   93.130001]  [<ffffffff8112a721>] __mm_populate+0x71/0x150
[   93.130001]  [<ffffffff8111d01f>] vm_mmap_pgoff+0xdf/0xf0
[   93.130001]  [<ffffffff8112c839>] sys_mmap_pgoff+0xa9/0x180
[   93.130001]  [<ffffffff8109acc5>] ?
trace_hardirqs_on_caller+0x105/0x190
[   93.130001]  [<ffffffff8132913e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   93.130001]  [<ffffffff81006972>] sys_mmap+0x22/0x30
[   93.130001]  [<ffffffff8188a342>] system_call_fastpath+0x16/0x1b
