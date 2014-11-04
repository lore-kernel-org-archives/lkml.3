Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaKDODS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:03:18 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:57266 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751510AbaKDODR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:03:17 -0500
Date: Tue, 4 Nov 2014 09:03:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 4/4 v2] ftracetest: Add a couple of ftrace test
 cases
Message-ID: <20141104090315.4726130e@gandalf.local.home>
In-Reply-To: <87h9yf5pu4.fsf@sejong.aot.lge.com>
References: <20141103212737.696365174@goodmis.org>
	<20141103212842.139783956@goodmis.org>
	<87h9yf5pu4.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2014 17:31:47 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Steve,
> 
> Just a few nitpicks..  Otherwise looks good to me.
> 

Of course. It wasn't easy taking my hacks and making them somewhat less
hacky.

> 
> On Mon, 03 Nov 2014 16:27:41 -0500, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> >
> > Added three test cases to get the feel of adding tests to ftracetest.
> > The three cases are:
> >
> >   function profiling test, to make sure function profiling still works
> >    with function tracing (was a regression)
> >
> >   function graph filter test to make sure that function graph filtering works.
> >
> >   function graph filter with stack tracing test to make sure that the function
> >    graph filter does filter and also continues to filter when another function tracer
> >    is running (like the stack tracer)
> >
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  .../ftrace/test.d/ftrace/fgraph-filter-stack.tc    | 94 ++++++++++++++++++++++
> >  .../ftrace/test.d/ftrace/fgraph-filter.tc          | 49 +++++++++++
> >  .../ftrace/test.d/ftrace/func_profiler.tc          | 76 +++++++++++++++++
> >  3 files changed, 219 insertions(+)
> >  create mode 100644 tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter-stack.tc
> >  create mode 100644 tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter.tc
> >  create mode 100644 tools/testing/selftests/ftrace/test.d/ftrace/func_profiler.tc
> >
> > diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter-stack.tc b/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter-stack.tc
> > new file mode 100644
> > index 000000000000..3d8f79176681
> > --- /dev/null
> > +++ b/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter-stack.tc
> > @@ -0,0 +1,94 @@
> > +#!/bin/sh
> > +# description: ftrace - function graph filters with stack tracer
> > +
> > +# Make sure that function graph filtering works, and is not
> > +# affected by other tracers enabled (like stack tracer)
> > +
> > +if ! grep -q function_graph available_tracers; then
> > +    echo "no function graph tracer configured"
> > +    exit_unsupported
> > +fi
> > +
> > +if [ ! -f set_ftrace_filter ]; then
> > +    echo "set_ftrace_filter not found? Is dynamic ftrace not set?"
> > +    exit_unsupported
> > +fi
> > +
> > +do_reset() {
> > +    reset_tracer
> > +    echo 0 > /proc/sys/kernel/stack_tracer_enabled
> > +    enable_tracing
> > +    clear_trace
> > +    echo > set_ftrace_filter
> > +}
> > +
> > +disable_tracing
> > +clear_trace;
> > +
> > +# filter something, schedule is always good
> > +if ! echo "schedule" > set_ftrace_filter; then
> > +    # test for powerpc 64
> > +    if ! echo ".schedule" > set_ftrace_filter; then
> 
> You did 'echo '*schedule' > set_ftrace_filter' in the last test case.

That was me being lazy. :-)

I actually like having both ways, as it adds different types of testing
to the infrastructure. When it comes to testing, having all tests do
everything the same isn't always the best thing. I've found most my bugs
by tests doing things slightly different.

> 
> 
> > +	echo "can not enable schedule filter"
> > +	exit -1
> > +    fi
> > +fi
> > +
> > +echo function_graph > current_tracer
> > +
> > +if [ ! -f stack_trace ]; then
> > +    echo "Stack tracer not configured"
> > +    do_reset
> > +    exit_unsupported;
> > +fi
> > +
> > +echo "Now testing with stack tracer"
> > +
> > +echo 1 > /proc/sys/kernel/stack_tracer_enabled
> > +
> > +disable_tracing
> > +clear_trace
> > +enable_tracing
> > +sleep 1
> > +
> > +count=`cat trace | grep '()' | grep -v schedule | wc -l`
> > +
> > +if [ $count -ne 0 ]; then
> > +    echo "Graph filtering not working with stack tracer?"
> > +    exit -1
> > +fi
> > +
> > +count=`cat trace | grep 'schedule()' | wc -l` 
> > +if [ $count -eq 0 ]; then
> > +    echo "No schedule traces found?"
> > +    exit -1
> > +fi
> > +
> > +# Make sure we did find something
> > +count=`cat trace | grep 'schedule()' | wc -l` 
> > +if [ $count -eq 0 ]; then
> > +    echo "No schedule traces found?"
> > +    exit -1
> > +fi
> 
> Do you really want to do it twice?

