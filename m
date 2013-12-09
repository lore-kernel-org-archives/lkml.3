Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab3LIE7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 23:59:36 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47079 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760322Ab3LIE7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 23:59:34 -0500
Message-ID: <52A54E2E.9010608@hitachi.com>
Date: Mon, 09 Dec 2013 13:59:26 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Alexei Starovoitov <ast@plumgrid.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Re: Re: [RFC PATCH tip 0/5] tracing filters with BPF
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com> <87fvq9cwlk.fsf@tassilo.jf.intel.com> <CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com> <CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com> <CAGdX0WEnZhtAJ_gKCFQK3p1wwd5x17zvViU6FRfAGieSKQfZEQ@mail.gmail.com> <52A264B1.1030605@hitachi.com> <CAGdX0WEVxGDNi-YMVeAtEV9bZpMbnnSBXxrUrn_oh0sWRouSaQ@mail.gmail.com>
In-Reply-To: <CAGdX0WEVxGDNi-YMVeAtEV9bZpMbnnSBXxrUrn_oh0sWRouSaQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/08 1:21), Jovi Zhangwei wrote:
> On Sat, Dec 7, 2013 at 7:58 AM, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
>> (2013/12/06 14:19), Jovi Zhangwei wrote:
>>> Hi Alexei,
>>>
>>> On Thu, Dec 5, 2013 at 12:40 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>>>>> On Tue, Dec 3, 2013 at 4:01 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>>>>>
>>>>>> Can you do some performance comparison compared to e.g. ktap?
>>>>>> How much faster is it?
>>>>
>>>> Did simple ktap test with 1M alloc_skb/kfree_skb toy test from earlier email:
>>>> trace skb:kfree_skb {
>>>>         if (arg2 == 0x100) {
>>>>                 printf("%x %x\n", arg1, arg2)
>>>>         }
>>>> }
>>>> 1M skb alloc/free 350315 (usecs)
>>>>
>>>> baseline without any tracing:
>>>> 1M skb alloc/free 145400 (usecs)
>>>>
>>>> then equivalent bpf test:
>>>> void filter(struct bpf_context *ctx)
>>>> {
>>>>         void *loc = (void *)ctx->regs.dx;
>>>>         if (loc == 0x100) {
>>>>                 struct sk_buff *skb = (struct sk_buff *)ctx->regs.si;
>>>>                 char fmt[] = "skb %p loc %p\n";
>>>>                 bpf_trace_printk(fmt, sizeof(fmt), (long)skb, (long)loc, 0);
>>>>         }
>>>> }
>>>> 1M skb alloc/free 183214 (usecs)
>>>>
>>>> so with one 'if' condition the difference ktap vs bpf is 350-145 vs 183-145
>>>>
>>>> obviously ktap is an interpreter, so it's not really fair.
>>>>
>>>> To make it really unfair I did:
>>>> trace skb:kfree_skb {
>>>>         if (arg2 == 0x100 || arg2 == 0x200 || arg2 == 0x300 || arg2 == 0x400 ||
>>>>             arg2 == 0x500 || arg2 == 0x600 || arg2 == 0x700 || arg2 == 0x800 ||
>>>>             arg2 == 0x900 || arg2 == 0x1000) {
>>>>                 printf("%x %x\n", arg1, arg2)
>>>>         }
>>>> }
>>>> 1M skb alloc/free 484280 (usecs)
>>>>
>>>> and corresponding bpf:
>>>> void filter(struct bpf_context *ctx)
>>>> {
>>>>         void *loc = (void *)ctx->regs.dx;
>>>>         if (loc == 0x100 || loc == 0x200 || loc == 0x300 || loc == 0x400 ||
>>>>             loc == 0x500 || loc == 0x600 || loc == 0x700 || loc == 0x800 ||
>>>>             loc == 0x900 || loc == 0x1000) {
>>>>                 struct sk_buff *skb = (struct sk_buff *)ctx->regs.si;
>>>>                 char fmt[] = "skb %p loc %p\n";
>>>>                 bpf_trace_printk(fmt, sizeof(fmt), (long)skb, (long)loc, 0);
>>>>         }
>>>> }
>>>> 1M skb alloc/free 185660 (usecs)
>>>>
>>>> the difference is bigger now: 484-145 vs 185-145
>>>>
>>> There have big differences for compare arg2(in ktap) with direct register
>>> access(ctx->regs.dx).
>>>
>>> The current argument fetching(arg2 in above testcase) implementation in ktap
>>> is very inefficient, see ktap/interpreter/lib_kdebug.c:kp_event_getarg.
>>> The only way to speedup is kernel tracing code change, let external tracing
>>> module access event field not through list lookup. This work is not
>>> started yet. :)
>>
>> I'm not sure why you can't access it directly from ftrace-event buffer.
>> There is just a packed data structure and it is exposed via debugfs.
>> You can decode it and can get an offset/size by using libtraceevent.
>>
> Then it means there need pass the event field info into kernel through trunk,
> it looks strange because the kernel structure is the source of event field info,
> it's like loop-back, and need to engage with libtraceevent in userspace.

No, the static traceevents have its own kernel data structure, but
the dynamic events don't. They expose the data format (offset/type)
via debugfs, but do not define new data structure.
So, I meant the script is enough to take an offset and a method casting
to corresponding size.

> (the side effect is it will make compilation slow, and consume more memory,
> sometimes it will process 20K events in one script, like 'trace
> probe:big_dso:*')

I doubt it, since you just need to get formats only for the events what
the script using.

> So "the only way" which I said is wrong, your approach indeed is another way.
> I just think maybe use array instead of list for event fields would be more
> efficient if list is not must needed. we can check it more in future.

Ah, perhaps, I misunderstood ktap implementation. Does it define dynamic
events right before loading a bytecode? In that case, I recommend you to
change a loader to adjust the bytecode after defining event to tune the
offset information, which fits to the target event format.

e.g.
 1) compile a bytecode with dummy offsets
 2) define new additional dynamic events
 3) get the field offset information from the events
 4) modify the bytecode to replace offsets with correct one on memory
 5) load the bytecode

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


