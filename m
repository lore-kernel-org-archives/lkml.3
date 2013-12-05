Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab3LENkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:40:21 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60195 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab3LENkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:40:20 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-70-52a0824137fe
Subject: [PATCH] x86-64: fix stack bounds checking in get_wchan
To: Andi Kleen <ak@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Date: Thu, 05 Dec 2013 17:40:17 +0400
Message-id: <20131205134017.17161.147.stgit@buzz>
User-Agent: StGit/0.15
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t/xy7qOTQuCDLZs1rU4PsHSYtpGcYsf
	O3tZLS7vmsNmcenAAiaLzZumMlv82PCY1YHdY9OqTjaPd+fOsXvMOxno8X7fVTaPvi2rGD0+
	b5LzONHyhTWAPYrLJiU1J7MstUjfLoErY0Xfb8aCbs6K5y+PsDQwrmbvYuTgkBAwkfg3R7yL
	kRPIFJO4cG89WxcjF4eQwFJGibXbHzFDOA1MEnOu32ICaRAWsJd4NKcMJC4isJdR4nz/I0aQ
	bjYBM4lt+26D2SwCqhIzbswEs3kFDCWu3lvFDGKLAm1Yc+kkE0RcUOLH5HssIDOZBdQlpkzJ
	BQkzC8hLbF7zlnkCI+8sJFWzEKpmIalawMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMk
	TL/uYFx6zOoQowAHoxIPr2PK/CAh1sSy4srcQ4wSHMxKIrzbGxYECfGmJFZWpRblxxeV5qQW
	H2Jk4uCUamB0C346ca34WSeteI3Nn/eFypx+XHZpkwlHjbF1324TI8YXps5HeeuEF2w4fOHA
	gxD/f2q/S+u9xUMnFPsbKeyWTD7+3sXxQsrqDS/+bmGdd0Vf7cij4Gm/7V525U7OvhqT3tf3
	LerIgxDdf9L/3p57ssSda+EThZRdT3Znznua+DTmLfeCw/tylFiKMxINtZiLihMBnwXFWDEC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes potential oops on unwinding volatile stack. get_wchan() is
lockless, task may wake up at any time and override any frame under us.
Stackframe is 16 bytes long plus it's supposed to be 64bit aligned.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 arch/x86/kernel/process_64.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 9c0280f..a7f089d 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -442,12 +442,11 @@ unsigned long get_wchan(struct task_struct *p)
 	if (!p || p == current || p->state == TASK_RUNNING)
 		return 0;
 	stack = (unsigned long)task_stack_page(p);
-	if (p->thread.sp < stack || p->thread.sp >= stack+THREAD_SIZE)
+	if (p->thread.sp < stack || p->thread.sp > stack + THREAD_SIZE - 8)
 		return 0;
 	fp = *(u64 *)(p->thread.sp);
 	do {
-		if (fp < (unsigned long)stack ||
-		    fp >= (unsigned long)stack+THREAD_SIZE)
+		if (fp < stack || fp > stack + THREAD_SIZE - 16 || fp & 7)
 			return 0;
 		ip = *(u64 *)(fp+8);
 		if (!in_sched_functions(ip))

