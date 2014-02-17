Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaBQSPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:15:17 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37420 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308AbaBQSPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:15:13 -0500
Date: Mon, 17 Feb 2014 18:12:10 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH v3 1/6] arm64: Add ftrace support
Message-ID: <20140217181209.GF26590@mudshark.cambridge.arm.com>
References: <1382598488-13511-1-git-send-email-takahiro.akashi@linaro.org>
 <1391768336-5642-1-git-send-email-takahiro.akashi@linaro.org>
 <1391768336-5642-2-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391768336-5642-2-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 10:18:51AM +0000, AKASHI Takahiro wrote:
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

> diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
> new file mode 100644
> index 0000000..0d5dfdb
> --- /dev/null
> +++ b/arch/arm64/include/asm/ftrace.h
> @@ -0,0 +1,23 @@
> +/*
> + * arch/arm64/include/asm/ftrace.h
> + *
> + * Copyright (C) 2013 Linaro Limited
> + * Author: AKASHI Takahiro <takahiro.akashi@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef __ASM_FTRACE_H
> +#define __ASM_FTRACE_H
> +
> +#ifdef CONFIG_FUNCTION_TRACER
> +#define MCOUNT_ADDR            ((unsigned long)_mcount)
> +#define MCOUNT_INSN_SIZE       4 /* sizeof mcount call */

You can use AARCH64_INSN_SIZE here.

> +#include <linux/linkage.h>
> +#include <asm/ftrace.h>
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
> + * get lr(x30) of insturmented function at any time by winding up call stack

instrumented

> + * as long as the kernel is compiled without -fomit-frame-pointer.
> + * (or CONFIG_FRAME_POINTER, this is forced on arm64)
> + *
> + * stack layout after mcount_enter:
> + *
> + *   0 ---------------------------------------- sp of _mcount()
> + *      x29: fp of instrumented function       fp is not winded
> + *     --------------------
> + *      x30: lr of _mcount() (= instrumented function's pc)
> + * +16 ---------------------------------------- sp of instrumented function
> + *
> + *     ....
> + *
> + * +xx ---------------------------------------- fp of instrumented function
> + *      x29: fp of parent
> + *     --------------------
> + *      x30: lr of insturmented function (= parent's pc)
> + *     --------------------
> + *      xxx
> + */
> +
> +       .macro mcount_enter
> +       stp     x29, x30, [sp, #-48]!
> +       .endm

Can you elaborate in your comment about where this 48 comes from please? I
can't join it up with your ascii art.

Will
