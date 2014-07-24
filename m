Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934460AbaGXTZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 15:25:06 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:56481 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705AbaGXTZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 15:25:04 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrUt1yLXTt5pDZJd0s4s+4dhs0LB7tbJYd6p1+EbdNWw7w@mail.gmail.com>
References: <1405657206-12060-1-git-send-email-ast@plumgrid.com>
	<1405657206-12060-11-git-send-email-ast@plumgrid.com>
	<CALCETrUt1yLXTt5pDZJd0s4s+4dhs0LB7tbJYd6p1+EbdNWw7w@mail.gmail.com>
Date: Thu, 24 Jul 2014 12:25:02 -0700
Message-ID: <CAMEtUuygJoH+PBNksTwRHyRObCZixoTDFzmnHroErZHZLaGNbg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 10/16] bpf: add eBPF verifier
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andy Lutomirski <luto@amacapital.net>
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

On Thu, Jul 24, 2014 at 11:25 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Jul 17, 2014 at 9:20 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>> Safety of eBPF programs is statically determined by the verifier, which detects:
>> - loops
>> - out of range jumps
>> - unreachable instructions
>> - invalid instructions
>> - uninitialized register access
>> - uninitialized stack access
>> - misaligned stack access
>> - out of range stack access
>> - invalid calling convention
>
> Is there something that documents exactly what conditions an eBPF
> program must satisfy in order to be considered valid?

I did a writeup in the past on things that verifiers checks and gave it
to internal folks to review. Guys have said that now they understand very
well how it works, but in reality it didn't help at all to write valid programs.
What worked is 'verification trace' = the instruction by instruction dump
of verifier state while it's analyzing the program.
I gave few simple examples of it in
'Understanding eBPF verifier messages' section:
https://git.kernel.org/cgit/linux/kernel/git/ast/bpf.git/diff/Documentation/networking/filter.txt?id=b22459133b9f52d2176c8c0f8b5eb036478a40c9
Every example there is what "program must satisfy to be valid"...

Therefore I'm addressing two things:
1. how verifier works and what it checks for.
  that is described in 'eBPF verifier' section of the doc and
  in 200 lines of comments inside verifier.c
2. how to write valid programs
 that's more important one, since it's a key to happy users.
 'verification trace' is the first step. I'm planning to add debug info and
 user space tool that points out to line in C instead of assembler trace.
 In other words to bring errors to user as early as possible during
 compilation process.
 This is not a concern when programs are written in assembler,
 since the programs will be much shorter and thought through by
 the author. However I don't think there will be too many users
 willing to understand ebpf assembler.

I suspect you're more concerned about #1 at this point whereas
I'm concerned about #2.
