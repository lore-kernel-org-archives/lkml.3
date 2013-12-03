Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab3LCVbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:31:06 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:64309 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab3LCVbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:31:03 -0500
MIME-Version: 1.0
In-Reply-To: <y0mpppdr7k7.fsf@fche.csb>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<1386044930-15149-4-git-send-email-ast@plumgrid.com>
	<529E0E69.90009@zytor.com>
	<CAMEtUuxENa69dMdhmZg=tSJ_mWaYAy_JqBF2NXxkqbaAxawFkw@mail.gmail.com>
	<y0mpppdr7k7.fsf@fche.csb>
Date: Tue, 3 Dec 2013 13:31:00 -0800
Message-ID: <CAMEtUuxvBP+HXpfUk41VkMOO6e__igmQqQUKpR28C1Us9E8LjQ@mail.gmail.com>
Subject: Re: [RFC PATCH tip 3/5] Extended BPF (64-bit BPF) design document
From: Alexei Starovoitov <ast@plumgrid.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 12:41 PM, Frank Ch. Eigler <fche@redhat.com> wrote:
>
> Alexei Starovoitov <ast@plumgrid.com> writes:
>
>> [...]
>>> Having EBPF code manipulating pointers - or kernel memory - directly
>>> seems like a nonstarter.  However, per your subsequent paragraph it
>>> sounds like pointers are a special type at which point it shouldn't
>>> matter at the EBPF level how many bytes it takes to represent it?
>>
>> bpf_check() will track every register through every insn.
>> If pointer is stored in the register, it will know what type
>> of pointer it is and will allow '*reg' operation only if pointer is valid.
>> [...]
>> BPF program actually can manipulate kernel memory directly
>> when checker guarantees that it is safe to do so :)
>
> It sounds like this sort of static analysis would have difficulty with
> situations such as:

yes. good points.
it's a simple analysis to have minimal # of lines in the kernel
with the goal to cover the cases where performance matters.
but the cases you mentioned are supported by bpf_load_pointer() in
bpf_trace_callbacks.c

> - multiple levels of indirection

in tools/bpf/trace/filter_ex1_orig.c
when filter reads first argument of event it assumes it got 'skb' pointer.
If it just type casts it and does 'skb->dev', this memory load will be
rejected by bpf_check().
Instead it does bpf_load_pointer() which will bring the value if the
pointer is not faulting.
It may be reading junk and subsequent bpf_memcmp(dev->name, "name")
may be reading
something even more bogus.
But it won't crash the kernel and if filter applied to the correct
event, the 'skb' pointer will be indeed 'struct sk_buff' and 'dev'
will indeed be pointing to 'struct net_device' and 'dev->name' will be
actual name.
It's possible to make first level of indirection faster by making
static analyzer more complex,
but imo it's not worth it for one level.
It's possible to teach it for multi-level, but then analyzer will
become too large and won't be suitable for kernel.

> - conditionals (where it can't trace a unique data/type flow for all pointers)

Some conditionals where performance matter are supported.
Like bpf_table_lookup() returns either valid pointer to table element or null.
and bpf_check assigns pointer type as 'ptr_to_table_conditional' until
bpf program does 'reg != null' and in the true branch the register
changes type to 'ptr_to_table', so that bpf program can access table
element for both read and write. See filter_ex2_orig.c
There 'leaf->packet_cnt' is a direct memory load from pointer that
points to table element.

> - aliasing (same reason)

not sure what you mean here.

> - the possibility of bad (or userspace?) pointers arriving as
>   parameters from the underlying trace events

solved same way as case #1

>> For example in tracing filters bpf_context access is restricted to:
>> static const struct bpf_context_access ctx_access[MAX_CTX_OFF] = {
>>         [offsetof(struct bpf_context, regs.di)] = {
>>                 FIELD_SIZEOF(struct bpf_context, regs.di),
>>                 BPF_READ
>>         },
>
> Are such constraints to be hard-coded in the kernel?

I'm hoping that BPF framework will be used by different kernel subsystems.
In case of trace filters 'bpf_context' will be defined once and
hard-coded within kernel.
So all tracing filters will have the same input interface.
For other subsystems bpf_context may mean something different with its
own access rights.
So bpf filters that load fine as tracing filters will be rejected when
loaded into other bpf subsystem.
Theoretically subsystem may define bpf_context dynamically. Like its
own bpf_context for every trace event, but that's an overkill.

>> Over course of development bpf_check() found several compiler bugs.
>> I also tried all of sorts of ways to break bpf jail from inside of a
>> bpf program, but so far checker catches everything I was able to throw
>> at it.
>
> (One can be sure that attackers will chew hard on this interface,
> should it become reasonably accessible to userspace, so good job
> starting to check carefully!)

I think for quite some time root privileges would be needed to load
these filters,
but eventually would be useful to let non-root users to insert them as well.

Thank you for feedback!

Regards,
Alexei
