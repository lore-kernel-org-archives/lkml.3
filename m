Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaGQSlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:41:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:55126 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751348AbaGQSlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 14:41:13 -0400
Date: Thu, 17 Jul 2014 14:41:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ftrace/core v3 2/3] ftrace, kprobes: Support IPMODIFY
 flag to find IP modify conflict
Message-ID: <20140717144110.0fb00723@gandalf.local.home>
In-Reply-To: <20140715060028.12195.33527.stgit@kbuild-fedora.novalocal>
References: <20140715060015.12195.74457.stgit@kbuild-fedora.novalocal>
	<20140715060028.12195.33527.stgit@kbuild-fedora.novalocal>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014 06:00:28 +0000
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Introduce FTRACE_OPS_FL_IPMODIFY to avoid conflict among
> ftrace users who may modify regs->ip to change the execution
> path. This also adds the flag to kprobe_ftrace_ops, since
> ftrace-based kprobes already modifies regs->ip. Thus, if
> another user modifies the regs->ip on the same function entry,
> one of them will be broken. So both should add IPMODIFY flag
> and make sure that ftrace_set_filter_ip() succeeds.
> 
> Note that currently conflicts of IPMODIFY are detected on the
> filter hash. It does NOT care about the notrace hash. This means
> that if you set filter hash all functions and notrace(mask)
> some of them, the IPMODIFY flag will be applied to all
> functions.

I would go a bit further (not in this patch, but in a separate patch),
that if ftrace_ops sets IPMODIFY, it must have a filter hash (non
global) *and* have nothing in the notrace hash. Modifying the ip is
dangerous, and it should only be done to a select few functions which
means there's no reason for having a notrace hash in existence.


> 
> Changes in v3:
>  - Update for the latest ftrace/core.
>  - Add a comment about FTRACE_OPS_FL_* attribute flags.
>  - Don't check FTRACE_OPS_FL_SAVE_REGS in
>    __ftrace_hash_update_ipmodify().
>  - Fix comments.
> 
> Changes in v2:
>  - Add a description how __ftrace_hash_update_ipmodify() will
>    handle the given hashes (NULL and EMPTY_HASH cases).
>  - Clear FTRACE_OPS_FL_ENABLED after calling
>    __unregister_ftrace_function() in error path.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> ---
>  Documentation/trace/ftrace.txt |    5 ++
>  include/linux/ftrace.h         |   15 ++++-
>  kernel/kprobes.c               |    2 -
>  kernel/trace/ftrace.c          |  132 +++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 149 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> index 2479b2a..0fcad7d 100644
> --- a/Documentation/trace/ftrace.txt
> +++ b/Documentation/trace/ftrace.txt
> @@ -234,6 +234,11 @@ of ftrace. Here is a list of some of the key files:
>  	will be displayed on the same line as the function that
>  	is returning registers.
>  
> +	If the callback registered to be traced by a function with
> +	the "ip modify" attribute (thus the regs->ip can be changed),
> +	a 'I' will be displayed on the same line as the function that

"an 'I' ..."

