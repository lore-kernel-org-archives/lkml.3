Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbaKSVBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:01:45 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35124 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666AbaKSVBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:01:41 -0500
From: Andy Lutomirski <luto@amacapital.net>
X-Google-Original-From: Andy Lutomirski <luto@mit.edu>
Message-ID: <546D0530.8040800@mit.edu>
Date: Wed, 19 Nov 2014 13:01:36 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: frequent lockups in 3.18rc4
References: <CA+55aFy9dWtS5qh=-HT9M7hQPeWDMvdxEynr0p4aRkiGkV6gyQ@mail.gmail.com> <20141118020959.GA2091@redhat.com> <CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com> <20141118023930.GA2871@redhat.com> <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com> <20141118145234.GA7487@redhat.com> <alpine.DEB.2.11.1411181914020.3909@nanos> <20141118215540.GD35311@redhat.com> <20141119021902.GA14216@redhat.com> <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com> <20141119145902.GA13387@redhat.com>
In-Reply-To: <20141119145902.GA13387@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 06:59 AM, Dave Jones wrote:
> On Tue, Nov 18, 2014 at 08:40:55PM -0800, Linus Torvalds wrote:
>  > On Tue, Nov 18, 2014 at 6:19 PM, Dave Jones <davej@redhat.com> wrote:
>  > >
>  > > NMI watchdog: BUG: soft lockup - CPU#2 stuck for 21s! [trinity-c42:31480]
>  > > CPU: 2 PID: 31480 Comm: trinity-c42 Not tainted 3.18.0-rc5+ #91 [loadavg: 174.61 150.35 148.64 9/411 32140]
>  > > RIP: 0010:[<ffffffff8a1798b4>]  [<ffffffff8a1798b4>] context_tracking_user_enter+0xa4/0x190
>  > > Call Trace:
>  > >  [<ffffffff8a012fc5>] syscall_trace_leave+0xa5/0x160
>  > >  [<ffffffff8a7d8624>] int_check_syscall_exit_work+0x34/0x3d
>  > 
>  > Hmm, if we are getting soft-lockups here, maybe it suggest too much exit-work.
>  > 
>  > Some TIF_NOHZ loop, perhaps? You have nohz on, don't you?
>  > 
>  > That makes me wonder: does the problem go away if you disable NOHZ?
> 
> Aparently not.

TIF_NOHZ is not the same thing as NOHZ.  Can you try a kernel with
CONFIG_CONTEXT_TRACKING=n?  Doing that may involve fiddling with RCU
settings a bit.  The normal no HZ idle stuff has nothing to do with
TIF_NOHZ, and you either have TIF_NOHZ set or you have some kind of
thread_info corruption going on here.

Hmm.  This isn't a stack overflow, is it?  That could cause all of these
problems quite easily, although I'd expect other symptoms, too.

> 
> NMI watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [trinity-c75:25175]
> CPU: 3 PID: 25175 Comm: trinity-c75 Not tainted 3.18.0-rc5+ #92 [loadavg: 168.72 151.72 150.38 9/410 27945]
> task: ffff8800364e44d0 ti: ffff880192d2c000 task.ti: ffff880192d2c000
> RIP: 0010:[<ffffffff94175be7>]  [<ffffffff94175be7>] context_tracking_user_exit+0x57/0x120

This RIP should be impossible if context tracking is off.

> RSP: 0018:ffff880192d2fee8  EFLAGS: 00000246
> RAX: 0000000000000000 RBX: 0000000100000046 RCX: 000000336ee35b47

                                    ^^^^^^^^^

That is a strange coincidence.  Where did 0x46 | (1<<32) come from?
That's a sensible interrupts-disabled flags value with the high part set
to 0x1.  Those high bits are undefined, but they ought to all be zero.

> RDX: 0000000000000001 RSI: ffffffff94ac1e84 RDI: ffffffff94a93725
> RBP: ffff880192d2fef8 R08: 00007f9b74d0b740 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: ffffffff940d8503
> R13: ffff880192d2fe98 R14: ffffffff943884e7 R15: ffff880192d2fe48
> FS:  00007f9b74d0b740(0000) GS:ffff880244600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000336f1b7740 CR3: 0000000229a95000 CR4: 00000000001407e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Stack:
>  ffff880192d30000 0000000000080000 ffff880192d2ff78 ffffffff94012c25
>  00007f9b747a5000 00007f9b747a5068 0000000000000000 0000000000000000
>  0000000000000000 ffffffff9437b3be 0000000000000000 0000000000000000
> Call Trace:
>  [<ffffffff94012c25>] syscall_trace_enter_phase1+0x125/0x1a0
>  [<ffffffff9437b3be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff947d41bf>] tracesys+0x14/0x4a
> Code: 42 fd ff 48 c7 c7 7a 1e ac 94 e8 25 29 21 00 65 8b 04 25 34 f7 1c 00 83 f8 01 74 28 f6 c7 02 74 13 0f 1f 00 e8 bb 43 fd ff 53 9d <5b> 41 5c 5d c3 0f 1f 40 00 53 9d e8 89 42 fd ff eb ee 0f 1f 80 
> sending NMI to other CPUs:
> NMI backtrace for cpu 1
> CPU: 1 PID: 25164 Comm: trinity-c64 Not tainted 3.18.0-rc5+ #92 [loadavg: 168.72 151.72 150.38 9/410 27945]
> task: ffff88011600dbc0 ti: ffff8801a99a4000 task.ti: ffff8801a99a4000
> RIP: 0010:[<ffffffff940fb71e>]  [<ffffffff940fb71e>] generic_exec_single+0xee/0x1a0
> RSP: 0018:ffff8801a99a7d18  EFLAGS: 00000202
> RAX: 0000000000000000 RBX: ffff8801a99a7d20 RCX: 0000000000000038
> RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
> RBP: ffff8801a99a7d78 R08: ffff880242b57ce0 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000003
> R13: 0000000000000001 R14: ffff880083c28948 R15: ffffffff94166aa0
> FS:  00007f9b74d0b740(0000) GS:ffff880244200000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000001 CR3: 00000001d8611000 CR4: 00000000001407e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Stack:
>  ffff8801a99a7d28 0000000000000000 ffffffff94166aa0 ffff880083c28948
>  0000000000000003 00000000e38f9aac ffff880083c28948 00000000ffffffff
>  0000000000000003 ffffffff94166aa0 ffff880083c28948 0000000000000001
> Call Trace:
>  [<ffffffff94166aa0>] ? perf_swevent_add+0x120/0x120
>  [<ffffffff94166aa0>] ? perf_swevent_add+0x120/0x120
>  [<ffffffff940fb89a>] smp_call_function_single+0x6a/0xe0
>  [<ffffffff940a172b>] ? preempt_count_sub+0x7b/0x100
>  [<ffffffff941671aa>] perf_event_read+0xca/0xd0
>  [<ffffffff94167240>] perf_event_read_value+0x90/0xe0
>  [<ffffffff941689c6>] perf_read+0x226/0x370
>  [<ffffffff942fbfb7>] ? security_file_permission+0x87/0xa0
>  [<ffffffff941eafff>] vfs_read+0x9f/0x180
>  [<ffffffff941ebbd8>] SyS_read+0x58/0xd0
>  [<ffffffff947d42c9>] tracesys_phase2+0xd4/0xd9

