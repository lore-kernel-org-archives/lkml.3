Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaF1H0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 03:26:19 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46272 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaF1H0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 03:26:16 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXQ60J+UqafHRKPbgQ37zhstW+E8xAponWs7AQ-DCgaWA@mail.gmail.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	<1403913966-4927-8-git-send-email-ast@plumgrid.com>
	<CALCETrXDR1LVmbigTicBiddgvcucM1dGk1R7rxdJyBCvGEBQMw@mail.gmail.com>
	<CAMEtUuywNHVcZ__296NzXK7RPXUBOf7gNQY9JFx0a9PV0Se+wA@mail.gmail.com>
	<CALCETrXQ60J+UqafHRKPbgQ37zhstW+E8xAponWs7AQ-DCgaWA@mail.gmail.com>
Date: Sat, 28 Jun 2014 00:26:14 -0700
Message-ID: <CAMEtUuwmxgrGMigmh1vZ7qCh9qB9ph9uFbPmVmmbqZvC5N9WyA@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 07/14] bpf: expand BPF syscall with program load/unload
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

On Fri, Jun 27, 2014 at 11:28 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Jun 27, 2014 at 11:12 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>> On Fri, Jun 27, 2014 at 5:19 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Fri, Jun 27, 2014 at 5:05 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>>>> eBPF programs are safe run-to-completion functions with load/unload
>>>> methods from userspace similar to kernel modules.
>>>>
>>>> User space API:
>>>>
>>>> - load eBPF program
>>>>   prog_id = bpf_prog_load(int prog_id, bpf_prog_type, struct nlattr *prog, int len)
>>>>
>>>>   where 'prog' is a sequence of sections (currently TEXT and LICENSE)
>>>>   TEXT - array of eBPF instructions
>>>>   LICENSE - GPL compatible
>>>> +
>>>> +       err = -EINVAL;
>>>> +       /* look for mandatory license string */
>>>> +       if (!tb[BPF_PROG_LICENSE])
>>>> +               goto free_attr;
>>>> +
>>>> +       /* eBPF programs must be GPL compatible */
>>>> +       if (!license_is_gpl_compatible(nla_data(tb[BPF_PROG_LICENSE])))
>>>> +               goto free_attr;
>>>
>>> Seriously?  My mind boggles.
>>
>> Yes. Quite a bit of logic can fit into one eBPF program. I don't think it's wise
>> to leave this door open for abuse. This check makes it clear that if you
>> write a program in C, the source code must be available.
>> If program is written in assembler than this check is nop anyway.
>>
>
> I can see this seriously annoying lots of users.  For example,
> Chromium might object.

chrome/seccomp generated programs are an exception. They
really don't have a source code. Quite large classic BPF programs
are generated out of decision tree driven by seccomp library. Here we
obviously cannot say that such bpf generating library must be GPLed.
Just like LLVM that emits eBPF code is not under GPL.
So chrome should be fine generating eBPF as well.

> If you want to add GPL-only functions in the future, that would be one
> thing.  But if someone writes a nice eBPF compiler, and someone else
> writes a little program that filters on network packets, I see no
> reason to claim that the little program is a derivative work of the
> kernel and therefore must be GPL.

I think we have to draw a line somewhere. Say, tomorrow I want
to modify libpcap to emit eBPF based on existing tcpdump syntax.
Would it mean that tcpdump filter strings are GPLed? Definitely not,
since they existed before and can function without new libpcap.
But if I write a new packet filtering program in C, compile it
using LLVM->eBPF and call into in-kernel helper functions
(like bpf_map_lookup_elem()),  I think it's exactly the derivative work.
It's analogous to kernel modules. If module wants to call
export_symbol_gpl() functions, it needs to be GPLed. Here all helper
functions are GPL. So we just have a blank check for eBPF program.
Having said that I can relax it a little by adding 'export_symbol(_gpl)?'
equivalent markings to all helper function. Then eBPF program that
doesn't call any functions at all, can run under non-free license.
But before I do that, I'd like hear others.
