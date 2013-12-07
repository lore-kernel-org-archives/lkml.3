Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3LGCe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 21:34:56 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47247 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab3LGCez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 21:34:55 -0500
Message-ID: <52A28945.1080904@hitachi.com>
Date: Sat, 07 Dec 2013 11:34:45 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL() and
 fixes crash bugs
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal> <20131204084551.GA31772@gmail.com> <529FBA71.6070107@hitachi.com> <y0mvbz3pd3z.fsf@fche.csb> <52A16AD7.6040500@hitachi.com> <20131206190753.GA3201@redhat.com> <52A25B71.3090108@hitachi.com> <20131207013249.GC3201@redhat.com>
In-Reply-To: <20131207013249.GC3201@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/07 10:32), Frank Ch. Eigler wrote:
> Hi -
> 
> On Sat, Dec 07, 2013 at 08:19:13AM +0900, Masami Hiramatsu wrote:
> 
>> [...]
>>> Would you plan to limit kprobes (or just the perf-probe frontend) to
>>> only function-entries also?
> 
>> Exactly, yes :). Currently I have a patch for kprobe-tracer
>> implementation (not only for perf-probe, but doesn't limit kprobes
>> itself).
> 
> Interesting option.  It sounds like a restrictive expedient that could
> result in kprobes never being made sufficiently robust.

the raw-kprobes users like systemtap can also implement its own
whitelist. :) ftrace-based whitelist is only useful for ftrace/perf.
Anyway, the list is open via debugfs as available_filter_functions.

>>> If not, and if intra-function statement-granularity kprobes remain
>>> allowed within a function-granularity whitelist, then you might
>>> still have those "quantitative" problems.
> 
>> Yes, but as far as I've tested, the performance overhead is not
>> high, especially as far as putting kprobes at the entry of those
>> functions because of ftrace-based optimization.
> 
> (Would that also make CONFIG_KPROBE_EVENT require KPROBES_ON_FTRACE?)

Ah, no but a good point. at least the whitelist requires
CONFIG_FUNCTION_TRACER.

>>> Even worse, kprobes robustness problems can bite even with a small
>>> whitelist, unless you can test the countless subset selections
>>> cartesian-product the aggrevating factors (like other tracing
>>> facilities being in use at the same time, limited memory, high irq
>>> rates, debugging sessions, architectures, whatever).
>>
>> And also, what script will run on each probe, right? :)
> 
> In the perf-probe world, the closest analogue could be varying the
> contextual data that's being extracted (stack traces, parameters, ...).

Yes, it should be verified before accessing it (and already done).

>>>> [...]  For the long term solution, I think we can introduce some
>>>> kind of performance gatekeeper as systemtap does. Counting the
>>>> miss-hit rate per second and if it go over a threshold, disable next
>>>> miss-hit (or most miss-hit) probe (as OOM killer does).
>>>
>>> That would make sense, but again it would not help deal with kprobes
>>> robustness (in the kernel-crashing rather than kernel-slowdown sense).
>>
>> Why would you think so? Is there any hidden path for calling kprobes
>> mechanism?? The kernel crash problem just comes from bugs, not the
>> quantitative issue.
> 
> I don't think we're disagreeing.  A performance-gatekeeper in
> perf-probe or nearby would be useful (and manage the kprobe-quantity
> problem).  It would not be sufficient to prevent the kernel-crashing
> bugs.

Right. Ah, I just meant that we'd better add those features, not
replacing the blacklist. And the blacklist should be maintained
anyway. :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


