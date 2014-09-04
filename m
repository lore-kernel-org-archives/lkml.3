Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbaIDOxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:53:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbaIDOw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:52:57 -0400
From: Aaron Tomlin <atomlin@redhat.com>
To: peterz@infradead.org
Cc: mingo@redhat.com, dzickus@redhat.com, bmr@redhat.com, jcastillo@redhat.com,
        atomlin@redhat.com, oleg@redhat.com, pzijlstr@redhat.com,
        riel@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        x86@kernel.org, rostedt@goodmis.org, hannes@cmpxchg.org,
        aneesh.kumar@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, minchan@kernel.org
Subject: [PATCH 2/2] sched: BUG when stack end location is over written
Date: Thu,  4 Sep 2014 15:50:24 +0100
Message-Id: <1409842224-11847-3-git-send-email-atomlin@redhat.com>
In-Reply-To: <1409842224-11847-1-git-send-email-atomlin@redhat.com>
References: <1409842224-11847-1-git-send-email-atomlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently in the event of a stack overrun a call to schedule()
does not check for this type of corruption. This corruption is
often silent and can go unnoticed. However once the corrupted
region is examined at a later stage, the outcome is undefined
and often results in a sporadic page fault which cannot be
handled.

This patch checks for a stack overrun and takes appropriate
action since the damage is already done, there is no point
in continuing.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
---
 kernel/sched/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ec1a286..d6af6a0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2660,6 +2660,9 @@ static noinline void __schedule_bug(struct task_struct *prev)
  */
 static inline void schedule_debug(struct task_struct *prev)
 {
+	if (unlikely(prev != &init_task &&
+		task_stack_end_corrupted(prev)))
+		BUG();
 	/*
 	 * Test if we are atomic. Since do_exit() needs to call into
 	 * schedule() atomically, we ignore that path. Otherwise whine
-- 
1.9.3

