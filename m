Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab3GJM6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 08:58:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24401 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3GJM6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 08:58:13 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=mY5AGG0wUPsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=x45eBLDEq7QA:10 a=9eVWKDxGWOiRCeP2OfoA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373461091.7458.55.camel@gandalf.local.home>
Subject: Re: timer: lockup in run_timer_softirq()
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>,
        Tejun Heo <tj@kernel.org>, tglx@linutronix.de,
        LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org
Date: Wed, 10 Jul 2013 08:58:11 -0400
In-Reply-To: <20130710124245.GT25631@dyad.programming.kicks-ass.net>
References: <51DC902F.3070403@oracle.com>
	 <20130709224706.GA13855@redhat.com> <51DC9379.9050408@oracle.com>
	 <20130709230316.GB13855@redhat.com> <51DC983F.2010409@oracle.com>
	 <20130710095210.GD17211@twins.programming.kicks-ass.net>
	 <1373459254.7458.49.camel@gandalf.local.home>
	 <20130710124245.GT25631@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-10 at 14:42 +0200, Peter Zijlstra wrote:

> but but but preempt_disable_notrace() isn't an rcu_read_lock().. You can only
> do that for rcu_sched.

Right. And not even rcu_sched is safe, as function tracing can trace
functions out of rcu scope. That's why I had to add that code to do a
schedule_on_each_cpu() in ftrace.

> 
> Anyway, I don't see a nice way out of this mess :/ the entire perf core uses
> regular RCU and converting all that is going to me a nasty big patch.

There is an easier way. We can add a way to have perf not trace specific
functions. Now there's already infrastructure there to pick and choose
what to trace and what not to for individual function tracing users like
perf. The trick will be how to annotate them.

If there's a way to mark a function without moving it to a section, this
would be possible. Perhaps similar to EXPORT_SYMBOL(). We could add a
PERF_NOTRACE().

static void __local_bh_enable()
{
	[...]
}
PERF_NOTRACE(__local_bh_enable);

And add these to a black list of functions that perf should not trace.

How's that sound?

-- Steve


