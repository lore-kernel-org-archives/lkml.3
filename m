Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaJLOyM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 10:54:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaJLOyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 10:54:11 -0400
Date: Sun, 12 Oct 2014 16:53:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mgorman@suse.de, chegu_vinod@hp.com,
        mingo@kernel.org, efault@gmx.de, vincent.guittot@linaro.org
Subject: Re: [PATCH RFC 4/5] sched,numa: calculate node scores in complex
 NUMA topologies
Message-ID: <20141012145358.GH3015@worktop>
References: <1412797050-8903-1-git-send-email-riel@redhat.com>
 <1412797050-8903-5-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412797050-8903-5-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 03:37:29PM -0400, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> In order to do task placement on systems with complex NUMA topologies,
> it is necessary to count the faults on nodes nearby the node that is
> being examined for a potential move.
> 
> In case of a system with a backplane interconnect, we are dealing with
> groups of NUMA nodes; each of the nodes within a group is the same number
> of hops away from nodes in other groups in the system. Optimal placement
> on this topology is achieved by counting all nearby nodes equally. When
> comparing nodes A and B at distance N, nearby nodes are those at distances
> smaller than N from nodes A or B.
> 
> Placement strategy on a system with a glueless mesh NUMA topology needs
> to be different, because there are no natural groups of nodes determined
> by the hardware. Instead, when dealing with two nodes A and B at distance
> N, N >= 2, there will be intermediate nodes at distance < N from both nodes
> A and B. Good placement can be achieved by right shifting the faults on
> nearby nodes by the number of hops from the node being scored. In this
> context, a nearby node is any node less than the maximum distance in the
> system away from the node. Those nodes are skipped for efficiency reasons,
> there is no real policy reason to do so.


> +/* Handle placement on systems where not all nodes are directly connected. */
> +static unsigned long score_nearby_nodes(struct task_struct *p, int nid,
> +					int hoplimit, bool task)
> +{
> +	unsigned long score = 0;
> +	int node;
> +
> +	/*
> +	 * All nodes are directly connected, and the same distance
> +	 * from each other. No need for fancy placement algorithms.
> +	 */
> +	if (sched_numa_topology_type == NUMA_DIRECT)
> +		return 0;
> +
> +	for_each_online_node(node) {

> +	}
> +
> +	return score;
> +}

> @@ -944,6 +1003,8 @@ static inline unsigned long task_weight(struct task_struct *p, int nid,
>  		return 0;
>  
>  	faults = task_faults(p, nid);
> +	faults += score_nearby_nodes(p, nid, hops, true);
> +
>  	return 1000 * faults / total_faults;
>  }

> @@ -961,6 +1022,8 @@ static inline unsigned long group_weight(struct task_struct *p, int nid,
>  		return 0;
>  
>  	faults = group_faults(p, nid);
> +	faults += score_nearby_nodes(p, nid, hops, false);
> +
>  	return 1000 * faults / total_faults;
>  }

So this makes {task,group}_weight() O(nr_nodes), and we call these
function from O(nr_nodes) loops, giving a total of O(nr_nodes^2)
computational complexity, right?

Seems important to mention; I realize this is only for !DIRECT, but
still, I bet the real large people (those same 512 nodes we had
previous) would not really appreciate this.
