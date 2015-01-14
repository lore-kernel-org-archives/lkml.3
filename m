Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbbANOCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:02:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36868 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbbANOCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:02:46 -0500
Date: Wed, 14 Jan 2015 06:02:10 -0800
From: tip-bot for Tetsuo Handa <tipbot@zytor.com>
Message-ID: <tip-1f8a7633094b7886c0677b78ba60b82e501f3ce6@git.kernel.org>
Cc: peterz@infradead.org, hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        torvalds@linux-foundation.org
Reply-To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        penguin-kernel@I-love.SAKURA.ne.jp, tglx@linutronix.de,
        mingo@kernel.org, peterz@infradead.org, hpa@zytor.com
In-Reply-To: <201412052131.GCE35924.FVHFOtLOJOMQFS@I-love.SAKURA.ne.jp>
References: <201412052131.GCE35924.FVHFOtLOJOMQFS@I-love.SAKURA.ne.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/debug: Fix potential call to __ffs(0)
  in sched_show_task()
Git-Commit-ID: 1f8a7633094b7886c0677b78ba60b82e501f3ce6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f8a7633094b7886c0677b78ba60b82e501f3ce6
Gitweb:     http://git.kernel.org/tip/1f8a7633094b7886c0677b78ba60b82e501f3ce6
Author:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
AuthorDate: Fri, 5 Dec 2014 21:22:22 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 14 Jan 2015 13:34:15 +0100

sched/debug: Fix potential call to __ffs(0) in sched_show_task()

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
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/201412052131.GCE35924.FVHFOtLOJOMQFS@I-love.SAKURA.ne.jp
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 56c9b79..816c172 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4508,9 +4508,10 @@ void sched_show_task(struct task_struct *p)
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
