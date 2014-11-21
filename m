Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751058AbaKUSFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:05:35 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:57519 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750704AbaKUSFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:05:33 -0500
Date: Fri, 21 Nov 2014 13:05:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH ftrace/core v6 2/5] ftrace, kprobes: Support IPMODIFY
 flag to find IP modify conflict
Message-ID: <20141121130529.316989d8@gandalf.local.home>
In-Reply-To: <20141121102516.11844.27829.stgit@localhost.localdomain>
References: <20141121102502.11844.82696.stgit@localhost.localdomain>
	<20141121102516.11844.27829.stgit@localhost.localdomain>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014 05:25:16 -0500
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

>  Documentation/trace/ftrace.txt |    5 +
>  include/linux/ftrace.h         |   16 ++++-
>  kernel/trace/ftrace.c          |  142 +++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 159 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> index 4da4261..f10f5f5 100644
> --- a/Documentation/trace/ftrace.txt
> +++ b/Documentation/trace/ftrace.txt
> @@ -234,6 +234,11 @@ of ftrace. Here is a list of some of the key files:
>  	will be displayed on the same line as the function that
>  	is returning registers.
>  
> +	If the callback registered to be traced by a function with
> +	the "ip modify" attribute (thus the regs->ip can be changed),
> +	an 'I' will be displayed on the same line as the function that
> +	can be overridden.
> +
>    function_profile_enabled:
>  
>  	When set it will enable all functions with either the function
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 7b2616f..93cf047 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -61,6 +61,11 @@ ftrace_func_t ftrace_ops_get_func(struct ftrace_ops *ops);
>  /*
>   * FTRACE_OPS_FL_* bits denote the state of ftrace_ops struct and are
>   * set in the flags member.
> + * CONTROL, SAVE_REGS, SAVE_REGS_IF_SUPPORTED, RECURSION_SAFE, STUB and
> + * IPMODIFY are a kind of attribute flags which can be set only before
> + * registering the ftrace_ops, and can not be modified while registered.
> + * Changing those attribute flags after regsitering ftrace_ops will
> + * cause unexpected results.
>   *
>   * ENABLED - set/unset when ftrace_ops is registered/unregistered
>   * DYNAMIC - set when ftrace_ops is registered to denote dynamically
> @@ -101,6 +106,10 @@ ftrace_func_t ftrace_ops_get_func(struct ftrace_ops *ops);
>   *            The ftrace_ops trampoline can be set by the ftrace users, and
>   *            in such cases the arch must not modify it. Only the arch ftrace
>   *            core code should set this flag.
> + * IPMODIFY - The ops can modify the IP register. This can only be set with
> + *            SAVE_REGS. If another ops is already registered for any of the
> + *            functions that this ops will be registered for, then this ops
> + *            will fail to register or set_filter_ip.

It's blocked by any ops sharing the same function, or just another ops
with this flag set? The comment doesn't specify. The code looks like
the latter.


>   */
>  enum {
>  	FTRACE_OPS_FL_ENABLED			= 1 << 0,
> @@ -116,6 +125,7 @@ enum {
>  	FTRACE_OPS_FL_REMOVING			= 1 << 10,
>  	FTRACE_OPS_FL_MODIFYING			= 1 << 11,
>  	FTRACE_OPS_FL_ALLOC_TRAMP		= 1 << 12,
> +	FTRACE_OPS_FL_IPMODIFY			= 1 << 13,
>  };
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE
> @@ -310,6 +320,7 @@ bool is_ftrace_trampoline(unsigned long addr);
>   *  ENABLED - the function is being traced
>   *  REGS    - the record wants the function to save regs
>   *  REGS_EN - the function is set up to save regs.
> + *  IPMODIFY - the record allows for the IP address to be changed.
>   *
>   * When a new ftrace_ops is registered and wants a function to save
>   * pt_regs, the rec->flag REGS is set. When the function has been
> @@ -323,10 +334,11 @@ enum {
>  	FTRACE_FL_REGS_EN	= (1UL << 29),
>  	FTRACE_FL_TRAMP		= (1UL << 28),
>  	FTRACE_FL_TRAMP_EN	= (1UL << 27),
> +	FTRACE_FL_IPMODIFY	= (1UL << 26),
>  };
>  
> -#define FTRACE_REF_MAX_SHIFT	27
> -#define FTRACE_FL_BITS		5
> +#define FTRACE_REF_MAX_SHIFT	26
> +#define FTRACE_FL_BITS		6
>  #define FTRACE_FL_MASKED_BITS	((1UL << FTRACE_FL_BITS) - 1)
>  #define FTRACE_FL_MASK		(FTRACE_FL_MASKED_BITS << FTRACE_REF_MAX_SHIFT)
>  #define FTRACE_REF_MAX		((1UL << FTRACE_REF_MAX_SHIFT) - 1)
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index fa0f36b..baa2c4d 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1358,6 +1358,9 @@ ftrace_hash_rec_disable_modify(struct ftrace_ops *ops, int filter_hash);
>  static void
>  ftrace_hash_rec_enable_modify(struct ftrace_ops *ops, int filter_hash);
>  
> +static int ftrace_hash_ipmodify_update(struct ftrace_ops *ops,
> +				       struct ftrace_hash *new_hash);
> +
>  static int
>  ftrace_hash_move(struct ftrace_ops *ops, int enable,
>  		 struct ftrace_hash **dst, struct ftrace_hash *src)
> @@ -1368,8 +1371,13 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
>  	struct ftrace_hash *new_hash;
>  	int size = src->count;
>  	int bits = 0;
> +	int ret;
>  	int i;
>  
> +	/* Reject setting notrace hash on IPMODIFY ftrace_ops */
> +	if (ops->flags & FTRACE_OPS_FL_IPMODIFY && !enable)
> +		return -EINVAL;
> +
>  	/*
>  	 * If the new source is empty, just free dst and assign it
>  	 * the empty_hash.
> @@ -1403,6 +1411,16 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
>  	}
>  
>  update:
> +	/* Make sure this can be applied if it is IPMODIFY ftrace_ops */
> +	if (enable) {
> +		/* IPMODIFY should be updated only when filter_hash updating */
> +		ret = ftrace_hash_ipmodify_update(ops, new_hash);
> +		if (ret < 0) {
> +			free_ftrace_hash(new_hash);
> +			return ret;
> +		}
> +	}
> +
>  	/*
>  	 * Remove the current set, update the hash and add
>  	 * them back.
> @@ -1767,6 +1785,114 @@ static void ftrace_hash_rec_enable_modify(struct ftrace_ops *ops,
>  	ftrace_hash_rec_update_modify(ops, filter_hash, 1);
>  }
>  
> +/*
> + * Try to update IPMODIFY flag on each ftrace_rec. Return 0 if it is OK
> + * or no-needed to update, -EBUSY if it detects a conflict of the flag
> + * on a ftrace_rec, and -EINVAL if the new_hash tries to trace all recs.
> + * Note that old_hash and new_hash has below meanings
> + *  - If the hash is NULL, it hits all recs (if IPMODIFY is set, this is rejected)
> + *  - If the hash is EMPTY_HASH, it hits nothing
> + *  - Anything else hits the recs which match the hash entries.
> + */
> +static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
> +					 struct ftrace_hash *old_hash,
> +					 struct ftrace_hash *new_hash)
> +{
> +	struct ftrace_page *pg;
> +	struct dyn_ftrace *rec, *end = NULL;
> +	int in_old, in_new;
> +
> +	/* Only update if the ops has been registered */
> +	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
> +		return 0;
> +
> +	if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY))
> +		return 0;
> +
> +	/*
> +	 * Since the IPMODIFY is very address sensitive action, we do not allow

 is *a* very address sensitive action

The rest looks good.

-- Steve

> +	 * ftrace_ops to set all functions to new hash.
> +	 */
> +	if (!new_hash || !old_hash)
> +		return -EINVAL;
> +
> +	/* Update rec->flags */
> +	do_for_each_ftrace_rec(pg, rec) {
> +		/* We need to update only differences of filter_hash */
> +		in_old = !!ftrace_lookup_ip(old_hash, rec->ip);
> +		in_new = !!ftrace_lookup_ip(new_hash, rec->ip);
> +		if (in_old == in_new)
> +			continue;
> +
> +		if (in_new) {
> +			/* New entries must ensure no others are using it */
> +			if (rec->flags & FTRACE_FL_IPMODIFY)
> +				goto rollback;
> +			rec->flags |= FTRACE_FL_IPMODIFY;
> +		} else /* Removed entry */
> +			rec->flags &= ~FTRACE_FL_IPMODIFY;
> +	} while_for_each_ftrace_rec();
> +
> +	return 0;
> +
> +rollback:
> +	end = rec;
> +
> +	/* Roll back what we did above */
> +	do_for_each_ftrace_rec(pg, rec) {
> +		if (rec == end)
> +			goto err_out;
> +
> +		in_old = !!ftrace_lookup_ip(old_hash, rec->ip);
> +		in_new = !!ftrace_lookup_ip(new_hash, rec->ip);
> +		if (in_old == in_new)
> +			continue;
> +
> +		if (in_new)
> +			rec->flags &= ~FTRACE_FL_IPMODIFY;
> +		else
> +			rec->flags |= FTRACE_FL_IPMODIFY;
> +	} while_for_each_ftrace_rec();
> +
> +err_out:
> +	return -EBUSY;
> +}
> +
> +static int ftrace_hash_ipmodify_enable(struct ftrace_ops *ops)
> +{
> +	struct ftrace_hash *hash = ops->func_hash->filter_hash;
> +
> +	if (ftrace_hash_empty(hash))
> +		hash = NULL;
> +
> +	return __ftrace_hash_update_ipmodify(ops, EMPTY_HASH, hash);
> +}
> +
> +/* Disabling always succeeds */
> +static void ftrace_hash_ipmodify_disable(struct ftrace_ops *ops)
> +{
> +	struct ftrace_hash *hash = ops->func_hash->filter_hash;
> +
> +	if (ftrace_hash_empty(hash))
> +		hash = NULL;
> +
> +	__ftrace_hash_update_ipmodify(ops, hash, EMPTY_HASH);
> +}
> +
> +static int ftrace_hash_ipmodify_update(struct ftrace_ops *ops,
> +				       struct ftrace_hash *new_hash)
> +{
> +	struct ftrace_hash *old_hash = ops->func_hash->filter_hash;
> +
> +	if (ftrace_hash_empty(old_hash))
> +		old_hash = NULL;
> +
> +	if (ftrace_hash_empty(new_hash))
> +		new_hash = NULL;
> +
> +	return __ftrace_hash_update_ipmodify(ops, old_hash, new_hash);
> +}
> +
>  static void print_ip_ins(const char *fmt, unsigned char *p)
>  {
>  	int i;
> @@ -2436,6 +2562,15 @@ static int ftrace_startup(struct ftrace_ops *ops, int command)
>  	 */
>  	ops->flags |= FTRACE_OPS_FL_ENABLED | FTRACE_OPS_FL_ADDING;
>  
> +	ret = ftrace_hash_ipmodify_enable(ops);
> +	if (ret < 0) {
> +		/* Rollback registration process */
> +		__unregister_ftrace_function(ops);
> +		ftrace_start_up--;
> +		ops->flags &= ~FTRACE_OPS_FL_ENABLED;
> +		return ret;
> +	}
> +
>  	ftrace_hash_rec_enable(ops, 1);
>  
>  	ftrace_startup_enable(command);
> @@ -2464,6 +2599,8 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
>  	 */
>  	WARN_ON_ONCE(ftrace_start_up < 0);
>  
> +	/* Disabling ipmodify never fails */
> +	ftrace_hash_ipmodify_disable(ops);
>  	ftrace_hash_rec_disable(ops, 1);
>  
>  	ops->flags &= ~FTRACE_OPS_FL_ENABLED;
> @@ -3058,9 +3195,10 @@ static int t_show(struct seq_file *m, void *v)
>  	if (iter->flags & FTRACE_ITER_ENABLED) {
>  		struct ftrace_ops *ops = NULL;
>  
> -		seq_printf(m, " (%ld)%s",
> +		seq_printf(m, " (%ld)%s%s",
>  			   ftrace_rec_count(rec),
> -			   rec->flags & FTRACE_FL_REGS ? " R" : "  ");
> +			   rec->flags & FTRACE_FL_REGS ? " R" : "  ",
> +			   rec->flags & FTRACE_FL_IPMODIFY ? " I" : "  ");
>  		if (rec->flags & FTRACE_FL_TRAMP_EN) {
>  			ops = ftrace_find_tramp_ops_any(rec);
>  			if (ops)
> 

