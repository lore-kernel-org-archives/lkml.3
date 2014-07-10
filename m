Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaGJRqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 13:46:01 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:6480 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaGJRqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 13:46:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 10 Jul 2014 10:35:05 -0700
Message-ID: <53BED155.9040607@nvidia.com>
Date: Thu, 10 Jul 2014 20:45:57 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [for-next][PATCH 04/21] ftrace: Optimize function graph to be
 called directly
References: <20140703160503.006976702@goodmis.org> <20140703161224.062459692@goodmis.org>
In-Reply-To: <20140703161224.062459692@goodmis.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/14 19:05, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)"<rostedt@goodmis.org>
>
> Function graph tracing is a bit different than the function tracers, as
> it is processed after either the ftrace_caller or ftrace_regs_caller
> and we only have one place to modify the jump to ftrace_graph_caller,
> the jump needs to happen after the restore of registeres.
>
> The function graph tracer is dependent on the function tracer, where
> even if the function graph tracing is going on by itself, the save and
> restore of registers is still done for function tracing regardless of
> if function tracing is happening, before it calls the function graph
> code.
>
> If there's no function tracing happening, it is possible to just call
> the function graph tracer directly, and avoid the wasted effort to save
> and restore regs for function tracing.
>
> This requires adding new flags to the dyn_ftrace records:
>
>    FTRACE_FL_TRAMP
>    FTRACE_FL_TRAMP_EN
>
> The first is set if the count for the record is one, and the ftrace_ops
> associated to that record has its own trampoline. That way the mcount code
> can call that trampoline directly.
>
> In the future, trampolines can be added to arbitrary ftrace_ops, where you
> can have two or more ftrace_ops registered to ftrace (like kprobes and perf)
> and if they are not tracing the same functions, then instead of doing a
> loop to check all registered ftrace_ops against their hashes, just call the
> ftrace_ops trampoline directly, which would call the registered ftrace_ops
> function directly.
>
> Without this patch perf showed:
>
>    0.05%  hackbench  [kernel.kallsyms]  [k] ftrace_caller
>    0.05%  hackbench  [kernel.kallsyms]  [k] arch_local_irq_save
>    0.05%  hackbench  [kernel.kallsyms]  [k] native_sched_clock
>    0.04%  hackbench  [kernel.kallsyms]  [k] __buffer_unlock_commit
>    0.04%  hackbench  [kernel.kallsyms]  [k] preempt_trace
>    0.04%  hackbench  [kernel.kallsyms]  [k] prepare_ftrace_return
>    0.04%  hackbench  [kernel.kallsyms]  [k] __this_cpu_preempt_check
>    0.04%  hackbench  [kernel.kallsyms]  [k] ftrace_graph_caller
>
> See that the ftrace_caller took up more time than the ftrace_graph_caller
> did.
>
> With this patch:
>
>    0.05%  hackbench  [kernel.kallsyms]  [k] __buffer_unlock_commit
>    0.04%  hackbench  [kernel.kallsyms]  [k] call_filter_check_discard
>    0.04%  hackbench  [kernel.kallsyms]  [k] ftrace_graph_caller
>    0.04%  hackbench  [kernel.kallsyms]  [k] sched_clock
>
> The ftrace_caller is no where to be found and ftrace_graph_caller still
> takes up the same percentage.
>
> Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
> ---
>   arch/x86/kernel/mcount_64.S |   5 +
>   include/linux/ftrace.h      |  19 +++-
>   kernel/trace/ftrace.c       | 242 ++++++++++++++++++++++++++++++++++++++++++--
>   3 files changed, 254 insertions(+), 12 deletions(-)
>

This commit (79922b8) breaks the function graph tracer on today's -next. 
This is on an ARM Tegra board.

I'm using ftrace with this script:

#!/bin/sh
echo function_graph > /d/tracing/current_tracer
echo clear > /d/tracing/trace
echo $$ > /d/tracing/set_ftrace_pid
exec "$@"

...and a simple './trace.sh ls' crashes with no console output. SysRq is 
not responsive either.
