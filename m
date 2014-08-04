Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaHDRI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:08:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbaHDRIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:08:25 -0400
Date: Mon, 4 Aug 2014 19:05:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH?] x86: reimplement ___preempt_schedule*() using THUNK
	helpers
Message-ID: <20140804170519.GA17466@redhat.com>
References: <1407158386-6201-1-git-send-email-dvlasenk@redhat.com> <1407158386-6201-5-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407158386-6201-5-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04, Denys Vlasenko wrote:
>
> --- a/arch/x86/kernel/preempt.S
> +++ b/arch/x86/kernel/preempt.S
> @@ -6,9 +6,13 @@
>
>  ENTRY(___preempt_schedule)
>  	CFI_STARTPROC
> -	SAVE_ALL
> +	ALLOC_PTREGS_ON_STACK
> +	SAVE_C_REGS
> +	SAVE_EXTRA_REGS
>  	call preempt_schedule
> -	RESTORE_ALL
> +	RESTORE_EXTRA_REGS
> +	RESTORE_C_REGS
> +	REMOVE_PTREGS_FROM_STACK
>  	ret
>  	CFI_ENDPROC
>
> @@ -16,9 +20,13 @@ ENTRY(___preempt_schedule)
>
>  ENTRY(___preempt_schedule_context)
>  	CFI_STARTPROC
> -	SAVE_ALL
> +	ALLOC_PTREGS_ON_STACK
> +	SAVE_C_REGS
> +	SAVE_EXTRA_REGS
>  	call preempt_schedule_context
> -	RESTORE_ALL
> +	RESTORE_EXTRA_REGS
> +	RESTORE_C_REGS
> +	REMOVE_PTREGS_FROM_STACK
>  	ret
>  	CFI_ENDPROC

Hmm. This part looks fine, but with or without this patch this all is
suboptimal, we do not need SAVE_ALL unless I missed something. Can't we
simply kill preempt.S ?

Peter, what do you think?

Oleg.

----------------------------------------------------------------------------
Subject: [PATCH] x86: reimplement ___preempt_schedule*() using THUNK helpers

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
index 28f85c9..dc2b8fd 100644
--- a/arch/x86/lib/thunk_32.S
+++ b/arch/x86/lib/thunk_32.S
@@ -7,7 +7,6 @@
 	#include <linux/linkage.h>
 	#include <asm/asm.h>
 
-#ifdef CONFIG_TRACE_IRQFLAGS
 	/* put return address in eax (arg1) */
 	.macro thunk_ra name,func
 	.globl \name
@@ -25,6 +24,15 @@
 	_ASM_NOKPROBE(\name)
 	.endm
 
+#ifdef CONFIG_TRACE_IRQFLAGS
 	thunk_ra trace_hardirqs_on_thunk,trace_hardirqs_on_caller
 	thunk_ra trace_hardirqs_off_thunk,trace_hardirqs_off_caller
 #endif
+
+#ifdef CONFIG_PREEMPT
+	THUNK ___preempt_schedule, preempt_schedule
+#ifdef CONFIG_CONTEXT_TRACKING
+	THUNK ___preempt_schedule_context, preempt_schedule_context
+#endif
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

