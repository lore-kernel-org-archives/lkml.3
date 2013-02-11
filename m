Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab3BKH3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 02:29:19 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:56808 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab3BKH3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 02:29:15 -0500
Message-ID: <51189D2F.4030000@synopsys.com>
Date: Mon, 11 Feb 2013 12:56:39 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.cross-arch
To: <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: pt_regs leak into userspace (was Re: [PATCH v3 20/71] ARC: Signal
 handling)
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com> <1359024639-21915-9-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1359024639-21915-9-git-send-email-vgupta@synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thursday 24 January 2013 04:20 PM, Vineet Gupta wrote:
> Includes following fixes courtesy review by Al-Viro
> 
> * Tracer poke to Callee-regs were lost
> 
>   Before going off into do_signal( ) we save the user-mode callee regs
>   (as they are not saved by default as part of pt_regs). This is to make
>   sure that that a Tracer (if tracing related signal) is able to do likes
>   of PEEKUSR(callee-reg).
> 
>   However in return path we were simply discarding the user-mode callee
>   regs, which would break a POKEUSR(callee-reg) from a tracer.
> 
> * Issue related to multiple syscall restarts are addressed in next patch
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>

[snipped...]

> +#ifndef _ASM_ARC_SIGCONTEXT_H
> +#define _ASM_ARC_SIGCONTEXT_H
> +
> +#include <asm/ptrace.h>
> +
> +/*
> + * Signal context structure - contains all info to do with the state
> + * before the signal handler was invoked.  Note: only add new entries
> + * to the end of the structure.
> + */
> +struct sigcontext {
> +	struct pt_regs regs;
> +};

I ran into a pt_regs "leak" into userspace ABI - causing some apps build failures.
This prompted me to clean the slight mess in that area (patch inline below). The
"fundamental-ness" of this patch warrants a chop-n-dice-n-squash into orig series
(vs. a addon change) hence the reason for running this by you.

The fundamental change is following - with everything else being a adjustment for it.

 struct sigcontext {
-	struct pt_regs regs;
+	struct user_regs_struct regs;
 };

 struct user_regs_struct {
-	struct pt_regs scratch;
-	struct callee_regs callee;
+	struct scratch {
+		long pad;
+		long bta, lp_start, lp_end, lp_count;
+		long status32, ret, blink, fp, gp;
+		long r12, r11, r10, r9, r8, r7, r6, r5, r4, r3, r2, r1, r0;
+		long sp;
+	} scratch;
+	struct callee {
+		long pad;
+		long r25, r24, r23, r22, r21, r20;
+		long r19, r18, r17, r16, r15, r14, r13;
+	} callee;
	long efa;	/* break pt addr, for break points in delay slots */
	long stop_pc;	/* give dbg stop_pc directly after checking orig_r8 */
 };


The only downside of this patch is that userspace signal stack grows in size,
since signal frame only cares about scratch regs (pt_regs), but has to accommodate
unused placeholder for callee regs too by virtue of using user_regs_struct.

Please let me know if you OK with merge of this patch into linux-next, (obviously
after chop-n-dice-n-squash).

Thx,
-Vineet

--------------------->
From: Vineet Gupta <vgupta@synopsys.com>
Date: Mon, 11 Feb 2013 12:47:28 +0530
Subject: [PATCH] ARC RFC: Establish user_regs_struct for ABI

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/entry.h           |    1 -
 arch/arc/include/asm/ptrace.h          |   17 ++++------
 arch/arc/include/uapi/asm/ptrace.h     |   56 ++++++++++++++++----------------
 arch/arc/include/uapi/asm/sigcontext.h |    5 +--
 arch/arc/kernel/asm-offsets.c          |   19 +++++++++--
 arch/arc/kernel/signal.c               |    5 ++-
 6 files changed, 56 insertions(+), 47 deletions(-)

