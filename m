Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaJWIR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:17:56 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56543 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbaJWIRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:17:49 -0400
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: byungchul.park@lge.com
From: byungchul.park@lge.com
To: rostedt@goodmis.org, mingo@redhat.com
Cc: jolsa@redhat.com, vanilla@blackduck.lge.com, linux-kernel@vger.kernel.org,
        Byungchul Park <byungchul.park@lge.com>
Subject: [PATCH 2/2] tracing, function_graph: add additional marks to signal very large function execution time
Date: Thu, 23 Oct 2014 17:17:22 +0900
Message-Id: <1414052242-9828-3-git-send-email-byungchul.park@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414052242-9828-1-git-send-email-byungchul.park@lge.com>
References: <1414052242-9828-1-git-send-email-byungchul.park@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Byungchul Park <byungchul.park@lge.com>

Currently, function graph tracer prints "!" or "+" just before
function execution time to signal a function overhead, depending
on the time. Even it is usually enough to do that, we sometimes
need to be signaled for bigger execution time than 100 micro seconds.

For example, I used function graph tracer to detect if there is
any case that exit_mm() takes too much time. I did following steps
in /sys/kernel/debug/tracing. It was easier to detect very big
excution time with patched kernel than with original kernel.

$ echo exit_mm > set_graph_function
$ echo function_graph > current_tracer
$ echo > trace
$ cat trace_pipe > $LOGFILE
 ... (do something and terminate logging)
$ grep "!s" $LOGFILE
 3) !s22082032 us |                      } /* kernel_map_pages */
 3) !s22082040 us |                    } /* free_pages_prepare */
 3) !s22082113 us |                  } /* free_hot_cold_page */
 3) !s22083455 us |                } /* free_hot_cold_page_list */
 3) !s22083895 us |              } /* release_pages */
 3) !s22177873 us |            } /* free_pages_and_swap_cache */
 3) !s22178929 us |          } /* unmap_single_vma */
 3) !s22198885 us |        } /* unmap_vmas */
 3) !s22206949 us |      } /* exit_mmap */
 3) !s22207659 us |    } /* mmput */
 3) !s22207793 us |  } /* exit_mm */

And then, it was easy to find out that a schedule-out occured by
sub_preempt_count() within kernel_map_pages().

To detect very large function exection time either by problematic
function implementation or by scheduling issues, this patch can be
useful.

Signed-off-by: Byungchul Park <byungchul.park@lge.com>
---
 kernel/trace/trace_functions_graph.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index c18a1e3..ea8b7e7 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -822,8 +822,14 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
 
 	/* Signal a overhead of time execution to the output */
 	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
+		/* Duration exceeded 1 secs */
+		if (duration > 1000000000ULL)
+			ret = trace_seq_puts(s, "!s");
+		/* Duration exceeded 1 msecs */
+		else if (duration > 1000000ULL)
+			ret = trace_seq_puts(s, "!m");
 		/* Duration exceeded 100 usecs */
-		if (duration > 100000ULL)
+		else if (duration > 100000ULL)
 			ret = trace_seq_puts(s, "! ");
 		/* Duration exceeded 10 usecs */
 		else if (duration > 10000ULL)
-- 
1.7.9.5

