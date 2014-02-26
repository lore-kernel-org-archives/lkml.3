Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaBZAjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:39:01 -0500
Received: from mail.efficios.com ([78.47.125.74]:39115 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbaBZAi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:38:59 -0500
Date: Wed, 26 Feb 2014 00:39:01 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Message-ID: <188130295.30493.1393375141631.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140225191505.32b56105@gandalf.local.home>
References: <20140225191505.32b56105@gandalf.local.home>
Subject: Re: [RFC][PATCH] tracing: Warn and notify if tracepoints are not
 loaded due to module taint
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Warn and notify if tracepoints are not loaded due to module taint
Thread-Index: Y+w5iRtnBJI2iK4r7SVb8fH01bYe/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "LKML" <linux-kernel@vger.kernel.org>
> Cc: "Ingo Molnar" <mingo@kernel.org>, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Rusty Russell"
> <rusty@rustcorp.com.au>, "Frederic Weisbecker" <fweisbec@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>,
> "Peter Zijlstra" <peterz@infradead.org>
> Sent: Tuesday, February 25, 2014 7:15:05 PM
> Subject: [RFC][PATCH] tracing: Warn and notify if tracepoints are not loaded due to module taint
> 
> [ Posting this as an RFC, but I plan on pushing it as soon as I finish
> testing it ]
> 
> If a module is loaded that is tainted with anything but OOT or CRAP, then
> it will not create the traceoint infrastructure for the module. There should

traceoint -> tracepoint

> be a big warning when this happens instead of exiting silently.
> 
> Fixes: 97e1c18e8d17 "tracing: Kernel Tracepoints"
> Cc: stable@vger.kernel.org
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/tracepoint.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 29f2654..413bc06 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -641,7 +641,8 @@ static int tracepoint_module_coming(struct module *mod)
>  	 * module headers (for forced load), to make sure we don't cause a crash.
>  	 * Staging and out-of-tree GPL modules are fine.
>  	 */
> -	if (mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)))
> +	if (WARN_ONCE(mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)),
> +		      "Module is tainted, disabling tracepoints"))

Perhaps ever clearer with:

   "Module \"%s\" is tainted, disabling tracepoints", mod->name

?

Other than that, looks good to me!

Thanks,

Mathieu

>  		return 0;
>  	mutex_lock(&tracepoints_mutex);
>  	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);
> --
> 1.8.5.3
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
