Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaATQb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:31:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32913 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaATQbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:31:24 -0500
Date: Mon, 20 Jan 2014 17:31:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, chegu_vinod@hp.com,
        mgorman@suse.de, mingo@redhat.com
Subject: Re: [PATCH 3/7] numa,sched: build per numa_group active node mask
 from faults_from statistics
Message-ID: <20140120163103.GI31570@twins.programming.kicks-ass.net>
References: <1389993129-28180-1-git-send-email-riel@redhat.com>
 <1389993129-28180-4-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389993129-28180-4-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 04:12:05PM -0500, riel@redhat.com wrote:
>  /*
> + * Iterate over the nodes from which NUMA hinting faults were triggered, in
> + * other words where the CPUs that incurred NUMA hinting faults are. The
> + * bitmask is used to limit NUMA page migrations, and spread out memory
> + * between the actively used nodes. To prevent flip-flopping, and excessive
> + * page migrations, nodes are added when they cause over 40% of the maximum
> + * number of faults, but only removed when they drop below 20%.
> + */
> +static void update_numa_active_node_mask(struct task_struct *p)
> +{
> +	unsigned long faults, max_faults = 0;
> +	struct numa_group *numa_group = p->numa_group;
> +	int nid;
> +
> +	for_each_online_node(nid) {
> +		faults = numa_group->faults_from[task_faults_idx(nid, 0)] +
> +			 numa_group->faults_from[task_faults_idx(nid, 1)];
> +		if (faults > max_faults)
> +			max_faults = faults;
> +	}
> +
> +	for_each_online_node(nid) {
> +		faults = numa_group->faults_from[task_faults_idx(nid, 0)] +
> +			 numa_group->faults_from[task_faults_idx(nid, 1)];
> +		if (!node_isset(nid, numa_group->active_nodes)) {
> +			if (faults > max_faults * 4 / 10)
> +				node_set(nid, numa_group->active_nodes);
> +		} else if (faults < max_faults * 2 / 10)
> +			node_clear(nid, numa_group->active_nodes);
> +	}
> +}

Why not use 6/16 and 3/16 resp.? That avoids an actual division.
