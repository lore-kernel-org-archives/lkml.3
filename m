Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965149Ab3FTDiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:38:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26835 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935744Ab3FTDgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:36:42 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=OStcs1rdcB0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Xs9eAzAnx_cA:10 a=VwQbUJbxAAAA:8 a=Q-fNiiVtAAAA:8 a=QOj0cCulifUiEa5uvbMA:9 a=jeBq3FmKZ4MA:10 a=lcTMV_K9oDIA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130620033639.723900482@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Jun 2013 23:35:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arend van Spriel <arend@broadcom.com>
Subject: [for-next][PATCH 08/12] tracing: Add binary & filter for events
References: <20130620033516.003166252@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-Add-binary-filter-for-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

There are some cases when filtering on a set flag of a field of a tracepoint
is useful. But currently the only filtering commands for numbered fields
is ==, !=, <, <=, >, >=. This does not help when you just want to trace if
a specific flag is set. For example:

 > # sudo trace-cmd record -e brcmfmac:brcmf_dbg -f 'level & 0x40000'
 > disable all
 > enable brcmfmac:brcmf_dbg
 > path = /sys/kernel/debug/tracing/events/brcmfmac/brcmf_dbg/enable
 > (level & 0x40000)
 > ^
 > parse_error: Invalid operator
 >

When trying to trace brcmf_dbg when level has its 1 << 18 bit set, the
filter fails to perform.

By allowing a binary '&' operation, this gives the user the ability to
test a bit.

Note, a binary '|' is not added, as it doesn't make sense as fields must
be compared to constants (for now), and ORing a constant will always return
true.

Link: http://lkml.kernel.org/r/1371057385.9844.261.camel@gandalf.local.home

Suggested-by: Arend van Spriel <arend@broadcom.com>
Tested-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/events.txt     |    2 +-
 kernel/trace/trace_events_filter.c |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index bb24c2a..4191124 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -183,7 +183,7 @@ The relational-operators depend on the type of the field being tested:
 
 The operators available for numeric fields are:
 
-==, !=, <, <=, >, >=
+==, !=, <, <=, >, >=, &
 
 And for string fields they are:
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index e1b653f..0d883dc 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -44,6 +44,7 @@ enum filter_op_ids
 	OP_LE,
 	OP_GT,
 	OP_GE,
+	OP_BAND,
 	OP_NONE,
 	OP_OPEN_PAREN,
 };
@@ -54,6 +55,7 @@ struct filter_op {
 	int precedence;
 };
 
+/* Order must be the same as enum filter_op_ids above */
 static struct filter_op filter_ops[] = {
 	{ OP_OR,	"||",		1 },
 	{ OP_AND,	"&&",		2 },
@@ -64,6 +66,7 @@ static struct filter_op filter_ops[] = {
 	{ OP_LE,	"<=",		5 },
 	{ OP_GT,	">",		5 },
 	{ OP_GE,	">=",		5 },
+	{ OP_BAND,	"&",		6 },
 	{ OP_NONE,	"OP_NONE",	0 },
 	{ OP_OPEN_PAREN, "(",		0 },
 };
@@ -156,6 +159,9 @@ static int filter_pred_##type(struct filter_pred *pred, void *event)	\
 	case OP_GE:							\
 		match = (*addr >= val);					\
 		break;							\
+	case OP_BAND:							\
+		match = (*addr & val);					\
+		break;							\
 	default:							\
 		break;							\
 	}								\
-- 
1.7.10.4


