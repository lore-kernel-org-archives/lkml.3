Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031146AbaLLRSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:18:30 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:56949 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030945AbaLLRSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:18:25 -0500
Date: Fri, 12 Dec 2014 12:18:21 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/5] workqueue: update wq_numa_possible_cpumask
Message-ID: <20141212171821.GB20020@htj.dyndns.org>
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
 <1418379595-6281-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418379595-6281-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 06:19:52PM +0800, Lai Jiangshan wrote:
...
> +static void wq_update_numa_mapping(int cpu)
> +{
> +	int node, orig_node = NUMA_NO_NODE, new_node = cpu_to_node(cpu);
> +
> +	lockdep_assert_held(&wq_pool_mutex);
> +
> +	if (!wq_numa_enabled)
> +		return;
> +
> +	/* the node of onlining CPU is not NUMA_NO_NODE */
> +	if (WARN_ON(new_node == NUMA_NO_NODE))
> +		return;
> +
> +	/* test whether the NUMA node mapping is changed. */
> +	if (cpumask_test_cpu(cpu, wq_numa_possible_cpumask[new_node]))
> +		return;
> +
> +	/* find the origin node */
> +	for_each_node(node) {
> +		if (cpumask_test_cpu(cpu, wq_numa_possible_cpumask[node])) {
> +			orig_node = node;
> +			break;
> +		}
> +	}
> +
> +	/* there may be multi mappings changed, re-initial. */
> +	cpumask_clear(wq_numa_possible_cpumask[new_node]);
> +	if (orig_node != NUMA_NO_NODE)
> +		cpumask_clear(wq_numa_possible_cpumask[orig_node]);
> +	for_each_possible_cpu(cpu) {
> +		node = cpu_to_node(node);
> +		if (node == new_node)
> +			cpumask_set_cpu(cpu, wq_numa_possible_cpumask[new_node]);
> +		else if (orig_node != NUMA_NO_NODE && node == orig_node)
> +			cpumask_set_cpu(cpu, wq_numa_possible_cpumask[orig_node]);
> +	}
> +}

Let's please move this to NUMA code and properly update it on actual
mapping changes.

Thanks.

-- 
tejun
