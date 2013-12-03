Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3LCUAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:00:30 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:52971 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab3LCT7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:59:55 -0500
MIME-Version: 1.0
In-Reply-To: <529E0E69.90009@zytor.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<1386044930-15149-4-git-send-email-ast@plumgrid.com>
	<529E0E69.90009@zytor.com>
Date: Tue, 3 Dec 2013 11:59:53 -0800
Message-ID: <CAMEtUuxENa69dMdhmZg=tSJ_mWaYAy_JqBF2NXxkqbaAxawFkw@mail.gmail.com>
Subject: Re: [RFC PATCH tip 3/5] Extended BPF (64-bit BPF) design document
From: Alexei Starovoitov <ast@plumgrid.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
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

On Tue, Dec 3, 2013 at 9:01 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/02/2013 08:28 PM, Alexei Starovoitov wrote:
>> +
>> +All BPF registers are 64-bit without subregs, which makes JITed x86 code
>> +less optimal, but matches sparc/mips architectures.
>> +Adding 32-bit subregs was considered, since JIT can map them to x86 and aarch64
>> +nicely, but read-modify-write overhead for sparc/mips is not worth the gains.
>> +
>
> I find this tradeoff to be more than somewhat puzzling, given that x86
> and ARM are by far the dominant tradeoffs, and it would make
> implementation on 32-bit CPUs cheaper if a lot of the operations are 32 bit.
>
> Instead it seems like the niche architectures (which, realistically,
> SPARC and MIPS have become) ought to take the performance hit.
>
> Perhaps you are simply misunderstanding the notion of subregisters.
> Neither x86 nor ARM64 leave the top 32 bits intact, so I don't see why
> SPARC/MIPS would do RMW either.

32-bit reg write access on x86-64 is of course zero-extended. 16 and 8
bit are not.
If BPF isa to allow 32-bit subregs, it would need to allow int args to
be passed in them
as well. I'm not sure yet that arm64 calling convention will match
x86-64 in that sense.
>From compiler point of view if arg has int32 type and lives in 32-bit
subreg on 64-bit cpu,
the compiler has to access it with 32-bit subreg ops only. It cannot
assume that it was zero extended by caller. So all ops on sparc/mips
would have to use extra registers and do 64->32 masks.
Also 32-bit subreg doesn't help to look at int variables. In both
cases it will be 32-bit load
then with subregs cmp eax and without it cmp rax after jit.
To increment atomic 32-bit counter in memory, they don't help either.
They just don't give enough performance boost to justify complexity in encoding,
analyzing and JITing. So I don't see a viable benefit of 32-bit subregs yet.

The above arguments apply to 64-bit CPUs with 64-bit registers with or
without 32-bit subregs.

If you're talking about 32-bit CPUs it's completely different matter.
If we want to support JIT on them we need 32-bit bpf isa
(proposed BPF isa is 64-bit with no effort to make it JITable on 32-bit cpus)
Which can reuse all of the same encoding and make all registers 32-bit.
Compiler will produce different bpf code though.
It would know that it cannot load 64-bit value in one insn and will
use register pairs and so on.
Like -m32 / -m64 switch for bpf backend.
Letting compiler generate 64-bit BPF isa and then try to JIT it to
32-bit cpu is feasible, but very painful. Such JIT will be too large
to include in kernel.
Proposed JIT is short and simple because it maps all registers and
instructions one to one.

So the big question, do we really care about lack of bpf jit on 32-bit cpus?
Considering that ebpf still works on them, but via interpreter (see
bpf_run.c)...
imo that is the same situation as we have today with old bpf.

>> +Q: Why extended BPF is 64-bit? Cannot we live with 32-bit?
>> +A: On 64-bit architectures, pointers are 64-bit and we want to pass 64-bit
>> +values in/out kernel functions, so 32-bit BPF registers would require to define
>> +register-pair ABI, there won't be a direct BPF register to HW register
>> +mapping and JIT would need to do combine/split/move operations for every
>> +register in and out of the function, which is complex, bug prone and slow.
>> +Another reason is counters. To use 64-bit counter BPF program would need to do
>> +a complex math. Again bug prone and not atomic.
>
> Having EBPF code manipulating pointers - or kernel memory - directly
> seems like a nonstarter.  However, per your subsequent paragraph it
> sounds like pointers are a special type at which point it shouldn't
> matter at the EBPF level how many bytes it takes to represent it?

bpf_check() will track every register through every insn.
If pointer is stored in the register, it will know what type
of pointer it is and will allow '*reg' operation only if pointer is valid.
For example, upon entry into bpf program, register R1 will have type ptr_to_ctx.
After JITing it means that 'rdi' has a valid pointer and it points to
'struct bpf_context'.
If bpf code has R1 = R1 + 1 insn, the checker will assign invalid_ptr type to R1
after this insn and memory access via R1 will be rejected by checker.

BPF program actually can manipulate kernel memory directly
when checker guarantees that it is safe to do so :)

For example in tracing filters bpf_context access is restricted to:
static const struct bpf_context_access ctx_access[MAX_CTX_OFF] = {
        [offsetof(struct bpf_context, regs.di)] = {
                FIELD_SIZEOF(struct bpf_context, regs.di),
                BPF_READ
        },

meaning that bpf program can only do 8-byte load from 'rdi + 112'
when rdi still has type ptr_to_ctx. (112 is offset of 'di' field
within bpf_context)

Direct access making it so efficient and fast. After JITing bpf
program is pretty to close to natively compiled code. C->bpf->x86 is
quite close to C->x86. (talking about x86_64 of course)

Over course of development bpf_check() found several compiler bugs.
I also tried all of sorts of ways to break bpf jail from inside of a
bpf program, but so far checker catches everything I was able to throw
at it.

btw, tools/bpf/trace/trace_filter_check.c is a user space program that
links kernel/bpf_jit/bpf_check.o to make it easier to debug/understand
how bpf_check() is working.
It's there to do the same check as kernel will do while loading, but
doing it in userspace.
So it's faster to get an answer whether bpf filter is safe or not.
Examples are in the same tools/bpf/trace/ dir.

Thank you so much for review! Really appreciate the feedback.

Regards,
Alexei
