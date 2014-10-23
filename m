Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaJWHUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 03:20:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbaJWHUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 03:20:45 -0400
Date: Thu, 23 Oct 2014 09:19:44 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, kan.liang@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v2 06/12] perf/x86: implement cross-HT corruption bug
 workaround
Message-ID: <20141023071944.GA5184@krava.brq.redhat.com>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
 <1412872486-2930-7-git-send-email-eranian@google.com>
 <20141022123151.GA15126@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022123151.GA15126@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 02:31:51PM +0200, Jiri Olsa wrote:
> On Thu, Oct 09, 2014 at 06:34:40PM +0200, Stephane Eranian wrote:
> > From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
> 
> SNIP
> 
> > +static struct event_constraint *
> > +intel_get_excl_constraints(struct cpu_hw_events *cpuc, struct perf_event *event,
> > +			   int idx, struct event_constraint *c)
> > +{
> > +	struct event_constraint *cx;
> > +	struct intel_excl_cntrs *excl_cntrs = cpuc->excl_cntrs;
> > +	struct intel_excl_states *xl, *xlo;
> > +	int is_excl, i;
> 
> SNIP
> 
> > +	/*
> > +	 * Modify static constraint with current dynamic
> > +	 * state of thread
> > +	 *
> > +	 * EXCLUSIVE: sibling counter measuring exclusive event
> > +	 * SHARED   : sibling counter measuring non-exclusive event
> > +	 * UNUSED   : sibling counter unused
> > +	 */
> > +	for_each_set_bit(i, cx->idxmsk, X86_PMC_IDX_MAX) {
> > +		/*
> > +		 * exclusive event in sibling counter
> > +		 * our corresponding counter cannot be used
> > +		 * regardless of our event
> > +		 */
> > +		if (xl->state[i] == INTEL_EXCL_EXCLUSIVE)
> > +			__clear_bit(i, cx->idxmsk);
> 
> if we want to check sibling counter, shouldn't we check xlo->state[i] instead? like
> 
> 		if (xlo->state[i] == INTEL_EXCL_EXCLUSIVE)
> 			__clear_bit(i, cx->idxmsk);
> 	   
> 
> and also in condition below?

any comment on this? I'm curious, because it'd enlighten me
on how this is supposed to work ;-)

I dont understand why you update the sibling's counter state instead
of the current cpuc->excl_thread_id HT, like in intel_commit_scheduling
while you hold lock for the current HT state

could you please comment, I must be missing something

thanks,
jirka
