Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969Ab3HNQEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:04:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58582 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765Ab3HNQE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:04:29 -0400
Date: Wed, 14 Aug 2013 18:04:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [RFC][PATCH 0/5] preempt_count rework
Message-ID: <20130814160416.GI24092@twins.programming.kicks-ass.net>
References: <20130814131539.790947874@chello.nl>
 <520B8A81.1080405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520B8A81.1080405@zytor.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 06:47:45AM -0700, H. Peter Anvin wrote:

> I still don't see this using a decrement of the percpu variable
> anywhere.  The C compiler doesn't know how to generate those, so if I'm
> not completely wet we will end up relying on sub_preempt_count()...
> which, because it relies on taking the address of the percpu variable
> will generate absolutely horrific code.
> 
> On x86, you never want to take the address of a percpu variable if you
> can avoid it, as you end up generating code like:
> 
> 	movq %fs:0,%rax
> 	subl $1,(%rax)
> 

Urgh,. yes you're right. I keep forgetting GCC doesn't know how to merge
those :/

OK, so something like the below would cure the worst of that I suppose.
It compiles but doesn't boot; must've done something wrong.

Someone please look at it because my asm-foo blows. I pretty much
copy/pasted this from asm/percpu.h.

---
--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -20,6 +20,28 @@ static __always_inline int *preempt_coun
 	return &__raw_get_cpu_var(__preempt_count);
 }
 
+#define __preempt_count_add(x) do {		\
+	asm("addl %1," __percpu_arg(0)		\
+		: "+m" (__preempt_count) 	\
+		: "ri" ((int)x) 		\
+		: "memory"); 			\
+} while (0)
+
+#define __preempt_count_sub(x) do {		\
+	asm("subl %1," __percpu_arg(0)		\
+		: "+m" (__preempt_count) 	\
+		: "ri" ((int)x) 		\
+		: "memory"); 			\
+} while (0)
+
+#define preempt_enable() do {			\
+	asm("\nsubl $1," __percpu_arg(0)	\
+	    "\njnz 1f"				\
+	    "\ncall preempt_schedule"		\
+	    "\n1:" : "+m" (__preempt_count)	\
+		   : : "memory");		\
+} while (0)
+
 /*
  * must be macros to avoid header recursion hell
  */
--- a/include/asm-generic/preempt.h
+++ b/include/asm-generic/preempt.h
@@ -17,6 +17,9 @@ static __always_inline int *preempt_coun
 	return &current_thread_info()->preempt_count;
 }
 
+#define __preempt_count_add(x)	do { current_thread_info()->preempt_count += (x); } while (0)
+#define __preempt_count_sub(x)  __preempt_count_add(-(x))
+
 /*
  * must be macros to avoid header recursion hell
  */
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -45,8 +45,8 @@ static __always_inline bool test_preempt
   extern void add_preempt_count(int val);
   extern void sub_preempt_count(int val);
 #else
-# define add_preempt_count(val)	do { *preempt_count_ptr() += (val); } while (0)
-# define sub_preempt_count(val)	do { *preempt_count_ptr() -= (val); } while (0)
+# define add_preempt_count(val)	__preempt_count_add(val)
+# define sub_preempt_count(val)	__preempt_count_sub(val)
 #endif
 
 #define inc_preempt_count() add_preempt_count(1)
@@ -101,17 +101,17 @@ do { \
 
 #define preempt_enable_no_resched()	sched_preempt_enable_no_resched()
 
+#ifndef preempt_enable
 #define preempt_enable() \
 do { \
 	preempt_enable_no_resched(); \
 	preempt_check_resched(); \
 } while (0)
+#endif
 
 /* For debugging and tracer internals only! */
-#define add_preempt_count_notrace(val)			\
-	do { *preempt_count_ptr() += (val); } while (0)
-#define sub_preempt_count_notrace(val)			\
-	do { *preempt_count_ptr() -= (val); } while (0)
+#define add_preempt_count_notrace(val)	__preempt_count_add(val)
+#define sub_preempt_count_notrace(val)	__preempt_count_sub(val)
 #define inc_preempt_count_notrace() add_preempt_count_notrace(1)
 #define dec_preempt_count_notrace() sub_preempt_count_notrace(1)
 
