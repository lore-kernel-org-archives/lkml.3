Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbaIRSxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:53:53 -0400
Received: from mail.kernel.org ([198.145.19.201]:45125 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032AbaIRSxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:53:52 -0400
Date: Thu, 18 Sep 2014 15:53:45 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf session: Add option to copy events when queueing
Message-ID: <20140918185345.GJ2770@kernel.org>
References: <1411060059-23589-1-git-send-email-yarygin@linux.vnet.ibm.com>
 <1411060059-23589-2-git-send-email-yarygin@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411060059-23589-2-git-send-email-yarygin@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 18, 2014 at 09:07:38PM +0400, Alexander Yarygin escreveu:
> From: David Ahern <dsahern@gmail.com>
> When processing events the session code has an ordered samples queue which is
> used to time-sort events coming in across multiple mmaps. At a later point in
> time samples on the queue are flushed up to some timestamp at which point the
> event is actually processed.
> 
> When analyzing events live (ie., record/analysis path in the same command)
> there is a race that leads to corrupted events and parse errors which cause
> perf to terminate. The problem is that when the event is placed in the ordered
> samples queue it is only a reference to the event which is really sitting in
> the mmap buffer. Even though the event is queued for later processing the mmap
> tail pointer is updated which indicates to the kernel that the event has been
> processed. The race is flushing the event from the queue before it gets
> overwritten by some other event. For commands trying to process events live
> (versus just writing to a file) and processing a high rate of events this leads
> to parse failures and perf terminates.
> 
> Examples hitting this problem are 'perf kvm stat live', especially with nested
> VMs which generate 100,000+ traces per second, and a command processing
> scheduling events with a high rate of context switching -- e.g., running
> 'perf bench sched pipe'.
> 
> This patch offers live commands an option to copy the event when it is placed in
> the ordered samples queue.

If nobody objects I'll merge this patch, as it fixes problems, but I
wonder if the best wouldn't be simply not calling
perf_evlist__mmap_consume() till the last event there is in fact
consumed... I.e. as we _really_ consume the events, we remove it from
there.

Instead of consuming the event at perf_tool->sample() time, we would
do it at perf_tool->finished_round(), would that be feasible? Has anyone
tried this?

David? Is this a st00pid idea?

- Arnaldo

> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Namhyung Kim <namhyung.kim@lge.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
> ---
>  tools/perf/util/ordered-events.c | 12 +++++++++---
>  tools/perf/util/ordered-events.h |  2 +-
>  tools/perf/util/session.c        | 12 +++++++++---
>  tools/perf/util/session.h        |  1 +
>  4 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
> index 706ce1a..5b51de5 100644
> --- a/tools/perf/util/ordered-events.c
> +++ b/tools/perf/util/ordered-events.c
> @@ -140,11 +140,15 @@ static int __ordered_events__flush(struct perf_session *s,
>  			break;
>  
>  		ret = perf_evlist__parse_sample(s->evlist, iter->event, &sample);
> -		if (ret)
> +		if (ret) {
>  			pr_err("Can't parse sample, err = %d\n", ret);
> -		else {
> +			if (s->copy_on_queue)
> +				free(iter->event);
> +		} else {
>  			ret = perf_session__deliver_event(s, iter->event, &sample, tool,
>  							  iter->file_offset);
> +			if (s->copy_on_queue)
> +				free(iter->event);
>  			if (ret)
>  				return ret;
>  		}
> @@ -233,13 +237,15 @@ void ordered_events__init(struct ordered_events *oe)
>  	oe->cur_alloc_size = 0;
>  }
>  
> -void ordered_events__free(struct ordered_events *oe)
> +void ordered_events__free(struct perf_session *s, struct ordered_events *oe)
>  {
>  	while (!list_empty(&oe->to_free)) {
>  		struct ordered_event *event;
>  
>  		event = list_entry(oe->to_free.next, struct ordered_event, list);
>  		list_del(&event->list);
> +		if (s->copy_on_queue)
> +			free(event->event);
>  		free(event);
>  	}
>  }
> diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
> index 3b2f205..a156b0e 100644
> --- a/tools/perf/util/ordered-events.h
> +++ b/tools/perf/util/ordered-events.h
> @@ -41,7 +41,7 @@ void ordered_events__delete(struct ordered_events *oe, struct ordered_event *eve
>  int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
>  			  enum oe_flush how);
>  void ordered_events__init(struct ordered_events *oe);
> -void ordered_events__free(struct ordered_events *oe);
> +void ordered_events__free(struct perf_session *s, struct ordered_events *oe);
>  
>  static inline
>  void ordered_events__set_alloc_size(struct ordered_events *oe, u64 size)
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 6d2d50d..40d3aec 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -542,7 +542,13 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
>  		return -ENOMEM;
>  
>  	new->file_offset = file_offset;
> -	new->event = event;
> +
> +	if (s->copy_on_queue) {
> +		new->event = malloc(event->header.size);
> +		memcpy(new->event, event, event->header.size);
> +	} else
> +		new->event = event;
> +
>  	return 0;
>  }
>  
> @@ -1164,7 +1170,7 @@ done:
>  out_err:
>  	free(buf);
>  	perf_session__warn_about_errors(session, tool);
> -	ordered_events__free(&session->ordered_events);
> +	ordered_events__free(session, &session->ordered_events);
>  	return err;
>  }
>  
> @@ -1309,7 +1315,7 @@ out:
>  out_err:
>  	ui_progress__finish();
>  	perf_session__warn_about_errors(session, tool);
> -	ordered_events__free(&session->ordered_events);
> +	ordered_events__free(session, &session->ordered_events);
>  	session->one_mmap = false;
>  	return err;
>  }
> diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
> index 8dd41ca..137f77f 100644
> --- a/tools/perf/util/session.h
> +++ b/tools/perf/util/session.h
> @@ -27,6 +27,7 @@ struct perf_session {
>  	void			*one_mmap_addr;
>  	u64			one_mmap_offset;
>  	struct ordered_events	ordered_events;
> +	bool			copy_on_queue;
>  	struct perf_data_file	*file;
>  };
>  
> -- 
> 1.9.1
