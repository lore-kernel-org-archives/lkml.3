Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaELWTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 18:19:35 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:8982 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaELWTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 18:19:34 -0400
Subject: [PATCH 0/2] ftrace: Add funcgraph_tail option
To: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
From: Robert Elliott <elliott@hp.com>
Date: Mon, 12 May 2014 17:18:30 -0500
Message-ID: <20140512221729.14555.57686.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
start of the function is off the trace.

This patch series adds a funcgraph-tail option to do that
in all cases.

echo 1 > /sys/kernel/debug/tracing/options/funcgraph-tail
or
echo funcgraph-tail > /sys/kernel/debug/tracing/trace_options
yields:
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

echo 0 > /sys/kernel/debug/tracing/options/funcgraph-tail
or
echo nofuncgraph-tail > /sys/kernel/debug/tracing/trace_options
(which is the default setting) still yields:
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


---

Robert Elliott (2):
      Eliminate duplicate TRACE_GRAPH_PRINT_xx defines
      In the function-graph tracer, add a funcgraph_tail option


 Documentation/trace/ftrace.txt       |   26 ++++++++++++++++++++++++++
 kernel/trace/trace.h                 |    2 ++
 kernel/trace/trace_functions_graph.c |   18 ++++++------------
 3 files changed, 34 insertions(+), 12 deletions(-)

--
Rob Elliott   HP Server Storage
