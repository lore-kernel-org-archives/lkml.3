Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaJMHNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:13:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbaJMHNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:13:13 -0400
Message-ID: <543B7B5F.4030708@redhat.com>
Date: Mon, 13 Oct 2014 03:12:31 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mgorman@suse.de, chegu_vinod@hp.com,
        mingo@kernel.org, efault@gmx.de, vincent.guittot@linaro.org
Subject: Re: [PATCH RFC 2/5] sched,numa: classify the NUMA topology of a system
References: <1412797050-8903-1-git-send-email-riel@redhat.com> <1412797050-8903-3-git-send-email-riel@redhat.com> <20141012143056.GF3015@worktop>
In-Reply-To: <20141012143056.GF3015@worktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2014 10:30 AM, Peter Zijlstra wrote:
> On Wed, Oct 08, 2014 at 03:37:27PM -0400, riel@redhat.com wrote:
>> +static void init_numa_topology_type(void)
>> +{
>> +	int a, b, c, n;
>> +
>> +	n = sched_domains_numa_levels;
>> +
>> +	if (n <= 1)
>> +		sched_numa_topology_type = NUMA_DIRECT;
>> +
>> +	for_each_online_node(a) {
>> +		for_each_online_node(b) {
>> +			/* Find two nodes furthest removed from each other. */
>> +			if (node_hops(a, b) < n)
>> +				continue;
>> +
>> +			/* Is there an intermediary node between a and b? */
>> +			for_each_online_node(c) {
>> +				if (node_hops(a, c) < n &&
>> +				    node_hops(b, c) < n) {
>> +					sched_numa_topology_type =
>> +							NUMA_GLUELESS_MESH;
>> +					return;
>> +				}
>> +			}
>> +
>> +			sched_numa_topology_type = NUMA_BACKPLANE;
>> +			return;
>> +		}
>> +	}
>> +}
>
> We can find max_distance nodes in sched_init_numa(), right? Could we not
> avoid this second iteration?
>
It's not about finding the max distance, but about finding
two nodes that are at the maximum distance from each other,
in order to see whether there are intermediate nodes
between the two.

I suppose we could just directly access the node_hops
tables to get two nodes that are the furthest away from
each other, but I suspect that searching that table
directly will not make a significant difference compared
with using the macros above.

Especially since this code is only ever run once at system
bootup.
