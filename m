Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaGBWna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 18:43:30 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:61266 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaGBWn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 18:43:27 -0400
MIME-Version: 1.0
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1726B207@AcuExch.aculab.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	<1403913966-4927-9-git-send-email-ast@plumgrid.com>
	<53B26BB0.90209@redhat.com>
	<CAMEtUuyc3+jrxG4r4=fk=Gc9OMhO8a2X1oyWPx1LsKzewVf01w@mail.gmail.com>
	<063D6719AE5E284EB5DD2968C1650D6D1726B207@AcuExch.aculab.com>
Date: Wed, 2 Jul 2014 15:43:26 -0700
Message-ID: <CAMEtUuwNL2ngOfMA7HMc6agRnSwYMTkvEqxoy_AFwDVnb-o_Ug@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 08/14] bpf: add eBPF verifier
From: Alexei Starovoitov <ast@plumgrid.com>
To: David Laight <David.Laight@aculab.com>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
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

On Wed, Jul 2, 2014 at 1:11 AM, David Laight <David.Laight@aculab.com> wrote:
> From: Alexei Starovoitov
> ...
>> >> +#define _(OP) ({ int ret = OP; if (ret < 0) return ret; })
> ...
>> >> +       _(get_map_info(env, map_id, &map));
>> >
>> > Nit: such macros should be removed, please.
>>
>> It may surely look unconventional, but alternative is to replace
>> every usage of _ macro with:
>> err =
>> if (err)
>>   return err;
>>
>> and since this macro is used 38 times, it will add ~120 unnecessary
>> lines that will only make code much harder to follow.
>> I tried not using macro and results were not pleasing.
>
> The problem is that they are hidden control flow.
> As such they make flow analysis harder for the casual reader.

In the abstract context macros with gotos and returns are bad,
but in this case extra verbosity is the bigger evil.

Consider this piece of code:
#define _(OP) ({ int ret = OP; if (ret < 0) return ret; })

if (opcode == BPF_END || opcode == BPF_NEG) {
    if (BPF_SRC(insn->code) != BPF_X)
        return -EINVAL;

    /* check src operand */
     _(check_reg_arg(regs, insn->dst_reg, 1));

    /* check dest operand */
    _(check_reg_arg(regs, insn->dst_reg, 0));

} else if (opcode == BPF_MOV) {

    if (BPF_SRC(insn->code) == BPF_X)
        /* check src operand */
        _(check_reg_arg(regs, insn->src_reg, 1));

    /* check dest operand */
    _(check_reg_arg(regs, insn->dst_reg, 0));

where casual reader can easily see what the purpose of the code
and what it's doing.

Now rewrite it without '_' macro:
if (opcode == BPF_END || opcode == BPF_NEG) {
    if (BPF_SRC(insn->code) != BPF_X)
            return -EINVAL;

    /* check src operand */
    err = check_reg_arg(regs, insn->dst_reg, 1);
    if (err)
        return err;

    /* check dest operand */
    err = check_reg_arg(regs, insn->dst_reg, 0);
    if (err)
        return err;

} else if (opcode == BPF_MOV) {

    if (BPF_SRC(insn->code) == BPF_X) {
        /* check src operand */
        err = check_reg_arg(regs, insn->src_reg, 1);
        if (err)
            return err;
    }

    /* check dest operand */
    err = check_reg_arg(regs, insn->dst_reg, 0);
    if (err)
        return err;

see how your eyes are now picking up endless control flow of
if conditions and returns, instead of focusing on the code itself.
It's much easier to understand the semantics when if (err) is out
of the way. Note that replacing _ with real name will ruin
the reading experience, since CAPITAL letters of the macro
will be screaming: "look at me", instead of letting reviewer
focus on the code.

I believe that this usage of _ as a macro specifically as defined,
would be a great addition to kernel coding style in general.
I don't want to see _ to be redefined differently.
