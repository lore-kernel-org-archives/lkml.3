Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaHDRjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:39:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbaHDRjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:39:09 -0400
Date: Mon, 4 Aug 2014 19:36:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH? v2] x86: reimplement ___preempt_schedule*() using THUNK
	helpers
Message-ID: <20140804173646.GA18520@redhat.com>
References: <1407158386-6201-1-git-send-email-dvlasenk@redhat.com> <1407158386-6201-5-git-send-email-dvlasenk@redhat.com> <20140804170519.GA17466@redhat.com> <20140804171814.GU19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804171814.GU19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04, Peter Zijlstra wrote:
>
> On Mon, Aug 04, 2014 at 07:05:19PM +0200, Oleg Nesterov wrote:
> > Hmm. This part looks fine, but with or without this patch this all is
> > suboptimal, we do not need SAVE_ALL unless I missed something. Can't we
> > simply kill preempt.S ?
> >
> > Peter, what do you think?
>
> HPA right, not me?

You too ;)

> I'm never sure on these details, if hpa thinks its
> fine, I'm good.

OK, please see v2 below, I missed the unconditional "Place EIP in the arg1"
in thunk_32.S.

Seems to work at least on x86_64, but I do not know how to test, lets see
what HPA thinks.

_If_ this is correct, I should probably rebase it on top of Denys's
changes... Or, given that this patch is simple, perhaps Denys can take
this patch as 1/X. If correct ;)

Oleg.

----------------------------------------------------------------------------
Subject: [PATCH] x86: reimplement ___preempt_schedule*() using THUNK helpers

---
 arch/x86/kernel/Makefile  |    2 --
 arch/x86/kernel/preempt.S |   25 -------------------------
 arch/x86/lib/thunk_32.S   |   20 ++++++++++++++++----
 arch/x86/lib/thunk_64.S   |    7 +++++++
 4 files changed, 23 insertions(+), 31 deletions(-)
 delete mode 100644 arch/x86/kernel/preempt.S

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 047f9ff..3f5d657 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -39,8 +39,6 @@ obj-y			+= tsc.o tsc_msr.o io_delay.o rtc.o
 obj-y			+= pci-iommu_table.o
 obj-y			+= resource.o
 
-obj-$(CONFIG_PREEMPT)	+= preempt.o
-
 obj-y				+= process.o
 obj-y				+= i387.o xsave.o
 obj-y				+= ptrace.o
diff --git a/arch/x86/kernel/preempt.S b/arch/x86/kernel/preempt.S
deleted file mode 100644
index ca7f0d5..0000000
--- a/arch/x86/kernel/preempt.S
+++ /dev/null
@@ -1,25 +0,0 @@
-
-#include <linux/linkage.h>
-#include <asm/dwarf2.h>
-#include <asm/asm.h>
-#include <asm/calling.h>
-
-ENTRY(___preempt_schedule)
-	CFI_STARTPROC
-	SAVE_ALL
-	call preempt_schedule
-	RESTORE_ALL
-	ret
-	CFI_ENDPROC
-
-#ifdef CONFIG_CONTEXT_TRACKING
-
-ENTRY(___preempt_schedule_context)
-	CFI_STARTPROC
-	SAVE_ALL
-	call preempt_schedule_context
-	RESTORE_ALL
-	ret
-	CFI_ENDPROC
-
-#endif
diff --git a/arch/x86/lib/thunk_32.S b/arch/x86/lib/thunk_32.S
index 28f85c9..7f1641a 100644
--- a/arch/x86/lib/thunk_32.S
+++ b/arch/x86/lib/thunk_32.S
@@ -7,16 +7,19 @@
 	#include <linux/linkage.h>
 	#include <asm/asm.h>
 
-#ifdef CONFIG_TRACE_IRQFLAGS
 	/* put return address in eax (arg1) */
-	.macro thunk_ra name,func
+	.macro thunk_ra name, func, put_ret_addr_in_eax=0
 	.globl \name
 \name:
 	pushl %eax
 	pushl %ecx
 	pushl %edx
+
+	.if \put_ret_addr_in_eax
 	/* Place EIP in the arg1 */
 	movl 3*4(%esp), %eax
+	.endif
+
 	call \func
 	popl %edx
 	popl %ecx
@@ -25,6 +28,15 @@
 	_ASM_NOKPROBE(\name)
 	.endm
 
-	thunk_ra trace_hardirqs_on_thunk,trace_hardirqs_on_caller
-	thunk_ra trace_hardirqs_off_thunk,trace_hardirqs_off_caller
+#ifdef CONFIG_TRACE_IRQFLAGS
+	thunk_ra trace_hardirqs_on_thunk,trace_hardirqs_on_caller,1
+	thunk_ra trace_hardirqs_off_thunk,trace_hardirqs_off_caller,1
+#endif
+
+#ifdef CONFIG_PREEMPT
+	THUNK ___preempt_schedule, preempt_schedule
+#ifdef CONFIG_CONTEXT_TRACKING
+	THUNK ___preempt_schedule_context, preempt_schedule_context
 #endif
+#endif
+
diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
index 92d9fea..b30b5eb 100644
--- a/arch/x86/lib/thunk_64.S
+++ b/arch/x86/lib/thunk_64.S
@@ -38,6 +38,13 @@
 	THUNK lockdep_sys_exit_thunk,lockdep_sys_exit
 #endif
 
+#ifdef CONFIG_PREEMPT
+	THUNK ___preempt_schedule, preempt_schedule
+#ifdef CONFIG_CONTEXT_TRACKING
+	THUNK ___preempt_schedule_context, preempt_schedule_context
+#endif
+#endif
+
 	/* SAVE_ARGS below is used only for the .cfi directives it contains. */
 	CFI_STARTPROC
 	SAVE_ARGS
-- 
1.5.5.1


