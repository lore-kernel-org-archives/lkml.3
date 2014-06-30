Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbaF3R6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:58:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511AbaF3R6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:58:46 -0400
Date: Mon, 30 Jun 2014 19:58:28 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 07/18] perf tools: Limit ordered events queue size
Message-ID: <20140630175828.GC1236@krava.redhat.com>
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
 <1403103539-16807-8-git-send-email-jolsa@kernel.org>
 <53ADFA13.50304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53ADFA13.50304@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 05:11:15PM -0600, David Ahern wrote:
> On 6/18/14, 8:58 AM, Jiri Olsa wrote:
> >@@ -520,7 +522,7 @@ static void queue_event(struct ordered_events_queue *q, struct ordered_event *ne
> >  static struct ordered_event *alloc_event(struct ordered_events_queue *q)
> >  {
> >  	struct list_head *cache = &q->cache;
> >-	struct ordered_event *new;
> >+	struct ordered_event *new = NULL;
> >
> >  	if (!list_empty(cache)) {
> >  		new = list_entry(cache->next, struct ordered_event, list);
> >@@ -529,10 +531,14 @@ static struct ordered_event *alloc_event(struct ordered_events_queue *q)
> >  		new = q->buffer + q->buffer_idx;
> >  		if (++q->buffer_idx == MAX_SAMPLE_BUFFER)
> >  			q->buffer = NULL;
> >-	} else {
> >-		q->buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
> >+	} else if (q->cur_alloc_size < q->max_alloc_size) {
> >+		size_t size = MAX_SAMPLE_BUFFER * sizeof(*new);
> >+
> >+		q->buffer = malloc(size);
> >  		if (!q->buffer)
> >  			return NULL;
> >+
> >+		q->cur_alloc_size += size;
> >  		list_add(&q->buffer->list, &q->to_free);
> >
> 
> When is cur_alloc_size decremented?

never, it get's incremented untiul we reach the limit,
then it stays and the cache is used for new events..
and it's all released at the end

jirka
