Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3LKDf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:35:59 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42698 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab3LKDf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 22:35:56 -0500
Message-ID: <52A7DD94.2050204@hitachi.com>
Date: Wed, 11 Dec 2013 12:35:48 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com> <87fvq9cwlk.fsf@tassilo.jf.intel.com> <CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com> <CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com> <20131205104113.GB20283@gmail.com> <20131205084657.09b6a2ce@gandalf.local.home> <CAMEtUuyp0q9YSMq7OchEeWLz9oPYd3qQ+0SDV5Pt8F10KLbFpg@mail.gmail.com> <20131205183735.5f9c8bae@gandalf.local.home> <CAMEtUuzkGNbh_ZOd5SbWEdNMz3NEpDZzzAKP=Ov10DKD5hVaKQ@mail.gmail.com> <20131210154748.GA1950@gmail.com> <CAMEtUuzaCMa6gSgoKvuzXPwo5d+2oFg9URiakKECh2nYSD8o9g@mail.gmail.com>
In-Reply-To: <CAMEtUuzaCMa6gSgoKvuzXPwo5d+2oFg9URiakKECh2nYSD8o9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/11 11:32), Alexei Starovoitov wrote:
> On Tue, Dec 10, 2013 at 7:47 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> * Alexei Starovoitov <ast@plumgrid.com> wrote:
>>
>>>> I'm fine if it becomes a requirement to have a vmlinux built with
>>>> DEBUG_INFO to use BPF and have a tool like perf to translate the
>>>> filters. But it that must not replace what the current filters do
>>>> now. That is, it can be an add on, but not a replacement.
>>>
>>> Of course. tracing filters via bpf is an additional tool for kernel
>>> debugging. bpf by itself has use cases beyond tracing.
>>
>> Well, Steve has a point: forcing DEBUG_INFO is a big showstopper for
>> most people.
> 
> there is a misunderstanding here.
> I was saying 'of course' to 'not replace current filter infra'.
> 
> bpf does not depend on debug info.
> That's the key difference between 'perf probe' approach and bpf filters.
> 
> Masami is right that what I was trying to achieve with bpf filters
> is similar to 'perf probe': insert a dynamic probe anywhere
> in the kernel, walk pointers, data structures, print interesting stuff.
> 
> 'perf probe' does it via scanning vmlinux with debug info.
> bpf filters don't need it.
> tools/bpf/trace/*_orig.c examples only depend on linux headers
> in /lib/modules/../build/include/
> Today bpf compiler struct layout is the same as x86_64.
> 
> Tomorrow bpf compiler will have flags to adjust endianness, pointer size, etc
> of the front-end. Similar to -m32/-m64 and -m*-endian flags.
> Neat part is that I don't need to do any work, just enable it properly in
> the bpf backend. From gcc/llvm point of view, bpf is yet another 'hw'
> architecture that compiler is emitting code for.
> So when C code of filter_ex1_orig.c does 'skb->dev', compiler determines
> field offset by looking at /lib/modules/.../include/skbuff.h
> whereas for 'perf probe' 'skb->dev' means walk debug info.

Right, the offset of the data structure can get from the header etc.

However, how would the bpf get the register or stack assignment of
skb itself? In the tracepoint macro, it will be able to get it from
function parameters (it needs a trick, like jprobe does).
I doubt you can do that on kprobes/uprobes without any debuginfo
support. :(

And is it possible to trace a field in a data structure which is
defined locally in somewhere.c ? :) (maybe it's just a corner case)

> Something like: cc1 -mlayout_x86_64 filter.c will produce bpf code that
> walks all data structures in the same way x86_64 does it.
> Even if the user makes a mistake and uses -mlayout_aarch64, it won't crash.
> Note that all -m* flags will be in one compiler. It won't grow any bigger
> because of that. All of it already supported by C front-ends.
> It may sound complex, but really very little code for the bpf backend.
> 
> I didn't look inside systemtap/ktap enough to say how much they're
> relying on presence of debug info to make a comparison.
> 
> I see two main use cases for bpf tracing filters: debugging live kernel
> and collecting stats. Same tricks that [sk]tap do with their maps.
> Or may be some of the stats that 'perf record' collects in userspace
> can be collected by bpf filter in kernel and stored into generic bpf table?
> 
>> Would it be possible to make BFP filters recognize exposed details
>> like the current filters do, without depending on the vmlinux?
> 
> Well, if you say that presence of linux headers is also too much to ask,
> I can hook bpf after probes stored all the args.
> 
> This way current simple filter syntax can move to userspace.
> 'arg1==x || arg2!=y' can be parsed by userspace, bpf code
> generated and fed into kernel. It will be faster than walk_pred_tree(),
> but if we cannot remove 2k lines from trace_events_filter.c
> because of backward compatibility, extra performance becomes
> the only reason to have two different implementations.
> 
> Another use case is to optimize fetch sequences of dynamic probes
> as Masami suggested, but backward compatibility requirement
> would preserve to ways of doing it as well.

The backward compatibility issue is only for the interface, but not
for the implementation, I think. :) The fetch method and filter
pred do already parse the argument into a syntax tree. IMHO, bpf
can optimize that tree to just a simple opcode stream.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


