Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaLCWOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:14:14 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:54305 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752267AbaLCWNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:13:55 -0500
Message-Id: <20141203221351.292388780@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 03 Dec 2014 17:13:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@plumgrid.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [for-next][PATCH 1/5] tracing: Add NOT to filtering logic
References: <20141203221311.563559646@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-tracing-Add-NOT-to-filtering-logic.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Ted noticed that he could not filter on an event for a bit being cleared.
That's because the filtering logic only tests event fields with a limited
number of comparisons which, for bit logic, only include "&", which can
test if a bit is set, but there's no good way to see if a bit is clear.

This adds a way to do: !(field & 2048)

Which returns true if the bit is not set, and false otherwise.

Note, currently !(field1 == 10 && field2 == 15) is not supported.
That is, the 'not' only works for direct comparisons, not for the
AND and OR logic.

Link: http://lkml.kernel.org/r/20141202021912.GA29096@thunk.org
Link: http://lkml.kernel.org/r/20141202120430.71979060@gandalf.local.home

Acked-by: Alexei Starovoitov <ast@plumgrid.com>
Suggested-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 7a8c1528e141..e6a33db83856 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -45,6 +45,7 @@ enum filter_op_ids
 	OP_GT,
 	OP_GE,
 	OP_BAND,
+	OP_NOT,
 	OP_NONE,
 	OP_OPEN_PAREN,
 };
@@ -67,6 +68,7 @@ static struct filter_op filter_ops[] = {
 	{ OP_GT,	">",		5 },
 	{ OP_GE,	">=",		5 },
 	{ OP_BAND,	"&",		6 },
+	{ OP_NOT,	"!",		6 },
 	{ OP_NONE,	"OP_NONE",	0 },
 	{ OP_OPEN_PAREN, "(",		0 },
 };
@@ -85,6 +87,7 @@ enum {
 	FILT_ERR_MISSING_FIELD,
 	FILT_ERR_INVALID_FILTER,
 	FILT_ERR_IP_FIELD_ONLY,
+	FILT_ERR_ILLEGAL_NOT_OP,
 };
 
 static char *err_text[] = {
@@ -101,6 +104,7 @@ static char *err_text[] = {
 	"Missing field name and/or value",
 	"Meaningless filter expression",
 	"Only 'ip' field is supported for function trace",
+	"Illegal use of '!'",
 };
 
 struct opstack_op {
@@ -139,6 +143,7 @@ struct pred_stack {
 	int			index;
 };
 
+/* If not of not match is equal to not of not, then it is a match */
 #define DEFINE_COMPARISON_PRED(type)					\
 static int filter_pred_##type(struct filter_pred *pred, void *event)	\
 {									\
@@ -166,7 +171,7 @@ static int filter_pred_##type(struct filter_pred *pred, void *event)	\
 		break;							\
 	}								\
 									\
-	return match;							\
+	return !!match == !pred->not;					\
 }
 
 #define DEFINE_EQUALITY_PRED(size)					\
@@ -1028,7 +1033,7 @@ static int init_pred(struct filter_parse_state *ps,
 	}
 
 	if (pred->op == OP_NE)
-		pred->not = 1;
+		pred->not ^= 1;
 
 	pred->fn = fn;
 	return 0;
@@ -1590,6 +1595,17 @@ static int replace_preds(struct ftrace_event_call *call,
 			continue;
 		}
 
+		if (elt->op == OP_NOT) {
+			if (!n_preds || operand1 || operand2) {
+				parse_error(ps, FILT_ERR_ILLEGAL_NOT_OP, 0);
+				err = -EINVAL;
+				goto fail;
+			}
+			if (!dry_run)
+				filter->preds[n_preds - 1].not ^= 1;
+			continue;
+		}
+
 		if (WARN_ON(n_preds++ == MAX_FILTER_PRED)) {
 			parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
 			err = -ENOSPC;
-- 
2.1.3


