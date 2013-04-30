Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514Ab3D3R1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 13:27:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445Ab3D3R1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 13:27:34 -0400
Date: Tue, 30 Apr 2013 13:27:20 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sourceware.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: systemtap broken by removal of register_timer_hook
Message-ID: <20130430172720.GA21499@redhat.com>
References: <20130403075017.GA2534@suse.de> <CAFTL4hyYezB2ZxM-GJ70VoxOeRSG64V6u+nX2hTuhF30R-GdPg__32168.962484184$1364986928$gmane$org@mail.gmail.com> <y0mvc83u79f.fsf@fche.csb> <CAFTL4hxx_GHoa4uguSAtY0A=cC43qJPKvpqaoguS-WAjFj+HSw@mail.gmail.com> <20130403144428.GA15432@redhat.com> <CAFTL4hy+U-dLPwGR8BcZt=C8Tug-jvh+24epadfte7Ci2cDU5Q@mail.gmail.com> <20130419144655.GD8308@redhat.com> <20130430001858.GF1760@somewhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430001858.GF1760@somewhere>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

> [...]  How about creating trace_tick() in
> include/trace/events/timer.h and call it from tick_periodic() and
> tick_sched_handle(). [...]

Like this?


>From facee64445c0dcc717e99c474c5c7dcdd31b9a74 Mon Sep 17 00:00:00 2001
From: "Frank Ch. Eigler" <fche@redhat.com>
Date: Wed, 3 Apr 2013 10:35:21 -0400
Subject: [PATCH] profiling: add tick tracepoint

Commit ba6fdda4 removed the timer_hook mechanism for modules to listen
to profiling timer ticks (without having to set up more complicated
perf mechanisms).  To reduce the impact on out-of-tree users such as
systemtap, a TRACE_EVENT-flavoured tracepoint is added in its place,
invoked right beside profile_tick() in kernel/time/tick-*.c.
Tested with perf and systemtap.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Frank Ch. Eigler <fche@redhat.com>
---
 include/trace/events/timer.h | 20 ++++++++++++++++++++
 kernel/time/tick-common.c    |  2 ++
 kernel/time/tick-sched.c     |  2 ++
 3 files changed, 24 insertions(+)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 425bcfe..ec4c2d0 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -323,6 +323,26 @@ TRACE_EVENT(itimer_expire,
 		  (int) __entry->pid, (unsigned long long)__entry->now)
 );
 
+
+struct pt_regs;
+
+/**
+ * tick - called when the profiling timer ticks
+ * @regs:	pointer to struct pt_regs*
+ */
+TRACE_EVENT(tick,
+	TP_PROTO(struct pt_regs *regs),
+	TP_ARGS(regs),
+	TP_STRUCT__entry(
+		__field( struct pt_regs*,	regs	)
+	),
+	TP_fast_assign(
+		__entry->regs	= regs;
+	),
+	TP_printk("ip=%p", (void *) instruction_pointer(__entry->regs))
+);
+
+
 #endif /*  _TRACE_TIMER_H */
 
 /* This part must be outside protection */
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index b1600a6..5f4227f 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -18,6 +18,7 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
+#include <trace/events/timer.h>
 
 #include <asm/irq_regs.h>
 
@@ -74,6 +75,7 @@ static void tick_periodic(int cpu)
 
 	update_process_times(user_mode(get_irq_regs()));
 	profile_tick(CPU_PROFILING);
+	trace_tick(get_irq_regs());
 }
 
 /*
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a19a399..447be56 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/irq_work.h>
+#include <trace/events/timer.h>
 
 #include <asm/irq_regs.h>
 
@@ -140,6 +141,7 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
 #endif
 	update_process_times(user_mode(regs));
 	profile_tick(CPU_PROFILING);
+	trace_tick(get_irq_regs());
 }
 
 /*
-- 
1.8.2

