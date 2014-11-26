Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaKZPpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:45:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbaKZPpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:45:18 -0500
Date: Wed, 26 Nov 2014 13:44:59 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf tools: Do not fail on processing out of order event
Message-ID: <20141126154459.GD3808@redhat.com>
References: <1417016371-30249-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417016371-30249-1-git-send-email-jolsa@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 26, 2014 at 04:39:31PM +0100, Jiri Olsa escreveu:
> Linus reported perf report command being interrupted due to
> processing of 'out of order' event, with following error:
> 
>   Timestamp below last timeslice flush
>   0x5733a8 [0x28]: failed to process type: 3
> 
> I could reproduce the issue and in my case it was caused by one
> CPU (mmap) being behind during record and userspace mmap reader
> seeing the data after other CPUs data were already stored.
> 
> It'd be nice to find the source of this hiccup, meanwhile I'm
> submitting change that does not kill the processing, but only
> tracks the number of out of order events and warn user.

Works, for me, thanks for the fast response!

- Arnaldo
 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/util/event.h   |  1 +
>  tools/perf/util/session.c | 13 +++++++------
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
> index 09b9e8d3fcf7..c4ffe2bd0738 100644
> --- a/tools/perf/util/event.h
> +++ b/tools/perf/util/event.h
> @@ -242,6 +242,7 @@ struct events_stats {
>  	u32 nr_invalid_chains;
>  	u32 nr_unknown_id;
>  	u32 nr_unprocessable_samples;
> +	u32 nr_unordered_events;
>  };
>  
>  struct attr_event {
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 6ac62ae6b8fa..17a85f527bfc 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -533,15 +533,11 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
>  		return -ETIME;
>  
>  	if (timestamp < oe->last_flush) {
> -		WARN_ONCE(1, "Timestamp below last timeslice flush\n");
> -
> -		pr_oe_time(timestamp,      "out of order event");
> +		pr_oe_time(timestamp,      "out of order event\n");
>  		pr_oe_time(oe->last_flush, "last flush, last_flush_type %d\n",
>  			   oe->last_flush_type);
>  
> -		/* We could get out of order messages after forced flush. */
> -		if (oe->last_flush_type != OE_FLUSH__HALF)
> -			return -EINVAL;
> +		s->stats.nr_unordered_events++;
>  	}
>  
>  	new = ordered_events__new(oe, timestamp, event);
> @@ -1118,6 +1114,11 @@ static void perf_session__warn_about_errors(const struct perf_session *session,
>  			    "Do you have a KVM guest running and not using 'perf kvm'?\n",
>  			    session->stats.nr_unprocessable_samples);
>  	}
> +
> +	if (session->stats.nr_unordered_events != 0) {
> +		ui__warning("%u out of order events recorded.\n",
> +			    session->stats.nr_unordered_events);
> +	}
>  }
>  
>  volatile int session_done;
> -- 
> 1.9.3
