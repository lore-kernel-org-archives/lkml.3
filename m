Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab3HaT3z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 15:29:55 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36934 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab3HaT3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 15:29:54 -0400
Date: Sat, 31 Aug 2013 12:29:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 02/18 v2] ftrace: Do not set ftrace records for
 unsafe RCU when not allowed
Message-ID: <20130831192940.GI3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051700.771674157@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831051700.771674157@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083119-0928-0000-0000-00000128CBFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 01:11:19AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> For the ftrace_ops that use RCU read locks, and can not be called by
> unsafe RCU functions (those outside of RCU tracking), have them not
> update the RCU unsafe function records when they are being registered
> or unregistered.
> 
> The ftrace function records store a counter of all the ftrace_ops
> callbacks that are hooked to the function the record represents.
> As unsafe RCU functions do not call callbacks that do not specify
> that they do not use RCU, do not update those records.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/trace/ftrace.c |   19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 3750360..d61f431 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1168,6 +1168,12 @@ static struct ftrace_page *ftrace_new_pgs;
>  static struct ftrace_page	*ftrace_pages_start;
>  static struct ftrace_page	*ftrace_pages;
> 
> +/*
> + * Hash of functions that are not safe to be called by
> + * callbacks that use RCU read locks.
> + */
> +static struct ftrace_hash *ftrace_unsafe_rcu;
> +
>  static bool ftrace_hash_empty(struct ftrace_hash *hash)
>  {
>  	return !hash || !hash->count;
> @@ -1638,6 +1644,7 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
>  {
>  	struct ftrace_hash *hash;
>  	struct ftrace_hash *other_hash;
> +	struct ftrace_hash *rcu_hash;
>  	struct ftrace_page *pg;
>  	struct dyn_ftrace *rec;
>  	int count = 0;
> @@ -1647,6 +1654,12 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
>  	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
>  		return;
> 
> +	/* Ignore rcu unsafe functions unless ops handles them */
> +	if (ops->flags & FTRACE_OPS_FL_RCU_SAFE)
> +		rcu_hash = NULL;
> +	else
> +		rcu_hash = ftrace_unsafe_rcu;
> +
>  	/*
>  	 * In the filter_hash case:
>  	 *   If the count is zero, we update all records.
> @@ -1680,6 +1693,10 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
>  		int in_hash = 0;
>  		int match = 0;
> 
> +		/* Ignore all in the rcu unsafe hash */
> +		if (ftrace_lookup_ip(rcu_hash, rec->ip))
> +			continue;
> +
>  		if (all) {
>  			/*
>  			 * Only the filter_hash affects all records.
> @@ -4291,8 +4308,6 @@ struct notifier_block ftrace_module_exit_nb = {
>  extern struct ftrace_func_finder *__start_ftrace_unsafe_rcu[];
>  extern struct ftrace_func_finder *__stop_ftrace_unsafe_rcu[];
> 
> -static struct ftrace_hash *ftrace_unsafe_rcu;
> -
>  static void __init create_unsafe_rcu_hash(void)
>  {
>  	struct ftrace_func_finder *finder;
> -- 
> 1.7.10.4
> 
> 

