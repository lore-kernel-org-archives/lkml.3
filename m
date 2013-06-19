Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934965Ab3FSR5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:57:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933869Ab3FSR5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:57:03 -0400
Date: Wed, 19 Jun 2013 19:51:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] tracing/perf: perf_trace_buf/perf_xxx hacks.
Message-ID: <20130619175139.GA20454@redhat.com>
References: <20130618192147.GA19443@redhat.com> <20130619121039.GA19225@twins.programming.kicks-ass.net> <20130619152844.GA9176@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619152844.GA9176@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19, Oleg Nesterov wrote:
>
> On 06/19, Peter Zijlstra wrote:
> >
> > I'm probably missing something obviuos, but what are we trying to do?
>
> Say, "perf record -e sched:sched_switch -p1".
>
> Every task except /sbin/init will do perf_trace_sched_switch() and
> perf_trace_buf_prepare() + perf_trace_buf_submit for no reason(),
> it doesn't have a counter.

I did some testing under kvm, not sure these numbers actually mean
something, but still.

So, the test-case:

	int pipe1[2], pipe2[2];

	void *tfunc(void *arg)
	{
		for (;;) {
			char c;
			assert(read(pipe1[0], &c, 1) == 1);
			assert(write(pipe2[1], &c, 1) == 1);
		}
	}

	int main(void)
	{
		pthread_t thr;
		int nr;

		assert(pipe(pipe1) == 0);
		assert(pipe(pipe2) == 0);

		assert(pthread_create(&thr, NULL, tfunc, NULL) == 0);

		for (nr = 0; nr < 1000 * 1000; ++nr) {
			char c;

			assert(write(pipe1[1], &c, 1) == 1);
			assert(read(pipe2[0], &c, 1) == 1);
		}

		return 0;
	}

Idle machine, "/usr/bin/time -f "%e %S %U" taskset 1 ./pf" 3 times:

	20.73 20.05 0.66
	20.68 20.04 0.63
	20.68 20.02 0.65

Now with "perf record -e sched:sched_switch -p1" running,

before 3/3:

	21.59 20.77 0.80
	21.40 20.70 0.68
	21.50 20.72 0.78

after 3/3:

	21.00 20.23 0.76
	20.89 20.19 0.69
	20.94 20.26 0.66

Oleg.

