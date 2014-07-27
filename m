Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaG0X6C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 19:58:02 -0400
Received: from ozlabs.org ([103.22.144.67]:49094 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaG0X6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 19:58:00 -0400
Message-ID: <1406505477.2876.15.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH] sched: make update_sd_pick_busiest return true on a
 busier sd
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, pjt@google.com, jhladky@redhat.com,
        ktkhai@parallels.com, tim.c.chen@linux.intel.com,
        nicolas.pitre@linaro.org
Date: Mon, 28 Jul 2014 09:57:57 +1000
In-Reply-To: <20140725152728.GB6758@twins.programming.kicks-ass.net>
References: <20140722144559.382c5243@annuminas.surriel.com>
	 <20140725152728.GB6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-25 at 17:27 +0200, Peter Zijlstra wrote:
> On Tue, Jul 22, 2014 at 02:45:59PM -0400, Rik van Riel wrote:
> > Currently update_sd_pick_busiest only returns true when an sd
> > is overloaded, or for SD_ASYM_PACKING when a domain is busier
> > than average and a higher numbered domain than the target.
> > 
> > This breaks load balancing between domains that are not overloaded,
> > in the !SD_ASYM_PACKING case. This patch makes update_sd_pick_busiest
> > return true when the busiest sd yet is encountered.
> > 
> > On a 4 node system, this seems to result in the load balancer finally
> > putting 1 thread of a 4 thread test run of "perf bench numa mem" on
> > each node, where before the load was generally not spread across all
> > nodes.
> 
> So for !ASYM the code is effectively:
> 
> 	return sgs->avg_load > sds->busiest_stat.avg_load;
> 
> I'd like to at least add a clause that makes overloaded groups
> prioritized over !overloaded groups.
> 
> Also, like we found earlier, calculate_imbalance() relies on the
> sum_nr_running > group_capacity_factor thing, which you've just
> 'wrecked', so we'd need an update to that part too.
> 
> > Behaviour for SD_ASYM_PACKING does not seem to match the comment,
> > in that groups with below average load average are ignored, but I
> > have no hardware to test that so I have left the behaviour of that
> > code unchanged.
> 
> Mikey, does that stuff work as expected?

Sorry for the slow response.  v1 and v2 both pass testing on POWER7.  So
FWIW...

Acked-By: Michael Neuling <mikey@neuling.org>

Mikey

