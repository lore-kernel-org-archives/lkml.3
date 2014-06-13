Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaFMU3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:29:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbaFMU3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:29:52 -0400
Message-ID: <539B5F1F.8000105@redhat.com>
Date: Fri, 13 Jun 2014 16:29:19 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, Karen Noel <knoel@redhat.com>,
        Hai Huang <hhuang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>
Subject: NUMA: untangling workloads on undersubscribed systems
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am still running into a long-standing system with the NUMA code, and
I am out of obvious ideas on how to fix it...

The scenario:
- a larger NUMA system, in this case an 8 core system with 8
  15-core/32-thread CPUs (ns->capacity == 18)
- 8 16-warehouse SPECjbb2005 instances
- two SPECjbb2005 instances getting stuck largely on the same node

er-node process memory usage (in MBs)
PID                        Node 0          Node 1          Node 2	   Node 3
        Node 4          Node 5          Node 6          Node 7
 Total
----------------  --------------- --------------- ---------------
--------------- -
-------------- --------------- --------------- ---------------
---------------
42765 (java)                16.90          580.37            6.95
     5.44       2632.76            1.88            7.12            3.46
        3254.89
42761 (java)                 8.72           23.09           46.19
    12.64       3126.64           14.61            2.96            3.76
        3238.60


The latter process is nicely concentrated on node 5. The first process
merely has most of its memory on node 5, but a good amount on node 1
as well.

The total number of threads that would like to run on node 5 is 32,
which exceeds both the number of threads node 5 has (30), as well as
ns->capacity for the node (18).

Node 1 is mostly idle, with about 4 of the task's 16 threads.
Numatop reports around a .4-.5 ratio of remote to local memory
accesses.

The question is, how do we decide to move more tasks from node 5 to
node 1, especially ones that have a decent group/task_score elsewhere?

We can detect some things:
1) ns->nr_running > ns->capacity on node 5
2) ns->nr_running < ns->capacity on node 1
3) ns->load on node 5 >> ns->load on node 1
4) group/task_score on node 5 >> group/task_score on node 1

A few quick things I can see is:

Node 5 is overloaded by a ratio of (16+14)/18, or about 1.7

Node 5 has about a 4.5x higher group/task_score than node 1

Node 5 has about a 7.5x higher load than node 1

Maybe task_numa_compare can take the load into account not just
to prohibit moves between nodes, but to actively encourage it when
the load difference significantly outweighs the difference in NUMA
score between nodes?

Would it make sense to compare these things?

score(node5)    score(node1)
------------ vs ------------
load(node5)     load(node1)

Maybe only if one node is overloaded?

Do you guys have any other ideas?




