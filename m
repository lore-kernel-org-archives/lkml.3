Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423531Ab3FURbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 13:31:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3739 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423122Ab3FURbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 13:31:42 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=9Wj5N41tlBAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=aOmUV1eUANkA:10 a=VwQbUJbxAAAA:8 a=x30EXVXcAAAA:8 a=ec7kSLFchr7r2S7lBoIA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=2F0HLYTCHDIA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371835898.18733.122.camel@gandalf.local.home>
Subject: [PATCH][GIT PULL] trace,x86: Move creation of irq tracepoints from
 apic.c to irq.c
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Fri, 21 Jun 2013 13:31:38 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Peter,

I noticed that you pulled in Seiji's patches into tip. Last night I was
running my test suite on them, and this morning they showed the
following compile bug. I found the fix and attached it below. I pushed
it into my tree that's based on your x86/trace branch, for your
convenience.

My testing also triggered another bug, but I'm not sure it's related to
these patches or something that already existed. I'm currently
investigating it now.

-- Steve


Please pull the latest tip/x86/trace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/x86/trace

Head SHA1: 83ab85140bc1492f92de263a1c30ea04a0f465f7


Steven Rostedt (Red Hat) (1):
      trace,x86: Move creation of irq tracepoints from apic.c to irq.c

----
 arch/x86/kernel/Makefile      |    2 ++
 arch/x86/kernel/apic/Makefile |    1 -
 arch/x86/kernel/apic/apic.c   |    4 +---
 arch/x86/kernel/irq.c         |    2 ++
 4 files changed, 5 insertions(+), 4 deletions(-)
---------------------------
commit 83ab85140bc1492f92de263a1c30ea04a0f465f7
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Fri Jun 21 10:29:05 2013 -0400

    trace,x86: Move creation of irq tracepoints from apic.c to irq.c
    
    Compiling without CONFIG_X86_LOCAL_APIC set, apic.c will not be
    compiled, and the irq tracepoints will not be created via the
    CREATE_TRACE_POINTS macro. When CONFIG_X86_LOCAL_APIC is not set,
    we get the following build error:
    
      LD      init/built-in.o
    arch/x86/built-in.o: In function `trace_x86_platform_ipi_entry':
    linux-test.git/arch/x86/include/asm/trace/irq_vectors.h:66: undefined reference to `__tracepoint_x86_platform_ipi_entry'
    arch/x86/built-in.o: In function `trace_x86_platform_ipi_exit':
    linux-test.git/arch/x86/include/asm/trace/irq_vectors.h:66: undefined reference to `__tracepoint_x86_platform_ipi_exit'
    arch/x86/built-in.o: In function `trace_irq_work_entry':
    linux-test.git/arch/x86/include/asm/trace/irq_vectors.h:72: undefined reference to `__tracepoint_irq_work_entry'
    arch/x86/built-in.o: In function `trace_irq_work_exit':
    linux-test.git/arch/x86/include/asm/trace/irq_vectors.h:72: undefined reference to `__tracepoint_irq_work_exit'
    arch/x86/built-in.o:(__jump_table+0x8): undefined reference to `__tracepoint_x86_platform_ipi_entry'
    arch/x86/built-in.o:(__jump_table+0x14): undefined reference to `__tracepoint_x86_platform_ipi_exit'
    arch/x86/built-in.o:(__jump_table+0x20): undefined reference to `__tracepoint_irq_work_entry'
    arch/x86/built-in.o:(__jump_table+0x2c): undefined reference to `__tracepoint_irq_work_exit'
    make[1]: *** [vmlinux] Error 1
    make: *** [sub-make] Error 2
    
    As irq.c is always compiled for x86, it is a more appropriate location
    to create the irq tracepoints.
    
    Cc: Seiji Aguchi <seiji.aguchi@hds.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 74b3891a..44e763f 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -16,6 +16,8 @@ CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
 
+CFLAGS_irq.o := -I$(src)/../include/asm/trace
+
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o ldt.o dumpstack.o nmi.o
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index 5274c3a..0ae0323 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -2,7 +2,6 @@
 # Makefile for local APIC drivers and for the IO-APIC code
 #
 
-CFLAGS_apic.o := -I$(src)/../../include/asm/trace
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o ipi.o
 obj-y				+= hw_nmi.o
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 61ced40..961676c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -35,6 +35,7 @@
 #include <linux/smp.h>
 #include <linux/mm.h>
 
+#include <asm/trace/irq_vectors.h>
 #include <asm/irq_remapping.h>
 #include <asm/perf_event.h>
 #include <asm/x86_init.h>
@@ -55,9 +56,6 @@
 #include <asm/tsc.h>
 #include <asm/hypervisor.h>
 
-#define CREATE_TRACE_POINTS
-#include <asm/trace/irq_vectors.h>
-
 unsigned int num_processors;
 
 unsigned disabled_cpus __cpuinitdata;
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 06af119..3a8185c 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -17,6 +17,8 @@
 #include <asm/idle.h>
 #include <asm/mce.h>
 #include <asm/hw_irq.h>
+
+#define CREATE_TRACE_POINTS
 #include <asm/trace/irq_vectors.h>
 
 atomic_t irq_err_count;


