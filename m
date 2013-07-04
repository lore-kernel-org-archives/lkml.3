Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab3GDNIC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:08:02 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59149 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab3GDNH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:07:59 -0400
Date: Thu, 4 Jul 2013 18:37:19 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/13] sched: Account for the number of preferred tasks
 running on a node when selecting a preferred node
Message-ID: <20130704130719.GC29916@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1372861300-9973-1-git-send-email-mgorman@suse.de>
 <1372861300-9973-14-git-send-email-mgorman@suse.de>
 <20130703183243.GB18898@dyad.programming.kicks-ass.net>
 <20130704093716.GO1875@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130704093716.GO1875@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
x-cbid: 13070413-5806-0000-0000-000021F803B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static void task_numa_placement(struct task_struct *p)
>  {
>  	int seq, nid, max_nid = 0;
> @@ -897,7 +924,7 @@ static void task_numa_placement(struct task_struct *p)
> 
>  		/* Find maximum private faults */
>  		faults = p->numa_faults[task_faults_idx(nid, 1)];
> -		if (faults > max_faults) {
> +		if (faults > max_faults && !sched_numa_overloaded(nid)) {

Should we take the other approach of setting the preferred nid but not 
moving the task to the node?

So if some task moves out of the preferred node, then we should still be
able to move this task there. 

However your current approach has an advantage that it atleast runs on
second preferred choice if not the first.

Also should sched_numa_overloaded() also consider pinned tasks?

>  			max_faults = faults;
>  			max_nid = nid;
>  		}
> @@ -923,9 +950,7 @@ static void task_numa_placement(struct task_struct *p)
>  							     max_nid);
>  		}
> 
> -		/* Update the preferred nid and migrate task if possible */
> -		p->numa_preferred_nid = max_nid;
> -		p->numa_migrate_seq = 0;
> +		sched_setnuma(p, max_nid, preferred_cpu);
>  		migrate_task_to(p, preferred_cpu);
> 
>  		/*

