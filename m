Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaCNEp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 00:45:26 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:46430 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaCNEpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 00:45:25 -0400
Message-ID: <53228959.3040000@linaro.org>
Date: Fri, 14 Mar 2014 13:45:13 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "rostedt@goodmis.org" <rostedt@goodmis.org>,
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
References: <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org> <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org> <1394705630-12384-5-git-send-email-takahiro.akashi@linaro.org> <20140313170834.GE25472@mudshark.cambridge.arm.com>
In-Reply-To: <20140313170834.GE25472@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 02:08 AM, Will Deacon wrote:
> On Thu, Mar 13, 2014 at 10:13:47AM +0000, AKASHI Takahiro wrote:
>> This patch implements arm64 specific part to support function tracers,
>> such as function (CONFIG_FUNCTION_TRACER), function_graph
>> (CONFIG_FUNCTION_GRAPH_TRACER) and function profiler
>> (CONFIG_FUNCTION_PROFILER).
>>
>> With 'function' tracer, all the functions in the kernel are traced with
>> timestamps in ${sysfs}/tracing/trace. If function_graph tracer is
>> specified, call graph is generated.
>>
>> The kernel must be compiled with -pg option so that _mcount() is inserted
>> at the beginning of functions. This function is called on every function's
>> entry as long as tracing is enabled.
>> In addition, function_graph tracer also needs to be able to probe function's
>> exit. ftrace_graph_caller() & return_to_handler do this by faking link
>> register's value to intercept function's return path.
>>
>> More details on architecture specific requirements are described in
>> Documentation/trace/ftrace-design.txt.
>
> [...]

You seem not to like this statement :-)

>> diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
>> new file mode 100644
>> index 0000000..0ac31c8
>> --- /dev/null
>> +++ b/arch/arm64/kernel/entry-ftrace.S
>> @@ -0,0 +1,175 @@
>> +/*
>> + * arch/arm64/kernel/entry-ftrace.S
>> + *
>> + * Copyright (C) 2013 Linaro Limited
>> + * Author: AKASHI Takahiro <takahiro.akashi@linaro.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/linkage.h>
>> +#include <asm/ftrace.h>
>> +#include <asm/insn.h>
>> +
>> +/*
>> + * Gcc with -pg will put the following code in the beginning of each function:
>> + *      mov x0, x30
>> + *      bl _mcount
>> + *     [function's body ...]
>> + * "bl _mcount" may be replaced to "bl ftrace_caller" or NOP if dynamic
>> + * ftrace is enabled.
>> + *
>> + * Please note that x0 as an argument will not be used here because we can
>> + * get lr(x30) of instrumented function at any time by winding up call stack
>> + * as long as the kernel is compiled without -fomit-frame-pointer.
>> + * (or CONFIG_FRAME_POINTER, this is forced on arm64)
>> + *
>> + * stack layout after mcount_enter in _mcount():
>> + *
>> + * current sp/fp =>  0:+-----+
>> + * in _mcount()               | x29 | -> instrumented function's fp
>> + *                    +-----+
>> + *                    | x30 | -> _mcount()'s lr (= instrumented function's pc)
>> + * old sp      => +16:+-----+
>> + * when instrumented   |     |
>> + * function calls      | ... |
>> + * _mcount()          |     |
>> + *                    |     |
>> + * instrumented => +xx:+--- --+
>> + * function's fp       | x29 | -> parent's fp
>> + *                    +-----+
>> + *                    | x30 | -> instrumented function's lr (= parent's pc)
>> + *                    +-----+
>> + *                    | ... |
>
> I guess it's just the diff that's misaligning your ASCII art here?

Yes, I think so. Misaligned due to "tab"

>> +/*
>> + * void return_to_handler(void)
>> + *
>> + * Run ftrace_return_to_handler() before going back to parent.
>> + * @fp is checked against the value passed by ftrace_graph_caller()
>> + * only when CONFIG_FUNCTION_GRAPH_FP_TEST is enabled.a
>> + */
>> +       .global return_to_handler
>> +return_to_handler:
>
> ENTRY(return_to_handler)

Fix it.

>> +       str     x0, [sp, #-16]!
>> +       mov     x0, x29                 //     parent's fp
>> +       bl      ftrace_return_to_handler// addr = ftrace_return_to_hander(fp);
>> +       mov     x30, x0                 // restore the original return address
>> +       ldr     x0, [sp], #16
>> +       ret
>
> and an ENDPROC here.

Fix it.
But please note that this (return_to_handler) is not a real function.
Declaring it as ENDPROC is not very useful.

>> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>> diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
>> new file mode 100644
>> index 0000000..a559ab8
>> --- /dev/null
>> +++ b/arch/arm64/kernel/ftrace.c
>> @@ -0,0 +1,64 @@
>> +/*
>> + * arch/arm64/kernel/ftrace.c
>> + *
>> + * Copyright (C) 2013 Linaro Limited
>> + * Author: AKASHI Takahiro <takahiro.akashi@linaro.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/ftrace.h>
>> +#include <linux/swab.h>
>> +#include <linux/uaccess.h>
>> +
>> +#include <asm/cacheflush.h>
>> +#include <asm/ftrace.h>
>> +#include <asm/insn.h>
>> +
>> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
>> +/*
>> + * function_graph tracer expects ftrace_return_to_handler() to be called
>> + * on the way back to parent. For this purpose, this function is called
>> + * in _mcount() or ftrace_caller() to replace return address (*parent) on
>> + * the call stack to return_to_handler.
>> + *
>> + * Note that @frame_pointer is used only for sanity check later.
>> + */
>> +void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
>> +                          unsigned long frame_pointer)
>> +{
>> +       unsigned long return_hooker = (unsigned long)&return_to_handler;
>> +       unsigned long old;
>> +       struct ftrace_graph_ent trace;
>> +       int err;
>> +
>> +       if (unlikely(atomic_read(&current->tracing_graph_pause)))
>> +               return;
>> +
>> +       /*
>> +        * Note:
>> +        * No protection against faulting at *parent, which may be seen
>> +        * on other archs. It's unlikely on AArch64.
>> +        */
>> +       old = *parent;
>> +       *parent = return_hooker;
>
> return_hook? People might take it personally otherwise ;)

I didn't know what "(return) hooker" means.
Anyway, leave it as it is after you and Steven's discussion.

>> +       trace.func = self_addr;
>
> in kernel/ftrace/ftrace.c there's an smb_wmb() between setting up
> tracing_graph_pause and setting the ret_stack with a comment saying:
>
>      /* Make sure the tasks see the -1 first: */
>
> Why don't we have a corresponding read-barrier here?

I think Steven answered it.

-Takahiro AKASHI

> Will
>
