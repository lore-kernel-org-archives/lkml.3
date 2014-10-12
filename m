Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaJLO4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 10:56:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38240 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaJLO4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 10:56:30 -0400
Date: Sun, 12 Oct 2014 16:56:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mgorman@suse.de, chegu_vinod@hp.com,
        mingo@kernel.org, efault@gmx.de, vincent.guittot@linaro.org
Subject: Re: [PATCH RFC 5/5] sched,numa: find the preferred nid with complex
 NUMA topology
Message-ID: <20141012145623.GI3015@worktop>
References: <1412797050-8903-1-git-send-email-riel@redhat.com>
 <1412797050-8903-6-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412797050-8903-6-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 03:37:30PM -0400, riel@redhat.com wrote:
> +static int preferred_group_nid(struct task_struct *p, int nid)
> +{
> +	nodemask_t nodes;
> +	int hops;
> +
> +	/* Direct connections between all NUMA nodes. */
> +	if (sched_numa_topology_type == NUMA_DIRECT)
> +		return nid;
> +
> +	/*
> +	 * On a system with glueless mesh NUMA topology, group_weight
> +	 * scores nodes according to the number of NUMA hinting faults on
> +	 * both the node itself, and on nearby nodes.
> +	 */
> +	if (sched_numa_topology_type == NUMA_GLUELESS_MESH) {
> +		unsigned long score, max_score = 0;
> +		int node, max_node = nid;
> +
> +		hops = sched_domains_numa_levels;
> +
> +		for_each_online_node(node) {
> +			score = group_weight(p, node, hops);
> +			if (score > max_score) {
> +				max_score = score;
> +				max_node = node;
> +			}
> +		}
> +		return max_node;
> +	}

This too is O(nr_nodes^2), right?
