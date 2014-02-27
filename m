Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaB0Qdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:33:50 -0500
Received: from mail.efficios.com ([78.47.125.74]:47736 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbaB0Qdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:33:49 -0500
Date: Thu, 27 Feb 2014 16:33:50 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Message-ID: <1493277105.31789.1393518830647.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140227154923.563572071@goodmis.org>
References: <20140227154616.703252665@goodmis.org> <20140227154923.563572071@goodmis.org>
Subject: Re: [RFA][PATCH 5/5] tracepoint: Warn and notify if tracepoints are
 not loaded due to module taint
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracepoint: Warn and notify if tracepoints are not loaded due to module taint
Thread-Index: UB5O2450aKWX68NIfAP+v+BCMHh2VQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: linux-kernel@vger.kernel.org
> Cc: "Ingo Molnar" <mingo@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Peter Zijlstra"
> <peterz@infradead.org>, "Frederic Weisbecker" <fweisbec@gmail.com>, "Mathieu Desnoyers"
> <mathieu.desnoyers@efficios.com>, stable@vger.kernel.org, "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
> Sent: Thursday, February 27, 2014 10:46:21 AM
> Subject: [RFA][PATCH 5/5] tracepoint: Warn and notify if tracepoints are not loaded due to module taint
> 
> [ Request for Ack ]
> 
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> If a module is loaded that is tainted with anything but OOT or CRAP, then
> it will not create the tracepoint infrastructure for the module. The user
> needs
> to be warned when this happens instead of exiting silently.
> 
> Fixes: 97e1c18e8d17 "tracing: Kernel Tracepoints"
> Cc: stable@vger.kernel.org
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/tracepoint.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 63630ae..a65af20 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -649,8 +649,12 @@ static int tracepoint_module_coming(struct module *mod)
>  	 * module headers (for forced load), to make sure we don't cause a crash.
>  	 * Staging and out-of-tree GPL modules are fine.
>  	 */
> -	if (trace_module_has_bad_taint(mod))
> +	if (trace_module_has_bad_taint(mod)) {
> +		pr_err("Module '%s' is tainted, disabling tracepoints\n",

Hrm, I wonder if this message could confuse users into thinking that because
of this error, tracepoints are disabled across the entire kernel (rather than
within this module).

I'd recommend the following message instead:

 pr_err("Module '%s' is tainted, ignoring its tracepoints\n",

Thoughts ?

Thanks,

Mathieu

> +		       mod->name);
>  		return 0;
> +	}
> +
>  	mutex_lock(&tracepoints_mutex);
>  	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);
>  	if (!tp_mod) {
> --
> 1.8.5.3
> 
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
