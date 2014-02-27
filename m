Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbaB0AjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 19:39:19 -0500
Received: from ozlabs.org ([203.10.76.45]:50712 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbaB0AjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 19:39:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] tracepoint: Do not waste memory on mods with no tracepoints
In-Reply-To: <20140226110313.4d92fb83@gandalf.local.home>
References: <20140226110313.4d92fb83@gandalf.local.home>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 27 Feb 2014 11:00:35 +1030
Message-ID: <87lhwx2y8k.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:
> No reason to allocate tp_module structures for modules that have no
> tracepoints. This just wastes memory.
>
> Fixes: b75ef8b44b1c "Tracepoint: Dissociate from module mutex"
> Cc: stable@vger.kernel.org # 3.2+

Really?  CC:stable?  To save an insignificant amount of memory?

The definition of stable seems to be shifting away from "fixes for
problems with significant effects".  I obviously missed the memo.

Rusty.



> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/tracepoint.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 29f2654..0d4ef26 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -636,6 +636,9 @@ static int tracepoint_module_coming(struct module *mod)
>  	struct tp_module *tp_mod, *iter;
>  	int ret = 0;
>  
> +	if (!mod->num_tracepoints)
> +		return 0;
> +
>  	/*
>  	 * We skip modules that taint the kernel, especially those with different
>  	 * module headers (for forced load), to make sure we don't cause a crash.
> @@ -679,6 +682,9 @@ static int tracepoint_module_going(struct module *mod)
>  {
>  	struct tp_module *pos;
>  
> +	if (!mod->num_tracepoints)
> +		return 0;
> +
>  	mutex_lock(&tracepoints_mutex);
>  	tracepoint_update_probe_range(mod->tracepoints_ptrs,
>  		mod->tracepoints_ptrs + mod->num_tracepoints);
> -- 
> 1.8.1.4
