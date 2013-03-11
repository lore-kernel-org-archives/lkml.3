Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3CKO2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:28:51 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:33529 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab3CKO2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:28:50 -0400
Date: Mon, 11 Mar 2013 15:28:45 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20130311142845.GA24546@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: cb16b91a449afd01b85ec4e59f30449d11c4acd7 s390: Fix a header dependencies related build error

Misc minor fixes mostly related to tracing.

 Thanks,

	Ingo

------------------>
Hiraku Toyooka (1):
      tracing: update documentation of snapshot utility

Li Zefan (1):
      s390: Fix a header dependencies related build error

Steven Rostedt (1):
      ftrace: Update the kconfig for DYNAMIC_FTRACE

Steven Rostedt (Red Hat) (2):
      tracing: Add help of snapshot feature when snapshot is empty
      tracing: Do not return EINVAL in snapshot when not allocated


 Documentation/trace/ftrace.txt |  2 +-
 arch/s390/include/asm/cpu_mf.h |  1 +
 kernel/trace/Kconfig           | 24 ++++++++++++++----------
 kernel/trace/trace.c           | 27 ++++++++++++++++++++++++---
 4 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 53d6a3c..a372304 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1873,7 +1873,7 @@ feature:
 
 	status\input  |     0      |     1      |    else    |
 	--------------+------------+------------+------------+
-	not allocated |(do nothing)| alloc+swap |   EINVAL   |
+	not allocated |(do nothing)| alloc+swap |(do nothing)|
 	--------------+------------+------------+------------+
 	allocated     |    free    |    swap    |   clear    |
 	--------------+------------+------------+------------+
diff --git a/arch/s390/include/asm/cpu_mf.h b/arch/s390/include/asm/cpu_mf.h
index 35f0020..c7c9bf6 100644
--- a/arch/s390/include/asm/cpu_mf.h
+++ b/arch/s390/include/asm/cpu_mf.h
@@ -12,6 +12,7 @@
 #ifndef _ASM_S390_CPU_MF_H
 #define _ASM_S390_CPU_MF_H
 
+#include <linux/errno.h>
 #include <asm/facility.h>
 
 #define CPU_MF_INT_SF_IAE	(1 << 31)	/* invalid entry address */
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 3656756..b516a8e 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -429,24 +429,28 @@ config PROBE_EVENTS
 	def_bool n
 
 config DYNAMIC_FTRACE
-	bool "enable/disable ftrace tracepoints dynamically"
+	bool "enable/disable function tracing dynamically"
 	depends on FUNCTION_TRACER
 	depends on HAVE_DYNAMIC_FTRACE
 	default y
 	help
-          This option will modify all the calls to ftrace dynamically
-	  (will patch them out of the binary image and replace them
-	  with a No-Op instruction) as they are called. A table is
-	  created to dynamically enable them again.
+	  This option will modify all the calls to function tracing
+	  dynamically (will patch them out of the binary image and
+	  replace them with a No-Op instruction) on boot up. During
+	  compile time, a table is made of all the locations that ftrace
+	  can function trace, and this table is linked into the kernel
+	  image. When this is enabled, functions can be individually
+	  enabled, and the functions not enabled will not affect
+	  performance of the system.
+
+	  See the files in /sys/kernel/debug/tracing:
+	    available_filter_functions
+	    set_ftrace_filter
+	    set_ftrace_notrace
 
 	  This way a CONFIG_FUNCTION_TRACER kernel is slightly larger, but
 	  otherwise has native performance as long as no tracing is active.
 
-	  The changes to the code are done by a kernel thread that
-	  wakes up once a second and checks to see if any ftrace calls
-	  were made. If so, it runs stop_machine (stops all CPUS)
-	  and modifies the code to jump over the call to ftrace.
-
 config DYNAMIC_FTRACE_WITH_REGS
 	def_bool y
 	depends on DYNAMIC_FTRACE
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c2e2c23..1f835a8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2400,6 +2400,27 @@ static void test_ftrace_alive(struct seq_file *m)
 	seq_printf(m, "#          MAY BE MISSING FUNCTION EVENTS\n");
 }
 
+#ifdef CONFIG_TRACER_MAX_TRACE
+static void print_snapshot_help(struct seq_file *m, struct trace_iterator *iter)
+{
+	if (iter->trace->allocated_snapshot)
+		seq_printf(m, "#\n# * Snapshot is allocated *\n#\n");
+	else
+		seq_printf(m, "#\n# * Snapshot is freed *\n#\n");
+
+	seq_printf(m, "# Snapshot commands:\n");
+	seq_printf(m, "# echo 0 > snapshot : Clears and frees snapshot buffer\n");
+	seq_printf(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
+	seq_printf(m, "#                      Takes a snapshot of the main buffer.\n");
+	seq_printf(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not allocate)\n");
+	seq_printf(m, "#                      (Doesn't have to be '2' works with any number that\n");
+	seq_printf(m, "#                       is not a '0' or '1')\n");
+}
+#else
+/* Should never be called */
+static inline void print_snapshot_help(struct seq_file *m, struct trace_iterator *iter) { }
+#endif
+
 static int s_show(struct seq_file *m, void *v)
 {
 	struct trace_iterator *iter = v;
@@ -2411,7 +2432,9 @@ static int s_show(struct seq_file *m, void *v)
 			seq_puts(m, "#\n");
 			test_ftrace_alive(m);
 		}
-		if (iter->trace && iter->trace->print_header)
+		if (iter->snapshot && trace_empty(iter))
+			print_snapshot_help(m, iter);
+		else if (iter->trace && iter->trace->print_header)
 			iter->trace->print_header(m);
 		else
 			trace_default_header(m);
@@ -4144,8 +4167,6 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	default:
 		if (current_trace->allocated_snapshot)
 			tracing_reset_online_cpus(&max_tr);
-		else
-			ret = -EINVAL;
 		break;
 	}
 
