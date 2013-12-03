Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3LCSGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:06:42 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:38843 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3LCSGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:06:41 -0500
MIME-Version: 1.0
In-Reply-To: <20131203091655.GB20179@gmail.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<20131203091655.GB20179@gmail.com>
Date: Tue, 3 Dec 2013 10:06:39 -0800
Message-ID: <CAMEtUuziP0zVe63HSxF0uVs1pnP--1HBs1-WsR2xfLOTyBaHSQ@mail.gmail.com>
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
From: Alexei Starovoitov <ast@plumgrid.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>, Pekka Enberg <penberg@iki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Arjan van de Ven <arjan@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 1:16 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Very cool! (Added various other folks who might be interested in this
> to the Cc: list.)
>
> I have one generic concern:
>
> It would be important to make it easy to extract loaded BPF code from
> the kernel in source code equivalent form, which compiles to the same
> BPF code.
>
> I.e. I think it would be fundamentally important to make sure that
> this is all within the kernel's license domain, to make it very clear
> there can be no 'binary only' BPF scripts.
>
> By up-loading BPF into a kernel the person loading it agrees to make
> that code available to all users of that system who can access it,
> under the same license as the kernel's code (or under a more
> permissive license).
>
> The last thing we want is people getting funny ideas and writing
> drivers in BPF and hiding the code or making license claims over it

all makes sense.
In case of kernel modules all export_symbols are accessible and module
has to have kernel compatible license. Same licensing terms apply to
anything else that interacts with kernel functions.
In case of BPF the list of accessible functions is tiny, so it's much
easier to enforce specific limited use case.
For tracing filters it's just bpf_load_xx/trace_printk/dump_stack.
Even if someone has funny ideas they cannot be brought to life, since
drivers need a lot more than this set of functions and BPF checker
will reject any attempts to call something outside of this tiny list.
imo the same applies to existing BPF as well. Meaning that tcpdump
filter string and seccomp filters, if distributed, has to have their
source code available.

> I.e. we want to allow flexible plugins technologically, but make sure
> people who run into such a plugin can modify and improve it under the
> same license as they can modify and improve the kernel itself!

wow. I guess if the whole thing takes off, we would need an in-kernel
directory to store upstreamed bpf filters as well :)

>> opcode encoding is the same between old BPF and extended BPF.
>> Original BPF has two 32-bit registers.
>> Extended BPF has ten 64-bit registers.
>> That is the main difference.
>>
>> Old BPF was using jt/jf fields for jump-insn only.
>> New BPF combines them into generic 'off' field for jump and non-jump insns.
>> k==imm field has the same meaning.
>
> This only affects the internal JIT representation, not the BPF byte
> code, right?

that is the ebpf vs bpf code difference. JIT doesn't keep another
representation.
Just converts it to x86

>>  32 files changed, 3332 insertions(+), 24 deletions(-)
>
> Impressive!
>
> I'm wondering, will the new nftable code in works make use of the BPF
> JIT as well, or is that a separate implementation?

nft is much higher level state machine customized for specific nftable use case.
imo iptables/nftable rules can be compiled into extended bpf.
One needs to define bpf_context and set of functions to do packet
lookup via bpf_callbacks...
but let's do it one step at a a time.

Thanks
Alexei
