Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3GYKFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:05:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34086 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab3GYKFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:05:12 -0400
Date: Thu, 25 Jul 2013 12:04:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Update perf_event_type documentation
Message-ID: <20130725100451.GJ27075@twins.programming.kicks-ass.net>
References: <20130716150907.GL23818@dyad.programming.kicks-ass.net>
 <tip-a5cdd40c9877e9aba704c020fd65d26b5cfecf18@git.kernel.org>
 <alpine.DEB.2.02.1307241348250.7828@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307241348250.7828@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 01:54:00PM -0400, Vince Weaver wrote:
> On Tue, 23 Jul 2013, tip-bot for Peter Zijlstra wrote:
> 
> > Commit-ID:  a5cdd40c9877e9aba704c020fd65d26b5cfecf18
> > Gitweb:     http://git.kernel.org/tip/a5cdd40c9877e9aba704c020fd65d26b5cfecf18
> > Author:     Peter Zijlstra <peterz@infradead.org>
> > AuthorDate: Tue, 16 Jul 2013 17:09:07 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Tue, 23 Jul 2013 12:17:08 +0200
> > 
> > perf: Update perf_event_type documentation
> > 
> > Due to a discussion with Adrian I had a good look at the perf_event_type record
> > layout and found the documentation to be somewhat unclear.
> 
> This code makes a lot of code changes considering it is "updating 
> documentation".
> 
> Also, will code following this "documentation" be backward compatible?
> 
> Meaning, if you have code that depends on the new fields you've added
> and run on older kernels, will you get sane results?  Or will the code
> get garbage and/or segfault in the sample_id fields because you read
> past the end of valid data?

I didn't add any fields, this is simply catching up with what was
already there. But yes, this is very much intended to be compatible.

> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 5e2bce9..1274114 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -4462,20 +4462,6 @@ void perf_output_sample(struct perf_output_handle *handle,
> >  		}
> >  	}
> >  
> > -	if (!event->attr.watermark) {
> > -		int wakeup_events = event->attr.wakeup_events;
> > -
> > -		if (wakeup_events) {
> > -			struct ring_buffer *rb = handle->rb;
> > -			int events = local_inc_return(&rb->events);
> > -
> > -			if (events >= wakeup_events) {
> > -				local_sub(wakeup_events, &rb->events);
> > -				local_inc(&rb->wakeup);
> > -			}
> > -		}
> > -	}
> > -
> >  	if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
> >  		if (data->br_stack) {
> >  			size_t size;
> > @@ -4511,16 +4497,31 @@ void perf_output_sample(struct perf_output_handle *handle,
> >  		}
> >  	}
> >  
> > -	if (sample_type & PERF_SAMPLE_STACK_USER)
> > +	if (sample_type & PERF_SAMPLE_STACK_USER) {
> >  		perf_output_sample_ustack(handle,
> >  					  data->stack_user_size,
> >  					  data->regs_user.regs);
> > +	}
> >  
> >  	if (sample_type & PERF_SAMPLE_WEIGHT)
> >  		perf_output_put(handle, data->weight);
> >  
> >  	if (sample_type & PERF_SAMPLE_DATA_SRC)
> >  		perf_output_put(handle, data->data_src.val);
> > +
> > +	if (!event->attr.watermark) {
> > +		int wakeup_events = event->attr.wakeup_events;
> > +
> > +		if (wakeup_events) {
> > +			struct ring_buffer *rb = handle->rb;
> > +			int events = local_inc_return(&rb->events);
> > +
> > +			if (events >= wakeup_events) {
> > +				local_sub(wakeup_events, &rb->events);
> > +				local_inc(&rb->wakeup);
> > +			}
> > +		}
> > +	}
> >  }

I suppose you're 'complaining' about these changes? Yeah, maybe I should
have split them up in a separate patch.

I moved the watermark code from somewhere in the middle of actually
doing the output to the end (where it once was) and added a 'missing'
pair of curlies.

I noticed both oddities when looking at the code to verify the output
format which was updated in the other hunks.

It should be a NOP functionality wise.
