Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab3EFMEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 08:04:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab3EFMEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 08:04:34 -0400
Date: Mon, 6 May 2013 14:04:11 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/14] perf ftrace: Add 'record' sub-command
Message-ID: <20130506120411.GA6035@krava.brq.redhat.com>
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
 <1366705872-12132-10-git-send-email-namhyung@kernel.org>
 <20130424141241.GG971@krava.brq.redhat.com>
 <87bo939lgt.fsf@sejong.aot.lge.com>
 <87mws8990n.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mws8990n.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 10:44:56AM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> Sorry for late reply.  I've been busy these days.
> 
> On Thu, 25 Apr 2013 15:24:18 +0900, Namhyung Kim wrote:
> > On Wed, 24 Apr 2013 16:12:41 +0200, Jiri Olsa wrote:
> >> I got following lockup for record command:
> >>
> >>   # ./perf --no-pager ftrace record ls
> >>   ...
> >>   hangs
> >>
> >>   in other terminal:
> >>
> >>   # pstack 14237
> >>   Thread 2 (Thread 0x7f3f1aa1d700 (LWP 14241)):
> >>   #0  0x0000003cec20b595 in pthread_cond_wait@@GLIBC_2.3.2 () from /lib64/libpthread.so.0
> >>   #1  0x0000000000446ebe in record_ftrace_raw_buffer (arg=0x21f9ce0) at builtin-ftrace.c:451
> >>   #2  0x0000003cec207d14 in start_thread () from /lib64/libpthread.so.0
> >>   #3  0x0000003cebaf168d in clone () from /lib64/libc.so.6
> >>   Thread 1 (Thread 0x7f3f1ba209c0 (LWP 14237)):
> >>   #0  0x0000003cec208e60 in pthread_join () from /lib64/libpthread.so.0
> >>   #1  0x0000000000449c8c in do_ftrace_record (ftrace=ftrace@entry=0x7fff1377d240) at builtin-ftrace.c:682
> >>   #2  0x000000000044a57b in __cmd_ftrace_record (argv=0x7fff1377d818, argc=<optimized out>, ftrace=0x7fff1377d240) at builtin-ftrace.c:1535
> >>   #3  cmd_ftrace (argc=2, argv=0x7fff1377d818, prefix=<optimized out>) at builtin-ftrace.c:1655
> >>   #4  0x000000000041a763 in run_builtin (p=p@entry=0x7d58a0, argc=argc@entry=3, argv=argv@entry=0x7fff1377d818) at perf.c:320
> >>   #5  0x0000000000419faf in handle_internal_command (argv=0x7fff1377d818, argc=3) at perf.c:377
> >>   #6  run_argv (argv=0x7fff1377d600, argcp=0x7fff1377d60c) at perf.c:421
> >>   #7  main (argc=3, argv=0x7fff1377d818) at perf.c:522
> >>
> >
> > How often can you reproduce it?  I can't. :(
> >
> > But it looks there's a race between cond_wait() and cond_broatcast().
> > I'll take a look at that.
> 
> I think the problem is that a recorder can be blocked if it received a
> broadcast signal before calling cond_wait().  So I modified the code to
> place signaling ready_cond and waiting start_cond in the same cs.
> 
> Does the patch below fix your problem?

yes.. without the patch I get lockup in like 10 minutes
with the patch the test is now ok for almost an hour..

jirka
