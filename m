Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbaAPQye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 11:54:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42330 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbaAPQyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:54:32 -0500
Date: Thu, 16 Jan 2014 17:54:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: raistlin@linux.it, juri.lelli@gmail.com, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: Fix __sched_setscheduler() nice test
Message-ID: <20140116165425.GA9481@laptop.programming.kicks-ass.net>
References: <52D64676.4040000@linaro.org>
 <20140115120418.GD31570@twins.programming.kicks-ass.net>
 <52D7E343.40909@linaro.org>
 <20140116141743.GT31570@twins.programming.kicks-ass.net>
 <52D7EAA4.2080208@linaro.org>
 <20140116142546.GU31570@twins.programming.kicks-ass.net>
 <52D7ED0A.2030502@linaro.org>
 <20140116154239.GR7572@laptop.programming.kicks-ass.net>
 <52D7FFCE.1030108@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D7FFCE.1030108@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: Fix __sched_setscheduler() nice test

With the introduction of sched_attr::sched_nice we need to check if
we've got permission to actually change the nice value.

Daniel found that can_nice() would always fail; and upon inspection it
turns out that can_nice() only tests to see if we can lower the nice
value, but it doesn't validate if we're lowering or not.

Therefore amend the test to only call can_nice() when we lower the nice
value.

Cc: raistlin@linux.it
Cc: juri.lelli@gmail.com
Fixes: d50dde5a10f3 ("sched: Add new scheduler syscalls to support an extended scheduling parameters ABI")
Reported-and-Tested-by: Daniel Lezcano <daniel.lezcano@linaro.org> 
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 93a2836b6220..36c951b7eef8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3296,7 +3296,8 @@ static int __sched_setscheduler(struct task_struct *p,
 	 */
 	if (user && !capable(CAP_SYS_NICE)) {
 		if (fair_policy(policy)) {
-			if (!can_nice(p, attr->sched_nice))
+			if (attr->sched_nice < TASK_NICE(p) &&
+			    !can_nice(p, attr->sched_nice))
 				return -EPERM;
 		}
 
