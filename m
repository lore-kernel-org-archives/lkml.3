Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbaA1KBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 05:01:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54584 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595AbaA1KBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 05:01:34 -0500
Date: Tue, 28 Jan 2014 10:01:31 +0000
From: Mel Gorman <mgorman@suse.de>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        mingo@redhat.com, chegu_vinod@hp.com
Subject: Re: [PATCH 6/9] numa,sched: normalize faults_cpu stats and weigh by
 CPU use
Message-ID: <20140128100131.GS4963@suse.de>
References: <1390860228-21539-1-git-send-email-riel@redhat.com>
 <1390860228-21539-7-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1390860228-21539-7-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 05:03:45PM -0500, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> Tracing the code that decides the active nodes has made it abundantly clear
> that the naive implementation of the faults_from code has issues.
> 
> Specifically, the garbage collector in some workloads will access orders
> of magnitudes more memory than the threads that do all the active work.
> This resulted in the node with the garbage collector being marked the only
> active node in the group.
> 
> This issue is avoided if we weigh the statistics by CPU use of each task in
> the numa group, instead of by how many faults each thread has occurred.
> 
> To achieve this, we normalize the number of faults to the fraction of faults
> that occurred on each node, and then multiply that fraction by the fraction
> of CPU time the task has used since the last time task_numa_placement was
> invoked.
> 
> This way the nodes in the active node mask will be the ones where the tasks
> from the numa group are most actively running, and the influence of eg. the
> garbage collector and other do-little threads is properly minimized.
> 
> On a 4 node system, using CPU use statistics calculated over a longer interval
> results in about 1% fewer page migrations with two 32-warehouse specjbb runs
> on a 4 node system, and about 5% fewer page migrations, as well as 1% better
> throughput, with two 8-warehouse specjbb runs, as compared with the shorter
> term statistics kept by the scheduler.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Chegu Vinod <chegu_vinod@hp.com>
> Signed-off-by: Rik van Riel <riel@redhat.com>

Major changes are related to the weight calculations to avoid overflow
and the avg runtime is calculated based on a longer runtime than the v4
version. Both seem sane so

Acked-by: Mel Gorman <mgorman@suse>

-- 
Mel Gorman
SUSE Labs
