Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488AbaJVMct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:32:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932865AbaJVMcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:32:46 -0400
Date: Wed, 22 Oct 2014 14:31:51 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, kan.liang@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v2 06/12] perf/x86: implement cross-HT corruption bug
 workaround
Message-ID: <20141022123151.GA15126@krava.brq.redhat.com>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
 <1412872486-2930-7-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412872486-2930-7-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 06:34:40PM +0200, Stephane Eranian wrote:
> From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>

SNIP

> +static struct event_constraint *
> +intel_get_excl_constraints(struct cpu_hw_events *cpuc, struct perf_event *event,
> +			   int idx, struct event_constraint *c)
> +{
> +	struct event_constraint *cx;
> +	struct intel_excl_cntrs *excl_cntrs = cpuc->excl_cntrs;
> +	struct intel_excl_states *xl, *xlo;
> +	int is_excl, i;

SNIP

> +	/*
> +	 * Modify static constraint with current dynamic
> +	 * state of thread
> +	 *
> +	 * EXCLUSIVE: sibling counter measuring exclusive event
> +	 * SHARED   : sibling counter measuring non-exclusive event
> +	 * UNUSED   : sibling counter unused
> +	 */
> +	for_each_set_bit(i, cx->idxmsk, X86_PMC_IDX_MAX) {
> +		/*
> +		 * exclusive event in sibling counter
> +		 * our corresponding counter cannot be used
> +		 * regardless of our event
> +		 */
> +		if (xl->state[i] == INTEL_EXCL_EXCLUSIVE)
> +			__clear_bit(i, cx->idxmsk);

if we want to check sibling counter, shouldn't we check xlo->state[i] instead? like

		if (xlo->state[i] == INTEL_EXCL_EXCLUSIVE)
			__clear_bit(i, cx->idxmsk);
	   

and also in condition below?

> +		/*
> +		 * if measuring an exclusive event, sibling
> +		 * measuring non-exclusive, then counter cannot
> +		 * be used
> +		 */
> +		if (is_excl && xl->state[i] == INTEL_EXCL_SHARED)
> +			__clear_bit(i, cx->idxmsk);
> +	}
> +
> +	/*
> +	 * recompute actual bit weight for scheduling algorithm
> +	 */
> +	cx->weight = hweight64(cx->idxmsk64);
> +
> +	/*
> +	 * if we return an empty mask, then switch
> +	 * back to static empty constraint to avoid
> +	 * the cost of freeing later on
> +	 */
> +	if (cx->weight == 0)
> +		cx = &emptyconstraint;
> +

SNIP

jirka
