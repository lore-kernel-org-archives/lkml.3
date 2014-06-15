Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaFOR1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 13:27:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaFOR1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 13:27:18 -0400
Date: Sun, 15 Jun 2014 19:27:03 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 05/17] perf tools: Add ordered_events_(get|put) interface
Message-ID: <20140615172703.GC1159@krava.brq.redhat.com>
References: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
 <1402610913-19059-6-git-send-email-jolsa@kernel.org>
 <1402661105.2178.19.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402661105.2178.19.camel@leonhard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 09:05:05PM +0900, Namhyung Kim wrote:
> 2014-06-13 (금), 00:08 +0200, Jiri Olsa:
> > +#define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct ordered_event))
> > +static struct ordered_event *alloc_event(struct ordered_events_queue *q)
> > +{
> > +	struct list_head *cache = &q->cache;
> > +	struct ordered_event *new;
> > +
> > +	if (!list_empty(cache)) {
> > +		new = list_entry(cache->next, struct ordered_event, list);
> > +		list_del(&new->list);
> > +	} else if (q->buffer) {
> > +		new = q->buffer + q->buffer_idx;
> > +		if (++q->buffer_idx == MAX_SAMPLE_BUFFER)
> > +			q->buffer = NULL;
> > +	} else {
> > +		q->buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
> > +		if (!q->buffer)
> > +			return NULL;
> > +		list_add(&q->buffer->list, &q->to_free);
> > +		q->buffer_idx = 2;
> > +		new = q->buffer + 1;
> 
> Hmm.. can we add a comment that the first entry is abused to maintain
> the to_free list?

ook

> 
> 
> > +	}
> > +
> > +	return new;
> > +}
> > +
> > +static struct ordered_event*
> > +ordered_events_get(struct ordered_events_queue *q, u64 timestamp)
> > +{
> > +	struct ordered_event *new;
> > +
> > +	new = alloc_event(q);
> > +	if (new) {
> > +		new->timestamp = timestamp;
> > +		queue_event(q, new);
> > +	}
> > +
> > +	return new;
> > +}
> > +
> > +static void
> > +ordered_event_put(struct ordered_events_queue *q, struct ordered_event *iter)
> > +{
> > +	list_del(&iter->list);
> > +	list_add(&iter->list, &q->cache);
> 
> list_move(&iter->list, &q->cache) ?

ok, I'll make that a separate patch, so it's obvious here
that I used the original code

> 
> > +	q->nr_events--;
> > +}
> 
> 
> [SNIP]
> > @@ -639,29 +681,13 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
> >  		return -EINVAL;
> >  	}
> >  
> > -	if (!list_empty(cache)) {
> > -		new = list_entry(cache->next, struct ordered_event, list);
> > -		list_del(&new->list);
> > -	} else if (q->buffer) {
> > -		new = q->buffer + q->buffer_idx;
> > -		if (++q->buffer_idx == MAX_SAMPLE_BUFFER)
> > -			q->buffer = NULL;
> > -	} else {
> > -		q->buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
> > -		if (!q->buffer)
> > -			return -ENOMEM;
> > -		list_add(&q->buffer->list, &q->to_free);
> > -		q->buffer_idx = 2;
> > -		new = q->buffer + 1;
> > +	new = ordered_events_get(q, timestamp);
> > +	if (new) {
> > +		new->file_offset = file_offset;
> > +		new->event = event;
> >  	}
> 
> What about make it like below:
> 
> 	if (!new)
> 		return -ENOMEM;
> 
> This way we can share more of the original code.

ook, will do

thanks,
jirka
