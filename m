Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbaKRQud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:50:33 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52661 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbaKRQuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:50:32 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-62-546b78d65fe0
Subject: [PATCH] ARM: enable stack trace dumping for all tasks
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Dave Martin <Dave.Martin@arm.com>
Date: Tue, 18 Nov 2014 19:50:29 +0400
Message-id: <20141118165029.9812.96216.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t/xq7rXKrJDDL5+krZomruH0eLHzl5W
	i02Pr7FaXN41h83i9mVeB1aPNfPWMHq0NPeweWxeUu/Rt2UVo8fnTXIBrFFcNimpOZllqUX6
	dglcGWcv7WUuWMNf8fFxH1MD4w2eLkZODgkBE4knfQfYIWwxiQv31rN1MXJxCAksZZS4MXcC
	O4TTyCRxcMJtJpAqYQE7iQ8L1jCD2GwCZhLb9t1mBLFFBPIlvh7YA9TNwcEsoCqx6VEqSJgF
	yPz9/BfYAl4BI4k79/+D2aICchIrL7ewQsQFJX5MvscC0aouMWVKLkiYWUBeYvOat8wTGPlm
	IamahVA1C0nVAkbmVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghgfllB+PiY1aHGAU4GJV4
	eBs2ZoUIsSaWFVfmHmKU4GBWEuE91w0U4k1JrKxKLcqPLyrNSS0+xMjEwSnVwBiqY/dMcatD
	xOIHayLlrynOPlJr0VzIbNik8ym0KM5Fc1lHbuvir4KdS7eZpn3rmtBbZ/Guf+at5/kvl8eW
	v90sYXJeiSn9BysfI4+Y0zKXqyVLylelX+p5VSK56UVlx5e776IeBSU+S7We2lE+5SkD+7/Q
	bzpVMbKBxknG3TVzfx8X9go8rsRSnJFoqMVcVJwIAPeM4EQqAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables CONFIG_STACKTRACE dumper for non-current tasks.
Both version of function unwind_frame() now check stack boundaries:
frame-pointer based after commit 3abb6671a9c04479c4bd026798a05f857393b7e2
("ARM: 7913/1: fix framepointer check in unwind_frame"),
unwind-table based after a51345770e519552e749ff457a2a9f83171a67b5
("ARM: 7987/1: ARM : unwinder : Prevent data abort due to stack overflow").

Now it's safe to dump stack trace for any task, not only for current.
If that task is running we could get garbage but kernel will not explode.
Actually, get_wchan() uses this code path for ages without any problems:
it calls unwind_frame() after racy check "task->state != TASK_RUNNING".

This feature already exposed into userspace via /proc/$PID/stack,
it's very useful for finding where task is stuck in the kernel.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Anurag Aggarwal <a.anurag@samsung.com>
Cc: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm/kernel/stacktrace.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index f065eb0..904070f 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -118,21 +118,10 @@ static noinline void __save_stack_trace(struct task_struct *tsk,
 	data.no_sched_functions = nosched;
 
 	if (tsk != current) {
-#ifdef CONFIG_SMP
-		/*
-		 * What guarantees do we have here that 'tsk' is not
-		 * running on another CPU?  For now, ignore it as we
-		 * can't guarantee we won't explode.
-		 */
-		if (trace->nr_entries < trace->max_entries)
-			trace->entries[trace->nr_entries++] = ULONG_MAX;
-		return;
-#else
 		frame.fp = thread_saved_fp(tsk);
 		frame.sp = thread_saved_sp(tsk);
 		frame.lr = 0;		/* recovered from the stack */
 		frame.pc = thread_saved_pc(tsk);
-#endif
 	} else {
 		register unsigned long current_sp asm ("sp");
 

