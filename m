Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935193Ab3DKMCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:02:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763999Ab3DKMCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:02:07 -0400
Date: Thu, 11 Apr 2013 13:59:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 0/1] uprobes/tracing: Don't pass addr=ip to
	perf_trace_buf_submit()
Message-ID: <20130411115921.GA27492@redhat.com>
References: <20130329181520.GA20670@redhat.com> <20130329181545.GA20697@redhat.com> <20130404142522.GC8986@linux.vnet.ibm.com> <515E4938.6090809@hitachi.com> <20130405150110.GA31300@redhat.com> <51628DF8.6030102@hitachi.com> <20130410145818.GA30670@redhat.com> <516692BF.6070904@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516692BF.6070904@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11, Masami Hiramatsu wrote:
>
> (2013/04/10 23:58), Oleg Nesterov wrote:
>
> > And... Cough, another question ;) To simplify, lets discuss kprobe_perf_func()
> > only. Suppose that a task hits the kprobe but this task/cpu doesn't have
> > a counter. Can't we avoid perf_trace_buf_prepare/submit in this case?
> > IOW, what do you think about the change below?
>
> Hmm, I'm not so sure how frequently this happens.

Suppose that you do, say, "perf record -e probe:some_func workload". Only
"workload" will have the active counter, any other task which hits the
probed some_func() will do perf_trace_buf_prepare/perf_trace_buf_submit
just to realize that nobody wants perf_swevent_event().

Simple test-case:

	#include <unistd.h>

	int main(void)
	{
		int n;

		for (n = 0; n < 1000 * 1000; ++n)
			getppid();

		return 0;
	}

Without kprobe:

	# time ./ppid

	real    0m0.663s
	user    0m0.163s
	sys     0m0.500s

Activate the probe:

	# perf probe sys_getppid

	# perf record -e probe:sys_getppid sleep 1000 &
	[1] 546

Test it again 3 times:

	# time ./ppid

Before the patch:

	real    0m9.727s
	user    0m0.177s
	sys     0m9.547s

	real    0m9.752s
	user    0m0.180s
	sys     0m9.573s

	real    0m9.761s
	user    0m0.187s
	sys     0m9.573s

After the patch:

	real    0m9.605s
	user	0m0.163s
	sys	0m9.437s

	real	0m9.592s
	user	0m0.167s
	sys	0m9.423s

	real	0m9.613s
	user	0m0.183s
	sys	0m9.427s

So the difference looks measurable but small, and I did the testing
under qemu so I do not really know if we can trust the numbers.

> And, is this right way to
> handle that case?

If only I was sure ;) I am asking.

And, to clarify, it is not that I think this change can really
improve the perfomance. Just I am trying to understand what I have
missed.

> If so, we can do same thing also on trace_events.
> (perf_trace_##call in include/trace/ftrace.h)

Yes, yes, this is not kprobe-specific. It seems that more users of
perf_trace_buf_submit() could be changed the same way.

Thanks,

Oleg.

