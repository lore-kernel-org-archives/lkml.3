Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbaDVNlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:41:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:21070 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756124AbaDVNlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:41:06 -0400
Date: Tue, 22 Apr 2014 09:41:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: ftrace/kprobes: Warning when insmod two modules
Message-ID: <20140422094103.39488700@gandalf.local.home>
In-Reply-To: <87bnvunhs9.fsf@rustcorp.com.au>
References: <1395637826-3312-1-git-send-email-indou.takao@jp.fujitsu.com>
	<5330164D.6030507@hitachi.com>
	<20140324105939.7f823b81@gandalf.local.home>
	<87bnvunhs9.fsf@rustcorp.com.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014 13:21:18 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:


> Sorry, was on paternity leave.

Congratulations! Although having two teenage daughters myself, I'm more
inclined to say "my condolences".

> 
> I'm always nervous about adding more states, since every place which
> examines the state has to be audited.

I didn't really add a state but instead broke an existing state into
two. More importantly, this second part of the state doesn't get
exported to other parts of the kernel. That is, there is no notifier
for it.

This means the only place you need to audit is in module.c itself. Any
other change requires auditing all module notifiers.


> 
> We set the mod->state to MOD_STATE_COMING in complete_formation;
> why don't we set NX there instead?  It also makes more sense to
> set NX before we hit parse_args() which can execute code in the module.

Well, NX is a different issue here all together. Sure if you want to,
but that wont affect this.

> 
> In fact, we should probably call the notifier there too, so people
> can breakpoint/tracepoint/etc parameter calls.
> 
> Of course, this means that we set NX before the notifier; does anything
> break?
> 
> Subject: module: set nx before marking module MODULE_STATE_COMING.
> 
> This prevents a WARN_ON() where ftrace calls set_all_modules_text_ro()
> which races with the module setting its own set_section_ro_nx().
> 
> It also means we're NX protected before we call parse_args(), which
> can execute module code.
> 
> This means that the notifiers will be called on a module which
> is already NX, so that may cause problems.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 11869408f79b..83a437e5d429 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3023,21 +3023,6 @@ static int do_init_module(struct module *mod)
>  	 */
>  	current->flags &= ~PF_USED_ASYNC;
>  
> -	blocking_notifier_call_chain(&module_notify_list,
> -			MODULE_STATE_COMING, mod);
> -
> -	/* Set RO and NX regions for core */
> -	set_section_ro_nx(mod->module_core,
> -				mod->core_text_size,
> -				mod->core_ro_size,
> -				mod->core_size);
> -
> -	/* Set RO and NX regions for init */
> -	set_section_ro_nx(mod->module_init,
> -				mod->init_text_size,
> -				mod->init_ro_size,
> -				mod->init_size);
> -
>  	do_mod_ctors(mod);
>  	/* Start the module */
>  	if (mod->init != NULL)
> @@ -3168,9 +3153,26 @@ static int complete_formation(struct module *mod, struct load_info *info)
>  	/* This relies on module_mutex for list integrity. */
>  	module_bug_finalize(info->hdr, info->sechdrs, mod);
>  
> +	/* Set RO and NX regions for core */
> +	set_section_ro_nx(mod->module_core,
> +				mod->core_text_size,
> +				mod->core_ro_size,
> +				mod->core_size);
> +
> +	/* Set RO and NX regions for init */
> +	set_section_ro_nx(mod->module_init,
> +				mod->init_text_size,
> +				mod->init_ro_size,
> +				mod->init_size);
> +
>  	/* Mark state as coming so strong_try_module_get() ignores us,
>  	 * but kallsyms etc. can see us. */
>  	mod->state = MODULE_STATE_COMING;
> +	mutex_unlock(&module_mutex);
> +
> +	blocking_notifier_call_chain(&module_notify_list,
> +				     MODULE_STATE_COMING, mod);

Here we break ftrace. ftrace expects that it can still replaces the
calls to mcount with nops here. If the text is RO, then it will crash.

-- Steve


> +	return 0;
>  
>  out:
>  	mutex_unlock(&module_mutex);

