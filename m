Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965228AbaLMFt7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 00:49:59 -0500
Received: from smtprelay0029.hostedemail.com ([216.40.44.29]:56057 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965106AbaLMFt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 00:49:58 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1544:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2859:2902:2904:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3355:3865:3866:3867:3868:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:6120:6261:6742:8599:8660:9025:10004:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12679:12783:13148:13230:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ring66_73ce010320207
X-Filterd-Recvd-Size: 5504
Date: Sat, 13 Dec 2014 00:49:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Yinghai Lu <yinghai@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [RFC PATCH 1/2] tracing: Move enabling tracepoints to just after
 mm_init()
Message-ID: <20141213004954.1c8aa67d@gandalf.local.home>
In-Reply-To: <20141213004830.792da019@gandalf.local.home>
References: <alpine.DEB.2.11.1412121539300.16494@nanos>
	<20141212181420.47100d5c@gandalf.local.home>
	<20141213004830.792da019@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Enabling tracepoints at boot up can be very useful. The tracepoint
can be initialized right after memory has been. There's no need to
wait for the early_initcall() to be called. That's too late for some
things that can use tracepoints for debugging. Move the logic to
enable tracepoints out of the initcalls and into init/main.c to
right after mm_init().

This also allows trace_printk() to be used early too.

Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1412121539300.16494@nanos

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h        |  6 ++++++
 init/main.c                   |  3 +++
 kernel/trace/trace.c          |  8 +++++++-
 kernel/trace/trace.h          | 13 +++++++++++++
 kernel/trace/trace_events.c   | 10 ++++++++--
 kernel/trace/trace_syscalls.c |  3 +--
 6 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ed501953f0b2..0fc3e720d4fd 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -39,6 +39,12 @@
 # define FTRACE_FORCE_LIST_FUNC 0
 #endif
 
+/* Main tracing buffer and events set up */
+#ifdef CONFIG_TRACING
+void trace_init(void);
+#else
+static inline trace_init(void) { }
+#endif
 
 struct module;
 struct ftrace_hash;
diff --git a/init/main.c b/init/main.c
index 800a0daede7e..060e60b6aa59 100644
--- a/init/main.c
+++ b/init/main.c
@@ -561,6 +561,9 @@ asmlinkage __visible void __init start_kernel(void)
 	trap_init();
 	mm_init();
 
+	/* trace_printk() and trace points may be used after this */
+	trace_init();
+
 	/*
 	 * Set up the scheduler prior starting any interrupts (such as the
 	 * timer interrupt). Full topology setup happens at smp_init()
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4ceb2546c7ef..ec3ca694665f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6876,6 +6876,13 @@ out:
 	return ret;
 }
 
+void __init trace_init(void)
+{
+	tracer_alloc_buffers();
+	init_ftrace_syscalls();
+	trace_event_init();	
+}
+
 __init static int clear_boot_tracer(void)
 {
 	/*
@@ -6895,6 +6902,5 @@ __init static int clear_boot_tracer(void)
 	return 0;
 }
 
-early_initcall(tracer_alloc_buffers);
 fs_initcall(tracer_init_debugfs);
 late_initcall(clear_boot_tracer);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3255dfb054a0..c138c149d6ef 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1301,4 +1301,17 @@ int perf_ftrace_event_register(struct ftrace_event_call *call,
 #define perf_ftrace_event_register NULL
 #endif
 
+#ifdef CONFIG_FTRACE_SYSCALLS
+void init_ftrace_syscalls(void);
+#else
+static inline void init_ftrace_syscalls(void) { }
+#endif
+
+#ifdef CONFIG_EVENT_TRACING
+void trace_event_init(void);
+#else
+static inline void __init trace_event_init(void) { }
+#endif
+
+
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f9d0cbe014b7..fd9deb0e03f0 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2477,8 +2477,14 @@ static __init int event_trace_init(void)
 #endif
 	return 0;
 }
-early_initcall(event_trace_memsetup);
-core_initcall(event_trace_enable);
+
+void __init trace_event_init(void)
+{
+	event_trace_memsetup();
+	init_ftrace_syscalls();
+	event_trace_enable();
+}
+
 fs_initcall(event_trace_init);
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index a72f3d8d813e..542219ea33ed 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -514,7 +514,7 @@ unsigned long __init __weak arch_syscall_addr(int nr)
 	return (unsigned long)sys_call_table[nr];
 }
 
-static int __init init_ftrace_syscalls(void)
+void __init init_ftrace_syscalls(void)
 {
 	struct syscall_metadata *meta;
 	unsigned long addr;
@@ -539,7 +539,6 @@ static int __init init_ftrace_syscalls(void)
 
 	return 0;
 }
-early_initcall(init_ftrace_syscalls);
 
 #ifdef CONFIG_PERF_EVENTS
 
-- 
1.8.1.4

