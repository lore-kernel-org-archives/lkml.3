Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760730AbaGYP1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:27:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36734 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760616AbaGYP1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:27:44 -0400
Date: Fri, 25 Jul 2014 17:27:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, mikey@neuling.org, mingo@kernel.org,
        pjt@google.com, jhladky@redhat.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, nicolas.pitre@linaro.org
Subject: Re: [PATCH] sched: make update_sd_pick_busiest return true on a
 busier sd
Message-ID: <20140725152728.GB6758@twins.programming.kicks-ass.net>
References: <20140722144559.382c5243@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722144559.382c5243@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 02:45:59PM -0400, Rik van Riel wrote:
> Currently update_sd_pick_busiest only returns true when an sd
> is overloaded, or for SD_ASYM_PACKING when a domain is busier
> than average and a higher numbered domain than the target.
> 
> This breaks load balancing between domains that are not overloaded,
> in the !SD_ASYM_PACKING case. This patch makes update_sd_pick_busiest
> return true when the busiest sd yet is encountered.
> 
> On a 4 node system, this seems to result in the load balancer finally
> putting 1 thread of a 4 thread test run of "perf bench numa mem" on
> each node, where before the load was generally not spread across all
> nodes.

So for !ASYM the code is effectively:

	return sgs->avg_load > sds->busiest_stat.avg_load;

I'd like to at least add a clause that makes overloaded groups
prioritized over !overloaded groups.

Also, like we found earlier, calculate_imbalance() relies on the
sum_nr_running > group_capacity_factor thing, which you've just
'wrecked', so we'd need an update to that part too.

> Behaviour for SD_ASYM_PACKING does not seem to match the comment,
> in that groups with below average load average are ignored, but I
> have no hardware to test that so I have left the behaviour of that
> code unchanged.

Mikey, does that stuff work as expected?
