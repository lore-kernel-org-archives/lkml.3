Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab3JGSpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:45:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab3JGSpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:45:30 -0400
Message-ID: <5253013D.4090402@redhat.com>
Date: Mon, 07 Oct 2013 14:45:17 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 29/63] sched: Set preferred NUMA node based on number
 of private faults
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-30-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-30-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:29 AM, Mel Gorman wrote:
> Ideally it would be possible to distinguish between NUMA hinting faults that
> are private to a task and those that are shared. If treated identically
> there is a risk that shared pages bounce between nodes depending on
> the order they are referenced by tasks. Ultimately what is desirable is
> that task private pages remain local to the task while shared pages are
> interleaved between sharing tasks running on different nodes to give good
> average performance. This is further complicated by THP as even
> applications that partition their data may not be partitioning on a huge
> page boundary.
> 
> To start with, this patch assumes that multi-threaded or multi-process
> applications partition their data and that in general the private accesses
> are more important for cpu->memory locality in the general case. Also,
> no new infrastructure is required to treat private pages properly but
> interleaving for shared pages requires additional infrastructure.
> 
> To detect private accesses the pid of the last accessing task is required
> but the storage requirements are a high. This patch borrows heavily from
> Ingo Molnar's patch "numa, mm, sched: Implement last-CPU+PID hash tracking"
> to encode some bits from the last accessing task in the page flags as
> well as the node information. Collisions will occur but it is better than
> just depending on the node information. Node information is then used to
> determine if a page needs to migrate. The PID information is used to detect
> private/shared accesses. The preferred NUMA node is selected based on where
> the maximum number of approximately private faults were measured. Shared
> faults are not taken into consideration for a few reasons.
> 
> First, if there are many tasks sharing the page then they'll all move
> towards the same node. The node will be compute overloaded and then
> scheduled away later only to bounce back again. Alternatively the shared
> tasks would just bounce around nodes because the fault information is
> effectively noise. Either way accounting for shared faults the same as
> private faults can result in lower performance overall.
> 
> The second reason is based on a hypothetical workload that has a small
> number of very important, heavily accessed private pages but a large shared
> array. The shared array would dominate the number of faults and be selected
> as a preferred node even though it's the wrong decision.
> 
> The third reason is that multiple threads in a process will race each
> other to fault the shared page making the fault information unreliable.
> 
> [riel@redhat.com: Fix complication error when !NUMA_BALANCING]
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
