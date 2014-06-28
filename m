Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbaF1QBb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 12:01:31 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:51642 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaF1QB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 12:01:28 -0400
MIME-Version: 1.0
In-Reply-To: <1403913966-4927-9-git-send-email-ast@plumgrid.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com> <1403913966-4927-9-git-send-email-ast@plumgrid.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 28 Jun 2014 09:01:06 -0700
Message-ID: <CALCETrV+uTamX2BShHsHnwTr4R7+MSQXX8bXe=2Xo1hbiSAipQ@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 08/14] bpf: add eBPF verifier
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 5:06 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> Safety of eBPF programs is statically determined by the verifier, which detects:

This is a very high-level review.  I haven't tried to read all the
code yet, and this is mostly questions rather than real comments.

> - loops
> - out of range jumps
> - unreachable instructions
> - invalid instructions
> - uninitialized register access
> - uninitialized stack access
> - misaligned stack access
> - out of range stack access
> - invalid calling convention
>
> It checks that
> - R1-R5 registers statisfy function prototype
> - program terminates
> - BPF_LD_ABS|IND instructions are only used in socket filters

Why are these used in socket filters?  Can't ctx along with some
accessor do the trick.


It seems to be that this is more or less a type system.  On entry to
each instruction, each register has a type, and the instruction might
change the types of the registers.

So: what are the rules?  If I understand correctly, these are the types:

> +       INVALID_PTR,                    /* reg doesn't contain a valid pointer */
> +       PTR_TO_CTX,                     /* reg points to bpf_context */
> +       PTR_TO_MAP,                     /* reg points to map element value */
> +       PTR_TO_MAP_CONDITIONAL,         /* points to map element value or NULL */
> +       PTR_TO_STACK,                   /* reg == frame_pointer */
> +       PTR_TO_STACK_IMM,               /* reg == frame_pointer + imm */
> +       PTR_TO_STACK_IMM_MAP_KEY,       /* pointer to stack used as map key */
> +       PTR_TO_STACK_IMM_MAP_VALUE,     /* pointer to stack used as map elem */
> +       RET_INTEGER,                    /* function returns integer */
> +       RET_VOID,                       /* function returns void */
> +       CONST_ARG,                      /* function expects integer constant argument */
> +       CONST_ARG_MAP_ID,               /* int const argument that is used as map_id */
> +       /* int const argument indicating number of bytes accessed from stack
> +        * previous function argument must be ptr_to_stack_imm
> +        */
> +       CONST_ARG_STACK_IMM_SIZE,
> +};

One confusing thing here is that some of these are types and some are
constraints.  I'm not sure this is necessary.  For example, RET_VOID
is an odd name for VOID, and RET_INTEGER is an odd name for INTEGER.

I think I'd have a much easier time understanding all of this if there
were an explicit table for the transition rules.  There are a couple
kinds of transitions.  The main one is kind of like a phi node: when
two different control paths reach the same instruction, the types of
each register presumably need to merge.  I would imagine rules like:

VOID, anything -> VOID
PTR_TO_MAP, PTR_TO_MAP_CONDITIONAL -> PTR_TO_MAP_CONDITIONAL

Then there are arithmetic rules: if you try to add two values, it
might be legal or illegal, and the result type needs to be known.

There are also things that happen on function entry and exit.  For
example, unused argument slots presumably all turn into VOID.  All
calls into the same function will apply the merge rule to the used
argument types.  Passing stack pointers into a function might be okay,
but passing stack pointers back out should presumably turn them into
VOID.

Am I understanding this right so far?

The next question is: what are the funny types for?

PTR_TO_MAP seems odd.  Shouldn't that just be PTR_TO_MEM?  And for these:

> +       PTR_TO_STACK_IMM_MAP_KEY,       /* pointer to stack used as map key */
> +       PTR_TO_STACK_IMM_MAP_VALUE,     /* pointer to stack used as map elem */

I don't understand at all.


Next question: how does bounds checking work?  Are you separately
tracking the offset and associated bounds of each pointer?  How does
bounds checking on PTR_TO_MAP work?  How about PTR_TO_STACK?  For that
matter, why would pointer arithmetic on the stack be needed at all?
ISTM it would be easier to have instructions to load and store a given
local stack slot.  I guess that stack slots from callers are useful,
too, but that seems *much* more complicated to track.

--Andy
