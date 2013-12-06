Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162258Ab3LFX6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:58:50 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:59559 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198Ab3LFX6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:58:48 -0500
Message-ID: <52A264B1.1030605@hitachi.com>
Date: Sat, 07 Dec 2013 08:58:41 +0900
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
Subject: Re: Re: [RFC PATCH tip 0/5] tracing filters with BPF
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com> <87fvq9cwlk.fsf@tassilo.jf.intel.com> <CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com> <CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com> <CAGdX0WEnZhtAJ_gKCFQK3p1wwd5x17zvViU6FRfAGieSKQfZEQ@mail.gmail.com>
In-Reply-To: <CAGdX0WEnZhtAJ_gKCFQK3p1wwd5x17zvViU6FRfAGieSKQfZEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/06 14:19), Jovi Zhangwei wrote:
> Hi Alexei,
> 
> On Thu, Dec 5, 2013 at 12:40 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>>> On Tue, Dec 3, 2013 at 4:01 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>>>
>>>> Can you do some performance comparison compared to e.g. ktap?
>>>> How much faster is it?
>>
>> Did simple ktap test with 1M alloc_skb/kfree_skb toy test from earlier email:
>> trace skb:kfree_skb {
>>         if (arg2 == 0x100) {
>>                 printf("%x %x\n", arg1, arg2)
>>         }
>> }
>> 1M skb alloc/free 350315 (usecs)
>>
>> baseline without any tracing:
>> 1M skb alloc/free 145400 (usecs)
>>
>> then equivalent bpf test:
>> void filter(struct bpf_context *ctx)
>> {
>>         void *loc = (void *)ctx->regs.dx;
>>         if (loc == 0x100) {
>>                 struct sk_buff *skb = (struct sk_buff *)ctx->regs.si;
>>                 char fmt[] = "skb %p loc %p\n";
>>                 bpf_trace_printk(fmt, sizeof(fmt), (long)skb, (long)loc, 0);
>>         }
>> }
>> 1M skb alloc/free 183214 (usecs)
>>
>> so with one 'if' condition the difference ktap vs bpf is 350-145 vs 183-145
>>
>> obviously ktap is an interpreter, so it's not really fair.
>>
>> To make it really unfair I did:
>> trace skb:kfree_skb {
>>         if (arg2 == 0x100 || arg2 == 0x200 || arg2 == 0x300 || arg2 == 0x400 ||
>>             arg2 == 0x500 || arg2 == 0x600 || arg2 == 0x700 || arg2 == 0x800 ||
>>             arg2 == 0x900 || arg2 == 0x1000) {
>>                 printf("%x %x\n", arg1, arg2)
>>         }
>> }
>> 1M skb alloc/free 484280 (usecs)
>>
>> and corresponding bpf:
>> void filter(struct bpf_context *ctx)
>> {
>>         void *loc = (void *)ctx->regs.dx;
>>         if (loc == 0x100 || loc == 0x200 || loc == 0x300 || loc == 0x400 ||
>>             loc == 0x500 || loc == 0x600 || loc == 0x700 || loc == 0x800 ||
>>             loc == 0x900 || loc == 0x1000) {
>>                 struct sk_buff *skb = (struct sk_buff *)ctx->regs.si;
>>                 char fmt[] = "skb %p loc %p\n";
>>                 bpf_trace_printk(fmt, sizeof(fmt), (long)skb, (long)loc, 0);
>>         }
>> }
>> 1M skb alloc/free 185660 (usecs)
>>
>> the difference is bigger now: 484-145 vs 185-145
>>
> There have big differences for compare arg2(in ktap) with direct register
> access(ctx->regs.dx).
> 
> The current argument fetching(arg2 in above testcase) implementation in ktap
> is very inefficient, see ktap/interpreter/lib_kdebug.c:kp_event_getarg.
> The only way to speedup is kernel tracing code change, let external tracing
> module access event field not through list lookup. This work is not
> started yet. :)

I'm not sure why you can't access it directly from ftrace-event buffer.
There is just a packed data structure and it is exposed via debugfs.
You can decode it and can get an offset/size by using libtraceevent.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


