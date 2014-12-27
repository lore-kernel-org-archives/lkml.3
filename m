Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbaL0QdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 11:33:20 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36392 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaL0QdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 11:33:18 -0500
Message-ID: <549EDF47.6050903@gmail.com>
Date: Sat, 27 Dec 2014 09:33:11 -0700
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
Subject: Re: [PATCH 15/37] perf tools: Introduce machine__find*_thread_time()
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org> <1419405333-27952-16-git-send-email-namhyung@kernel.org>
In-Reply-To: <1419405333-27952-16-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/14 12:15 AM, Namhyung Kim wrote:
> @@ -61,12 +61,12 @@ static int unwind_entry(struct unwind_entry *entry, void *arg)
>   __attribute__ ((noinline))
>   static int unwind_thread(struct thread *thread)
>   {
> -	struct perf_sample sample;
> +	struct perf_sample sample = {
> +		.time = -1ULL,
> +	};

1-liner like the others?



> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 582e011adc92..2cc088d71922 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -431,6 +431,103 @@ struct thread *machine__find_thread(struct machine *machine, pid_t pid,
>   	return __machine__findnew_thread(machine, pid, tid, false);
>   }
>
> +static void machine__remove_thread(struct machine *machine, struct thread *th);

Why is this declaration needed?

> +
> +static struct thread *__machine__findnew_thread_time(struct machine *machine,
> +						     pid_t pid, pid_t tid,
> +						     u64 timestamp, bool create)
> +{
> +	struct thread *curr, *pos, *new;
> +	struct thread *th = NULL;
> +	struct rb_node **p;
> +	struct rb_node *parent = NULL;
> +	bool initial = timestamp == (u64)0;
> +
> +	curr = __machine__findnew_thread(machine, pid, tid, initial);

What if create arg is false? Should initial arg also be false?

> +	if (curr && timestamp >= curr->start_time)
> +		return curr;
> +
> +	p = &machine->dead_threads.rb_node;
> +	while (*p != NULL) {
> +		parent = *p;
> +		th = rb_entry(parent, struct thread, rb_node);
> +
> +		if (th->tid == tid) {
> +			list_for_each_entry(pos, &th->node, node) {
> +				if (timestamp >= pos->start_time &&
> +				    pos->start_time > th->start_time) {
> +					th = pos;
> +					break;
> +				}
> +			}
> +
> +			if (timestamp >= th->start_time) {
> +				machine__update_thread_pid(machine, th, pid);
> +				return th;
> +			}
> +			break;
> +		}
> +
> +		if (tid < th->tid)
> +			p = &(*p)->rb_left;
> +		else
> +			p = &(*p)->rb_right;
> +	}

Can the dead_threads search be put in a separate function -- 
machine__find_dead_thread?

> +
> +	if (!create)
> +		return NULL;
> +
> +	if (!curr)
> +		return __machine__findnew_thread(machine, pid, tid, true);
> +
> +	new = thread__new(pid, tid);
> +	if (new == NULL)
> +		return NULL;
> +
> +	new->start_time = timestamp;
> +
> +	if (*p) {
> +		list_for_each_entry(pos, &th->node, node) {
> +			/* sort by time */
> +			if (timestamp >= pos->start_time) {
> +				th = pos;
> +				break;
> +			}
> +		}
> +		list_add_tail(&new->node, &th->node);
> +	} else {
> +		rb_link_node(&new->rb_node, parent, p);
> +		rb_insert_color(&new->rb_node, &machine->dead_threads);
> +	}

Why insert this unknown tid on the dead_threads list?

> +
> +	/*
> +	 * We have to initialize map_groups separately
> +	 * after rb tree is updated.
> +	 *
> +	 * The reason is that we call machine__findnew_thread
> +	 * within thread__init_map_groups to find the thread
> +	 * leader and that would screwed the rb tree.
> +	 */
> +	if (thread__init_map_groups(new, machine)) {
> +		thread__delete(new);
> +		return NULL;
> +	}
> +
> +	return new;
> +}

---8<---

> @@ -1265,6 +1362,16 @@ static void machine__remove_thread(struct machine *machine, struct thread *th)
>   		pos = rb_entry(parent, struct thread, rb_node);
>
>   		if (pos->tid == th->tid) {
> +			struct thread *old;
> +
> +			/* sort by time */
> +			list_for_each_entry(old, &pos->node, node) {
> +				if (th->start_time >= old->start_time) {
> +					pos = old;
> +					break;
> +				}
> +			}
> +

this change seems unrelated to the patch subject -- 
machine__find*_thread_time.

David
