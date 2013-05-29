Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934960Ab3E2Bxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 21:53:47 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41564 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934826Ab3E2Bxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 21:53:46 -0400
Date: Tue, 28 May 2013 18:53:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] ftrace: Use the rcu _notrace variants for
 rcu_dereference_raw() and friends
Message-ID: <20130529015339.GX6172@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130528183841.535484906@goodmis.org>
 <20130528184209.467603904@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130528184209.467603904@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052901-4834-0000-0000-0000077D55A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 02:38:43PM -0400, Steven Rostedt wrote:
> As rcu_dereference_raw() under RCU debug config options can add quite a
> bit of checks, and that tracing uses rcu_dereference_raw(), these checks
> happen with the function tracer. The function tracer also happens to trace
> these debug checks too. This added overhead can livelock the system.
> 
> Have the function tracer use the new RCU _notrace equivalents that do
> not do the debug checks for RCU.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Looks good to me!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Index: linux-trace.git/kernel/trace/ftrace.c
> ===================================================================
> --- linux-trace.git.orig/kernel/trace/ftrace.c
> +++ linux-trace.git/kernel/trace/ftrace.c
> @@ -120,22 +120,22 @@ static void ftrace_ops_no_ops(unsigned l
> 
>  /*
>   * Traverse the ftrace_global_list, invoking all entries.  The reason that we
> - * can use rcu_dereference_raw() is that elements removed from this list
> + * can use rcu_dereference_raw_notrace() is that elements removed from this list
>   * are simply leaked, so there is no need to interact with a grace-period
> - * mechanism.  The rcu_dereference_raw() calls are needed to handle
> + * mechanism.  The rcu_dereference_raw_notrace() calls are needed to handle
>   * concurrent insertions into the ftrace_global_list.
>   *
>   * Silly Alpha and silly pointer-speculation compiler optimizations!
>   */
>  #define do_for_each_ftrace_op(op, list)			\
> -	op = rcu_dereference_raw(list);			\
> +	op = rcu_dereference_raw_notrace(list);			\
>  	do
> 
>  /*
>   * Optimized for just a single item in the list (as that is the normal case).
>   */
>  #define while_for_each_ftrace_op(op)				\
> -	while (likely(op = rcu_dereference_raw((op)->next)) &&	\
> +	while (likely(op = rcu_dereference_raw_notrace((op)->next)) &&	\
>  	       unlikely((op) != &ftrace_list_end))
> 
>  static inline void ftrace_ops_init(struct ftrace_ops *ops)
> @@ -779,7 +779,7 @@ ftrace_find_profiled_func(struct ftrace_
>  	if (hlist_empty(hhd))
>  		return NULL;
> 
> -	hlist_for_each_entry_rcu(rec, hhd, node) {
> +	hlist_for_each_entry_rcu_notrace(rec, hhd, node) {
>  		if (rec->ip == ip)
>  			return rec;
>  	}
> @@ -1165,7 +1165,7 @@ ftrace_lookup_ip(struct ftrace_hash *has
> 
>  	hhd = &hash->buckets[key];
> 
> -	hlist_for_each_entry_rcu(entry, hhd, hlist) {
> +	hlist_for_each_entry_rcu_notrace(entry, hhd, hlist) {
>  		if (entry->ip == ip)
>  			return entry;
>  	}
> @@ -1422,8 +1422,8 @@ ftrace_ops_test(struct ftrace_ops *ops, 
>  	struct ftrace_hash *notrace_hash;
>  	int ret;
> 
> -	filter_hash = rcu_dereference_raw(ops->filter_hash);
> -	notrace_hash = rcu_dereference_raw(ops->notrace_hash);
> +	filter_hash = rcu_dereference_raw_notrace(ops->filter_hash);
> +	notrace_hash = rcu_dereference_raw_notrace(ops->notrace_hash);
> 
>  	if ((ftrace_hash_empty(filter_hash) ||
>  	     ftrace_lookup_ip(filter_hash, ip)) &&
> @@ -2920,7 +2920,7 @@ static void function_trace_probe_call(un
>  	 * on the hash. rcu_read_lock is too dangerous here.
>  	 */
>  	preempt_disable_notrace();
> -	hlist_for_each_entry_rcu(entry, hhd, node) {
> +	hlist_for_each_entry_rcu_notrace(entry, hhd, node) {
>  		if (entry->ip == ip)
>  			entry->ops->func(ip, parent_ip, &entry->data);
>  	}
> 