> +	can be overridden.
> +
>    function_profile_enabled:
>  
>  	When set it will enable all functions with either the function
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 11e18fd..daa0f7f 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -60,6 +60,11 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
>  /*
>   * FTRACE_OPS_FL_* bits denote the state of ftrace_ops struct and are
>   * set in the flags member.
> + * CONTROL, SAVE_REGS, SAVE_REGS_IF_SUPPORTED, RECURSION_SAFE, STUB and
> + * IPMODIFY are a kind of attribute flags which can set only before

"... which can be set ..."

> + * registering the ftrace_ops, and not able to update while registered.

"..., and can not be modified while registered."

> + * Changint those attribute flags after regsitering ftrace_ops will

s/Changint/Changing/

> + * cause unexpected results.
>   *
>   * ENABLED - set/unset when ftrace_ops is registered/unregistered
>   * DYNAMIC - set when ftrace_ops is registered to denote dynamically
> @@ -90,6 +95,9 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
>   * INITIALIZED - The ftrace_ops has already been initialized (first use time
>   *            register_ftrace_function() is called, it will initialized the ops)
>   * DELETED - The ops are being deleted, do not let them be registered again.
> + * IPMODIFY - The ops can modify IP register. This must be set with SAVE_REGS
> + *            and if the other ops has been set this on same function, filter
> + *            update must be failed.


"The ops can modify the IP register. This can only be set along with
SAVE_REGS. If another ops is already registered for any of the
functions that this ops will be registered for, then this ops will fail
to register."


>   */
>  enum {
>  	FTRACE_OPS_FL_ENABLED			= 1 << 0,
> @@ -101,6 +109,7 @@ enum {
>  	FTRACE_OPS_FL_STUB			= 1 << 6,
>  	FTRACE_OPS_FL_INITIALIZED		= 1 << 7,
>  	FTRACE_OPS_FL_DELETED			= 1 << 8,
> +	FTRACE_OPS_FL_IPMODIFY			= 1 << 9,
>  };
>  
>  /*
> @@ -312,6 +321,7 @@ extern int ftrace_nr_registered_ops(void);
>   *  ENABLED - the function is being traced
>   *  REGS    - the record wants the function to save regs
>   *  REGS_EN - the function is set up to save regs.
> + *  IPMODIFY - the record wants to change IP address.

maybe say "the record allows for the IP address to be changed"?

>   *
>   * When a new ftrace_ops is registered and wants a function to save
>   * pt_regs, the rec->flag REGS is set. When the function has been
> @@ -325,10 +335,11 @@ enum {
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
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 3214289..e52d86f 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c

I think this should be split into two patches. One that adds the ftrace
infrastructure, and the other that adds the kprobes user of the
IPMODIFY flag.

> @@ -915,7 +915,7 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
>  #ifdef CONFIG_KPROBES_ON_FTRACE
>  static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
>  	.func = kprobe_ftrace_handler,
> -	.flags = FTRACE_OPS_FL_SAVE_REGS,
> +	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_IPMODIFY,
>  };
>  static int kprobe_ftrace_enabled;
>  
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 45aac1a..c12a6de 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1295,6 +1295,9 @@ ftrace_hash_rec_disable(struct ftrace_ops *ops, int filter_hash);
>  static void
>  ftrace_hash_rec_enable(struct ftrace_ops *ops, int filter_hash);
>  
> +static int ftrace_hash_ipmodify_update(struct ftrace_ops *ops,
> +				       struct ftrace_hash *new_hash);
> +
>  static int
>  ftrace_hash_move(struct ftrace_ops *ops, int enable,
>  		 struct ftrace_hash **dst, struct ftrace_hash *src)
> @@ -1306,6 +1309,7 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
>  	struct ftrace_hash *new_hash;
>  	int size = src->count;
>  	int bits = 0;
> +	int ret;
>  	int i;
>  
>  	/*
> @@ -1341,6 +1345,16 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
>  	}
>  
>  update:

I wonder if we should also check here if the IPMODIFY flag is set that
the filter has has something other than all functions and has nothing
in the notrace part?

> +	/* Before everything, make sure this can be applied */
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
> @@ -1685,6 +1699,108 @@ static void ftrace_hash_rec_enable(struct ftrace_ops *ops,
>  	__ftrace_hash_rec_update(ops, filter_hash, 1);
>  }
>  
> +/*
> + * Try to update IPMODIFY flag on each ftrace_rec. Return 0 if it is OK
> + * or no-needed to update, -EBUSY if it detects a conflict of the flag
> + * on a ftrace_rec.
> + * Note that old_hash and new_hash has below meanings
> + *  - If the hash is NULL, it hits all recs
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

Again, if new_hash is NULL, then perhaps fail right away here. We
probably should require that a IPMODIFY flag requires that the callback
pick and choose its functions? Don't you think?

-- Steve

> +
> +	/* Update rec->flags */
> +	do_for_each_ftrace_rec(pg, rec) {
> +		/* We need to update only differences of filter_hash */
> +		in_old = !old_hash || ftrace_lookup_ip(old_hash, rec->ip);
> +		in_new = !new_hash || ftrace_lookup_ip(new_hash, rec->ip);
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
> +		in_old = !old_hash || ftrace_lookup_ip(old_hash, rec->ip);
> +		in_new = !new_hash || ftrace_lookup_ip(new_hash, rec->ip);
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
> +	struct ftrace_hash *hash = ops->filter_hash;
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
> +	struct ftrace_hash *hash = ops->filter_hash;
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
> +	struct ftrace_hash *old_hash = ops->filter_hash;
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
> +
>  static void print_ip_ins(const char *fmt, unsigned char *p)
>  {
>  	int i;
> @@ -2321,6 +2437,15 @@ static int ftrace_startup(struct ftrace_ops *ops, int command)
>  
>  	ops->flags |= FTRACE_OPS_FL_ENABLED;
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
> @@ -2347,6 +2472,8 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
>  	 */
>  	WARN_ON_ONCE(ftrace_start_up < 0);
>  
> +	/* Disabling ipmodify never fails */
> +	ftrace_hash_ipmodify_disable(ops);
>  	ftrace_hash_rec_disable(ops, 1);
>  
>  	ops->flags &= ~FTRACE_OPS_FL_ENABLED;
> @@ -2897,9 +3024,10 @@ static int t_show(struct seq_file *m, void *v)
>  
>  	seq_printf(m, "%ps", (void *)rec->ip);
>  	if (iter->flags & FTRACE_ITER_ENABLED) {
> -		seq_printf(m, " (%ld)%s",
> +		seq_printf(m, " (%ld)%s%s",
>  			   ftrace_rec_count(rec),
> -			   rec->flags & FTRACE_FL_REGS ? " R" : "  ");
> +			   rec->flags & FTRACE_FL_REGS ? " R" : "  ",
> +			   rec->flags & FTRACE_FL_IPMODIFY ? " I" : "  ");
>  		if (rec->flags & FTRACE_FL_TRAMP_EN) {
>  			struct ftrace_ops *ops;
>  
> 

