Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3LCKei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 05:34:38 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42881 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab3LCKeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 05:34:31 -0500
Message-ID: <529DB3AD.4070305@hitachi.com>
Date: Tue, 03 Dec 2013 19:34:21 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
In-Reply-To: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/03 13:28), Alexei Starovoitov wrote:
> Hi All,
> 
> the following set of patches adds BPF support to trace filters.
> 
> Trace filters can be written in C and allow safe read-only access to any
> kernel data structure. Like systemtap but with safety guaranteed by kernel.
> 
> The user can do:
> cat bpf_program > /sys/kernel/debug/tracing/.../filter
> if tracing event is either static or dynamic via kprobe_events.

Oh, thank you for this great work! :D

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
> The kernel will do static analysis of bpf program to make sure that it cannot
> crash the kernel (doesn't have loops, valid memory/register accesses, etc).
> Then kernel will map bpf instructions to x86 instructions and let it
> run in the place of trace filter.
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
> 
> echo 0 > enable
> [  258.073593] 1M skb alloc/free 144919 (usecs)
> (tracing is disabled, performance is back to original)
> 
> The C program compiled into BPF and then JITed into x86 is faster than
> filter_match_preds() approach (199-145 msec vs 302-145 msec)

Great! :)

> tracing+bpf is a tool for safe read-only access to variables without recompiling
> the kernel and without affecting running programs.

Hmm, this feature and trace-event trigger actions can give us
powerful on-the-fly scripting functionality...

> BPF filters can be written manually (see tools/bpf/trace/filter_ex1.c)
> or better compiled from restricted C via GCC or LLVM
> 
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

Looks very interesting. :)

Thank you!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


