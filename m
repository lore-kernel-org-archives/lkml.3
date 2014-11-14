Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbaKNGWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 01:22:46 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46097 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaKNGWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 01:22:46 -0500
X-Original-SENDERIP: 10.177.222.33
X-Original-MAILFROM: byungchul.park@lge.com
Date: Fri, 14 Nov 2014 15:22:23 +0900
From: Byungchul Park <byungchul.park@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, seungho1.park@lge.com,
        jolsa@redhat.com
Subject: Re: [PATCH v2 3/3] tracing: add additional marks to signal very
 large delay
Message-ID: <20141114062223.GK3393@byungchulpark-X58A-UD3R>
References: <1415171926-9782-1-git-send-email-byungchul.park@lge.com>
 <1415171926-9782-4-git-send-email-byungchul.park@lge.com>
 <20141113223801.367a5f33@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113223801.367a5f33@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 10:38:01PM -0500, Steven Rostedt wrote:
> On Wed,  5 Nov 2014 16:18:46 +0900
> byungchul.park@lge.com wrote:
> 
> > -static unsigned long preempt_mark_thresh_us = 100;
> > +DEFINE_MARK_STRUCT = {
> > +	DEFINE_MARK(0ULL		, ' '), /* 0 usecs */
> > +	DEFINE_MARK(10000ULL		, '+'), /* 10 usecs */
> > +	DEFINE_MARK(100000ULL		, '!'), /* 100 usecs */
> > +	DEFINE_MARK(1000000ULL		, '#'), /* 1000 usecs */
> > +	DEFINE_MARK(1000000000ULL	, '$'), /* 1 sec */
> > +};
> 
> OK, I see why you did the macro magic here. But it's still obfuscates
> the code.
> 
> Instead of having that find_trace_mark() be a static function, just
> make it defined in trace_output.c that function_graph calls. This code
> is used for outputting to userspace and a function call is not going to
> be noticed.

OK, I will make it global function and use it.

> 
> As it would now be a global function (although only defined in
> kernel/trace), we need to make the name a bit more specific. Instead of
> calling it find_trace_mark(), call it trace_duration_mark().
> 

OK, I'll rename it.

Thank you,
Byungchul.

> -- Steve
> 
> >  
> >  static int
> >  lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
> > @@ -506,8 +512,7 @@ lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
> >  		return trace_seq_printf(
> >  				s, " %4lldus%c: ",
> >  				abs_ts,
> > -				rel_ts > preempt_mark_thresh_us ? '!' :
> > -				  rel_ts > 1 ? '+' : ' ');
> > +				MARK(rel_ts * NSEC_PER_USEC));
> >  	} else { /* !verbose && !in_ns */
> >  		return trace_seq_printf(s, " %4lld: ", abs_ts);
> >  	}
> > @@ -692,7 +697,7 @@ int register_ftrace_event(struct trace_event *event)
> >  				goto out;
> >  
> >  		} else {
> > -			
> > +
> >  			event->type = next_event_type++;
> >  			list = &ftrace_event_list;
> >  		}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
