Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaGIBts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 21:49:48 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30500 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaGIBtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 21:49:46 -0400
Message-ID: <53BC9FB4.9060108@oracle.com>
Date: Tue, 08 Jul 2014 21:49:40 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: fs: pipe: hung task when splicing from pipe to eventfd
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've noticed a scenario where a machine will hang waiting on pipe mutex indefinitely,
triggering the hung task timer and possibly rebooting the system.

The problem happens when we have a process stuck in an uninterruptable sleep waiting
on a pipe's mutex:

[  603.612650] trinity-c4      D 0000000000000000 12552  8967   8561 0x00000004
[  603.613402]  ffff88039f63fd18 0000000000000002 ffffffff9ebfc9f0 0000000000000000
[  603.614221]  ffff88039ffeb000 ffff88039f63ffd8 00000000001d7740 00000000001d7740
[  603.614976]  ffff88038d950000 ffff88039ffeb000 ffff88039f63fd08 ffff8802fe9a89d8
[  603.615708] Call Trace:
[  603.615940] schedule (kernel/sched/core.c:2841)
[  603.616380] schedule_preempt_disabled (kernel/sched/core.c:2868)
[  603.617000] mutex_lock_nested (kernel/locking/mutex.c:532 kernel/locking/mutex.c:584)
[  603.617527] ? pipe_lock_nested (fs/pipe.c:61)
[  603.618239] ? pipe_lock_nested (fs/pipe.c:61)
[  603.618808] pipe_lock_nested (fs/pipe.c:61)
[  603.619307] pipe_lock (fs/pipe.c:69)
[  603.619869] vmsplice_to_user (fs/splice.c:1572)
[  603.621263] ? vtime_account_user (kernel/sched/cputime.c:687)
[  603.622131] ? get_parent_ip (kernel/sched/core.c:2555)
[  603.622994] ? context_tracking_user_exit (include/linux/vtime.h:89 include/linux/jump_label.h:115 include/trace/events/context_tracking.h:47 kernel/context_tracking.c:180)
[  603.624056] ? preempt_count_sub (kernel/sched/core.c:2611)
[  603.625085] ? context_tracking_user_exit (./arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:184 (discriminator 2))
[  603.626115] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[  603.627192] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2557 kernel/locking/lockdep.c:2599)
[  603.628230] ? __fget_light (fs/file.c:685)
[  603.629115] SyS_vmsplice (include/linux/file.h:38 fs/splice.c:1657 fs/splice.c:1639)
[  603.629989] tracesys (arch/x86/kernel/entry_64.S:542)
[  603.630975] 1 lock held by trinity-c4/8967:
[  603.631652] #0: (&pipe->mutex/1){+.+.+.}, at: pipe_lock_nested (fs/pipe.c:61)

But that pipe is stuck in a splice operation into an eventfd which will wait until it's
read from since the counter overflowed:

[  610.022055] trinity-c16     S 0000000000000010 12576  9657   8561 0x00000000
[  610.023911]  ffff88025a90fcf8 0000000000000002 ffffffff9b4e32c0 ffff88025a910000
[  610.025615]  ffff88025a910000 ffff88025a90ffd8 00000000001d7740 00000000001d7740
[  610.027242]  ffff880041438000 ffff88025a910000 ffff88025a90fce8 ffff88025a910000
[  610.028799] Call Trace:
[  610.029329] ? _raw_spin_unlock_irq (./arch/x86/include/asm/paravirt.h:819 include/linux/spinlock_api_smp.h:168 kernel/locking/spinlock.c:199)
[  610.030610] schedule (kernel/sched/core.c:2841)
[  610.032205] eventfd_write (include/linux/spinlock.h:328 fs/eventfd.c:274)
[  610.033317] ? try_to_wake_up (kernel/sched/core.c:2936)
[  610.035108] ? do_splice_to (fs/splice.c:1068)
[  610.036491] __kernel_write (fs/read_write.c:502)
[  610.037612] ? do_splice_to (fs/splice.c:1068)
[  610.038881] write_pipe_buf (fs/splice.c:1078)
[  610.040742] ? pipe_lock_nested (fs/pipe.c:61)
[  610.042382] __splice_from_pipe (fs/splice.c:770 fs/splice.c:886)
[  610.043599] ? do_splice_to (fs/splice.c:1068)
[  610.044810] ? do_splice_to (fs/splice.c:1068)
[  610.046086] splice_from_pipe (fs/splice.c:922)
[  610.047345] ? context_tracking_user_exit (include/linux/vtime.h:89 include/linux/jump_label.h:115 include/trace/events/context_tracking.h:47 kernel/context_tracking.c:180)
[  610.049100] default_file_splice_write (fs/splice.c:1087)
[  610.051041] SyS_splice (include/linux/fs.h:2270 fs/splice.c:1394 fs/splice.c:1701 fs/splice.c:1686)
[  610.052445] ? trace_hardirqs_on (kernel/locking/lockdep.c:2607)
[  610.053919] tracesys (arch/x86/kernel/entry_64.S:542)

I don't have a good idea how to fix it, I've considered adding a timeout to that schedule()
and returning -ERESTARTSYS which should comply with what the user might see, but it seems
slightly ugly.


Thanks,
Sasha
