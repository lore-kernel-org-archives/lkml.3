Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaLEMbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:31:49 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:57769 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaLEMbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:31:48 -0500
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sched: Fix potential call to __ffs(0) in sched_show_task()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201412052131.GCE35924.FVHFOtLOJOMQFS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 5 Dec 2014 21:31:14 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8579fc072fda603c4ae472cc3f0390d61556ac01 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Fri, 5 Dec 2014 21:22:22 +0900
Subject: [PATCH] sched: Fix potential call to __ffs(0) in sched_show_task()

"struct task_struct"->state is "volatile long" and __ffs() warns that
"Undefined if no bit exists, so code should check against 0 first."

Therefore, at expression

  state = p->state ? __ffs(p->state) + 1 : 0;

in sched_show_task(), CPU might see "p->state" before "?" as "non-zero"
but "p->state" after "?" as "zero", which could result in
"state >= sizeof(stat_nam)" being true and bogus '?' is printed.

This patch changes "state" from "unsigned int" to "unsigned long" and
save "p->state" before calling __ffs(), in order to avoid potential call
to __ffs(0).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 kernel/sched/core.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 89e7283..8cb5f9b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4528,9 +4528,10 @@ void sched_show_task(struct task_struct *p)
 {
 	unsigned long free = 0;
 	int ppid;
-	unsigned state;
+	unsigned long state = p->state;
 
-	state = p->state ? __ffs(p->state) + 1 : 0;
+	if (state)
+		state = __ffs(state) + 1;
 	printk(KERN_INFO "%-15.15s %c", p->comm,
 		state < sizeof(stat_nam) - 1 ? stat_nam[state] : '?');
 #if BITS_PER_LONG == 32
-- 
1.7.1
