Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934956Ab3E2Buw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 21:50:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:50452 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934525Ab3E2Buv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 21:50:51 -0400
Date: Tue, 28 May 2013 18:50:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] rcu: Add _notrace variation of rcu_dereference_raw()
 and hlist_for_each_entry_rcu()
Message-ID: <20130529015035.GW6172@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130528183841.535484906@goodmis.org>
 <20130528184209.304356745@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130528184209.304356745@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052901-4834-0000-0000-0000077D5282
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 02:38:42PM -0400, Steven Rostedt wrote:
> As rcu_dereference_raw() under RCU debug config options can add quite a
> bit of checks, and that tracing uses rcu_dereference_raw(), these checks
> happen with the function tracer. The function tracer also happens to trace
> these debug checks too. This added overhead can livelock the system.
> 
> Add a new interface to RCU for both rcu_dereference_raw_notrace() as well
> as hlist_for_each_entry_rcu_notrace() as the hlist iterator uses the
> rcu_dereference_raw() as well, and is used a bit with the function tracer.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Much nicer!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Index: linux-trace.git/include/linux/rculist.h
> ===================================================================
> --- linux-trace.git.orig/include/linux/rculist.h
> +++ linux-trace.git/include/linux/rculist.h
> @@ -461,6 +461,26 @@ static inline void hlist_add_after_rcu(s
>  			&(pos)->member)), typeof(*(pos)), member))
> 
>  /**
> + * hlist_for_each_entry_rcu_notrace - iterate over rcu list of given type (for tracing)
> + * @pos:	the type * to use as a loop cursor.
> + * @head:	the head for your list.
> + * @member:	the name of the hlist_node within the struct.
> + *
> + * This list-traversal primitive may safely run concurrently with
> + * the _rcu list-mutation primitives such as hlist_add_head_rcu()
> + * as long as the traversal is guarded by rcu_read_lock().
> + *
> + * This is the same as hlist_for_each_entry_rcu() except that it does
> + * not do any RCU debugging or tracing.
> + */
> +#define hlist_for_each_entry_rcu_notrace(pos, head, member)			\
> +	for (pos = hlist_entry_safe (rcu_dereference_raw_notrace(hlist_first_rcu(head)),\
> +			typeof(*(pos)), member);			\
> +		pos;							\
> +		pos = hlist_entry_safe(rcu_dereference_raw_notrace(hlist_next_rcu(\
> +			&(pos)->member)), typeof(*(pos)), member))
> +
> +/**
>   * hlist_for_each_entry_rcu_bh - iterate over rcu list of given type
>   * @pos:	the type * to use as a loop cursor.
>   * @head:	the head for your list.
> Index: linux-trace.git/include/linux/rcupdate.h
> ===================================================================
> --- linux-trace.git.orig/include/linux/rcupdate.h
> +++ linux-trace.git/include/linux/rcupdate.h
> @@ -640,6 +640,15 @@ static inline void rcu_preempt_sleep_che
> 
>  #define rcu_dereference_raw(p) rcu_dereference_check(p, 1) /*@@@ needed? @@@*/
> 
> +/*
> + * The tracing infrastructure traces RCU (we want that), but unfortunately
> + * some of the RCU checks causes tracing to lock up the system.
> + *
> + * The tracing version of rcu_dereference_raw() must not call
> + * rcu_read_lock_held().
> + */
> +#define rcu_dereference_raw_notrace(p) __rcu_dereference_check((p), 1, __rcu)
> +
>  /**
>   * rcu_access_index() - fetch RCU index with no dereferencing
>   * @p: The index to read
> 

