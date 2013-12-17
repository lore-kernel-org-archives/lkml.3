Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab3LQSWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:22:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32893 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab3LQSPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:15:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 083/103] ARM: 7912/1: check stack pointer in get_wchan
Date: Tue, 17 Dec 2013 18:13:12 +0000
Message-Id: <1387304012-23805-84-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/kernel/process.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 693b744..e5bacab 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -483,6 +483,7 @@ EXPORT_SYMBOL(kernel_thread);
 unsigned long get_wchan(struct task_struct *p)
 {
 	struct stackframe frame;
+	unsigned long stack_page;
 	int count = 0;
 	if (!p || p == current || p->state == TASK_RUNNING)
 		return 0;
@@ -491,9 +492,11 @@ unsigned long get_wchan(struct task_struct *p)
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

