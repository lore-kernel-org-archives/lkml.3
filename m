Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaHIK5J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 06:57:09 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38602 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaHIK5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 06:57:03 -0400
Message-ID: <53E5FE78.4030903@hitachi.com>
Date: Sat, 09 Aug 2014 19:56:56 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, bobby.prani@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
References: <20140807150031.GB5821@linux.vnet.ibm.com> <20140807152600.GW9918@twins.programming.kicks-ass.net> <20140807172753.GG3588@twins.programming.kicks-ass.net> <20140807184635.GI3588@twins.programming.kicks-ass.net> <20140807154907.6f59cf6e@gandalf.local.home> <20140807155326.18481e66@gandalf.local.home> <20140807200813.GB3935@laptop> <20140807171823.1a481290@gandalf.local.home> <20140808064020.GZ9918@twins.programming.kicks-ass.net> <20140808101221.21056900@gandalf.local.home> <20140808142810.GV5821@linux.vnet.ibm.com>
In-Reply-To: <20140808142810.GV5821@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/08 23:28), Paul E. McKenney wrote:
> On Fri, Aug 08, 2014 at 10:12:21AM -0400, Steven Rostedt wrote:
>> On Fri, 8 Aug 2014 08:40:20 +0200
>> Peter Zijlstra <peterz@infradead.org> wrote:
>>
>>> On Thu, Aug 07, 2014 at 05:18:23PM -0400, Steven Rostedt wrote:
>>>> On Thu, 7 Aug 2014 22:08:13 +0200
>>>> Peter Zijlstra <peterz@infradead.org> wrote:
>>>>
>>>>> OK, you've got to start over and start at the beginning, because I'm
>>>>> really not understanding this..
>>>>>
>>>>> What is a 'trampoline' and what are you going to use them for.
>>>>
>>>> Great question! :-)
>>>>
>>>> The trampoline is some code that is used to jump to and then jump
>>>> someplace else. Currently, we use this for kprobes and ftrace. For
>>>> ftrace we have the ftrace_caller trampoline, which is static. When
>>>> booting, most functions in the kernel call the mcount code which
>>>> simply returns without doing anything. This too is a "trampoline". At
>>>> boot, we convert these calls to nops (as you already know). When we
>>>> enable callbacks from functions, we convert those calls to call
>>>> "ftrace_caller" which is a small assembly trampoline that will call
>>>> some function that registered with ftrace.
>>>>
>>>> Now why do we need the call_rcu_task() routine?
>>>>
>>>> Right now, if you register multiple callbacks to ftrace, even if they
>>>> are not tracing the same routine, ftrace has to change ftrace_caller to
>>>> call another trampoline (in C), that does a loop of all ops registered
>>>> with ftrace, and compares the function to the ops hash tables to see if
>>>> the ops function should be called for that function.
>>>>
>>>> What we want to do is to create a dynamic trampoline that is a copy of
>>>> the ftrace_caller code, but instead of calling this list trampoline, it
>>>> calls the ops function directly. This way, each ops registered with
>>>> ftrace can have its own custom trampoline that when called will only
>>>> call the ops function and not have to iterate over a list. This only
>>>> happens if the function being traced only has this one ops registered.
>>>> For functions with multiple ops attached to it, we need to call the
>>>> list anyway. But for the majority of the cases, this is not the case.
>>>>
>>>> The one caveat for this is, how do we free this custom trampoline when
>>>> the ops is done with it? Especially for users of ftrace that
>>>> dynamically create their own ops (like perf, and ftrace instances).
>>>>
>>>> We need to find a way to free it, but unfortunately, there's no way to
>>>> know when it is safe to free it. There's no way to disable preemption
>>>> or have some other notifier to let us know if a task has jumped to this
>>>> trampoline and has been preempted (sleeping). The only safe way to know
>>>> that no task is on the trampoline is to remove the calls to it,
>>>> synchronize the CPUS (so the trampolines are not even in the caches),
>>>> and then wait for all tasks to go through some quiescent state. This
>>>> state happens to be either not running, in userspace, or when it
>>>> voluntarily calls schedule. Because nothing that uses this trampoline
>>>> should do that, and if the task voluntarily calls schedule, we know
>>>> it's not on the trampoline.
>>>>
>>>> Make sense?
>>>
>>> Ok, so they're purely used in the function prologue/epilogue callchain.
>>
>> No, they are also used by optimized kprobes. This is why optimized
>> kprobes depend on !CONFIG_PREEMPT. [ added Masami to the discussion ].
>>
>> Which reminds me. On !CONFIG_PREEMPT, call_rcu_task() should be
>> equivalent to call_rcu_sched().
> 
> Almost.  One difference is that call_rcu_sched() won't wait for
> idle-task execution.  So presumably you are currently prohibited from
> putting kprobes in idle tasks.

No need to prohibit all kprobes, just prohibit optimizing if the kprobe
is in the idle context (if I can detect it). Since I've already replaced
text-area based __kprobes with list-based NOKPROBE_SYMOBOL in core kernel,
I think it is an option to add NOOPTPROBE_SYMBOL for that purpose.

Thank you,

> Oleg slipped this one past me, and for more than a full hour,
> (https://lkml.org/lkml/2014/8/2/18), but this time I remembered.  ;-)
> 
> 							Thanx, Paul



-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


