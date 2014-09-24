Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbaIXC7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 22:59:00 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33203 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbaIXC66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 22:58:58 -0400
Message-ID: <5422336A.6030304@hitachi.com>
Date: Wed, 24 Sep 2014 11:58:50 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC][PATCH] ftracetest: Add a couple of ftrace test cases
References: <20140923173846.603cb49c@gandalf.local.home>
In-Reply-To: <20140923173846.603cb49c@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/24 6:38), Steven Rostedt wrote:
> 
> [
>   Masami, I took two of my test scripts and added some basic comments

Thanks!

>   to them and copied them pretty much unchanged into a ftrace directory
>   under test.d. Is this fine, or is there more massaging I need to do
>   to them?

Yeah, ftrace has a double meaning :), so test.d/ftrace is fine to me.

> 
>   I know the echos don't show up, but I kept them anyway. What should
>   happen with them?

I think you'd better use exit_unsupported/exit_xfail to notify
that the test target is not configured, or expected to fail.
Then the user can reconfigure that. Maybe we should keep the
detailed log of such results. (you can do it with --keep option)

> ]
> 
> Added two test cases to get the feel of adding tests to ftracetest.
> The two cases are:
> 
>   function profiling test, to make sure function profiling still works
>    with function tracing (was a regression)
> 
>   function graph filter test to make sure that the function graph filter
>    does filter and also continues to filter when another function tracer
>    is running (like the stack tracer)
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  .../ftrace/test.d/ftrace/fgraph-filter.tc          | 111 +++++++++++++++++++++
>  .../ftrace/test.d/ftrace/func_profiler.tc          |  78 +++++++++++++++
>  2 files changed, 189 insertions(+)
>  create mode 100644 tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter.tc
>  create mode 100644 tools/testing/selftests/ftrace/test.d/ftrace/func_profiler.tc
> 
> diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter.tc b/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter.tc
> new file mode 100644
> index 000000000000..42f764d1f8d2
> --- /dev/null
> +++ b/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter.tc
> @@ -0,0 +1,111 @@
> +#!/bin/sh
> +# description: ftrace - function graph filters
> +
> +# Make sure that function graph filtering works, and is not
> +# affected by other tracers enabled (like stack tracer)
> +
> +if ! grep -q function_graph available_tracers; then
> +    echo "no function graph tracer configured"
> +    exit 0;

This should call exit_unsupported, because the test is not passed.

> +fi
> +
> +if [ ! -f set_ftrace_filter ]; then
> +    echo "set_ftrace_filter not found? Is dynamic ftrace not set?"
> +    exit 0

Ditto.

> +fi
> +
> +do_reset() {
> +    echo nop > current_tracer
> +    echo 0 > /proc/sys/kernel/stack_tracer_enabled
> +    echo 1 > tracing_on
> +    echo > trace
> +    echo > set_ftrace_filter
> +}
> +
> +echo 0 > tracing_on
> +# clear trace
> +echo > trace
> +# filter something, schedule is always good
> +if ! echo "schedule" > set_ftrace_filter; then
> +    # test for powerpc 64
> +    if ! echo ".schedule" > set_ftrace_filter; then
> +	echo "can not enable schedule filter"
> +	exit -1
> +    fi
> +fi
> +
> +echo function_graph > current_tracer
> +echo 1 > tracing_on
> +sleep 1
> +# search for functions (has "()" on the line), and make sure
> +# that only the schedule function was found
> +count=`cat trace | grep '()' | grep -v schedule | wc -l`
> +if [ $count -ne 0 ]; then
> +    echo "Graph filtering not working by itself?"
> +    exit -1;
> +fi
> +
> +# Make sure we did find something
> +count=`cat trace | grep 'schedule()' | wc -l` 
> +if [ $count -eq 0 ]; then
> +    echo "No schedule traces found?"
> +    exit -1
> +fi
> +
> +echo "Graph filtering works by itself"
> +

I think the following part should be a separated test for
stack trace.

> +if [ ! -f stack_trace ]; then
> +    echo "Stack tracer not configured, can't continue test"
> +    # stack tracer not configured in this kernel? pass test anyway
> +    do_reset
> +    exit 0;

Here should call exit_unsupported.

> +fi
> +
> +echo "Now testing with stack tracer"
> +
> +echo 1 > /proc/sys/kernel/stack_tracer_enabled
> +
> +echo 0 > tracing_on
> +echo > trace
> +echo 1 > tracing_on
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
> +echo "Graph filtering works with stack tracer"
> +
> +echo "Now testing if filtering still works without stack tracer"
> +
> +echo 0 > /proc/sys/kernel/stack_tracer_enabled
> +echo > trace
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
> +echo "SUCCESS!"
> +exit 0
> diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/func_profiler.tc b/tools/testing/selftests/ftrace/test.d/ftrace/func_profiler.tc
> new file mode 100644
> index 000000000000..f35c58968d09
> --- /dev/null
> +++ b/tools/testing/selftests/ftrace/test.d/ftrace/func_profiler.tc
> @@ -0,0 +1,78 @@
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
> +    # allow it to pass, as the kernel doesn't support it
> +    exit 0;
> +fi
> +
> +if [ ! -f set_ftrace_filter ]; then
> +    echo "set_ftrace_filter not found? Is dynamic ftrace not set?"
> +    exit 0
> +fi
> +
> +if [ ! -f function_profile_enabled ]; then
> +    echo "function_profile_enabled not found, function profiling enabled?"
> +    exit 0
> +fi

These checks should call exit_unsupported if failed.

> +
> +echo "Testing function tracer with profiler:"
> +echo "enable function tracer"
> +echo function > current_tracer || exit 1
> +echo "enable profiler"
> +echo 1 > function_profile_enabled || exit 1

Now you don't need "|| exit 1", since if the command fails,
the shell exits with error code.

> +
> +sleep 1
> +
> +echo "Now filter on just schedule"
> +echo '*schedule' > set_ftrace_filter
> +> trace

echo > trace?

Thank you,

> +
> +echo "Now disable function profiler"
> +echo 0 > function_profile_enabled || exit 1
> +
> +sleep 1
> +
> +# make sure only schedule functions exist
> +
> +echo "testing if only schedule is being traced"
> +if grep -v -e '^#' -e 'schedule' trace; then
> +	echo "more than schedule was found"
> +	exit 1
> +fi
> +
> +echo "Make sure schedule was traced"
> +if ! grep -e 'schedule' trace > /dev/null; then
> +	cat trace
> +	echo "can not find schedule in trace"
> +	exit 1
> +fi
> +
> +echo "clear filter"
> +echo > set_ftrace_filter || exit 1
> +> trace
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
> +echo nop > current_tracer || exit 1
> +
> +exit 0
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


