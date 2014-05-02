Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaEBTND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:13:03 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:52446 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbaEBTNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:13:00 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>
CC: "linux-kernel (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] ftrace function-graph: print the function name on all }
 lines
Thread-Topic: [RFC PATCH] ftrace function-graph: print the function name on
 all } lines
Thread-Index: Ac9mODNtz2lzmTzpTXeVV8s0zTG8Xg==
Date: Fri, 2 May 2014 19:11:11 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402956EE7D16@G9W0745.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using ftrace function-graph to examine the times consumed by
functions, the time shows up on the line where the call is made
if no other traceable functions were called by that function:
 11)   0.672 us    |    cmd_alloc [hpsa]();

but the time shows up down by the } if the were other traceable
functions called by that function:
 11)               |              cmd_alloc [hpsa]() {
 11)   0.129 us    |                cmd_free [hpsa]();
 11)   0.106 us    |                cmd_free [hpsa]();
 11)   2.014 us    |              }

On its own, the } line doesn't indicate which function it is
closing, so grep cannot be used to search for all the times
for this function. You have to write a parser.

The function name does get printed on those lines when the
start of the function is off the trace, so I modified 
trace_functions_graph.c to do that in all cases.

 11)               |    hpsa_scsi_ioaccel_raid_map [hpsa]() {
 11)               |      hpsa_scsi_ioaccel_queue_command [hpsa]() {
 11)               |        hpsa_scsi_ioaccel2_queue_command [hpsa]() {
 11)   0.067 us    |          fixup_ioaccel_cdb [hpsa]();
 11)   0.053 us    |          set_encrypt_ioaccel2 [hpsa]();
 11)   0.199 us    |          enqueue_cmd_and_start_io [hpsa]();
 11)   1.952 us    |        } /* hpsa_scsi_ioaccel2_queue_command [hpsa] */
 11)   2.501 us    |      } /* hpsa_scsi_ioaccel_queue_command [hpsa] */
 11)   3.093 us    |    } /* hpsa_scsi_ioaccel_raid_map [hpsa] */
 11)   4.667 us    |  } /* hpsa_scsi_queue_command [hpsa] */

rather than:
 11)               |    hpsa_scsi_ioaccel_raid_map [hpsa]() {
 11)               |      hpsa_scsi_ioaccel_queue_command [hpsa]() {
 11)               |        hpsa_scsi_ioaccel2_queue_command [hpsa]() {
 11)   0.067 us    |          fixup_ioaccel_cdb [hpsa]();
 11)   0.053 us    |          set_encrypt_ioaccel2 [hpsa]();
 11)   0.199 us    |          enqueue_cmd_and_start_io [hpsa]();
 11)   1.952 us    |        }
 11)   2.501 us    |      }
 11)   3.093 us    |    }
 11)   4.667 us    |  }

Is this a change you would be interested in taking, or
do you think that makes the output too cluttered?

A potential patch (based on kernel-3.14) is:

From: Robert Elliott <elliott@hp.com>

In the function-graph tracer, print the function name on
all } lines, not just functions whose first line is no
longer in the trace buffer.

If a function calls other traced functions, its total
time appears on its } line.  This change allows grep
to be used to determine the function for which the
line corresponds.

Signed-off-by: Robert Elliott <elliott@hp.com>
---
 kernel/trace/trace_functions_graph.c |   24 ++++++------------------
 1 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 0b99120..d530a61 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1130,7 +1130,6 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	struct fgraph_data *data = iter->private;
 	pid_t pid = ent->pid;
 	int cpu = iter->cpu;
-	int func_match = 1;
 	int ret;
 	int i;
 
@@ -1150,11 +1149,8 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 		 */
 		cpu_data->depth = trace->depth - 1;
 
-		if (trace->depth < FTRACE_RETFUNC_DEPTH) {
-			if (cpu_data->enter_funcs[trace->depth] != trace->func)
-				func_match = 0;
+		if (trace->depth < FTRACE_RETFUNC_DEPTH)
 			cpu_data->enter_funcs[trace->depth] = 0;
-		}
 	}
 
 	if (print_graph_prologue(iter, s, 0, 0, flags))
@@ -1173,20 +1169,12 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	}
 
 	/*
-	 * If the return function does not have a matching entry,
-	 * then the entry was lost. Instead of just printing
-	 * the '}' and letting the user guess what function this
-	 * belongs to, write out the function name.
+	 * Write out the function name if the return
+	 * function has or does not have a matching entry.
 	 */
-	if (func_match) {
-		ret = trace_seq_puts(s, "}\n");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	} else {
-		ret = trace_seq_printf(s, "} /* %ps */\n", (void *)trace->func);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	ret = trace_seq_printf(s, "} /* %ps */\n", (void *)trace->func);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Overrun */
 	if (flags & TRACE_GRAPH_PRINT_OVERRUN) {


---
Rob Elliott    HP Server Storage


