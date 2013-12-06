Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203Ab3LFFT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 00:19:56 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:50665 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3LFFTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 00:19:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<87fvq9cwlk.fsf@tassilo.jf.intel.com>
	<CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com>
	<CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
Date: Fri, 6 Dec 2013 13:19:52 +0800
Message-ID: <CAGdX0WEnZhtAJ_gKCFQK3p1wwd5x17zvViU6FRfAGieSKQfZEQ@mail.gmail.com>
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexei,

On Thu, Dec 5, 2013 at 12:40 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>> On Tue, Dec 3, 2013 at 4:01 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>>
>>> Can you do some performance comparison compared to e.g. ktap?
>>> How much faster is it?
>
> Did simple ktap test with 1M alloc_skb/kfree_skb toy test from earlier email:
> trace skb:kfree_skb {
>         if (arg2 == 0x100) {
>                 printf("%x %x\n", arg1, arg2)
>         }
> }
> 1M skb alloc/free 350315 (usecs)
>
> baseline without any tracing:
> 1M skb alloc/free 145400 (usecs)
>
> then equivalent bpf test:
> void filter(struct bpf_context *ctx)
> {
>         void *loc = (void *)ctx->regs.dx;
>         if (loc == 0x100) {
>                 struct sk_buff *skb = (struct sk_buff *)ctx->regs.si;
>                 char fmt[] = "skb %p loc %p\n";
>                 bpf_trace_printk(fmt, sizeof(fmt), (long)skb, (long)loc, 0);
>         }
> }
> 1M skb alloc/free 183214 (usecs)
>
> so with one 'if' condition the difference ktap vs bpf is 350-145 vs 183-145
>
> obviously ktap is an interpreter, so it's not really fair.
>
> To make it really unfair I did:
> trace skb:kfree_skb {
>         if (arg2 == 0x100 || arg2 == 0x200 || arg2 == 0x300 || arg2 == 0x400 ||
>             arg2 == 0x500 || arg2 == 0x600 || arg2 == 0x700 || arg2 == 0x800 ||
>             arg2 == 0x900 || arg2 == 0x1000) {
>                 printf("%x %x\n", arg1, arg2)
>         }
> }
> 1M skb alloc/free 484280 (usecs)
>
> and corresponding bpf:
> void filter(struct bpf_context *ctx)
> {
>         void *loc = (void *)ctx->regs.dx;
>         if (loc == 0x100 || loc == 0x200 || loc == 0x300 || loc == 0x400 ||
>             loc == 0x500 || loc == 0x600 || loc == 0x700 || loc == 0x800 ||
>             loc == 0x900 || loc == 0x1000) {
>                 struct sk_buff *skb = (struct sk_buff *)ctx->regs.si;
>                 char fmt[] = "skb %p loc %p\n";
>                 bpf_trace_printk(fmt, sizeof(fmt), (long)skb, (long)loc, 0);
>         }
> }
> 1M skb alloc/free 185660 (usecs)
>
> the difference is bigger now: 484-145 vs 185-145
>
There have big differences for compare arg2(in ktap) with direct register
access(ctx->regs.dx).

The current argument fetching(arg2 in above testcase) implementation in ktap
is very inefficient, see ktap/interpreter/lib_kdebug.c:kp_event_getarg.
The only way to speedup is kernel tracing code change, let external tracing
module access event field not through list lookup. This work is not
started yet. :)

Of course, I'm not saying this argument fetching issue is the performance
root cause compared with bpf and Systemtap, the bytecode executing speed
wouldn't compare with raw machine code.
(There have a plan to use JIT in ktap core, like luajit project, but
it need some
time to work on)
