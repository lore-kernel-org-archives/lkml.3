Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3LEIe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 03:34:28 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38396 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab3LEIe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:34:27 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-a8-52a03a90b59b
Subject: [PATCH 1/2] ARM: check stack pointer in get_wchan
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Date: Thu, 05 Dec 2013 12:34:24 +0400
Message-id: <20131205083424.32632.51618.stgit@buzz>
User-Agent: StGit/0.15
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t/xy7oTrBYEGfxda23xY2cvq8Wmx9dY
	LS7vmsNmcfsyr8XUGT/YLV5+PMHiwOaxZt4aRo+W5h42j81L6j36tqxi9Pi8SS6ANYrLJiU1
	J7MstUjfLoEr48PH2WwFU/gqHr2cytjAeJW7i5GTQ0LARGL/+43MELaYxIV769m6GLk4hASW
	MkrsurKIBcJpYJJounOOEaRKWMBK4sOERawgtohAvsTXA3vYQGw2ATOJbftug9UwC/hLbGyd
	DTaVRUBV4tmXm+wgNq+AscT9bQ1MILYo0LY1l04yQcQFJX5Mvge0jAOoV11iypRciDHyEpvX
	vGWewMg3C0nVLISqWUiqFjAyr2IUTS1NLihOSs811CtOzC0uzUvXS87P3cQICdIvOxgXH7M6
	xCjAwajEw/sjf36QEGtiWXFl7iFGCQ5mJRHeWIsFQUK8KYmVValF+fFFpTmpxYcYmTg4pRoY
	zUS89Dkfzp+xueX/oxPbJmyoOd35d4asPvPTd+s/WGrHiU02Ydm5JdrU3vnQ4qW/SqM/b/0l
	MZdt9dLzLUu+tH09vMU96FTI01WOD25MNwly9kh6smluf3qDKt+N/Rp+a1vdSk/P8Lh0R+Db
	0uW6bDbq3sk3928+M3PttnMLcooY98o3f7niEK3EUpyRaKjFXFScCAADCTAaMAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_wchan() is lockless. Task may wakeup at any time and change its own stack,
thus each next stack frame may be overwritten and filled with random stuff.

/proc/$pid/stack interface had been disabled for non-current tasks, see [1]
But 'wchan' still allows to trigger stack frame unwinding on volatile stack.

This patch fixes oops in unwind_frame() by adding stack pointer validation on
each step (as x86 code do), unwind_frame() already checks frame pointer.

Also I've found another report of this oops on stackoverflow (irony).

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Link: http://www.spinics.net/lists/arm-kernel/msg110589.html [1]
Link: http://stackoverflow.com/questions/18479894/unwind-frame-cause-a-kernel-paging-error
Acked-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/kernel/process.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 94f6b05..92f7b15 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -404,6 +404,7 @@ EXPORT_SYMBOL(dump_fpu);
 unsigned long get_wchan(struct task_struct *p)
 {
 	struct stackframe frame;
+	unsigned long stack_page;
 	int count = 0;
 	if (!p || p == current || p->state == TASK_RUNNING)
 		return 0;
@@ -412,9 +413,11 @@ unsigned long get_wchan(struct task_struct *p)
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

