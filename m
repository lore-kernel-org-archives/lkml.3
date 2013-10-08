Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3JHPf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:35:26 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:20254 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752929Ab3JHPfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:35:23 -0400
Date: Tue, 8 Oct 2013 11:35:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: Re: [PATCH 6/6] x86: Allow disabling HW_BREAKPOINTS and PERF_EVENTS
Message-ID: <20131008153518.GB15214@home.goodmis.org>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
 <1380922788-23112-7-git-send-email-andi@firstfloor.org>
 <20131006164934.GA15167@gmail.com>
 <20131008065938.GA4333@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008065938.GA4333@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 08:59:38AM +0200, Ingo Molnar wrote:
> 
> Secondly and more importantly, visualized with relative sizes, in a 
> feature matrix, makes it clearer what's going on with vmlinux .text:
> 
>                               perf-OFF   perf-ON
> 
>             ftrace-OFF               0     +151k
> 
>             ftrace-ON            +897k    +1142k
> 
> So basically ftrace is causing a big chunk of the instrumentation size 
> increase. With tons of tracers and lots of kernel subsystems built into 
> your .config that's a lot of nice instrumentation functionality and it's 
> thus also a natural end result IMO.

I'm curious what you turned on for between the "ftrace-OFF" and "ftrace-ON"?

Technically, ftrace is just the infrastructure for the /debug/tracing directory
and the function tracer. And there's lots of options to turn on or off:

CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FTRACE_MCOUNT_RECORD=y

The one thing that you didn't post was CONFIG_EVENT_TRACING. This is where
a lot of bloat can come from, as this enables the infrastructure for
tracepoints. This is also needed by perf to trace most sw events.

The trace event infrastructure that both perf and ftrace uses (as well
as other tracers and tools) is well known to cause bloat in the kernel.
There's patches to help make it more bearable, but there's more work to
be done.

Currently, ftrace selects events, but that was only because you suggested
to do so as events are so valuable in tracing.

-- Steve

