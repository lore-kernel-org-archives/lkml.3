Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568AbaDIOZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:25:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44112 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761AbaDIOZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:25:11 -0400
Date: Wed, 9 Apr 2014 16:24:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        Michele Ballabio <barra_cuda@katamail.com>,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <greg@kroah.com>
Subject: [PATCH -stable] x86,preempt: Fix preemption for i386
Message-ID: <20140409142447.GD13658@twins.programming.kicks-ass.net>
References: <5341707F.5000406@katamail.com>
 <20140407150337.GO10526@twins.programming.kicks-ass.net>
 <20140407150705.GB13658@twins.programming.kicks-ass.net>
 <5342EB78.3060002@gmx.de>
 <20140407185658.GK11096@twins.programming.kicks-ass.net>
 <20140408122128.GC13658@twins.programming.kicks-ass.net>
 <53450F7E.7040904@canonical.com>
 <20140409094515.GR11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140409094515.GR11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, Linus,

I'm not entirely clear on how acceptable it is to propose a different
patch for -stable than what we have upstream.

The below Changelog explain, but in short, we should either backport 4
rather invasive patches to .13-stable and .14-stable or do the small
patch provided.

The 4 patches by Steven are the right thing to do, but I feel they might
be too invasive to propose for -stable, therefore the alternative
approach.

---
Subject: x86,preempt: Fix preemption for i386
From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 8 Apr 2014 14:21:28 +0200

Many people reported preemption/reschedule problems with i386 kernels
for .13 and .14. After Michele bisected this to a combination of

  3e8e42c69bb ("sched: Revert need_resched() to look at TIF_NEED_RESCHED")
  ded79754754 ("irq: Force hardirq exit's softirq processing on its own stack")

it finally dawned on me that i386's current_thread_info() was to
blame.

When we are on interrupt/exception stacks, we fail to observe the
right TIF_NEED_RESCHED bit and therefore the PREEMPT_NEED_RESCHED
folding malfunctions.

Current upstream fixes this by making i386 behave the same as x86_64
already did:

  2432e1364bbe ("x86: Nuke the supervisor_stack field in i386 thread_info")
  b807902a88c4 ("x86: Nuke GET_THREAD_INFO_WITH_ESP() macro for i386")
  0788aa6a23cb ("x86: Prepare removal of previous_esp from i386 thread_info structure")
  198d208df437 ("x86: Keep thread_info on thread stack in x86_32")

However, that is far too much to stuff into -stable. Therefore I
propose we merge the below patch which uses task_thread_info(current)
for tif_need_resched() instead of the ESP based current_thread_info().

This makes sure we always observe the one true TIF_NEED_RESCHED bit
and things will work as expected again.

Cc: fweisbec@gmail.com
Cc: mingo@kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Cohen <david.a.cohen@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Tested-by: Stefan Bader <stefan.bader@canonical.com>
Tested-by: Toralf Förster <toralf.foerster@gmx.de>
Tested-by: Michele Ballabio <barra_cuda@katamail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/preempt.h |   11 +++++++++++
 include/linux/preempt.h        |    4 ++++
 include/linux/thread_info.h    |    2 --
 3 files changed, 15 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -5,6 +5,17 @@
 #include <asm/percpu.h>
 #include <linux/thread_info.h>
 
+#ifdef CONFIG_X86_32
+/*
+ * i386's current_thread_info() depends on ESP and for interrupt/exception
+ * stacks this doesn't yield the actual task thread_info.
+ *
+ * We hard rely on the fact that all the TIF_NEED_RESCHED bits are
+ * the same, therefore use the slightly more expensive version below.
+ */
+#define tif_need_resched() test_tsk_thread_flag(current, TIF_NEED_RESCHED)
+#endif
+
 DECLARE_PER_CPU(int, __preempt_count);
 
 /*
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -17,6 +17,10 @@
 
 #include <asm/preempt.h>
 
+#ifndef tif_need_resched
+#define tif_need_resched() test_thread_flag(TIF_NEED_RESCHED)
+#endif
+
 #if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
 extern void preempt_count_add(int val);
 extern void preempt_count_sub(int val);
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -118,8 +118,6 @@ static inline __deprecated void set_need
 	 */
 }
 
-#define tif_need_resched() test_thread_flag(TIF_NEED_RESCHED)
-
 #if defined TIF_RESTORE_SIGMASK && !defined HAVE_SET_RESTORE_SIGMASK
 /*
  * An arch can define its own version of set_restore_sigmask() to get the
