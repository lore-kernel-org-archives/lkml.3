Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbbAFDmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 22:42:05 -0500
Received: from smtprelay0245.hostedemail.com ([216.40.44.245]:48047 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754420AbbAFDlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 22:41:52 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::,RULES_HIT:1:41:355:379:541:973:981:988:989:1260:1277:1311:1313:1314:1345:1381:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2393:2553:2559:2562:2636:2693:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4605:5007:6119:6120:6261:6755:7774:7875:7974:9121:10004:10848:11026:11232:11233:11658:11914:12043:12219:12294:12296:12438:12517:12519:12555:12679:13870:14096:14097:14394:21080:21094,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cent74_6757443f4a463
X-Filterd-Recvd-Size: 10937
Date: Mon, 5 Jan 2015 22:41:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-trace-users@vger.kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [ANNOUNCE] trace-cmd v2.5 released
Message-ID: <20150105224149.337a1988@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from version 2.4:

Added three new commands:

 o trace-cmd stream
    This starts ftrace tracing and reads the binary files and processes it
    to produce text output without the need to save to disk (or network).

 o trace-cmd profile
    This uses the stream infrastructure from above, but also keeps track
    of the data and analyzes it to produce various useful statistics.
    By default it enables function graph tracing with a depth of 1, to only
    show where user tasks entered the kernel. It also enables sched switch
    and sched wakeup events to see how long it took to wake up a task.
    It also enables stack tracing to display where the latencies are happening.
    There's lots of options to change the default settings to show more
    about how the kernel is working.

 o trace-cmd stat
    Shows what may be enabled in ftrace. There's times when events are enabled
    or kprobes are added, or even when filters are used, and it may be difficult
    to see what state ftrace is in. Using trace-cmd stat will show you the state
    that ftrace is in. It will display if a tracer is enabled and much more.

New options:

In trace-cmd record

  Added --profile, that enables the default profiling events (and function graph
  tracing with depth of 1). These are the same events that are enabled with the
  trace-cmd profile command.

In trace-cmd report

  Added --profile option that will read the data of the trace.dat file and report
  it the same as the trace-cmd profile command would.

Some improvements:

 o trace-cmd record will reset everything it touches after it is done recording.
    Before it use to leave some things still active, like options and such.
    Now, if you enable options for recording, it will reset them when finished,
    as well as triggers and filters. trace-cmd start, or trace-cmd record with
    the -k option will leave the changes as is when done.

 o trace-cmd reset now resets triggers and filters.


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git


Here's an example of what the new profiler does: (all times are in
nanoseconds)

 # trace-cmd profile sleep 1
