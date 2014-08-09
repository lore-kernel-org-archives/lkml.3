Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaHIKgk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 06:36:40 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:59211 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaHIKgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 06:36:37 -0400
Message-ID: <53E5F9AD.6030802@hitachi.com>
Date: Sat, 09 Aug 2014 19:36:29 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
References: <20140807172753.GG3588@twins.programming.kicks-ass.net> <20140807184635.GI3588@twins.programming.kicks-ass.net> <20140807154907.6f59cf6e@gandalf.local.home> <20140807155326.18481e66@gandalf.local.home> <20140807200813.GB3935@laptop> <20140807171823.1a481290@gandalf.local.home> <20140808064020.GZ9918@twins.programming.kicks-ass.net> <20140808101221.21056900@gandalf.local.home> <20140808143413.GB9918@twins.programming.kicks-ass.net> <20140808105858.171da847@gandalf.local.home> <20140808162714.GG9918@twins.programming.kicks-ass.net> <20140808132716.28aa1c14@gandalf.local.home>
In-Reply-To: <20140808132716.28aa1c14@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/09 2:27), Steven Rostedt wrote:
> On Fri, 8 Aug 2014 18:27:14 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> On Fri, Aug 08, 2014 at 10:58:58AM -0400, Steven Rostedt wrote:
>>
>>>>> No, they are also used by optimized kprobes. This is why optimized
>>>>> kprobes depend on !CONFIG_PREEMPT. [ added Masami to the discussion ].
>>>>
>>>> How do those work? Is that one where the INT3 relocates the instruction
>>>> stream into an alternative 'text' and that JMPs back into the original
>>>> stream at the end?
>>>
>>> No, it's where we replace the 'int3' with a jump to a trampoline that
>>> simulates an INT3. Speeds things up quite a bit.
>>
>> OK, so the trivial 'fix' for that is to patch the probe site like:
>>
>> 	preempt_disable();		INC	GS:%__preempt_count
>> 	call trampoline;		CALL	0xDEADBEEF
>> 	preempt_enable();		DEC	GS:%__preempt_count
>> 					JNZ	1f
>> 					CALL	___preempt_schedule
>> 				1f:
>>
>> At which point the preempt_disable/enable() are the read side primitives
>> and call_rcu_sched/synchronize_sched are sufficient to release it.
>>
>> With the per-cpu preempt count stuff we have on x86 that is 4
>> instructions for the preempt_*() stuff -- they're 'big' instructions
>> though, since 3 have memops and 2 have a segment prefix.
>>
>>
> 
> Well, this looks like it may make kprobes a bit more complex, and even
> slow down slightly the optimized probe.

This may not only influence the performance, but also reduce the
applicability of optprobe too much :(
Since the optprobe can replace multiple instructions, it decodes probe
site to find out the basic blocks for avoiding the jump instruction to
across the border of the basic blocks, which can cause another branch
can jump into the jump instruction.
So, patching "big" instruction series for the probe site just reduces
the possibility of jump optimization. I don't think that is practical.

Thank you,

> 
> Also note that if we add call_rcu_tasks(), then perf function tracing
> can be called directly instead of being added to the trampoline that
> disables and enables preemption before calling it.
> 
> -- Steve
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


