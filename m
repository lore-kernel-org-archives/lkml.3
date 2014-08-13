Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbaHMVCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 17:02:53 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:52462 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaHMVCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 17:02:52 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXfp+7FmEzAoLiqzqY73NBzt8JsD40hzvhT3=gr-Scp=g@mail.gmail.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
	<1407916658-8731-2-git-send-email-ast@plumgrid.com>
	<CALCETrXzZVxMGUgDPOKwN0DPLvupU=ew1z6D4U-jHg+RoyZyLg@mail.gmail.com>
	<CAMEtUuxog0w-XkYMHM=Zto_gejy8x5agxohAWOs1zPEtXTr0Sw@mail.gmail.com>
	<CALCETrXfp+7FmEzAoLiqzqY73NBzt8JsD40hzvhT3=gr-Scp=g@mail.gmail.com>
Date: Wed, 13 Aug 2014 14:02:50 -0700
Message-ID: <CAMEtUuwx6Y4qxyz4TGK9=M2BH-dXnPsm+JrusqbyjzK20yUv6A@mail.gmail.com>
Subject: Re: [PATCH RFC v4 net-next 01/26] net: filter: add "load 64-bit
 immediate" eBPF instruction
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
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

On Wed, Aug 13, 2014 at 11:35 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> The compiler can still think of it as a single insn, though, but some
> future compiler might not.

I think that would be very dangerous.
compiler (user space) and kernel interpreter must have the same
understanding of ISA.

> In any case, I think that, if you use the
> same code for high and for low, you need logic in the JIT that's at
> least as complicated.

why do you think so? Handling of pseudo BPF_LD_IMM64 is done
in single patch #11 which is one of the smallest...

> For example, what happens if you have two
> consecutive 64-bit immediate loads to the same register?  Now you have
> four consecutive 8-byte insn words that differ only in their immediate
> values, and you need to split them correctly.

I don't need to do anything special in this case.
Two 16-byte instructions back to back is not a problem.
Interpreter or JIT don't care whether they move the same or different
immediates into the same or different register. Interpreter and JITs
are dumb on purpose.
when verifier sees two back to back ld_imm64, the 2nd will simply
override the value loaded by first one. It's not any different than
two back to back 'mov dst_reg, imm32' instructions.
