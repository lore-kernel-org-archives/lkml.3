Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaATTjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:39:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaATTjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:39:20 -0500
Message-ID: <52DD7129.3040106@redhat.com>
Date: Mon, 20 Jan 2014 13:55:37 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, chegu_vinod@hp.com,
        mgorman@suse.de, mingo@redhat.com
Subject: Re: [PATCH 3/7] numa,sched: build per numa_group active node mask
 from faults_from statistics
References: <1389993129-28180-1-git-send-email-riel@redhat.com> <1389993129-28180-4-git-send-email-riel@redhat.com> <20140120163103.GI31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140120163103.GI31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2014 11:31 AM, Peter Zijlstra wrote:
> On Fri, Jan 17, 2014 at 04:12:05PM -0500, riel@redhat.com wrote:
>>  /*
>> + * Iterate over the nodes from which NUMA hinting faults were triggered, in
>> + * other words where the CPUs that incurred NUMA hinting faults are. The
>> + * bitmask is used to limit NUMA page migrations, and spread out memory
>> + * between the actively used nodes. To prevent flip-flopping, and excessive
>> + * page migrations, nodes are added when they cause over 40% of the maximum
>> + * number of faults, but only removed when they drop below 20%.
>> + */
>> +static void update_numa_active_node_mask(struct task_struct *p)
>> +{
>> +	unsigned long faults, max_faults = 0;
>> +	struct numa_group *numa_group = p->numa_group;
>> +	int nid;
>> +
>> +	for_each_online_node(nid) {
>> +		faults = numa_group->faults_from[task_faults_idx(nid, 0)] +
>> +			 numa_group->faults_from[task_faults_idx(nid, 1)];
>> +		if (faults > max_faults)
>> +			max_faults = faults;
>> +	}
>> +
>> +	for_each_online_node(nid) {
>> +		faults = numa_group->faults_from[task_faults_idx(nid, 0)] +
>> +			 numa_group->faults_from[task_faults_idx(nid, 1)];
>> +		if (!node_isset(nid, numa_group->active_nodes)) {
>> +			if (faults > max_faults * 4 / 10)
>> +				node_set(nid, numa_group->active_nodes);
>> +		} else if (faults < max_faults * 2 / 10)
>> +			node_clear(nid, numa_group->active_nodes);
>> +	}
>> +}
> 
> Why not use 6/16 and 3/16 resp.? That avoids an actual division.

OK, will do.

-- 
All rights reversed
