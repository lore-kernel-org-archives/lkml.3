Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab3LDRg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:36:27 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44109 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3LDRgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:36:24 -0500
MIME-Version: 1.0
In-Reply-To: <20131204093417.GC32531@gmail.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<20131203091655.GB20179@gmail.com>
	<CAMEtUuziP0zVe63HSxF0uVs1pnP--1HBs1-WsR2xfLOTyBaHSQ@mail.gmail.com>
	<20131204093417.GC32531@gmail.com>
Date: Wed, 4 Dec 2013 09:36:23 -0800
Message-ID: <CAMEtUuwMGwQEtX4p1RyNTSZBA_9j-XQ4aEtM7L5hrqPkS2szfw@mail.gmail.com>
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
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 1:34 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Alexei Starovoitov <ast@plumgrid.com> wrote:
>
>> On Tue, Dec 3, 2013 at 1:16 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> >
>> > Very cool! (Added various other folks who might be interested in
>> > this to the Cc: list.)
>> >
>> > I have one generic concern:
>> >
>> > It would be important to make it easy to extract loaded BPF code
>> > from the kernel in source code equivalent form, which compiles to
>> > the same BPF code.
>> >
>> > I.e. I think it would be fundamentally important to make sure that
>> > this is all within the kernel's license domain, to make it very
>> > clear there can be no 'binary only' BPF scripts.
>> >
>> > By up-loading BPF into a kernel the person loading it agrees to
>> > make that code available to all users of that system who can
>> > access it, under the same license as the kernel's code (or under a
>> > more permissive license).
>> >
>> > The last thing we want is people getting funny ideas and writing
>> > drivers in BPF and hiding the code or making license claims over
>> > it
>>
>> all makes sense. In case of kernel modules all export_symbols are
>> accessible and module has to have kernel compatible license. Same
>> licensing terms apply to anything else that interacts with kernel
>> functions. In case of BPF the list of accessible functions is tiny,
>> so it's much easier to enforce specific limited use case. For
>> tracing filters it's just bpf_load_xx/trace_printk/dump_stack. Even
>> if someone has funny ideas they cannot be brought to life, since
>> drivers need a lot more than this set of functions and BPF checker
>> will reject any attempts to call something outside of this tiny
>> list. imo the same applies to existing BPF as well. Meaning that
>> tcpdump filter string and seccomp filters, if distributed, has to
>> have their source code available.
>
> I mean more than that, I mean the licensing of BFP filters a user can
> find on his own system's kernel should be very clear: by the act of
> loading a BFP script into the kernel the user doing the 'upload' gives
> permission for it to be redistributed on kernel-compatible license
> terms.
>
> The easiest way to achieve that is to make sure that all loaded BFP
> scripts are 'registered' and are dumpable, viewable and reusable.
> That's good for debugging and it's good for transparency.
>
> This means a minimal BFP decoder will have to be in the kernel as
> well, but that's OK, we actually have several x86 instruction decoder
> in the kernel already, so there's no complexity threshold.

sure. there is pr_info_bpf_insn() in bpf_run.c that dumps bpf insn in
human readable format.
I'll hook it up to trace_seq, so that "cat
/sys/kernel/debug/.../filter" will dump it.

Also I'm thinking to add 'license_string' section to bpf binary format
and call license_is_gpl_compatible() on it during load.
If false, then just reject it…. not even messing with taint flags...
That would be way stronger indication of bpf licensing terms than what
we have for .ko

>> wow. I guess if the whole thing takes off, we would need an
>> in-kernel directory to store upstreamed bpf filters as well :)
>
> I see no reason why not, but more importantly all currently loaded BFP
> scripts should be dumpable, displayable and reusable in a kernel
> license compatible fashion.

ok. will add global bpf list as well (was hesitating to do something
like this because of central lock)
and something in debugfs that dumps bodies of all currently loaded filters.

Will that solve the concern?

Thanks
Alexei
