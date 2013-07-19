Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab3GSU1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 16:27:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25240 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab3GSU1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 16:27:24 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=RlVDF7lzNMQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=R1XAcQrJXZkA:10 a=20KFwNOVAAAA:8 a=ayC55rCoAAAA:8 a=uo9KpuxPFzrzqbvv0iYA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=q9mC2fbAJx8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374265641.3356.31.camel@gandalf.local.home>
Subject: Re: [PATCH RESEND 0/3] Teach perf_trace_##call() to check
 hlist_empty(perf_events)
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 19 Jul 2013 16:27:21 -0400
In-Reply-To: <20130719074339.GA22597@gmail.com>
References: <20130718183018.GA4043@redhat.com>
	 <20130719074339.GA22597@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-19 at 09:43 +0200, Ingo Molnar wrote:
> * Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > Hello.
> > 
> > The patches are the same, I only tried to update the changelogs a bit.
> > I am also quoting my old email below, to explain what this hack tries
> > to do.
> > 
> > 	Say, "perf record -e sched:sched_switch -p1".
> > 
> > 	Every task except /sbin/init will do perf_trace_sched_switch() and
> > 	perf_trace_buf_prepare() + perf_trace_buf_submit for no reason(),
> > 	it doesn't have a counter.
> > 
> > 	So it makes sense to add the fast-path check at the start of
> > 	perf_trace_##call(),
> > 
> > 		if (hlist_empty(event_call->perf_events))
> > 			return;
> > 
> > 	The problem is, we should not do this if __task != NULL (iow, if
> > 	DECLARE_EVENT_CLASS() uses __perf_task()), perf_tp_event() has the
> > 	additional code for this case.
> > 
> > 	So we should do
> > 
> > 		if (!__task && hlist_empty(event_call->perf_events))
> > 			return;
> > 
> > 	But __task is changed by "{ assign; }" block right before
> > 	perf_trace_buf_submit(). Too late for the fast-path check,
> > 	we already called perf_trace_buf_prepare/fetch_regs.
> > 
> > 	So. After 2/3 __perf_task() (and __perf_count/addr) is called
> > 	when ftrace_get_offsets_##call(args) evaluates the arguments,
> > 	and we can check !__task && hlist_empty() right after that.
> > 
> > Oleg.
> 
> Nice improvement.
> 
> Peter, Steve, any objections?
> 

Yep, agreed.


The whole series...

Reviewed-and-Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