diff --git a/arch/arc/include/asm/entry.h b/arch/arc/include/asm/entry.h
index 23daa32..9f544fa 100644
--- a/arch/arc/include/asm/entry.h
+++ b/arch/arc/include/asm/entry.h
@@ -35,7 +35,6 @@
 #include <asm/unistd.h>		/* For NR_syscalls defination */
 #include <asm/asm-offsets.h>
 #include <asm/arcregs.h>
-#include <asm/ptrace.h>
 #include <asm/processor.h>	/* For VMALLOC_START */
 #include <asm/thread_info.h>	/* For THREAD_SIZE */

diff --git a/arch/arc/include/asm/ptrace.h b/arch/arc/include/asm/ptrace.h
index 95e633e..7d4cc32 100644
--- a/arch/arc/include/asm/ptrace.h
+++ b/arch/arc/include/asm/ptrace.h
@@ -50,13 +50,17 @@ struct pt_regs {
 	long r0;
 	long sp;	/* user/kernel sp depending on where we came from  */
 	long orig_r0;
+
 	/*to distinguish bet excp, syscall, irq */
+	union {
+		/* so that assembly code is same for LE/BE */
 #ifdef CONFIG_CPU_BIG_ENDIAN
-	/* so that assembly code is same for LE/BE */
-	unsigned long orig_r8:16, event:16;
+		unsigned long orig_r8:16, event:16;
 #else
-	unsigned long event:16, orig_r8:16;
+		unsigned long event:16, orig_r8:16;
 #endif
+		long orig_r8_word;
+	};
 };

 /* Callee saved registers - need to be saved only when you are scheduled out */
@@ -78,13 +82,6 @@ struct callee_regs {
 	long r13;
 };

-/* User mode registers, used for core dumps. */
-struct user_regs_struct {
-	struct pt_regs scratch;
-	struct callee_regs callee;
-	long efa;	/* break pt addr, for break points in delay slots */
-	long stop_pc;	/* give dbg stop_pc directly after checking orig_r8 */
-};

 #define instruction_pointer(regs)	((regs)->ret)
 #define profile_pc(regs)		instruction_pointer(regs)
diff --git a/arch/arc/include/uapi/asm/ptrace.h b/arch/arc/include/uapi/asm/ptrace.h
index bccf4ab..bacb411 100644
--- a/arch/arc/include/uapi/asm/ptrace.h
+++ b/arch/arc/include/uapi/asm/ptrace.h
@@ -12,35 +12,35 @@
 #define _UAPI__ASM_ARC_PTRACE_H

 /*
- * XXX: ABI hack.
- * The offset calc can be cleanly done in asm-offset.c, however gdb includes
- * this header directly.
+ * Userspace ABI: Register state needed by
+ *  -ptrace (gdbserver)
+ *  -sigcontext (SA_SIGNINFO signal frame)
+ *
+ * This is to decouple pt_regs from user-space ABI, to be able to change it
+ * w/o affecting the ABI.
+ * Although the layout (initial padding) is similar to pt_regs to have some
+ * optimizations when copying pt_regs to/from user_regs_struct.
+ *
+ * Also, sigcontext only care about the scratch regs as that is what we really
+ * save/restore for signal handling.
  */
-#define PT_bta		4
-#define PT_lp_start	8
-#define PT_lp_end	12
-#define PT_lp_count	16
-#define PT_status32	20
-#define PT_ret		24
-#define PT_blink	28
-#define PT_fp		32
-#define PT_r26		36
-#define PT_r12		40
-#define PT_r11		44
-#define PT_r10		48
-#define PT_r9		52
-#define PT_r8		56
-#define PT_r7		60
-#define PT_r6		64
-#define PT_r5		68
-#define PT_r4		72
-#define PT_r3		76
-#define PT_r2		80
-#define PT_r1		84
-#define PT_r0		88
-#define PT_sp		92
-#define PT_orig_r0	96
-#define PT_orig_r8	100
+struct user_regs_struct {
+
+	struct scratch {
+		long pad;
+		long bta, lp_start, lp_end, lp_count;
+		long status32, ret, blink, fp, gp;
+		long r12, r11, r10, r9, r8, r7, r6, r5, r4, r3, r2, r1, r0;
+		long sp;
+	} scratch;
+	struct callee {
+		long pad;
+		long r25, r24, r23, r22, r21, r20;
+		long r19, r18, r17, r16, r15, r14, r13;
+	} callee;
+	long efa;	/* break pt addr, for break points in delay slots */
+	long stop_pc;	/* give dbg stop_pc directly after checking orig_r8 */
+};


 #endif /* _UAPI__ASM_ARC_PTRACE_H */
