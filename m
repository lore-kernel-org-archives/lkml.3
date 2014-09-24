Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbaIXPmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:42:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:14948 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753249AbaIXPmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:42:38 -0400
Date: Wed, 24 Sep 2014 11:42:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC][PATCH] ftracetest: Add a couple of ftrace test cases
Message-ID: <20140924114235.4287f4a1@gandalf.local.home>
In-Reply-To: <5422336A.6030304@hitachi.com>
References: <20140923173846.603cb49c@gandalf.local.home>
	<5422336A.6030304@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014 11:58:50 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2014/09/24 6:38), Steven Rostedt wrote:
 
> >   to them and copied them pretty much unchanged into a ftrace directory
> >   under test.d. Is this fine, or is there more massaging I need to do
> >   to them?
> 
> Yeah, ftrace has a double meaning :), so test.d/ftrace is fine to me.

I was thinking that more complex tests can go into ftrace, and simple
tests can go into basic.

> 
> > 
> >   I know the echos don't show up, but I kept them anyway. What should
> >   happen with them?
> 
> I think you'd better use exit_unsupported/exit_xfail to notify
> that the test target is not configured, or expected to fail.

OK, that answers the exit codes (as you also stated below), but what
about the echos themselves?

> Then the user can reconfigure that. Maybe we should keep the
> detailed log of such results. (you can do it with --keep option)

You mean keep the echos, as they are ignored anyway, but if we add
--keep, then the echos will show?  Maybe that option should be -v, like
other tools use for "verbose".


> > --- /dev/null
> > +++ b/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter.tc
> > @@ -0,0 +1,111 @@
> > +#!/bin/sh
> > +# description: ftrace - function graph filters
> > +
> > +# Make sure that function graph filtering works, and is not
> > +# affected by other tracers enabled (like stack tracer)
> > +
> > +if ! grep -q function_graph available_tracers; then
> > +    echo "no function graph tracer configured"
> > +    exit 0;
> 
> This should call exit_unsupported, because the test is not passed.

Will update this and others.


> > +# Make sure we did find something
> > +count=`cat trace | grep 'schedule()' | wc -l` 
> > +if [ $count -eq 0 ]; then
> > +    echo "No schedule traces found?"
> > +    exit -1
> > +fi
> > +
> > +echo "Graph filtering works by itself"
> > +
> 
> I think the following part should be a separated test for
> stack trace.

Good point. A lot of my test scripts do multiple tests. I think for
putting them into tools/testing/selftests/ftrace, I'll break them up
and make them separate tests. For example, the simple graph filtering
above is an example of something that can go into the basic directory,
but the test against stack tracer should be in ftrace. What do you
think?


> > +
> > +echo "Now filter on just schedule"
> > +echo '*schedule' > set_ftrace_filter
> > +> trace
> 
> echo > trace?

OK. Hmm, I wonder if we should make a bunch of functions that the tests
can use. Like a "clear_trace" call that does this. Can we export
functions that this shell will be able to use? When we see lots of
duplicate code we may want to have something like that. Well, for this,
it may not be that big of a deal, because "echo > trace" is rather
simple. But I do have other operations that are a bit more intrusive.

-- Steve

