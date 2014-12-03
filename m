Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaLCDVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 22:21:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:54951 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750931AbaLCDVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 22:21:08 -0500
Message-Id: <20141203032106.019621650@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 02 Dec 2014 22:13:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Theodore Tso <tytso@mit.edu>, Alexei Starovoitov <ast@plumgrid.com>
Subject: [PATCH 2/3] tracing: Allow NOT to filter AND and OR clauses
References: <20141203031334.174087814@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-tracing-Allow-NOT-to-filter-AND-and-OR-clauses.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add support to allow not "!" for and (&&) and (||). That is:

 !(field1 == X && field2 == Y)

Where the value of the full clause will be notted.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index e6a33db83856..ced69da0ff55 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -489,9 +489,10 @@ static int process_ops(struct filter_pred *preds,
 		if (!WARN_ON_ONCE(!pred->fn))
 			match = pred->fn(pred, rec);
 		if (!!match == type)
-			return match;
+			break;
 	}
-	return match;
+	/* If not of not match is equal to not of not, then it is a match */
+	return !!match == !op->not;
 }
 
 struct filter_match_preds_data {
@@ -740,10 +741,10 @@ static int filter_set_pred(struct event_filter *filter,
 		 * then this op can be folded.
 		 */
 		if (left->index & FILTER_PRED_FOLD &&
-		    (left->op == dest->op ||
+		    ((left->op == dest->op && !left->not) ||
 		     left->left == FILTER_PRED_INVALID) &&
 		    right->index & FILTER_PRED_FOLD &&
-		    (right->op == dest->op ||
+		    ((right->op == dest->op && !right->not) ||
 		     right->left == FILTER_PRED_INVALID))
 			dest->index |= FILTER_PRED_FOLD;
 
-- 
2.1.3


