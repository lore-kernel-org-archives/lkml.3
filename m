Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3IKPMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:12:05 -0400
Received: from mail.openrapids.net ([64.15.138.104]:43245 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754052Ab3IKPMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:12:02 -0400
Date: Wed, 11 Sep 2013 11:12:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Cc: lttng-dev@lists.lttng.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: [RFC PATCH lttng-modules] Fix: use timekeeping_is_busy() to fix
	ktime_get() hard lockup
Message-ID: <20130911151200.GB19800@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an issue affecting lttng-modules with Linux kernels starting with
3.10.

This patch depends on Linux kernel patch:
"timekeeping: introduce timekeeping_is_busy()"

Starting from Linux kernel commit
06c017fdd4dc48451a29ac37fc1db4a3f86b7f40 "timekeeping: Hold
timekeepering locks in do_adjtimex and hardpps" (3.10 kernels), the
xtime write seqlock is held across calls to __do_adjtimex(), which
includes a call to notify_cmos_timer(), and hence
schedule_delayed_work().

This introduces a side-effect for a set of tracepoints, including mainly
the workqueue tracepoints: a tracer hooking on those tracepoints and
reading current time with ktime_get() will cause hard system LOCKUP such
as:

WARNING: CPU: 6 PID: 2258 at kernel/watchdog.c:245 watchdog_overflow_callback+0x93/0x9e()
Watchdog detected hard LOCKUP on cpu 6
Modules linked in: lttng_probe_workqueue(O) lttng_probe_vmscan(O) lttng_probe_udp(O) lttng_probe_timer(O) lttng_probe_s]
CPU: 6 PID: 2258 Comm: ntpd Tainted: G           O 3.11.0 #158
Hardware name: Supermicro X7DAL/X7DAL, BIOS 6.00 12/03/2007
0000000000000000 ffffffff814f83eb ffffffff813b206a ffff88042fd87c78
ffffffff8106a07c 0000000000000000 ffffffff810c94c2 0000000000000000
ffff88041f31bc00 0000000000000000 ffff88042fd87d68 ffff88042fd87ef8
Call Trace:
<NMI>  [<ffffffff813b206a>] ? dump_stack+0x41/0x51
[<ffffffff8106a07c>] ? warn_slowpath_common+0x79/0x92
[<ffffffff810c94c2>] ? watchdog_overflow_callback+0x93/0x9e
[<ffffffff8106a12d>] ? warn_slowpath_fmt+0x45/0x4a
[<ffffffff810c94c2>] ? watchdog_overflow_callback+0x93/0x9e
[<ffffffff810c942f>] ? watchdog_enable_all_cpus.part.2+0x31/0x31
[<ffffffff810ecc66>] ? __perf_event_overflow+0x12c/0x1ae
[<ffffffff810eab60>] ? perf_event_update_userpage+0x13/0xc2
[<ffffffff81016820>] ? intel_pmu_handle_irq+0x26a/0x2fd
[<ffffffff813b7a0b>] ? perf_event_nmi_handler+0x24/0x3d
[<ffffffff813b728f>] ? nmi_handle.isra.3+0x58/0x12f
[<ffffffff813b7a59>] ? perf_ibs_nmi_handler+0x35/0x35
[<ffffffff813b7404>] ? do_nmi+0x9e/0x2bc
[<ffffffff813b6af7>] ? end_repeat_nmi+0x1e/0x2e
[<ffffffff810a2a33>] ? read_seqcount_begin.constprop.4+0x8/0xf
[<ffffffff810a2a33>] ? read_seqcount_begin.constprop.4+0x8/0xf
[<ffffffff810a2a33>] ? read_seqcount_begin.constprop.4+0x8/0xf
<<EOE>>  [<ffffffff810a2d6c>] ? ktime_get+0x23/0x5e
[<ffffffffa0314670>] ? lib_ring_buffer_clock_read.isra.28+0x1f/0x21 [lttng_ring_buffer_client_discard]
[<ffffffffa0314786>] ? lttng_event_reserve+0x112/0x3f3 [lttng_ring_buffer_client_discard]
[<ffffffffa045b1c5>] ? __event_probe__workqueue_queue_work+0x72/0xe0 [lttng_probe_workqueue]
[<ffffffff812ef7e9>] ? sock_aio_read.part.10+0x110/0x124
[<ffffffff81133a36>] ? do_sync_readv_writev+0x50/0x76
[<ffffffff8107d514>] ? __queue_work+0x1ab/0x265
[<ffffffff8107da7e>] ? queue_delayed_work_on+0x3f/0x4e
[<ffffffff810a473d>] ? __do_adjtimex+0x408/0x413
[<ffffffff810a3e9a>] ? do_adjtimex+0x98/0xee
[<ffffffff8106cec6>] ? SYSC_adjtimex+0x32/0x5d
[<ffffffff813bb74b>] ? tracesys+0xdd/0xe2

LTTng uses ktime to have the same time-base across kernel and
user-space, so traces gathered from LTTng-modules and LTTng-UST can be
correlated. We plan on using ktime until a fast, scalable, and
fine-grained time-source for tracing that can be used across kernel and
user-space, and which does not rely on read seqlock for kernel-level
synchronization, makes its way into the kernel.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
diff --git a/wrapper/trace-clock.h b/wrapper/trace-clock.h
index bced61c..2f9df7a 100644
--- a/wrapper/trace-clock.h
+++ b/wrapper/trace-clock.h
@@ -32,6 +32,7 @@
 #include <linux/ktime.h>
 #include <linux/time.h>
 #include <linux/hrtimer.h>
+#include <linux/version.h>
 #include "random.h"
 
 static inline u64 trace_clock_monotonic_wrapper(void)
@@ -45,6 +46,10 @@ static inline u64 trace_clock_monotonic_wrapper(void)
 	if (in_nmi())
 		return (u64) -EIO;
 
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,10,0))
+	if (timekeeping_is_busy())
+		return (u64) -EIO;
+#endif
 	ktime = ktime_get();
 	return ktime_to_ns(ktime);
 }

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
