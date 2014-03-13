Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaCMRMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 13:12:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54804 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754012AbaCMRMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 13:12:06 -0400
Date: Thu, 13 Mar 2014 17:08:34 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 4/7] arm64: Add ftrace support
Message-ID: <20140313170834.GE25472@mudshark.cambridge.arm.com>
References: <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705630-12384-5-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394705630-12384-5-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 10:13:47AM +0000, AKASHI Takahiro wrote:
> This patch implements arm64 specific part to support function tracers,
> such as function (CONFIG_FUNCTION_TRACER), function_graph
> (CONFIG_FUNCTION_GRAPH_TRACER) and function profiler
> (CONFIG_FUNCTION_PROFILER).
> 
> With 'function' tracer, all the functions in the kernel are traced with
> timestamps in ${sysfs}/tracing/trace. If function_graph tracer is
> specified, call graph is generated.
> 
> The kernel must be compiled with -pg option so that _mcount() is inserted
> at the beginning of functions. This function is called on every function's
> entry as long as tracing is enabled.
> In addition, function_graph tracer also needs to be able to probe function's
> exit. ftrace_graph_caller() & return_to_handler do this by faking link
> register's value to intercept function's return path.
> 
> More details on architecture specific requirements are described in
> Documentation/trace/ftrace-design.txt.

[...]

> diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
> new file mode 100644
> index 0000000..0ac31c8
> --- /dev/null
> +++ b/arch/arm64/kernel/entry-ftrace.S
> @@ -0,0 +1,175 @@
> +/*
> + * arch/arm64/kernel/entry-ftrace.S
> + *
> + * Copyright (C) 2013 Linaro Limited
> + * Author: AKASHI Takahiro <takahiro.akashi@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/linkage.h>
> +#include <asm/ftrace.h>
> +#include <asm/insn.h>
> +
> +/*
> + * Gcc with -pg will put the following code in the beginning of each function:
> + *      mov x0, x30
> + *      bl _mcount
> + *     [function's body ...]
> + * "bl _mcount" may be replaced to "bl ftrace_caller" or NOP if dynamic
> + * ftrace is enabled.
> + *
> + * Please note that x0 as an argument will not be used here because we can
> + * get lr(x30) of instrumented function at any time by winding up call stack
> + * as long as the kernel is compiled without -fomit-frame-pointer.
> + * (or CONFIG_FRAME_POINTER, this is forced on arm64)
> + *
> + * stack layout after mcount_enter in _mcount():
> + *
> + * current sp/fp =>  0:+-----+
> + * in _mcount()               | x29 | -> instrumented function's fp
> + *                    +-----+
> + *                    | x30 | -> _mcount()'s lr (= instrumented function's pc)
> + * old sp      => +16:+-----+
> + * when instrumented   |     |
> + * function calls      | ... |
> + * _mcount()          |     |
> + *                    |     |
> + * instrumented => +xx:+-----+
> + * function's fp       | x29 | -> parent's fp
> + *                    +-----+
> + *                    | x30 | -> instrumented function's lr (= parent's pc)
> + *                    +-----+
> + *                    | ... |

I guess it's just the diff that's misaligning your ASCII art here?

> +/*
> + * void return_to_handler(void)
> + *
> + * Run ftrace_return_to_handler() before going back to parent.
> + * @fp is checked against the value passed by ftrace_graph_caller()
> + * only when CONFIG_FUNCTION_GRAPH_FP_TEST is enabled.
> + */
> +       .global return_to_handler
> +return_to_handler:

ENTRY(return_to_handler)

> +       str     x0, [sp, #-16]!
> +       mov     x0, x29                 //     parent's fp
> +       bl      ftrace_return_to_handler// addr = ftrace_return_to_hander(fp);
> +       mov     x30, x0                 // restore the original return address
> +       ldr     x0, [sp], #16
> +       ret

and an ENDPROC here.

> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
> new file mode 100644
> index 0000000..a559ab8
> --- /dev/null
> +++ b/arch/arm64/kernel/ftrace.c
> @@ -0,0 +1,64 @@
> +/*
> + * arch/arm64/kernel/ftrace.c
> + *
> + * Copyright (C) 2013 Linaro Limited
> + * Author: AKASHI Takahiro <takahiro.akashi@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/ftrace.h>
> +#include <linux/swab.h>
> +#include <linux/uaccess.h>
> +
> +#include <asm/cacheflush.h>
> +#include <asm/ftrace.h>
> +#include <asm/insn.h>
> +
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +/*
> + * function_graph tracer expects ftrace_return_to_handler() to be called
> + * on the way back to parent. For this purpose, this function is called
> + * in _mcount() or ftrace_caller() to replace return address (*parent) on
> + * the call stack to return_to_handler.
> + *
> + * Note that @frame_pointer is used only for sanity check later.
> + */
> +void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
> +                          unsigned long frame_pointer)
> +{
> +       unsigned long return_hooker = (unsigned long)&return_to_handler;
> +       unsigned long old;
> +       struct ftrace_graph_ent trace;
> +       int err;
> +
> +       if (unlikely(atomic_read(&current->tracing_graph_pause)))
> +               return;
> +
> +       /*
> +        * Note:
> +        * No protection against faulting at *parent, which may be seen
> +        * on other archs. It's unlikely on AArch64.
> +        */
> +       old = *parent;
> +       *parent = return_hooker;

return_hook? People might take it personally otherwise ;)

> +       trace.func = self_addr;

in kernel/ftrace/ftrace.c there's an smb_wmb() between setting up
tracing_graph_pause and setting the ret_stack with a comment saying:

    /* Make sure the tasks see the -1 first: */

Why don't we have a corresponding read-barrier here?

Will
