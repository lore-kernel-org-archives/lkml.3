Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaA0WEC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:04:02 -0500
Received: from shelob.surriel.com ([74.92.59.67]:58564 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbaA0WEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:04:00 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, peterz@infradead.org, mgorman@suse.de,
        mingo@redhat.com, chegu_vinod@hp.com
Subject: [PATCH v5 0/9] numa,sched,mm: pseudo-interleaving for automatic NUMA balancing
Date: Mon, 27 Jan 2014 17:03:39 -0500
Message-Id: <1390860228-21539-1-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current automatic NUMA balancing code base has issues with
workloads that do not fit on one NUMA load. Page migration is
slowed down, but memory distribution between the nodes where
the workload runs is essentially random, often resulting in a
suboptimal amount of memory bandwidth being available to the
workload.

In order to maximize performance of workloads that do not fit in one NUMA
node, we want to satisfy the following criteria:
1) keep private memory local to each thread
2) avoid excessive NUMA migration of pages
3) distribute shared memory across the active nodes, to
   maximize memory bandwidth available to the workload

This patch series identifies the NUMA nodes on which the workload
is actively running, and balances (somewhat lazily) the memory
between those nodes, satisfying the criteria above.

As usual, the series has had some performance testing, but it
could always benefit from more testing, on other systems.

Changes since v4:
 - remove some code that did not help performance
 - implement all the cleanups suggested by Mel Gorman
 - lots more testing, by Chegu Vinod and myself
 - rebase against -tip instead of -next, to make merging easier
Changes since v3:
 - various code cleanups suggested by Mel Gorman (some in their own patches)
 - after some testing, switch back to the NUMA specific CPU use stats,
   since that results in a 1% performance increase for two 8-warehouse
   specjbb instances on a 4-node system, and reduced page migration across
   the board
Changes since v2:
 - dropped tracepoint (for now?)
 - implement obvious improvements suggested by Peter
 - use the scheduler maintained CPU use statistics, drop
   the NUMA specific ones for now. We can add those later
   if they turn out to be beneficial
Changes since v1:
 - fix divide by zero found by Chegu Vinod
 - improve comment, as suggested by Peter Zijlstra
 - do stats calculations in task_numa_placement in local variables


Some performance numbers, with two 40-warehouse specjbb instances
on an 8 node system with 10 CPU cores per node, using a pre-cleanup
version of these patches, courtesy of Chegu Vinod:

numactl manual pinning
spec1.txt:           throughput =     755900.20 SPECjbb2005 bops
spec2.txt:           throughput =     754914.40 SPECjbb2005 bops

NO-pinning results (Automatic NUMA balancing, with patches)
spec1.txt:           throughput =     706439.84 SPECjbb2005 bops
spec2.txt:           throughput =     729347.75 SPECjbb2005 bops

NO-pinning results (Automatic NUMA balancing, without patches)
spec1.txt:           throughput =     667988.47 SPECjbb2005 bops
spec2.txt:           throughput =     638220.45 SPECjbb2005 bops

No Automatic NUMA and NO-pinning results
spec1.txt:           throughput =     544120.97 SPECjbb2005 bops
spec2.txt:           throughput =     453553.41 SPECjbb2005 bops

