Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab3EMPDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:03:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23338 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab3EMPDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:03:42 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=L14AFVN-rE8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=LQh7Td0SupIA:10 a=Mfv4wl1ZcoLWM-0cPuQA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368457419.6828.31.camel@gandalf.local.home>
Subject: Re: [PATCH 1/3] x86/sched/context_tracking: Call new
 schedule_preempt_user() from entry_64.S
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 13 May 2013 11:03:39 -0400
In-Reply-To: <1368438990.2618.55.camel@ThinkPad-T5421>
References: <20130510211225.594959788@goodmis.org>
	 <20130510211825.341015861@goodmis.org>
	 <1368438990.2618.55.camel@ThinkPad-T5421>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 17:56 +0800, Li Zhong wrote:

> > All this before schedule_user() was able to call user_exit() and take us
> > out of dynamic tick user context.
> 
> Maybe we could just disable function trace for schedule_user()? 
> 
> It seems that function trace might use RCU, at least in __schedule()
> when calling preempt_enable(), and if preemption is really enabled. 

There is a small use of rcu scheduling (preempt disable/enable) in
function tracing. One is for perf and dynamic call traces and some hash
code (multiple users of the function tracer). But those are the unique
cases, and I really do not want to remove this function just for the non
common case. Function tracing has proven extremely useful in debugging
RCU and context tracking. By adding notrace, it's a lost cause.

Not to mention, adding trace_printk() there will break it too, and that
does not use any RCU but still disables preemption because the writing
to the ring buffer requires staying on the same CPU.

> 
> user_exit() is used to allow RCU usage after that (with rcu_user_exit).
> RCU usage is not allowed before that because cpu is in user eqs. And if
> function trace needs use RCU, then it seems user_exit() itself or its
> callers couldn't be function traced.

And it can't be debugged either.

I can probably black list those functions manually, such that only the
main function tracer can trace it, all others will not. In otherwords, I
can have it such that function tracer will not trace those functions for
perf, dynamic function tracers, or anything that requires changing the
function list.

I could probably also add a heavier weight synchronize_sched() that even
synchronizes cpus in userspace.


> 
> If __schedule() in preempt_enable() is the only place function trace
> uses RCU, then after converting to schedule_preempt_user(), it is safe
> as irqs are disabled for __schedule() to happen. But user_exit() itself
> and some other callers might still need function trace be disabled.

The above makes no sense to me. function tracing didn't break, but the
user_exit() did because of a preemption in the wrong place, as there was
no protection there to prevent an unnecessary preemption.


-- Steve


