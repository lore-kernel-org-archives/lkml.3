Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab3LLCsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 21:48:46 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:54180 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3LLCso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 21:48:44 -0500
MIME-Version: 1.0
In-Reply-To: <52A7DD94.2050204@hitachi.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<87fvq9cwlk.fsf@tassilo.jf.intel.com>
	<CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com>
	<CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
	<20131205104113.GB20283@gmail.com>
	<20131205084657.09b6a2ce@gandalf.local.home>
	<CAMEtUuyp0q9YSMq7OchEeWLz9oPYd3qQ+0SDV5Pt8F10KLbFpg@mail.gmail.com>
	<20131205183735.5f9c8bae@gandalf.local.home>
	<CAMEtUuzkGNbh_ZOd5SbWEdNMz3NEpDZzzAKP=Ov10DKD5hVaKQ@mail.gmail.com>
	<20131210154748.GA1950@gmail.com>
	<CAMEtUuzaCMa6gSgoKvuzXPwo5d+2oFg9URiakKECh2nYSD8o9g@mail.gmail.com>
	<52A7DD94.2050204@hitachi.com>
Date: Wed, 11 Dec 2013 18:48:42 -0800
Message-ID: <CAMEtUux+-AZp0tWK6ce5qLNAQ3fJ0bvZWHmn_FLNZ8EusDyOqA@mail.gmail.com>
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
From: Alexei Starovoitov <ast@plumgrid.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 7:35 PM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> (2013/12/11 11:32), Alexei Starovoitov wrote:
>> On Tue, Dec 10, 2013 at 7:47 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>>
>>> * Alexei Starovoitov <ast@plumgrid.com> wrote:
>>>
>>>>> I'm fine if it becomes a requirement to have a vmlinux built with
>>>>> DEBUG_INFO to use BPF and have a tool like perf to translate the
>>>>> filters. But it that must not replace what the current filters do
>>>>> now. That is, it can be an add on, but not a replacement.
>>>>
>>>> Of course. tracing filters via bpf is an additional tool for kernel
>>>> debugging. bpf by itself has use cases beyond tracing.
>>>
>>> Well, Steve has a point: forcing DEBUG_INFO is a big showstopper for
>>> most people.
>>
>> there is a misunderstanding here.
>> I was saying 'of course' to 'not replace current filter infra'.
>>
>> bpf does not depend on debug info.
>> That's the key difference between 'perf probe' approach and bpf filters.
>>
>> Masami is right that what I was trying to achieve with bpf filters
>> is similar to 'perf probe': insert a dynamic probe anywhere
>> in the kernel, walk pointers, data structures, print interesting stuff.
>>
>> 'perf probe' does it via scanning vmlinux with debug info.
>> bpf filters don't need it.
>> tools/bpf/trace/*_orig.c examples only depend on linux headers
>> in /lib/modules/../build/include/
>> Today bpf compiler struct layout is the same as x86_64.
>>
>> Tomorrow bpf compiler will have flags to adjust endianness, pointer size, etc
>> of the front-end. Similar to -m32/-m64 and -m*-endian flags.
>> Neat part is that I don't need to do any work, just enable it properly in
>> the bpf backend. From gcc/llvm point of view, bpf is yet another 'hw'
>> architecture that compiler is emitting code for.
>> So when C code of filter_ex1_orig.c does 'skb->dev', compiler determines
>> field offset by looking at /lib/modules/.../include/skbuff.h
>> whereas for 'perf probe' 'skb->dev' means walk debug info.
>
> Right, the offset of the data structure can get from the header etc.
>
> However, how would the bpf get the register or stack assignment of
> skb itself? In the tracepoint macro, it will be able to get it from
> function parameters (it needs a trick, like jprobe does).
> I doubt you can do that on kprobes/uprobes without any debuginfo
> support. :(

the 4/5 diff actually shows how it's working ;)
for kprobes it works at the function entry, since arguments are still
in the registers
and walks the pointers further down.
It cannot do func+line_number as perf-probe does, of course.
for tracepoints it's the same trick: call no-inline func with traceprobe args
and call inlined crash_setup_regs() that stores the regs.

Of course, there are limitations. Like 7th func argument goes into
stack and requires
more work to get out. If struct is not defined in .h, it would need to
be redefined in filter.c
Corner cases as you said.
Today user of bpf filter needs to know that arg1 goes into %rdi and so on.
that is easy to cleanup.

>> Another use case is to optimize fetch sequences of dynamic probes
>> as Masami suggested, but backward compatibility requirement
>> would preserve to ways of doing it as well.
>
> The backward compatibility issue is only for the interface, but not
> for the implementation, I think. :) The fetch method and filter
> pred do already parse the argument into a syntax tree. IMHO, bpf
> can optimize that tree to just a simple opcode stream.

ahh. yes. that's doable.

Thanks
Alexei
