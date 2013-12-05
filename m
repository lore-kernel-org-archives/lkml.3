Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3LEKlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:41:18 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:33585 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab3LEKlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:41:17 -0500
Date: Thu, 5 Dec 2013 11:41:13 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
Message-ID: <20131205104113.GB20283@gmail.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
 <87fvq9cwlk.fsf@tassilo.jf.intel.com>
 <CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com>
 <CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexei Starovoitov <ast@plumgrid.com> wrote:

> > On Tue, Dec 3, 2013 at 4:01 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >>
> >> Can you do some performance comparison compared to e.g. ktap?
> >> How much faster is it?
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

Real life scripts, for examples the ones related to network protocol 
analysis will often have such patterns in them, so I don't think this 
measurement is particularly unfair.

Thanks,

	Ingo
