Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaLBREf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:04:35 -0500
Received: from smtprelay0164.hostedemail.com ([216.40.44.164]:53612 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750831AbaLBREd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:04:33 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:800:960:967:973:988:989:1183:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2859:2898:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3871:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6261:8599:8603:8660:9025:10004:10400:10848:10913:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12679:12696:12737:12783:13138:13148:13180:13229:13230:13231:13846:14394:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: geese44_7ee2d3811c94c
X-Filterd-Recvd-Size: 3017
Date: Tue, 2 Dec 2014 12:04:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Alexei Starovoitov <ast@plumgrid.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] tracing: Add NOT to filtering logic
Message-ID: <20141202120430.71979060@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

Suggested-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 7a8c1528e141..9ddbf0c05340 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -37,6 +37,7 @@ enum filter_op_ids
 {
 	OP_OR,
 	OP_AND,
+	OP_NOT,
 	OP_GLOB,
 	OP_NE,
 	OP_EQ,
@@ -59,6 +60,7 @@ struct filter_op {
 static struct filter_op filter_ops[] = {
 	{ OP_OR,	"||",		1 },
 	{ OP_AND,	"&&",		2 },
+	{ OP_NOT,	"!",		3 },
 	{ OP_GLOB,	"~",		4 },
 	{ OP_NE,	"!=",		4 },
 	{ OP_EQ,	"==",		4 },
@@ -166,7 +168,7 @@ static int filter_pred_##type(struct filter_pred *pred, void *event)	\
 		break;							\
 	}								\
 									\
-	return match;							\
+	return match == !pred->not;					\
 }
 
 #define DEFINE_EQUALITY_PRED(size)					\
@@ -1028,7 +1030,7 @@ static int init_pred(struct filter_parse_state *ps,
 	}
 
 	if (pred->op == OP_NE)
-		pred->not = 1;
+		pred->not ^= 1;
 
 	pred->fn = fn;
 	return 0;
@@ -1590,6 +1592,16 @@ static int replace_preds(struct ftrace_event_call *call,
 			continue;
 		}
 
+		if (elt->op == OP_NOT) {
+			if (!n_preds) {
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
1.8.1.4

