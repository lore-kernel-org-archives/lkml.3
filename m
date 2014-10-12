Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaJLObG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 10:31:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:56762 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaJLObC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 10:31:02 -0400
Date: Sun, 12 Oct 2014 16:30:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mgorman@suse.de, chegu_vinod@hp.com,
        mingo@kernel.org, efault@gmx.de, vincent.guittot@linaro.org
Subject: Re: [PATCH RFC 2/5] sched,numa: classify the NUMA topology of a
 system
Message-ID: <20141012143056.GF3015@worktop>
References: <1412797050-8903-1-git-send-email-riel@redhat.com>
 <1412797050-8903-3-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412797050-8903-3-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 03:37:27PM -0400, riel@redhat.com wrote:
> +static void init_numa_topology_type(void)
> +{
> +	int a, b, c, n;
> +
> +	n = sched_domains_numa_levels;
> +
> +	if (n <= 1)
> +		sched_numa_topology_type = NUMA_DIRECT;
> +
> +	for_each_online_node(a) {
> +		for_each_online_node(b) {
> +			/* Find two nodes furthest removed from each other. */
> +			if (node_hops(a, b) < n)
> +				continue;
> +
> +			/* Is there an intermediary node between a and b? */
> +			for_each_online_node(c) {
> +				if (node_hops(a, c) < n &&
> +				    node_hops(b, c) < n) {
> +					sched_numa_topology_type =
> +							NUMA_GLUELESS_MESH;
> +					return;
> +				}
> +			}
> +
> +			sched_numa_topology_type = NUMA_BACKPLANE;
> +			return;
> +		}
> +	}
> +}

We can find max_distance nodes in sched_init_numa(), right? Could we not
avoid this second iteration?
