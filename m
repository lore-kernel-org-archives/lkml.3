Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab3LCJRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:17:08 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:57543 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab3LCJRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:17:00 -0500
Date: Tue, 3 Dec 2013 10:16:55 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>, Pekka Enberg <penberg@iki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Arjan van de Ven <arjan@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
Message-ID: <20131203091655.GB20179@gmail.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexei Starovoitov <ast@plumgrid.com> wrote:

> Hi All,
> 
> the following set of patches adds BPF support to trace filters.
> 
> Trace filters can be written in C and allow safe read-only access to 
> any kernel data structure. Like systemtap but with safety guaranteed 
> by kernel.

Very cool! (Added various other folks who might be interested in this 
to the Cc: list.)

I have one generic concern:

It would be important to make it easy to extract loaded BPF code from 
the kernel in source code equivalent form, which compiles to the same 
BPF code.

I.e. I think it would be fundamentally important to make sure that 
this is all within the kernel's license domain, to make it very clear 
there can be no 'binary only' BPF scripts.

By up-loading BPF into a kernel the person loading it agrees to make 
that code available to all users of that system who can access it, 
under the same license as the kernel's code (or under a more 
permissive license).

The last thing we want is people getting funny ideas and writing 
drivers in BPF and hiding the code or making license claims over it 
...

I.e. we want to allow flexible plugins technologically, but make sure 
people who run into such a plugin can modify and improve it under the 
same license as they can modify and improve the kernel itself!

[ People can still 'hide' their sekrit plugins if they want to, by not
  distributing them to anyone who'd redistribute it widely. ]

> The user can do:
> cat bpf_program > /sys/kernel/debug/tracing/.../filter
> if tracing event is either static or dynamic via kprobe_events.
> 
> The filter program may look like:
> void filter(struct bpf_context *ctx)
> {
>         char devname[4] = "eth5";
>         struct net_device *dev;
>         struct sk_buff *skb = 0;
> 
>         dev = (struct net_device *)ctx->regs.si;
>         if (bpf_memcmp(dev->name, devname, 4) == 0) {
>                 char fmt[] = "skb %p dev %p eth5\n";
>                 bpf_trace_printk(fmt, skb, dev, 0, 0);
>         }
> }
> 
> The kernel will do static analysis of bpf program to make sure that 
> it cannot crash the kernel (doesn't have loops, valid 
> memory/register accesses, etc). Then kernel will map bpf 
> instructions to x86 instructions and let it run in the place of 
> trace filter.
> 
> To demonstrate performance I did a synthetic test:
>         dev = init_net.loopback_dev;
>         do_gettimeofday(&start_tv);
>         for (i = 0; i < 1000000; i++) {
>                 struct sk_buff *skb;
>                 skb = netdev_alloc_skb(dev, 128);
>                 kfree_skb(skb);
>         }
>         do_gettimeofday(&end_tv);
>         time = end_tv.tv_sec - start_tv.tv_sec;
>         time *= USEC_PER_SEC;
>         time += (long long)((long)end_tv.tv_usec - (long)start_tv.tv_usec);
> 
>         printk("1M skb alloc/free %lld (usecs)\n", time);
> 
> no tracing
> [   33.450966] 1M skb alloc/free 145179 (usecs)
> 
> echo 1 > enable
> [   97.186379] 1M skb alloc/free 240419 (usecs)
> (tracing slows down kfree_skb() due to event_buffer_lock/buffer_unlock_commit)
> 
> echo 'name==eth5' > filter
> [  139.644161] 1M skb alloc/free 302552 (usecs)
> (running filter_match_preds() for every skb and discarding
> event_buffer is even slower)
> 
> cat bpf_prog > filter
> [  171.150566] 1M skb alloc/free 199463 (usecs)
> (JITed bpf program is safely checking dev->name == eth5 and discarding)

So, to do the math:

   tracing               'all' overhead:   95 nsecs per event
   tracing 'eth5 + old filter' overhead:  157 nsecs per event
   tracing 'eth5 + BPF filter' overhead:   54 nsecs per event

So via BPF and a fairly trivial filter, we are able to reduce tracing 
overhead for real - while old-style filters.

In addition to that we now also have arbitrary BPF scripts, full C 
programs (or written in any other language from which BPF bytecode can 
be generated) enabled.

Seems like a massive win-win scenario to me ;-)

> echo 0 > enable
> [  258.073593] 1M skb alloc/free 144919 (usecs)
> (tracing is disabled, performance is back to original)
> 
> The C program compiled into BPF and then JITed into x86 is faster 
> than filter_match_preds() approach (199-145 msec vs 302-145 msec)
> 
> tracing+bpf is a tool for safe read-only access to variables without 
> recompiling the kernel and without affecting running programs.
> 
> BPF filters can be written manually (see 
> tools/bpf/trace/filter_ex1.c) or better compiled from restricted C 
> via GCC or LLVM

> Q: What is the difference between existing BPF and extended BPF?
> A:
> Existing BPF insn from uapi/linux/filter.h
> struct sock_filter {
>         __u16   code;   /* Actual filter code */
>         __u8    jt;     /* Jump true */
>         __u8    jf;     /* Jump false */
>         __u32   k;      /* Generic multiuse field */
> };
> 
> Extended BPF insn from linux/bpf.h
> struct bpf_insn {
>         __u8    code;    /* opcode */
>         __u8    a_reg:4; /* dest register*/
>         __u8    x_reg:4; /* source register */
>         __s16   off;     /* signed offset */
>         __s32   imm;     /* signed immediate constant */
> };
> 
> opcode encoding is the same between old BPF and extended BPF.
> Original BPF has two 32-bit registers.
> Extended BPF has ten 64-bit registers.
> That is the main difference.
> 
> Old BPF was using jt/jf fields for jump-insn only.
> New BPF combines them into generic 'off' field for jump and non-jump insns.
> k==imm field has the same meaning.

This only affects the internal JIT representation, not the BPF byte 
code, right?

>  32 files changed, 3332 insertions(+), 24 deletions(-)

Impressive!

I'm wondering, will the new nftable code in works make use of the BPF 
JIT as well, or is that a separate implementation?

Thanks,

	Ingo