Crap, no. Hmm, that was probably suppose to go into the other file. Let
me fix that.

> 
> 
> > +
> > +echo 0 > /proc/sys/kernel/stack_tracer_enabled
> > +clear_trace
> > +sleep 1
> > +
> > +
> > +count=`cat trace | grep '()' | grep -v schedule | wc -l`
> > +
> > +if [ $count -ne 0 ]; then
> > +    echo "Graph filtering not working after stack tracer disabled?"
> > +    exit -1
> > +fi
> > +
> > +count=`cat trace | grep 'schedule()' | wc -l` 
> > +if [ $count -eq 0 ]; then
> > +    echo "No schedule traces found?"
> > +    exit -1
> > +fi
> > +
> > +do_reset
> > +
> > +exit 0
> 
> 
> [SNIP]
> > --- /dev/null
> > +++ b/tools/testing/selftests/ftrace/test.d/ftrace/func_profiler.tc
> > @@ -0,0 +1,76 @@
> > +#!/bin/sh
> > +# description: ftrace - function profiler with function tracing
> > +
> > +# There was a bug after a rewrite of the ftrace infrastructure that
> > +# caused the function_profiler not to be able to run with the function
> > +# tracer, because the function_profiler used the function_graph tracer
> > +# and it was assumed the two could not run simultaneously.
> > +#
> > +# There was another related bug where the solution to the first bug
> > +# broke the way filtering of the function tracer worked.
> > +#
> > +# This test triggers those bugs on those kernels.
> > +#
> > +# We need function_graph and profiling to to run this test
> > +if ! grep -q function_graph available_tracers; then
> > +    echo "no function graph tracer configured"
> > +    exit_unsupported;
> > +fi
> > +
> > +if [ ! -f set_ftrace_filter ]; then
> > +    echo "set_ftrace_filter not found? Is dynamic ftrace not set?"
> > +    exit_unsupported
> > +fi
> > +
> > +if [ ! -f function_profile_enabled ]; then
> > +    echo "function_profile_enabled not found, function profiling enabled?"
> > +    exit_unsupported
> > +fi
> > +
> > +echo "Testing function tracer with profiler:"
> > +echo "enable function tracer"
> > +echo function > current_tracer
> > +echo "enable profiler"
> > +echo 1 > function_profile_enabled
> 
> Oh, this test is verbose.. :)

I could switch those to comments. When running the tests, these are
suppressed. Should I change them?

> 
> 
> > +
> > +sleep 1
> > +
> > +echo "Now filter on just schedule"
> > +echo '*schedule' > set_ftrace_filter
> 
> Here..

Yep, me being lazy. But I think I'll keep it as a variant. At least
until I have better testing of filters. This is really basic. My stress
tests use trace-cmd, which isn't what we want for these tests.


> 
> > +clear_trace
> > +
> > +echo "Now disable function profiler"
> > +echo 0 > function_profile_enabled
> > +
> > +sleep 1
> > +
> > +# make sure only schedule functions exist
> > +
> > +echo "testing if only schedule is being traced"
> > +if grep -v -e '^#' -e 'schedule' trace; then
> 
> It seems you might want to add -q or > /dev/null.  Or count the
> resulting lines like other tests.

Why?

The -v is an inverse search. It returns true if it finds anything but
'^#' and 'schedule', and false if it doesn't.

That's what we want. Why count lines? We could add -q, but again, all
output is suppressed. This came from my own test scripts, and there I
purposely left out the -q because if it failed, I wanted to see what
was there that wasn't suppose to be.

-- Steve
