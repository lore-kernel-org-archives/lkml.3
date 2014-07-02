Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaGBXEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 19:04:11 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36489 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaGBXEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 19:04:08 -0400
MIME-Version: 1.0
In-Reply-To: <CA+ZOOTODDPN=6SECq1uPPD7AGP1zgBJ+bfYaX9o3YhnaCTiHYQ@mail.gmail.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	<1403913966-4927-9-git-send-email-ast@plumgrid.com>
	<CA+ZOOTODDPN=6SECq1uPPD7AGP1zgBJ+bfYaX9o3YhnaCTiHYQ@mail.gmail.com>
Date: Wed, 2 Jul 2014 16:04:05 -0700
Message-ID: <CAMEtUuxfrAUDDQVGNsNV2PeDii-6LAwQCbB2XGEHTJDwkkvyWg@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 08/14] bpf: add eBPF verifier
From: Alexei Starovoitov <ast@plumgrid.com>
To: Chema Gonzalez <chema@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 3:22 PM, Chema Gonzalez <chema@google.com> wrote:
>> + * - unreachable insns exist (shouldn't be a forest. program = one function)
> This seems to me an unnecessary style restriction on user code.

unreachable instructions to me is a ticking time bomb of potential exploits.
Definitely should be rejected.

>> +#define _(OP) ({ int ret = OP; if (ret < 0) return ret; })
> +1 to removing the _ macro. If you want to avoid the 3 lines (is there
> anything in the style guide against "if ((err=OP) < 0) ..." ?), at

assignment and function call inside 'if' ? I don't like such style.

> least use some meaningful macro name (DO_AND_CHECK, or something like
> that).

Try replacing _ with any other name and see how bad it will look.
I tried with MACRO_NAME and with 'if (err) goto' and with 'if (err) return',
before I converged on _ macro.
I think it's a hidden gem of this patch.

> Can you please add:
>
> + } else if (class == BPF_LD) {
> +   if (BPF_MODE(insn->code) == BPF_ABS) {
> +     pr_cont("(%02x) r0 = *(%s *)skb[%d]\n",
> +       insn->code,
> +       bpf_ldst_string[BPF_SIZE(insn->code) >> 3],
> +       insn->imm);
> +   } else if (BPF_MODE(insn->code) == BPF_IND) {
> +     pr_cont("(%02x) r0 = *(%s *)skb[r%d + %d]\n",
> +       insn->code,
> +       bpf_ldst_string[BPF_SIZE(insn->code) >> 3],
> +       insn->src_reg, insn->imm);
> +   } else {
> +     pr_cont("BUG_ld_%02x\n", insn->code);
> +     return;
> +   }
>
> Note that I'm hardcoding r0 (instead of using %d for insn->dst_reg)
> because that's how ebpf writes the instructions.

ohh yes. it's a copy paste error, since it was in a different file before.
Will definitely add. Thanks!

>> +static void init_reg_state(struct reg_state *regs)
>> +{
>> +       struct reg_state *reg;
>> +       int i;
>> +
>> +       for (i = 0; i < MAX_BPF_REG; i++) {
>> +               regs[i].ptr = INVALID_PTR;
>> +               regs[i].read_ok = false;
>> +               regs[i].imm = 0xbadbad;
>> +       }
>> +       reg = regs + BPF_REG_FP;
> Any reason you switching from the array syntax to the pointer one? I
> find "reg = regs[BPF_REG_FP];" more readable (and the one you chose in
> the loop).

in this function no particular reason. It felt a bit less verbose, but
I can make
the change.

>> +       reg = regs + BPF_REG_1; /* 1st arg to a function */
>> +       reg->ptr = PTR_TO_CTX;
> Wait, doesn't this depend on doing "BPF_MOV64_REG(BPF_REG_CTX,
> BPF_REG_ARG1)" (the bpf-to-ebpf prologue), which is only enforced on
> filters converted from bpf? In fact, shouldn't this set
> regs[BPF_REG_CTX] instead of regs[BPF_REG_1] ?

nope. it's REG_1.
as you said r6=r1 is only emitted by converted classic filters.
Verifier will see this 'r6=r1' assignment and will copy the r1 type into r6.

Thank you for review!
