Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab3FKJJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 05:09:55 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47101 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3FKJJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 05:09:52 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, juri.lelli@gmail.com
Subject: [PATCH 3/3] ftrace: fix stddev calculation
Date: Tue, 11 Jun 2013 11:08:48 +0200
Message-Id: <1370941728-15456-4-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370941728-15456-1-git-send-email-juri.lelli@gmail.com>
References: <1370941728-15456-1-git-send-email-juri.lelli@gmail.com>
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
 kernel/trace/ftrace.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6caaa0e..073a328 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -593,13 +593,17 @@ void function_stat_calc(struct ftrace_profile *rec,
 	if (rec->counter <= 1)
 		*stddev = 0;
 	else {
-		*stddev = rec->time_squared - rec->counter * (*avg) * (*avg);
+		/*
+		 * Apply Welford's method.
+		 */
+		*stddev = rec->counter * rec->time_squared -
+			  rec->time * rec->time;
 
 		/*
 		 * Divide only 1000 for ns^2 -> us^2 conversion.
 		 * trace_print_graph_duration will divide 1000 again.
 		 */
-		do_div(*stddev, (rec->counter - 1) * 1000);
+		do_div(*stddev, rec->counter * (rec->counter - 1) * 1000);
 	}
 }
 
-- 
1.7.9.5

