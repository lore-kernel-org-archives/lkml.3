Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaAPSkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:40:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41171 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaAPSkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:40:19 -0500
Date: Thu, 16 Jan 2014 10:39:30 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-eaad45132c564ce377e6dce05e78e08e456d5315@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <20140116165425.GA9481@laptop.programming.kicks-ass.net>
References: <20140116165425.GA9481@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix __sched_setscheduler() nice test
Git-Commit-ID: eaad45132c564ce377e6dce05e78e08e456d5315
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 10:39:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eaad45132c564ce377e6dce05e78e08e456d5315
Gitweb:     http://git.kernel.org/tip/eaad45132c564ce377e6dce05e78e08e456d5315
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 16 Jan 2014 17:54:25 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 16 Jan 2014 18:07:08 +0100

sched: Fix __sched_setscheduler() nice test

With the introduction of sched_attr::sched_nice we need to check
if we've got permission to actually change the nice value.

Daniel found that can_nice() would always fail; and upon
inspection it turns out that can_nice() only tests to see if we
can lower the nice value, but it doesn't validate if we're
lowering or not.

Therefore amend the test to only call can_nice() when we lower
the nice value.

Reported-and-Tested-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: raistlin@linux.it
Cc: juri.lelli@gmail.com
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Fixes: d50dde5a10f3 ("sched: Add new scheduler syscalls to support an extended scheduling parameters ABI")
Link: http://lkml.kernel.org/r/20140116165425.GA9481@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 93a2836..36c951b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3296,7 +3296,8 @@ recheck:
 	 */
 	if (user && !capable(CAP_SYS_NICE)) {
 		if (fair_policy(policy)) {
-			if (!can_nice(p, attr->sched_nice))
+			if (attr->sched_nice < TASK_NICE(p) &&
+			    !can_nice(p, attr->sched_nice))
 				return -EPERM;
 		}
 
