Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaJMHRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:17:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbaJMHRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:17:40 -0400
Message-ID: <543B7C6C.3030309@redhat.com>
Date: Mon, 13 Oct 2014 03:17:00 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mgorman@suse.de, chegu_vinod@hp.com,
        mingo@kernel.org, efault@gmx.de, vincent.guittot@linaro.org
Subject: Re: [PATCH RFC 5/5] sched,numa: find the preferred nid with complex
 NUMA topology
References: <1412797050-8903-1-git-send-email-riel@redhat.com> <1412797050-8903-6-git-send-email-riel@redhat.com> <20141012145623.GI3015@worktop>
In-Reply-To: <20141012145623.GI3015@worktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2014 10:56 AM, Peter Zijlstra wrote:
> On Wed, Oct 08, 2014 at 03:37:30PM -0400, riel@redhat.com wrote:
>> +static int preferred_group_nid(struct task_struct *p, int nid)
>> +{
>> +	nodemask_t nodes;
>> +	int hops;
>> +
>> +	/* Direct connections between all NUMA nodes. */
>> +	if (sched_numa_topology_type == NUMA_DIRECT)
>> +		return nid;
>> +
>> +	/*
>> +	 * On a system with glueless mesh NUMA topology, group_weight
>> +	 * scores nodes according to the number of NUMA hinting faults on
>> +	 * both the node itself, and on nearby nodes.
>> +	 */
>> +	if (sched_numa_topology_type == NUMA_GLUELESS_MESH) {
>> +		unsigned long score, max_score = 0;
>> +		int node, max_node = nid;
>> +
>> +		hops = sched_domains_numa_levels;
>> +
>> +		for_each_online_node(node) {
>> +			score = group_weight(p, node, hops);
>> +			if (score > max_score) {
>> +				max_score = score;
>> +				max_node = node;
>> +			}
>> +		}
>> +		return max_node;
>> +	}
>
> This too is O(nr_nodes^2), right?
>
It is, but I suspect the glueless mesh topologies are
never larger than on the order of a dozen nodes or so.

Would you prefer me to make the optimization I proposed
in the other email, or should I just add in a comment
stating that that optimization could be made if it turns
out to be necessary?
