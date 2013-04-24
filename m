Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab3DXXE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 19:04:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:12638 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071Ab3DXXE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 19:04:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,546,1363158000"; 
   d="scan'208";a="231818589"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] Fix perf LBR filtering
Date: Wed, 24 Apr 2013 16:04:53 -0700
Message-Id: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The perf LBR code has special code to filter specific
instructions in software.

The LBR logs any instruction address, even if IP just faulted.
This means user space can control any address by just branching
to a bad address.

On a modern Intel system the only software filtering needed
is to include SYSCALL/RETs in PERF_SAMPLE_BRANCH_ANY_CALL/RETURN.
The hardware call filter only handles short calls, but syscall
is a far call. So it enables far call logging too, but removes
any other far calls (like interrupts) by looking at the instruction.
On older systems some additional software filtering is done too,
to work a problem that CALLs can be only logged together with
indirect jumps.

It currently assumes that any address that looks like a kernel
address can be safely referenced.

But that is dangerous if can be controlled by the user:
- It can be used to crash the kernel
- It allows to probe any physical address for a small set of values
(valid call op codes) which is an information leak.
- It may point to a side effect on read MMIO region

So we cannot reference kernel addresses safely.

Possible options:

I) Disable FAR calls for ANY_CALL/RETURNS.
This just means syscalls are not logged
as calls. This also lowers the overhead of call logging.
This changes semantics slightly.
This is reasonable on Sandy Bridge and later, but would
cause additional problems on Nehalem and Westmere with
their additional filters.

II) Simple disable any filtering for kernel space.
This means interrupts in kernel space are reported as calls
and on Nehalem/Westmere some indirect jumps are reported
as calls too

III) Enumerate all the kernel entry points and check.
Any bad call must have a kernel entry point as to.
This seemed to fragile to maintain.

IV) Enumerate all kernel code and check for these ranges.
Quite complicated, especially with the new kernel code JITs.
Would also allow to probe for kernel code (defeating randomized kernel)

This patch implements II: Simply disable software filtering for
any kernel address, which seemed the best.
(I) would be also an option and was earlier implemented in
https://patchwork.kernel.org/patch/2468351/
(however this patch still leaves Nehalem/Westmere/Atom open to the problem)
(III) and (IV) appear too complicated and risky.

Should be applied to applicable stable branches too. The problem
goes back a long time.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index da02e9c..ae8c76f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -442,15 +442,27 @@ static int branch_type(unsigned long from, unsigned long to)
 			return X86_BR_NONE;
 
 		addr = buf;
-	} else
-		addr = (void *)from;
+	} else {
+		/*
+		 * The LBR logs any address in IP, even if IP just faulted.
+		 * This means user space can control any address. Since
+		 * it's dangerous to reference a user controlled kernel 
+		 * address we don't do any software filtering for addresses that
+		 * look like kernel.
+		 *
+		 * On modern Intel systems (Sandy Bridge+) this implies that
+		 * exceptions and interrupts in kernel space may be reported like
+		 * calls.
+		 */
+		return X86_BR_NONE;
+	}
 
 	/*
 	 * decoder needs to know the ABI especially
 	 * on 64-bit systems running 32-bit apps
 	 */
 #ifdef CONFIG_X86_64
-	is64 = kernel_ip((unsigned long)addr) || !test_thread_flag(TIF_IA32);
+	is64 = !test_thread_flag(TIF_IA32);
 #endif
 	insn_init(&insn, addr, is64);
 	insn_get_opcode(&insn);
-- 
1.7.7.6

