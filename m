Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935314Ab3E2W2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:28:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:13728 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935315Ab3E2W2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:28:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,766,1363158000"; 
   d="scan'208";a="345327215"
Subject: [v3][PATCH 4/4] x86: nmi length tracepoints
To: a.p.zijlstra@chello.nl
Cc: mingo@redhat.com, paulus@samba.org, acme@ghostprotocols.net,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 29 May 2013 15:28:03 -0700
References: <20130529222756.25535229@viggo.jf.intel.com>
In-Reply-To: <20130529222756.25535229@viggo.jf.intel.com>
Message-Id: <20130529222803.9A11A23E@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This patch has been invaluable in my adventures finding
issues in the perf NMI handler.  I'm as big a fan of
printk() as anybody is, but using printk() in NMIs is
deadly when they're happening frequently.

Even hacking in trace_printk() ended up eating enough
CPU to throw off some of the measurements I was making.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/Documentation/trace/events-nmi.txt |   43 ++++++++++++++++++
 linux.git-davehans/arch/x86/kernel/nmi.c              |    9 ++-
 linux.git-davehans/include/trace/events/nmi.h         |   37 +++++++++++++++
 3 files changed, 87 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/nmi.c~nmi-tracepoints arch/x86/kernel/nmi.c
--- linux.git/arch/x86/kernel/nmi.c~nmi-tracepoints	2013-05-29 15:10:19.717684752 -0700
+++ linux.git-davehans/arch/x86/kernel/nmi.c	2013-05-29 15:10:19.720684883 -0700
@@ -30,6 +30,9 @@
 #include <asm/nmi.h>
 #include <asm/x86_init.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/nmi.h>
+
 struct nmi_desc {
 	spinlock_t lock;
 	struct list_head head;
@@ -108,11 +111,13 @@ static int __kprobes nmi_handle(unsigned
 	 */
 	list_for_each_entry_rcu(a, &desc->head, list) {
 		u64 before, delta, whole_msecs;
-		int decimal_msecs;
+		int decimal_msecs, thishandled;
 
 		before = local_clock();
-		handled += a->handler(type, regs);
+		thishandled = a->handler(type, regs);
+		handled += thishandled;
 		delta = local_clock() - before;
+		trace_nmi_handler(a->handler, (int)delta, thishandled);
 
 		if (delta < nmi_longest_ns)
 			continue;
diff -puN /dev/null Documentation/trace/events-nmi.txt
--- /dev/null	2013-03-17 11:51:50.342329668 -0700
+++ linux.git-davehans/Documentation/trace/events-nmi.txt	2013-05-29 15:10:19.720684883 -0700
@@ -0,0 +1,43 @@
+NMI Trace Events
+
+These events normally show up here:
+
+	/sys/kernel/debug/tracing/events/nmi
+
+--
+
+nmi_handler:
+
+You might want to use this tracepoint if you suspect that your
+NMI handlers are hogging large amounts of CPU time.  The kernel
+will warn if it sees long-running handlers:
+
+	INFO: NMI handler took too long to run: 9.207 msecs
+
+and this tracepoint will allow you to drill down and get some
+more details.
+
+Let's say you suspect that perf_event_nmi_handler() is causing
+you some problems and you only want to trace that handler
+specifically.  You need to find its address:
+
+	$ grep perf_event_nmi_handler /proc/kallsyms
+	ffffffff81625600 t perf_event_nmi_handler
+
+Let's also say you are only interested in when that function is
+really hogging a lot of CPU time, like a millisecond at a time.
+Note that the kernel's output is in milliseconds, but the input
+to the filter is in nanoseconds!  You can filter on 'delta_ns':
+
+cd /sys/kernel/debug/tracing/events/nmi/nmi_handler
+echo 'handler==0xffffffff81625600 && delta_ns>1000000' > filter
+echo 1 > enable
+
+Your output would then look like:
+
+$ cat /sys/kernel/debug/tracing/trace_pipe
+<idle>-0     [000] d.h3   505.397558: nmi_handler: perf_event_nmi_handler() delta_ns: 3236765 handled: 1
+<idle>-0     [000] d.h3   505.805893: nmi_handler: perf_event_nmi_handler() delta_ns: 3174234 handled: 1
+<idle>-0     [000] d.h3   506.158206: nmi_handler: perf_event_nmi_handler() delta_ns: 3084642 handled: 1
+<idle>-0     [000] d.h3   506.334346: nmi_handler: perf_event_nmi_handler() delta_ns: 3080351 handled: 1
+
diff -puN /dev/null include/trace/events/nmi.h
--- /dev/null	2013-03-17 11:51:50.342329668 -0700
+++ linux.git-davehans/include/trace/events/nmi.h	2013-05-29 15:10:19.720684883 -0700
@@ -0,0 +1,37 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM nmi
+
+#if !defined(_TRACE_NMI_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_NMI_H
+
+#include <linux/ktime.h>
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(nmi_handler,
+
+	TP_PROTO(void *handler, s64 delta_ns, int handled),
+
+	TP_ARGS(handler, delta_ns, handled),
+
+	TP_STRUCT__entry(
+		__field(	void *,		handler	)
+		__field(	s64,		delta_ns)
+		__field(	int,		handled	)
+	),
+
+	TP_fast_assign(
+		__entry->handler = handler;
+		__entry->delta_ns = delta_ns;
+		__entry->handled = handled;
+	),
+
+	TP_printk("%ps() delta_ns: %lld handled: %d",
+		__entry->handler,
+		__entry->delta_ns,
+		__entry->handled)
+);
+
+#endif /* _TRACE_NMI_H */
+
+/* This part ust be outside protection */
+#include <trace/define_trace.h>
_
