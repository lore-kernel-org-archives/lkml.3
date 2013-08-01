Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3HANOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:14:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab3HANN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:13:59 -0400
Date: Thu, 1 Aug 2013 15:13:30 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/8] perf: Gather event accounting code
Message-ID: <20130801131329.GF1032@krava.brq.redhat.com>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
 <1374539466-4799-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374539466-4799-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 02:31:01AM +0200, Frederic Weisbecker wrote:
> Gather all the event accounting code to a single place,
> once all the prerequisites are completed. This simplifies
> the refcounting.
> 
> Original-patch-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  kernel/events/core.c |   79 +++++++++++++++++++++++++++++--------------------
>  1 files changed, 47 insertions(+), 32 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index c5f435f..3bb73af 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3128,6 +3128,21 @@ static void free_event_rcu(struct rcu_head *head)
>  static void ring_buffer_put(struct ring_buffer *rb);
>  static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb);
>  
> +static void __free_event(struct perf_event *event)
> +{
> +	if (!event->parent) {
> +		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
> +			put_callchain_buffers();
> +	}
> +
> +	if (event->destroy)
> +		event->destroy(event);
> +
> +	if (event->ctx)
> +		put_ctx(event->ctx);
> +
> +	call_rcu(&event->rcu_head, free_event_rcu);
> +}
>  static void free_event(struct perf_event *event)
>  {

nitpick, missing nl between functions

>  	irq_work_sync(&event->pending);
> @@ -3141,8 +3156,6 @@ static void free_event(struct perf_event *event)
>  			atomic_dec(&nr_comm_events);
>  		if (event->attr.task)
>  			atomic_dec(&nr_task_events);
> -		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
> -			put_callchain_buffers();
>  		if (is_cgroup_event(event)) {
>  			atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
>  			static_key_slow_dec_deferred(&perf_sched_events);
> @@ -3180,13 +3193,8 @@ static void free_event(struct perf_event *event)
>  	if (is_cgroup_event(event))
>  		perf_detach_cgroup(event);
>  
> -	if (event->destroy)
> -		event->destroy(event);
> -
> -	if (event->ctx)
> -		put_ctx(event->ctx);
>  
> -	call_rcu(&event->rcu_head, free_event_rcu);
> +	__free_event(event);

nitpick, extra nl above