diff --git a/arch/arc/include/uapi/asm/sigcontext.h
b/arch/arc/include/uapi/asm/sigcontext.h
index f21b541..9678a11 100644
--- a/arch/arc/include/uapi/asm/sigcontext.h
+++ b/arch/arc/include/uapi/asm/sigcontext.h
@@ -13,11 +13,10 @@

 /*
  * Signal context structure - contains all info to do with the state
- * before the signal handler was invoked.  Note: only add new entries
- * to the end of the structure.
+ * before the signal handler was invoked.
  */
 struct sigcontext {
-	struct pt_regs regs;
+	struct user_regs_struct regs;
 };

 #endif /* _ASM_ARC_SIGCONTEXT_H */
diff --git a/arch/arc/kernel/asm-offsets.c b/arch/arc/kernel/asm-offsets.c
index 0c06b7a..b0197ad 100644
--- a/arch/arc/kernel/asm-offsets.c
+++ b/arch/arc/kernel/asm-offsets.c
@@ -9,11 +9,11 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
-#include <asm/hardirq.h>
 #include <linux/thread_info.h>
-#include <asm/page.h>
 #include <linux/kbuild.h>
-#include <asm/event-log.h>
+#include <asm/hardirq.h>
+#include <asm/page.h>
+#include <asm/ptrace.h>

 int main(void)
 {
@@ -46,6 +46,19 @@ int main(void)

 	DEFINE(MM_CTXT_ASID, offsetof(mm_context_t, asid));

+	BLANK();
+
+	DEFINE(PT_status32, offsetof(struct pt_regs, status32));
+	DEFINE(PT_orig_r8, offsetof(struct pt_regs, orig_r8_word));
+	DEFINE(PT_r0, offsetof(struct pt_regs, r0));
+	DEFINE(PT_r1, offsetof(struct pt_regs, r1));
+	DEFINE(PT_r2, offsetof(struct pt_regs, r2));
+	DEFINE(PT_r3, offsetof(struct pt_regs, r3));
+	DEFINE(PT_r4, offsetof(struct pt_regs, r4));
+	DEFINE(PT_r5, offsetof(struct pt_regs, r5));
+	DEFINE(PT_r6, offsetof(struct pt_regs, r6));
+	DEFINE(PT_r7, offsetof(struct pt_regs, r7));
+
 #ifdef CONFIG_ARC_DBG_EVENT_TIMELINE
 	BLANK();
 	DEFINE(EVLOG_FIELD_EXTRA, offsetof(timeline_log_t, extra));
diff --git a/arch/arc/kernel/signal.c b/arch/arc/kernel/signal.c
index d16740d..e56bb7d 100644
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -70,7 +70,8 @@ stash_usr_regs(struct rt_sigframe __user *sf, struct pt_regs *regs,
 	       sigset_t *set)
 {
 	int err;
-	err = __copy_to_user(&(sf->uc.uc_mcontext.regs), regs, sizeof(*regs));
+	err = __copy_to_user(&(sf->uc.uc_mcontext.regs), regs,
+				sizeof(sf->uc.uc_mcontext.regs.scratch));
 	err |= __copy_to_user(&sf->uc.uc_sigmask, set, sizeof(sigset_t));

 	return err;
@@ -88,7 +89,7 @@ static int restore_usr_regs(struct pt_regs *regs, struct
rt_sigframe __user *sf)
 	}

 	err |= __copy_from_user(regs, &(sf->uc.uc_mcontext.regs),
-				sizeof(*regs));
+				sizeof(sf->uc.uc_mcontext.regs.scratch));

 	return err;
 }
-- 
1.7.4.1

