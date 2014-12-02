Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaLBEv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 23:51:27 -0500
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:36800 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752714AbaLBEv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 23:51:26 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2898:3138:3139:3140:3141:3142:3354:3622:3866:3867:3868:3871:3872:3874:4250:5007:6261:7875:7904:8603:8660:9040:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12050:12296:12438:12517:12519:12555:12740:13148:13180:13229:13230:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sound20_80bed8f659322
X-Filterd-Recvd-Size: 3658
Date: Mon, 1 Dec 2014 23:51:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Checking to see if a bit is _not_ set in a ftrace event filter
Message-ID: <20141201235123.10954e42@gandalf.local.home>
In-Reply-To: <20141201225725.1e94aa66@gandalf.local.home>
References: <20141202021912.GA29096@thunk.org>
	<20141201214104.32d3f10d@gandalf.local.home>
	<CAMEtUuzEg39N9ZALuq-u4X+oaNJGqL6G05UABSHYpejQ78Cp3Q@mail.gmail.com>
	<20141201225725.1e94aa66@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014 22:57:25 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 1 Dec 2014 19:52:11 -0800
> Alexei Starovoitov <ast@plumgrid.com> wrote:
> 
> > yeah. teaching tree walk to do (state & 2048) == 0 is not trivial,
> > since it doesn't have a concept of value of expression.
> > Doing !(state & 2048) is probably a bit easier, since there
> > are hacks for 'not' already.
> 
> That's exactly what I was looking at doing. If I can get something
> working without spending more than an hour or two, I may even push it
> for this release cycle.

Actually, this was rather trivial. It took me longer because I was
doing this half asleep, but it seems to work.

Note, this is a major beta patch. It probably doesn't work with ANDS
and ORS, that is !(x == 1 && y == 2) probably doesn't work, but this
should: !(x == 1), and so should !(state & 2048).

I'll clean this up and get it ready for 3.19.

Cheers!

-- Steve

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 7a8c1528e141..aee7b743c9df 100644
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
@@ -565,7 +567,7 @@ int filter_match_preds(struct event_filter *filter, void *rec)
 	data.preds = preds = rcu_dereference_sched(filter->preds);
 	ret = walk_pred_tree(preds, root, filter_match_preds_cb, &data);
 	WARN_ON(ret);
-	return data.match;
+	return !!data.match;
 }
 EXPORT_SYMBOL_GPL(filter_match_preds);
 
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
