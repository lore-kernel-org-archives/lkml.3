Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030798Ab3DSOro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:47:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030593Ab3DSOrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:47:43 -0400
Date: Fri, 19 Apr 2013 10:46:55 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sourceware.org>
Subject: Re: systemtap broken by removal of register_timer_hook
Message-ID: <20130419144655.GD8308@redhat.com>
References: <20130403075017.GA2534@suse.de> <CAFTL4hyYezB2ZxM-GJ70VoxOeRSG64V6u+nX2hTuhF30R-GdPg__32168.962484184$1364986928$gmane$org@mail.gmail.com> <y0mvc83u79f.fsf@fche.csb> <CAFTL4hxx_GHoa4uguSAtY0A=cC43qJPKvpqaoguS-WAjFj+HSw@mail.gmail.com> <20130403144428.GA15432@redhat.com> <CAFTL4hy+U-dLPwGR8BcZt=C8Tug-jvh+24epadfte7Ci2cDU5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hy+U-dLPwGR8BcZt=C8Tug-jvh+24epadfte7Ci2cDU5Q@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Frederic -


> > How about this?
> >
> > Author: Frank Ch. Eigler <fche@redhat.com>
> > Date:   Wed Apr 3 10:35:21 2013 -0400
> >
> >     profiling: add profile_tick tracepoint
> > [...]

> It would be better not to tie this to CONFIG_PROFILING.
> A tracepoint in update_process_times() instead would be great but it's
> sometimes called several times in a tick from some archs.
> Probably we need something like:
> 
> static inline tick_trace(struct pt_regs *regs)
> {
>     trace_timer_tick(regs);
>     profile_tick(CPU_PROFILING);
> }

I looked into this, but found no natural place to define such an
inline function from which to call into a tracepoint, without having
to #include the <event/FOO.h> file many times.  Nor does it seem
appropriate to do the identical #define CREATE_TRACE_POINTS part from
all the different arch/.../*.c files that may call into that inline.
If you'd like to stick to this idea, please advise further where you
think the tracepoint definition & declarations should go.

In the alternative, here is v2 of the patch, just changing the
tracepoint-printing argument as suggested by jistone.

- FChE

---------------

Author: Frank Ch. Eigler <fche@redhat.com>
Date:   Wed Apr 3 10:35:21 2013 -0400

    profiling: add profile_tick tracepoint
    
    Commit ba6fdda4 removed the timer_hook mechanism for modules to listen
    to profiling timer ticks (without having to set up more complicated
    perf mechanisms).  To reduce the impact on out-of-tree users such as
    systemtap, a TRACE_EVENT-flavoured tracepoint is added in its place.
    Tested with perf and systemtap.
    
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Ingo Molnar <mingo@kernel.org>
    Cc: Mel Gorman <mgorman@suse.de>
    Signed-off-by: Frank Ch. Eigler <fche@redhat.com>

diff --git a/include/trace/events/profile.h b/include/trace/events/profile.h
new file mode 100644
index 0000000..445aee7
--- /dev/null
+++ b/include/trace/events/profile.h
@@ -0,0 +1,37 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM profile
+
+#if !defined(_TRACE_PROFILE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_PROFILE_H
+
+#include <linux/tracepoint.h>
+
+
+struct pt_regs;
+
+/**
+ * profile_tick - called when the profiling timer ticks
+ * @type:	profiling tick type, generally @CPU_PROFILING
+ * @regs:	pointer to struct pt_regs*
+ */
+
+TRACE_EVENT(profile_tick,
+	TP_PROTO(int type, struct pt_regs *regs),
+	TP_ARGS(type, regs),
+	TP_STRUCT__entry(
+		__field( int,			type	)
+		__field( struct pt_regs*,	regs	)
+	),
+	TP_fast_assign(
+		__entry->type	= type;
+		__entry->regs	= regs;
+	),
+	TP_printk("type=%d ip=%p", __entry->type,
+		  instruction_pointer(__entry->regs))
+);
+
+
+#endif /*  _TRACE_PROFILE_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/profile.c b/kernel/profile.c
index dc3384e..d61f921 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -29,6 +29,9 @@
 #include <asm/irq_regs.h>
 #include <asm/ptrace.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/profile.h>
+
 struct profile_hit {
 	u32 pc, hits;
 };
@@ -414,6 +417,8 @@ void profile_tick(int type)
 {
 	struct pt_regs *regs = get_irq_regs();
 
+	trace_profile_tick(type, regs);
+
 	if (!user_mode(regs) && prof_cpu_mask != NULL &&
 	    cpumask_test_cpu(smp_processor_id(), prof_cpu_mask))
 		profile_hit(type, (void *)profile_pc(regs));
