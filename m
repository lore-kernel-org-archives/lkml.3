Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbaEGLmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 07:42:13 -0400
Received: from mail.efficios.com ([78.47.125.74]:40505 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932627AbaEGLmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 07:42:11 -0400
Date: Wed, 7 May 2014 11:42:11 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Javi Merino <javi.merino@arm.com>, David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Message-ID: <2007248757.12536.1399462930995.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140506231059.0dd132bc@gandalf.local.home>
References: <20140506094407.507b6435@gandalf.local.home> <1033323713.12184.1399404932965.JavaMail.zimbra@efficios.com> <20140506154845.43c7b0ad@gandalf.local.home> <799562553.12242.1399409621298.JavaMail.zimbra@efficios.com> <20140506170640.088df53b@gandalf.local.home> <1813175652.12255.1399411000693.JavaMail.zimbra@efficios.com> <20140506231059.0dd132bc@gandalf.local.home>
Subject: Re: [RFA][PATCH v2] tracing: Add trace_<tracepoint>_enabled()
 function
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF29 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Add trace_<tracepoint>_enabled() function
Thread-Index: z6EUDVKr0c6SBweb4BO11aqQECc+Nw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "LKML" <linux-kernel@vger.kernel.org>
> Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Javi Merino"
> <javi.merino@arm.com>, "David Howells" <dhowells@redhat.com>, "Ingo Molnar" <mingo@kernel.org>
> Sent: Tuesday, May 6, 2014 11:10:59 PM
> Subject: [RFA][PATCH v2] tracing: Add trace_<tracepoint>_enabled() function
> 
> 
> There are some code paths in the kernel that need to do some preparations
> before it calls a tracepoint. As that code is worthless overhead when
> the tracepoint is not enabled, it would be prudent to have that code
> only run when the tracepoint is active. To accomplish this, all tracepoints
> now get a static inline function called "trace_<tracepoint-name>_enabled()"
> which returns true when the tracepoint is enabled and false otherwise.
> 
> As an added bonus, that function uses the static_key of the tracepoint
> such that no branch is needed.
> 
>   if (trace_mytracepoint_enabled()) {
> 	arg = process_tp_arg();
> 	trace_mytracepoint(arg);
>   }
> 
> Will keep the "process_tp_arg()" (which may be expensive to run) from
> being executed when the tracepoint isn't enabled.
> 
> It's best to encapsulate the tracepoint itself in the if statement
> just to keep races. For example, if you had:
> 
>   if (trace_mytracepoint_enabled())
> 	arg = process_tp_arg();
>   trace_mytracepoint(arg);
> 
> There's a chance that the tracepoint could be enabled just after the
> if statement, and arg will be undefined when calling the tracepoint.
> 
> Link: http://lkml.kernel.org/r/20140506094407.507b6435@gandalf.local.home
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> ---
> Changes since v1: Added some documentation about using this function.
> ---
>  Documentation/trace/tracepoints.txt | 24 ++++++++++++++++++++++++
>  include/linux/tracepoint.h          | 10 ++++++++++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/Documentation/trace/tracepoints.txt
> b/Documentation/trace/tracepoints.txt
> index 6b018b5..a3efac6 100644
> --- a/Documentation/trace/tracepoints.txt
> +++ b/Documentation/trace/tracepoints.txt
> @@ -115,6 +115,30 @@ If the tracepoint has to be used in kernel modules, an
>  EXPORT_TRACEPOINT_SYMBOL_GPL() or EXPORT_TRACEPOINT_SYMBOL() can be
>  used to export the defined tracepoints.
>  
> +If you need to do a bit of work for a tracepoint parameter, and
> +that work is only used for the tracepoint, that work can be encapsulated
> +within an if statement with the following:
> +
> +	if (trace_foo_bar_enabled()) {
> +		int i;
> +		int tot = 0;
> +
> +		for (i = 0; i < count; i++)
> +			tot += calculate_nuggets();
> +
> +		trace_foo_bar(tot);
> +	}
> +
> +All trace_<tracepoint>() calls have a matching trace_<tracepoint>_enabled()
> +function defined that returns true if the tracepoint is enabled and
> +false otherwise. The trace_<tracepoint>() should always be within the
> +block of the if (trace_<tracepoint>_enabled()) to prevent races between
> +the tracepoint being enabled and the check being seen.
> +
> +The advantage of using the trace_<tracepoint>_enabled() is that it uses
> +the static_key of the tracepoint to allow the if statement to be implemented
> +with jump labels and avoid conditional branches.
> +
>  Note: The convenience macro TRACE_EVENT provides an alternative way to
>        define tracepoints. Check http://lwn.net/Articles/379903,
>        http://lwn.net/Articles/381064 and http://lwn.net/Articles/383362
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 9d30ee4..2e2a5f7 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -185,6 +185,11 @@ extern void syscall_unregfunc(void);
>  	static inline void						\
>  	check_trace_callback_type_##name(void (*cb)(data_proto))	\
>  	{								\
> +	}								\
> +	static inline bool						\
> +	trace_##name##_enabled(void)					\
> +	{								\
> +		return static_key_false(&__tracepoint_##name.key);	\
>  	}
>  
>  /*
> @@ -230,6 +235,11 @@ extern void syscall_unregfunc(void);
>  	}								\
>  	static inline void check_trace_callback_type_##name(void (*cb)(data_proto))
>  	\
>  	{								\
> +	}								\
> +	static inline bool						\
> +	trace_##name##_enabled(void)					\
> +	{								\
> +		return false;						\
>  	}
>  
>  #define DEFINE_TRACE_FN(name, reg, unreg)
> --
> 1.8.1.4
> 
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
