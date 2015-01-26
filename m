Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbbAZQOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:14:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbbAZQOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:14:43 -0500
Date: Mon, 26 Jan 2015 17:14:37 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vojtech Pavlik <vojtech@suse.cz>, Namhyung Kim <namhyung@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH ftrace/core v6 4/5] kprobes: Set IPMODIFY flag only if
 the probe can change regs->ip
Message-ID: <20150126161436.GC8244@dhcp128.suse.cz>
References: <20141121102502.11844.82696.stgit@localhost.localdomain>
 <20141121102530.11844.41626.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141121102530.11844.41626.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-21 05:25:30, Masami Hiramatsu wrote:
> Set FTRACE_OPS_FL_IPMODIFY flag only for the probes which can change
> regs->ip, which has kprobe->break_handler.
> Currently we can not put jprobe and another ftrace handler which
> changes regs->ip on the same function because all kprobes have
> FTRACE_OPS_FL_IPMODIFY flag. This removes FTRACE_OPS_FL_IPMODIFY
> flag from kprobes and only when the user uses jprobe (or the
> kprobe.break_handler != NULL) we add additinal ftrace_ops with
> FTRACE_OPS_FL_IPMODIFY on target function.

Please, what are the plans with this patch?

I have checked the interference between Kprobes and LivePatching and
here is my observation:

1. Jprobe and LivePatch must be in a hard conflict. They both need
   to change IP and continue another way after ftrace ops finishes.

   BTW: I wonder a bit why Jprobe handler could not be called directly
   from kprobe_ftrace_handler(). I guess that it is because we want
   to call the kprobe handler in a sane context: preemption and IRQs
   enabled, be able to use traced functions.


2. Normal Kprobe for the original function is ignored if the function
   is patched.

   I am working on a code that will print warning in both
   cases. First, when we add a patch and the function has
   a Kprobe registered. Second, the function is patched and
   we want to add Kprobe for the original version.

   I want to make it generic and make it dependent on the
   IPMODIFY flag. IMHO, it just could be a handshake between
   kprobe and ftrace code. I am still trying to understand
   the needed parts of the code ;-)


3. Kretprobe could live with a patch without a problem!

   The Kretprobe entry handler is called directly in
   kprobe_ftrace_handler() and does not change IP.
   On the other hand the LivePatch ftrace handler does
   not modify the return address because the return address
   is the same for the original and the patched function.

   Or did I miss something?

   This is where this patch might be useful. The other patches
   from this patch set are already in Linus' tree and I cannot
   find any information about this one.

   I could try to solve remaining problems if there are any.


Best Regards,
Petr

