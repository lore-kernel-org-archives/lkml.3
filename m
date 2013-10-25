Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3JYNLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:11:11 -0400
Received: from mail-gg0-f179.google.com ([209.85.161.179]:39522 "EHLO
	mail-gg0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab3JYNLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:11:07 -0400
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Oct 2013 09:11:07 EDT
Date: Fri, 25 Oct 2013 09:12:11 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dave Jones <davej@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: perf/ftrace lockup on 3.12-rc6 with trigger code
In-Reply-To: <1382695687.12254.4.camel@pippen.local.home>
Message-ID: <alpine.DEB.2.10.1310250906110.22710@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1310241324330.4352@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1310241422460.6573@vincent-weaver-1.um.maine.edu> <1382695687.12254.4.camel@pippen.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Oct 2013, Steven Rostedt wrote:

> On Thu, 2013-10-24 at 14:25 -0400, Vince Weaver wrote:
> > On Thu, 24 Oct 2013, Vince Weaver wrote:
> > > after a month of trying I finally got a small test-case out of my 
> > > perf_fuzzer suite that triggers a system lockup with just one syscall.
> > > 
> > > Attached is the code that triggers it.
> > 
> > And it turns out you can only trigger this specific problem if advanced 
> > ftrace options are enabled.
> > 
> > CONFIG_KPROBES_ON_FTRACE=y
> > CONFIG_FUNCTION_TRACER=y
> > CONFIG_FUNCTION_GRAPH_TRACER=y
> > CONFIG_STACK_TRACER=y
> > CONFIG_DYNAMIC_FTRACE=y
> > CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
> > CONFIG_FUNCTION_PROFILER=y
> > CONFIG_FTRACE_MCOUNT_RECORD=y
> 
> The above STACK_TRACER, FTRACE_WITH_REGS and FUNCTION_PROFILER probably
> don't need to be set, as they are pretty much stand alone, and don't
> look to be involved in the stack traces that you (and Dave) posted.
> 
> > 
> > Urgh, I had turned those on to try to debug something and forgot to 
> > disable.  I feel like I saw this problem before I had those enabled so I 
> > guess I have to start from scratch fuzzing to see if I can get a more
> > generally reproducible trace.
> 
> Looks like something is incorrectly enabling function tracer within
> perf. Peter told me that there's some ref count bug that may use data
> after being freed on exit.
> 
> I tried the program that you attached in you previous email, and was not
> able to hit the bug. Are you able to hit the bug with that code each
> time?

yes.  My poor core2 machine has been hard-reset (hold down the power 
button it's locked that hard) about 200 times in the past month while 
trying to track down this problem.

I'm not sure how tracepoints work exactly, but the problem code is setting
	pe[5].type=PERF_TYPE_TRACEPOINT;
	pe[5].config=0x7fffffff00000001;

The config is being truncated to 32-bits by the perf/ftrace code so I 
think this means the tracepoint being enabled is

	tracing/events/ftrace/function/id:1

The sample period is set to

        pe[5].sample_period=0xffffffffff000000;

and the fd is set to generate a signal on overflow (the crash doesn't 
happen unless a signal handler is set up).

If I must I can problem start sprinkling printks around the code to try to 
track things down in more detail but I'd rather not if I can avoid that.

Vince