Riddle me this: what are we doing in tracesys_phase2?  This is a full
slow-path syscall.  TIF_NOHZ doesn't cause that, I think.  I'd love to
see the value of ti->flags here.  Is trinity using ptrace?

Um.  There's a bug.  Patch coming after lunch.  No clue whether it will
help here.

--Andy

> Code: 48 89 de 48 03 14 c5 20 65 d1 94 48 89 df e8 8a 4b 28 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 4d c8 65 48 33 0c 25 28 00 00 00 0f 85 8e 00 
> NMI backtrace for cpu 0
> INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 35.055 msecs
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc5+ #92 [loadavg: 168.72 151.72 150.38 11/410 27945]
> task: ffffffff94c164c0 ti: ffffffff94c00000 task.ti: ffffffff94c00000
> RIP: 0010:[<ffffffff943dd415>]  [<ffffffff943dd415>] intel_idle+0xd5/0x180
> RSP: 0018:ffffffff94c03e28  EFLAGS: 00000046
> RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
> RDX: 0000000000000000 RSI: ffffffff94c03fd8 RDI: 0000000000000000
> RBP: ffffffff94c03e58 R08: 000000008baf8b86 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
> R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff94c00000
> FS:  0000000000000000(0000) GS:ffff880244000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f162e060000 CR3: 0000000014c11000 CR4: 00000000001407f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Stack:
>  0000000094c03e58 5955c5b31ad5e8cf ffffe8fffee031a8 0000000000000005
>  ffffffff94ca9dc0 0000000000000000 ffffffff94c03ea8 ffffffff94661f05
>  00001cb7dcf6fd93 ffffffff94ca9f90 ffffffff94c00000 ffffffff94d18870
> Call[31557.908912] NMI backtrace for cpu 2
> INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 68.178 msecs
> CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.18.0-rc5+ #92 [loadavg: 168.72 151.72 150.38 10/410 27945]
> task: ffff880242b596f0 ti: ffff880242b6c000 task.ti: ffff880242b6c000
> RIP: 0010:[<ffffffff943dd415>]  [<ffffffff943dd415>] intel_idle+0xd5/0x180
> RSP: 0018:ffff880242b6fdf8  EFLAGS: 00000046
> RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
> RDX: 0000000000000000 RSI: ffff880242b6ffd8 RDI: 0000000000000002
> RBP: ffff880242b6fe28 R08: 000000008baf8b86 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
> R13: 0000000000000032 R14: 0000000000000004 R15: ffff880242b6c000
> FS:  0000000000000000(0000) GS:ffff880244400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000014c11000 CR4: 00000000001407e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Stack:
>  0000000242b6fe28 da97aa9b9f42090a ffffe8ffff2031a8 0000000000000005
>  ffffffff94ca9dc0 0000000000000002 ffff880242b6fe78 ffffffff94661f05
>  00001cb7dcdd1af6 ffffffff94ca9f90 ffff880242b6c000 ffffffff94d18870
> Call Trace:
>  [<ffffffff94661f05>] cpuidle_enter_state+0x55/0x1c0
>  [<ffffffff94662127>] cpuidle_enter+0x17/0x20
>  [<ffffffff940b94a3>] cpu_startup_entry+0x423/0x4d0
>  [<ffffffff9402b763>] start_secondary+0x1a3/0x220
> Code: 31 d2 65 48 8b 34 25 08 ba 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 ba 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
> INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 95.994 msecs
> 
> 
> <tangent>
> 
> Also, today I learned we can reach the perf_event_read code from
> read(). Given I had /proc/sys/kernel/perf_event_paranoid set to 1,
> I'm not sure how this is even possible. The only user of perf_fops
> is perf_event_open syscall _after_ it's checked that sysctl.
> 
> Oh, there's an ioctl path to perf too. Though trinity
> doesn't know anything about it, so I find it surprising if it
> managed to pull the right combination of entropy to make that
> do the right thing.  Still, that ioctl path probably needs
> to also be checking that sysctl shouldn't it ?
> 
> 	Dave
> 

