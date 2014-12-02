Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348AbaLBXcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:32:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:46970 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbaLBXct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:32:49 -0500
Message-ID: <547E4C14.6040509@oracle.com>
Date: Tue, 02 Dec 2014 18:32:36 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?windows-1252?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <20141127225637.GA24019@redhat.com> <m5dart$co$1@ger.gmane.org> <CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com> <547b8a45.6e608c0a.20f9.1002@mx.google.com> <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com> <547bbe36.48548c0a.105c.779c@mx.google.com> <20141201191431.GA17385@linux.vnet.ibm.com> <547ccf74.a5198c0a.25de.26d9@mx.google.com> <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com> <20141201230339.GA20487@ret.masoncoding.com> <20141202193252.GB17595@redhat.com>
In-Reply-To: <20141202193252.GB17595@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 02:32 PM, Dave Jones wrote:
> On Mon, Dec 01, 2014 at 06:08:38PM -0500, Chris Mason wrote:
>  > I'm not sure if this is related, but running trinity here, I noticed it
>  > was stuck at 100% system time on every CPU.  perf report tells me we are
>  > spending all of our time in spin_lock under the sync system call.
>  > 
>  > I think it's coming from contention in the bdi_queue_work() call from
>  > inside sync_inodes_sb, which is spin_lock_bh(). 
>  > 
>  > I wonder if we're just spinning so hard on this one bh lock that we're
>  > starving the watchdog?
>  > 
>  > Dave, do you have spinlock debugging on?  
> 
> That has been a constant, yes. I can try with that disabled some time.

Here's my side of the story: I was observing RCU lockups which went away when
I disabled verbose printing for fault injections. It seems that printing one
line ~10 times a second can cause that...

I've disabled lock debugging to see if anything new will show up, and hit
something that may be related:

[  787.894288] ================================================================================
[  787.897074] UBSan: Undefined behaviour in kernel/sched/fair.c:4541:17
[  787.898981] signed integer overflow:
[  787.900066] 361516561629678 * 101500 cannot be represented in type 'long long int'
[  787.900066] CPU: 18 PID: 12958 Comm: trinity-c103 Not tainted 3.18.0-rc6-next-20141201-sasha-00070-g028060a-dirty #1528
[  787.900066]  0000000000000000 0000000000000000 ffffffff93b0f890 ffff8806e3eff918
[  787.900066]  ffffffff91f1cf26 1ffffffff3c2de73 ffffffff93b0f8a8 ffff8806e3eff938
[  787.900066]  ffffffff91f1fb90 1ffffffff3c2de73 ffffffff93b0f8a8 ffff8806e3eff9f8
[  787.900066] Call Trace:
[  787.900066] dump_stack (lib/dump_stack.c:52)
[  787.900066] ubsan_epilogue (lib/ubsan.c:159)
[  787.900066] handle_overflow (lib/ubsan.c:191)
[  787.900066] ? __do_page_fault (arch/x86/mm/fault.c:1220)
[  787.900066] ? local_clock (kernel/sched/clock.c:392)
[  787.900066] __ubsan_handle_mul_overflow (lib/ubsan.c:218)
[  787.900066] select_task_rq_fair (kernel/sched/fair.c:4541 kernel/sched/fair.c:4755)
[  787.900066] try_to_wake_up (kernel/sched/core.c:1415 kernel/sched/core.c:1724)
[  787.900066] ? trace_hardirqs_on_thunk (arch/x86/lib/thunk_64.S:33)
[  787.900066] default_wake_function (kernel/sched/core.c:2979)
[  787.900066] ? get_parent_ip (kernel/sched/core.c:2559)
[  787.900066] autoremove_wake_function (kernel/sched/wait.c:295)
[  787.900066] ? get_parent_ip (kernel/sched/core.c:2559)
[  787.900066] __wake_up_common (kernel/sched/wait.c:73)
[  787.900066] __wake_up_sync_key (include/linux/spinlock.h:364 kernel/sched/wait.c:146)
[  787.900066] pipe_write (fs/pipe.c:466)
[  787.900066] ? kasan_poison_shadow (mm/kasan/kasan.c:48)
[  787.900066] ? new_sync_read (fs/read_write.c:480)
[  787.900066] do_iter_readv_writev (fs/read_write.c:681)
[  787.900066] compat_do_readv_writev (fs/read_write.c:1029)
[  787.900066] ? wait_for_partner (fs/pipe.c:340)
[  787.900066] ? _raw_spin_unlock (./arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
[  787.900066] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[  787.900066] ? syscall_trace_enter_phase1 (include/linux/context_tracking.h:27 arch/x86/kernel/ptrace.c:1486)
[  787.900066] compat_writev (fs/read_write.c:1145)
[  787.900066] compat_SyS_writev (fs/read_write.c:1163 fs/read_write.c:1151)
[  787.900066] ia32_do_call (arch/x86/ia32/ia32entry.S:446)
[  787.900066] ================================================================================

(For Linus asking himself "what the hell is this UBSan thing, I didn't merge that!" - it's an
undefined behaviour sanitizer that works with gcc5.)


Thanks,
Sasha
