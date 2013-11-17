Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab3KQHyO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 02:54:14 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42989 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3KQHyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 02:54:01 -0500
Message-ID: <52887617.7050302@hitachi.com>
Date: Sun, 17 Nov 2013 16:53:59 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
References: <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu> <20131108204839.GD14606@localhost.localdomain> <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu> <20131108223657.GF14606@localhost.localdomain> <20131109151014.GN16117@laptop.programming.kicks-ass.net> <20131114152304.GC5364@laptop.programming.kicks-ass.net> <20131114153301.GD5364@laptop.programming.kicks-ass.net> <528575E2.4000700@hitachi.com> <20131115122833.GE10456@twins.programming.kicks-ass.net> <20131115091521.3ad917fe@gandalf.local.home> <20131115142851.GA17498@localhost.localdomain>
In-Reply-To: <20131115142851.GA17498@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/15 23:28), Frederic Weisbecker wrote:
> On Fri, Nov 15, 2013 at 09:15:21AM -0500, Steven Rostedt wrote:
>> On Fri, 15 Nov 2013 13:28:33 +0100
>> Peter Zijlstra <peterz@infradead.org> wrote:
>>
>>> On Fri, Nov 15, 2013 at 10:16:18AM +0900, Masami Hiramatsu wrote:
>>>> Kprobes itself can detect nested call by using per-cpu current-running
>>>> kprobe pointer. And if it is nested, it just skips calling handlers.
>>>> Anyway, I don't recommend to probe inside the handlers, but yes,
>>>> you can trace perf-handler by ftrace B). I actually traced a kprobe-bug
>>>> by kprobe-tracer last night, that was amazing :)
>>>
>>> Ah, ok, so that would avoid the worst problems. Good. Should we still
>>> mark the entire perf swevent path as __kprobes just to be sure?
>>
>> I wouldn't unless we can prove that it breaks. It's sometimes nice to
>> be able to debug the debugging facilities with the debugging
>> facilities ;-)
> 
> Even with the existing __kprobes annotations, I'm sure we can find many ways to
> break the kernel.
> 
> We can reproduce that bug with irq_work recursion with setting a kprobe in
> the end of the irq_work() arch low level handler for example. Or simply
> somewhere in irq_exit().
>
> I think we could do dangerous things with breakpoints as well. Setting breakpoints
> in do_debug() or stuffs like that.
> 
> So keeping up with __kprobes annotations to every potential dangerous site
> is not viable IMHO. It's important to maintain basic sanity with tagging sites
> that are used by kprobes itself but we can't really prevent from any issue.
> 
> At some point it's up to the user to know what he's doing and avoid recursion.
> As long as kprobes can be set only by root.

Hmm, it would be better to add some documentation how users can avoid
such thing.

> OTOH it would be nice to detect these kind of behaviour (thinking about irq_work for
> example) and warn when something wrong is suspected.

Agreed.
FYI, kprobes has a recursion detection counter and it is reported via
debugfs/tracing/kprobe_profile :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


