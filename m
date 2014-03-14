Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaCNKKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:10:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46358 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752548AbaCNKKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:10:37 -0400
Date: Fri, 14 Mar 2014 10:07:35 +0000
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
Message-ID: <20140314100735.GC13541@arm.com>
References: <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705630-12384-5-git-send-email-takahiro.akashi@linaro.org>
 <20140313170834.GE25472@mudshark.cambridge.arm.com>
 <53228959.3040000@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53228959.3040000@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 04:45:13AM +0000, AKASHI Takahiro wrote:
> On 03/14/2014 02:08 AM, Will Deacon wrote:
> > On Thu, Mar 13, 2014 at 10:13:47AM +0000, AKASHI Takahiro wrote:
> >> This patch implements arm64 specific part to support function tracers,
> >> such as function (CONFIG_FUNCTION_TRACER), function_graph
> >> (CONFIG_FUNCTION_GRAPH_TRACER) and function profiler
> >> (CONFIG_FUNCTION_PROFILER).
> >>
> >> With 'function' tracer, all the functions in the kernel are traced with
> >> timestamps in ${sysfs}/tracing/trace. If function_graph tracer is
> >> specified, call graph is generated.
> >>
> >> The kernel must be compiled with -pg option so that _mcount() is inserted
> >> at the beginning of functions. This function is called on every function's
> >> entry as long as tracing is enabled.
> >> In addition, function_graph tracer also needs to be able to probe function's
> >> exit. ftrace_graph_caller() & return_to_handler do this by faking link
> >> register's value to intercept function's return path.
> >>
> >> More details on architecture specific requirements are described in
> >> Documentation/trace/ftrace-design.txt.
> >
> > [...]
> 
> You seem not to like this statement :-)

Huh? I was just using '[...]' to signify that I'd removed a lot of context
(since the code all looked fine there). Otherwise, review emails can get
really long.

> >> +       str     x0, [sp, #-16]!
> >> +       mov     x0, x29                 //     parent's fp
> >> +       bl      ftrace_return_to_handler// addr = ftrace_return_to_hander(fp);
> >> +       mov     x30, x0                 // restore the original return address
> >> +       ldr     x0, [sp], #16
> >> +       ret
> >
> > and an ENDPROC here.
> 
> Fix it.
> But please note that this (return_to_handler) is not a real function.
> Declaring it as ENDPROC is not very useful.

Then use END(...). The opening macro was the main point, since that avoid
the need for an explicit .globl.

Will
