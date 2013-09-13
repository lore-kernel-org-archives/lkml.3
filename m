Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab3IMIG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 04:06:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40628 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab3IMIGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 04:06:20 -0400
Date: Fri, 13 Sep 2013 10:06:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kevin Easton <kevin@guarana.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Peter Anvin <hpa@zytor.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] preempt_count rework -v2
Message-ID: <20130913080605.GG31370@twins.programming.kicks-ass.net>
References: <20130910135636.GA8268@gmail.com>
 <CA+55aFwmEQeF+PtM7cuaQ8OkuTS=R4JJ61Wwfv8u-Svo-V3KwQ@mail.gmail.com>
 <20130910164519.GL31370@twins.programming.kicks-ass.net>
 <CA+55aFz7WtcdkwKEGoqCzmC9HsY0LPK-oVK_oATYhRnbGq=2GA@mail.gmail.com>
 <20130912022040.GT31370@twins.programming.kicks-ass.net>
 <20130913072459.GA15492@chicago.guarana.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913072459.GA15492@chicago.guarana.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 05:25:00PM +1000, Kevin Easton wrote:
> If you wanted to collapse the unary and binary variants as you mentioned
> upthread, you could do something like (for the CC_HAVE_ASM_GOTO case):

Indeed, another 11 lines off, awesome!

--- /dev/null
+++ b/arch/x86/include/asm/rmwcc.h
@@ -0,0 +1,41 @@
+#ifndef _ASM_X86_RMWcc
+#define _ASM_X86_RMWcc
+
+#ifdef CC_HAVE_ASM_GOTO
+
+#define __GEN_RMWcc(fullop, var, cc, ...)				\
+do {									\
+	asm volatile goto (fullop "; j" cc " %l[cc_label]"		\
+			: : "m" (var), ## __VA_ARGS__ 			\
+			: "memory" : cc_label);				\
+	return 0;							\
+cc_label:								\
+	return 1;							\
+} while (0)
+
+#define GEN_UNARY_RMWcc(op, var, arg0, cc) 				\
+	__GEN_RMWcc(op " " arg0, var, cc)
+
+#define GEN_BINARY_RMWcc(op, var, val, arg0, cc)			\
+	__GEN_RMWcc(op " %1, " arg0, var, cc, "er" (val))
+
+#else /* !CC_HAVE_ASM_GOTO */
+
+#define __GEN_RMWcc(fullop, var, cc, ...)				\
+do {									\
+	char c;								\
+	asm volatile (fullop "; set" cc " %1"				\
+			: "+m" (var), "=qm" (c)				\
+			: __VA_ARGS__ : "memory");			\
+	return c != 0;							\
+} while (0)
+
+#define GEN_UNARY_RMWcc(op, var, arg0, cc)				\
+	__GEN_RMWcc(op " " arg0, var, cc)
+
+#define GEN_BINARY_RMWcc(op, var, val, arg0, cc)			\
+	__GEN_RMWcc(op " %2, " arg0, var, cc, "er" (val))
+
+#endif /* CC_HAVE_ASM_GOTO */
+
+#endif /* _ASM_X86_RMWcc */

