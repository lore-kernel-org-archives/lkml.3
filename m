Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaKDIby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:31:54 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46384 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbaKDIbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:31:50 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 4/4 v2] ftracetest: Add a couple of ftrace test cases
References: <20141103212737.696365174@goodmis.org>
	<20141103212842.139783956@goodmis.org>
Date: Tue, 04 Nov 2014 17:31:47 +0900
In-Reply-To: <20141103212842.139783956@goodmis.org> (Steven Rostedt's message
	of "Mon, 03 Nov 2014 16:27:41 -0500")
Message-ID: <87h9yf5pu4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

Just a few nitpicks..  Otherwise looks good to me.


On Mon, 03 Nov 2014 16:27:41 -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>
> Added three test cases to get the feel of adding tests to ftracetest.
> The three cases are:
>
>   function profiling test, to make sure function profiling still works
>    with function tracing (was a regression)
>
>   function graph filter test to make sure that function graph filtering works.
>
>   function graph filter with stack tracing test to make sure that the function
>    graph filter does filter and also continues to filter when another function tracer
>    is running (like the stack tracer)
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  .../ftrace/test.d/ftrace/fgraph-filter-stack.tc    | 94 ++++++++++++++++++++++
>  .../ftrace/test.d/ftrace/fgraph-filter.tc          | 49 +++++++++++
>  .../ftrace/test.d/ftrace/func_profiler.tc          | 76 +++++++++++++++++
>  3 files changed, 219 insertions(+)
>  create mode 100644 tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter-stack.tc
>  create mode 100644 tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter.tc
>  create mode 100644 tools/testing/selftests/ftrace/test.d/ftrace/func_profiler.tc
>
> diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter-stack.tc b/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter-stack.tc
> new file mode 100644
> index 000000000000..3d8f79176681
> --- /dev/null
> +++ b/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter-stack.tc
> @@ -0,0 +1,94 @@
> +#!/bin/sh
> +# description: ftrace - function graph filters with stack tracer
> +
> +# Make sure that function graph filtering works, and is not
> +# affected by other tracers enabled (like stack tracer)
> +
> +if ! grep -q function_graph available_tracers; then
> +    echo "no function graph tracer configured"
> +    exit_unsupported
> +fi
> +
> +if [ ! -f set_ftrace_filter ]; then
> +    echo "set_ftrace_filter not found? Is dynamic ftrace not set?"
> +    exit_unsupported
> +fi
> +
> +do_reset() {
> +    reset_tracer
> +    echo 0 > /proc/sys/kernel/stack_tracer_enabled
> +    enable_tracing
> +    clear_trace
> +    echo > set_ftrace_filter
> +}
> +
> +disable_tracing
> +clear_trace;
> +
> +# filter something, schedule is always good
> +if ! echo "schedule" > set_ftrace_filter; then
> +    # test for powerpc 64
> +    if ! echo ".schedule" > set_ftrace_filter; then

You did 'echo '*schedule' > set_ftrace_filter' in the last test case.


> +	echo "can not enable schedule filter"
> +	exit -1
> +    fi
> +fi
> +
> +echo function_graph > current_tracer
> +
> +if [ ! -f stack_trace ]; then
> +    echo "Stack tracer not configured"
> +    do_reset
> +    exit_unsupported;
> +fi
> +
> +echo "Now testing with stack tracer"
> +
> +echo 1 > /proc/sys/kernel/stack_tracer_enabled
> +
> +disable_tracing
> +clear_trace
> +enable_tracing
> +sleep 1
> +
> +count=`cat trace | grep '()' | grep -v schedule | wc -l`
> +
> +if [ $count -ne 0 ]; then
> +    echo "Graph filtering not working with stack tracer?"
> +    exit -1
> +fi
> +
> +count=`cat trace | grep 'schedule()' | wc -l` 
> +if [ $count -eq 0 ]; then
> +    echo "No schedule traces found?"
> +    exit -1
> +fi
> +
> +# Make sure we did find something
> +count=`cat trace | grep 'schedule()' | wc -l` 
> +if [ $count -eq 0 ]; then
> +    echo "No schedule traces found?"
> +    exit -1
> +fi

Do you really want to do it twice?


> +
> +echo 0 > /proc/sys/kernel/stack_tracer_enabled
> +clear_trace
> +sleep 1
> +
> +
> +count=`cat trace | grep '()' | grep -v schedule | wc -l`
> +
> +if [ $count -ne 0 ]; then
> +    echo "Graph filtering not working after stack tracer disabled?"
> +    exit -1
> +fi
> +
> +count=`cat trace | grep 'schedule()' | wc -l` 
> +if [ $count -eq 0 ]; then
> +    echo "No schedule traces found?"
> +    exit -1
> +fi
> +
> +do_reset
> +
> +exit 0


[SNIP]
> --- /dev/null
> +++ b/tools/testing/selftests/ftrace/test.d/ftrace/func_profiler.tc
> @@ -0,0 +1,76 @@
> +#!/bin/sh
> +# description: ftrace - function profiler with function tracing
> +
> +# There was a bug after a rewrite of the ftrace infrastructure that
> +# caused the function_profiler not to be able to run with the function
> +# tracer, because the function_profiler used the function_graph tracer
> +# and it was assumed the two could not run simultaneously.
> +#
> +# There was another related bug where the solution to the first bug
> +# broke the way filtering of the function tracer worked.
> +#
> +# This test triggers those bugs on those kernels.
> +#
> +# We need function_graph and profiling to to run this test
> +if ! grep -q function_graph available_tracers; then
> +    echo "no function graph tracer configured"
> +    exit_unsupported;
> +fi
> +
> +if [ ! -f set_ftrace_filter ]; then
> +    echo "set_ftrace_filter not found? Is dynamic ftrace not set?"
> +    exit_unsupported
> +fi
> +
> +if [ ! -f function_profile_enabled ]; then
> +    echo "function_profile_enabled not found, function profiling enabled?"
> +    exit_unsupported
> +fi
> +
> +echo "Testing function tracer with profiler:"
> +echo "enable function tracer"
> +echo function > current_tracer
> +echo "enable profiler"
> +echo 1 > function_profile_enabled

Oh, this test is verbose.. :)


> +
> +sleep 1
> +
> +echo "Now filter on just schedule"
> +echo '*schedule' > set_ftrace_filter

Here..

> +clear_trace
> +
> +echo "Now disable function profiler"
> +echo 0 > function_profile_enabled
> +
> +sleep 1
> +
> +# make sure only schedule functions exist
> +
> +echo "testing if only schedule is being traced"
> +if grep -v -e '^#' -e 'schedule' trace; then

It seems you might want to add -q or > /dev/null.  Or count the
resulting lines like other tests.


> +	echo "more than schedule was found"
> +	exit 1

'exit -1' for consistency?

Thanks,
Namhyung


> +fi
> +
> +echo "Make sure schedule was traced"
> +if ! grep -e 'schedule' trace > /dev/null; then
> +	cat trace
> +	echo "can not find schedule in trace"
> +	exit 1
> +fi
> +
> +echo > set_ftrace_filter
> +clear_trace
> +
> +sleep 1
> +
> +echo "make sure something other than scheduler is being traced"
> +if ! grep -v -e '^#' -e 'schedule' trace > /dev/null; then
> +	cat trace
> +	echo "no other functions besides schedule was found"
> +	exit 1
> +fi
> +
> +reset_tracer
> +
> +exit 0
