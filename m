Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaEFTff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 15:35:35 -0400
Received: from mail.efficios.com ([78.47.125.74]:37248 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbaEFTfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 15:35:34 -0400
Date: Tue, 6 May 2014 19:35:32 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Javi Merino <javi.merino@arm.com>, David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Message-ID: <1033323713.12184.1399404932965.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140506094407.507b6435@gandalf.local.home>
References: <20140506094407.507b6435@gandalf.local.home>
Subject: Re: [RFA][PATCH] tracing: Add trace_<tracepoint>_enabled() function
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF29 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Add trace_<tracepoint>_enabled() function
Thread-Index: JiVKvj24v84uuoSDKib+wwfRED9xHw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "LKML" <linux-kernel@vger.kernel.org>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Javi Merino"
> <javi.merino@arm.com>, "David Howells" <dhowells@redhat.com>, "Ingo Molnar" <mingo@kernel.org>
> Sent: Tuesday, May 6, 2014 9:44:07 AM
> Subject: [RFA][PATCH] tracing: Add trace_<tracepoint>_enabled() function
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

I'm OK with the intend, however there seems to be two means to achieve
this, and I'm not sure the proposed solution is safe.

As you point out just above, the trace_mytracepoint_enabled() construct
can easily lead to incorrect code if users are not very careful on how
they use the condition vs the tracepoint itself.

I understand that the reason why we cannot simply put the call
to "process_tp_arg()" within the parameters passed to trace_mytracepoint()
is because trace_mytracepoint() is a static inline, and that the
side-effects of the arguments it receives need to be evaluated whether
the tracepoint is enabled or not.

To overcome this issue, I have used a layer of macro on top of the
trace_*() call in lttng-ust, giving something similar to this:

#define tracepoint(name, ...)                                      \
        do {                                                       \
                if (static_key_false(&__tracepoint_##name.key)     \
                        trace_##name(__VA_ARGS__);                 \
        } while (0)

and the static inline trace_##name declared by __DECLARE_TRACE
simply contains __DO_TRACE(&__tracepoint_##name,
                                TP_PROTO(data_proto),
                                TP_ARGS(data_args),
                                TP_CONDITION(cond),,);

This allow calling a tracepoint with:

   tracepoint(mytracepoint, process_tp_arg());

making sure that process_tp_arg() will only be evaluated if
the tracepoint is enabled. It also ensures that it's impossible
to create a C construct that will open a race window where a
tracepoint could be called with an unpopulated parameter, such as:

   if (trace_mytracepoint_enabled())
 	arg = process_tp_arg();
   trace_mytracepoint(arg);

Thoughts ?

Thanks,

Mathieu

> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/tracepoint.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
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

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