[...]
task: sleep-3269
  Event: sched_switch:R (1) Total: 149811 Avg: 149811 Max: 149811 Min:149811
          | 
          + ftrace_raw_event_sched_switch (0xffffffff8109f310)
              100% (1) time:149811 max:149811 min:149811 avg:149811
               __schedule (0xffffffff816c1e91)
               preempt_schedule (0xffffffff816c237e)
               ___preempt_schedule (0xffffffff81351a69)
               cpu_stop_queue_work (0xffffffff81108dc6)
               stop_one_cpu (0xffffffff8110909a)
               sched_exec (0xffffffff810a119b)
               do_execveat_common.isra.31 (0xffffffff811de538)
               do_execve (0xffffffff811dea9c)
               SyS_execve (0xffffffff811ded2e)
               return_to_handler (0xffffffff816c8458)
               stub_execve (0xffffffff816c6929)
            
      
  Event: sched_switch:S (1) Total: 1000586336 Avg: 1000586336 Max: 1000586336 Min:1000586336
          | 
          + ftrace_raw_event_sched_switch (0xffffffff8109f310)
              100% (1) time:1000586336 max:1000586336 min:1000586336 avg:1000586336
               __schedule (0xffffffff816c1e91)
               schedule (0xffffffff816c23c9)
               do_nanosleep (0xffffffff816c4f2c)
               hrtimer_nanosleep (0xffffffff810dcd86)
               SyS_nanosleep (0xffffffff810dcea6)
               return_to_handler (0xffffffff816c8458)
               tracesys_phase2 (0xffffffff816c65b0)
            
      
  Event: sched_wakeup:0xcc5 (1) Total: 67019 Avg: 67019 Max: 67019 Min:67019
          | 
          + ftrace_raw_event_sched_wakeup_template (0xffffffff8109d960)
              100% (1) time:67019 max:67019 min:67019 avg:67019
               ttwu_do_wakeup (0xffffffff810a01a2)
               ttwu_do_activate.constprop.122 (0xffffffff810a0236)
               try_to_wake_up (0xffffffff810a3ec3)
               wake_up_process (0xffffffff810a4057)
               hrtimer_wakeup (0xffffffff810db772)
               __run_hrtimer (0xffffffff810dbd91)
               hrtimer_interrupt (0xffffffff810dc6b7)
               local_apic_timer_interrupt (0xffffffff810363e7)
               smp_trace_apic_timer_interrupt (0xffffffff816c8c6a)
               trace_apic_timer_interrupt (0xffffffff816c725a)
               finish_task_switch (0xffffffff8109c3a4)
               __schedule (0xffffffff816c1e11)
               schedule (0xffffffff816c23c9)
               schedule_preempt_disabled (0xffffffff816c26f8)
               return_to_handler (0xffffffff816c8458)
               cpu_startup_entry (0xffffffff810b55bf)
               start_secondary (0xffffffff81034821)
            
      
  Event: func: SyS_nanosleep() (1) Total: 1000713547 Avg: 1000713547 Max: 1000713547 Min:1000713547
  Event: func: do_notify_resume() (1) Total: 2115 Avg: 2115 Max: 2115 Min:2115
  Event: func: SyS_munmap() (1) Total: 18242 Avg: 18242 Max: 18242 Min:18242
  Event: func: sys_arch_prctl() (1) Total: 453 Avg: 453 Max: 453 Min:453
  Event: func: SyS_mprotect() (4) Total: 14749 Avg: 3687 Max: 5552 Min:2830
  Event: func: SyS_read() (1) Total: 1840 Avg: 1840 Max: 1840 Min:1840
  Event: func: sys_close() (5) Total: 3760 Avg: 752 Max: 1300 Min:591
  Event: func: sys_newfstat() (3) Total: 2428 Avg: 809 Max: 963 Min:713
  Event: func: SyS_open() (3) Total: 18524 Avg: 6174 Max: 8139 Min:4821
  Event: func: sys_access() (1) Total: 3330 Avg: 3330 Max: 3330 Min:3330
  Event: func: SyS_mmap() (8) Total: 25451 Avg: 3181 Max: 6508 Min:1682
  Event: func: sys_brk() (4) Total: 3209 Avg: 802 Max: 2184 Min:315
  Event: func: sys_execve() (5) Total: 476177 Avg: 95235 Max: 461530 Min:2220
  Event: func: syscall_trace_enter_phase2() (38) Total: 23190 Avg: 610 Max: 891 Min:323
  Event: func: syscall_trace_enter_phase1() (38) Total: 10393 Avg: 273 Max: 527 Min:160
  Event: func: __do_page_fault() (54) Total: 321093 Avg: 5946 Max: 74358 Min:721
  Event: func: syscall_trace_leave() (38) Total: 26608 Avg: 700 Max: 971 Min:378
  Event: func: __sb_end_write() (1) Total: 400 Avg: 400 Max: 400 Min:400
  Event: func: fsnotify() (1) Total: 619 Avg: 619 Max: 619 Min:619
  Event: func: __fsnotify_parent() (1) Total: 358 Avg: 358 Max: 358 Min:358
  Event: func: mutex_unlock() (2) Total: 40585 Avg: 20292 Max: 40290 Min:295
  Event: func: smp_trace_irq_work_interrupt() (8) Total: 331596 Avg: 41449 Max: 115301 Min:1013
  Event: sys_enter:35 (1) Total: 1000715243 Avg: 1000715243 Max: 1000715243 Min:1000715243
  Event: sys_enter:11 (1) Total: 77933 Avg: 77933 Max: 77933 Min:77933
  Event: sys_enter:158 (1) Total: 1854 Avg: 1854 Max: 1854 Min:1854
  Event: sys_enter:10 (4) Total: 136307 Avg: 34076 Max: 120779 Min:4068
  Event: sys_enter:0 (1) Total: 3014 Avg: 3014 Max: 3014 Min:3014
  Event: sys_enter:3 (5) Total: 65336 Avg: 13067 Max: 57459 Min:1907
  Event: sys_enter:5 (3) Total: 6096 Avg: 2032 Max: 2253 Min:1903
  Event: sys_enter:2 (3) Total: 24618 Avg: 8206 Max: 9456 Min:6272
  Event: sys_enter:21 (1) Total: 5052 Avg: 5052 Max: 5052 Min:5052
  Event: sys_enter:9 (8) Total: 38694 Avg: 4836 Max: 9998 Min:3108
  Event: sys_enter:12 (4) Total: 8893 Avg: 2223 Max: 3539 Min:1514
  Event: sys_enter:59 (5) Total: 481653 Avg: 96330 Max: 462822 Min:2984
  Event: page_fault_user:0x398d86b630 (1)
  Event: page_fault_user:0x398d844de0 (1)
  Event: page_fault_user:0x398d8d9020 (1)
  Event: page_fault_user:0xc84008 (1)
  Event: page_fault_user:0x7ff5b75f9074 (1)
  Event: page_fault_user:0x7ff5b7500ed0 (1)
  Event: page_fault_user:0x7ff5b7630950 (1)
  Event: page_fault_user:0x7ff5b74eb644 (1)
  Event: page_fault_user:0x7ff5b74c2560 (1)
  Event: page_fault_user:0x7ff5b749c010 (1)
  Event: page_fault_user:0xc83008 (1)
  Event: page_fault_user:0x398d900510 (1)
  Event: page_fault_user:0x398dbb3ae8 (1)
  Event: page_fault_user:0x398d87f490 (1)
  Event: page_fault_user:0x398d8eb660 (1)
  Event: page_fault_user:0x398d8bd730 (1)
  Event: page_fault_user:0x398d9625d9 (1)
  Event: page_fault_user:0x398d931810 (1)
  Event: page_fault_user:0x398dbb7114 (1)
  Event: page_fault_user:0x398d837610 (1)
  Event: page_fault_user:0x398d89e860 (1)
  Event: page_fault_user:0x398d8f23b0 (1)
  Event: page_fault_user:0x398dbb4510 (1)
  Event: page_fault_user:0x398dbad6f0 (1)
  Event: page_fault_user:0x398dbb1018 (1)
  Event: page_fault_user:0x398d977b37 (1)
  Event: page_fault_user:0x398d92eb60 (1)
  Event: page_fault_user:0x398d8abff0 (1)
  Event: page_fault_user:0x398dbb0d30 (1)
  Event: page_fault_user:0x398dbb6c24 (1)
  Event: page_fault_user:0x398d821c50 (1)
  Event: page_fault_user:0x398dbb6c20 (1)
  Event: page_fault_user:0x398d886350 (1)
  Event: page_fault_user:0x7ff5bd88d000 (1)
  Event: page_fault_user:0x7ff5bd88c740 (1)
  Event: page_fault_user:0x7ff5bd88e000 (1)
  Event: page_fault_user:0x398d816230 (1)
  Event: page_fault_user:0x398d8002b8 (1)
  Event: page_fault_user:0x398dbb0b40 (1)
  Event: page_fault_user:0x398dbb2880 (1)
  Event: page_fault_user:0x7ff5bd8a385c (1)
  Event: page_fault_user:0x7ff5bd88f000 (1)
  Event: page_fault_user:0x606e70 (1)
  Event: page_fault_user:0x7ff5bd8ac010 (1)
  Event: page_fault_user:0x7fff9e7fe038 (1)
  Event: page_fault_user:0x606da8 (1)
  Event: page_fault_user:0x400040 (1)
  Event: page_fault_user:0x7fff9e7cfff8 (1)
  Event: page_fault_user:0x398d222218 (1)
  Event: page_fault_user:0x398d015120 (1)
  Event: page_fault_user:0x398d220ce8 (1)
  Event: page_fault_user:0x398d220b80 (1)
  Event: page_fault_user:0x398d001590 (1)
  Event: page_fault_user:0x398d838490 (1)
  Event: softirq_raise:RCU (1) Total: 4123 Avg: 4123 Max: 4123 Min:4123
  Event: softirq_raise:TIMER (1) Total: 3889 Avg: 3889 Max: 3889 Min:3889
  Event: softirq_entry:RCU (1) Total: 952 Avg: 952 Max: 952 Min:952
  Event: softirq_entry:TIMER (1) Total: 539 Avg: 539 Max: 539 Min:539


Don't forget to install the docs:

  make doc
  sudo make install_doc

and read man trace-cmd-profile for more details.

Enjoy,

-- Steve
