Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbaDQOks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:40:48 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52616 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaDQOkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:40:45 -0400
X-Originating-IP: 50.43.32.211
Date: Thu, 17 Apr 2014 07:40:30 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH -tip v9 17/26] notifier: Use NOKPROBE_SYMBOL macro in
 notifier
Message-ID: <20140417144030.GA23089@leaf>
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140417081835.26341.56128.stgit@ltc230.yrl.intra.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417081835.26341.56128.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 05:18:35PM +0900, Masami Hiramatsu wrote:
> Use NOKPROBE_SYMBOL macro to protect functions from
> kprobes instead of __kprobes annotation in notifier.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/notifier.c |   22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/notifier.c b/kernel/notifier.c
> index db4c8b0..4803da6 100644
> --- a/kernel/notifier.c
> +++ b/kernel/notifier.c
> @@ -71,9 +71,9 @@ static int notifier_chain_unregister(struct notifier_block **nl,
>   *	@returns:	notifier_call_chain returns the value returned by the
>   *			last notifier function called.
>   */
> -static int __kprobes notifier_call_chain(struct notifier_block **nl,
> -					unsigned long val, void *v,
> -					int nr_to_call,	int *nr_calls)
> +static int notifier_call_chain(struct notifier_block **nl,
> +			       unsigned long val, void *v,
> +			       int nr_to_call, int *nr_calls)
>  {
>  	int ret = NOTIFY_DONE;
>  	struct notifier_block *nb, *next_nb;
> @@ -102,6 +102,7 @@ static int __kprobes notifier_call_chain(struct notifier_block **nl,
>  	}
>  	return ret;
>  }
> +NOKPROBE_SYMBOL(notifier_call_chain);
>  
>  /*
>   *	Atomic notifier chain routines.  Registration and unregistration
> @@ -172,9 +173,9 @@ EXPORT_SYMBOL_GPL(atomic_notifier_chain_unregister);
>   *	Otherwise the return value is the return value
>   *	of the last notifier function called.
>   */
> -int __kprobes __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
> -					unsigned long val, void *v,
> -					int nr_to_call, int *nr_calls)
> +int __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
> +				 unsigned long val, void *v,
> +				 int nr_to_call, int *nr_calls)
>  {
>  	int ret;
>  
> @@ -184,13 +185,15 @@ int __kprobes __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(__atomic_notifier_call_chain);
> +NOKPROBE_SYMBOL(__atomic_notifier_call_chain);
>  
> -int __kprobes atomic_notifier_call_chain(struct atomic_notifier_head *nh,
> -		unsigned long val, void *v)
> +int atomic_notifier_call_chain(struct atomic_notifier_head *nh,
> +			       unsigned long val, void *v)
>  {
>  	return __atomic_notifier_call_chain(nh, val, v, -1, NULL);
>  }
>  EXPORT_SYMBOL_GPL(atomic_notifier_call_chain);
> +NOKPROBE_SYMBOL(atomic_notifier_call_chain);
>  
>  /*
>   *	Blocking notifier chain routines.  All access to the chain is
> @@ -527,7 +530,7 @@ EXPORT_SYMBOL_GPL(srcu_init_notifier_head);
>  
>  static ATOMIC_NOTIFIER_HEAD(die_chain);
>  
> -int notrace __kprobes notify_die(enum die_val val, const char *str,
> +int notrace notify_die(enum die_val val, const char *str,
>  	       struct pt_regs *regs, long err, int trap, int sig)
>  {
>  	struct die_args args = {
> @@ -540,6 +543,7 @@ int notrace __kprobes notify_die(enum die_val val, const char *str,
>  	};
>  	return atomic_notifier_call_chain(&die_chain, val, &args);
>  }
> +NOKPROBE_SYMBOL(notify_die);
>  
>  int register_die_notifier(struct notifier_block *nb)
>  {
> 
> 
