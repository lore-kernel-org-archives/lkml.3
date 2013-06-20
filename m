Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965058Ab3FTDgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:36:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26835 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965027Ab3FTDgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:36:43 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Pk-EZGx7BVEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=VOUmjDad-IQA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=-ZOzeitVOd1rROuh1jsA:9 a=lSinr4eg3GwA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=57enSLdNeJTTivMF:21 a=fCpgS3oLjpCBBvHJ:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130620033640.383727161@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Jun 2013 23:35:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>
Subject: [for-next][PATCH 12/12] ftrace: Fix stddev calculation in function profiler
References: <20130620033516.003166252@goodmis.org>
Content-Disposition: inline; filename=0012-ftrace-Fix-stddev-calculation-in-function-profiler.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juri Lelli <juri.lelli@gmail.com>

When FUNCTION_GRAPH_TRACER is enabled, ftrace can profile kernel functions
and print basic statistics about them. Unfortunately, running stddev
calculation is wrong. This patch corrects it implementing Welford’s method:

        s^2 = 1 / (n * (n-1)) * (n * \Sum (x_i)^2 - (\Sum x_i)^2) .
Link: http://lkml.kernel.org/r/1371031398-24048-1-git-send-email-juri.lelli@gmail.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 800a8a2..26e1910 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -641,12 +641,18 @@ static int function_stat_show(struct seq_file *m, void *v)
 	if (rec->counter <= 1)
 		stddev = 0;
 	else {
-		stddev = rec->time_squared - rec->counter * avg * avg;
+		/*
+		 * Apply Welford's method:
+		 * s^2 = 1 / (n * (n-1)) * (n * \Sum (x_i)^2 - (\Sum x_i)^2)
+		 */
+		stddev = rec->counter * rec->time_squared -
+			 rec->time * rec->time;
+
 		/*
 		 * Divide only 1000 for ns^2 -> us^2 conversion.
 		 * trace_print_graph_duration will divide 1000 again.
 		 */
-		do_div(stddev, (rec->counter - 1) * 1000);
+		do_div(stddev, rec->counter * (rec->counter - 1) * 1000);
 	}
 
 	trace_seq_init(&s);
-- 
1.7.10.4


