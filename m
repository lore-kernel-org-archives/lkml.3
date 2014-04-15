Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaDONzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:55:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54998 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaDONzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:55:01 -0400
Date: Tue, 15 Apr 2014 15:54:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] perf sched: Add trace event for sched wait.
Message-ID: <20140415135447.GW11096@twins.programming.kicks-ass.net>
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 09:32:49PM +0900, Dongsheng Yang wrote:
> Hi all:
> 	This is to solve the bug message shown in perf sched latency.
> 
> 	# perf sched latency|tail
> 	  ksoftirqd/0:3         |      0.597 ms |       57 | avg:    0.004 ms | max:    0.054 ms | max at: 19681.546204 s
> 	  ksoftirqd/1:14        |      0.637 ms |       58 | avg:    0.004 ms | max:    0.066 ms | max at: 19674.687734 s
> 	  irqbalance:349        |      0.429 ms |        1 | avg:    0.004 ms | max:    0.004 ms | max at: 19675.791528 s
> 	  ksoftirqd/3:24        |      0.527 ms |       67 | avg:    0.003 ms | max:    0.011 ms | max at: 19673.285019 s
> 	  migration/3:23        |      0.000 ms |        1 | avg:    0.002 ms | max:    0.002 ms | max at: 19672.055354 s
> 	 -----------------------------------------------------------------------------------------
> 	  TOTAL:                |   4384.616 ms |    36879 |
> 	 ---------------------------------------------------
> 	  INFO: 0.030% state machine bugs (11 out of 36684)
> 
> 	After some investigation, there are two reasons cause this problem.
> 
> 	(1). Sometimes, scheduler will wake up a running task, it is not necessary,
> 	     then I skip the wakeup if task->state is TASK_RUNNING. [4/8]
> 
> 	(2). No tracing for sched wait.
> 	This is a simple graph for task state changing.
> 
> 	----------------		1		----------------
> 	| TASK_RUNNING | ------------------------------>| TASK_RUNNING |
> 	|   (running)  |<------------------------------ |  (wait cpu)  |
> 	----------------		2		----------------
> 		^						|
> 		|4	-------------------------	3	|
> 		|-------|TASK_{UN}INTERRUPTABLE	|<--------------|
> 			|	in wait_rq	|
> 			-------------------------
> 
> 	As the graph shown above, there are four event in scheduling, and
> we currently are tracing 3 of them.
> 
> 	1 & 2: sched:sched_switch
> 	    4: sched:sched_wakeup|sched:sched_wakeup_new
> 
> But about 3, we have no trace event for it.

We do, sched_switch() includes the previous task state. Also there's
tons more than a waitqueue you can get stuck in.
