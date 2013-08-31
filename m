Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab3HaTqx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 15:46:53 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47601 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab3HaTqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 15:46:52 -0400
Date: Sat, 31 Aug 2013 12:46:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 06/18 v2] ftrace: Add rcu_unsafe_filter_functions
 file
Message-ID: <20130831194639.GN3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051701.452903571@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831051701.452903571@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083119-0320-0000-0000-000000DACE1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 01:11:23AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Since the RCU unsafe functions are no longer displayed by the
> available_filter_functions, we still need a way to see these
> functions in order to trace them. Create a new file that lists
> the functions that were declared RCU unsafe.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  include/linux/ftrace.h |    1 +
>  kernel/trace/ftrace.c  |   31 +++++++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 4709264..4752764 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -412,6 +412,7 @@ enum {
>  	FTRACE_ITER_HASH	= (1 << 4),
>  	FTRACE_ITER_ENABLED	= (1 << 5),
>  	FTRACE_ITER_NO_UNSAFE	= (1 << 6),
> +	FTRACE_ITER_UNSAFE_ONLY	= (1 << 7),
>  };
> 
>  void arch_ftrace_update_code(int command);
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index be87ac9..a3e4b71 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2647,6 +2647,9 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
>  		    ((iter->flags & FTRACE_ITER_ENABLED) &&
>  		     !(rec->flags & FTRACE_FL_ENABLED)) ||
> 
> +		    ((iter->flags & FTRACE_ITER_UNSAFE_ONLY) &&
> +		     !ftrace_lookup_ip(ftrace_unsafe_rcu, rec->ip)) ||
> +
>  		    ((iter->flags & FTRACE_ITER_NO_UNSAFE) &&
>  		     ftrace_lookup_ip(ftrace_unsafe_rcu, rec->ip))) {
> 
> @@ -2784,6 +2787,24 @@ ftrace_avail_open(struct inode *inode, struct file *file)
>  }
> 
>  static int
> +ftrace_rcu_unsafe_open(struct inode *inode, struct file *file)
> +{
> +	struct ftrace_iterator *iter;
> +
> +	if (unlikely(ftrace_disabled))
> +		return -ENODEV;
> +
> +	iter = __seq_open_private(file, &show_ftrace_seq_ops, sizeof(*iter));
> +	if (iter) {
> +		iter->pg = ftrace_pages_start;
> +		iter->flags = FTRACE_ITER_UNSAFE_ONLY;
> +		iter->ops = &global_ops;
> +	}
> +
> +	return iter ? 0 : -ENOMEM;
> +}
> +
> +static int
>  ftrace_enabled_open(struct inode *inode, struct file *file)
>  {
>  	struct ftrace_iterator *iter;
> @@ -3835,6 +3856,13 @@ static const struct file_operations ftrace_avail_fops = {
>  	.release = seq_release_private,
>  };
> 
> +static const struct file_operations ftrace_rcu_unsafe_fops = {
> +	.open = ftrace_rcu_unsafe_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = seq_release_private,
> +};
> +
>  static const struct file_operations ftrace_enabled_fops = {
>  	.open = ftrace_enabled_open,
>  	.read = seq_read,
> @@ -4071,6 +4099,9 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
>  	trace_create_file("available_filter_functions", 0444,
>  			d_tracer, NULL, &ftrace_avail_fops);
> 
> +	trace_create_file("rcu_unsafe_filter_functions", 0444,
> +			d_tracer, NULL, &ftrace_rcu_unsafe_fops);
> +
>  	trace_create_file("enabled_functions", 0444,
>  			d_tracer, NULL, &ftrace_enabled_fops);
> 
> -- 
> 1.7.10.4
> 
> 

