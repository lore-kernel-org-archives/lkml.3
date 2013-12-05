Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3LENaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:30:15 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59630 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab3LENaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:30:13 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-ca-52a07fe32d4b
Subject: [PATCH 1/2] ARM64: check stack pointer in get_wchan
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Date: Thu, 05 Dec 2013 17:30:10 +0400
Message-id: <20131205133010.16410.96824.stgit@buzz>
User-Agent: StGit/0.15
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkluLIzCtJLcpLzFFi42I5/e/4Fd3H9QuCDBZe47B4v6yH0eLHzl5W
	i02Pr7FaXN41h83i5ccTLA6sHmvmrWH02Lyk3qNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	pr7+y1hwn7Pi5JkOpgbGr+xdjJwcEgImEv2nzrFA2GISF+6tZ+ti5OIQEljKKDHpTwuU08Ak
	0Tm/nxmkSljARuL6wiZmkISIwAxGic93foKNYhMwk9i27zYjiM0ioCpx7e87sLG8AsYS6+89
	YAOxRYFWrLl0kgkiLijxY/I9oBoODmYBdYkpU3JBwswC8hKb17xlnsDIOwtJ1SyEqllIqhYw
	Mq9iFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECAm+rzsYlx6zOsQowMGoxMPrmDI/SIg1say4
	MvcQowQHs5IIr3DOgiAh3pTEyqrUovz4otKc1OJDjEwcnFINjNPZdcpTw3b0amhtbHT4/Ox3
	rMbn9zVm103ivnnIvPY6s3TJlEIx9fwzfmmT/Ht+TDh2JG1Ke8Ff24kvZWXyBZJCLvz9efS8
	PgfL/LsBVpabPH0nvGxLMFNWm/PWnqPr84L2hKMrVxkK/LZzy1Up7/+ppvM4IdLaR/uIWeLr
	MuOD4ZaT3nRvVWIpzkg01GIuKk4EAFkF7ZQcAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_wchan() is lockless. Task may wakeup at any time and change its own stack,
thus each next stack frame may be overwritten and filled with random stuff.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 arch/arm64/kernel/process.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index de17c89..0adb8f0 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -308,6 +308,7 @@ struct task_struct *__switch_to(struct task_struct *prev,
 unsigned long get_wchan(struct task_struct *p)
 {
 	struct stackframe frame;
+	unsigned long stack_page;
 	int count = 0;
 	if (!p || p == current || p->state == TASK_RUNNING)
 		return 0;
@@ -315,9 +316,11 @@ unsigned long get_wchan(struct task_struct *p)
 	frame.fp = thread_saved_fp(p);
 	frame.sp = thread_saved_sp(p);
 	frame.pc = thread_saved_pc(p);
+	stack_page = (unsigned long)task_stack_page(p);
 	do {
-		int ret = unwind_frame(&frame);
-		if (ret < 0)
+		if (frame.sp < stack_page ||
+		    frame.sp >= stack_page + THREAD_SIZE ||
+		    unwind_frame(&frame))
 			return 0;
 		if (!in_sched_functions(frame.pc))
 			return frame.pc;

