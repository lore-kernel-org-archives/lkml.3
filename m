Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391AbbA1VQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:16:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbbA1Uuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:35 -0500
Date: Wed, 28 Jan 2015 06:29:25 -0800
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-81907478c4311a679849216abf723999184ab984@git.kernel.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        riel@redhat.com, hpa@zytor.com, JBeulich@suse.com,
        peterz@infradead.org, tglx@linutronix.de, jbeulich@suse.com,
        mingo@kernel.org
Reply-To: hpa@zytor.com, riel@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, jbeulich@suse.com, mingo@kernel.org,
        peterz@infradead.org, JBeulich@suse.com, tglx@linutronix.de
In-Reply-To: <54C2139202000078000588F7@mail.emea.novell.com>
References: <54C2139202000078000588F7@mail.emea.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/fair:
  Avoid using uninitialized variable in preferred_group_nid()
Git-Commit-ID: 81907478c4311a679849216abf723999184ab984
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

Commit-ID:  81907478c4311a679849216abf723999184ab984
Gitweb:     http://git.kernel.org/tip/81907478c4311a679849216abf723999184ab984
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 23 Jan 2015 08:25:38 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 28 Jan 2015 13:14:12 +0100

sched/fair: Avoid using uninitialized variable in preferred_group_nid()

At least some gcc versions - validly afaict - warn about potentially
using max_group uninitialized: There's no way the compiler can prove
that the body of the conditional where it and max_faults get set/
updated gets executed; in fact, without knowing all the details of
other scheduler code, I can't prove this either.

Generally the necessary change would appear to be to clear max_group
prior to entering the inner loop, and break out of the outer loop when
it ends up being all clear after the inner one. This, however, seems
inefficient, and afaict the same effect can be achieved by exiting the
outer loop when max_faults is still zero after the inner loop.

[ mingo: changed the solution to zero initialization: uninitialized_var()
  needs to die, as it's an actively dangerous construct: if in the future
  a known-proven-good piece of code is changed to have a true, buggy
  uninitialized variable, the compiler warning is then supressed...

  The better long term solution is to clean up the code flow, so that
  even simple minded compilers (and humans!) are able to read it without
  getting a headache.  ]

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/54C2139202000078000588F7@mail.emea.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 40667cb..fe331fc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1730,7 +1730,7 @@ static int preferred_group_nid(struct task_struct *p, int nid)
 	nodes = node_online_map;
 	for (dist = sched_max_numa_distance; dist > LOCAL_DISTANCE; dist--) {
 		unsigned long max_faults = 0;
-		nodemask_t max_group;
+		nodemask_t max_group = NODE_MASK_NONE;
 		int a, b;
 
 		/* Are there nodes at this distance from each other? */
