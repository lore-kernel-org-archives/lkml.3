Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab3LRWRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:17:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab3LRVJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:09:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.4 05/31] ARM: 7912/1: check stack pointer in get_wchan
Date: Wed, 18 Dec 2013 13:08:13 -0800
Message-Id: <20131218210522.943736314@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218210522.790152625@linuxfoundation.org>
References: <20131218210522.790152625@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/process.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -503,6 +503,7 @@ EXPORT_SYMBOL(kernel_thread);
 unsigned long get_wchan(struct task_struct *p)
 {
 	struct stackframe frame;
+	unsigned long stack_page;
 	int count = 0;
 	if (!p || p == current || p->state == TASK_RUNNING)
 		return 0;
@@ -511,9 +512,11 @@ unsigned long get_wchan(struct task_stru
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


