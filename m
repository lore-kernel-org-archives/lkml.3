Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab3FLKDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:03:36 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51225 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3FLKDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:03:34 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, juri.lelli@gmail.com
Subject: [PATCH] ftrace: fix stddev calculation
Date: Wed, 12 Jun 2013 12:03:18 +0200
Message-Id: <1371031398-24048-1-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When FUNCTION_GRAPH_TRACER is enabled, ftrace can profile kernel functions
and print basic statistics about them. Unfortunately, running stddev
calculation is wrong. This patch corrects it implementing Welford’s method:

        s^2 = 1 / (n * (n-1)) * (n * \Sum (x_i)^2 - (\Sum x_i)^2) .

Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/ftrace.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6c508ff..6c3fce2 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -622,12 +622,18 @@ static int function_stat_show(struct seq_file *m, void *v)
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
1.7.9.5

