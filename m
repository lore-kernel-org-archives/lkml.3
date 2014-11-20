Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbaKTGjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 01:39:15 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:41221 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbaKTGjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 01:39:14 -0500
X-Original-SENDERIP: 10.177.222.33
X-Original-MAILFROM: byungchul.park@lge.com
Date: Thu, 20 Nov 2014 15:38:46 +0900
From: Byungchul Park <byungchul.park@lge.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, seungho1.park@lge.com, jolsa@redhat.com
Subject: Re: [PATCH v5 2/2] tracing: add additional marks to signal very
 large time
Message-ID: <20141120063846.GD27177@byungchulpark-X58A-UD3R>
References: <1416442535-31188-1-git-send-email-byungchul.park@lge.com>
 <1416442535-31188-3-git-send-email-byungchul.park@lge.com>
 <20141119200604.6b57266d@gandalf.local.home>
 <87ioiapft4.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ioiapft4.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 20, 2014 at 03:05:43PM +0900, Namhyung Kim wrote:
> Hi Steve and Byungchul,
> 
> On Wed, 19 Nov 2014 20:06:04 -0500, Steven Rostedt wrote:
> > On Thu, 20 Nov 2014 09:15:35 +0900
> > byungchul.park@lge.com wrote:
> >> -static unsigned long preempt_mark_thresh_us = 100;
> >> +#undef MARK
> >> +#define MARK(v, s) {.val = v, .sym = s}
> >> +/* trace overhead mark */
> >> +static const struct trace_mark {
> >> +	unsigned long long	val; /* unit: nsec */
> >> +	char			sym;
> >> +} mark[] = {
> >> +	MARK(1000000000ULL	, '$'), /* 1 sec */
> >> +	MARK(1000000ULL		, '#'), /* 1000 usecs */
> >> +	MARK(100000ULL		, '!'), /* 100 usecs */
> >> +	MARK(10000ULL		, '+'), /* 10 usecs */
> >> +	MARK(0ULL		, ' '), /* 0 usecs */
> >> +};
> >> +#undef MARK
> >> +
> >> +char trace_find_mark(unsigned long long d)
> >> +{
> >> +	int i;
> >> +	int size = ARRAY_SIZE(mark);
> >> +
> >> +	for (i = 0; i < size; i++) {
> >> +		if (d >= mark[i].val)
> >> +			break;
> >> +	}
> >> +
> >> +	return (i == size)? ' ' : mark[i].sym;
> >
> > Change this to:
> >
> > 	/* The break from loop must have been hit */
> > 	if (WARN_ON_ONCE(i == size))
> > 		return ' ';
> 
> I think it's impossible since it's always true that 'd >= 0'.
> 

If someone won't define "MARK(0ULL, ' ')", then i think it can happen. :)

Thanks,
Byungchul

> Thanks,
> Namhyung
> 
> >
> > 	return mark[i].sym;
> >
> > -- Steve
> >
> >
> >> +}
> >>  
> >>  static int
> >>  lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
> >> @@ -506,8 +532,7 @@ lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
> >>  		return trace_seq_printf(
> >>  				s, " %4lldus%c: ",
> >>  				abs_ts,
> >> -				rel_ts > preempt_mark_thresh_us ? '!' :
> >> -				  rel_ts > 1 ? '+' : ' ');
> >> +				trace_find_mark(rel_ts * NSEC_PER_USEC));
> >>  	} else { /* !verbose && !in_ns */
> >>  		return trace_seq_printf(s, " %4lld: ", abs_ts);
> >>  	}
> >> @@ -692,7 +717,7 @@ int register_ftrace_event(struct trace_event *event)
> >>  				goto out;
> >>  
> >>  		} else {
> >> -			
> >> +
> >>  			event->type = next_event_type++;
> >>  			list = &ftrace_event_list;
> >>  		}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
