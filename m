Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbaJOFMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 01:12:16 -0400
Received: from mga14.intel.com ([192.55.52.115]:61472 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbaJOFMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 01:12:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="400441083"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 8/8] x86: Use rd/wr fs/gs base in arch_prctl
Date: Tue, 14 Oct 2014 22:11:51 -0700
Message-Id: <1413349911-3620-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413349911-3620-1-git-send-email-andi@firstfloor.org>
References: <1413349911-3620-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Convert arch_prctl to use the new instructions to
change fs/gs if available, instead of using MSRs.

This is merely a small performance optimization,
no new functionality.

With the new instructions the syscall is really obsolete,
as everything can be set directly in ring 3. But the syscall
is widely used by existing software, so we still support it.

The syscall still enforces that the addresses are not
in kernel space, even though that is not needed more.
This is mainly so that the programs written for new CPUs
do not suddenly fail on old CPUs.

With the new instructions available it prefers to use
them in the context switch, instead of using the old
"use GDT segment rewrite" trick.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/process_64.c | 45 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 9bad75a..7669b3b 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -486,15 +486,23 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
 	int ret = 0;
 	int doit = task == current;
 	int cpu;
+	int fast_seg = boot_cpu_has(X86_FEATURE_FSGSBASE);
 
 	switch (code) {
 	case ARCH_SET_GS:
+		/*
+		 * With fast_seg we don't need that check anymore,
+		 * but keep it so that programs do not suddenly
+		 * start failing when run on older CPUs.
+		 * If you really want to set a address in kernel space
+		 * use WRGSBASE directly.
+		 */
 		if (addr >= TASK_SIZE_OF(task))
 			return -EPERM;
 		cpu = get_cpu();
 		/* handle small bases via the GDT because that's faster to
 		   switch. */
-		if (addr <= 0xffffffff) {
+		if (addr <= 0xffffffff && !fast_seg) {
 			set_32bit_tls(task, GS_TLS, addr);
 			if (doit) {
 				load_TLS(&task->thread, cpu);
@@ -506,8 +514,17 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
 			task->thread.gsindex = 0;
 			task->thread.gs = addr;
 			if (doit) {
-				load_gs_index(0);
-				ret = wrmsrl_safe(MSR_KERNEL_GS_BASE, addr);
+				if (fast_seg) {
+					local_irq_disable();
+					swapgs();
+					loadsegment(gs, 0);
+					wrgsbase(addr);
+					swapgs();
+					local_irq_enable();
+				} else {
+					load_gs_index(0);
+					ret = wrmsrl_safe(MSR_KERNEL_GS_BASE, addr);
+				}
 			}
 		}
 		put_cpu();
@@ -520,7 +537,7 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
 		cpu = get_cpu();
 		/* handle small bases via the GDT because that's faster to
 		   switch. */
-		if (addr <= 0xffffffff) {
+		if (addr <= 0xffffffff && !fast_seg) {
 			set_32bit_tls(task, FS_TLS, addr);
 			if (doit) {
 				load_TLS(&task->thread, cpu);
@@ -535,7 +552,10 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
 				/* set the selector to 0 to not confuse
 				   __switch_to */
 				loadsegment(fs, 0);
-				ret = wrmsrl_safe(MSR_FS_BASE, addr);
+				if (fast_seg)
+					wrfsbase(addr);
+				else
+					ret = wrmsrl_safe(MSR_FS_BASE, addr);
 			}
 		}
 		put_cpu();
@@ -544,6 +564,8 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
 		unsigned long base;
 		if (task->thread.fsindex == FS_TLS_SEL)
 			base = read_32bit_tls(task, FS_TLS);
+		else if (doit && fast_seg)
+			base = rdfsbase();
 		else if (doit)
 			rdmsrl(MSR_FS_BASE, base);
 		else
@@ -558,9 +580,16 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
 			base = read_32bit_tls(task, GS_TLS);
 		else if (doit) {
 			savesegment(gs, gsindex);
-			if (gsindex)
-				rdmsrl(MSR_KERNEL_GS_BASE, base);
-			else
+			if (gsindex) {
+				if (fast_seg) {
+					local_irq_disable();
+					swapgs();
+					base = rdgsbase();
+					swapgs();
+					local_irq_enable();
+				} else
+					rdmsrl(MSR_KERNEL_GS_BASE, base);
+			} else
 				base = task->thread.gs;
 		} else
 			base = task->thread.gs;
-- 
1.9.3

