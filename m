Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaAOV7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:59:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41208 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaAOV7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:59:06 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 028/166] ARM: 7912/1: check stack pointer in get_wchan
Date: Wed, 15 Jan 2014 13:50:42 -0800
Message-Id: <1389822780-4729-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>

commit 1b15ec7a7427d4188ba91b9bbac696250a059d22 upstream.

get_wchan() is lockless. Task may wakeup at any time and change its own stack,
thus each next stack frame may be overwritten and filled with random stuff.

/proc/$pid/stack interface had been disabled for non-current tasks, see [1]
But 'wchan' still allows to trigger stack frame unwinding on volatile stack.

This patch fixes oops in unwind_frame() by adding stack pointer validation on
each step (as x86 code do), unwind_frame() already checks frame pointer.

Also I've found another report of this oops on stackoverflow (irony).

Link: http://www.spinics.net/lists/arm-kernel/msg110589.html [1]
Link: http://stackoverflow.com/questions/18479894/unwind-frame-cause-a-kernel-paging-error

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/kernel/process.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index c6dec5f..31c92b8 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -434,6 +434,7 @@ EXPORT_SYMBOL(dump_fpu);
 unsigned long get_wchan(struct task_struct *p)
 {
 	struct stackframe frame;
+	unsigned long stack_page;
 	int count = 0;
 	if (!p || p == current || p->state == TASK_RUNNING)
 		return 0;
@@ -442,9 +443,11 @@ unsigned long get_wchan(struct task_struct *p)
 	frame.sp = thread_saved_sp(p);
 	frame.lr = 0;			/* recovered from the stack */
 	frame.pc = thread_saved_pc(p);
+	stack_page = (unsigned long)task_stack_page(p);
 	do {
-		int ret = unwind_frame(&frame);
-		if (ret < 0)
+		if (frame.sp < stack_page ||
+		    frame.sp >= stack_page + THREAD_SIZE ||
+		    unwind_frame(&frame) < 0)
 			return 0;
 		if (!in_sched_functions(frame.pc))
 			return frame.pc;
-- 
1.8.3.2

