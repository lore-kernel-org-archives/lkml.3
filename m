Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaHHDFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 23:05:30 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:60297 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbaHHDF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 23:05:29 -0400
Date: Thu, 7 Aug 2014 23:05:26 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@redhat.com>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 1/5] tracing: Do not do anything special with
 tracepoint_string when tracing is disabled
In-Reply-To: <20140807223553.541eada9@gandalf.local.home>
Message-ID: <alpine.LFD.2.11.1408072304090.6061@knanqh.ubzr>
References: <1406318733-26754-1-git-send-email-nicolas.pitre@linaro.org> <1406318733-26754-2-git-send-email-nicolas.pitre@linaro.org> <20140807223553.541eada9@gandalf.local.home>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2014, Steven Rostedt wrote:

> Because ftrace_events.h is not included when config tracing is not
> enabled, I got error messages when compiling arm and arm64 without
> tracing enabled. This is the new patch I'm now testing that moves the
> tracepoint_string code to include/linux/tracepoint.h as well.

Makes sense.



> 
> -- Steve
> 
> From 3c49b52b155d0f723792377e1a4480a0e7ca0ba2 Mon Sep 17 00:00:00 2001
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Fri, 25 Jul 2014 16:05:29 -0400
> Subject: [PATCH] tracing: Do not do anything special with tracepoint_string
>  when tracing is disabled
> 
> When CONFIG_TRACING is not enabled, there's no reason to save the trace
> strings either by the linker or as a static variable that can be
> referenced later. Simply pass back the string that is given to
> tracepoint_string().
> 
> Had to move the define to include/linux/tracepoint.h so that it is still
> visible when CONFIG_TRACING is not set.
> 
> Link: http://lkml.kernel.org/p/1406318733-26754-2-git-send-email-nicolas.pitre@linaro.org
> 
> Suggested-by: Nicolas Pitre <nico@linaro.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/ftrace_event.h | 34 ----------------------------------
>  include/linux/tracepoint.h   | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+), 34 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index cff3106ffe2c..c9f619a2070f 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -574,40 +574,6 @@ do {									\
>  		__trace_printk(ip, fmt, ##args);			\
>  } while (0)
>  
> -/**
> - * tracepoint_string - register constant persistent string to trace system
> - * @str - a constant persistent string that will be referenced in tracepoints
> - *
> - * If constant strings are being used in tracepoints, it is faster and
> - * more efficient to just save the pointer to the string and reference
> - * that with a printf "%s" instead of saving the string in the ring buffer
> - * and wasting space and time.
> - *
> - * The problem with the above approach is that userspace tools that read
> - * the binary output of the trace buffers do not have access to the string.
> - * Instead they just show the address of the string which is not very
> - * useful to users.
> - *
> - * With tracepoint_string(), the string will be registered to the tracing
> - * system and exported to userspace via the debugfs/tracing/printk_formats
> - * file that maps the string address to the string text. This way userspace
> - * tools that read the binary buffers have a way to map the pointers to
> - * the ASCII strings they represent.
> - *
> - * The @str used must be a constant string and persistent as it would not
> - * make sense to show a string that no longer exists. But it is still fine
> - * to be used with modules, because when modules are unloaded, if they
> - * had tracepoints, the ring buffers are cleared too. As long as the string
> - * does not change during the life of the module, it is fine to use
> - * tracepoint_string() within a module.
> - */
> -#define tracepoint_string(str)						\
> -	({								\
> -		static const char *___tp_str __tracepoint_string = str; \
> -		___tp_str;						\
> -	})
> -#define __tracepoint_string	__attribute__((section("__tracepoint_str")))
> -
>  #ifdef CONFIG_PERF_EVENTS
>  struct perf_event;
>  
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 2e2a5f7717e5..b1293f15f592 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -249,6 +249,50 @@ extern void syscall_unregfunc(void);
>  
>  #endif /* CONFIG_TRACEPOINTS */
>  
> +#ifdef CONFIG_TRACING
> +/**
> + * tracepoint_string - register constant persistent string to trace system
> + * @str - a constant persistent string that will be referenced in tracepoints
> + *
> + * If constant strings are being used in tracepoints, it is faster and
> + * more efficient to just save the pointer to the string and reference
> + * that with a printf "%s" instead of saving the string in the ring buffer
> + * and wasting space and time.
> + *
> + * The problem with the above approach is that userspace tools that read
> + * the binary output of the trace buffers do not have access to the string.
> + * Instead they just show the address of the string which is not very
> + * useful to users.
> + *
> + * With tracepoint_string(), the string will be registered to the tracing
> + * system and exported to userspace via the debugfs/tracing/printk_formats
> + * file that maps the string address to the string text. This way userspace
> + * tools that read the binary buffers have a way to map the pointers to
> + * the ASCII strings they represent.
> + *
> + * The @str used must be a constant string and persistent as it would not
> + * make sense to show a string that no longer exists. But it is still fine
> + * to be used with modules, because when modules are unloaded, if they
> + * had tracepoints, the ring buffers are cleared too. As long as the string
> + * does not change during the life of the module, it is fine to use
> + * tracepoint_string() within a module.
> + */
> +#define tracepoint_string(str)						\
> +	({								\
> +		static const char *___tp_str __tracepoint_string = str; \
> +		___tp_str;						\
> +	})
> +#define __tracepoint_string	__attribute__((section("__tracepoint_str")))
> +#else
> +/*
> + * tracepoint_string() is used to save the string address for userspace
> + * tracing tools. When tracing isn't configured, there's no need to save
> + * anything.
> + */
> +# define tracepoint_string(str) str
> +# define __tracepoint_string
> +#endif
> +
>  /*
>   * The need for the DECLARE_TRACE_NOARGS() is to handle the prototype
>   * (void). "void" is a special value in a function prototype and can
> -- 
> 2.0.1
> 
> 
