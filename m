Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbaF0XL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:11:28 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:45207 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbaF0XL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:11:27 -0400
Message-ID: <53ADFA13.50304@gmail.com>
Date: Fri, 27 Jun 2014 17:11:15 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 07/18] perf tools: Limit ordered events queue size
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org> <1403103539-16807-8-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403103539-16807-8-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/14, 8:58 AM, Jiri Olsa wrote:
> @@ -520,7 +522,7 @@ static void queue_event(struct ordered_events_queue *q, struct ordered_event *ne
>   static struct ordered_event *alloc_event(struct ordered_events_queue *q)
>   {
>   	struct list_head *cache = &q->cache;
> -	struct ordered_event *new;
> +	struct ordered_event *new = NULL;
>
>   	if (!list_empty(cache)) {
>   		new = list_entry(cache->next, struct ordered_event, list);
> @@ -529,10 +531,14 @@ static struct ordered_event *alloc_event(struct ordered_events_queue *q)
>   		new = q->buffer + q->buffer_idx;
>   		if (++q->buffer_idx == MAX_SAMPLE_BUFFER)
>   			q->buffer = NULL;
> -	} else {
> -		q->buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
> +	} else if (q->cur_alloc_size < q->max_alloc_size) {
> +		size_t size = MAX_SAMPLE_BUFFER * sizeof(*new);
> +
> +		q->buffer = malloc(size);
>   		if (!q->buffer)
>   			return NULL;
> +
> +		q->cur_alloc_size += size;
>   		list_add(&q->buffer->list, &q->to_free);
>

When is cur_alloc_size decremented?

$ git checkout remotes/jolsa/perf/core_ordered_events

$ egrep -r cur_alloc_size tools/perf/
tools/perf//util/ordered-events.c:	} else if (q->cur_alloc_size < 
q->max_alloc_size) {
tools/perf//util/ordered-events.c:		   q->cur_alloc_size, 
q->max_alloc_size);
tools/perf//util/ordered-events.c:		q->cur_alloc_size += size;
tools/perf//util/ordered-events.c:	q->cur_alloc_size = 0;
tools/perf//util/ordered-events.h:	u64			cur_alloc_size;

Does not appear to ever be decremented.

David

