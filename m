Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844AbaE2Fhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:37:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220AbaE2Eez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Stefan Bader <stefan.bader@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
        stable-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?q?Toralf=20F=BFrster?= <toralf.foerster@gmx.de>,
        Michele Ballabio <barra_cuda@katamail.com>,
        Peter Zijlstra <peterz@infradead.org>, fweisbec@gmail.com,
        mingo@kernel.org, greg@kroah.com
Subject: [PATCH 3.14 013/140] x86,preempt: Fix preemption for i386
Date: Wed, 28 May 2014 21:32:32 -0700
Message-Id: <20140529043051.100327598@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Peter Zijlstra <peterz@infradead.org>

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

Cc: bp@alien8.de
Cc: fweisbec@gmail.com
Cc: david.a.cohen@linux.intel.com
Cc: mingo@kernel.org
Cc: fweisbec@gmail.com
Cc: greg@kroah.com
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: gregkh@linuxfoundation.org
Cc: pbonzini@redhat.com
Cc: rostedt@goodmis.org
Cc: stefan.bader@canonical.com
Cc: mingo@kernel.org
Cc: toralf.foerster@gmx.de
Cc: David Cohen <david.a.cohen@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: torvalds@linux-foundation.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: <stable-commits@vger.kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: peterz@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: barra_cuda@katamail.com
Tested-by: Stefan Bader <stefan.bader@canonical.com>
Tested-by: Toralf F¿rster <toralf.foerster@gmx.de>
Tested-by: Michele Ballabio <barra_cuda@katamail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140409142447.GD13658@twins.programming.kicks-ass.net

---
 arch/x86/include/asm/preempt.h |   12 ++++++++++++
 include/linux/preempt.h        |    2 ++
 include/linux/thread_info.h    |    2 --
 3 files changed, 14 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -5,6 +5,18 @@
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
+#undef tif_need_resched
+#define tif_need_resched() test_tsk_thread_flag(current, TIF_NEED_RESCHED)
+#endif
+
 DECLARE_PER_CPU(int, __preempt_count);
 
 /*
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -15,6 +15,8 @@
  */
 #define PREEMPT_NEED_RESCHED	0x80000000
 
+#define tif_need_resched() test_thread_flag(TIF_NEED_RESCHED)
+
 #include <asm/preempt.h>
 
 #if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
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


