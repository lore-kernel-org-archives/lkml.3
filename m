Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbaDVT6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:58:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:56011 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbaDVT62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:58:28 -0400
Date: Tue, 22 Apr 2014 16:25:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Robert Richter <robert.richter@linaro.org>
Subject: Re: [PATCH 03/16] perf, mmap: Factor out perf_alloc/free_rb()
Message-ID: <20140422142517.GL11182@twins.programming.kicks-ass.net>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
 <1396883078-25320-4-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396883078-25320-4-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 05:04:25PM +0200, Jean Pihet wrote:
> From: Robert Richter <robert.richter@linaro.org>
> 
> Factor out code to allocate and deallocate ringbuffers. We need this
> later to setup the sampling buffer for persistent events.
> 
> While at this, replacing get_current_user() with get_uid(user).
> 
> Signed-off-by: Robert Richter <robert.richter@linaro.org>
> Signed-off-by: Robert Richter <rric@kernel.org>
> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> ---
>  kernel/events/core.c     | 77 +++++++++++++++++++++++++++++-------------------
>  kernel/events/internal.h |  3 ++
>  2 files changed, 50 insertions(+), 30 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 5eaba42..22ec8f0 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3193,7 +3193,45 @@ static void free_event_rcu(struct rcu_head *head)
>  }
>  
>  static void ring_buffer_put(struct ring_buffer *rb);
> +static void ring_buffer_attach(struct perf_event *event, struct ring_buffer *rb);
>  static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb);
> +static void perf_event_init_userpage(struct perf_event *event);
> +
> +/*
> + * Must be called with &event->mmap_mutex held. event->rb must be
> + * NULL. perf_alloc_rb() requires &event->mmap_count to be incremented
> + * on success which corresponds to &rb->mmap_count that is initialized
> + * with 1.
> + */
> +int perf_alloc_rb(struct perf_event *event, int nr_pages, int flags)
> +{
> +	struct ring_buffer *rb;

	lockdep_assert_held(&event->mmap_mutex);
	WARN_ON(event->rb);

> +
> +	rb = rb_alloc(nr_pages,
> +		event->attr.watermark ? event->attr.wakeup_watermark : 0,
> +		event->cpu, flags);
> +	if (!rb)
> +		return -ENOMEM;
> +
> +	atomic_set(&rb->mmap_count, 1);
> +	ring_buffer_attach(event, rb);
> +	rcu_assign_pointer(event->rb, rb);
> +
> +	perf_event_init_userpage(event);
> +	perf_event_update_userpage(event);
> +
> +	return 0;
> +}
> +
> +/* Must be called with &event->mmap_mutex held. event->rb must be set. */
> +void perf_free_rb(struct perf_event *event)
> +{
> +	struct ring_buffer *rb = event->rb;

	lockdep_assert_held(&event->mmap_mutex);

> +	rcu_assign_pointer(event->rb, NULL);
> +	ring_buffer_detach(event, rb);
> +	ring_buffer_put(rb);
> +}
