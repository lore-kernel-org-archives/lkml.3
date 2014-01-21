Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbaAUW1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:27:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbaAUW1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:27:07 -0500
Message-ID: <52DEF41F.1040105@redhat.com>
Date: Tue, 21 Jan 2014 17:26:39 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        mingo@redhat.com, chegu_vinod@hp.com
Subject: Re: [PATCH 2/6] numa,sched: track from which nodes NUMA faults are
 triggered
References: <1390245667-24193-1-git-send-email-riel@redhat.com> <1390245667-24193-3-git-send-email-riel@redhat.com> <20140121122130.GG4963@suse.de>
In-Reply-To: <20140121122130.GG4963@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 07:21 AM, Mel Gorman wrote:
> On Mon, Jan 20, 2014 at 02:21:03PM -0500, riel@redhat.com wrote:

>> +++ b/include/linux/sched.h
>> @@ -1492,6 +1492,14 @@ struct task_struct {
>>  	unsigned long *numa_faults_buffer;
>>  
>>  	/*
>> +	 * Track the nodes where faults are incurred. This is not very
>> +	 * interesting on a per-task basis, but it help with smarter
>> +	 * numa memory placement for groups of processes.
>> +	 */
>> +	unsigned long *numa_faults_from;
>> +	unsigned long *numa_faults_from_buffer;
>> +
> 
> As an aside I wonder if we can derive any useful metric from this

It may provide for a better way to tune the numa scan interval
than the current code, since the "local vs remote" ratio is not
going to provide us much useful info when dealing with a workload
that is spread across multiple numa nodes.

>>  		grp->total_faults = p->total_numa_faults;
>> @@ -1526,7 +1536,7 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
>>  
>>  	double_lock(&my_grp->lock, &grp->lock);
>>  
>> -	for (i = 0; i < 2*nr_node_ids; i++) {
>> +	for (i = 0; i < 4*nr_node_ids; i++) {
>>  		my_grp->faults[i] -= p->numa_faults[i];
>>  		grp->faults[i] += p->numa_faults[i];
>>  	}
> 
> The same obscure trick is used throughout and I'm not sure how
> maintainable that will be. Would it be better to be explicit about this?

I have made a cleanup patch for this, using the defines you
suggested.

>> @@ -1634,6 +1649,7 @@ void task_numa_fault(int last_cpupid, int node, int pages, int flags)
>>  		p->numa_pages_migrated += pages;
>>  
>>  	p->numa_faults_buffer[task_faults_idx(node, priv)] += pages;
>> +	p->numa_faults_from_buffer[task_faults_idx(this_node, priv)] += pages;
>>  	p->numa_faults_locality[!!(flags & TNF_FAULT_LOCAL)] += pages;
> 
> this_node and node is similarly ambiguous in terms of name. Rename of
> data_node and cpu_node would have been clearer.

I added a patch in the next version of the series.

Don't want to make the series too large, though :)

-- 
All rights reversed
