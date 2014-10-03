Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaJCHeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 03:34:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbaJCHeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 03:34:22 -0400
Date: Fri, 3 Oct 2014 09:33:54 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf tools: Add option to copy events when queueing
Message-ID: <20141003073354.GA19087@krava.brq.redhat.com>
References: <1412267936-19827-1-git-send-email-yarygin@linux.vnet.ibm.com>
 <1412267936-19827-2-git-send-email-yarygin@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412267936-19827-2-git-send-email-yarygin@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 08:38:55PM +0400, Alexander Yarygin wrote:
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
> 
> Based on a patch from David Ahern <dsahern@gmail.com>
> 
> Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Namhyung Kim <namhyung.kim@lge.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/util/ordered-events.c | 51 ++++++++++++++++++++++++++++++++++++----
>  tools/perf/util/ordered-events.h | 10 +++++++-
>  tools/perf/util/session.c        |  5 ++--
>  3 files changed, 58 insertions(+), 8 deletions(-)

apart from extra whitespaces (below):
Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

> 
> diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
> index 706ce1a..06d53ee 100644
> --- a/tools/perf/util/ordered-events.c
> +++ b/tools/perf/util/ordered-events.c

SNIP

> +		}
>  
>  		pr("alloc size %" PRIu64 "B (+%zu), max %" PRIu64 "B\n",
>  		   oe->cur_alloc_size, size, oe->max_alloc_size);
> @@ -90,15 +127,19 @@ static struct ordered_event *alloc_event(struct ordered_events *oe)
>  		pr("allocation limit reached %" PRIu64 "B\n", oe->max_alloc_size);
>  	}
>  
> +	new->event = new_event;
> +
>  	return new;

^^^ here

>  }
>  
>  struct ordered_event *
> -ordered_events__new(struct ordered_events *oe, u64 timestamp)
> +ordered_events__new(struct ordered_events *oe, u64 timestamp,
> +		    union perf_event *event)
>  {
>  	struct ordered_event *new;
>  
> -	new = alloc_event(oe);
> +	new = alloc_event(oe, event);
> +
>  	if (new) {

^^^ and here
