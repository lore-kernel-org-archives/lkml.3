Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaFMMFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 08:05:14 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:50291 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaFMMFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 08:05:13 -0400
Subject: Re: [PATCH 05/17] perf tools: Add ordered_events_(get|put)
 interface
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1402610913-19059-6-git-send-email-jolsa@kernel.org>
References: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
	 <1402610913-19059-6-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Jun 2014 21:05:05 +0900
Message-ID: <1402661105.2178.19.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-13 (금), 00:08 +0200, Jiri Olsa:
> +#define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct ordered_event))
> +static struct ordered_event *alloc_event(struct ordered_events_queue *q)
> +{
> +	struct list_head *cache = &q->cache;
> +	struct ordered_event *new;
> +
> +	if (!list_empty(cache)) {
> +		new = list_entry(cache->next, struct ordered_event, list);
> +		list_del(&new->list);
> +	} else if (q->buffer) {
> +		new = q->buffer + q->buffer_idx;
> +		if (++q->buffer_idx == MAX_SAMPLE_BUFFER)
> +			q->buffer = NULL;
> +	} else {
> +		q->buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
> +		if (!q->buffer)
> +			return NULL;
> +		list_add(&q->buffer->list, &q->to_free);
> +		q->buffer_idx = 2;
> +		new = q->buffer + 1;

Hmm.. can we add a comment that the first entry is abused to maintain
the to_free list?


> +	}
> +
> +	return new;
> +}
> +
> +static struct ordered_event*
> +ordered_events_get(struct ordered_events_queue *q, u64 timestamp)
> +{
> +	struct ordered_event *new;
> +
> +	new = alloc_event(q);
> +	if (new) {
> +		new->timestamp = timestamp;
> +		queue_event(q, new);
> +	}
> +
> +	return new;
> +}
> +
> +static void
> +ordered_event_put(struct ordered_events_queue *q, struct ordered_event *iter)
> +{
> +	list_del(&iter->list);
> +	list_add(&iter->list, &q->cache);

list_move(&iter->list, &q->cache) ?

> +	q->nr_events--;
> +}


[SNIP]
> @@ -639,29 +681,13 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
>  		return -EINVAL;
>  	}
>  
> -	if (!list_empty(cache)) {
> -		new = list_entry(cache->next, struct ordered_event, list);
> -		list_del(&new->list);
> -	} else if (q->buffer) {
> -		new = q->buffer + q->buffer_idx;
> -		if (++q->buffer_idx == MAX_SAMPLE_BUFFER)
> -			q->buffer = NULL;
> -	} else {
> -		q->buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
> -		if (!q->buffer)
> -			return -ENOMEM;
> -		list_add(&q->buffer->list, &q->to_free);
> -		q->buffer_idx = 2;
> -		new = q->buffer + 1;
> +	new = ordered_events_get(q, timestamp);
> +	if (new) {
> +		new->file_offset = file_offset;
> +		new->event = event;
>  	}

What about make it like below:

	if (!new)
		return -ENOMEM;

This way we can share more of the original code.

Thanks,
Namhyung


>  
> -	new->timestamp = timestamp;
> -	new->file_offset = file_offset;
> -	new->event = event;
> -
> -	__queue_event(new, s);
> -
> -	return 0;
> +	return new ? 0 : -ENOMEM;
>  }
>  
>  static void callchain__printf(struct perf_sample *sample)



