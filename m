Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbbAWIZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:25:41 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:54938 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbbAWIZj convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 23 Jan 2015 03:25:39 -0500
Message-Id: <54C2139202000078000588F7@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 23 Jan 2015 08:25:38 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Peter Zijlstra" <peterz@infradead.org>, <mingo@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: sched/fair: avoid using uninitialized variable in
 preferred_group_nid()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least some gcc versions - validly afaict - warn about potentially
using max_group uninitialized: There's no way the compiler can prove
that the body of the conditional where it and max_faults get set/
updated gets executed; in fact, without knowing all the details of
other scheduler code, I can't prove this either.

Generally the necessary change would appear to be to clear max_group
prior to entering the inner loop, and break out of the outer loop when
it ends up being all clear after the inner one. This, however, seems
inefficient, and afaict the same effect can be achieved by exiting the
outer loop when max_faults is still zero after the inner loop. For the
compiler's sake, mark max_group uninitialized, as we're now able to
prove it's not actually being used uninitalized anymore.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- 3.19-rc5/kernel/sched/fair.c
+++ 3.19-rc5-sched-fair-preferred-group-nid/kernel/sched/fair.c
@@ -1730,7 +1730,7 @@ static int preferred_group_nid(struct ta
 	nodes = node_online_map;
 	for (dist = sched_max_numa_distance; dist > LOCAL_DISTANCE; dist--) {
 		unsigned long max_faults = 0;
-		nodemask_t max_group;
+		nodemask_t uninitialized_var(max_group);
 		int a, b;
 
 		/* Are there nodes at this distance from each other? */
@@ -1764,6 +1764,8 @@ static int preferred_group_nid(struct ta
 			}
 		}
 		/* Next round, evaluate the nodes within max_group. */
+		if (!max_faults)
+			break;
 		nodes = max_group;
 	}
 	return nid;



