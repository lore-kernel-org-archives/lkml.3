Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750886AbaFMMMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 08:12:31 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:40463 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaFMMMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 08:12:30 -0400
Subject: Re: [PATCH 15/17] perf tools: Add debug prints for ordered events
 queue
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1402610913-19059-16-git-send-email-jolsa@kernel.org>
References: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
	 <1402610913-19059-16-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Jun 2014 21:12:23 +0900
Message-ID: <1402661543.2178.25.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-13 (금), 00:08 +0200, Jiri Olsa:
> Adding some prints for ordered events queue, to help
> debug issues.
> 
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jean Pihet <jean.pihet@linaro.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/builtin-report.c      |  4 +++
>  tools/perf/util/ordered-events.c | 54 ++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/ordered-events.h |  2 ++
>  3 files changed, 60 insertions(+)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 09b9d0c..130ab5c 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -82,6 +82,10 @@ static int report__config(const char *var, const char *value, void *cb)
>  		rep->queue_size = perf_config_u64(var, value);
>  		return 0;
>  	}
> +	if (!strcmp(var, "report.queue-debug")) {
> +		debug_sample_queue = perf_config_int(var, value);
> +		return 0;
> +	}

Again, config option only?


>  
>  	return perf_default_config(var, value, cb);
>  }
> diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
> index eaf2c47..80f1daa 100644
> --- a/tools/perf/util/ordered-events.c
> +++ b/tools/perf/util/ordered-events.c
> @@ -4,6 +4,37 @@
>  #include "session.h"
>  #include "asm/bug.h"
>  
> +int debug_sample_queue;
> +
> +static int pr_level(int level, const char *fmt, ...)
> +{
> +	int ret = 0;
> +
> +	if (unlikely(debug_sample_queue >= level)) {
> +		va_list args;
> +
> +		va_start(args, fmt);
> +		ret = vfprintf(stderr, fmt, args);
> +		va_end(args);
> +	}
> +
> +	return ret;
> +}
> +
> +#define pr_N(n, fmt, ...) \
> +	pr_level(n, fmt, ##__VA_ARGS__)
> +#define pr(fmt, ...)  pr_N(1, pr_fmt(fmt), ##__VA_ARGS__)
> +
> +static int pr_time(const char *str, u64 time)
> +{
> +	u64 secs, usecs, nsecs = time;
> +
> +	secs = nsecs / NSECS_PER_SEC;
> +	nsecs -= secs * NSECS_PER_SEC;
> +	usecs = nsecs / NSECS_PER_USEC;
> +	return fprintf(stderr, "\t[%13lu.%06lu] %s\n", secs, usecs, str);
> +}

It'd be better if these functions somehow reuse existing pr_* functions
or at least honor the use_browser value IMHO.

Thanks,
Namhyung


> +
>  static void queue_event(struct ordered_events_queue *q, struct ordered_event *new)
>  {
>  	struct ordered_event *last = q->last;
> @@ -68,6 +99,9 @@ static struct ordered_event *alloc_event(struct ordered_events_queue *q)
>  		if (!q->buffer)
>  			return NULL;
>  
> +		pr("alloc size %" PRIu64 "B, max %" PRIu64 "B\n",
> +		   q->cur_alloc_size, q->max_alloc_size);
> +
>  		q->cur_alloc_size += size;
>  		list_add(&q->buffer->list, &q->to_free);
>  		q->buffer_idx = 2;
> @@ -182,6 +216,19 @@ int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
>  		break;
>  	};
>  
> +	if (unlikely(debug_sample_queue)) {
> +		static const char * const str[] = {
> +			"FINAL",
> +			"ROUND",
> +			"HALF ",
> +		};
> +
> +		fprintf(stderr, "ordered_events_flush %s, nr_events %u\n",
> +			str[how], q->nr_events);
> +		pr_time("next_flush",    q->next_flush);
> +		pr_time("max_timestamp", q->max_timestamp);
> +	}
> +
>  	err = __ordered_events_flush(s, tool);
>  
>  	if (!err) {
> @@ -189,6 +236,13 @@ int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
>  			q->next_flush = q->max_timestamp;
>  	}
>  
> +	if (unlikely(debug_sample_queue)) {
> +		fprintf(stderr, "ordered_events_flush nr_events %u\n",
> +			q->nr_events);
> +		pr_time("next_flush", q->next_flush);
> +		pr_time("last_flush", q->last_flush);
> +	}
> +
>  	return err;
>  }
>  
> diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
> index 04cb295..8a717de 100644
> --- a/tools/perf/util/ordered-events.h
> +++ b/tools/perf/util/ordered-events.h
> @@ -48,4 +48,6 @@ ordered_events_queue_alloc_size(struct ordered_events_queue *q, u64 size)
>  {
>  	q->max_alloc_size = size;
>  }
> +
> +extern int debug_sample_queue;
>  #endif /* __ORDERED_EVENTS_H */



