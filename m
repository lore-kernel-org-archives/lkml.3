Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162704Ab3LFXtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:49:07 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:59339 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161368Ab3LFXtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:49:04 -0500
Message-ID: <52A26268.5070403@hitachi.com>
Date: Sat, 07 Dec 2013 08:48:56 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Alexei Starovoitov <ast@plumgrid.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC PATCH tip 4/5] use BPF in tracing filters
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com> <1386044930-15149-5-git-send-email-ast@plumgrid.com> <529E7BEC.70509@hitachi.com> <20131203201133.52934a02@gandalf.local.home> <529FC352.7090004@hitachi.com> <CAMEtUuwMv6PtN=9_RmxouZpVB8PVN8oZDNDUyLva2J+xos48og@mail.gmail.com> <52A18E31.6030605@hitachi.com> <CAGdX0WGK13RVo6dgNbMKm81gy4GLZUBFEhmYfHj6tjz33FpmnQ@mail.gmail.com>
In-Reply-To: <CAGdX0WGK13RVo6dgNbMKm81gy4GLZUBFEhmYfHj6tjz33FpmnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/06 19:05), Jovi Zhangwei wrote:
> On Fri, Dec 6, 2013 at 4:43 PM, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
>> (2013/12/05 14:11), Alexei Starovoitov wrote:
>>> On Wed, Dec 4, 2013 at 4:05 PM, Masami Hiramatsu
>>> <masami.hiramatsu.pt@hitachi.com> wrote:
>>>> (2013/12/04 10:11), Steven Rostedt wrote:
>>>>> On Wed, 04 Dec 2013 09:48:44 +0900
>>>>> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>>>
>>>>>> fetch functions and actions. In that case, we can continue
>>>>>> to use current interface but much faster to trace.
>>>>>> Also, we can see what filter/arguments/actions are set
>>>>>> on each event.
>>>>>
>>>>> There's also the problem that the current filters work with the results
>>>>> of what is written to the buffer, not what is passed in by the trace
>>>>> point, as that isn't even displayed to the user.
>>>>
>>>> Agreed, so I've said I doubt this implementation is a good
>>>> shape to integrate. Ktap style is better, since it just gets
>>>> parameters from perf buffer entry (using event format).
>>>
>>> Are you saying always store all arguments into ring buffer and let
>>> filter run on it?
>>
>> Yes, it is what ftrace does. I doubt your way fits all of the existing
>> trace-event macros. However, I think just for dynamic events, you can
>> integrating the argument fetching and filtering.
>>
> Does this will affect the user interface of perf-probe argument fetching?
> 
> I mean if use bpf backend, do we must need gcc to compile bpf source
> for perf-probe argument fetching? as we known, current argument
> fetching is go through kprobe_events/uprobe_events debugfs file, and
> ktap is based on this behavior.

No, I don't want to do that. Feeding binary code into the kernel is
not trusted nor controllable. I'd just like to see the code which
optimizing current fetching/filtering methods, and that is possible.

Anyway, as far as I can see, there looks be two different models of
tracing in our mind.

A) Fixed event based tracing: In this model, there are several fixed
"events" which well defined with fixed arguments. tracer handles these
events and only use limited arguments. It's like a packet stream
processing. ftrace, perf etc. are used this model.

B) Flexible event-point tracing: In this model, each tracer(or even
trace user) can freely define their own event, there will be some fixed
tracing points defined, but arguments are defined by users. It's like a
debugger's breakpoint debugging. systemtap, ktap etc. are used this model.

Of course, both have pros/cons, and can share some fundamental features.
e.g. B model has a good flexibility and A model is easy to use for beginners.

I think we'd better not integrate these two, but find the better way
to share each functionality.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


