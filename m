Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab3LCUls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:41:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897Ab3LCUlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:41:46 -0500
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH tip 3/5] Extended BPF (64-bit BPF) design document
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<1386044930-15149-4-git-send-email-ast@plumgrid.com>
	<529E0E69.90009@zytor.com>
	<CAMEtUuxENa69dMdhmZg=tSJ_mWaYAy_JqBF2NXxkqbaAxawFkw@mail.gmail.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 03 Dec 2013 15:41:28 -0500
In-Reply-To: <CAMEtUuxENa69dMdhmZg=tSJ_mWaYAy_JqBF2NXxkqbaAxawFkw@mail.gmail.com> (Alexei Starovoitov's message of "Tue, 3 Dec 2013 11:59:53 -0800")
Message-ID: <y0mpppdr7k7.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alexei Starovoitov <ast@plumgrid.com> writes:

> [...]
>> Having EBPF code manipulating pointers - or kernel memory - directly
>> seems like a nonstarter.  However, per your subsequent paragraph it
>> sounds like pointers are a special type at which point it shouldn't
>> matter at the EBPF level how many bytes it takes to represent it?
>
> bpf_check() will track every register through every insn.
> If pointer is stored in the register, it will know what type
> of pointer it is and will allow '*reg' operation only if pointer is valid.
> [...]
> BPF program actually can manipulate kernel memory directly
> when checker guarantees that it is safe to do so :)

It sounds like this sort of static analysis would have difficulty with
situations such as:

- multiple levels of indirection

- conditionals (where it can't trace a unique data/type flow for all pointers)

- aliasing (same reason)

- the possibility of bad (or userspace?) pointers arriving as
  parameters from the underlying trace events
  

> For example in tracing filters bpf_context access is restricted to:
> static const struct bpf_context_access ctx_access[MAX_CTX_OFF] = {
>         [offsetof(struct bpf_context, regs.di)] = {
>                 FIELD_SIZEOF(struct bpf_context, regs.di),
>                 BPF_READ
>         },

Are such constraints to be hard-coded in the kernel?


> Over course of development bpf_check() found several compiler bugs.
> I also tried all of sorts of ways to break bpf jail from inside of a
> bpf program, but so far checker catches everything I was able to throw
> at it.

(One can be sure that attackers will chew hard on this interface,
should it become reasonably accessible to userspace, so good job
starting to check carefully!)


- FChE
