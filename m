Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaL0Pbl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 10:31:41 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35747 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaL0Pbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 10:31:40 -0500
Message-ID: <549ED0D8.1020505@gmail.com>
Date: Sat, 27 Dec 2014 08:31:36 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 14/37] perf tools: Convert dead thread list into rbtree
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org> <1419405333-27952-15-git-send-email-namhyung@kernel.org>
In-Reply-To: <1419405333-27952-15-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/14 12:15 AM, Namhyung Kim wrote:
> @@ -106,8 +117,8 @@ void machine__delete_threads(struct machine *machine)
>   	while (nd) {
>   		struct thread *t = rb_entry(nd, struct thread, rb_node);
>
> -		rb_erase(&t->rb_node, &machine->threads);
>   		nd = rb_next(nd);
> +		rb_erase(&t->rb_node, &machine->threads);
>   		thread__delete(t);
>   	}
>   }

unrelated to dead threads. Bug fix? separate patch?


> @@ -1236,13 +1247,36 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
>
>   static void machine__remove_thread(struct machine *machine, struct thread *th)
>   {
> +	struct rb_node **p = &machine->dead_threads.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct thread *pos;
> +
>   	machine->last_match = NULL;
>   	rb_erase(&th->rb_node, &machine->threads);
> +
> +	th->dead = true;
> +
>   	/*
>   	 * We may have references to this thread, for instance in some hist_entry
> -	 * instances, so just move them to a separate list.
> +	 * instances, so just move them to a separate list in rbtree.
>   	 */
> -	list_add_tail(&th->node, &machine->dead_threads);
> +	while (*p != NULL) {
> +		parent = *p;
> +		pos = rb_entry(parent, struct thread, rb_node);
> +
> +		if (pos->tid == th->tid) {
> +			list_add_tail(&th->node, &pos->node);
> +			return;
> +		}

So you have a linked list for tid collisions (not mentioned in the git log).

> +
> +		if (th->tid < pos->tid)
> +			p = &(*p)->rb_left;
> +		else
> +			p = &(*p)->rb_right;
> +	}
> +
> +	rb_link_node(&th->rb_node, parent, p);
> +	rb_insert_color(&th->rb_node, &machine->dead_threads);
>   }
>
>   int machine__process_fork_event(struct machine *machine, union perf_event *event,
> @@ -1649,7 +1683,7 @@ int machine__for_each_thread(struct machine *machine,

---8<---

> diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
> index 0b6dcd70bc8b..413f28cf689b 100644
> --- a/tools/perf/util/thread.h
> +++ b/tools/perf/util/thread.h
> @@ -11,10 +11,8 @@
>   struct thread_stack;
>
>   struct thread {
> -	union {
> -		struct rb_node	 rb_node;
> -		struct list_head node;
> -	};
> +	struct rb_node	 	rb_node;
> +	struct list_head 	node;
>   	struct map_groups	*mg;
>   	pid_t			pid_; /* Not all tools update this */
>   	pid_t			tid;

could use better names for rb_node and node. rb_node is the entry in the 
dead_threads tree - dead_node?; node is the linked list for tid 
collisions - tid_node?

David
