Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaAPMUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 07:20:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35661 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaAPMUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 07:20:20 -0500
Date: Thu, 16 Jan 2014 13:19:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20140116121955.GQ31570@twins.programming.kicks-ass.net>
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 02:58:29PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> arch/x86/kernel/process.c: In function 'mwait_idle':
> /scratch/sfr/next/arch/x86/kernel/process.c:434:3: error: implicit declaration of function '__monitor' [-Werror=implicit-function-declaration]
>    __monitor((void *)&current_thread_info()->flags, 0, 0);
>    ^
> arch/x86/kernel/process.c:437:4: error: implicit declaration of function '__sti_mwait' [-Werror=implicit-function-declaration]
>     __sti_mwait(0, 0);
>     ^
> 
> Caused by commit 16824255394f ("x86, acpi, idle: Restructure the mwait
> idle routines") interacting with commit 7760518cce95 ("x86 idle: restore
> mwait_idle()") from the idle tree.
> 
> I am not sure how to fix this so I just reverted the idle tree commit for
> now (since it reverted cleanly). Please let me know if there is a better
> solution.

I think the below ought to work

---
 arch/x86/kernel/process.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 3fb8d95ab8b5..220df9b2f22a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -28,6 +28,7 @@
 #include <asm/fpu-internal.h>
 #include <asm/debugreg.h>
 #include <asm/nmi.h>
+#include <asm/mwait.h>
 
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
@@ -398,6 +399,37 @@ static void amd_e400_idle(void)
 		default_idle();
 }
 
+/*
+ * Intel Core2 and older machines prefer MWAIT over HALT for C1.
+ * We can't rely on cpuidle installing MWAIT, because it will not load
+ * on systems that support only C1 -- so the boot default must be MWAIT.
+ *  
+ * Some AMD machines are the opposite, they depend on using HALT.
+ *
+ * So for default C1, which is used during boot until cpuidle loads,
+ * use MWAIT-C1 on Intel HW that has it, else use HALT.
+ */
+static int prefer_mwait_c1_over_halt(const struct cpuinfo_x86 *c)
+{
+	if (c->x86_vendor != X86_VENDOR_INTEL)
+		return 0;
+
+	if (!cpu_has(c, X86_FEATURE_MWAIT))
+		return 0;
+
+	return 1;
+}
+
+/*
+ * MONITOR/MWAIT with no hints, used for default default C1 state.
+ * This invokes MWAIT with interrutps enabled and no flags,
+ * which is backwards compatible with the original MWAIT implementation.
+ */
+static void mwait_idle(void)
+{
+	mwait_idle_with_hints(0, 0);
+}
+
 void select_idle_routine(const struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
@@ -411,6 +443,9 @@ void select_idle_routine(const struct cpuinfo_x86 *c)
 		/* E400: APIC timer interrupt does not wake up CPU from C1e */
 		pr_info("using AMD E400 aware idle routine\n");
 		x86_idle = amd_e400_idle;
+	} else if (prefer_mwait_c1_over_halt(c)) {
+		pr_info("using mwait in idle threads\n");
+		x86_idle = mwait_idle;
 	} else
 		x86_idle = default_idle;
 }
