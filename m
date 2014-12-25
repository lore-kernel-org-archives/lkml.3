Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaLYXG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 18:06:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbaLYXGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 18:06:25 -0500
Date: Fri, 26 Dec 2014 00:05:52 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 14/37] perf tools: Convert dead thread list into rbtree
Message-ID: <20141225230552.GB15569@krava.redhat.com>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-15-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419405333-27952-15-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 04:15:10PM +0900, Namhyung Kim wrote:

SNIP

>  
>  static void machine__remove_thread(struct machine *machine, struct thread *th)
>  {
> +	struct rb_node **p = &machine->dead_threads.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct thread *pos;
> +
>  	machine->last_match = NULL;
>  	rb_erase(&th->rb_node, &machine->threads);
> +
> +	th->dead = true;
> +
>  	/*
>  	 * We may have references to this thread, for instance in some hist_entry
> -	 * instances, so just move them to a separate list.
> +	 * instances, so just move them to a separate list in rbtree.
>  	 */
> -	list_add_tail(&th->node, &machine->dead_threads);
> +	while (*p != NULL) {
> +		parent = *p;
> +		pos = rb_entry(parent, struct thread, rb_node);
> +
> +		if (pos->tid == th->tid) {
> +			list_add_tail(&th->node, &pos->node);
> +			return;
> +		}

hum, why is this 'new list' in thread object necessary? why not
to store all in the tree?


> +
> +		if (th->tid < pos->tid)
> +			p = &(*p)->rb_left;
> +		else
> +			p = &(*p)->rb_right;
> +	}
> +

SNIP

> diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
> index 0b6dcd70bc8b..413f28cf689b 100644
> --- a/tools/perf/util/thread.h
> +++ b/tools/perf/util/thread.h
> @@ -11,10 +11,8 @@
>  struct thread_stack;
>  
>  struct thread {
> -	union {
> -		struct rb_node	 rb_node;
> -		struct list_head node;
> -	};
> +	struct rb_node	 	rb_node;
> +	struct list_head 	node;
>  	struct map_groups	*mg;
>  	pid_t			pid_; /* Not all tools update this */
>  	pid_t			tid;
> @@ -22,7 +20,8 @@ struct thread {
>  	int			cpu;
>  	char			shortname[3];
>  	bool			comm_set;
> -	bool			dead; /* if set thread has exited */
> +	bool			exited; /* if set thread has exited */
> +	bool			dead; /* thread is in dead_threads list */

looks like this also changes the logic (new exited flag),
not just the dead threads storage wheel

jirka
