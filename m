Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaDONct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:32:49 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:61961 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750930AbaDONcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:32:48 -0400
X-IronPort-AV: E=Sophos;i="4.97,863,1389715200"; 
   d="scan'208";a="29292482"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>,
        <peterz@infradead.org>, <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 0/8] perf sched: Add trace event for sched wait.
Date: Tue, 15 Apr 2014 21:32:49 +0900
Message-ID: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:
	This is to solve the bug message shown in perf sched latency.

	# perf sched latency|tail
	  ksoftirqd/0:3         |      0.597 ms |       57 | avg:    0.004 ms | max:    0.054 ms | max at: 19681.546204 s
	  ksoftirqd/1:14        |      0.637 ms |       58 | avg:    0.004 ms | max:    0.066 ms | max at: 19674.687734 s
	  irqbalance:349        |      0.429 ms |        1 | avg:    0.004 ms | max:    0.004 ms | max at: 19675.791528 s
	  ksoftirqd/3:24        |      0.527 ms |       67 | avg:    0.003 ms | max:    0.011 ms | max at: 19673.285019 s
	  migration/3:23        |      0.000 ms |        1 | avg:    0.002 ms | max:    0.002 ms | max at: 19672.055354 s
	 -----------------------------------------------------------------------------------------
	  TOTAL:                |   4384.616 ms |    36879 |
	 ---------------------------------------------------
	  INFO: 0.030% state machine bugs (11 out of 36684)

	After some investigation, there are two reasons cause this problem.

	(1). Sometimes, scheduler will wake up a running task, it is not necessary,
	     then I skip the wakeup if task->state is TASK_RUNNING. [4/8]

	(2). No tracing for sched wait.
	This is a simple graph for task state changing.

	----------------		1		----------------
	| TASK_RUNNING | ------------------------------>| TASK_RUNNING |
	|   (running)  |<------------------------------ |  (wait cpu)  |
	----------------		2		----------------
		^						|
		|4	-------------------------	3	|
		|-------|TASK_{UN}INTERRUPTABLE	|<--------------|
			|	in wait_rq	|
			-------------------------

	As the graph shown above, there are four event in scheduling, and
we currently are tracing 3 of them.

	1 & 2: sched:sched_switch
	    4: sched:sched_wakeup|sched:sched_wakeup_new

But about 3, we have no trace event for it.

This patchset add a new trace event for sched wait, and add a trace point
before any task added into wait queue. [1/8] & [3/8]

	BTW, other patchs in this thread are about some little fix and enhancement
in the development, please help to review at the same time. 

Thanx

Dongsheng (8):
  sched & trace: Add a trace event for wait.
  sched/wait: Add trace point before add task into wait queue.
  sched/wait: Use __add_wait_queue{_tail}_exclusive() as possible.
  sched/core: Skip wakeup when task is already running.
  perf tools: record and process sched:sched_wait event.
  perf tools: add missing event for perf sched record.
  perf tools: Adapt the TASK_STATE_TO_CHAR_STR to new value in kernel
    space.
  perf tools: Clarify the output of perf sched map.

 include/trace/events/sched.h |  20 +++++++++
 kernel/sched/core.c          |   3 ++
 kernel/sched/wait.c          |  13 ++++--
 tools/perf/builtin-sched.c   | 100 +++++++++++++++++++++++++++++++++++--------
 4 files changed, 115 insertions(+), 21 deletions(-)

-- 
1.8.2.1

