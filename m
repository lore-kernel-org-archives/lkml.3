Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab3KOBQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 20:16:27 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:53265 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab3KOBQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 20:16:21 -0500
Message-ID: <528575E2.4000700@hitachi.com>
Date: Fri, 15 Nov 2013 10:16:18 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu> <20131108200244.GB14606@localhost.localdomain> <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu> <20131108204839.GD14606@localhost.localdomain> <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu> <20131108223657.GF14606@localhost.localdomain> <20131109151014.GN16117@laptop.programming.kicks-ass.net> <20131114152304.GC5364@laptop.programming.kicks-ass.net> <20131114153301.GD5364@laptop.programming.kicks-ass.net>
In-Reply-To: <20131114153301.GD5364@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/15 0:33), Peter Zijlstra wrote:
> On Thu, Nov 14, 2013 at 04:23:04PM +0100, Peter Zijlstra wrote:
>>  /*
>> + * We must dis-allow sampling irq_work_exit() because perf event sampling
>> + * itself can cause irq_work, which would lead to an infinite loop;
>> + *
>> + *  1) irq_work_exit happens
>> + *  2) generates perf sample
>> + *  3) generates irq_work
>> + *  4) goto 1
>> + */
>> +TRACE_EVENT_PERF_PERM(irq_work_exit, is_sampling_event(p_event) ? -EPERM : 0);
> 
> And the only reason this doesn't feed fwd itself into oblivion for
> irq_work_enter() is because the irq_work_list must not be empty when the
> interrupt is raised, and queueing further work does not re-raise the
> IPI.
> 
> 
> Also, we should probably do something 'smart' for kprobes, as all of
> irq_work.c and plenty of perf itself is not __kprobe marked so you're
> all free to insert kprobes in the middle of perf and then attach perf to
> such a thing.

Kprobes itself can detect nested call by using per-cpu current-running
kprobe pointer. And if it is nested, it just skips calling handlers.
Anyway, I don't recommend to probe inside the handlers, but yes,
you can trace perf-handler by ftrace B). I actually traced a kprobe-bug
by kprobe-tracer last night, that was amazing :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


