Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbaFXKkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:40:00 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50713 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbaFXKj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:39:57 -0400
Date: Tue, 24 Jun 2014 12:39:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/3] perf: Do not allow optimized switch for non-cloned
 events
Message-ID: <20140624103936.GK19860@laptop.programming.kicks-ass.net>
References: <1403598026-2310-1-git-send-email-jolsa@kernel.org>
 <1403598026-2310-2-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403598026-2310-2-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 10:20:25AM +0200, Jiri Olsa wrote:
> From: Jiri Olsa <jolsa@redhat.com>
> 
> The context check in perf_event_context_sched_out allows
> non-cloned context to be part of the optimized schedule
> out switch.
> 
> This could move non-cloned context into another workload
> child. Once this child exits, the context is closed and
> leaves all original (parent) events in closed state.
> 
> Any other new cloned event will have closed state and not
> measure anything. And probably causing other odd bugs.
> 
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/events/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index d968008..4e3618e 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -2319,7 +2319,7 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
>  	next_parent = rcu_dereference(next_ctx->parent_ctx);
>  
>  	/* If neither context have a parent context; they cannot be clones. */
> -	if (!parent && !next_parent)
> +	if (!parent || !next_parent)
>  		goto unlock;
>  
>  	if (next_parent == ctx || next_ctx == parent || next_parent == parent) {

Ohh, nice, good catch!

Thanks
