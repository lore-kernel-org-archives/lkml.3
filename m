Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab3LDBNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:13:51 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:59730 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab3LDBNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:13:45 -0500
Message-ID: <529E81C1.2070208@hitachi.com>
Date: Wed, 04 Dec 2013 10:13:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlz?= =?UTF-8?B?YmVja2Vy?= 
	<fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>, Pekka Enberg <penberg@iki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Arjan van de Ven <arjan@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        namhyung@kernel.org
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com> <20131203091655.GB20179@gmail.com> <20131203103346.65c744e3@gandalf.local.home> <CAMEtUuw_6dCuZd=1fQxNYrZid67n7MRYBT16qBkgR_JxOPkfdg@mail.gmail.com>
In-Reply-To: <CAMEtUuw_6dCuZd=1fQxNYrZid67n7MRYBT16qBkgR_JxOPkfdg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/04 3:26), Alexei Starovoitov wrote:
> On Tue, Dec 3, 2013 at 7:33 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Tue, 3 Dec 2013 10:16:55 +0100
>> Ingo Molnar <mingo@kernel.org> wrote:
>>
>>
>>> So, to do the math:
>>>
>>>    tracing               'all' overhead:   95 nsecs per event
>>>    tracing 'eth5 + old filter' overhead:  157 nsecs per event
>>>    tracing 'eth5 + BPF filter' overhead:   54 nsecs per event
>>>
>>> So via BPF and a fairly trivial filter, we are able to reduce tracing
>>> overhead for real - while old-style filters.
>>
>> Yep, seems that BPF can do what I wasn't able to do with the normal
>> filters. Although, I haven't looked at the code yet, I'm assuming that
>> the BPF works on the parameters passed into the trace event. The normal
>> filters can only process the results of the trace (what's being
>> recorded) not the parameters of the trace event itself. To get what's
>> recorded, we need to write to the buffer first, and then we decided if
>> we want to keep the event or not and discard the event from the buffer
>> if we do not.
>>
>> That method does not reduce overhead at all, and only adds to it, as
>> Alexei's tests have shown. The purpose of the filter was not to reduce
>> overhead, but to reduce filling the buffer with needless data.
> 
> Precisely.
> Assumption is that filters will filter out majority of the events.
> So filter takes pt_regs as input, has to interpret them and call
> bpf_trace_printk
> if it really wants to store something for the human to see.
> We can extend bpf trace filters to return true/false to indicate
> whether TP_printk-format
> specified as part of the event should be printed as well, but imo
> that's unnecessary.
> When I was using bpf filters to debug networking bits I didn't need
> that printk format of the event. I only used event as an entry point,
> filtering out things and printing different fields vs initial event.
> More like what developers do when they sprinkle
> trace_printk/dump_stack through the code while debugging.
> 
> the only inconvenience so far is to know how parameters are getting
> into registers.
> on x86-64, arg1 is in rdi, arg2 is in rsi,... I want to improve that
> after first step is done.

Actually, that part is done by the perf-probe and ftrace dynamic events
(kernel/trace/trace_probe.c). I think this generic BPF is good for
re-implementing fetch methods. :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


