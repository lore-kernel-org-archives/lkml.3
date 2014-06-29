Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaF2GUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 02:20:05 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:46752 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaF2GUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 02:20:01 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrV-uUL=NJ5_XP90cMmxvVJ0PHxCb7f4L=TqGX9tB5Vi2Q@mail.gmail.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	<1403913966-4927-9-git-send-email-ast@plumgrid.com>
	<CALCETrV+uTamX2BShHsHnwTr4R7+MSQXX8bXe=2Xo1hbiSAipQ@mail.gmail.com>
	<CAMEtUuzq4ib6MFAsp_ZpBisRa=XFUgKkX7OwwrEoOfw7O1YXCQ@mail.gmail.com>
	<CALCETrV-uUL=NJ5_XP90cMmxvVJ0PHxCb7f4L=TqGX9tB5Vi2Q@mail.gmail.com>
Date: Sat, 28 Jun 2014 23:20:00 -0700
Message-ID: <CAMEtUuy_NZYsi3OB3TRfutHKaryzGSy6W4cdjzU-iJKkv75DKQ@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 08/14] bpf: add eBPF verifier
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

On Sat, Jun 28, 2014 at 6:58 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> These were great questions! I hope I answered them. If not, please
>> continue asking.
>
> I have plenty more questions, but here's one right now: does anything
> prevent programs from using pointers in comparisons, returning
> pointers, or otherwise figuring out the value of a pointer?  If so, I
> think it would be worthwhile to prevent that so that eBPF programs
> can't learn kernel addresses.

when we decide to let non-root users load such programs, yes.
Right now the goal is the opposite. Take a look at 'drop monitor' example.
It stores kernel addresses where packets were dropped into a map,
so that user space can read it. The goal of eBPF for tracing is to be able
to see all corners of the kernel without being able to crash it.
eBPF is a kernel module that cannot crash kernel or adversely affect
the execution. Though in the future I'd like to expand applicability and
let unprivileged users use them. In such cases exposing kernel
addresses will be prevented. It's easy to tweak verifier to prevent
comparison of pointers, storing pointers to a map or passing them into
a function. The verifier is already tracking all pointers. There ways to
leak them: store into map, pass to helper function, return from program,
compare to constant, obfuscate via arithmetic. Prevention by verifier
is trivial. Though not right now. User level security is a different topic.
If I try to solve both 'root user safety' and 'non-root security' it will
take ages to go anywhere. So this patch is root only. I'm deliberately
not addressing non-root security for now.
First step: root only, get kernel pieces in place, llvm upstream, perf
plus all other user level tools. Just this step will take months.
Then let's talk about non-root. I believe it will need minimal changes
to verifier and no syscall uapi changes, but even if I'm wrong and
new syscall would be needed, it's not a big deal. Adding things
gradually is way better than trying to solve everything at once.
