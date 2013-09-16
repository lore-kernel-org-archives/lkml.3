Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab3IPQk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:40:29 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:60460 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab3IPQk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:40:28 -0400
Date: Mon, 16 Sep 2013 18:40:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf session: Add option to copy events when queueing
Message-ID: <20130916164022.GA29373@localhost.localdomain>
References: <1378496221-61525-1-git-send-email-dsahern@gmail.com>
 <20130914161626.GD1718@localhost.localdomain>
 <52349C14.2070508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52349C14.2070508@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 14, 2013 at 11:25:40AM -0600, David Ahern wrote:
> On 9/14/13 10:16 AM, Frederic Weisbecker wrote:
> >>@@ -676,7 +682,12 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
> >>
> >>  	new->timestamp = timestamp;
> >>  	new->file_offset = file_offset;
> >>-	new->event = event;
> >>+
> >>+	if (s->copy_on_queue) {
> >>+		new->event = malloc(event->header.size);
> >>+		memcpy(new->event, event, event->header.size);
> >>+	} else
> >>+		new->event = event;
> 
> ---8<---
> 
> >So do you think it should stay optional? This looks like a global problem, I mean
> >the event can be unmapped anytime for any builtin tool mapping it, right?
> 
> Yes. I could make it the default behavior; just overhead in doing
> that (malloc/copy for each event).

Are there any tool that don't suffer from this bug somehow? If not then it must
be applied unconditionally.

> 
> >
> >Also we already allocate the sample list node (struct sample_queue) from os->sample
> >buffer. ie: we have our own allocator there.
> >
> >Probably we should reuse that and include the copied event space in "struct sample_queue"?
> 
> 
> Right, that's where I put the malloc and copy - I kept the relevant
> change above. I take it you are thinking of something different but
> I am not following you. You definitely do NOT want to change struct
> sample_queue to include an event - like this:
> 
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 51f5edf..866944a 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -491,7 +491,7 @@ static perf_event__swap_op perf_event__swap_ops[] = {
>  struct sample_queue {
>     u64         timestamp;
>     u64         file_offset;
> -   union perf_event    *event;
> +   union perf_event    event;

Right that's roughly what I thought.

>     struct list_head    list;
>  };
> 
> size of event is determined by mmap_event (mmap2_event in latest
> code) which is > 4096 because of the filename argument. Including
> the event directly in sample_queue would balloon memory usage
> (learned this the hard way!).

Ah then perhaps we can allocate with the dynamic size of the event?

> 
> >
> >Also looking at it now, it seems we have a bug on the existing code:
> >
> >
> >         if (!list_empty(sc)) {
> >                 new = list_entry(sc->next, struct sample_queue, list);
> >                 list_del(&new->list);
> >         } else if (os->sample_buffer) {
> >                 new = os->sample_buffer + os->sample_buffer_idx;
> >                 if (++os->sample_buffer_idx == MAX_SAMPLE_BUFFER)
> >                         os->sample_buffer = NULL;
> >         } else {
> >                os->sample_buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
> >                if (!os->sample_buffer)
> >                         return -ENOMEM;
> >                list_add(&os->sample_buffer->list, &os->to_free);
> >                os->sample_buffer_idx = 2;
> >                new = os->sample_buffer + 1;
> >         }
> >
> >If we actually run out of buffer rooms, we should realloc right after and not
> >wait for the next entry, otherwise we loose an event:
> >
> >         if (!list_empty(sc)) {
> >                 new = list_entry(sc->next, struct sample_queue, list);
> >                 list_del(&new->list);
> >         } else {
> >                 if (os->sample_buffer) {
> >                         new = os->sample_buffer + os->sample_buffer_idx;
> >                         if (++os->sample_buffer_idx == MAX_SAMPLE_BUFFER)
> >                                 os->sample_buffer = NULL;
> >                 }
> >
> >                 if (!os->sample_buffer) {
> >	                os->sample_buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
> >                         if (!os->sample_buffer)
> >                                 return -ENOMEM;
> >                         list_add(&os->sample_buffer->list, &os->to_free);
> >                         os->sample_buffer_idx = 2;
> >                         new = os->sample_buffer + 1;
> >         }
> >
> >
> >Although the mirrored os->sample_buffer condition check is a bit ugly and should move to
> >a function. But the idea is there.
> 
> Ok. That should be a separate patch. Are you going to submit that one?

Yeah, unless you beat me at it :)
