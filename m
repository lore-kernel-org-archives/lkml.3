Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab3GRJDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 05:03:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57599 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab3GRJC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 05:02:59 -0400
Date: Thu, 18 Jul 2013 11:02:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [PATCH] perf, x86: Add Silvermont (22nm Atom) support
Message-ID: <20130718090248.GF27075@twins.programming.kicks-ass.net>
References: <1374125767-9411-1-git-send-email-zheng.z.yan@intel.com>
 <20130718082324.GA27075@twins.programming.kicks-ass.net>
 <51E7A6F3.10109@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E7A6F3.10109@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 04:27:31PM +0800, Yan, Zheng wrote:
> On 07/18/2013 04:23 PM, Peter Zijlstra wrote:
> > On Thu, Jul 18, 2013 at 01:36:07PM +0800, Yan, Zheng wrote:
> >> +static struct event_constraint intel_slm_event_constraints[] __read_mostly =
> >> +{
> >> +	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
> >> +	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
> >> +	FIXED_EVENT_CONSTRAINT(0x013c, 2), /* CPU_CLK_UNHALTED.REF */
> >> +	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* pseudo CPU_CLK_UNHALTED.REF */
> > 
> > So the normal event 0x13c and the fixed counter 2 are normally _not_ the
> > same. Are they for slm? Are you sure?
> > 
> 
> yes, I'm sure. see page 15-15 of http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-optimization-manual.pdf

OK, then put in a comment how slm is 'special' and you might want to fix
intel_pmu_init():

	if (x86_pmu.event_constraints) {
		/*
		 * event on fixed counter2 (REF_CYCLES) only works on this
		 * counter, so do not extend mask to generic counters
		 */
		for_each_event_constraint(c, x86_pmu.event_constraints) {
			if (c->cmask != FIXED_EVENT_FLAGS
			    || c->idxmsk64 == INTEL_PMC_MSK_FIXED_REF_CYCLES) {
				continue;
			}

			c->idxmsk64 |= (1ULL << x86_pmu.num_counters) - 1;
			c->weight += x86_pmu.num_counters;
		}
	}

Since that explicitly skips the fixed counter 2 and doesn't extend its
constraint to include all other counters.
