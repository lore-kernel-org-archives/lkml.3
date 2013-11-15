Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab3KOMTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:19:19 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:14704 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3KOMTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:19:11 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-ba-5286113c40dd
Subject: [PATCH] arm: check stack pointer in get_wchan
To: Russell King <linux@arm.linux.org.uk>
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Date: Fri, 15 Nov 2013 16:19:07 +0400
Message-id: <20131115121907.4707.82671.stgit@buzz>
User-Agent: StGit/0.15
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e/4FV0bwbYgg4vTDS02Pb7GanF51xw2
	i9uXeS2mzvjB7sDi0dLcw+axeUm9R9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGV8PXaFuWAq
	X8Wt51dYGxivcXcxcnBICJhINNzN7mLkBDLFJC7cW8/WxcjFISSwlFHiftNGJginkUni9+Hd
	LCANwgJmEheviII0iAhoSpxafJEZxGYDCm/bd5sRxGYWKJLoudHGBmKzCKhKPPhzlQmklVfA
	SGL1LjmQsCjQrjWXTjKB2LwCghI/Jt8Dm84soC4xZUouxBR5ic1r3jJPYOSbhaRqFkLVLCRV
	CxiZVzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKEBODXHYxLj1kdYhTgYFTi4Y2Qbg0SYk0s
	K67MPcQowcGsJMJ79w1QiDclsbIqtSg/vqg0J7X4ECMTB6dUA2NcOqcHS6IKU/N/wWk/NWaf
	UEi3+d5aEuX/pGmqmqLDg2XHrp8IYO65detj4EP/o7nSGlfmWD9gXzaN4/01+77P1UzRk3Uv
	vPTiS15mLGqucZ1FtSl4aem1XVYWNc637Q79WXLJbprByfqqKZvZvkVYBXFPvyxfcEX13ucS
	x4UZ/mKrZJ+deKbEUpyRaKjFXFScCACmR8w3HgIAAA==
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
Cc: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Link: http://www.spinics.net/lists/arm-kernel/msg110589.html [1]
Link: http://stackoverflow.com/questions/18479894/unwind-frame-cause-a-kernel-paging-error
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

