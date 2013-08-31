Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab3HaTqQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 15:46:16 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35780 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab3HaTqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 15:46:15 -0400
Date: Sat, 31 Aug 2013 12:46:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 05/18 v2] ftrace: Do not display non safe RCU
 functions in available_filter_functions
Message-ID: <20130831194602.GM3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051701.256486055@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831051701.256486055@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083119-0320-0000-0000-000000DACE06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 01:11:22AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> As available_filter_functions file displays functions that are generally
> available for tracing, do not show the ones that are RCU unsafe. Otherwise
> it may be confusing for perf users to see these functions in this file but
> not be able to trace them.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/ftrace.h |    1 +
>  kernel/trace/ftrace.c  |    6 +++++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 1d17a82..4709264 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -411,6 +411,7 @@ enum {
>  	FTRACE_ITER_DO_HASH	= (1 << 3),
>  	FTRACE_ITER_HASH	= (1 << 4),
>  	FTRACE_ITER_ENABLED	= (1 << 5),
> +	FTRACE_ITER_NO_UNSAFE	= (1 << 6),
>  };
> 
>  void arch_ftrace_update_code(int command);
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 06504b2..be87ac9 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2645,7 +2645,10 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
>  		     !ftrace_lookup_ip(ops->notrace_hash, rec->ip)) ||
> 
>  		    ((iter->flags & FTRACE_ITER_ENABLED) &&
> -		     !(rec->flags & FTRACE_FL_ENABLED))) {
> +		     !(rec->flags & FTRACE_FL_ENABLED)) ||
> +

OK, I'll bite...  Why the blank line?

							Thanx, Paul

> +		    ((iter->flags & FTRACE_ITER_NO_UNSAFE) &&
> +		     ftrace_lookup_ip(ftrace_unsafe_rcu, rec->ip))) {
> 
>  			rec = NULL;
>  			goto retry;
> @@ -2773,6 +2776,7 @@ ftrace_avail_open(struct inode *inode, struct file *file)
>  	iter = __seq_open_private(file, &show_ftrace_seq_ops, sizeof(*iter));
>  	if (iter) {
>  		iter->pg = ftrace_pages_start;
> +		iter->flags = FTRACE_ITER_NO_UNSAFE;
>  		iter->ops = &global_ops;
>  	}
> 
> -- 
> 1.7.10.4
> 
> 