> Note about the implementation: This uses a dummy ftrace_ops to
> reserve IPMODIFY flag on the given ftrace address, for the case
> that we have a enabled kprobe on a function entry and a jprobe
> is added on the same point. In that case, we already have a
> ftrace_ops without IPMODIFY flag on the entry, and we have to
> add another ftrace_ops with IPMODIFY on the same address.
> If we put a same handler on both ftrace_ops, the handler can
> be called twice on that entry until the first one is removed.
> This means that the kprobe and the jprobe are called twice too,
> and that will not what kprobes expected.
> Thus I added a dummy ftrace_ops just for reserving IPMODIFY flag.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> ---
> Changes in v4:
>  - Increment refcounter after succeeded to register ftrace_ops.
> 
> Changes in v3:
>  - Update __ftrace_add/remove_filter_ip() according to
>    Namhyng's comments (thanks!)
>  - Split out regs->ip recovering code from this patch.
> ---
>  Documentation/kprobes.txt |   12 ++--
>  kernel/kprobes.c          |  125 +++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 114 insertions(+), 23 deletions(-)
> 
> diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
> index 4227ec2..eb03efc 100644
> --- a/Documentation/kprobes.txt
> +++ b/Documentation/kprobes.txt
> @@ -264,15 +264,13 @@ stop-machine method that ksplice uses for supporting a CONFIG_PREEMPT=y
>  kernel.
>  
>  NOTE for geeks:
> -The jump optimization changes the kprobe's pre_handler behavior.
> -Without optimization, the pre_handler can change the kernel's execution
> +The jump optimization (and ftrace-based kprobes) changes the kprobe's
> +pre_handler behavior.
> +Without optimizations, the pre_handler can change the kernel's execution
>  path by changing regs->ip and returning 1.  However, when the probe
>  is optimized, that modification is ignored.  Thus, if you want to
> -tweak the kernel's execution path, you need to suppress optimization,
> -using one of the following techniques:
> -- Specify an empty function for the kprobe's post_handler or break_handler.
> - or
> -- Execute 'sysctl -w debug.kprobes_optimization=n'
> +tweak the kernel's execution path, you need to suppress optimization or
> +notify your handler will modify regs->ip by setting p->break_handler.
>  
>  1.5 Blacklist
>  
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 831978c..4b4b7c5 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -915,10 +915,93 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
>  #ifdef CONFIG_KPROBES_ON_FTRACE
>  static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
>  	.func = kprobe_ftrace_handler,
> -	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_IPMODIFY,
> +	.flags = FTRACE_OPS_FL_SAVE_REGS,
>  };
>  static int kprobe_ftrace_enabled;
>  
> +static void kprobe_ftrace_stub(unsigned long a0, unsigned long a1,
> +			struct ftrace_ops *op, struct pt_regs *regs)
> +{
> +	/* Do nothing. This is just a dummy handler */
> +}
> +
> +/* This is only for checking conflict with other ftrace users */
> +static struct ftrace_ops kprobe_ipmod_ftrace_ops __read_mostly = {
> +	.func = kprobe_ftrace_stub,
> +	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_IPMODIFY,
> +};
> +static int kprobe_ipmod_ftrace_enabled;
> +
> +static int __ftrace_add_filter_ip(struct ftrace_ops *ops, unsigned long ip,
> +				  int *ref)
> +{
> +	int ret;
> +
> +	/* Try to set given ip to filter */
> +	ret = ftrace_set_filter_ip(ops, ip, 0, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (*ref == 0) {
> +		ret = register_ftrace_function(ops);
> +		if (ret < 0) {
> +			/* Rollback the filter */
> +			ftrace_set_filter_ip(ops, ip, 1, 0);
> +			goto out;
> +		}
> +	}
> +	(*ref)++;
> +
> +out:
> +	return ret;
> +}
> +
> +static int __ftrace_remove_filter_ip(struct ftrace_ops *ops, unsigned long ip,
> +				     int *ref)
> +{
> +	int ret;
> +
> +	if (*ref == 1) {
> +		ret = unregister_ftrace_function(ops);
> +		if (ret < 0)
> +			return ret;
> +		/*Ignore failure, because it is already unregistered */
> +		ftrace_set_filter_ip(ops, ip, 1, 0);
> +	} else {
> +		/* Try to remove given ip to filter */
> +		ret = ftrace_set_filter_ip(ops, ip, 1, 0);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	(*ref)--;
> +
> +	return 0;
> +}
> +
> +static int try_reserve_ftrace_ipmodify(struct kprobe *p)
> +{
> +	if (!p->break_handler)
> +		return 0;
> +
> +	return __ftrace_add_filter_ip(&kprobe_ipmod_ftrace_ops,
> +				      (unsigned long)p->addr,
> +				      &kprobe_ipmod_ftrace_enabled);
> +}
> +
> +static void release_ftrace_ipmodify(struct kprobe *p)
> +{
> +	int ret;
> +
> +	if (p->break_handler) {
> +		ret = __ftrace_remove_filter_ip(&kprobe_ipmod_ftrace_ops,
> +						(unsigned long)p->addr,
> +						&kprobe_ipmod_ftrace_enabled);
> +		WARN(ret < 0, "Failed to release ftrace at %p (%d)\n",
> +		     p->addr, ret);
> +	}
> +}
> +
>  /* Must ensure p->addr is really on ftrace */
>  static int prepare_kprobe(struct kprobe *p)
>  {
> @@ -933,14 +1016,10 @@ static void arm_kprobe_ftrace(struct kprobe *p)
>  {
>  	int ret;
>  
> -	ret = ftrace_set_filter_ip(&kprobe_ftrace_ops,
> -				   (unsigned long)p->addr, 0, 0);
> +	ret = __ftrace_add_filter_ip(&kprobe_ftrace_ops,
> +				     (unsigned long)p->addr,
> +				     &kprobe_ftrace_enabled);
>  	WARN(ret < 0, "Failed to arm kprobe-ftrace at %p (%d)\n", p->addr, ret);
> -	kprobe_ftrace_enabled++;
> -	if (kprobe_ftrace_enabled == 1) {
> -		ret = register_ftrace_function(&kprobe_ftrace_ops);
> -		WARN(ret < 0, "Failed to init kprobe-ftrace (%d)\n", ret);
> -	}
>  }
>  
>  /* Caller must lock kprobe_mutex */
> @@ -948,17 +1027,16 @@ static void disarm_kprobe_ftrace(struct kprobe *p)
>  {
>  	int ret;
>  
> -	kprobe_ftrace_enabled--;
> -	if (kprobe_ftrace_enabled == 0) {
> -		ret = unregister_ftrace_function(&kprobe_ftrace_ops);
> -		WARN(ret < 0, "Failed to init kprobe-ftrace (%d)\n", ret);
> -	}
> -	ret = ftrace_set_filter_ip(&kprobe_ftrace_ops,
> -			   (unsigned long)p->addr, 1, 0);
> -	WARN(ret < 0, "Failed to disarm kprobe-ftrace at %p (%d)\n", p->addr, ret);
> +	ret = __ftrace_remove_filter_ip(&kprobe_ftrace_ops,
> +					(unsigned long)p->addr,
> +					&kprobe_ftrace_enabled);
> +	WARN(ret < 0, "Failed to disarm kprobe-ftrace at %p (%d)\n",
> +	     p->addr, ret);
>  }
>  #else	/* !CONFIG_KPROBES_ON_FTRACE */
>  #define prepare_kprobe(p)	arch_prepare_kprobe(p)
> +#define try_reserve_ftrace_ipmodify(p)	(0)
> +#define release_ftrace_ipmodify(p)	do {} while (0)
>  #define arm_kprobe_ftrace(p)	do {} while (0)
>  #define disarm_kprobe_ftrace(p)	do {} while (0)
>  #endif
> @@ -1502,6 +1580,14 @@ int register_kprobe(struct kprobe *p)
>  	mutex_lock(&kprobe_mutex);
>  
>  	old_p = get_kprobe(p->addr);
> +
> +	/* Try to reserve ftrace ipmodify if needed */
> +	if (kprobe_ftrace(p) && (!old_p || !old_p->break_handler)) {
> +		ret = try_reserve_ftrace_ipmodify(p);
> +		if (ret < 0)
> +			goto out_noreserve;
> +	}
> +
>  	if (old_p) {
>  		/* Since this may unoptimize old_p, locking text_mutex. */
>  		ret = register_aggr_kprobe(old_p, p);
> @@ -1525,6 +1611,9 @@ int register_kprobe(struct kprobe *p)
>  	try_to_optimize_kprobe(p);
>  
>  out:
> +	if (ret < 0 && kprobe_ftrace(p))
> +		release_ftrace_ipmodify(p);
> +out_noreserve:
>  	mutex_unlock(&kprobe_mutex);
>  
>  	if (probed_mod)
> @@ -1639,6 +1728,10 @@ static void __unregister_kprobe_bottom(struct kprobe *p)
>  {
>  	struct kprobe *ap;
>  
> +	/* Release reserved ftrace ipmodify if needed */
> +	if (kprobe_ftrace(p))
> +		release_ftrace_ipmodify(p);
> +
>  	if (list_empty(&p->list))
>  		/* This is an independent kprobe */
>  		arch_remove_kprobe(p);
> 
> 
